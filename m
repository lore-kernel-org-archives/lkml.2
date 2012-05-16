Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967148Ab2EPNGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 09:06:01 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:49214 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965982Ab2EPNF6 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 16 May 2012 09:05:58 -0400
Message-Id: <4FB3C27202000078000841A0@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 16 May 2012 14:06:26 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: fix accounting in
 kernel_physical_mapping_init()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When finding a present and acceptable 2M/1G mapping, the number of
pages mapped this way shouldn't be incremented (as it was already
incremented when the earlier part of the mapping was established).
Instead, last_map_addr needs to be updated in this case.

Further, address increments were wrong in one place each in both
phys_pmd_init() and phys_pud_init() (lacking the aligning down to the
respective page boundary).

As we're now doing the same calculation several times, fold it into
a single instance using a local variable (matching how
kernel_physical_mapping_init() itself does it at the PGD level).

Observed during code inspection, not because of an actual problem.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/mm/init_64.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- 3.4-rc7/arch/x86/mm/init_64.c
+++ 3.4-rc7-x86_64-mm-init-accounting/arch/x86/mm/init_64.c
@@ -407,12 +407,12 @@ static unsigned long __meminit
 phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 	      unsigned long page_size_mask, pgprot_t prot)
 {
-	unsigned long pages = 0;
+	unsigned long pages = 0, next;
 	unsigned long last_map_addr = end;
 
 	int i = pmd_index(address);
 
-	for (; i < PTRS_PER_PMD; i++, address += PMD_SIZE) {
+	for (; i < PTRS_PER_PMD; i++, address = next) {
 		unsigned long pte_phys;
 		pmd_t *pmd = pmd_page + pmd_index(address);
 		pte_t *pte;
@@ -426,6 +426,8 @@ phys_pmd_init(pmd_t *pmd_page, unsigned
 			break;
 		}
 
+		next = (address & PMD_MASK) + PMD_SIZE;
+
 		if (pmd_val(*pmd)) {
 			if (!pmd_large(*pmd)) {
 				spin_lock(&init_mm.page_table_lock);
@@ -449,7 +451,7 @@ phys_pmd_init(pmd_t *pmd_page, unsigned
 			 * attributes.
 			 */
 			if (page_size_mask & (1 << PG_LEVEL_2M)) {
-				pages++;
+				last_map_addr = next;
 				continue;
 			}
 			new_prot = pte_pgprot(pte_clrhuge(*(pte_t *)pmd));
@@ -462,7 +464,7 @@ phys_pmd_init(pmd_t *pmd_page, unsigned
 				pfn_pte(address >> PAGE_SHIFT,
 					__pgprot(pgprot_val(prot) | _PAGE_PSE)));
 			spin_unlock(&init_mm.page_table_lock);
-			last_map_addr = (address & PMD_MASK) + PMD_SIZE;
+			last_map_addr = next;
 			continue;
 		}
 
@@ -482,11 +484,11 @@ static unsigned long __meminit
 phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 			 unsigned long page_size_mask)
 {
-	unsigned long pages = 0;
+	unsigned long pages = 0, next;
 	unsigned long last_map_addr = end;
 	int i = pud_index(addr);
 
-	for (; i < PTRS_PER_PUD; i++, addr = (addr & PUD_MASK) + PUD_SIZE) {
+	for (; i < PTRS_PER_PUD; i++, addr = next) {
 		unsigned long pmd_phys;
 		pud_t *pud = pud_page + pud_index(addr);
 		pmd_t *pmd;
@@ -495,8 +497,9 @@ phys_pud_init(pud_t *pud_page, unsigned
 		if (addr >= end)
 			break;
 
-		if (!after_bootmem &&
-				!e820_any_mapped(addr, addr+PUD_SIZE, 0)) {
+		next = (addr & PUD_MASK) + PUD_SIZE;
+
+		if (!after_bootmem && !e820_any_mapped(addr, next, 0)) {
 			set_pud(pud, __pud(0));
 			continue;
 		}
@@ -523,7 +526,7 @@ phys_pud_init(pud_t *pud_page, unsigned
 			 * attributes.
 			 */
 			if (page_size_mask & (1 << PG_LEVEL_1G)) {
-				pages++;
+				last_map_addr = next;
 				continue;
 			}
 			prot = pte_pgprot(pte_clrhuge(*(pte_t *)pud));
@@ -535,7 +538,7 @@ phys_pud_init(pud_t *pud_page, unsigned
 			set_pte((pte_t *)pud,
 				pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
 			spin_unlock(&init_mm.page_table_lock);
-			last_map_addr = (addr & PUD_MASK) + PUD_SIZE;
+			last_map_addr = next;
 			continue;
 		}
 



