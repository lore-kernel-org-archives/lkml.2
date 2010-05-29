Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab0E2De5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 23:34:57 -0400
Received: from king.tilera.com ([72.1.168.226]:16063 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755774Ab0E2De3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 23:34:29 -0400
Message-Id: <201005290334.o4T3YHS0029970@farm-0002.internal.tilera.com>
In-Reply-To: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 28 May 2010 23:13:59 -0400
Subject: [PATCH 6/8] arch/tile: the mm/ directory.
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, torvalds@linux-foundation.org
X-OriginalArrivalTime: 29 May 2010 03:34:17.0624 (UTC) FILETIME=[D14EB980:01CAFEDF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/mm/Makefile      |    9 +
 arch/tile/mm/elf.c         |  164 +++++++
 arch/tile/mm/extable.c     |   30 ++
 arch/tile/mm/fault.c       |  905 ++++++++++++++++++++++++++++++++++++
 arch/tile/mm/highmem.c     |  328 ++++++++++++++
 arch/tile/mm/homecache.c   |  445 ++++++++++++++++++
 arch/tile/mm/hugetlbpage.c |  343 ++++++++++++++
 arch/tile/mm/init.c        | 1082 ++++++++++++++++++++++++++++++++++++++++++++
 arch/tile/mm/migrate.h     |   50 ++
 arch/tile/mm/migrate_32.S  |  211 +++++++++
 arch/tile/mm/mmap.c        |   75 +++
 arch/tile/mm/pgtable.c     |  566 +++++++++++++++++++++++
 12 files changed, 4208 insertions(+), 0 deletions(-)
 create mode 100644 arch/tile/mm/Makefile
 create mode 100644 arch/tile/mm/elf.c
 create mode 100644 arch/tile/mm/extable.c
 create mode 100644 arch/tile/mm/fault.c
 create mode 100644 arch/tile/mm/highmem.c
 create mode 100644 arch/tile/mm/homecache.c
 create mode 100644 arch/tile/mm/hugetlbpage.c
 create mode 100644 arch/tile/mm/init.c
 create mode 100644 arch/tile/mm/migrate.h
 create mode 100644 arch/tile/mm/migrate_32.S
 create mode 100644 arch/tile/mm/mmap.c
 create mode 100644 arch/tile/mm/pgtable.c

diff --git a/arch/tile/mm/Makefile b/arch/tile/mm/Makefile
new file mode 100644
index 0000000..e252aed
--- /dev/null
+++ b/arch/tile/mm/Makefile
@@ -0,0 +1,9 @@
+#
+# Makefile for the linux tile-specific parts of the memory manager.
+#
+
+obj-y	:= init.o pgtable.o fault.o extable.o elf.o \
+	   mmap.o homecache.o migrate_$(BITS).o
+
+obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
+obj-$(CONFIG_HIGHMEM) += highmem.o
diff --git a/arch/tile/mm/elf.c b/arch/tile/mm/elf.c
new file mode 100644
index 0000000..818c9be
--- /dev/null
+++ b/arch/tile/mm/elf.c
@@ -0,0 +1,164 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/mm.h>
+#include <linux/pagemap.h>
+#include <linux/binfmts.h>
+#include <linux/compat.h>
+#include <linux/mman.h>
+#include <linux/elf.h>
+#include <asm/pgtable.h>
+#include <asm/pgalloc.h>
+
+/* Notify a running simulator, if any, that an exec just occurred. */
+static void sim_notify_exec(const char *binary_name)
+{
+	unsigned char c;
+	do {
+		c = *binary_name++;
+		__insn_mtspr(SPR_SIM_CONTROL,
+			     (SIM_CONTROL_OS_EXEC
+			      | (c << _SIM_CONTROL_OPERATOR_BITS)));
+
+	} while (c);
+}
+
+static int notify_exec(void)
+{
+	int retval = 0;  /* failure */
+	struct vm_area_struct *vma = current->mm->mmap;
+	while (vma) {
+		if ((vma->vm_flags & VM_EXECUTABLE) && vma->vm_file)
+			break;
+		vma = vma->vm_next;
+	}
+	if (vma) {
+		char *buf = (char *) __get_free_page(GFP_KERNEL);
+		if (buf) {
+			char *path = d_path(&vma->vm_file->f_path,
+					    buf, PAGE_SIZE);
+			if (!IS_ERR(path)) {
+				sim_notify_exec(path);
+				retval = 1;
+			}
+			free_page((unsigned long)buf);
+		}
+	}
+	return retval;
+}
+
+/* Notify a running simulator, if any, that we loaded an interpreter. */
+static void sim_notify_interp(unsigned long load_addr)
+{
+	size_t i;
+	for (i = 0; i < sizeof(load_addr); i++) {
+		unsigned char c = load_addr >> (i * 8);
+		__insn_mtspr(SPR_SIM_CONTROL,
+			     (SIM_CONTROL_OS_INTERP
+			      | (c << _SIM_CONTROL_OPERATOR_BITS)));
+	}
+}
+
+
+/* Kernel address of page used to map read-only kernel data into userspace. */
+static void *vdso_page;
+
+/* One-entry array used for install_special_mapping. */
+static struct page *vdso_pages[1];
+
+int __init vdso_setup(void)
+{
+	extern char __rt_sigreturn[], __rt_sigreturn_end[];
+	vdso_page = (void *)get_zeroed_page(GFP_ATOMIC);
+	memcpy(vdso_page, __rt_sigreturn, __rt_sigreturn_end - __rt_sigreturn);
+	vdso_pages[0] = virt_to_page(vdso_page);
+	return 0;
+}
+device_initcall(vdso_setup);
+
+const char *arch_vma_name(struct vm_area_struct *vma)
+{
+	if (vma->vm_private_data == vdso_pages)
+		return "[vdso]";
+#ifndef __tilegx__
+	if (vma->vm_start == MEM_USER_INTRPT)
+		return "[intrpt]";
+#endif
+	return NULL;
+}
+
+int arch_setup_additional_pages(struct linux_binprm *bprm,
+				int executable_stack)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long vdso_base;
+	int retval = 0;
+
+	/*
+	 * Notify the simulator that an exec just occurred.
+	 * If we can't find the filename of the mapping, just use
+	 * whatever was passed as the linux_binprm filename.
+	 */
+	if (!notify_exec())
+		sim_notify_exec(bprm->filename);
+
+	down_write(&mm->mmap_sem);
+
+	/*
+	 * MAYWRITE to allow gdb to COW and set breakpoints
+	 *
+	 * Make sure the vDSO gets into every core dump.  Dumping its
+	 * contents makes post-mortem fully interpretable later
+	 * without matching up the same kernel and hardware config to
+	 * see what PC values meant.
+	 */
+	vdso_base = VDSO_BASE;
+	retval = install_special_mapping(mm, vdso_base, PAGE_SIZE,
+					 VM_READ|VM_EXEC|
+					 VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
+					 VM_ALWAYSDUMP,
+					 vdso_pages);
+
+#ifndef __tilegx__
+	/*
+	 * Set up a user-interrupt mapping here; the user can't
+	 * create one themselves since it is above TASK_SIZE.
+	 * We make it unwritable by default, so the model for adding
+	 * interrupt vectors always involves an mprotect.
+	 */
+	if (!retval) {
+		unsigned long addr = MEM_USER_INTRPT;
+		addr = mmap_region(NULL, addr, INTRPT_SIZE,
+				   MAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE,
+				   VM_READ|VM_EXEC|
+				   VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC, 0);
+		if (addr > (unsigned long) -PAGE_SIZE)
+			retval = (int) addr;
+	}
+#endif
+
+	up_write(&mm->mmap_sem);
+
+	return retval;
+}
+
+
+void elf_plat_init(struct pt_regs *regs, unsigned long load_addr)
+{
+	/* Zero all registers. */
+	memset(regs, 0, sizeof(*regs));
+
+	/* Report the interpreter's load address. */
+	sim_notify_interp(load_addr);
+}
diff --git a/arch/tile/mm/extable.c b/arch/tile/mm/extable.c
new file mode 100644
index 0000000..4fb0acb
--- /dev/null
+++ b/arch/tile/mm/extable.c
@@ -0,0 +1,30 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/uaccess.h>
+
+int fixup_exception(struct pt_regs *regs)
+{
+	const struct exception_table_entry *fixup;
+
+	fixup = search_exception_tables(regs->pc);
+	if (fixup) {
+		regs->pc = fixup->fixup;
+		return 1;
+	}
+
+	return 0;
+}
diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
new file mode 100644
index 0000000..9b6b92f
--- /dev/null
+++ b/arch/tile/mm/fault.c
@@ -0,0 +1,905 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * From i386 code copyright (C) 1995  Linus Torvalds
+ */
+
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/ptrace.h>
+#include <linux/mman.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/smp_lock.h>
+#include <linux/interrupt.h>
+#include <linux/init.h>
+#include <linux/tty.h>
+#include <linux/vt_kern.h>		/* For unblank_screen() */
+#include <linux/highmem.h>
+#include <linux/module.h>
+#include <linux/kprobes.h>
+#include <linux/hugetlb.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+
+#include <asm/system.h>
+#include <asm/pgalloc.h>
+#include <asm/sections.h>
+
+#include <arch/interrupts.h>
+
+/*
+ * Unlock any spinlocks which will prevent us from getting the
+ * message out
+ */
+void bust_spinlocks(int yes)
+{
+	int loglevel_save = console_loglevel;
+
+	if (yes) {
+		oops_in_progress = 1;
+		return;
+	}
+	oops_in_progress = 0;
+	/*
+	 * OK, the message is on the console.  Now we call printk()
+	 * without oops_in_progress set so that printk will give klogd
+	 * a poke.  Hold onto your hats...
+	 */
+	console_loglevel = 15;	/* NMI oopser may have shut the console up */
+	printk(" ");
+	console_loglevel = loglevel_save;
+}
+
+static noinline void force_sig_info_fault(int si_signo, int si_code,
+	unsigned long address, int fault_num, struct task_struct *tsk)
+{
+	siginfo_t info;
+
+	if (unlikely(tsk->pid < 2)) {
+		panic("Signal %d (code %d) at %#lx sent to %s!",
+		      si_signo, si_code & 0xffff, address,
+		      tsk->pid ? "init" : "the idle task");
+	}
+
+	info.si_signo = si_signo;
+	info.si_errno = 0;
+	info.si_code = si_code;
+	info.si_addr = (void __user *)address;
+	info.si_trapno = fault_num;
+	force_sig_info(si_signo, &info, tsk);
+}
+
+#ifndef __tilegx__
+/*
+ * Synthesize the fault a PL0 process would get by doing a word-load of
+ * an unaligned address or a high kernel address.  Called indirectly
+ * from sys_cmpxchg() in kernel/intvec.S.
+ */
+int _sys_cmpxchg_badaddr(unsigned long address, struct pt_regs *regs)
+{
+	if (address >= PAGE_OFFSET)
+		force_sig_info_fault(SIGSEGV, SEGV_MAPERR, address,
+				     INT_DTLB_MISS, current);
+	else
+		force_sig_info_fault(SIGBUS, BUS_ADRALN, address,
+				     INT_UNALIGN_DATA, current);
+
+	/*
+	 * Adjust pc to point at the actual instruction, which is unusual
+	 * for syscalls normally, but is appropriate when we are claiming
+	 * that a syscall swint1 caused a page fault or bus error.
+	 */
+	regs->pc -= 8;
+
+	/*
+	 * Mark this as a caller-save interrupt, like a normal page fault,
+	 * so that when we go through the signal handler path we will
+	 * properly restore r0, r1, and r2 for the signal handler arguments.
+	 */
+	regs->flags |= PT_FLAGS_CALLER_SAVES;
+
+	return 0;
+}
+#endif
+
+static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
+{
+	unsigned index = pgd_index(address);
+	pgd_t *pgd_k;
+	pud_t *pud, *pud_k;
+	pmd_t *pmd, *pmd_k;
+
+	pgd += index;
+	pgd_k = init_mm.pgd + index;
+
+	if (!pgd_present(*pgd_k))
+		return NULL;
+
+	pud = pud_offset(pgd, address);
+	pud_k = pud_offset(pgd_k, address);
+	if (!pud_present(*pud_k))
+		return NULL;
+
+	pmd = pmd_offset(pud, address);
+	pmd_k = pmd_offset(pud_k, address);
+	if (!pmd_present(*pmd_k))
+		return NULL;
+	if (!pmd_present(*pmd)) {
+		set_pmd(pmd, *pmd_k);
+		arch_flush_lazy_mmu_mode();
+	} else
+		BUG_ON(pmd_ptfn(*pmd) != pmd_ptfn(*pmd_k));
+	return pmd_k;
+}
+
+/*
+ * Handle a fault on the vmalloc or module mapping area
+ */
+static inline int vmalloc_fault(pgd_t *pgd, unsigned long address)
+{
+	pmd_t *pmd_k;
+	pte_t *pte_k;
+
+	/* Make sure we are in vmalloc area */
+	if (!(address >= VMALLOC_START && address < VMALLOC_END))
+		return -1;
+
+	/*
+	 * Synchronize this task's top level page-table
+	 * with the 'reference' page table.
+	 */
+	pmd_k = vmalloc_sync_one(pgd, address);
+	if (!pmd_k)
+		return -1;
+	if (pmd_huge(*pmd_k))
+		return 0;   /* support TILE huge_vmap() API */
+	pte_k = pte_offset_kernel(pmd_k, address);
+	if (!pte_present(*pte_k))
+		return -1;
+	return 0;
+}
+
+/* Wait until this PTE has completed migration. */
+static void wait_for_migration(pte_t *pte)
+{
+	if (pte_migrating(*pte)) {
+		/*
+		 * Wait until the migrater fixes up this pte.
+		 * We scale the loop count by the clock rate so we'll wait for
+		 * a few seconds here.
+		 */
+		int retries = 0;
+		int bound = get_clock_rate();
+		while (pte_migrating(*pte)) {
+			barrier();
+			if (++retries > bound)
+				panic("Hit migrating PTE (%#llx) and"
+				      " page PFN %#lx still migrating",
+				      pte->val, pte_pfn(*pte));
+		}
+	}
+}
+
+/*
+ * It's not generally safe to use "current" to get the page table pointer,
+ * since we might be running an oprofile interrupt in the middle of a
+ * task switch.
+ */
+static pgd_t *get_current_pgd(void)
+{
+	HV_Context ctx = hv_inquire_context();
+	unsigned long pgd_pfn = ctx.page_table >> PAGE_SHIFT;
+	struct page *pgd_page = pfn_to_page(pgd_pfn);
+	BUG_ON(PageHighMem(pgd_page));   /* oops, HIGHPTE? */
+	return (pgd_t *) __va(ctx.page_table);
+}
+
+/*
+ * We can receive a page fault from a migrating PTE at any time.
+ * Handle it by just waiting until the fault resolves.
+ *
+ * It's also possible to get a migrating kernel PTE that resolves
+ * itself during the downcall from hypervisor to Linux.  We just check
+ * here to see if the PTE seems valid, and if so we retry it.
+ *
+ * NOTE! We MUST NOT take any locks for this case.  We may be in an
+ * interrupt or a critical region, and must do as little as possible.
+ * Similarly, we can't use atomic ops here, since we may be handling a
+ * fault caused by an atomic op access.
+ */
+static int handle_migrating_pte(pgd_t *pgd, int fault_num,
+				unsigned long address,
+				int is_kernel_mode, int write)
+{
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+	pte_t pteval;
+
+	if (pgd_addr_invalid(address))
+		return 0;
+
+	pgd += pgd_index(address);
+	pud = pud_offset(pgd, address);
+	if (!pud || !pud_present(*pud))
+		return 0;
+	pmd = pmd_offset(pud, address);
+	if (!pmd || !pmd_present(*pmd))
+		return 0;
+	pte = pmd_huge_page(*pmd) ? ((pte_t *)pmd) :
+		pte_offset_kernel(pmd, address);
+	pteval = *pte;
+	if (pte_migrating(pteval)) {
+		wait_for_migration(pte);
+		return 1;
+	}
+
+	if (!is_kernel_mode || !pte_present(pteval))
+		return 0;
+	if (fault_num == INT_ITLB_MISS) {
+		if (pte_exec(pteval))
+			return 1;
+	} else if (write) {
+		if (pte_write(pteval))
+			return 1;
+	} else {
+		if (pte_read(pteval))
+			return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * This routine is responsible for faulting in user pages.
+ * It passes the work off to one of the appropriate routines.
+ * It returns true if the fault was successfully handled.
+ */
+static int handle_page_fault(struct pt_regs *regs,
+			     int fault_num,
+			     int is_page_fault,
+			     unsigned long address,
+			     int write)
+{
+	struct task_struct *tsk;
+	struct mm_struct *mm;
+	struct vm_area_struct *vma;
+	unsigned long stack_offset;
+	int fault;
+	int si_code;
+	int is_kernel_mode;
+	pgd_t *pgd;
+
+	/* on TILE, protection faults are always writes */
+	if (!is_page_fault)
+		write = 1;
+
+	is_kernel_mode = (EX1_PL(regs->ex1) != USER_PL);
+
+	tsk = validate_current();
+
+	/*
+	 * Check to see if we might be overwriting the stack, and bail
+	 * out if so.  The page fault code is a relatively likely
+	 * place to get trapped in an infinite regress, and once we
+	 * overwrite the whole stack, it becomes very hard to recover.
+	 */
+	stack_offset = stack_pointer & (THREAD_SIZE-1);
+	if (stack_offset < THREAD_SIZE / 8) {
+		printk(KERN_ALERT "Potential stack overrun: sp %#lx\n",
+		       stack_pointer);
+		show_regs(regs);
+		printk(KERN_ALERT "Killing current process %d/%s\n",
+		       tsk->pid, tsk->comm);
+		do_group_exit(SIGKILL);
+	}
+
+	/*
+	 * Early on, we need to check for migrating PTE entries;
+	 * see homecache.c.  If we find a migrating PTE, we wait until
+	 * the backing page claims to be done migrating, then we procede.
+	 * For kernel PTEs, we rewrite the PTE and return and retry.
+	 * Otherwise, we treat the fault like a normal "no PTE" fault,
+	 * rather than trying to patch up the existing PTE.
+	 */
+	pgd = get_current_pgd();
+	if (handle_migrating_pte(pgd, fault_num, address,
+				 is_kernel_mode, write))
+		return 1;
+
+	si_code = SEGV_MAPERR;
+
+	/*
+	 * We fault-in kernel-space virtual memory on-demand. The
+	 * 'reference' page table is init_mm.pgd.
+	 *
+	 * NOTE! We MUST NOT take any locks for this case. We may
+	 * be in an interrupt or a critical region, and should
+	 * only copy the information from the master page table,
+	 * nothing more.
+	 *
+	 * This verifies that the fault happens in kernel space
+	 * and that the fault was not a protection fault.
+	 */
+	if (unlikely(address >= TASK_SIZE &&
+		     !is_arch_mappable_range(address, 0))) {
+		if (is_kernel_mode && is_page_fault &&
+		    vmalloc_fault(pgd, address) >= 0)
+			return 1;
+		/*
+		 * Don't take the mm semaphore here. If we fixup a prefetch
+		 * fault we could otherwise deadlock.
+		 */
+		mm = NULL;  /* happy compiler */
+		vma = NULL;
+		goto bad_area_nosemaphore;
+	}
+
+	/*
+	 * If we're trying to touch user-space addresses, we must
+	 * be either at PL0, or else with interrupts enabled in the
+	 * kernel, so either way we can re-enable interrupts here.
+	 */
+	local_irq_enable();
+
+	mm = tsk->mm;
+
+	/*
+	 * If we're in an interrupt, have no user context or are running in an
+	 * atomic region then we must not take the fault.
+	 */
+	if (in_atomic() || !mm) {
+		vma = NULL;  /* happy compiler */
+		goto bad_area_nosemaphore;
+	}
+
+	/*
+	 * When running in the kernel we expect faults to occur only to
+	 * addresses in user space.  All other faults represent errors in the
+	 * kernel and should generate an OOPS.  Unfortunately, in the case of an
+	 * erroneous fault occurring in a code path which already holds mmap_sem
+	 * we will deadlock attempting to validate the fault against the
+	 * address space.  Luckily the kernel only validly references user
+	 * space from well defined areas of code, which are listed in the
+	 * exceptions table.
+	 *
+	 * As the vast majority of faults will be valid we will only perform
+	 * the source reference check when there is a possibility of a deadlock.
+	 * Attempt to lock the address space, if we cannot we then validate the
+	 * source.  If this is invalid we can skip the address space check,
+	 * thus avoiding the deadlock.
+	 */
+	if (!down_read_trylock(&mm->mmap_sem)) {
+		if (is_kernel_mode &&
+		    !search_exception_tables(regs->pc)) {
+			vma = NULL;  /* happy compiler */
+			goto bad_area_nosemaphore;
+		}
+		down_read(&mm->mmap_sem);
+	}
+
+	vma = find_vma(mm, address);
+	if (!vma)
+		goto bad_area;
+	if (vma->vm_start <= address)
+		goto good_area;
+	if (!(vma->vm_flags & VM_GROWSDOWN))
+		goto bad_area;
+	if (regs->sp < PAGE_OFFSET) {
+		/*
+		 * accessing the stack below sp is always a bug.
+		 */
+		if (address < regs->sp)
+			goto bad_area;
+	}
+	if (expand_stack(vma, address))
+		goto bad_area;
+
+/*
+ * Ok, we have a good vm_area for this memory access, so
+ * we can handle it..
+ */
+good_area:
+	si_code = SEGV_ACCERR;
+	if (fault_num == INT_ITLB_MISS) {
+		if (!(vma->vm_flags & VM_EXEC))
+			goto bad_area;
+	} else if (write) {
+#ifdef TEST_VERIFY_AREA
+		if (!is_page_fault && regs->cs == KERNEL_CS)
+			printk("WP fault at "REGFMT"\n", regs->eip);
+#endif
+		if (!(vma->vm_flags & VM_WRITE))
+			goto bad_area;
+	} else {
+		if (!is_page_fault || !(vma->vm_flags & VM_READ))
+			goto bad_area;
+	}
+
+ survive:
+	/*
+	 * If for any reason at all we couldn't handle the fault,
+	 * make sure we exit gracefully rather than endlessly redo
+	 * the fault.
+	 */
+	fault = handle_mm_fault(mm, vma, address, write);
+	if (unlikely(fault & VM_FAULT_ERROR)) {
+		if (fault & VM_FAULT_OOM)
+			goto out_of_memory;
+		else if (fault & VM_FAULT_SIGBUS)
+			goto do_sigbus;
+		BUG();
+	}
+	if (fault & VM_FAULT_MAJOR)
+		tsk->maj_flt++;
+	else
+		tsk->min_flt++;
+
+	/*
+	 * If this was an asynchronous fault,
+	 * restart the appropriate engine.
+	 */
+	switch (fault_num) {
+#if CHIP_HAS_TILE_DMA()
+	case INT_DMATLB_MISS:
+	case INT_DMATLB_MISS_DWNCL:
+	case INT_DMATLB_ACCESS:
+	case INT_DMATLB_ACCESS_DWNCL:
+		__insn_mtspr(SPR_DMA_CTR, SPR_DMA_CTR__REQUEST_MASK);
+		break;
+#endif
+#if CHIP_HAS_SN_PROC()
+	case INT_SNITLB_MISS:
+	case INT_SNITLB_MISS_DWNCL:
+		__insn_mtspr(SPR_SNCTL,
+			     __insn_mfspr(SPR_SNCTL) &
+			     ~SPR_SNCTL__FRZPROC_MASK);
+		break;
+#endif
+	}
+
+	up_read(&mm->mmap_sem);
+	return 1;
+
+/*
+ * Something tried to access memory that isn't in our memory map..
+ * Fix it, but check if it's kernel or user first..
+ */
+bad_area:
+	up_read(&mm->mmap_sem);
+
+bad_area_nosemaphore:
+	/* User mode accesses just cause a SIGSEGV */
+	if (!is_kernel_mode) {
+		/*
+		 * It's possible to have interrupts off here.
+		 */
+		local_irq_enable();
+
+		force_sig_info_fault(SIGSEGV, si_code, address,
+				     fault_num, tsk);
+		return 0;
+	}
+
+no_context:
+	/* Are we prepared to handle this kernel fault?  */
+	if (fixup_exception(regs))
+		return 0;
+
+/*
+ * Oops. The kernel tried to access some bad page. We'll have to
+ * terminate things with extreme prejudice.
+ */
+
+	bust_spinlocks(1);
+
+	/* FIXME: no lookup_address() yet */
+#ifdef SUPPORT_LOOKUP_ADDRESS
+	if (fault_num == INT_ITLB_MISS) {
+		pte_t *pte = lookup_address(address);
+
+		if (pte && pte_present(*pte) && !pte_exec_kernel(*pte))
+			printk(KERN_CRIT "kernel tried to execute"
+			       " non-executable page - exploit attempt?"
+			       " (uid: %d)\n", current->uid);
+	}
+#endif
+	if (address < PAGE_SIZE)
+		printk(KERN_ALERT "Unable to handle kernel NULL pointer dereference\n");
+	else
+		printk(KERN_ALERT "Unable to handle kernel paging request\n");
+	printk(" at virtual address "REGFMT", pc "REGFMT"\n",
+	       address, regs->pc);
+
+	show_regs(regs);
+
+	if (unlikely(tsk->pid < 2)) {
+		panic("Kernel page fault running %s!",
+		      tsk->pid ? "init" : "the idle task");
+	}
+
+	/*
+	 * More FIXME: we should probably copy the i386 here and
+	 * implement a generic die() routine.  Not today.
+	 */
+#ifdef SUPPORT_DIE
+	die("Oops", regs);
+#endif
+	bust_spinlocks(1);
+
+	do_group_exit(SIGKILL);
+
+/*
+ * We ran out of memory, or some other thing happened to us that made
+ * us unable to handle the page fault gracefully.
+ */
+out_of_memory:
+	up_read(&mm->mmap_sem);
+	if (is_global_init(tsk)) {
+		yield();
+		down_read(&mm->mmap_sem);
+		goto survive;
+	}
+	printk("VM: killing process %s\n", tsk->comm);
+	if (!is_kernel_mode)
+		do_group_exit(SIGKILL);
+	goto no_context;
+
+do_sigbus:
+	up_read(&mm->mmap_sem);
+
+	/* Kernel mode? Handle exceptions or die */
+	if (is_kernel_mode)
+		goto no_context;
+
+	force_sig_info_fault(SIGBUS, BUS_ADRERR, address, fault_num, tsk);
+	return 0;
+}
+
+#ifndef __tilegx__
+
+extern char sys_cmpxchg[], __sys_cmpxchg_end[];
+extern char __sys_cmpxchg_grab_lock[];
+extern char __start_atomic_asm_code[], __end_atomic_asm_code[];
+
+/*
+ * We return this structure in registers to avoid having to write
+ * additional save/restore code in the intvec.S caller.
+ */
+struct intvec_state {
+	void *handler;
+	unsigned long vecnum;
+	unsigned long fault_num;
+	unsigned long info;
+	unsigned long retval;
+};
+
+/* We must release ICS before panicking or we won't get anywhere. */
+#define ics_panic(fmt, ...) do { \
+	__insn_mtspr(SPR_INTERRUPT_CRITICAL_SECTION, 0); \
+	panic(fmt, __VA_ARGS__); \
+} while (0)
+
+void do_page_fault(struct pt_regs *regs, int fault_num,
+		   unsigned long address, unsigned long write);
+
+/*
+ * When we take an ITLB or DTLB fault or access violation in the
+ * supervisor while the critical section bit is set, the hypervisor is
+ * reluctant to write new values into the EX_CONTEXT_1_x registers,
+ * since that might indicate we have not yet squirreled the SPR
+ * contents away and can thus safely take a recursive interrupt.
+ * Accordingly, the hypervisor passes us the PC via SYSTEM_SAVE_1_2.
+ */
+struct intvec_state do_page_fault_ics(struct pt_regs *regs, int fault_num,
+				      unsigned long address,
+				      unsigned long info)
+{
+	unsigned long pc = info & ~1;
+	int write = info & 1;
+	pgd_t *pgd = get_current_pgd();
+
+	/* Retval is 1 at first since we will handle the fault fully. */
+	struct intvec_state state = {
+		do_page_fault, fault_num, address, write, 1
+	};
+
+	/* Validate that we are plausibly in the right routine. */
+	if ((pc & 0x7) != 0 || pc < PAGE_OFFSET ||
+	    (fault_num != INT_DTLB_MISS &&
+	     fault_num != INT_DTLB_ACCESS)) {
+		unsigned long old_pc = regs->pc;
+		regs->pc = pc;
+		ics_panic("Bad ICS page fault args:"
+			  " old PC %#lx, fault %d/%d at %#lx\n",
+			  old_pc, fault_num, write, address);
+	}
+
+	/* We might be faulting on a vmalloc page, so check that first. */
+	if (fault_num != INT_DTLB_ACCESS && vmalloc_fault(pgd, address) >= 0)
+		return state;
+
+	/*
+	 * If we faulted with ICS set in sys_cmpxchg, we are providing
+	 * a user syscall service that should generate a signal on
+	 * fault.  We didn't set up a kernel stack on initial entry to
+	 * sys_cmpxchg, but instead had one set up by the fault, which
+	 * (because sys_cmpxchg never releases ICS) came to us via the
+	 * SYSTEM_SAVE_1_2 mechanism, and thus EX_CONTEXT_1_[01] are
+	 * still referencing the original user code.  We release the
+	 * atomic lock and rewrite pt_regs so that it appears that we
+	 * came from user-space directly, and after we finish the
+	 * fault we'll go back to user space and re-issue the swint.
+	 * This way the backtrace information is correct if we need to
+	 * emit a stack dump at any point while handling this.
+	 *
+	 * Must match register use in sys_cmpxchg().
+	 */
+	if (pc >= (unsigned long) sys_cmpxchg &&
+	    pc < (unsigned long) __sys_cmpxchg_end) {
+#ifdef CONFIG_SMP
+		/* Don't unlock before we could have locked. */
+		if (pc >= (unsigned long)__sys_cmpxchg_grab_lock) {
+			int *lock_ptr = (int *)(regs->regs[ATOMIC_LOCK_REG]);
+			__atomic_fault_unlock(lock_ptr);
+		}
+#endif
+		regs->sp = regs->regs[27];
+	}
+
+	/*
+	 * We can also fault in the atomic assembly, in which
+	 * case we use the exception table to do the first-level fixup.
+	 * We may re-fixup again in the real fault handler if it
+	 * turns out the faulting address is just bad, and not,
+	 * for example, migrating.
+	 */
+	else if (pc >= (unsigned long) __start_atomic_asm_code &&
+		   pc < (unsigned long) __end_atomic_asm_code) {
+		const struct exception_table_entry *fixup;
+#ifdef CONFIG_SMP
+		/* Unlock the atomic lock. */
+		int *lock_ptr = (int *)(regs->regs[ATOMIC_LOCK_REG]);
+		__atomic_fault_unlock(lock_ptr);
+#endif
+		fixup = search_exception_tables(pc);
+		if (!fixup)
+			ics_panic("ICS atomic fault not in table:"
+				  " PC %#lx, fault %d", pc, fault_num);
+		regs->pc = fixup->fixup;
+		regs->ex1 = PL_ICS_EX1(KERNEL_PL, 0);
+	}
+
+	/*
+	 * NOTE: the one other type of access that might bring us here
+	 * are the memory ops in __tns_atomic_acquire/__tns_atomic_release,
+	 * but we don't have to check specially for them since we can
+	 * always safely return to the address of the fault and retry,
+	 * since no separate atomic locks are involved.
+	 */
+
+	/*
+	 * Now that we have released the atomic lock (if necessary),
+	 * it's safe to spin if the PTE that caused the fault was migrating.
+	 */
+	if (fault_num == INT_DTLB_ACCESS)
+		write = 1;
+	if (handle_migrating_pte(pgd, fault_num, address, 1, write))
+		return state;
+
+	/* Return zero so that we continue on with normal fault handling. */
+	state.retval = 0;
+	return state;
+}
+
+#endif /* !__tilegx__ */
+
+/*
+ * This routine handles page faults.  It determines the address, and the
+ * problem, and then passes it handle_page_fault() for normal DTLB and
+ * ITLB issues, and for DMA or SN processor faults when we are in user
+ * space.  For the latter, if we're in kernel mode, we just save the
+ * interrupt away appropriately and return immediately.  We can't do
+ * page faults for user code while in kernel mode.
+ */
+void do_page_fault(struct pt_regs *regs, int fault_num,
+		   unsigned long address, unsigned long write)
+{
+	int is_page_fault;
+
+	/* This case should have been handled by do_page_fault_ics(). */
+	BUG_ON(write & ~1);
+
+#if CHIP_HAS_TILE_DMA()
+	/*
+	 * If it's a DMA fault, suspend the transfer while we're
+	 * handling the miss; we'll restart after it's handled.  If we
+	 * don't suspend, it's possible that this process could swap
+	 * out and back in, and restart the engine since the DMA is
+	 * still 'running'.
+	 */
+	if (fault_num == INT_DMATLB_MISS ||
+	    fault_num == INT_DMATLB_ACCESS ||
+	    fault_num == INT_DMATLB_MISS_DWNCL ||
+	    fault_num == INT_DMATLB_ACCESS_DWNCL) {
+		__insn_mtspr(SPR_DMA_CTR, SPR_DMA_CTR__SUSPEND_MASK);
+		while (__insn_mfspr(SPR_DMA_USER_STATUS) &
+		       SPR_DMA_STATUS__BUSY_MASK)
+			;
+	}
+#endif
+
+	/* Validate fault num and decide if this is a first-time page fault. */
+	switch (fault_num) {
+	case INT_ITLB_MISS:
+	case INT_DTLB_MISS:
+#if CHIP_HAS_TILE_DMA()
+	case INT_DMATLB_MISS:
+	case INT_DMATLB_MISS_DWNCL:
+#endif
+#if CHIP_HAS_SN_PROC()
+	case INT_SNITLB_MISS:
+	case INT_SNITLB_MISS_DWNCL:
+#endif
+		is_page_fault = 1;
+		break;
+
+	case INT_DTLB_ACCESS:
+#if CHIP_HAS_TILE_DMA()
+	case INT_DMATLB_ACCESS:
+	case INT_DMATLB_ACCESS_DWNCL:
+#endif
+		is_page_fault = 0;
+		break;
+
+	default:
+		panic("Bad fault number %d in do_page_fault", fault_num);
+	}
+
+	if (EX1_PL(regs->ex1) != USER_PL) {
+		struct async_tlb *async;
+		switch (fault_num) {
+#if CHIP_HAS_TILE_DMA()
+		case INT_DMATLB_MISS:
+		case INT_DMATLB_ACCESS:
+		case INT_DMATLB_MISS_DWNCL:
+		case INT_DMATLB_ACCESS_DWNCL:
+			async = &current->thread.dma_async_tlb;
+			break;
+#endif
+#if CHIP_HAS_SN_PROC()
+		case INT_SNITLB_MISS:
+		case INT_SNITLB_MISS_DWNCL:
+			async = &current->thread.sn_async_tlb;
+			break;
+#endif
+		default:
+			async = NULL;
+		}
+		if (async) {
+
+			/*
+			 * No vmalloc check required, so we can allow
+			 * interrupts immediately at this point.
+			 */
+			local_irq_enable();
+
+			set_thread_flag(TIF_ASYNC_TLB);
+			if (async->fault_num != 0) {
+				panic("Second async fault %d;"
+				      " old fault was %d (%#lx/%ld)",
+				      fault_num, async->fault_num,
+				      address, write);
+			}
+			BUG_ON(fault_num == 0);
+			async->fault_num = fault_num;
+			async->is_fault = is_page_fault;
+			async->is_write = write;
+			async->address = address;
+			return;
+		}
+	}
+
+	handle_page_fault(regs, fault_num, is_page_fault, address, write);
+}
+
+
+#if CHIP_HAS_TILE_DMA() || CHIP_HAS_SN_PROC()
+/*
+ * Check an async_tlb structure to see if a deferred fault is waiting,
+ * and if so pass it to the page-fault code.
+ */
+static void handle_async_page_fault(struct pt_regs *regs,
+				    struct async_tlb *async)
+{
+	if (async->fault_num) {
+		/*
+		 * Clear async->fault_num before calling the page-fault
+		 * handler so that if we re-interrupt before returning
+		 * from the function we have somewhere to put the
+		 * information from the new interrupt.
+		 */
+		int fault_num = async->fault_num;
+		async->fault_num = 0;
+		handle_page_fault(regs, fault_num, async->is_fault,
+				  async->address, async->is_write);
+	}
+}
+#endif /* CHIP_HAS_TILE_DMA() || CHIP_HAS_SN_PROC() */
+
+
+/*
+ * This routine effectively re-issues asynchronous page faults
+ * when we are returning to user space.
+ */
+void do_async_page_fault(struct pt_regs *regs)
+{
+	/*
+	 * Clear thread flag early.  If we re-interrupt while processing
+	 * code here, we will reset it and recall this routine before
+	 * returning to user space.
+	 */
+	clear_thread_flag(TIF_ASYNC_TLB);
+
+#if CHIP_HAS_TILE_DMA()
+	handle_async_page_fault(regs, &current->thread.dma_async_tlb);
+#endif
+#if CHIP_HAS_SN_PROC()
+	handle_async_page_fault(regs, &current->thread.sn_async_tlb);
+#endif
+}
+
+void vmalloc_sync_all(void)
+{
+#ifdef __tilegx__
+	/* Currently all L1 kernel pmd's are static and shared. */
+	BUG_ON(pgd_index(VMALLOC_END) != pgd_index(VMALLOC_START));
+#else
+	/*
+	 * Note that races in the updates of insync and start aren't
+	 * problematic: insync can only get set bits added, and updates to
+	 * start are only improving performance (without affecting correctness
+	 * if undone).
+	 */
+	static DECLARE_BITMAP(insync, PTRS_PER_PGD);
+	static unsigned long start = PAGE_OFFSET;
+	unsigned long address;
+
+	BUILD_BUG_ON(PAGE_OFFSET & ~PGDIR_MASK);
+	for (address = start; address >= PAGE_OFFSET; address += PGDIR_SIZE) {
+		if (!test_bit(pgd_index(address), insync)) {
+			unsigned long flags;
+			struct list_head *pos;
+
+			spin_lock_irqsave(&pgd_lock, flags);
+			list_for_each(pos, &pgd_list)
+				if (!vmalloc_sync_one(list_to_pgd(pos),
+								address)) {
+					/* Must be at first entry in list. */
+					BUG_ON(pos != pgd_list.next);
+					break;
+				}
+			spin_unlock_irqrestore(&pgd_lock, flags);
+			if (pos != pgd_list.next)
+				set_bit(pgd_index(address), insync);
+		}
+		if (address == start && test_bit(pgd_index(address), insync))
+			start = address + PGDIR_SIZE;
+	}
+#endif
+}
diff --git a/arch/tile/mm/highmem.c b/arch/tile/mm/highmem.c
new file mode 100644
index 0000000..1fcecc5
--- /dev/null
+++ b/arch/tile/mm/highmem.c
@@ -0,0 +1,328 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/highmem.h>
+#include <linux/module.h>
+#include <linux/pagemap.h>
+#include <asm/homecache.h>
+
+#define kmap_get_pte(vaddr) \
+	pte_offset_kernel(pmd_offset(pud_offset(pgd_offset_k(vaddr), (vaddr)),\
+		(vaddr)), (vaddr))
+
+
+void *kmap(struct page *page)
+{
+	void *kva;
+	unsigned long flags;
+	pte_t *ptep;
+
+	might_sleep();
+	if (!PageHighMem(page))
+		return page_address(page);
+	kva = kmap_high(page);
+
+	/*
+	 * Rewrite the PTE under the lock.  This ensures that the page
+	 * is not currently migrating.
+	 */
+	ptep = kmap_get_pte((unsigned long)kva);
+	flags = homecache_kpte_lock();
+	set_pte_at(&init_mm, kva, ptep, mk_pte(page, page_to_kpgprot(page)));
+	homecache_kpte_unlock(flags);
+
+	return kva;
+}
+EXPORT_SYMBOL(kmap);
+
+void kunmap(struct page *page)
+{
+	if (in_interrupt())
+		BUG();
+	if (!PageHighMem(page))
+		return;
+	kunmap_high(page);
+}
+EXPORT_SYMBOL(kunmap);
+
+static void debug_kmap_atomic_prot(enum km_type type)
+{
+#ifdef CONFIG_DEBUG_HIGHMEM
+	static unsigned warn_count = 10;
+
+	if (unlikely(warn_count == 0))
+		return;
+
+	if (unlikely(in_interrupt())) {
+		if (in_irq()) {
+			if (type != KM_IRQ0 && type != KM_IRQ1 &&
+			    type != KM_BIO_SRC_IRQ &&
+			    /* type != KM_BIO_DST_IRQ && */
+			    type != KM_BOUNCE_READ) {
+				WARN_ON(1);
+				warn_count--;
+			}
+		} else if (!irqs_disabled()) {	/* softirq */
+			if (type != KM_IRQ0 && type != KM_IRQ1 &&
+			    type != KM_SOFTIRQ0 && type != KM_SOFTIRQ1 &&
+			    type != KM_SKB_SUNRPC_DATA &&
+			    type != KM_SKB_DATA_SOFTIRQ &&
+			    type != KM_BOUNCE_READ) {
+				WARN_ON(1);
+				warn_count--;
+			}
+		}
+	}
+
+	if (type == KM_IRQ0 || type == KM_IRQ1 || type == KM_BOUNCE_READ ||
+	    type == KM_BIO_SRC_IRQ /* || type == KM_BIO_DST_IRQ */) {
+		if (!irqs_disabled()) {
+			WARN_ON(1);
+			warn_count--;
+		}
+	} else if (type == KM_SOFTIRQ0 || type == KM_SOFTIRQ1) {
+		if (irq_count() == 0 && !irqs_disabled()) {
+			WARN_ON(1);
+			warn_count--;
+		}
+	}
+#endif
+}
+
+/*
+ * Describe a single atomic mapping of a page on a given cpu at a
+ * given address, and allow it to be linked into a list.
+ */
+struct atomic_mapped_page {
+	struct list_head list;
+	struct page *page;
+	int cpu;
+	unsigned long va;
+};
+
+static spinlock_t amp_lock = __SPIN_LOCK_UNLOCKED(&amp_lock);
+static struct list_head amp_list = LIST_HEAD_INIT(amp_list);
+
+/*
+ * Combining this structure with a per-cpu declaration lets us give
+ * each cpu an atomic_mapped_page structure per type.
+ */
+struct kmap_amps {
+	struct atomic_mapped_page per_type[KM_TYPE_NR];
+};
+DEFINE_PER_CPU(struct kmap_amps, amps);
+
+/*
+ * Add a page and va, on this cpu, to the list of kmap_atomic pages,
+ * and write the new pte to memory.  Writing the new PTE under the
+ * lock guarantees that it is either on the list before migration starts
+ * (if we won the race), or set_pte() sets the migrating bit in the PTE
+ * (if we lost the race).  And doing it under the lock guarantees
+ * that when kmap_atomic_fix_one_pte() comes along, it finds a valid
+ * PTE in memory, iff the mapping is still on the amp_list.
+ *
+ * Finally, doing it under the lock lets us safely examine the page
+ * to see if it is immutable or not, for the generic kmap_atomic() case.
+ * If we examine it earlier we are exposed to a race where it looks
+ * writable earlier, but becomes immutable before we write the PTE.
+ */
+static void kmap_atomic_register(struct page *page, enum km_type type,
+				 unsigned long va, pte_t *ptep, pte_t pteval)
+{
+	unsigned long flags;
+	struct atomic_mapped_page *amp;
+
+	flags = homecache_kpte_lock();
+	spin_lock(&amp_lock);
+
+	/* With interrupts disabled, now fill in the per-cpu info. */
+	amp = &__get_cpu_var(amps).per_type[type];
+	amp->page = page;
+	amp->cpu = smp_processor_id();
+	amp->va = va;
+
+	/* For generic kmap_atomic(), choose the PTE writability now. */
+	if (!pte_read(pteval))
+		pteval = mk_pte(page, page_to_kpgprot(page));
+
+	list_add(&amp->list, &amp_list);
+	set_pte(ptep, pteval);
+	arch_flush_lazy_mmu_mode();
+
+	spin_unlock(&amp_lock);
+	homecache_kpte_unlock(flags);
+}
+
+/*
+ * Remove a page and va, on this cpu, from the list of kmap_atomic pages.
+ * Linear-time search, but we count on the lists being short.
+ * We don't need to adjust the PTE under the lock (as opposed to the
+ * kmap_atomic_register() case), since we're just unconditionally
+ * zeroing the PTE after it's off the list.
+ */
+static void kmap_atomic_unregister(struct page *page, unsigned long va)
+{
+	unsigned long flags;
+	struct atomic_mapped_page *amp;
+	int cpu = smp_processor_id();
+	spin_lock_irqsave(&amp_lock, flags);
+	list_for_each_entry(amp, &amp_list, list) {
+		if (amp->page == page && amp->cpu == cpu && amp->va == va)
+			break;
+	}
+	BUG_ON(&amp->list == &amp_list);
+	list_del(&amp->list);
+	spin_unlock_irqrestore(&amp_lock, flags);
+}
+
+/* Helper routine for kmap_atomic_fix_kpte(), below. */
+static void kmap_atomic_fix_one_kpte(struct atomic_mapped_page *amp,
+				     int finished)
+{
+	pte_t *ptep = kmap_get_pte(amp->va);
+	if (!finished) {
+		set_pte(ptep, pte_mkmigrate(*ptep));
+		flush_remote(0, 0, NULL, amp->va, PAGE_SIZE, PAGE_SIZE,
+			     cpumask_of(amp->cpu), NULL, 0);
+	} else {
+		/*
+		 * Rewrite a default kernel PTE for this page.
+		 * We rely on the fact that set_pte() writes the
+		 * present+migrating bits last.
+		 */
+		pte_t pte = mk_pte(amp->page, page_to_kpgprot(amp->page));
+		set_pte(ptep, pte);
+	}
+}
+
+/*
+ * This routine is a helper function for homecache_fix_kpte(); see
+ * its comments for more information on the "finished" argument here.
+ *
+ * Note that we hold the lock while doing the remote flushes, which
+ * will stall any unrelated cpus trying to do kmap_atomic operations.
+ * We could just update the PTEs under the lock, and save away copies
+ * of the structs (or just the va+cpu), then flush them after we
+ * release the lock, but it seems easier just to do it all under the lock.
+ */
+void kmap_atomic_fix_kpte(struct page *page, int finished)
+{
+	struct atomic_mapped_page *amp;
+	unsigned long flags;
+	spin_lock_irqsave(&amp_lock, flags);
+	list_for_each_entry(amp, &amp_list, list) {
+		if (amp->page == page)
+			kmap_atomic_fix_one_kpte(amp, finished);
+	}
+	spin_unlock_irqrestore(&amp_lock, flags);
+}
+
+/*
+ * kmap_atomic/kunmap_atomic is significantly faster than kmap/kunmap
+ * because the kmap code must perform a global TLB invalidation when
+ * the kmap pool wraps.
+ *
+ * Note that they may be slower than on x86 (etc.) because unlike on
+ * those platforms, we do have to take a global lock to map and unmap
+ * pages on Tile (see above).
+ *
+ * When holding an atomic kmap is is not legal to sleep, so atomic
+ * kmaps are appropriate for short, tight code paths only.
+ */
+void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
+{
+	enum fixed_addresses idx;
+	unsigned long vaddr;
+	pte_t *pte;
+
+	/* even !CONFIG_PREEMPT needs this, for in_atomic in do_page_fault */
+	pagefault_disable();
+
+	/* Avoid icache flushes by disallowing atomic executable mappings. */
+	BUG_ON(pte_exec(prot));
+
+	if (!PageHighMem(page))
+		return page_address(page);
+
+	debug_kmap_atomic_prot(type);
+
+	idx = type + KM_TYPE_NR*smp_processor_id();
+	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
+	pte = kmap_get_pte(vaddr);
+	BUG_ON(!pte_none(*pte));
+
+	/* Register that this page is mapped atomically on this cpu. */
+	kmap_atomic_register(page, type, vaddr, pte, mk_pte(page, prot));
+
+	return (void *)vaddr;
+}
+EXPORT_SYMBOL(kmap_atomic_prot);
+
+void *kmap_atomic(struct page *page, enum km_type type)
+{
+	/* PAGE_NONE is a magic value that tells us to check immutability. */
+	return kmap_atomic_prot(page, type, PAGE_NONE);
+}
+EXPORT_SYMBOL(kmap_atomic);
+
+void kunmap_atomic(void *kvaddr, enum km_type type)
+{
+	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
+	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();
+
+	/*
+	 * Force other mappings to Oops if they try to access this pte without
+	 * first remapping it.  Keeping stale mappings around is a bad idea.
+	 */
+	if (vaddr == __fix_to_virt(FIX_KMAP_BEGIN+idx)) {
+		pte_t *pte = kmap_get_pte(vaddr);
+		pte_t pteval = *pte;
+		BUG_ON(!pte_present(pteval) && !pte_migrating(pteval));
+		kmap_atomic_unregister(pte_page(pteval), vaddr);
+		kpte_clear_flush(pte, vaddr);
+	} else {
+		/* Must be a lowmem page */
+		BUG_ON(vaddr < PAGE_OFFSET);
+		BUG_ON(vaddr >= (unsigned long)high_memory);
+	}
+
+	arch_flush_lazy_mmu_mode();
+	pagefault_enable();
+}
+EXPORT_SYMBOL(kunmap_atomic);
+
+/*
+ * This API is supposed to allow us to map memory without a "struct page".
+ * Currently we don't support this, though this may change in the future.
+ */
+void *kmap_atomic_pfn(unsigned long pfn, enum km_type type)
+{
+	return kmap_atomic(pfn_to_page(pfn), type);
+}
+void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
+{
+	return kmap_atomic_prot(pfn_to_page(pfn), type, prot);
+}
+
+struct page *kmap_atomic_to_page(void *ptr)
+{
+	pte_t *pte;
+	unsigned long vaddr = (unsigned long)ptr;
+
+	if (vaddr < FIXADDR_START)
+		return virt_to_page(ptr);
+
+	pte = kmap_get_pte(vaddr);
+	return pte_page(*pte);
+}
diff --git a/arch/tile/mm/homecache.c b/arch/tile/mm/homecache.c
new file mode 100644
index 0000000..52feb77
--- /dev/null
+++ b/arch/tile/mm/homecache.c
@@ -0,0 +1,445 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * This code maintains the "home" for each page in the system.
+ */
+
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+#include <linux/bootmem.h>
+#include <linux/rmap.h>
+#include <linux/pagemap.h>
+#include <linux/mutex.h>
+#include <linux/interrupt.h>
+#include <linux/sysctl.h>
+#include <linux/pagevec.h>
+#include <linux/ptrace.h>
+#include <linux/timex.h>
+#include <linux/cache.h>
+#include <linux/smp.h>
+
+#include <asm/page.h>
+#include <asm/sections.h>
+#include <asm/tlbflush.h>
+#include <asm/pgalloc.h>
+#include <asm/homecache.h>
+
+#include "migrate.h"
+
+
+#if CHIP_HAS_COHERENT_LOCAL_CACHE()
+
+/*
+ * The noallocl2 option suppresses all use of the L2 cache to cache
+ * locally from a remote home.  There's no point in using it if we
+ * don't have coherent local caching, though.
+ */
+int __write_once noallocl2;
+static int __init set_noallocl2(char *str)
+{
+	noallocl2 = 1;
+	return 0;
+}
+early_param("noallocl2", set_noallocl2);
+
+#else
+
+#define noallocl2 0
+
+#endif
+
+
+
+/* Provide no-op versions of these routines to keep flush_remote() cleaner. */
+#define mark_caches_evicted_start() 0
+#define mark_caches_evicted_finish(mask, timestamp) do {} while (0)
+
+
+
+
+/*
+ * Update the irq_stat for cpus that we are going to interrupt
+ * with TLB or cache flushes.  Also handle removing dataplane cpus
+ * from the TLB flush set, and setting dataplane_tlb_state instead.
+ */
+static void hv_flush_update(const struct cpumask *cache_cpumask,
+			    struct cpumask *tlb_cpumask,
+			    unsigned long tlb_va, unsigned long tlb_length,
+			    HV_Remote_ASID *asids, int asidcount)
+{
+	struct cpumask mask;
+	int i, cpu;
+
+	cpumask_clear(&mask);
+	if (cache_cpumask)
+		cpumask_or(&mask, &mask, cache_cpumask);
+	if (tlb_cpumask && tlb_length) {
+		cpumask_or(&mask, &mask, tlb_cpumask);
+	}
+
+	for (i = 0; i < asidcount; ++i)
+		cpumask_set_cpu(asids[i].y * smp_width + asids[i].x, &mask);
+
+	/*
+	 * Don't bother to update atomically; losing a count
+	 * here is not that critical.
+	 */
+	for_each_cpu(cpu, &mask)
+		++per_cpu(irq_stat, cpu).irq_hv_flush_count;
+}
+
+/*
+ * This wrapper function around hv_flush_remote() does several things:
+ *
+ *  - Provides a return value error-checking panic path, since
+ *    there's never any good reason for hv_flush_remote() to fail.
+ *  - Accepts a 32-bit PFN rather than a 64-bit PA, which generally
+ *    is the type that Linux wants to pass around anyway.
+ *  - Centralizes the mark_caches_evicted() handling.
+ *  - Canonicalizes that lengths of zero make cpumasks NULL.
+ *  - Handles deferring TLB flushes for dataplane tiles.
+ *  - Tracks remote interrupts in the per-cpu irq_cpustat_t.
+ *
+ * Note that we have to wait until the cache flush completes before
+ * updating the per-cpu last_cache_flush word, since otherwise another
+ * concurrent flush can race, conclude the flush has already
+ * completed, and start to use the page while it's still dirty
+ * remotely (running concurrently with the actual evict, presumably).
+ */
+void flush_remote(unsigned long cache_pfn, unsigned long cache_control,
+		  const struct cpumask *cache_cpumask_orig,
+		  HV_VirtAddr tlb_va, unsigned long tlb_length,
+		  unsigned long tlb_pgsize,
+		  const struct cpumask *tlb_cpumask_orig,
+		  HV_Remote_ASID *asids, int asidcount)
+{
+	int rc;
+	int timestamp = 0;  /* happy compiler */
+	struct cpumask cache_cpumask_copy, tlb_cpumask_copy;
+	struct cpumask *cache_cpumask, *tlb_cpumask;
+	HV_PhysAddr cache_pa;
+	char cache_buf[NR_CPUS*5], tlb_buf[NR_CPUS*5];
+
+	mb();   /* provided just to simplify "magic hypervisor" mode */
+
+	/*
+	 * Canonicalize and copy the cpumasks.
+	 */
+	if (cache_cpumask_orig && cache_control) {
+		cpumask_copy(&cache_cpumask_copy, cache_cpumask_orig);
+		cache_cpumask = &cache_cpumask_copy;
+	} else {
+		cpumask_clear(&cache_cpumask_copy);
+		cache_cpumask = NULL;
+	}
+	if (cache_cpumask == NULL)
+		cache_control = 0;
+	if (tlb_cpumask_orig && tlb_length) {
+		cpumask_copy(&tlb_cpumask_copy, tlb_cpumask_orig);
+		tlb_cpumask = &tlb_cpumask_copy;
+	} else {
+		cpumask_clear(&tlb_cpumask_copy);
+		tlb_cpumask = NULL;
+	}
+
+	hv_flush_update(cache_cpumask, tlb_cpumask, tlb_va, tlb_length,
+			asids, asidcount);
+	cache_pa = (HV_PhysAddr)cache_pfn << PAGE_SHIFT;
+	if (cache_control & HV_FLUSH_EVICT_L2)
+		timestamp = mark_caches_evicted_start();
+	rc = hv_flush_remote(cache_pa, cache_control,
+			     cpumask_bits(cache_cpumask),
+			     tlb_va, tlb_length, tlb_pgsize,
+			     cpumask_bits(tlb_cpumask),
+			     asids, asidcount);
+	if (cache_control & HV_FLUSH_EVICT_L2)
+		mark_caches_evicted_finish(cache_cpumask, timestamp);
+	if (rc == 0)
+		return;
+	cpumask_scnprintf(cache_buf, sizeof(cache_buf), &cache_cpumask_copy);
+	cpumask_scnprintf(tlb_buf, sizeof(tlb_buf), &tlb_cpumask_copy);
+
+	printk("hv_flush_remote(%#llx, %#lx, %p [%s],"
+	       " %#lx, %#lx, %#lx, %p [%s], %p, %d) = %d\n",
+	       cache_pa, cache_control, cache_cpumask, cache_buf,
+	       (unsigned long)tlb_va, tlb_length, tlb_pgsize,
+	       tlb_cpumask, tlb_buf,
+	       asids, asidcount, rc);
+	if (asidcount > 0) {
+		int i;
+		printk(" asids:");
+		for (i = 0; i < asidcount; ++i)
+			printk(" %d,%d,%d",
+			       asids[i].x, asids[i].y, asids[i].asid);
+		printk("\n");
+	}
+	panic("Unsafe to continue.");
+}
+
+void homecache_evict(const struct cpumask *mask)
+{
+	flush_remote(0, HV_FLUSH_EVICT_L2, mask, 0, 0, 0, NULL, NULL, 0);
+}
+
+/* Return a mask of the cpus whose caches currently own these pages. */
+static void homecache_mask(struct page *page, int pages,
+			   struct cpumask *home_mask)
+{
+	int i;
+	cpumask_clear(home_mask);
+	for (i = 0; i < pages; ++i) {
+		int home = page_home(&page[i]);
+		if (home == PAGE_HOME_IMMUTABLE ||
+		    home == PAGE_HOME_INCOHERENT) {
+			cpumask_copy(home_mask, cpu_possible_mask);
+			return;
+		}
+#if CHIP_HAS_CBOX_HOME_MAP()
+		if (home == PAGE_HOME_HASH) {
+			cpumask_or(home_mask, home_mask, &hash_for_home_map);
+			continue;
+		}
+#endif
+		if (home == PAGE_HOME_UNCACHED)
+			continue;
+		BUG_ON(home < 0 || home >= NR_CPUS);
+		cpumask_set_cpu(home, home_mask);
+	}
+}
+
+/*
+ * Return the passed length, or zero if it's long enough that we
+ * believe we should evict the whole L2 cache.
+ */
+static unsigned long cache_flush_length(unsigned long length)
+{
+	return (length >= CHIP_L2_CACHE_SIZE()) ? HV_FLUSH_EVICT_L2 : length;
+}
+
+/* On the simulator, confirm lines have been evicted everywhere. */
+static void validate_lines_evicted(unsigned long pfn, size_t length)
+{
+	sim_syscall(SIM_SYSCALL_VALIDATE_LINES_EVICTED,
+		    (HV_PhysAddr)pfn << PAGE_SHIFT, length);
+}
+
+/* Flush a page out of whatever cache(s) it is in. */
+void homecache_flush_cache(struct page *page, int order)
+{
+	int pages = 1 << order;
+	int length = cache_flush_length(pages * PAGE_SIZE);
+	unsigned long pfn = page_to_pfn(page);
+	struct cpumask home_mask;
+
+	homecache_mask(page, pages, &home_mask);
+	flush_remote(pfn, length, &home_mask, 0, 0, 0, NULL, NULL, 0);
+	validate_lines_evicted(pfn, pages * PAGE_SIZE);
+}
+
+
+/* Report the home corresponding to a given PTE. */
+static int pte_to_home(pte_t pte)
+{
+	if (hv_pte_get_nc(pte))
+		return PAGE_HOME_IMMUTABLE;
+	switch (hv_pte_get_mode(pte)) {
+	case HV_PTE_MODE_CACHE_TILE_L3:
+		return get_remote_cache_cpu(pte);
+	case HV_PTE_MODE_CACHE_NO_L3:
+		return PAGE_HOME_INCOHERENT;
+	case HV_PTE_MODE_UNCACHED:
+		return PAGE_HOME_UNCACHED;
+#if CHIP_HAS_CBOX_HOME_MAP()
+	case HV_PTE_MODE_CACHE_HASH_L3:
+		return PAGE_HOME_HASH;
+#endif
+	}
+	panic("Bad PTE %#llx\n", pte.val);
+}
+
+/* Update the home of a PTE if necessary (can also be used for a pgprot_t). */
+pte_t pte_set_home(pte_t pte, int home)
+{
+	/* Check for non-linear file mapping "PTEs" and pass them through. */
+	if (pte_file(pte))
+		return pte;
+
+#if CHIP_HAS_MMIO()
+	/* Check for MMIO mappings and pass them through. */
+	if (hv_pte_get_mode(pte) == HV_PTE_MODE_MMIO)
+		return pte;
+#endif
+
+
+	/*
+	 * Only immutable pages get NC mappings.  If we have a
+	 * non-coherent PTE, but the underlying page is not
+	 * immutable, it's likely the result of a forced
+	 * caching setting running up against ptrace setting
+	 * the page to be writable underneath.  In this case,
+	 * just keep the PTE coherent.
+	 */
+	if (hv_pte_get_nc(pte) && home != PAGE_HOME_IMMUTABLE) {
+		pte = hv_pte_clear_nc(pte);
+		printk("non-immutable page incoherently referenced: %#llx\n",
+		       pte.val);
+	}
+
+	switch (home) {
+
+	case PAGE_HOME_UNCACHED:
+		pte = hv_pte_set_mode(pte, HV_PTE_MODE_UNCACHED);
+		break;
+
+	case PAGE_HOME_INCOHERENT:
+		pte = hv_pte_set_mode(pte, HV_PTE_MODE_CACHE_NO_L3);
+		break;
+
+	case PAGE_HOME_IMMUTABLE:
+		/*
+		 * We could home this page anywhere, since it's immutable,
+		 * but by default just home it to follow "hash_default".
+		 */
+		BUG_ON(hv_pte_get_writable(pte));
+		if (pte_get_forcecache(pte)) {
+			/* Upgrade "force any cpu" to "No L3" for immutable. */
+			if (hv_pte_get_mode(pte) == HV_PTE_MODE_CACHE_TILE_L3
+			    && pte_get_anyhome(pte)) {
+				pte = hv_pte_set_mode(pte,
+						      HV_PTE_MODE_CACHE_NO_L3);
+			}
+		} else
+#if CHIP_HAS_CBOX_HOME_MAP()
+		if (hash_default)
+			pte = hv_pte_set_mode(pte, HV_PTE_MODE_CACHE_HASH_L3);
+		else
+#endif
+			pte = hv_pte_set_mode(pte, HV_PTE_MODE_CACHE_NO_L3);
+		pte = hv_pte_set_nc(pte);
+		break;
+
+#if CHIP_HAS_CBOX_HOME_MAP()
+	case PAGE_HOME_HASH:
+		pte = hv_pte_set_mode(pte, HV_PTE_MODE_CACHE_HASH_L3);
+		break;
+#endif
+
+	default:
+		BUG_ON(home < 0 || home >= NR_CPUS ||
+		       !cpu_is_valid_lotar(home));
+		pte = hv_pte_set_mode(pte, HV_PTE_MODE_CACHE_TILE_L3);
+		pte = set_remote_cache_cpu(pte, home);
+		break;
+	}
+
+#if CHIP_HAS_NC_AND_NOALLOC_BITS()
+	if (noallocl2)
+		pte = hv_pte_set_no_alloc_l2(pte);
+
+	/* Simplify "no local and no l3" to "uncached" */
+	if (hv_pte_get_no_alloc_l2(pte) && hv_pte_get_no_alloc_l1(pte) &&
+	    hv_pte_get_mode(pte) == HV_PTE_MODE_CACHE_NO_L3) {
+		pte = hv_pte_set_mode(pte, HV_PTE_MODE_UNCACHED);
+	}
+#endif
+
+	/* Checking this case here gives a better panic than from the hv. */
+	BUG_ON(hv_pte_get_mode(pte) == 0);
+
+	return pte;
+}
+
+/*
+ * The routines in this section are the "static" versions of the normal
+ * dynamic homecaching routines; they just set the home cache
+ * of a kernel page once, and require a full-chip cache/TLB flush,
+ * so they're not suitable for anything but infrequent use.
+ */
+
+#if CHIP_HAS_CBOX_HOME_MAP()
+static inline int initial_page_home(void) { return PAGE_HOME_HASH; }
+#else
+static inline int initial_page_home(void) { return 0; }
+#endif
+
+int page_home(struct page *page)
+{
+	if (PageHighMem(page)) {
+		return initial_page_home();
+	} else {
+		unsigned long kva = (unsigned long)page_address(page);
+		return pte_to_home(*virt_to_pte(NULL, kva));
+	}
+}
+
+void homecache_change_page_home(struct page *page, int order, int home)
+{
+	int i, pages = (1 << order);
+	unsigned long kva;
+
+	BUG_ON(PageHighMem(page));
+	BUG_ON(page_count(page) > 1);
+	BUG_ON(page_mapcount(page) != 0);
+	kva = (unsigned long) page_address(page);
+	flush_remote(0, HV_FLUSH_EVICT_L2, &cpu_cacheable_map,
+		     kva, pages * PAGE_SIZE, PAGE_SIZE, cpu_online_mask,
+		     NULL, 0);
+
+	for (i = 0; i < pages; ++i, kva += PAGE_SIZE) {
+		pte_t *ptep = virt_to_pte(NULL, kva);
+		pte_t pteval = *ptep;
+		BUG_ON(!pte_present(pteval) || pte_huge(pteval));
+		*ptep = pte_set_home(pteval, home);
+	}
+}
+
+struct page *homecache_alloc_pages(gfp_t gfp_mask,
+				   unsigned int order, int home)
+{
+	struct page *page;
+	BUG_ON(gfp_mask & __GFP_HIGHMEM);   /* must be lowmem */
+	page = alloc_pages(gfp_mask, order);
+	if (page)
+		homecache_change_page_home(page, order, home);
+	return page;
+}
+
+struct page *homecache_alloc_pages_node(int nid, gfp_t gfp_mask,
+					unsigned int order, int home)
+{
+	struct page *page;
+	BUG_ON(gfp_mask & __GFP_HIGHMEM);   /* must be lowmem */
+	page = alloc_pages_node(nid, gfp_mask, order);
+	if (page)
+		homecache_change_page_home(page, order, home);
+	return page;
+}
+
+void homecache_free_pages(unsigned long addr, unsigned int order)
+{
+	struct page *page;
+
+	if (addr == 0)
+		return;
+
+	VM_BUG_ON(!virt_addr_valid((void *)addr));
+	page = virt_to_page((void *)addr);
+	if (put_page_testzero(page)) {
+		int pages = (1 << order);
+		homecache_change_page_home(page, order, initial_page_home());
+		while (pages--)
+			__free_page(page++);
+	}
+}
diff --git a/arch/tile/mm/hugetlbpage.c b/arch/tile/mm/hugetlbpage.c
new file mode 100644
index 0000000..c38570f
--- /dev/null
+++ b/arch/tile/mm/hugetlbpage.c
@@ -0,0 +1,343 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * TILE Huge TLB Page Support for Kernel.
+ * Taken from i386 hugetlb implementation:
+ * Copyright (C) 2002, Rohit Seth <rohit.seth@intel.com>
+ */
+
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/hugetlb.h>
+#include <linux/pagemap.h>
+#include <linux/smp_lock.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/sysctl.h>
+#include <linux/mman.h>
+#include <asm/tlb.h>
+#include <asm/tlbflush.h>
+
+pte_t *huge_pte_alloc(struct mm_struct *mm,
+		      unsigned long addr, unsigned long sz)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pte_t *pte = NULL;
+
+	/* We do not yet support multiple huge page sizes. */
+	BUG_ON(sz != PMD_SIZE);
+
+	pgd = pgd_offset(mm, addr);
+	pud = pud_alloc(mm, pgd, addr);
+	if (pud)
+		pte = (pte_t *) pmd_alloc(mm, pud, addr);
+	BUG_ON(pte && !pte_none(*pte) && !pte_huge(*pte));
+
+	return pte;
+}
+
+pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd = NULL;
+
+	pgd = pgd_offset(mm, addr);
+	if (pgd_present(*pgd)) {
+		pud = pud_offset(pgd, addr);
+		if (pud_present(*pud))
+			pmd = pmd_offset(pud, addr);
+	}
+	return (pte_t *) pmd;
+}
+
+#ifdef HUGETLB_TEST
+struct page *follow_huge_addr(struct mm_struct *mm, unsigned long address,
+			      int write)
+{
+	unsigned long start = address;
+	int length = 1;
+	int nr;
+	struct page *page;
+	struct vm_area_struct *vma;
+
+	vma = find_vma(mm, addr);
+	if (!vma || !is_vm_hugetlb_page(vma))
+		return ERR_PTR(-EINVAL);
+
+	pte = huge_pte_offset(mm, address);
+
+	/* hugetlb should be locked, and hence, prefaulted */
+	WARN_ON(!pte || pte_none(*pte));
+
+	page = &pte_page(*pte)[vpfn % (HPAGE_SIZE/PAGE_SIZE)];
+
+	WARN_ON(!PageHead(page));
+
+	return page;
+}
+
+int pmd_huge(pmd_t pmd)
+{
+	return 0;
+}
+
+int pud_huge(pud_t pud)
+{
+	return 0;
+}
+
+struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
+			     pmd_t *pmd, int write)
+{
+	return NULL;
+}
+
+#else
+
+struct page *follow_huge_addr(struct mm_struct *mm, unsigned long address,
+			      int write)
+{
+	return ERR_PTR(-EINVAL);
+}
+
+int pmd_huge(pmd_t pmd)
+{
+	return !!(pmd_val(pmd) & _PAGE_HUGE_PAGE);
+}
+
+int pud_huge(pud_t pud)
+{
+	return !!(pud_val(pud) & _PAGE_HUGE_PAGE);
+}
+
+struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
+			     pmd_t *pmd, int write)
+{
+	struct page *page;
+
+	page = pte_page(*(pte_t *)pmd);
+	if (page)
+		page += ((address & ~PMD_MASK) >> PAGE_SHIFT);
+	return page;
+}
+
+struct page *follow_huge_pud(struct mm_struct *mm, unsigned long address,
+			     pud_t *pud, int write)
+{
+	struct page *page;
+
+	page = pte_page(*(pte_t *)pud);
+	if (page)
+		page += ((address & ~PUD_MASK) >> PAGE_SHIFT);
+	return page;
+}
+
+int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep)
+{
+	return 0;
+}
+
+#endif
+
+#ifdef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
+static unsigned long hugetlb_get_unmapped_area_bottomup(struct file *file,
+		unsigned long addr, unsigned long len,
+		unsigned long pgoff, unsigned long flags)
+{
+	struct hstate *h = hstate_file(file);
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+	unsigned long start_addr;
+
+	if (len > mm->cached_hole_size) {
+		start_addr = mm->free_area_cache;
+	} else {
+		start_addr = TASK_UNMAPPED_BASE;
+		mm->cached_hole_size = 0;
+	}
+
+full_search:
+	addr = ALIGN(start_addr, huge_page_size(h));
+
+	for (vma = find_vma(mm, addr); ; vma = vma->vm_next) {
+		/* At this point:  (!vma || addr < vma->vm_end). */
+		if (TASK_SIZE - len < addr) {
+			/*
+			 * Start a new search - just in case we missed
+			 * some holes.
+			 */
+			if (start_addr != TASK_UNMAPPED_BASE) {
+				start_addr = TASK_UNMAPPED_BASE;
+				mm->cached_hole_size = 0;
+				goto full_search;
+			}
+			return -ENOMEM;
+		}
+		if (!vma || addr + len <= vma->vm_start) {
+			mm->free_area_cache = addr + len;
+			return addr;
+		}
+		if (addr + mm->cached_hole_size < vma->vm_start)
+			mm->cached_hole_size = vma->vm_start - addr;
+		addr = ALIGN(vma->vm_end, huge_page_size(h));
+	}
+}
+
+static unsigned long hugetlb_get_unmapped_area_topdown(struct file *file,
+		unsigned long addr0, unsigned long len,
+		unsigned long pgoff, unsigned long flags)
+{
+	struct hstate *h = hstate_file(file);
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma, *prev_vma;
+	unsigned long base = mm->mmap_base, addr = addr0;
+	unsigned long largest_hole = mm->cached_hole_size;
+	int first_time = 1;
+
+	/* don't allow allocations above current base */
+	if (mm->free_area_cache > base)
+		mm->free_area_cache = base;
+
+	if (len <= largest_hole) {
+		largest_hole = 0;
+		mm->free_area_cache  = base;
+	}
+try_again:
+	/* make sure it can fit in the remaining address space */
+	if (mm->free_area_cache < len)
+		goto fail;
+
+	/* either no address requested or cant fit in requested address hole */
+	addr = (mm->free_area_cache - len) & huge_page_mask(h);
+	do {
+		/*
+		 * Lookup failure means no vma is above this address,
+		 * i.e. return with success:
+		 */
+		vma = find_vma_prev(mm, addr, &prev_vma);
+		if (!vma) {
+			return addr;
+			break;
+		}
+
+		/*
+		 * new region fits between prev_vma->vm_end and
+		 * vma->vm_start, use it:
+		 */
+		if (addr + len <= vma->vm_start &&
+			    (!prev_vma || (addr >= prev_vma->vm_end))) {
+			/* remember the address as a hint for next time */
+			mm->cached_hole_size = largest_hole;
+			mm->free_area_cache = addr;
+			return addr;
+		} else {
+			/* pull free_area_cache down to the first hole */
+			if (mm->free_area_cache == vma->vm_end) {
+				mm->free_area_cache = vma->vm_start;
+				mm->cached_hole_size = largest_hole;
+			}
+		}
+
+		/* remember the largest hole we saw so far */
+		if (addr + largest_hole < vma->vm_start)
+			largest_hole = vma->vm_start - addr;
+
+		/* try just below the current vma->vm_start */
+		addr = (vma->vm_start - len) & huge_page_mask(h);
+
+	} while (len <= vma->vm_start);
+
+fail:
+	/*
+	 * if hint left us with no space for the requested
+	 * mapping then try again:
+	 */
+	if (first_time) {
+		mm->free_area_cache = base;
+		largest_hole = 0;
+		first_time = 0;
+		goto try_again;
+	}
+	/*
+	 * A failed mmap() very likely causes application failure,
+	 * so fall back to the bottom-up function here. This scenario
+	 * can happen with large stack limits and large mmap()
+	 * allocations.
+	 */
+	mm->free_area_cache = TASK_UNMAPPED_BASE;
+	mm->cached_hole_size = ~0UL;
+	addr = hugetlb_get_unmapped_area_bottomup(file, addr0,
+			len, pgoff, flags);
+
+	/*
+	 * Restore the topdown base:
+	 */
+	mm->free_area_cache = base;
+	mm->cached_hole_size = ~0UL;
+
+	return addr;
+}
+
+unsigned long hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags)
+{
+	struct hstate *h = hstate_file(file);
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+
+	if (len & ~huge_page_mask(h))
+		return -EINVAL;
+	if (len > TASK_SIZE)
+		return -ENOMEM;
+
+	if (flags & MAP_FIXED) {
+		if (prepare_hugepage_range(file, addr, len))
+			return -EINVAL;
+		return addr;
+	}
+
+	if (addr) {
+		addr = ALIGN(addr, huge_page_size(h));
+		vma = find_vma(mm, addr);
+		if (TASK_SIZE - len >= addr &&
+		    (!vma || addr + len <= vma->vm_start))
+			return addr;
+	}
+	if (current->mm->get_unmapped_area == arch_get_unmapped_area)
+		return hugetlb_get_unmapped_area_bottomup(file, addr, len,
+				pgoff, flags);
+	else
+		return hugetlb_get_unmapped_area_topdown(file, addr, len,
+				pgoff, flags);
+}
+
+static __init int setup_hugepagesz(char *opt)
+{
+	unsigned long ps = memparse(opt, &opt);
+	if (ps == PMD_SIZE) {
+		hugetlb_add_hstate(PMD_SHIFT - PAGE_SHIFT);
+	} else if (ps == PUD_SIZE) {
+		hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
+	} else {
+		printk(KERN_ERR "hugepagesz: Unsupported page size %lu M\n",
+			ps >> 20);
+		return 0;
+	}
+	return 1;
+}
+__setup("hugepagesz=", setup_hugepagesz);
+
+#endif /*HAVE_ARCH_HUGETLB_UNMAPPED_AREA*/
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
new file mode 100644
index 0000000..31b5c09
--- /dev/null
+++ b/arch/tile/mm/init.c
@@ -0,0 +1,1082 @@
+/*
+ * Copyright (C) 1995  Linus Torvalds
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/module.h>
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/ptrace.h>
+#include <linux/mman.h>
+#include <linux/mm.h>
+#include <linux/hugetlb.h>
+#include <linux/swap.h>
+#include <linux/smp.h>
+#include <linux/init.h>
+#include <linux/highmem.h>
+#include <linux/pagemap.h>
+#include <linux/poison.h>
+#include <linux/bootmem.h>
+#include <linux/slab.h>
+#include <linux/proc_fs.h>
+#include <linux/efi.h>
+#include <linux/memory_hotplug.h>
+#include <linux/uaccess.h>
+#include <asm/mmu_context.h>
+#include <asm/processor.h>
+#include <asm/system.h>
+#include <asm/pgtable.h>
+#include <asm/pgalloc.h>
+#include <asm/dma.h>
+#include <asm/fixmap.h>
+#include <asm/tlb.h>
+#include <asm/tlbflush.h>
+#include <asm/sections.h>
+#include <asm/setup.h>
+#include <asm/homecache.h>
+#include <hv/hypervisor.h>
+#include <arch/chip.h>
+
+#include "migrate.h"
+
+/*
+ * We could set FORCE_MAX_ZONEORDER to "(HPAGE_SHIFT - PAGE_SHIFT + 1)"
+ * in the Tile Kconfig, but this generates configure warnings.
+ * Do it here and force people to get it right to compile this file.
+ * The problem is that with 4KB small pages and 16MB huge pages,
+ * the default value doesn't allow us to group enough small pages
+ * together to make up a huge page.
+ */
+#if CONFIG_FORCE_MAX_ZONEORDER < HPAGE_SHIFT - PAGE_SHIFT + 1
+# error "Change FORCE_MAX_ZONEORDER in arch/tile/Kconfig to match page size"
+#endif
+
+#define clear_pgd(pmdptr) (*(pmdptr) = hv_pte(0))
+
+unsigned long VMALLOC_RESERVE = CONFIG_VMALLOC_RESERVE;
+
+DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
+
+/* Create an L2 page table */
+static pte_t * __init alloc_pte(void)
+{
+	return __alloc_bootmem(L2_KERNEL_PGTABLE_SIZE, HV_PAGE_TABLE_ALIGN, 0);
+}
+
+/*
+ * L2 page tables per controller.  We allocate these all at once from
+ * the bootmem allocator and store them here.  This saves on kernel L2
+ * page table memory, compared to allocating a full 64K page per L2
+ * page table, and also means that in cases where we use huge pages,
+ * we are guaranteed to later be able to shatter those huge pages and
+ * switch to using these page tables instead, without requiring
+ * further allocation.  Each l2_ptes[] entry points to the first page
+ * table for the first hugepage-size piece of memory on the
+ * controller; other page tables are just indexed directly, i.e. the
+ * L2 page tables are contiguous in memory for each controller.
+ */
+static pte_t *l2_ptes[MAX_NUMNODES];
+static int num_l2_ptes[MAX_NUMNODES];
+
+static void init_prealloc_ptes(int node, int pages)
+{
+	BUG_ON(pages & (HV_L2_ENTRIES-1));
+	if (pages) {
+		num_l2_ptes[node] = pages;
+		l2_ptes[node] = __alloc_bootmem(pages * sizeof(pte_t),
+						HV_PAGE_TABLE_ALIGN, 0);
+	}
+}
+
+pte_t *get_prealloc_pte(unsigned long pfn)
+{
+	int node = pfn_to_nid(pfn);
+	pfn &= ~(-1UL << (NR_PA_HIGHBIT_SHIFT - PAGE_SHIFT));
+	BUG_ON(node >= MAX_NUMNODES);
+	BUG_ON(pfn >= num_l2_ptes[node]);
+	return &l2_ptes[node][pfn];
+}
+
+/*
+ * What caching do we expect pages from the heap to have when
+ * they are allocated during bootup?  (Once we've installed the
+ * "real" swapper_pg_dir.)
+ */
+static int initial_heap_home(void)
+{
+#if CHIP_HAS_CBOX_HOME_MAP()
+	if (hash_default)
+		return PAGE_HOME_HASH;
+#endif
+	return smp_processor_id();
+}
+
+/*
+ * Place a pointer to an L2 page table in a middle page
+ * directory entry.
+ */
+static void __init assign_pte(pmd_t *pmd, pte_t *page_table)
+{
+	phys_addr_t pa = __pa(page_table);
+	unsigned long l2_ptfn = pa >> HV_LOG2_PAGE_TABLE_ALIGN;
+	pte_t pteval = hv_pte_set_ptfn(__pgprot(_PAGE_TABLE), l2_ptfn);
+	BUG_ON((pa & (HV_PAGE_TABLE_ALIGN-1)) != 0);
+	pteval = pte_set_home(pteval, initial_heap_home());
+	*(pte_t *)pmd = pteval;
+	if (page_table != (pte_t *)pmd_page_vaddr(*pmd))
+		BUG();
+}
+
+#ifdef __tilegx__
+
+#if HV_L1_SIZE != HV_L2_SIZE
+# error Rework assumption that L1 and L2 page tables are same size.
+#endif
+
+/* Since pmd_t arrays and pte_t arrays are the same size, just use casts. */
+static inline pmd_t *alloc_pmd(void)
+{
+	return (pmd_t *)alloc_pte();
+}
+
+static inline void assign_pmd(pud_t *pud, pmd_t *pmd)
+{
+	assign_pte((pmd_t *)pud, (pte_t *)pmd);
+}
+
+#endif /* __tilegx__ */
+
+/* Replace the given pmd with a full PTE table. */
+void __init shatter_pmd(pmd_t *pmd)
+{
+	pte_t *pte = get_prealloc_pte(pte_pfn(*(pte_t *)pmd));
+	assign_pte(pmd, pte);
+}
+
+#ifdef CONFIG_HIGHMEM
+/*
+ * This function initializes a certain range of kernel virtual memory
+ * with new bootmem page tables, everywhere page tables are missing in
+ * the given range.
+ */
+
+/*
+ * NOTE: The pagetables are allocated contiguous on the physical space
+ * so we can cache the place of the first one and move around without
+ * checking the pgd every time.
+ */
+static void __init page_table_range_init(unsigned long start,
+					 unsigned long end, pgd_t *pgd_base)
+{
+	pgd_t *pgd;
+	int pgd_idx;
+	unsigned long vaddr;
+
+	vaddr = start;
+	pgd_idx = pgd_index(vaddr);
+	pgd = pgd_base + pgd_idx;
+
+	for ( ; (pgd_idx < PTRS_PER_PGD) && (vaddr != end); pgd++, pgd_idx++) {
+		pmd_t *pmd = pmd_offset(pud_offset(pgd, vaddr), vaddr);
+		if (pmd_none(*pmd))
+			assign_pte(pmd, alloc_pte());
+		vaddr += PMD_SIZE;
+	}
+}
+#endif /* CONFIG_HIGHMEM */
+
+
+#if CHIP_HAS_CBOX_HOME_MAP()
+
+static int __initdata ktext_hash = 1;  /* .text pages */
+static int __initdata kdata_hash = 1;  /* .data and .bss pages */
+int __write_once hash_default = 1;     /* kernel allocator pages */
+EXPORT_SYMBOL(hash_default);
+int __write_once kstack_hash = 1;      /* if no homecaching, use h4h */
+#endif /* CHIP_HAS_CBOX_HOME_MAP */
+
+/*
+ * CPUs to use to for striping the pages of kernel data.  If hash-for-home
+ * is available, this is only relevant if kcache_hash sets up the
+ * .data and .bss to be page-homed, and we don't want the default mode
+ * of using the full set of kernel cpus for the striping.
+ */
+static __initdata struct cpumask kdata_mask;
+static __initdata int kdata_arg_seen;
+
+int __write_once kdata_huge;       /* if no homecaching, small pages */
+
+
+/* Combine a generic pgprot_t with cache home to get a cache-aware pgprot. */
+static pgprot_t __init construct_pgprot(pgprot_t prot, int home)
+{
+	prot = pte_set_home(prot, home);
+#if CHIP_HAS_CBOX_HOME_MAP()
+	if (home == PAGE_HOME_IMMUTABLE) {
+		if (ktext_hash)
+			prot = hv_pte_set_mode(prot, HV_PTE_MODE_CACHE_HASH_L3);
+		else
+			prot = hv_pte_set_mode(prot, HV_PTE_MODE_CACHE_NO_L3);
+	}
+#endif
+	return prot;
+}
+
+/*
+ * For a given kernel data VA, how should it be cached?
+ * We return the complete pgprot_t with caching bits set.
+ */
+static pgprot_t __init init_pgprot(ulong address)
+{
+	int cpu;
+	unsigned long page;
+	enum { CODE_DELTA = MEM_SV_INTRPT - PAGE_OFFSET };
+
+#if CHIP_HAS_CBOX_HOME_MAP()
+	/* For kdata=huge, everything is just hash-for-home. */
+	if (kdata_huge)
+		return construct_pgprot(PAGE_KERNEL, PAGE_HOME_HASH);
+#endif
+
+	/* We map the aliased pages of permanent text inaccessible. */
+	if (address < (ulong) _sinittext - CODE_DELTA)
+		return PAGE_NONE;
+
+	/*
+	 * We map read-only data non-coherent for performance.  We could
+	 * use neighborhood caching on TILE64, but it's not clear it's a win.
+	 */
+	if ((address >= (ulong) __start_rodata &&
+	     address < (ulong) __end_rodata) ||
+	    address == (ulong) empty_zero_page) {
+		return construct_pgprot(PAGE_KERNEL_RO, PAGE_HOME_IMMUTABLE);
+	}
+
+	/* As a performance optimization, keep the boot init stack here. */
+	if (address >= (ulong)&init_thread_union &&
+	    address < (ulong)&init_thread_union + THREAD_SIZE)
+		return construct_pgprot(PAGE_KERNEL, smp_processor_id());
+
+#ifndef __tilegx__
+#if !ATOMIC_LOCKS_FOUND_VIA_TABLE()
+	/* Force the atomic_locks[] array page to be hash-for-home. */
+	if (address == (ulong) atomic_locks)
+		return construct_pgprot(PAGE_KERNEL, PAGE_HOME_HASH);
+#endif
+#endif
+
+	/*
+	 * Everything else that isn't data or bss is heap, so mark it
+	 * with the initial heap home (hash-for-home, or this cpu).  This
+	 * includes any addresses after the loaded image; any address before
+	 * _einittext (since we already captured the case of text before
+	 * _sinittext); and any init-data pages.
+	 *
+	 * All the LOWMEM pages that we mark this way will get their
+	 * struct page homecache properly marked later, in set_page_homes().
+	 * The HIGHMEM pages we leave with a default zero for their
+	 * homes, but with a zero free_time we don't have to actually
+	 * do a flush action the first time we use them, either.
+	 */
+	if (address >= (ulong) _end || address < (ulong) _sdata ||
+	    (address >= (ulong) _sinitdata &&
+	     address < (ulong) _einitdata))
+		return construct_pgprot(PAGE_KERNEL, initial_heap_home());
+
+#if CHIP_HAS_CBOX_HOME_MAP()
+	/* Use hash-for-home if requested for data/bss. */
+	if (kdata_hash)
+		return construct_pgprot(PAGE_KERNEL, PAGE_HOME_HASH);
+#endif
+
+	/*
+	 * Otherwise we just hand out consecutive cpus.  To avoid
+	 * requiring this function to hold state, we just walk forward from
+	 * _sdata by PAGE_SIZE, skipping the readonly and init data, to reach
+	 * the requested address, while walking cpu home around kdata_mask.
+	 * This is typically no more than a dozen or so iterations.
+	 */
+	BUG_ON(_einitdata != __bss_start);
+	for (page = (ulong)_sdata, cpu = NR_CPUS; ; ) {
+		cpu = cpumask_next(cpu, &kdata_mask);
+		if (cpu == NR_CPUS)
+			cpu = cpumask_first(&kdata_mask);
+		if (page >= address)
+			break;
+		page += PAGE_SIZE;
+		if (page == (ulong)__start_rodata)
+			page = (ulong)__end_rodata;
+		if (page == (ulong)&init_thread_union)
+			page += THREAD_SIZE;
+		if (page == (ulong)_sinitdata)
+			page = (ulong)_einitdata;
+		if (page == (ulong)empty_zero_page)
+			page += PAGE_SIZE;
+#ifndef __tilegx__
+#if !ATOMIC_LOCKS_FOUND_VIA_TABLE()
+		if (page == (ulong)atomic_locks)
+			page += PAGE_SIZE;
+#endif
+#endif
+
+	}
+	return construct_pgprot(PAGE_KERNEL, cpu);
+}
+
+/*
+ * This function sets up how we cache the kernel text.  If we have
+ * hash-for-home support, normally that is used instead (see the
+ * kcache_hash boot flag for more information).  But if we end up
+ * using a page-based caching technique, this option sets up the
+ * details of that.  In addition, the "ktext=nocache" option may
+ * always be used to disable local caching of text pages, if desired.
+ */
+
+static int __initdata ktext_arg_seen;
+static int __initdata ktext_small;
+static int __initdata ktext_local;
+static int __initdata ktext_all;
+static int __initdata ktext_nondataplane;
+static int __initdata ktext_nocache;
+static struct cpumask __initdata ktext_mask;
+
+static int __init setup_ktext(char *str)
+{
+	if (str == NULL)
+		return -EINVAL;
+
+	/* If you have a leading "nocache", turn off ktext caching */
+	if (strncmp(str, "nocache", 7) == 0) {
+		ktext_nocache = 1;
+		printk("ktext: disabling local caching of kernel text\n");
+		str += 7;
+		if (*str == ',')
+			++str;
+		if (*str == '\0')
+			return 0;
+	}
+
+	ktext_arg_seen = 1;
+
+	/* Default setting on Tile64: use a huge page */
+	if (strcmp(str, "huge") == 0)
+		printk("ktext: using one huge locally cached page\n");
+
+	/* Pay TLB cost but get no cache benefit: cache small pages locally */
+	else if (strcmp(str, "local") == 0) {
+		ktext_small = 1;
+		ktext_local = 1;
+		printk("ktext: using small pages with local caching\n");
+	}
+
+	/* Neighborhood cache ktext pages on all cpus. */
+	else if (strcmp(str, "all") == 0) {
+		ktext_small = 1;
+		ktext_all = 1;
+		printk("ktext: using maximal caching neighborhood\n");
+	}
+
+
+	/* Neighborhood ktext pages on specified mask */
+	else if (cpulist_parse(str, &ktext_mask) == 0) {
+		char buf[NR_CPUS * 5];
+		cpulist_scnprintf(buf, sizeof(buf), &ktext_mask);
+		if (cpumask_weight(&ktext_mask) > 1) {
+			ktext_small = 1;
+			printk("ktext: using caching neighborhood %s "
+			       "with small pages\n", buf);
+		} else {
+			printk("ktext: caching on cpu %s with one huge page\n",
+			       buf);
+		}
+	}
+
+	else if (*str)
+		return -EINVAL;
+
+	return 0;
+}
+
+early_param("ktext", setup_ktext);
+
+
+static inline pgprot_t ktext_set_nocache(pgprot_t prot)
+{
+	if (!ktext_nocache)
+		prot = hv_pte_set_nc(prot);
+#if CHIP_HAS_NC_AND_NOALLOC_BITS()
+	else
+		prot = hv_pte_set_no_alloc_l2(prot);
+#endif
+	return prot;
+}
+
+#ifndef __tilegx__
+static pmd_t *__init get_pmd(pgd_t pgtables[], unsigned long va)
+{
+	return pmd_offset(pud_offset(&pgtables[pgd_index(va)], va), va);
+}
+#else
+static pmd_t *__init get_pmd(pgd_t pgtables[], unsigned long va)
+{
+	pud_t *pud = pud_offset(&pgtables[pgd_index(va)], va);
+	if (pud_none(*pud))
+		assign_pmd(pud, alloc_pmd());
+	return pmd_offset(pud, va);
+}
+#endif
+
+/* Temporary page table we use for staging. */
+static pgd_t pgtables[PTRS_PER_PGD]
+ __attribute__((section(".init.page")));
+
+/*
+ * This maps the physical memory to kernel virtual address space, a total
+ * of max_low_pfn pages, by creating page tables starting from address
+ * PAGE_OFFSET.
+ *
+ * This routine transitions us from using a set of compiled-in large
+ * pages to using some more precise caching, including removing access
+ * to code pages mapped at PAGE_OFFSET (executed only at MEM_SV_START)
+ * marking read-only data as locally cacheable, striping the remaining
+ * .data and .bss across all the available tiles, and removing access
+ * to pages above the top of RAM (thus ensuring a page fault from a bad
+ * virtual address rather than a hypervisor shoot down for accessing
+ * memory outside the assigned limits).
+ */
+static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
+{
+	unsigned long address, pfn;
+	pmd_t *pmd;
+	pte_t *pte;
+	int pte_ofs;
+	const struct cpumask *my_cpu_mask = cpumask_of(smp_processor_id());
+	struct cpumask kstripe_mask;
+	int rc, i;
+
+#if CHIP_HAS_CBOX_HOME_MAP()
+	if (ktext_arg_seen && ktext_hash) {
+		printk("warning: \"ktext\" boot argument ignored"
+		       " if \"kcache_hash\" sets up text hash-for-home\n");
+		ktext_small = 0;
+	}
+
+	if (kdata_arg_seen && kdata_hash) {
+		printk("warning: \"kdata\" boot argument ignored"
+		       " if \"kcache_hash\" sets up data hash-for-home\n");
+	}
+
+	if (kdata_huge && !hash_default) {
+		printk("warning: disabling \"kdata=huge\"; requires"
+		       " kcache_hash=all or =allbutstack\n");
+		kdata_huge = 0;
+	}
+#endif
+
+	/*
+	 * Set up a mask for cpus to use for kernel striping.
+	 * This is normally all cpus, but minus dataplane cpus if any.
+	 * If the dataplane covers the whole chip, we stripe over
+	 * the whole chip too.
+	 */
+	cpumask_copy(&kstripe_mask, cpu_possible_mask);
+	if (!kdata_arg_seen)
+		kdata_mask = kstripe_mask;
+
+	/* Allocate and fill in L2 page tables */
+	for (i = 0; i < MAX_NUMNODES; ++i) {
+#ifdef CONFIG_HIGHMEM
+		unsigned long end_pfn = node_lowmem_end_pfn[i];
+#else
+		unsigned long end_pfn = node_end_pfn[i];
+#endif
+		unsigned long end_huge_pfn = 0;
+
+		/* Pre-shatter the last huge page to allow per-cpu pages. */
+		if (kdata_huge)
+			end_huge_pfn = end_pfn - (HPAGE_SIZE >> PAGE_SHIFT);
+
+		pfn = node_start_pfn[i];
+
+		/* Allocate enough memory to hold L2 page tables for node. */
+		init_prealloc_ptes(i, end_pfn - pfn);
+
+		address = (unsigned long) pfn_to_kaddr(pfn);
+		while (pfn < end_pfn) {
+			BUG_ON(address & (HPAGE_SIZE-1));
+			pmd = get_pmd(pgtables, address);
+			pte = get_prealloc_pte(pfn);
+			if (pfn < end_huge_pfn) {
+				pgprot_t prot = init_pgprot(address);
+				*(pte_t *)pmd = pte_mkhuge(pfn_pte(pfn, prot));
+				for (pte_ofs = 0; pte_ofs < PTRS_PER_PTE;
+				     pfn++, pte_ofs++, address += PAGE_SIZE)
+					pte[pte_ofs] = pfn_pte(pfn, prot);
+			} else {
+				if (kdata_huge)
+					printk(KERN_DEBUG "pre-shattered huge"
+					       " page at %#lx\n", address);
+				for (pte_ofs = 0; pte_ofs < PTRS_PER_PTE;
+				     pfn++, pte_ofs++, address += PAGE_SIZE) {
+					pgprot_t prot = init_pgprot(address);
+					pte[pte_ofs] = pfn_pte(pfn, prot);
+				}
+				assign_pte(pmd, pte);
+			}
+		}
+	}
+
+	/*
+	 * Set or check ktext_map now that we have cpu_possible_mask
+	 * and kstripe_mask to work with.
+	 */
+	if (ktext_all)
+		cpumask_copy(&ktext_mask, cpu_possible_mask);
+	else if (ktext_nondataplane)
+		ktext_mask = kstripe_mask;
+	else if (!cpumask_empty(&ktext_mask)) {
+		/* Sanity-check any mask that was requested */
+		struct cpumask bad;
+		cpumask_andnot(&bad, &ktext_mask, cpu_possible_mask);
+		cpumask_and(&ktext_mask, &ktext_mask, cpu_possible_mask);
+		if (!cpumask_empty(&bad)) {
+			char buf[NR_CPUS * 5];
+			cpulist_scnprintf(buf, sizeof(buf), &bad);
+			printk("ktext: not using unavailable cpus %s\n", buf);
+		}
+		if (cpumask_empty(&ktext_mask)) {
+			printk("ktext: no valid cpus; caching on %d.\n",
+			       smp_processor_id());
+			cpumask_copy(&ktext_mask,
+				     cpumask_of(smp_processor_id()));
+		}
+	}
+
+	address = MEM_SV_INTRPT;
+	pmd = get_pmd(pgtables, address);
+	if (ktext_small) {
+		/* Allocate an L2 PTE for the kernel text */
+		int cpu = 0;
+		pgprot_t prot = construct_pgprot(PAGE_KERNEL_EXEC,
+						 PAGE_HOME_IMMUTABLE);
+
+		if (ktext_local) {
+			if (ktext_nocache)
+				prot = hv_pte_set_mode(prot,
+						       HV_PTE_MODE_UNCACHED);
+			else
+				prot = hv_pte_set_mode(prot,
+						       HV_PTE_MODE_CACHE_NO_L3);
+		} else {
+			prot = hv_pte_set_mode(prot,
+					       HV_PTE_MODE_CACHE_TILE_L3);
+			cpu = cpumask_first(&ktext_mask);
+
+			prot = ktext_set_nocache(prot);
+		}
+
+		BUG_ON(address != (unsigned long)_stext);
+		pfn = 0;  /* code starts at PA 0 */
+		pte = alloc_pte();
+		for (pte_ofs = 0; address < (unsigned long)_einittext;
+		     pfn++, pte_ofs++, address += PAGE_SIZE) {
+			if (!ktext_local) {
+				prot = set_remote_cache_cpu(prot, cpu);
+				cpu = cpumask_next(cpu, &ktext_mask);
+				if (cpu == NR_CPUS)
+					cpu = cpumask_first(&ktext_mask);
+			}
+			pte[pte_ofs] = pfn_pte(pfn, prot);
+		}
+		assign_pte(pmd, pte);
+	} else {
+		pte_t pteval = pfn_pte(0, PAGE_KERNEL_EXEC);
+		pteval = pte_mkhuge(pteval);
+#if CHIP_HAS_CBOX_HOME_MAP()
+		if (ktext_hash) {
+			pteval = hv_pte_set_mode(pteval,
+						 HV_PTE_MODE_CACHE_HASH_L3);
+			pteval = ktext_set_nocache(pteval);
+		} else
+#endif /* CHIP_HAS_CBOX_HOME_MAP() */
+		if (cpumask_weight(&ktext_mask) == 1) {
+			pteval = set_remote_cache_cpu(pteval,
+					      cpumask_first(&ktext_mask));
+			pteval = hv_pte_set_mode(pteval,
+						 HV_PTE_MODE_CACHE_TILE_L3);
+			pteval = ktext_set_nocache(pteval);
+		} else if (ktext_nocache)
+			pteval = hv_pte_set_mode(pteval,
+						 HV_PTE_MODE_UNCACHED);
+		else
+			pteval = hv_pte_set_mode(pteval,
+						 HV_PTE_MODE_CACHE_NO_L3);
+		*(pte_t *)pmd = pteval;
+	}
+
+	/* Set swapper_pgprot here so it is flushed to memory right away. */
+	swapper_pgprot = init_pgprot((unsigned long)swapper_pg_dir);
+
+	/*
+	 * Since we may be changing the caching of the stack and page
+	 * table itself, we invoke an assembly helper to do the
+	 * following steps:
+	 *
+	 *  - flush the cache so we start with an empty slate
+	 *  - install pgtables[] as the real page table
+	 *  - flush the TLB so the new page table takes effect
+	 */
+	rc = flush_and_install_context(__pa(pgtables),
+				       init_pgprot((unsigned long)pgtables),
+				       __get_cpu_var(current_asid),
+				       cpumask_bits(my_cpu_mask));
+	BUG_ON(rc != 0);
+
+	/* Copy the page table back to the normal swapper_pg_dir. */
+	memcpy(pgd_base, pgtables, sizeof(pgtables));
+	__install_page_table(pgd_base, __get_cpu_var(current_asid),
+			     swapper_pgprot);
+}
+
+/*
+ * devmem_is_allowed() checks to see if /dev/mem access to a certain address
+ * is valid. The argument is a physical page number.
+ *
+ * On Tile, the only valid things for which we can just hand out unchecked
+ * PTEs are the kernel code and data.  Anything else might change its
+ * homing with time, and we wouldn't know to adjust the /dev/mem PTEs.
+ * Note that init_thread_union is released to heap soon after boot,
+ * so we include it in the init data.
+ *
+ * For TILE-Gx, we might want to consider allowing access to PA
+ * regions corresponding to PCI space, etc.
+ */
+int devmem_is_allowed(unsigned long pagenr)
+{
+	return pagenr < kaddr_to_pfn(_end) &&
+		!(pagenr >= kaddr_to_pfn(&init_thread_union) ||
+		  pagenr < kaddr_to_pfn(_einitdata)) &&
+		!(pagenr >= kaddr_to_pfn(_sinittext) ||
+		  pagenr <= kaddr_to_pfn(_einittext-1));
+}
+
+#ifdef CONFIG_HIGHMEM
+static void __init permanent_kmaps_init(pgd_t *pgd_base)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+	unsigned long vaddr;
+
+	vaddr = PKMAP_BASE;
+	page_table_range_init(vaddr, vaddr + PAGE_SIZE*LAST_PKMAP, pgd_base);
+
+	pgd = swapper_pg_dir + pgd_index(vaddr);
+	pud = pud_offset(pgd, vaddr);
+	pmd = pmd_offset(pud, vaddr);
+	pte = pte_offset_kernel(pmd, vaddr);
+	pkmap_page_table = pte;
+}
+#endif /* CONFIG_HIGHMEM */
+
+
+static void __init init_free_pfn_range(unsigned long start, unsigned long end)
+{
+	unsigned long pfn;
+	struct page *page = pfn_to_page(start);
+
+	for (pfn = start; pfn < end; ) {
+		/* Optimize by freeing pages in large batches */
+		int order = __ffs(pfn);
+		int count, i;
+		struct page *p;
+
+		if (order >= MAX_ORDER)
+			order = MAX_ORDER-1;
+		count = 1 << order;
+		while (pfn + count > end) {
+			count >>= 1;
+			--order;
+		}
+		for (p = page, i = 0; i < count; ++i, ++p) {
+			__ClearPageReserved(p);
+			/*
+			 * Hacky direct set to avoid unnecessary
+			 * lock take/release for EVERY page here.
+			 */
+			p->_count.counter = 0;
+			p->_mapcount.counter = -1;
+		}
+		init_page_count(page);
+		__free_pages(page, order);
+		totalram_pages += count;
+
+		page += count;
+		pfn += count;
+	}
+}
+
+static void __init set_non_bootmem_pages_init(void)
+{
+	struct zone *z;
+	for_each_zone(z) {
+		unsigned long start, end;
+		int nid = z->zone_pgdat->node_id;
+
+		start = z->zone_start_pfn;
+		if (start == 0)
+			continue;  /* bootmem */
+		end = start + z->spanned_pages;
+		if (zone_idx(z) == ZONE_DMA) {
+			BUG_ON(start != node_start_pfn[nid]);
+			start = node_free_pfn[nid];
+		}
+#ifdef CONFIG_HIGHMEM
+		if (zone_idx(z) == ZONE_HIGHMEM)
+			totalhigh_pages += z->spanned_pages;
+#endif
+		if (kdata_huge) {
+			unsigned long percpu_pfn = node_percpu_pfn[nid];
+			if (start < percpu_pfn && end > percpu_pfn)
+				end = percpu_pfn;
+		}
+#ifdef CONFIG_PCI
+		if (start <= pci_reserve_start_pfn &&
+		    end > pci_reserve_start_pfn) {
+			if (end > pci_reserve_end_pfn)
+				init_free_pfn_range(pci_reserve_end_pfn, end);
+			end = pci_reserve_start_pfn;
+		}
+#endif
+		init_free_pfn_range(start, end);
+	}
+}
+
+/*
+ * paging_init() sets up the page tables - note that all of lowmem is
+ * already mapped by head.S.
+ */
+void __init paging_init(void)
+{
+#ifdef CONFIG_HIGHMEM
+	unsigned long vaddr, end;
+#endif
+#ifdef __tilegx__
+	pud_t *pud;
+#endif
+	pgd_t *pgd_base = swapper_pg_dir;
+
+	kernel_physical_mapping_init(pgd_base);
+
+#ifdef CONFIG_HIGHMEM
+	/*
+	 * Fixed mappings, only the page table structure has to be
+	 * created - mappings will be set by set_fixmap():
+	 */
+	vaddr = __fix_to_virt(__end_of_fixed_addresses - 1) & PMD_MASK;
+	end = (FIXADDR_TOP + PMD_SIZE - 1) & PMD_MASK;
+	page_table_range_init(vaddr, end, pgd_base);
+	permanent_kmaps_init(pgd_base);
+#endif
+
+#ifdef __tilegx__
+	/*
+	 * Since GX allocates just one pmd_t array worth of vmalloc space,
+	 * we go ahead and allocate it statically here, then share it
+	 * globally.  As a result we don't have to worry about any task
+	 * changing init_mm once we get up and running, and there's no
+	 * need for e.g. vmalloc_sync_all().
+	 */
+	BUILD_BUG_ON(pgd_index(VMALLOC_START) != pgd_index(VMALLOC_END));
+	pud = pud_offset(pgd_base + pgd_index(VMALLOC_START), VMALLOC_START);
+	assign_pmd(pud, alloc_pmd());
+#endif
+}
+
+
+/*
+ * Walk the kernel page tables and derive the page_home() from
+ * the PTEs, so that set_pte() can properly validate the caching
+ * of all PTEs it sees.
+ */
+void __init set_page_homes(void)
+{
+}
+
+static void __init set_max_mapnr_init(void)
+{
+#ifdef CONFIG_FLATMEM
+	max_mapnr = max_low_pfn;
+#endif
+}
+
+void __init mem_init(void)
+{
+	int codesize, datasize, initsize;
+	int i;
+#ifndef __tilegx__
+	void *last;
+#endif
+
+#ifdef CONFIG_FLATMEM
+	if (!mem_map)
+		BUG();
+#endif
+
+#ifdef CONFIG_HIGHMEM
+	/* check that fixmap and pkmap do not overlap */
+	if (PKMAP_ADDR(LAST_PKMAP-1) >= FIXADDR_START) {
+		printk(KERN_ERR "fixmap and kmap areas overlap"
+		       " - this will crash\n");
+		printk(KERN_ERR "pkstart: %lxh pkend: %lxh fixstart %lxh\n",
+		       PKMAP_BASE, PKMAP_ADDR(LAST_PKMAP-1),
+		       FIXADDR_START);
+		BUG();
+	}
+#endif
+
+	set_max_mapnr_init();
+
+	/* this will put all bootmem onto the freelists */
+	totalram_pages += free_all_bootmem();
+
+	/* count all remaining LOWMEM and give all HIGHMEM to page allocator */
+	set_non_bootmem_pages_init();
+
+	codesize =  (unsigned long)&_etext - (unsigned long)&_text;
+	datasize =  (unsigned long)&_end - (unsigned long)&_sdata;
+	initsize =  (unsigned long)&_einittext - (unsigned long)&_sinittext;
+	initsize += (unsigned long)&_einitdata - (unsigned long)&_sinitdata;
+
+	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, %dk data, %dk init, %ldk highmem)\n",
+		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+		num_physpages << (PAGE_SHIFT-10),
+		codesize >> 10,
+		datasize >> 10,
+		initsize >> 10,
+		(unsigned long) (totalhigh_pages << (PAGE_SHIFT-10))
+	       );
+
+	/*
+	 * In debug mode, dump some interesting memory mappings.
+	 */
+#ifdef CONFIG_HIGHMEM
+	printk(KERN_DEBUG "  KMAP    %#lx - %#lx\n",
+	       FIXADDR_START, FIXADDR_TOP + PAGE_SIZE - 1);
+	printk(KERN_DEBUG "  PKMAP   %#lx - %#lx\n",
+	       PKMAP_BASE, PKMAP_ADDR(LAST_PKMAP) - 1);
+#endif
+#ifdef CONFIG_HUGEVMAP
+	printk(KERN_DEBUG "  HUGEMAP %#lx - %#lx\n",
+	       HUGE_VMAP_BASE, HUGE_VMAP_END - 1);
+#endif
+	printk(KERN_DEBUG "  VMALLOC %#lx - %#lx\n",
+	       _VMALLOC_START, _VMALLOC_END - 1);
+#ifdef __tilegx__
+	for (i = MAX_NUMNODES-1; i >= 0; --i) {
+		struct pglist_data *node = &node_data[i];
+		if (node->node_present_pages) {
+			unsigned long start = (unsigned long)
+				pfn_to_kaddr(node->node_start_pfn);
+			unsigned long end = start +
+				(node->node_present_pages << PAGE_SHIFT);
+			printk(KERN_DEBUG "  MEM%d    %#lx - %#lx\n",
+			       i, start, end - 1);
+		}
+	}
+#else
+	last = high_memory;
+	for (i = MAX_NUMNODES-1; i >= 0; --i) {
+		if ((unsigned long)vbase_map[i] != -1UL) {
+			printk(KERN_DEBUG "  LOWMEM%d %#lx - %#lx\n",
+			       i, (unsigned long) (vbase_map[i]),
+			       (unsigned long) (last-1));
+			last = vbase_map[i];
+		}
+	}
+#endif
+
+#ifndef __tilegx__
+	/*
+	 * Convert from using one lock for all atomic operations to
+	 * one per cpu.
+	 */
+	__init_atomic_per_cpu();
+#endif
+}
+
+/*
+ * this is for the non-NUMA, single node SMP system case.
+ * Specifically, in the case of x86, we will always add
+ * memory to the highmem for now.
+ */
+#ifndef CONFIG_NEED_MULTIPLE_NODES
+int arch_add_memory(u64 start, u64 size)
+{
+	struct pglist_data *pgdata = &contig_page_data;
+	struct zone *zone = pgdata->node_zones + MAX_NR_ZONES-1;
+	unsigned long start_pfn = start >> PAGE_SHIFT;
+	unsigned long nr_pages = size >> PAGE_SHIFT;
+
+	return __add_pages(zone, start_pfn, nr_pages);
+}
+
+int remove_memory(u64 start, u64 size)
+{
+	return -EINVAL;
+}
+#endif
+
+struct kmem_cache *pgd_cache;
+
+void __init pgtable_cache_init(void)
+{
+	pgd_cache = kmem_cache_create("pgd",
+				PTRS_PER_PGD*sizeof(pgd_t),
+				PTRS_PER_PGD*sizeof(pgd_t),
+				0,
+				NULL);
+	if (!pgd_cache)
+		panic("pgtable_cache_init(): Cannot create pgd cache");
+}
+
+#if !CHIP_HAS_COHERENT_LOCAL_CACHE()
+/*
+ * The __w1data area holds data that is only written during initialization,
+ * and is read-only and thus freely cacheable thereafter.  Fix the page
+ * table entries that cover that region accordingly.
+ */
+static void mark_w1data_ro(void)
+{
+	/* Loop over page table entries */
+	unsigned long addr = (unsigned long)__w1data_begin;
+	BUG_ON((addr & (PAGE_SIZE-1)) != 0);
+	for (; addr <= (unsigned long)__w1data_end - 1; addr += PAGE_SIZE) {
+		unsigned long pfn = kaddr_to_pfn((void *)addr);
+		struct page *page = pfn_to_page(pfn);
+		pte_t *ptep = virt_to_pte(NULL, addr);
+		BUG_ON(pte_huge(*ptep));   /* not relevant for kdata_huge */
+		set_pte_at(&init_mm, addr, ptep, pfn_pte(pfn, PAGE_KERNEL_RO));
+	}
+}
+#endif
+
+#ifdef CONFIG_DEBUG_PAGEALLOC
+static long __write_once initfree;
+#else
+static long __write_once initfree = 1;
+#endif
+
+/* Select whether to free (1) or mark unusable (0) the __init pages. */
+static int __init set_initfree(char *str)
+{
+	strict_strtol(str, 0, &initfree);
+	printk("initfree: %s free init pages\n", initfree ? "will" : "won't");
+	return 1;
+}
+__setup("initfree=", set_initfree);
+
+static void free_init_pages(char *what, unsigned long begin, unsigned long end)
+{
+	unsigned long addr = (unsigned long) begin;
+
+	if (kdata_huge && !initfree) {
+		printk("Warning: ignoring initfree=0:"
+		       " incompatible with kdata=huge\n");
+		initfree = 1;
+	}
+	end = (end + PAGE_SIZE - 1) & PAGE_MASK;
+	local_flush_tlb_pages(NULL, begin, PAGE_SIZE, end - begin);
+	for (addr = begin; addr < end; addr += PAGE_SIZE) {
+		/*
+		 * Note we just reset the home here directly in the
+		 * page table.  We know this is safe because our caller
+		 * just flushed the caches on all the other cpus,
+		 * and they won't be touching any of these pages.
+		 */
+		int pfn = kaddr_to_pfn((void *)addr);
+		struct page *page = pfn_to_page(pfn);
+		pte_t *ptep = virt_to_pte(NULL, addr);
+		if (!initfree) {
+			/*
+			 * If debugging page accesses then do not free
+			 * this memory but mark them not present - any
+			 * buggy init-section access will create a
+			 * kernel page fault:
+			 */
+			pte_clear(&init_mm, addr, ptep);
+			continue;
+		}
+		__ClearPageReserved(page);
+		init_page_count(page);
+		if (pte_huge(*ptep))
+			BUG_ON(!kdata_huge);
+		else
+			set_pte_at(&init_mm, addr, ptep,
+				   pfn_pte(pfn, PAGE_KERNEL));
+		memset((void *)addr, POISON_FREE_INITMEM, PAGE_SIZE);
+		free_page(addr);
+		totalram_pages++;
+	}
+	printk(KERN_INFO "Freeing %s: %ldk freed\n", what, (end - begin) >> 10);
+}
+
+void free_initmem(void)
+{
+	const unsigned long text_delta = MEM_SV_INTRPT - PAGE_OFFSET;
+
+	/*
+	 * Evict the dirty initdata on the boot cpu, evict the w1data
+	 * wherever it's homed, and evict all the init code everywhere.
+	 * We are guaranteed that no one will touch the init pages any
+	 * more, and although other cpus may be touching the w1data,
+	 * we only actually change the caching on tile64, which won't
+	 * be keeping local copies in the other tiles' caches anyway.
+	 */
+	homecache_evict(&cpu_cacheable_map);
+
+	/* Free the data pages that we won't use again after init. */
+	free_init_pages("unused kernel data",
+			(unsigned long)_sinitdata,
+			(unsigned long)_einitdata);
+
+	/*
+	 * Free the pages mapped from 0xc0000000 that correspond to code
+	 * pages from 0xfd000000 that we won't use again after init.
+	 */
+	free_init_pages("unused kernel text",
+			(unsigned long)_sinittext - text_delta,
+			(unsigned long)_einittext - text_delta);
+
+#if !CHIP_HAS_COHERENT_LOCAL_CACHE()
+	/*
+	 * Upgrade the .w1data section to globally cached.
+	 * We don't do this on tilepro, since the cache architecture
+	 * pretty much makes it irrelevant, and in any case we end
+	 * up having racing issues with other tiles that may touch
+	 * the data after we flush the cache but before we update
+	 * the PTEs and flush the TLBs, causing sharer shootdowns
+	 * later.  Even though this is to clean data, it seems like
+	 * an unnecessary complication.
+	 */
+	mark_w1data_ro();
+#endif
+
+	/* Do a global TLB flush so everyone sees the changes. */
+	flush_tlb_all();
+}
diff --git a/arch/tile/mm/migrate.h b/arch/tile/mm/migrate.h
new file mode 100644
index 0000000..cd45a08
--- /dev/null
+++ b/arch/tile/mm/migrate.h
@@ -0,0 +1,50 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * Structure definitions for migration, exposed here for use by
+ * arch/tile/kernel/asm-offsets.c.
+ */
+
+#ifndef MM_MIGRATE_H
+#define MM_MIGRATE_H
+
+#include <linux/cpumask.h>
+#include <hv/hypervisor.h>
+
+/*
+ * This function is used as a helper when setting up the initial
+ * page table (swapper_pg_dir).
+ */
+extern int flush_and_install_context(HV_PhysAddr page_table, HV_PTE access,
+				     HV_ASID asid,
+				     const unsigned long *cpumask);
+
+/*
+ * This function supports migration as a "helper" as follows:
+ *
+ *  - Set the stack PTE itself to "migrating".
+ *  - Do a global TLB flush for (va,length) and the specified ASIDs.
+ *  - Do a cache-evict on all necessary cpus.
+ *  - Write the new stack PTE.
+ *
+ * Note that any non-NULL pointers must not point to the page that
+ * is handled by the stack_pte itself.
+ */
+extern int homecache_migrate_stack_and_flush(pte_t stack_pte, unsigned long va,
+				     size_t length, pte_t *stack_ptep,
+				     const struct cpumask *cache_cpumask,
+				     const struct cpumask *tlb_cpumask,
+				     HV_Remote_ASID *asids,
+				     int asidcount);
+
+#endif /* MM_MIGRATE_H */
diff --git a/arch/tile/mm/migrate_32.S b/arch/tile/mm/migrate_32.S
new file mode 100644
index 0000000..f738765
--- /dev/null
+++ b/arch/tile/mm/migrate_32.S
@@ -0,0 +1,211 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * This routine is a helper for migrating the home of a set of pages to
+ * a new cpu.  See the documentation in homecache.c for more information.
+ */
+
+#include <linux/linkage.h>
+#include <linux/threads.h>
+#include <asm/page.h>
+#include <asm/types.h>
+#include <asm/asm-offsets.h>
+#include <hv/hypervisor.h>
+
+	.text
+
+/*
+ * First, some definitions that apply to all the code in the file.
+ */
+
+/* Locals (caller-save) */
+#define r_tmp		r10
+#define r_save_sp	r11
+
+/* What we save where in the stack frame; must include all callee-saves. */
+#define FRAME_SP	4
+#define FRAME_R30	8
+#define FRAME_R31	12
+#define FRAME_R32	16
+#define FRAME_R33	20
+#define FRAME_R34	24
+#define FRAME_R35	28
+#define FRAME_SIZE	32
+
+
+
+
+/*
+ * On entry:
+ *
+ *   r0 low word of the new context PA to install (moved to r_context_lo)
+ *   r1 high word of the new context PA to install (moved to r_context_hi)
+ *   r2 low word of PTE to use for context access (moved to r_access_lo)
+ *   r3 high word of PTE to use for context access (moved to r_access_lo)
+ *   r4 ASID to use for new context (moved to r_asid)
+ *   r5 pointer to cpumask with just this cpu set in it (r_my_cpumask)
+ */
+
+/* Arguments (caller-save) */
+#define r_context_lo_in	r0
+#define r_context_hi_in	r1
+#define r_access_lo_in	r2
+#define r_access_hi_in	r3
+#define r_asid_in	r4
+#define r_my_cpumask	r5
+
+/* Locals (callee-save); must not be more than FRAME_xxx above. */
+#define r_save_ics	r30
+#define r_context_lo	r31
+#define r_context_hi	r32
+#define r_access_lo	r33
+#define r_access_hi	r34
+#define r_asid		r35
+
+STD_ENTRY(flush_and_install_context)
+	/*
+	 * Create a stack frame; we can't touch it once we flush the
+	 * cache until we install the new page table and flush the TLB.
+	 */
+	{
+	 move r_save_sp, sp
+	 sw sp, lr
+	 addi sp, sp, -FRAME_SIZE
+	}
+	addi r_tmp, sp, FRAME_SP
+	{
+	 sw r_tmp, r_save_sp
+	 addi r_tmp, sp, FRAME_R30
+	}
+	{
+	 sw r_tmp, r30
+	 addi r_tmp, sp, FRAME_R31
+	}
+	{
+	 sw r_tmp, r31
+	 addi r_tmp, sp, FRAME_R32
+	}
+	{
+	 sw r_tmp, r32
+	 addi r_tmp, sp, FRAME_R33
+	}
+	{
+	 sw r_tmp, r33
+	 addi r_tmp, sp, FRAME_R34
+	}
+	{
+	 sw r_tmp, r34
+	 addi r_tmp, sp, FRAME_R35
+	}
+	sw r_tmp, r35
+
+	/* Move some arguments to callee-save registers. */
+	{
+	 move r_context_lo, r_context_lo_in
+	 move r_context_hi, r_context_hi_in
+	}
+	{
+	 move r_access_lo, r_access_lo_in
+	 move r_access_hi, r_access_hi_in
+	}
+	move r_asid, r_asid_in
+
+	/* Disable interrupts, since we can't use our stack. */
+	{
+	 mfspr r_save_ics, INTERRUPT_CRITICAL_SECTION
+	 movei r_tmp, 1
+	}
+	mtspr INTERRUPT_CRITICAL_SECTION, r_tmp
+
+	/* First, flush our L2 cache. */
+	{
+	 move r0, zero  /* cache_pa */
+	 move r1, zero
+	}
+	{
+	 auli r2, zero, ha16(HV_FLUSH_EVICT_L2)  /* cache_control */
+	 move r3, r_my_cpumask  /* cache_cpumask */
+	}
+	{
+	 move r4, zero  /* tlb_va */
+	 move r5, zero  /* tlb_length */
+	}
+	{
+	 move r6, zero  /* tlb_pgsize */
+	 move r7, zero  /* tlb_cpumask */
+	}
+	{
+	 move r8, zero  /* asids */
+	 move r9, zero  /* asidcount */
+	}
+	jal hv_flush_remote
+	bnz r0, .Ldone
+
+	/* Now install the new page table. */
+	{
+	 move r0, r_context_lo
+	 move r1, r_context_hi
+	}
+	{
+	 move r2, r_access_lo
+	 move r3, r_access_hi
+	}
+	{
+	 move r4, r_asid
+	 movei r5, HV_CTX_DIRECTIO
+	}
+	jal hv_install_context
+	bnz r0, .Ldone
+
+	/* Finally, flush the TLB. */
+	{
+	 movei r0, 0   /* preserve_global */
+	 jal hv_flush_all
+	}
+
+.Ldone:
+	/* Reset interrupts back how they were before. */
+	mtspr INTERRUPT_CRITICAL_SECTION, r_save_ics
+
+	/* Restore the callee-saved registers and return. */
+	addli lr, sp, FRAME_SIZE
+	{
+	 lw lr, lr
+	 addli r_tmp, sp, FRAME_R30
+	}
+	{
+	 lw r30, r_tmp
+	 addli r_tmp, sp, FRAME_R31
+	}
+	{
+	 lw r31, r_tmp
+	 addli r_tmp, sp, FRAME_R32
+	}
+	{
+	 lw r32, r_tmp
+	 addli r_tmp, sp, FRAME_R33
+	}
+	{
+	 lw r33, r_tmp
+	 addli r_tmp, sp, FRAME_R34
+	}
+	{
+	 lw r34, r_tmp
+	 addli r_tmp, sp, FRAME_R35
+	}
+	{
+	 lw r35, r_tmp
+	 addi sp, sp, FRAME_SIZE
+	}
+	jrp lr
+	STD_ENDPROC(flush_and_install_context)
diff --git a/arch/tile/mm/mmap.c b/arch/tile/mm/mmap.c
new file mode 100644
index 0000000..f96f4ce
--- /dev/null
+++ b/arch/tile/mm/mmap.c
@@ -0,0 +1,75 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * Taken from the i386 architecture and simplified.
+ */
+
+#include <linux/mm.h>
+#include <linux/random.h>
+#include <linux/limits.h>
+#include <linux/sched.h>
+#include <linux/mman.h>
+#include <linux/compat.h>
+
+/*
+ * Top of mmap area (just below the process stack).
+ *
+ * Leave an at least ~128 MB hole.
+ */
+#define MIN_GAP (128*1024*1024)
+#define MAX_GAP (TASK_SIZE/6*5)
+
+static inline unsigned long mmap_base(struct mm_struct *mm)
+{
+	unsigned long gap = rlimit(RLIMIT_STACK);
+	unsigned long random_factor = 0;
+
+	if (current->flags & PF_RANDOMIZE)
+		random_factor = get_random_int() % (1024*1024);
+
+	if (gap < MIN_GAP)
+		gap = MIN_GAP;
+	else if (gap > MAX_GAP)
+		gap = MAX_GAP;
+
+	return PAGE_ALIGN(TASK_SIZE - gap - random_factor);
+}
+
+/*
+ * This function, called very early during the creation of a new
+ * process VM image, sets up which VM layout function to use:
+ */
+void arch_pick_mmap_layout(struct mm_struct *mm)
+{
+#if !defined(__tilegx__)
+	int is_32bit = 1;
+#elif defined(CONFIG_COMPAT)
+	int is_32bit = is_compat_task();
+#else
+	int is_32bit = 0;
+#endif
+
+	/*
+	 * Use standard layout if the expected stack growth is unlimited
+	 * or we are running native 64 bits.
+	 */
+	if (!is_32bit || rlimit(RLIMIT_STACK) == RLIM_INFINITY) {
+		mm->mmap_base = TASK_UNMAPPED_BASE;
+		mm->get_unmapped_area = arch_get_unmapped_area;
+		mm->unmap_area = arch_unmap_area;
+	} else {
+		mm->mmap_base = mmap_base(mm);
+		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
+		mm->unmap_area = arch_unmap_area_topdown;
+	}
+}
diff --git a/arch/tile/mm/pgtable.c b/arch/tile/mm/pgtable.c
new file mode 100644
index 0000000..289e729
--- /dev/null
+++ b/arch/tile/mm/pgtable.c
@@ -0,0 +1,566 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/mm.h>
+#include <linux/swap.h>
+#include <linux/smp.h>
+#include <linux/highmem.h>
+#include <linux/slab.h>
+#include <linux/pagemap.h>
+#include <linux/spinlock.h>
+#include <linux/cpumask.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/vmalloc.h>
+#include <linux/smp.h>
+
+#include <asm/system.h>
+#include <asm/pgtable.h>
+#include <asm/pgalloc.h>
+#include <asm/fixmap.h>
+#include <asm/tlb.h>
+#include <asm/tlbflush.h>
+#include <asm/homecache.h>
+
+#define K(x) ((x) << (PAGE_SHIFT-10))
+
+/*
+ * The normal show_free_areas() is too verbose on Tile, with dozens
+ * of processors and often four NUMA zones each with high and lowmem.
+ */
+void show_mem(void)
+{
+	struct zone *zone;
+
+	printk("Active:%lu inactive:%lu dirty:%lu writeback:%lu unstable:%lu"
+	       " free:%lu\n slab:%lu mapped:%lu pagetables:%lu bounce:%lu"
+	       " pagecache:%lu swap:%lu\n",
+	       (global_page_state(NR_ACTIVE_ANON) +
+		global_page_state(NR_ACTIVE_FILE)),
+	       (global_page_state(NR_INACTIVE_ANON) +
+		global_page_state(NR_INACTIVE_FILE)),
+	       global_page_state(NR_FILE_DIRTY),
+	       global_page_state(NR_WRITEBACK),
+	       global_page_state(NR_UNSTABLE_NFS),
+	       global_page_state(NR_FREE_PAGES),
+	       (global_page_state(NR_SLAB_RECLAIMABLE) +
+		global_page_state(NR_SLAB_UNRECLAIMABLE)),
+	       global_page_state(NR_FILE_MAPPED),
+	       global_page_state(NR_PAGETABLE),
+	       global_page_state(NR_BOUNCE),
+	       global_page_state(NR_FILE_PAGES),
+	       nr_swap_pages);
+
+	for_each_zone(zone) {
+		unsigned long flags, order, total = 0, largest_order = -1;
+
+		if (!populated_zone(zone))
+			continue;
+
+		printk("Node %d %7s: ", zone_to_nid(zone), zone->name);
+		spin_lock_irqsave(&zone->lock, flags);
+		for (order = 0; order < MAX_ORDER; order++) {
+			int nr = zone->free_area[order].nr_free;
+			total += nr << order;
+			if (nr)
+				largest_order = order;
+		}
+		spin_unlock_irqrestore(&zone->lock, flags);
+		printk("%lukB (largest %luKb)\n",
+		       K(total), largest_order ? K(1UL) << largest_order : 0);
+	}
+}
+
+/*
+ * Associate a virtual page frame with a given physical page frame
+ * and protection flags for that frame.
+ */
+static void set_pte_pfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	pgd = swapper_pg_dir + pgd_index(vaddr);
+	if (pgd_none(*pgd)) {
+		BUG();
+		return;
+	}
+	pud = pud_offset(pgd, vaddr);
+	if (pud_none(*pud)) {
+		BUG();
+		return;
+	}
+	pmd = pmd_offset(pud, vaddr);
+	if (pmd_none(*pmd)) {
+		BUG();
+		return;
+	}
+	pte = pte_offset_kernel(pmd, vaddr);
+	/* <pfn,flags> stored as-is, to permit clearing entries */
+	set_pte(pte, pfn_pte(pfn, flags));
+
+	/*
+	 * It's enough to flush this one mapping.
+	 * This appears conservative since it is only called
+	 * from __set_fixmap.
+	 */
+	local_flush_tlb_page(NULL, vaddr, PAGE_SIZE);
+}
+
+/*
+ * Associate a huge virtual page frame with a given physical page frame
+ * and protection flags for that frame. pfn is for the base of the page,
+ * vaddr is what the page gets mapped to - both must be properly aligned.
+ * The pmd must already be instantiated.
+ */
+void set_pmd_pfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	if (vaddr & (PMD_SIZE-1)) {		/* vaddr is misaligned */
+		printk(KERN_WARNING "set_pmd_pfn: vaddr misaligned\n");
+		return; /* BUG(); */
+	}
+	if (pfn & (PTRS_PER_PTE-1)) {		/* pfn is misaligned */
+		printk(KERN_WARNING "set_pmd_pfn: pfn misaligned\n");
+		return; /* BUG(); */
+	}
+	pgd = swapper_pg_dir + pgd_index(vaddr);
+	if (pgd_none(*pgd)) {
+		printk(KERN_WARNING "set_pmd_pfn: pgd_none\n");
+		return; /* BUG(); */
+	}
+	pud = pud_offset(pgd, vaddr);
+	pmd = pmd_offset(pud, vaddr);
+	set_pmd(pmd, ptfn_pmd(HV_PFN_TO_PTFN(pfn), flags));
+	/*
+	 * It's enough to flush this one mapping.
+	 * We flush both small and huge TSBs to be sure.
+	 */
+	local_flush_tlb_page(NULL, vaddr, HPAGE_SIZE);
+	local_flush_tlb_pages(NULL, vaddr, PAGE_SIZE, HPAGE_SIZE);
+}
+
+void __set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t flags)
+{
+	unsigned long address = __fix_to_virt(idx);
+
+	if (idx >= __end_of_fixed_addresses) {
+		BUG();
+		return;
+	}
+	set_pte_pfn(address, phys >> PAGE_SHIFT, flags);
+}
+
+#if defined(CONFIG_HIGHPTE)
+pte_t *_pte_offset_map(pmd_t *dir, unsigned long address, enum km_type type)
+{
+	pte_t *pte = kmap_atomic(pmd_page(*dir), type) +
+		(pmd_ptfn(*dir) << HV_LOG2_PAGE_TABLE_ALIGN) & ~PAGE_MASK;
+	return &pte[pte_index(address)];
+}
+#endif
+
+/*
+ * List of all pgd's needed so it can invalidate entries in both cached
+ * and uncached pgd's. This is essentially codepath-based locking
+ * against pageattr.c; it is the unique case in which a valid change
+ * of kernel pagetables can't be lazily synchronized by vmalloc faults.
+ * vmalloc faults work because attached pagetables are never freed.
+ * The locking scheme was chosen on the basis of manfred's
+ * recommendations and having no core impact whatsoever.
+ * -- wli
+ */
+DEFINE_SPINLOCK(pgd_lock);
+LIST_HEAD(pgd_list);
+
+static inline void pgd_list_add(pgd_t *pgd)
+{
+	list_add(pgd_to_list(pgd), &pgd_list);
+}
+
+static inline void pgd_list_del(pgd_t *pgd)
+{
+	list_del(pgd_to_list(pgd));
+}
+
+#define KERNEL_PGD_INDEX_START pgd_index(PAGE_OFFSET)
+#define KERNEL_PGD_PTRS (PTRS_PER_PGD - KERNEL_PGD_INDEX_START)
+
+static void pgd_ctor(pgd_t *pgd)
+{
+	unsigned long flags;
+
+	memset(pgd, 0, KERNEL_PGD_INDEX_START*sizeof(pgd_t));
+	spin_lock_irqsave(&pgd_lock, flags);
+
+#ifndef __tilegx__
+	/*
+	 * Check that the user interrupt vector has no L2.
+	 * It never should for the swapper, and new page tables
+	 * should always start with an empty user interrupt vector.
+	 */
+	BUG_ON(((u64 *)swapper_pg_dir)[pgd_index(MEM_USER_INTRPT)] != 0);
+#endif
+
+	clone_pgd_range(pgd + KERNEL_PGD_INDEX_START,
+			swapper_pg_dir + KERNEL_PGD_INDEX_START,
+			KERNEL_PGD_PTRS);
+
+	pgd_list_add(pgd);
+	spin_unlock_irqrestore(&pgd_lock, flags);
+}
+
+static void pgd_dtor(pgd_t *pgd)
+{
+	unsigned long flags; /* can be called from interrupt context */
+
+	spin_lock_irqsave(&pgd_lock, flags);
+	pgd_list_del(pgd);
+	spin_unlock_irqrestore(&pgd_lock, flags);
+}
+
+pgd_t *pgd_alloc(struct mm_struct *mm)
+{
+	pgd_t *pgd = kmem_cache_alloc(pgd_cache, GFP_KERNEL);
+	if (pgd)
+		pgd_ctor(pgd);
+	return pgd;
+}
+
+void pgd_free(struct mm_struct *mm, pgd_t *pgd)
+{
+	pgd_dtor(pgd);
+	kmem_cache_free(pgd_cache, pgd);
+}
+
+
+#define L2_USER_PGTABLE_PAGES (1 << L2_USER_PGTABLE_ORDER)
+
+struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address)
+{
+	int flags = GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO|__GFP_COMP;
+	struct page *p;
+
+#ifdef CONFIG_HIGHPTE
+	flags |= __GFP_HIGHMEM;
+#endif
+
+	p = alloc_pages(flags, L2_USER_PGTABLE_ORDER);
+	if (p == NULL)
+		return NULL;
+
+	pgtable_page_ctor(p);
+	return p;
+}
+
+/*
+ * Free page immediately (used in __pte_alloc if we raced with another
+ * process).  We have to correct whatever pte_alloc_one() did before
+ * returning the pages to the allocator.
+ */
+void pte_free(struct mm_struct *mm, struct page *p)
+{
+	pgtable_page_dtor(p);
+	__free_pages(p, L2_USER_PGTABLE_ORDER);
+}
+
+void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte,
+		    unsigned long address)
+{
+	int i;
+
+	pgtable_page_dtor(pte);
+	tlb->need_flush = 1;
+	if (tlb_fast_mode(tlb)) {
+		struct page *pte_pages[L2_USER_PGTABLE_PAGES];
+		for (i = 0; i < L2_USER_PGTABLE_PAGES; ++i)
+			pte_pages[i] = pte + i;
+		free_pages_and_swap_cache(pte_pages, L2_USER_PGTABLE_PAGES);
+		return;
+	}
+	for (i = 0; i < L2_USER_PGTABLE_PAGES; ++i) {
+		tlb->pages[tlb->nr++] = pte + i;
+		if (tlb->nr >= FREE_PTE_NR)
+			tlb_flush_mmu(tlb, 0, 0);
+	}
+}
+
+#ifndef __tilegx__
+
+/*
+ * FIXME: needs to be atomic vs hypervisor writes.  For now we make the
+ * window of vulnerability a bit smaller by doing an unlocked 8-bit update.
+ */
+int ptep_test_and_clear_young(struct vm_area_struct *vma,
+			      unsigned long addr, pte_t *ptep)
+{
+#if HV_PTE_INDEX_ACCESSED < 8 || HV_PTE_INDEX_ACCESSED >= 16
+# error Code assumes HV_PTE "accessed" bit in second byte
+#endif
+	u8 *tmp = (u8 *)ptep;
+	u8 second_byte = tmp[1];
+	if (!(second_byte & (1 << (HV_PTE_INDEX_ACCESSED - 8))))
+		return 0;
+	tmp[1] = second_byte & ~(1 << (HV_PTE_INDEX_ACCESSED - 8));
+	return 1;
+}
+
+/*
+ * This implementation is atomic vs hypervisor writes, since the hypervisor
+ * always writes the low word (where "accessed" and "dirty" are) and this
+ * routine only writes the high word.
+ */
+void ptep_set_wrprotect(struct mm_struct *mm,
+			unsigned long addr, pte_t *ptep)
+{
+#if HV_PTE_INDEX_WRITABLE < 32
+# error Code assumes HV_PTE "writable" bit in high word
+#endif
+	u32 *tmp = (u32 *)ptep;
+	tmp[1] = tmp[1] & ~(1 << (HV_PTE_INDEX_WRITABLE - 32));
+}
+
+#endif
+
+pte_t *virt_to_pte(struct mm_struct* mm, unsigned long addr)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	if (pgd_addr_invalid(addr))
+		return NULL;
+
+	pgd = mm ? pgd_offset(mm, addr) : swapper_pg_dir + pgd_index(addr);
+	pud = pud_offset(pgd, addr);
+	if (!pud_present(*pud))
+		return NULL;
+	pmd = pmd_offset(pud, addr);
+	if (pmd_huge_page(*pmd))
+		return (pte_t *)pmd;
+	if (!pmd_present(*pmd))
+		return NULL;
+	return pte_offset_kernel(pmd, addr);
+}
+
+pgprot_t set_remote_cache_cpu(pgprot_t prot, int cpu)
+{
+	unsigned int width = smp_width;
+	int x = cpu % width;
+	int y = cpu / width;
+	BUG_ON(y >= smp_height);
+	BUG_ON(hv_pte_get_mode(prot) != HV_PTE_MODE_CACHE_TILE_L3);
+	BUG_ON(cpu < 0 || cpu >= NR_CPUS);
+	BUG_ON(!cpu_is_valid_lotar(cpu));
+	return hv_pte_set_lotar(prot, HV_XY_TO_LOTAR(x, y));
+}
+
+int get_remote_cache_cpu(pgprot_t prot)
+{
+	HV_LOTAR lotar = hv_pte_get_lotar(prot);
+	int x = HV_LOTAR_X(lotar);
+	int y = HV_LOTAR_Y(lotar);
+	BUG_ON(hv_pte_get_mode(prot) != HV_PTE_MODE_CACHE_TILE_L3);
+	return x + y * smp_width;
+}
+
+void set_pte_order(pte_t *ptep, pte_t pte, int order)
+{
+	unsigned long pfn = pte_pfn(pte);
+	struct page *page = pfn_to_page(pfn);
+
+	/* Update the home of a PTE if necessary */
+	pte = pte_set_home(pte, page_home(page));
+
+#ifdef __tilegx__
+	*ptep = pte;
+#else
+	/*
+	 * When setting a PTE, write the high bits first, then write
+	 * the low bits.  This sets the "present" bit only after the
+	 * other bits are in place.  If a particular PTE update
+	 * involves transitioning from one valid PTE to another, it
+	 * may be necessary to call set_pte_order() more than once,
+	 * transitioning via a suitable intermediate state.
+	 * Note that this sequence also means that if we are transitioning
+	 * from any migrating PTE to a non-migrating one, we will not
+	 * see a half-updated PTE with the migrating bit off.
+	 */
+#if HV_PTE_INDEX_PRESENT >= 32 || HV_PTE_INDEX_MIGRATING >= 32
+# error Must write the present and migrating bits last
+#endif
+	((u32 *)ptep)[1] = (u32)(pte_val(pte) >> 32);
+	barrier();
+	((u32 *)ptep)[0] = (u32)(pte_val(pte));
+#endif
+}
+
+/* Can this mm load a PTE with cached_priority set? */
+static inline int mm_is_priority_cached(struct mm_struct *mm)
+{
+	return mm->context.priority_cached;
+}
+
+/*
+ * Add a priority mapping to an mm_context and
+ * notify the hypervisor if this is the first one.
+ */
+void start_mm_caching(struct mm_struct *mm)
+{
+	if (!mm_is_priority_cached(mm)) {
+		mm->context.priority_cached = -1U;
+		hv_set_caching(-1U);
+	}
+}
+
+/*
+ * Validate and return the priority_cached flag.  We know if it's zero
+ * that we don't need to scan, since we immediately set it non-zero
+ * when we first consider a MAP_CACHE_PRIORITY mapping.
+ *
+ * We only _try_ to acquire the mmap_sem semaphore; if we can't acquire it,
+ * since we're in an interrupt context (servicing switch_mm) we don't
+ * worry about it and don't unset the "priority_cached" field.
+ * Presumably we'll come back later and have more luck and clear
+ * the value then; for now we'll just keep the cache marked for priority.
+ */
+static unsigned int update_priority_cached(struct mm_struct *mm)
+{
+	if (mm->context.priority_cached && down_write_trylock(&mm->mmap_sem)) {
+		struct vm_area_struct *vm;
+		for (vm = mm->mmap; vm; vm = vm->vm_next) {
+			if (hv_pte_get_cached_priority(vm->vm_page_prot))
+				break;
+		}
+		if (vm == NULL)
+			mm->context.priority_cached = 0;
+		up_write(&mm->mmap_sem);
+	}
+	return mm->context.priority_cached;
+}
+
+/* Set caching correctly for an mm that we are switching to. */
+void check_mm_caching(struct mm_struct *prev, struct mm_struct *next)
+{
+	if (!mm_is_priority_cached(next)) {
+		/*
+		 * If the new mm doesn't use priority caching, just see if we
+		 * need the hv_set_caching(), or can assume it's already zero.
+		 */
+		if (mm_is_priority_cached(prev))
+			hv_set_caching(0);
+	} else {
+		hv_set_caching(update_priority_cached(next));
+	}
+}
+
+#if CHIP_HAS_MMIO()
+
+/* Map an arbitrary MMIO address, homed according to pgprot, into VA space. */
+void __iomem *ioremap_prot(resource_size_t phys_addr, unsigned long size,
+			   pgprot_t home)
+{
+	void *addr;
+	struct vm_struct *area;
+	unsigned long offset, last_addr;
+	pgprot_t pgprot;
+
+	/* Don't allow wraparound or zero size */
+	last_addr = phys_addr + size - 1;
+	if (!size || last_addr < phys_addr)
+		return NULL;
+
+	/* Create a read/write, MMIO VA mapping homed at the requested shim. */
+	pgprot = PAGE_KERNEL;
+	pgprot = hv_pte_set_mode(pgprot, HV_PTE_MODE_MMIO);
+	pgprot = hv_pte_set_lotar(pgprot, hv_pte_get_lotar(home));
+
+	/*
+	 * Mappings have to be page-aligned
+	 */
+	offset = phys_addr & ~PAGE_MASK;
+	phys_addr &= PAGE_MASK;
+	size = PAGE_ALIGN(last_addr+1) - phys_addr;
+
+	/*
+	 * Ok, go for it..
+	 */
+	area = get_vm_area(size, VM_IOREMAP /* | other flags? */);
+	if (!area)
+		return NULL;
+	area->phys_addr = phys_addr;
+	addr = area->addr;
+	if (ioremap_page_range((unsigned long)addr, (unsigned long)addr + size,
+			       phys_addr, pgprot)) {
+		remove_vm_area((void *)(PAGE_MASK & (unsigned long) addr));
+		return NULL;
+	}
+	return (__force void __iomem *) (offset + (char *)addr);
+}
+EXPORT_SYMBOL(ioremap_prot);
+
+/* Map a PCI MMIO bus address into VA space. */
+void __iomem *ioremap(resource_size_t phys_addr, unsigned long size)
+{
+	panic("ioremap for PCI MMIO is not supported");
+}
+EXPORT_SYMBOL(ioremap);
+
+/* Unmap an MMIO VA mapping. */
+void iounmap(volatile void __iomem *addr_in)
+{
+	volatile void __iomem *addr = (volatile void __iomem *)
+		(PAGE_MASK & (unsigned long __force)addr_in);
+#if 1
+	vunmap((void * __force)addr);
+#else
+	/* x86 uses this complicated flow instead of vunmap().  Is
+	 * there any particular reason we should do the same? */
+	struct vm_struct *p, *o;
+
+	/* Use the vm area unlocked, assuming the caller
+	   ensures there isn't another iounmap for the same address
+	   in parallel. Reuse of the virtual address is prevented by
+	   leaving it in the global lists until we're done with it.
+	   cpa takes care of the direct mappings. */
+	read_lock(&vmlist_lock);
+	for (p = vmlist; p; p = p->next) {
+		if (p->addr == addr)
+			break;
+	}
+	read_unlock(&vmlist_lock);
+
+	if (!p) {
+		printk("iounmap: bad address %p\n", addr);
+		dump_stack();
+		return;
+	}
+
+	/* Finally remove it */
+	o = remove_vm_area((void *)addr);
+	BUG_ON(p != o || o == NULL);
+	kfree(p);
+#endif
+}
+EXPORT_SYMBOL(iounmap);
+
+#endif /* CHIP_HAS_MMIO() */
-- 
1.6.5.2

