Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab3ADA4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:56:32 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26706 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab3ADAta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:49:30 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v7u1 20/31] x86, kexec: replace ident_mapping_init and init_level4_page
Date: Thu,  3 Jan 2013 16:48:40 -0800
Message-Id: <1357260531-11115-21-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now ident_mapping_init is checking if pgd/pud is present for every 2M,
so several 2Ms are in same PUD, it will keep checking if pud is there.

init_level4_page does not check existing pgd/pud.

We could use generic mapping_init to replace them all.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/machine_kexec_64.c |  161 ++++++------------------------------
 1 file changed, 26 insertions(+), 135 deletions(-)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index be14ee1..d2d7e02 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -16,144 +16,12 @@
 #include <linux/io.h>
 #include <linux/suspend.h>
 
+#include <asm/init.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
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
@@ -203,15 +71,37 @@ err:
 	return result;
 }
 
+static void *alloc_pgt_page(void *data)
+{
+	struct kimage *image = (struct kimage *)data;
+	struct page *page;
+	void *p = NULL;
+
+	page = kimage_alloc_control_pages(image, 0);
+	if (page) {
+		p = page_address(page);
+		clear_page(p);
+	}
+
+	return p;
+}
+
 static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
 {
+	struct x86_mapping_info info = {
+		.alloc_pgt_page	= alloc_pgt_page,
+		.context	= image,
+		.pmd_flag	= __PAGE_KERNEL_LARGE_EXEC,
+	};
 	unsigned long mstart, mend;
 	pgd_t *level4p;
 	int result;
 	int i;
 
 	level4p = (pgd_t *)__va(start_pgtable);
-	result = init_level4_page(image, level4p, 0, max_pfn << PAGE_SHIFT);
+	clear_page(level4p);
+	result = kernel_ident_mapping_init(&info, level4p,
+						0, max_pfn << PAGE_SHIFT);
 	if (result)
 		return result;
 
@@ -225,7 +115,8 @@ static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
 		mstart = image->segment[i].mem;
 		mend   = mstart + image->segment[i].memsz;
 
-		result = ident_mapping_init(image, level4p, mstart, mend);
+		result = kernel_ident_mapping_init(&info,
+						 level4p, mstart, mend);
 
 		if (result)
 			return result;
-- 
1.7.10.4

