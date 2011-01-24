Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab1AXR4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 12:56:35 -0500
Received: from service87.mimecast.com ([94.185.240.25]:51243 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754020Ab1AXR42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 12:56:28 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 13/19] ARM: LPAE: Add identity mapping support for the 3-level page table format
Date: Mon, 24 Jan 2011 17:55:55 +0000
Message-Id: <1295891761-18366-14-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c.dirty
In-Reply-To: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 24 Jan 2011 17:56:13.0975 (UTC) FILETIME=[FDCBA270:01CBBBEF]
X-MC-Unique: 111012417562601801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p0OHvI6L031561

With LPAE, the pgd is a separate page table with entries pointing to the
pmd. The identity_mapping_add() function needs to ensure that the pgd is
populated before populating the pmd level. The do..while blocks now loop
over the pmd in order to have the same implementation for the two page
table formats. The pmd_addr_end() definition has been removed and the
generic one used instead. The pmd clean-up is done in the pgd_free()
function.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/pgtable.h |    4 ----
 arch/arm/mm/idmap.c            |   39 ++++++++++++++++++++++++++++-----------
 2 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index a833701..40b21c1 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -257,10 +257,6 @@ static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 
 #define pmd_page(pmd)		pfn_to_page(__phys_to_pfn(pmd_val(pmd) & PHYS_MASK))
 
-/* we don't need complex calculations here as the pmd is folded into the pgd */
-#define pmd_addr_end(addr,end)	(end)
-
-
 #ifndef CONFIG_HIGHPTE
 #define __pte_map(pmd)		pmd_page_vaddr(*(pmd))
 #define __pte_unmap(pte)	do { } while (0)
diff --git a/arch/arm/mm/idmap.c b/arch/arm/mm/idmap.c
index 5729944..dffc7a2 100644
--- a/arch/arm/mm/idmap.c
+++ b/arch/arm/mm/idmap.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 
 #include <asm/cputype.h>
@@ -7,12 +9,25 @@
 static void idmap_add_pmd(pgd_t *pgd, unsigned long addr, unsigned long end,
 	unsigned long prot)
 {
-	pmd_t *pmd = pmd_offset(pgd, addr);
+	pmd_t *pmd;
+
+	if (pgd_none_or_clear_bad(pgd) || (pgd_val(*pgd) & L_PGD_SWAPPER)) {
+		pmd = pmd_alloc_one(NULL, addr);
+		if (!pmd) {
+			pr_warning("Failed to allocate identity pmd.\n");
+			return;
+		}
+		pgd_populate(NULL, pgd, pmd);
+		pmd += pmd_index(addr);
+	} else
+		pmd = pmd_offset(pgd, addr);
 
 	addr = (addr & PMD_MASK) | prot;
 	pmd[0] = __pmd(addr);
+#ifndef CONFIG_ARM_LPAE
 	addr += SECTION_SIZE;
 	pmd[1] = __pmd(addr);
+#endif
 	flush_pmd_entry(pmd);
 }
 
@@ -20,21 +35,24 @@ void identity_mapping_add(pgd_t *pgd, unsigned long addr, unsigned long end)
 {
 	unsigned long prot, next;
 
-	prot = PMD_TYPE_SECT | PMD_SECT_AP_WRITE;
+	prot = PMD_TYPE_SECT | PMD_SECT_AP_WRITE | PMD_SECT_AF;
 	if (cpu_architecture() <= CPU_ARCH_ARMv5TEJ && !cpu_is_xscale())
 		prot |= PMD_BIT4;
 
-	pgd += pgd_index(addr);
 	do {
-		next = pgd_addr_end(addr, end);
-		idmap_add_pmd(pgd, addr, next, prot);
-	} while (pgd++, addr = next, addr != end);
+		next = pmd_addr_end(addr, end);
+		idmap_add_pmd(pgd + pgd_index(addr), addr, next, prot);
+	} while (addr = next, addr < end);
 }
 
 #ifdef CONFIG_SMP
 static void idmap_del_pmd(pgd_t *pgd, unsigned long addr, unsigned long end)
 {
-	pmd_t *pmd = pmd_offset(pgd, addr);
+	pmd_t *pmd;
+
+	if (pgd_none_or_clear_bad(pgd))
+		return;
+	pmd = pmd_offset(pgd, addr);
 	pmd_clear(pmd);
 }
 
@@ -42,11 +60,10 @@ void identity_mapping_del(pgd_t *pgd, unsigned long addr, unsigned long end)
 {
 	unsigned long next;
 
-	pgd += pgd_index(addr);
 	do {
-		next = pgd_addr_end(addr, end);
-		idmap_del_pmd(pgd, addr, next);
-	} while (pgd++, addr = next, addr != end);
+		next = pmd_addr_end(addr, end);
+		idmap_del_pmd(pgd + pgd_index(addr), addr, next);
+	} while (addr = next, addr < end);
 }
 #endif
 

