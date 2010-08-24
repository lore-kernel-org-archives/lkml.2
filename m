Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684Ab0HYAAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 20:00:48 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:61422 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295Ab0HYAAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 20:00:34 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/8] hugetlb: fix metadata corruption in hugetlb_fault()
Date: Wed, 25 Aug 2010 08:55:20 +0900
Message-Id: <1282694127-14609-2-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1282694127-14609-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1282694127-14609-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to avoid metadata corruption when memory failure occurs between
alloc_huge_page() and lock_page().
The corruption occurs because page fault can fail with metadata changes
remained (such as refcount, mapcount, etc.)
Since the PageHWPoison() check is for avoiding hwpoisoned page remained
in pagecache mapping to the process, it should be done in "found in pagecache"
branch, not in the common path.
This patch moves the check to "found in pagecache" branch and fix the problem.

ChangeLog since v2:
- remove retry check in "new allocation" path.
- make description more detailed
- change patch name from "HWPOISON, hugetlb: move PG_HWPoison bit check"

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 mm/hugetlb.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git v2.6.36-rc2/mm/hugetlb.c v2.6.36-rc2/mm/hugetlb.c
index cc5be78..6871b41 100644
--- v2.6.36-rc2/mm/hugetlb.c
+++ v2.6.36-rc2/mm/hugetlb.c
@@ -2518,22 +2518,19 @@ retry:
 			hugepage_add_new_anon_rmap(page, vma, address);
 		}
 	} else {
+		/*
+		 * If memory error occurs between mmap() and fault, some process
+		 * don't have hwpoisoned swap entry for errored virtual address.
+		 * So we need to block hugepage fault by PG_hwpoison bit check.
+		 */
+		if (unlikely(PageHWPoison(page))) {
+			ret = VM_FAULT_HWPOISON;
+			goto backout_unlocked;
+		}
 		page_dup_rmap(page);
 	}
 
 	/*
-	 * Since memory error handler replaces pte into hwpoison swap entry
-	 * at the time of error handling, a process which reserved but not have
-	 * the mapping to the error hugepage does not have hwpoison swap entry.
-	 * So we need to block accesses from such a process by checking
-	 * PG_hwpoison bit here.
-	 */
-	if (unlikely(PageHWPoison(page))) {
-		ret = VM_FAULT_HWPOISON;
-		goto backout_unlocked;
-	}
-
-	/*
 	 * If we are going to COW a private mapping later, we examine the
 	 * pending reservations for this page now. This will ensure that
 	 * any allocations necessary to record that reservation occur outside
-- 
1.7.2.1

