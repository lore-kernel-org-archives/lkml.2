Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab1CNVMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 17:12:32 -0400
Received: from www.tglx.de ([62.245.132.106]:50921 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab1CNVMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 17:12:30 -0400
Date: Mon, 14 Mar 2011 22:12:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] x86 fixes for 2.6.38
Message-ID: <alpine.LFD.2.00.1103142211080.2787@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Thanks,

	tglx

------------------>
Andrea Arcangeli (1):
      x86/mm: Fix pgd_lock deadlock

Andrey Vagin (1):
      x86/mm: Handle mm_fault_error() in kernel space

Naga Chumbalkar (1):
      x86: Don't check for BIOS corruption in first 64K when there's no need to

Sebastian Andrzej Siewior (1):
      x86: ce4100: Set pci ops via callback instead of module init


 arch/x86/include/asm/ce4100.h     |    6 ++++++
 arch/x86/kernel/check.c           |    8 ++++----
 arch/x86/mm/fault.c               |   14 ++++++++++----
 arch/x86/mm/init_64.c             |    6 +++---
 arch/x86/mm/pageattr.c            |   18 ++++++++----------
 arch/x86/mm/pgtable.c             |   11 ++++-------
 arch/x86/pci/ce4100.c             |    7 ++++---
 arch/x86/platform/ce4100/ce4100.c |    2 ++
 arch/x86/xen/mmu.c                |   10 ++++------
 9 files changed, 45 insertions(+), 37 deletions(-)
 create mode 100644 arch/x86/include/asm/ce4100.h

diff --git a/arch/x86/include/asm/ce4100.h b/arch/x86/include/asm/ce4100.h
new file mode 100644
index 0000000..e656ad8
--- /dev/null
+++ b/arch/x86/include/asm/ce4100.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_CE4100_H_
+#define _ASM_CE4100_H_
+
+int ce4100_pci_init(void);
+
+#endif
diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
index 13a3891..452932d 100644
--- a/arch/x86/kernel/check.c
+++ b/arch/x86/kernel/check.c
@@ -106,8 +106,8 @@ void __init setup_bios_corruption_check(void)
 		addr += size;
 	}
 
-	printk(KERN_INFO "Scanning %d areas for low memory corruption\n",
-	       num_scan_areas);
+	if (num_scan_areas)
+		printk(KERN_INFO "Scanning %d areas for low memory corruption\n", num_scan_areas);
 }
 
 
