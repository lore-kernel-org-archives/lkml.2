Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632Ab1EXVlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:41:17 -0400
Received: from service87.mimecast.com ([94.185.240.25]:34839 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933511Ab1EXVjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:39:49 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v6 14/18] ARM: LPAE: Add identity mapping support for the 3-level page table format
Date: Tue, 24 May 2011 22:39:20 +0100
Message-Id: <1306273164-18217-15-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
References: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 24 May 2011 21:39:49.0005 (UTC) FILETIME=[1B58C3D0:01CC1A5B]
X-MC-Unique: 111052422394600801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p4OLfg7Y005066

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
 arch/arm/mm/idmap.c            |   36 ++++++++++++++++++++++++++++++++++--
 2 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 1db9ad6..9645e52 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -263,10 +263,6 @@ static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 
 #define pmd_page(pmd)		pfn_to_page(__phys_to_pfn(pmd_val(pmd) & PHYS_MASK))
 
-/* we don't need complex calculations here as the pmd is folded into the pgd */
-#define pmd_addr_end(addr,end)	(end)
-
-
 #ifndef CONFIG_HIGHPTE
 #define __pte_map(pmd)		pmd_page_vaddr(*(pmd))
 #define __pte_unmap(pte)	do { } while (0)
diff --git a/arch/arm/mm/idmap.c b/arch/arm/mm/idmap.c
index 2be9139..24e0655 100644
--- a/arch/arm/mm/idmap.c
+++ b/arch/arm/mm/idmap.c
@@ -1,9 +1,36 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 
 #include <asm/cputype.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
 
+#ifdef CONFIG_ARM_LPAE
+static void idmap_add_pmd(pud_t *pud, unsigned long addr, unsigned long end,
+	unsigned long prot)
+{
+	pmd_t *pmd;
+	unsigned long next;
+
+	if (pud_none_or_clear_bad(pud) || (pud_val(*pud) & L_PGD_SWAPPER)) {
+		pmd = pmd_alloc_one(NULL, addr);
+		if (!pmd) {
+			pr_warning("Failed to allocate identity pmd.\n");
+			return;
+		}
+		pud_populate(NULL, pud, pmd);
+		pmd += pmd_index(addr);
+	} else
+		pmd = pmd_offset(pud, addr);
+
+	do {
+		next = pmd_addr_end(addr, end);
+		*pmd = __pmd((addr & PMD_MASK) | prot);
+		flush_pmd_entry(pmd);
+	} while (pmd++, addr = next, addr != end);
+}
+#else	/* !CONFIG_ARM_LPAE */
 static void idmap_add_pmd(pud_t *pud, unsigned long addr, unsigned long end,
 	unsigned long prot)
 {
@@ -15,6 +42,7 @@ static void idmap_add_pmd(pud_t *pud, unsigned long addr, unsigned long end,
 	pmd[1] = __pmd(addr);
 	flush_pmd_entry(pmd);
 }
+#endif	/* CONFIG_ARM_LPAE */
 
 static void idmap_add_pud(pgd_t *pgd, unsigned long addr, unsigned long end,
 	unsigned long prot)
@@ -32,7 +60,7 @@ void identity_mapping_add(pgd_t *pgd, unsigned long addr, unsigned long end)
 {
 	unsigned long prot, next;
 
-	prot = PMD_TYPE_SECT | PMD_SECT_AP_WRITE;
+	prot = PMD_TYPE_SECT | PMD_SECT_AP_WRITE | PMD_SECT_AF;
 	if (cpu_architecture() <= CPU_ARCH_ARMv5TEJ && !cpu_is_xscale())
 		prot |= PMD_BIT4;
 
@@ -46,7 +74,11 @@ void identity_mapping_add(pgd_t *pgd, unsigned long addr, unsigned long end)
 #ifdef CONFIG_SMP
 static void idmap_del_pmd(pud_t *pud, unsigned long addr, unsigned long end)
 {
-	pmd_t *pmd = pmd_offset(pud, addr);
+	pmd_t *pmd;
+
+	if (pud_none_or_clear_bad(pud))
+		return;
+	pmd = pmd_offset(pud, addr);
 	pmd_clear(pmd);
 }
 

