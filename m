Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab1AYFmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 00:42:39 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57868 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab1AYFmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 00:42:38 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4D3E6377.6060803@np.css.fujitsu.com>
Date: Tue, 25 Jan 2011 14:45:27 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Andrea Arcangeli <aarcange@redhat.com>
CC: =?ISO-2022-JP?B?QUtQTRskQiEhGyhC?= <akpm@linux-foundation.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Huang Ying <ying.huang@intel.com>, LKLM <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] Avoid unmapping THP when it is failed to be split.
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the THP is failed to be split,
   1. The processes using the poisoned page could not be collected.
      (Because page_mapped_in_vma() in collect_procs_anon() always
       returns NULL.)
   2. The poisoned page could not be unmapped.
      (If CONFIG_DEBUG_VM is "y", VM_BUG_ON(PageTransHuge(page))
       in try_to_unmap() will be called, and system panic will be
       caused.)
   3. The processes using the poisoned page could not be killed, too.
      (Because no process is collected in 1.)

So if splitting THP is failed, it is better to stop unmapping
rather than causing panic. System might servive if the page is freed
later.

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 mm/memory-failure.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 548fbd7..55f7d07 100644
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
@@ -896,6 +894,17 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 		}
 	}
 
+	if (!PageHuge(hpage) && PageAnon(hpage) &&
+	    unlikely(split_huge_page(hpage))) {
+		/*
+		 * FIXME: if splitting THP is failed, it is better to stop
+		 * the following operation rather than causing panic
+		 * by unmapping. System might survive if the page is freed later.
+		 */
+		printk(KERN_INFO "MCE %#lx: failed to split THP\n", pfn);
+		return SWAP_FAIL;
+	}
+
 	/*
 	 * First collect all the processes that have the page
 	 * mapped in dirty form.  This has to be done before try_to_unmap,
-- 
1.7.2.2


