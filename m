Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab1ANB5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 20:57:14 -0500
Received: from [69.28.251.93] ([69.28.251.93]:45039 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756997Ab1ANB43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 20:56:29 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND 6/6] MIPS: Limit fixrange_init() to the FIXMAP region
Date: Thu, 13 Jan 2011 17:52:17 -0800
Message-Id: <701f7c96d791acbfc7a8d913ca60426b@localhost>
In-Reply-To: <491015d51e5d3d36c517da09e038ecaf@localhost>
References: <491015d51e5d3d36c517da09e038ecaf@localhost>
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
index 45447cd..14a89bd 100644
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

