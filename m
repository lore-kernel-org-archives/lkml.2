Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab1KGQRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:17:31 -0500
Received: from service87.mimecast.com ([91.220.42.44]:50190 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932827Ab1KGQR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:17:27 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 13/16] ARM: LPAE: Add identity mapping support for the 3-level page table format
Date: Mon,  7 Nov 2011 16:16:55 +0000
Message-Id: <1320682618-1182-14-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Nov 2011 16:17:13.0545 (UTC) FILETIME=[B5943390:01CC9D68]
X-MC-Unique: 111110716172410701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pA7GHqLL015276

With LPAE, the pgd is a separate page table with entries pointing to the
pmd. The identity_mapping_add() function needs to ensure that the pgd is
populated before populating the pmd level. The do..while blocks now loop
over the pmd in order to have the same implementation for the two page
table formats. The pmd_addr_end() definition has been removed and the
generic one used instead. The pmd clean-up is done in the pgd_free()
function.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/mm/idmap.c |   36 ++++++++++++++++++++++++++++++++++--
 1 files changed, 34 insertions(+), 2 deletions(-)

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
 

