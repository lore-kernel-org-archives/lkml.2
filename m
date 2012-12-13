Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab2LMWDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:03:01 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26692 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664Ab2LMWCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:02:53 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v6 16/27] x86, kexec: Merge ident_mapping_init and init_level4_page
Date: Thu, 13 Dec 2012 14:02:10 -0800
Message-Id: <1355436141-8668-17-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now ident_mapping_init is checking if pgd/pud is present for every 2M,
so several 2Ms are in same PUD, it will keep checking if pud is there.

init_level4_page does not check existing pgd/pud.

We will need to use ident_mapping_init with pfn_mapped array to
map ram only, and two entries in pfn_mapped could be in same pgd/pud,
so we need to check if pgd/pud is present instead of init_level4_page.

So merge these two set functions to make new ident_mapping_init not
check pgd/pud for every pmd in same pgd/pud, and use it to replace
init_level4_page.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/machine_kexec_64.c |  214 ++++++++++++++----------------------
 1 file changed, 80 insertions(+), 134 deletions(-)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index be14ee1..a0bf7fb 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -21,139 +21,6 @@
 #include <asm/mmu_context.h>
 #include <asm/debugreg.h>
 
-static int init_one_level2_page(struct kimage *image, pgd_t *pgd,
-				unsigned long addr)
-{
-	pud_t *pud;
-	pmd_t *pmd;
-	struct page *page;
-	int result = -ENOMEM;
-
-	addr &= PMD_MASK;
-	pgd += pgd_index(addr);
-	if (!pgd_present(*pgd)) {
-		page = kimage_alloc_control_pages(image, 0);
-		if (!page)
-			goto out;
-		pud = (pud_t *)page_address(page);
-		clear_page(pud);
-		set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
-	}
-	pud = pud_offset(pgd, addr);
-	if (!pud_present(*pud)) {
-		page = kimage_alloc_control_pages(image, 0);
-		if (!page)
-			goto out;
-		pmd = (pmd_t *)page_address(page);
-		clear_page(pmd);
-		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
-	}
-	pmd = pmd_offset(pud, addr);
-	if (!pmd_present(*pmd))
-		set_pmd(pmd, __pmd(addr | __PAGE_KERNEL_LARGE_EXEC));
-	result = 0;
-out:
-	return result;
-}
-
-static int ident_mapping_init(struct kimage *image, pgd_t *level4p,
-				unsigned long mstart, unsigned long mend)
-{
-	int result;
-
-	mstart = round_down(mstart, PMD_SIZE);
-	mend   = round_up(mend - 1, PMD_SIZE);
-
-	while (mstart < mend) {
-		result = init_one_level2_page(image, level4p, mstart);
-		if (result)
-			return result;
-
-		mstart += PMD_SIZE;
-	}
-
-	return 0;
-}
-
-static void init_level2_page(pmd_t *level2p, unsigned long addr)
-{
-	unsigned long end_addr;
-
-	addr &= PAGE_MASK;
-	end_addr = addr + PUD_SIZE;
-	while (addr < end_addr) {
-		set_pmd(level2p++, __pmd(addr | __PAGE_KERNEL_LARGE_EXEC));
-		addr += PMD_SIZE;
-	}
-}
-
-static int init_level3_page(struct kimage *image, pud_t *level3p,
-				unsigned long addr, unsigned long last_addr)
-{
-	unsigned long end_addr;
-	int result;
-
-	result = 0;
-	addr &= PAGE_MASK;
-	end_addr = addr + PGDIR_SIZE;
-	while ((addr < last_addr) && (addr < end_addr)) {
-		struct page *page;
-		pmd_t *level2p;
-
-		page = kimage_alloc_control_pages(image, 0);
-		if (!page) {
-			result = -ENOMEM;
-			goto out;
-		}
-		level2p = (pmd_t *)page_address(page);
-		init_level2_page(level2p, addr);
-		set_pud(level3p++, __pud(__pa(level2p) | _KERNPG_TABLE));
-		addr += PUD_SIZE;
-	}
-	/* clear the unused entries */
-	while (addr < end_addr) {
-		pud_clear(level3p++);
-		addr += PUD_SIZE;
-	}
-out:
-	return result;
-}
-
-
-static int init_level4_page(struct kimage *image, pgd_t *level4p,
-				unsigned long addr, unsigned long last_addr)
-{
-	unsigned long end_addr;
-	int result;
-
-	result = 0;
-	addr &= PAGE_MASK;
-	end_addr = addr + (PTRS_PER_PGD * PGDIR_SIZE);
-	while ((addr < last_addr) && (addr < end_addr)) {
-		struct page *page;
-		pud_t *level3p;
-
-		page = kimage_alloc_control_pages(image, 0);
-		if (!page) {
-			result = -ENOMEM;
-			goto out;
-		}
-		level3p = (pud_t *)page_address(page);
-		result = init_level3_page(image, level3p, addr, last_addr);
-		if (result)
-			goto out;
-		set_pgd(level4p++, __pgd(__pa(level3p) | _KERNPG_TABLE));
-		addr += PGDIR_SIZE;
-	}
-	/* clear the unused entries */
-	while (addr < end_addr) {
-		pgd_clear(level4p++);
-		addr += PGDIR_SIZE;
-	}
-out:
-	return result;
-}
-
 static void free_transition_pgtable(struct kimage *image)
 {
 	free_page((unsigned long)image->arch.pud);
@@ -203,6 +70,84 @@ err:
 	return result;
 }
 
