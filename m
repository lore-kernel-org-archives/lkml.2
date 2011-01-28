Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab1A1Ftd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 00:49:33 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58007 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab1A1Ftc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 00:49:32 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4D4259B0.6040902@np.css.fujitsu.com>
Date: Fri, 28 Jan 2011 14:52:48 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Andrea Arcangeli <aarcange@redhat.com>
CC: =?ISO-2022-JP?B?QUtQTRskQiEhGyhC?= <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: [PATCH -v2 1/3] Fix splitting poisoned THP.
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The poisoned THP is now split with split_huge_page()
in collect_procs_anon(). If kmalloc() is failed in collect_procs(),
split_huge_page() could not be called. And the work
after split_huge_page() for collecting the processes using
poisoned page will not be done, too. So the processes using
the poisoned page could not be killed.

The condition becomes worse when CONFIG_DEBUG_VM == "Y".
Because the poisoned THP could not be split, system panic will be
caused by VM_BUG_ON(PageTransHuge(page)) in try_to_unmap().

This patch does:
  1. move split_huge_page() to the place before collect_procs().
     This can be sure the failure of splitting THP is caused by itself.
  2. when splitting THP is failed, stop the operations after it.
     This can avoid unexpected system panic or non sense works.

-v2
   Make the description clearly.
   Add PageTransHuge() checking for THP before split_huge_page().

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 mm/memory-failure.c |   30 ++++++++++++++++++++++++++++--
 1 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 548fbd7..2fa5f94 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -386,8 +386,6 @@ static void collect_procs_anon(struct page *page, struct list_head *to_kill,
 	struct task_struct *tsk;
 	struct anon_vma *av;
 
-	if (!PageHuge(page) && unlikely(split_huge_page(page)))
-		return;
 	read_lock(&tasklist_lock);
 	av = page_lock_anon_vma(page);
 	if (av == NULL)	/* Not actually mapped anymore */
@@ -896,6 +894,34 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 		}
 	}
 
+	if (PageTransHuge(hpage)) {
+		/*
+		 * Verify that this isn't a hugetlbfs head page, the check for
+		 * PageAnon is just for avoid tripping a split_huge_page internal
+		 * debug check, as split_huge_page refuses to deal with anything
+		 * that isn't an anon page. PageAnon can't go away from under us
+		 * because we hold a refcount on the hpage, without a refcount
+		 * on the hpage. split_huge_page can't be safely called
+		 * in the first place, having a refcount on the tail isn't enough
+		 * to be safe.
+		 */
+		if (!PageHuge(hpage) && PageAnon(hpage)) {
+			if (unlikely(split_huge_page(hpage))) {
+				/*
+				 * FIXME: if splitting THP is failed, it is better
+				 * to stop the following operation rather than
+				 * causing panic by unmapping. System might survive
+				 * if the page is freed later.
+				 */
+				printk(KERN_INFO
+					"MCE %#lx: failed to split THP\n", pfn);
+
+				BUG_ON(!PageHWPoison(p));
+				return SWAP_FAIL;
+			}
+		}
+	}
+
 	/*
 	 * First collect all the processes that have the page
 	 * mapped in dirty form.  This has to be done before try_to_unmap,
-- 
1.7.2.2


