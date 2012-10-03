Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab2JCM7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:59:53 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:41560 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932197Ab2JCM7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:59:50 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg@redhat.com>, Jan Beulich <jbeulich@suse.com>,
        x86@kernel.org, Ingo Molnar <mingo@kernel.org>,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 3/3] x86/kernel: remove tboot 1:1 page table creation code
Date: Wed,  3 Oct 2012 13:59:17 +0100
Message-Id: <1349269157-25956-4-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349269157-25956-1-git-send-email-matt@console-pimps.org>
References: <1349269157-25956-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaoyan Zhang <xiaoyan.zhang@intel.com>

For TXT boot, while Linux kernel trys to shutdown/S3/S4/reboot, it
need to jump back to tboot code and do TXT teardown work. Previously
kernel zapped all mem page identity mapping (va=pa) after booting, so
tboot code mem address was mapped again with identity mapping. Now
kernel didn't zap the identity mapping page table, so tboot related
code can remove the remapping code before trapping back now.

Signed-off-by: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
Acked-by: Gang Wei <gang.wei@intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/kernel/tboot.c | 78 ++++---------------------------------------------
 1 file changed, 5 insertions(+), 73 deletions(-)

diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index f84fe00..d4f460f 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -103,71 +103,13 @@ void __init tboot_probe(void)
 	pr_debug("tboot_size: 0x%x\n", tboot->tboot_size);
 }
 
-static pgd_t *tboot_pg_dir;
-static struct mm_struct tboot_mm = {
-	.mm_rb          = RB_ROOT,
-	.pgd            = swapper_pg_dir,
-	.mm_users       = ATOMIC_INIT(2),
-	.mm_count       = ATOMIC_INIT(1),
-	.mmap_sem       = __RWSEM_INITIALIZER(init_mm.mmap_sem),
-	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
-	.mmlist         = LIST_HEAD_INIT(init_mm.mmlist),
-};
-
 static inline void switch_to_tboot_pt(void)
 {
-	write_cr3(virt_to_phys(tboot_pg_dir));
-}
-
-static int map_tboot_page(unsigned long vaddr, unsigned long pfn,
-			  pgprot_t prot)
-{
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-
-	pgd = pgd_offset(&tboot_mm, vaddr);
-	pud = pud_alloc(&tboot_mm, pgd, vaddr);
-	if (!pud)
-		return -1;
-	pmd = pmd_alloc(&tboot_mm, pud, vaddr);
-	if (!pmd)
-		return -1;
-	pte = pte_alloc_map(&tboot_mm, NULL, pmd, vaddr);
-	if (!pte)
-		return -1;
-	set_pte_at(&tboot_mm, vaddr, pte, pfn_pte(pfn, prot));
-	pte_unmap(pte);
-	return 0;
-}
-
-static int map_tboot_pages(unsigned long vaddr, unsigned long start_pfn,
-			   unsigned long nr)
-{
-	/* Reuse the original kernel mapping */
-	tboot_pg_dir = pgd_alloc(&tboot_mm);
-	if (!tboot_pg_dir)
-		return -1;
-
-	for (; nr > 0; nr--, vaddr += PAGE_SIZE, start_pfn++) {
-		if (map_tboot_page(vaddr, start_pfn, PAGE_KERNEL_EXEC))
-			return -1;
-	}
-
-	return 0;
-}
-
-static void tboot_create_trampoline(void)
-{
-	u32 map_base, map_size;
-
-	/* Create identity map for tboot shutdown code. */
-	map_base = PFN_DOWN(tboot->tboot_base);
-	map_size = PFN_UP(tboot->tboot_size);
-	if (map_tboot_pages(map_base << PAGE_SHIFT, map_base, map_size))
-		panic("tboot: Error mapping tboot pages (mfns) @ 0x%x, 0x%x\n",
-		      map_base, map_size);
+#ifdef CONFIG_X86_32
+	load_cr3(initial_page_table);
+#else
+	write_cr3(real_mode_header->trampoline_pgd);
+#endif
 }
 
 #ifdef CONFIG_ACPI_SLEEP
@@ -225,14 +167,6 @@ void tboot_shutdown(u32 shutdown_type)
 	if (!tboot_enabled())
 		return;
 
-	/*
-	 * if we're being called before the 1:1 mapping is set up then just
-	 * return and let the normal shutdown happen; this should only be
-	 * due to very early panic()
-	 */
-	if (!tboot_pg_dir)
-		return;
-
 	/* if this is S3 then set regions to MAC */
 	if (shutdown_type == TB_SHUTDOWN_S3)
 		if (tboot_setup_sleep())
@@ -343,8 +277,6 @@ static __init int tboot_late_init(void)
 	if (!tboot_enabled())
 		return 0;
 
-	tboot_create_trampoline();
-
 	atomic_set(&ap_wfs_count, 0);
 	register_hotcpu_notifier(&tboot_cpu_notifier);
 
-- 
1.7.11.4