@@ -143,12 +143,12 @@ static void check_corruption(struct work_struct *dummy)
 {
 	check_for_bios_corruption();
 	schedule_delayed_work(&bios_check_work,
-		round_jiffies_relative(corruption_check_period*HZ)); 
+		round_jiffies_relative(corruption_check_period*HZ));
 }
 
 static int start_periodic_check_for_corruption(void)
 {
-	if (!memory_corruption_check || corruption_check_period == 0)
+	if (!num_scan_areas || !memory_corruption_check || corruption_check_period == 0)
 		return 0;
 
 	printk(KERN_INFO "Scanning for low memory corruption every %d seconds\n",
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 7d90ceb..20e3f87 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -229,15 +229,14 @@ void vmalloc_sync_all(void)
 	for (address = VMALLOC_START & PMD_MASK;
 	     address >= TASK_SIZE && address < FIXADDR_TOP;
 	     address += PMD_SIZE) {
-
-		unsigned long flags;
 		struct page *page;
 
-		spin_lock_irqsave(&pgd_lock, flags);
+		spin_lock(&pgd_lock);
 		list_for_each_entry(page, &pgd_list, lru) {
 			spinlock_t *pgt_lock;
 			pmd_t *ret;
 
+			/* the pgt_lock only for Xen */
 			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
 
 			spin_lock(pgt_lock);
@@ -247,7 +246,7 @@ void vmalloc_sync_all(void)
 			if (!ret)
 				break;
 		}
-		spin_unlock_irqrestore(&pgd_lock, flags);
+		spin_unlock(&pgd_lock);
 	}
 }
 
@@ -828,6 +827,13 @@ mm_fault_error(struct pt_regs *regs, unsigned long error_code,
 	       unsigned long address, unsigned int fault)
 {
 	if (fault & VM_FAULT_OOM) {
+		/* Kernel mode? Handle exceptions or die: */
+		if (!(error_code & PF_USER)) {
+			up_read(&current->mm->mmap_sem);
+			no_context(regs, error_code, address);
+			return;
+		}
+
 		out_of_memory(regs, error_code, address);
 	} else {
 		if (fault & (VM_FAULT_SIGBUS|VM_FAULT_HWPOISON|
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 71a5929..c14a542 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -105,18 +105,18 @@ void sync_global_pgds(unsigned long start, unsigned long end)
 
 	for (address = start; address <= end; address += PGDIR_SIZE) {
 		const pgd_t *pgd_ref = pgd_offset_k(address);
-		unsigned long flags;
 		struct page *page;
 
 		if (pgd_none(*pgd_ref))
 			continue;
 
-		spin_lock_irqsave(&pgd_lock, flags);
+		spin_lock(&pgd_lock);
 		list_for_each_entry(page, &pgd_list, lru) {
 			pgd_t *pgd;
 			spinlock_t *pgt_lock;
 
 			pgd = (pgd_t *)page_address(page) + pgd_index(address);
+			/* the pgt_lock only for Xen */
 			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
 			spin_lock(pgt_lock);
 
@@ -128,7 +128,7 @@ void sync_global_pgds(unsigned long start, unsigned long end)
 
 			spin_unlock(pgt_lock);
 		}
-		spin_unlock_irqrestore(&pgd_lock, flags);
+		spin_unlock(&pgd_lock);
 	}
 }
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index d343b3c..90825f2 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -57,12 +57,10 @@ static unsigned long direct_pages_count[PG_LEVEL_NUM];
 
 void update_page_count(int level, unsigned long pages)
 {
-	unsigned long flags;
-
 	/* Protect against CPA */
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	direct_pages_count[level] += pages;
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
 
 static void split_page_count(int level)
@@ -394,7 +392,7 @@ static int
 try_preserve_large_page(pte_t *kpte, unsigned long address,
 			struct cpa_data *cpa)
 {
-	unsigned long nextpage_addr, numpages, pmask, psize, flags, addr, pfn;
+	unsigned long nextpage_addr, numpages, pmask, psize, addr, pfn;
 	pte_t new_pte, old_pte, *tmp;
 	pgprot_t old_prot, new_prot, req_prot;
 	int i, do_split = 1;
@@ -403,7 +401,7 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	if (cpa->force_split)
 		return 1;
 
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	/*
 	 * Check for races, another CPU might have split this page
 	 * up already:
@@ -498,14 +496,14 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	}
 
 out_unlock:
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 
 	return do_split;
 }
 
 static int split_large_page(pte_t *kpte, unsigned long address)
 {
-	unsigned long flags, pfn, pfninc = 1;
+	unsigned long pfn, pfninc = 1;
 	unsigned int i, level;
 	pte_t *pbase, *tmp;
 	pgprot_t ref_prot;
@@ -519,7 +517,7 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	if (!base)
 		return -ENOMEM;
 
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	/*
 	 * Check for races, another CPU might have split this page
 	 * up for us already:
@@ -591,7 +589,7 @@ out_unlock:
 	 */
 	if (base)
 		__free_page(base);
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 
 	return 0;
 }
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 500242d..0113d19 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -121,14 +121,12 @@ static void pgd_ctor(struct mm_struct *mm, pgd_t *pgd)
 
 static void pgd_dtor(pgd_t *pgd)
 {
-	unsigned long flags; /* can be called from interrupt context */
-
 	if (SHARED_KERNEL_PMD)
 		return;
 
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	pgd_list_del(pgd);
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
 
 /*
@@ -260,7 +258,6 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	pgd_t *pgd;
 	pmd_t *pmds[PREALLOCATED_PMDS];
-	unsigned long flags;
 
 	pgd = (pgd_t *)__get_free_page(PGALLOC_GFP);
 
@@ -280,12 +277,12 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	 * respect to anything walking the pgd_list, so that they
 	 * never see a partially populated pgd.
 	 */
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 
 	pgd_ctor(mm, pgd);
 	pgd_prepopulate_pmd(mm, pgd, pmds);
 
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 
 	return pgd;
 
diff --git a/arch/x86/pci/ce4100.c b/arch/x86/pci/ce4100.c
index 85b68ef..9260b3e 100644
--- a/arch/x86/pci/ce4100.c
+++ b/arch/x86/pci/ce4100.c
@@ -34,6 +34,7 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 
+#include <asm/ce4100.h>
 #include <asm/pci_x86.h>
 
 struct sim_reg {
@@ -306,10 +307,10 @@ struct pci_raw_ops ce4100_pci_conf = {
 	.write = ce4100_conf_write,
 };
 
-static int __init ce4100_pci_init(void)
+int __init ce4100_pci_init(void)
 {
 	init_sim_regs();
 	raw_pci_ops = &ce4100_pci_conf;
-	return 0;
+	/* Indicate caller that it should invoke pci_legacy_init() */
+	return 1;
 }
-subsys_initcall(ce4100_pci_init);
diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index d2c0d51..cd6f184 100644
--- a/arch/x86/platform/ce4100/ce4100.c
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -15,6 +15,7 @@
 #include <linux/serial_reg.h>
 #include <linux/serial_8250.h>
 
+#include <asm/ce4100.h>
 #include <asm/setup.h>
 #include <asm/io.h>
 
@@ -129,4 +130,5 @@ void __init x86_ce4100_early_setup(void)
 	x86_init.resources.probe_roms = x86_init_noop;
 	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
 	x86_init.mpparse.find_smp_config = sdv_find_smp_config;
+	x86_init.pci.init = ce4100_pci_init;
 }
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 5e92b61..f608942 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -986,10 +986,9 @@ static void xen_pgd_pin(struct mm_struct *mm)
  */
 void xen_mm_pin_all(void)
 {
-	unsigned long flags;
 	struct page *page;
 
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 
 	list_for_each_entry(page, &pgd_list, lru) {
 		if (!PagePinned(page)) {
@@ -998,7 +997,7 @@ void xen_mm_pin_all(void)
 		}
 	}
 
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
 
 /*
@@ -1099,10 +1098,9 @@ static void xen_pgd_unpin(struct mm_struct *mm)
  */
 void xen_mm_unpin_all(void)
 {
-	unsigned long flags;
 	struct page *page;
 
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 
 	list_for_each_entry(page, &pgd_list, lru) {
 		if (PageSavePinned(page)) {
@@ -1112,7 +1110,7 @@ void xen_mm_unpin_all(void)
 		}
 	}
 
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
 
 void xen_activate_mm(struct mm_struct *prev, struct mm_struct *next)
