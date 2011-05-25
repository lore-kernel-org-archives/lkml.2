Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab1EYHKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 03:10:47 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41145 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab1EYHKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 03:10:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDCAB6B.8060804@jp.fujitsu.com>
Date: Wed, 25 May 2011 16:10:35 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: kosaki.motohiro@jp.fujitsu.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, aarcange@redhat.com,
        akpm@linux-foundation.org, n-horiguchi@ah.jp.nec.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 3/4] pagewalk: add locking-rule commnets
References: <4DDCAAC0.20102@jp.fujitsu.com>
In-Reply-To: <4DDCAAC0.20102@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally, walk_hugetlb_range() didn't require a caller take any lock.
But commit d33b9f45bd (mm: hugetlb: fix hugepage memory leak in
walk_page_range) changed its rule. Because it added find_vma() call
in walk_hugetlb_range().

Any locking-rule change commit should write a doc too.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/mm.h |    1 +
 mm/pagewalk.c      |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index dd87a78..7337b66 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -921,6 +921,7 @@ unsigned long unmap_vmas(struct mmu_gather **tlb,
  * @pte_entry: if set, called for each non-empty PTE (4th-level) entry
  * @pte_hole: if set, called for each hole at all levels
  * @hugetlb_entry: if set, called for each hugetlb entry
+ *                 *Caution*: The caller must hold mmap_sem() if it's used.
  *
  * (see walk_page_range for more details)
  */
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index ee4ff87..f792940 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -181,6 +181,9 @@ static int walk_hugetlb_range(struct vm_area_struct *vma,
  *
  * If any callback returns a non-zero value, the walk is aborted and
  * the return value is propagated back to the caller. Otherwise 0 is returned.
+ *
+ * walk->mm->mmap_sem must be held for at least read if walk->hugetlb_entry
+ * is !NULL.
  */
 int walk_page_range(unsigned long addr, unsigned long end,
 		    struct mm_walk *walk)
-- 
1.7.3.1



