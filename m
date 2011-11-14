Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab1KNQYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 11:24:53 -0500
Received: from service87.mimecast.com ([91.220.42.44]:55699 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab1KNQYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 11:24:20 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 13/15] ARM: LPAE: Add identity mapping support for the 3-level page table format
Date: Mon, 14 Nov 2011 16:23:49 +0000
Message-Id: <1321287831-24560-14-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1321287831-24560-1-git-send-email-catalin.marinas@arm.com>
References: <1321287831-24560-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 14 Nov 2011 16:24:08.0460 (UTC) FILETIME=[D5C774C0:01CCA2E9]
X-MC-Unique: 111111416241805301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pAEGPAwL019384

With LPAE, the pgd is a separate page table with entries pointing to the
pmd. The identity_mapping_add() function needs to ensure that the pgd is
populated before populating the pmd level. The do..while blocks now loop
over the pmd in order to have the same implementation for the two page
table formats. The pmd_addr_end() definition has been removed and the
generic one used instead. The pmd clean-up is done in the pgd_free()
function.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---

The idmap_add_pmd() function cannot be called in an atomic context. The
setup_mm_for_reboot() function is being re-implemented as part of the
kexec patches and no longer calls identity_mapping_add().

 arch/arm/mm/idmap.c |   34 ++++++++++++++++++++++++++++++++--
 1 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/idmap.c b/arch/arm/mm/idmap.c
index 2be9139..267db72 100644
--- a/arch/arm/mm/idmap.c
+++ b/arch/arm/mm/idmap.c
@@ -4,6 +4,31 @@
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
+		pmd = pmd_alloc_one(&init_mm, addr);
+		if (!pmd) {
+			pr_warning("Failed to allocate identity pmd.\n");
+			return;
+		}
+		pud_populate(&init_mm, pud, pmd);
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
@@ -15,6 +40,7 @@ static void idmap_add_pmd(pud_t *pud, unsigned long addr, unsigned long end,
 	pmd[1] = __pmd(addr);
 	flush_pmd_entry(pmd);
 }
+#endif	/* CONFIG_ARM_LPAE */
 
 static void idmap_add_pud(pgd_t *pgd, unsigned long addr, unsigned long end,
 	unsigned long prot)
@@ -32,7 +58,7 @@ void identity_mapping_add(pgd_t *pgd, unsigned long addr, unsigned long end)
 {
 	unsigned long prot, next;
 
-	prot = PMD_TYPE_SECT | PMD_SECT_AP_WRITE;
+	prot = PMD_TYPE_SECT | PMD_SECT_AP_WRITE | PMD_SECT_AF;
 	if (cpu_architecture() <= CPU_ARCH_ARMv5TEJ && !cpu_is_xscale())
 		prot |= PMD_BIT4;
 
@@ -46,7 +72,11 @@ void identity_mapping_add(pgd_t *pgd, unsigned long addr, unsigned long end)
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
 

