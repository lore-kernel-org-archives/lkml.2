Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab1AFHqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 02:46:16 -0500
Received: from [69.28.251.93] ([69.28.251.93]:38783 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755073Ab1AFHqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 02:46:04 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] MIPS: Limit fixrange_init() to the FIXMAP region
Date: Wed, 05 Jan 2011 23:31:30 -0800
Message-Id: <e19154ae0e4900405b6e8586a31fa878@localhost>
In-Reply-To: <8eec0c63f92528c501c0e6a0c8396359@localhost>
References: <8eec0c63f92528c501c0e6a0c8396359@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixrange_init() allocates page tables for all addresses higher than
FIXADDR_TOP.  On processors that override the default FIXADDR_TOP
address of 0xfffe_0000, this can consume up to 4 pages (1 page per 4MB)
for pgd's that are never used.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/mm/init.c       |    6 +++---
 arch/mips/mm/pgtable-32.c |    2 +-
 arch/mips/mm/pgtable-64.c |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 2efcbd2..deb8b3a 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -279,11 +279,11 @@ void __init fixrange_init(unsigned long start, unsigned long end,
 	k = __pmd_offset(vaddr);
 	pgd = pgd_base + i;
 
-	for ( ; (i < PTRS_PER_PGD) && (vaddr != end); pgd++, i++) {
+	for ( ; (i < PTRS_PER_PGD) && (vaddr < end); pgd++, i++) {
 		pud = (pud_t *)pgd;
-		for ( ; (j < PTRS_PER_PUD) && (vaddr != end); pud++, j++) {
+		for ( ; (j < PTRS_PER_PUD) && (vaddr < end); pud++, j++) {
 			pmd = (pmd_t *)pud;
-			for (; (k < PTRS_PER_PMD) && (vaddr != end); pmd++, k++) {
+			for (; (k < PTRS_PER_PMD) && (vaddr < end); pmd++, k++) {
 				if (pmd_none(*pmd)) {
 					pte = (pte_t *) alloc_bootmem_low_pages(PAGE_SIZE);
 					set_pmd(pmd, __pmd((unsigned long)pte));
diff --git a/arch/mips/mm/pgtable-32.c b/arch/mips/mm/pgtable-32.c
index 575e401..adc6911 100644
--- a/arch/mips/mm/pgtable-32.c
+++ b/arch/mips/mm/pgtable-32.c
@@ -52,7 +52,7 @@ void __init pagetable_init(void)
 	 * Fixed mappings:
 	 */
 	vaddr = __fix_to_virt(__end_of_fixed_addresses - 1) & PMD_MASK;
-	fixrange_init(vaddr, 0, pgd_base);
+	fixrange_init(vaddr, vaddr + FIXADDR_SIZE, pgd_base);
 
 #ifdef CONFIG_HIGHMEM
 	/*
diff --git a/arch/mips/mm/pgtable-64.c b/arch/mips/mm/pgtable-64.c
index 78eaa4f..cda4e30 100644
--- a/arch/mips/mm/pgtable-64.c
+++ b/arch/mips/mm/pgtable-64.c
@@ -76,5 +76,5 @@ void __init pagetable_init(void)
 	 * Fixed mappings:
 	 */
 	vaddr = __fix_to_virt(__end_of_fixed_addresses - 1) & PMD_MASK;
-	fixrange_init(vaddr, 0, pgd_base);
+	fixrange_init(vaddr, vaddr + FIXADDR_SIZE, pgd_base);
 }
-- 
1.7.0.4