+static void ident_pmd_init(pmd_t *pmd_page,
+			  unsigned long addr, unsigned long end)
+{
+	addr &= PMD_MASK;
+	for (; addr < end; addr += PMD_SIZE) {
+		pmd_t *pmd = pmd_page + pmd_index(addr);
+
+		if (!pmd_present(*pmd))
+			set_pmd(pmd, __pmd(addr | __PAGE_KERNEL_LARGE_EXEC));
+	}
+}
+static int ident_pud_init(struct kimage *image, pud_t *pud_page,
+			  unsigned long addr, unsigned long end)
+{
+	unsigned long next;
+	struct page *page;
+
+	for (; addr < end; addr = next) {
+		pud_t *pud = pud_page + pud_index(addr);
+		pmd_t *pmd;
+
+		next = (addr & PUD_MASK) + PUD_SIZE;
+		if (next > end)
+			next = end;
+
+		if (pud_present(*pud)) {
+			pmd = pmd_offset(pud, 0);
+			ident_pmd_init(pmd, addr, next);
+			continue;
+		}
+		page = kimage_alloc_control_pages(image, 0);
+		if (!page)
+			return -ENOMEM;
+		pmd = (pmd_t *)page_address(page);
+		clear_page(pmd);
+		ident_pmd_init(pmd, addr, next);
+		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
+	}
+
+	return 0;
+}
+static int ident_mapping_init(struct kimage *image, pgd_t *pgd_page,
+				unsigned long addr, unsigned long end)
+{
+	unsigned long next;
+	struct page *page;
+	int result;
+
+	for (; addr < end; addr = next) {
+		pgd_t *pgd = pgd_page + pgd_index(addr);
+		pud_t *pud;
+
+		next = (addr & PGDIR_MASK) + PGDIR_SIZE;
+		if (next > end)
+			next = end;
+
+		if (pgd_present(*pgd)) {
+			pud = pud_offset(pgd, 0);
+			result = ident_pud_init(image, pud, addr, next);
+			if (result)
+				return result;
+			continue;
+		}
+
+		page = kimage_alloc_control_pages(image, 0);
+		if (!page)
+			return -ENOMEM;
+		pud = (pud_t *)page_address(page);
+		clear_page(pud);
+		result = ident_pud_init(image, pud, addr, next);
+		if (result)
+			return result;
+		set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
+	}
+
+	return 0;
+}
+
 static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
 {
 	unsigned long mstart, mend;
@@ -211,7 +156,8 @@ static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
 	int i;
 
 	level4p = (pgd_t *)__va(start_pgtable);
-	result = init_level4_page(image, level4p, 0, max_pfn << PAGE_SHIFT);
+	clear_page(level4p);
+	result = ident_mapping_init(image, level4p, 0, max_pfn << PAGE_SHIFT);
 	if (result)
 		return result;
 
-- 
1.7.10.4

