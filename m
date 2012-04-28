Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab2D1QWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 12:22:37 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44023 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090Ab2D1QWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 12:22:36 -0400
Subject: [PATCH bugfix] proc/pagemap: correctly report non-present ptes and
 holes between vmas
To: Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andi Kleen <ak@linux.intel.com>, Pavel Emelyanov <xemul@parallels.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Sat, 28 Apr 2012 20:22:30 +0400
Message-ID: <20120428162229.15658.56316.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch resets current pagemap-entry if current pte isn't present,
or if current vma is over. Otherwise pagemap reports last entry again and again.

non-present pte reporting was broken in commit v3.3-3738-g092b50b
("pagemap: introduce data structure for pagemap entry")

reporting for holes was broken in commit v3.3-3734-g5aaabe8
("pagemap: avoid splitting thp when reading /proc/pid/pagemap")

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Reported-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andi Kleen <ak@linux.intel.com>
---
 fs/proc/task_mmu.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index a580c69..9f9c033 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -747,6 +747,8 @@ static void pte_to_pagemap_entry(pagemap_entry_t *pme, pte_t pte)
 	else if (pte_present(pte))
 		*pme = make_pme(PM_PFRAME(pte_pfn(pte))
 				| PM_PSHIFT(PAGE_SHIFT) | PM_PRESENT);
+	else
+		*pme = make_pme(PM_NOT_PRESENT);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -761,6 +763,8 @@ static void thp_pmd_to_pagemap_entry(pagemap_entry_t *pme,
 	if (pmd_present(pmd))
 		*pme = make_pme(PM_PFRAME(pmd_pfn(pmd) + offset)
 				| PM_PSHIFT(PAGE_SHIFT) | PM_PRESENT);
+	else
+		*pme = make_pme(PM_NOT_PRESENT);
 }
 #else
 static inline void thp_pmd_to_pagemap_entry(pagemap_entry_t *pme,
@@ -801,8 +805,10 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 
 		/* check to see if we've left 'vma' behind
 		 * and need a new, higher one */
-		if (vma && (addr >= vma->vm_end))
+		if (vma && (addr >= vma->vm_end)) {
 			vma = find_vma(walk->mm, addr);
+			pme = make_pme(PM_NOT_PRESENT);
+		}
 
 		/* check that 'vma' actually covers this address,
 		 * and that it isn't a huge page vma */
@@ -830,6 +836,8 @@ static void huge_pte_to_pagemap_entry(pagemap_entry_t *pme,
 	if (pte_present(pte))
 		*pme = make_pme(PM_PFRAME(pte_pfn(pte) + offset)
 				| PM_PSHIFT(PAGE_SHIFT) | PM_PRESENT);
+	else
+		*pme = make_pme(PM_NOT_PRESENT);
 }
 
 /* This function walks within one hugetlb entry in the single call */
@@ -839,7 +847,7 @@ static int pagemap_hugetlb_range(pte_t *pte, unsigned long hmask,
 {
 	struct pagemapread *pm = walk->private;
 	int err = 0;
-	pagemap_entry_t pme = make_pme(PM_NOT_PRESENT);
+	pagemap_entry_t pme;
 
 	for (; addr != end; addr += PAGE_SIZE) {
 		int offset = (addr & ~hmask) >> PAGE_SHIFT;

