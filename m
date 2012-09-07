Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab2IGQhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:37:14 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34248 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab2IGQ1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:27:52 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 06/31] arm64: MMU fault handling and page table management
Date: Fri,  7 Sep 2012 17:26:41 +0100
Message-Id: <1347035226-18649-7-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Sep 2012 16:27:49.0800 (UTC) FILETIME=[B8CEC280:01CD8D15]
X-MC-Unique: 112090717275101301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q87GbMJc008491

This patch adds support for the handling of the MMU faults (exception
entry code introduced by a previous patch) and page table management.

The user translation table is pointed to by TTBR0 and the kernel one
(swapper_pg_dir) by TTBR1. There is no translation information shared or
address space overlapping between user and kernel page tables.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm64/include/asm/page.h    |   67 +++++
 arch/arm64/include/asm/pgalloc.h |  113 ++++++++
 arch/arm64/mm/copypage.c         |   34 +++
 arch/arm64/mm/extable.c          |   17 ++
 arch/arm64/mm/fault.c            |  534 ++++++++++++++++++++++++++++++++++++++
 arch/arm64/mm/mm.h               |    2 +
 arch/arm64/mm/mmap.c             |  144 ++++++++++
 arch/arm64/mm/pgd.c              |   54 ++++
 8 files changed, 965 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/include/asm/page.h
 create mode 100644 arch/arm64/include/asm/pgalloc.h
 create mode 100644 arch/arm64/mm/copypage.c
 create mode 100644 arch/arm64/mm/extable.c
 create mode 100644 arch/arm64/mm/fault.c
 create mode 100644 arch/arm64/mm/mm.h
 create mode 100644 arch/arm64/mm/mmap.c
 create mode 100644 arch/arm64/mm/pgd.c

diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
new file mode 100644
index 0000000..46bf666
--- /dev/null
+++ b/arch/arm64/include/asm/page.h
@@ -0,0 +1,67 @@
+/*
+ * Based on arch/arm/include/asm/page.h
+ *
+ * Copyright (C) 1995-2003 Russell King
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_PAGE_H
+#define __ASM_PAGE_H
+
+/* PAGE_SHIFT determines the page size */
+#ifdef CONFIG_ARM64_64K_PAGES
+#define PAGE_SHIFT		16
+#else
+#define PAGE_SHIFT		12
+#endif
+#define PAGE_SIZE		(_AC(1,UL) << PAGE_SHIFT)
+#define PAGE_MASK		(~(PAGE_SIZE-1))
+
+/* We do define AT_SYSINFO_EHDR but don't use the gate mechanism */
+#define __HAVE_ARCH_GATE_AREA		1
+
+#ifndef __ASSEMBLY__
+
+#ifdef CONFIG_ARM64_64K_PAGES
+#include <asm/pgtable-2level-types.h>
+#else
+#include <asm/pgtable-3level-types.h>
+#endif
+
+extern void __cpu_clear_user_page(void *p, unsigned long user);
+extern void __cpu_copy_user_page(void *to, const void *from,
+				 unsigned long user);
+extern void copy_page(void *to, const void *from);
+extern void clear_page(void *to);
+
+#define clear_user_page(addr,vaddr,pg)  __cpu_clear_user_page(addr, vaddr)
+#define copy_user_page(to,from,vaddr,pg) __cpu_copy_user_page(to, from, vaddr)
+
+typedef struct page *pgtable_t;
+
+#ifdef CONFIG_HAVE_ARCH_PFN_VALID
+extern int pfn_valid(unsigned long);
+#endif
+
+#include <asm/memory.h>
+
+#endif /* !__ASSEMBLY__ */
+
+#define VM_DATA_DEFAULT_FLAGS \
+	(((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0) | \
+	 VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+
+#include <asm-generic/getorder.h>
+
+#endif
diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pgalloc.h
new file mode 100644
index 0000000..f214069
--- /dev/null
+++ b/arch/arm64/include/asm/pgalloc.h
@@ -0,0 +1,113 @@
+/*
+ * Based on arch/arm/include/asm/pgalloc.h
+ *
+ * Copyright (C) 2000-2001 Russell King
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_PGALLOC_H
+#define __ASM_PGALLOC_H
+
+#include <asm/pgtable-hwdef.h>
+#include <asm/processor.h>
+#include <asm/cacheflush.h>
+#include <asm/tlbflush.h>
+
+#define check_pgt_cache()		do { } while (0)
+
+#ifndef CONFIG_ARM64_64K_PAGES
+
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
+{
+	return (pmd_t *)get_zeroed_page(GFP_KERNEL | __GFP_REPEAT);
+}
+
+static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
+{
+	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
+	free_page((unsigned long)pmd);
+}
+
+static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
+{
+	set_pud(pud, __pud(__pa(pmd) | PMD_TYPE_TABLE));
+}
+
+#endif	/* CONFIG_ARM64_64K_PAGES */
+
+extern pgd_t *pgd_alloc(struct mm_struct *mm);
+extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
+
+#define PGALLOC_GFP	(GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO)
+
+static inline pte_t *
+pte_alloc_one_kernel(struct mm_struct *mm, unsigned long addr)
+{
+	return (pte_t *)__get_free_page(PGALLOC_GFP);
+}
+
+static inline pgtable_t
+pte_alloc_one(struct mm_struct *mm, unsigned long addr)
+{
+	struct page *pte;
+
+	pte = alloc_pages(PGALLOC_GFP, 0);
+	if (pte)
+		pgtable_page_ctor(pte);
+
+	return pte;
+}
+
+/*
+ * Free a PTE table.
+ */
+static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
+{
+	if (pte)
+		free_page((unsigned long)pte);
+}
+
+static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
+{
+	pgtable_page_dtor(pte);
+	__free_page(pte);
+}
+
+static inline void __pmd_populate(pmd_t *pmdp, phys_addr_t pte,
+				  pmdval_t prot)
+{
+	set_pmd(pmdp, __pmd(pte | prot));
+}
+
+/*
+ * Populate the pmdp entry with a pointer to the pte.  This pmd is part
+ * of the mm address space.
+ */
+static inline void
+pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmdp, pte_t *ptep)
+{
+	/*
+	 * The pmd must be loaded with the physical address of the PTE table
+	 */
+	__pmd_populate(pmdp, __pa(ptep), PMD_TYPE_TABLE);
+}
+
+static inline void
+pmd_populate(struct mm_struct *mm, pmd_t *pmdp, pgtable_t ptep)
+{
+	__pmd_populate(pmdp, page_to_phys(ptep), PMD_TYPE_TABLE);
+}
+#define pmd_pgtable(pmd) pmd_page(pmd)
+
+#endif
diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
new file mode 100644
index 0000000..9aecbac
--- /dev/null
+++ b/arch/arm64/mm/copypage.c
@@ -0,0 +1,34 @@
+/*
+ * Based on arch/arm/mm/copypage.c
+ *
+ * Copyright (C) 2002 Deep Blue Solutions Ltd, All Rights Reserved.
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/mm.h>
+
+#include <asm/page.h>
+#include <asm/cacheflush.h>
+
+void __cpu_copy_user_page(void *kto, const void *kfrom, unsigned long vaddr)
+{
+	copy_page(kto, kfrom);
+	__flush_dcache_area(kto, PAGE_SIZE);
+}
+
+void __cpu_clear_user_page(void *kaddr, unsigned long vaddr)
+{
+	clear_page(kaddr);
+}
diff --git a/arch/arm64/mm/extable.c b/arch/arm64/mm/extable.c
new file mode 100644
index 0000000..7944427
--- /dev/null
+++ b/arch/arm64/mm/extable.c
@@ -0,0 +1,17 @@
+/*
+ * Based on arch/arm/mm/extable.c
+ */
+
+#include <linux/module.h>
+#include <linux/uaccess.h>
+
+int fixup_exception(struct pt_regs *regs)
+{
+	const struct exception_table_entry *fixup;
+
+	fixup = search_exception_tables(instruction_pointer(regs));
+	if (fixup)
+		regs->pc = fixup->fixup;
+
+	return fixup != NULL;
+}
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
new file mode 100644
index 0000000..1909a69
--- /dev/null
+++ b/arch/arm64/mm/fault.c
@@ -0,0 +1,534 @@
+/*
+ * Based on arch/arm/mm/fault.c
+ *
+ * Copyright (C) 1995  Linus Torvalds
+ * Copyright (C) 1995-2004 Russell King
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/module.h>
+#include <linux/signal.h>
+#include <linux/mm.h>
+#include <linux/hardirq.h>
+#include <linux/init.h>
+#include <linux/kprobes.h>
+#include <linux/uaccess.h>
+#include <linux/page-flags.h>
+#include <linux/sched.h>
+#include <linux/highmem.h>
+#include <linux/perf_event.h>
+
+#include <asm/exception.h>
+#include <asm/debug-monitors.h>
+#include <asm/system_misc.h>
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
+
+/*
+ * Dump out the page tables associated with 'addr' in mm 'mm'.
+ */
+void show_pte(struct mm_struct *mm, unsigned long addr)
+{
+	pgd_t *pgd;
+
+	if (!mm)
+		mm = &init_mm;
+
+	pr_alert("pgd = %p\n", mm->pgd);
+	pgd = pgd_offset(mm, addr);
+	pr_alert("[%08lx] *pgd=%016llx", addr, pgd_val(*pgd));
+
+	do {
+		pud_t *pud;
+		pmd_t *pmd;
+		pte_t *pte;
+
+		if (pgd_none_or_clear_bad(pgd))
+			break;
+
+		pud = pud_offset(pgd, addr);
+		if (pud_none_or_clear_bad(pud))
+			break;
+
+		pmd = pmd_offset(pud, addr);
+		printk(", *pmd=%016llx", pmd_val(*pmd));
+		if (pmd_none_or_clear_bad(pmd))
+			break;
+
+		pte = pte_offset_map(pmd, addr);
+		printk(", *pte=%016llx", pte_val(*pte));
+		pte_unmap(pte);
+	} while(0);
+
+	printk("\n");
+}
+
+/*
+ * The kernel tried to access some page that wasn't present.
+ */
+static void __do_kernel_fault(struct mm_struct *mm, unsigned long addr,
+			      unsigned int esr, struct pt_regs *regs)
+{
+	/*
+	 * Are we prepared to handle this kernel fault?
+	 */
+	if (fixup_exception(regs))
+		return;
+
+	/*
+	 * No handler, we'll have to terminate things with extreme prejudice.
+	 */
+	bust_spinlocks(1);
+	pr_alert("Unable to handle kernel %s at virtual address %08lx\n",
+		 (addr < PAGE_SIZE) ? "NULL pointer dereference" :
+		 "paging request", addr);
+
+	show_pte(mm, addr);
+	die("Oops", regs, esr);
+	bust_spinlocks(0);
+	do_exit(SIGKILL);
+}
+
+/*
+ * Something tried to access memory that isn't in our memory map. User mode
+ * accesses just cause a SIGSEGV
+ */
+static void __do_user_fault(struct task_struct *tsk, unsigned long addr,
+			    unsigned int esr, unsigned int sig, int code,
+			    struct pt_regs *regs)
+{
+	struct siginfo si;
+
+	if (show_unhandled_signals) {
+		pr_info("%s[%d]: unhandled page fault (%d) at 0x%08lx, code 0x%03x\n",
+			tsk->comm, task_pid_nr(tsk), sig, addr, esr);
+		show_pte(tsk->mm, addr);
+		show_regs(regs);
+	}
+
+	tsk->thread.fault_address = addr;
+	si.si_signo = sig;
+	si.si_errno = 0;
+	si.si_code = code;
+	si.si_addr = (void __user *)addr;
+	force_sig_info(sig, &si, tsk);
+}
+
+void do_bad_area(unsigned long addr, unsigned int esr, struct pt_regs *regs)
+{
+	struct task_struct *tsk = current;
+	struct mm_struct *mm = tsk->active_mm;
+
+	/*
+	 * If we are in kernel mode at this point, we have no context to
+	 * handle this fault with.
+	 */
+	if (user_mode(regs))
+		__do_user_fault(tsk, addr, esr, SIGSEGV, SEGV_MAPERR, regs);
+	else
+		__do_kernel_fault(mm, addr, esr, regs);
+}
+
+#define VM_FAULT_BADMAP		0x010000
+#define VM_FAULT_BADACCESS	0x020000
+
+#define ESR_WRITE		(1 << 6)
+#define ESR_LNX_EXEC		(1 << 24)
+
+/*
+ * Check that the permissions on the VMA allow for the fault which occurred.
+ * If we encountered a write fault, we must have write permission, otherwise
+ * we allow any permission.
+ */
+static inline bool access_error(unsigned int esr, struct vm_area_struct *vma)
+{
+	unsigned int mask = VM_READ | VM_WRITE | VM_EXEC;
+
+	if (esr & ESR_WRITE)
+		mask = VM_WRITE;
+	if (esr & ESR_LNX_EXEC)
+		mask = VM_EXEC;
+
+	return vma->vm_flags & mask ? false : true;
+}
+
+static int __do_page_fault(struct mm_struct *mm, unsigned long addr,
+			   unsigned int esr, unsigned int flags,
+			   struct task_struct *tsk)
+{
+	struct vm_area_struct *vma;
+	int fault;
+
+	vma = find_vma(mm, addr);
+	fault = VM_FAULT_BADMAP;
+	if (unlikely(!vma))
+		goto out;
+	if (unlikely(vma->vm_start > addr))
+		goto check_stack;
+
+	/*
+	 * Ok, we have a good vm_area for this memory access, so we can handle
+	 * it.
+	 */
+good_area:
+	if (access_error(esr, vma)) {
+		fault = VM_FAULT_BADACCESS;
+		goto out;
+	}
+
+	return handle_mm_fault(mm, vma, addr & PAGE_MASK, flags);
+
+check_stack:
+	if (vma->vm_flags & VM_GROWSDOWN && !expand_stack(vma, addr))
+		goto good_area;
+out:
+	return fault;
+}
+
+static int __kprobes do_page_fault(unsigned long addr, unsigned int esr,
+				   struct pt_regs *regs)
+{
+	struct task_struct *tsk;
+	struct mm_struct *mm;
+	int fault, sig, code;
+	int write = esr & ESR_WRITE;
+	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
+		(write ? FAULT_FLAG_WRITE : 0);
+
+	tsk = current;
+	mm  = tsk->mm;
+
+	/* Enable interrupts if they were enabled in the parent context. */
+	if (interrupts_enabled(regs))
+		local_irq_enable();
+
+	/*
+	 * If we're in an interrupt or have no user context, we must not take
+	 * the fault.
+	 */
+	if (in_atomic() || !mm)
+		goto no_context;
+
+	/*
+	 * As per x86, we may deadlock here. However, since the kernel only
+	 * validly references user space from well defined areas of the code,
+	 * we can bug out early if this is from code which shouldn't.
+	 */
+	if (!down_read_trylock(&mm->mmap_sem)) {
+		if (!user_mode(regs) && !search_exception_tables(regs->pc))
+			goto no_context;
+retry:
+		down_read(&mm->mmap_sem);
+	} else {
+		/*
+		 * The above down_read_trylock() might have succeeded in which
+		 * case, we'll have missed the might_sleep() from down_read().
+		 */
+		might_sleep();
+#ifdef CONFIG_DEBUG_VM
+		if (!user_mode(regs) && !search_exception_tables(regs->pc))
+			goto no_context;
+#endif
+	}
+
+	fault = __do_page_fault(mm, addr, esr, flags, tsk);
+
+	/*
+	 * If we need to retry but a fatal signal is pending, handle the
+	 * signal first. We do not need to release the mmap_sem because it
+	 * would already be released in __lock_page_or_retry in mm/filemap.c.
+	 */
+	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+		return 0;
+
+	/*
+	 * Major/minor page fault accounting is only done on the initial
+	 * attempt. If we go through a retry, it is extremely likely that the
+	 * page will be found in page cache at that point.
+	 */
+
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
+	if (flags & FAULT_FLAG_ALLOW_RETRY) {
+		if (fault & VM_FAULT_MAJOR) {
+			tsk->maj_flt++;
+			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs,
+				      addr);
+		} else {
+			tsk->min_flt++;
+			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, regs,
+				      addr);
+		}
+		if (fault & VM_FAULT_RETRY) {
+			/*
+			 * Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk of
+			 * starvation.
+			 */
+			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			goto retry;
+		}
+	}
+
+	up_read(&mm->mmap_sem);
+
+	/*
+	 * Handle the "normal" case first - VM_FAULT_MAJOR / VM_FAULT_MINOR
+	 */
+	if (likely(!(fault & (VM_FAULT_ERROR | VM_FAULT_BADMAP |
+			      VM_FAULT_BADACCESS))))
+		return 0;
+
+	if (fault & VM_FAULT_OOM) {
+		/*
+		 * We ran out of memory, call the OOM killer, and return to
+		 * userspace (which will retry the fault, or kill us if we got
+		 * oom-killed).
+		 */
+		pagefault_out_of_memory();
+		return 0;
+	}
+
+	/*
+	 * If we are in kernel mode at this point, we have no context to
+	 * handle this fault with.
+	 */
+	if (!user_mode(regs))
+		goto no_context;
+
+	if (fault & VM_FAULT_SIGBUS) {
+		/*
+		 * We had some memory, but were unable to successfully fix up
+		 * this page fault.
+		 */
+		sig = SIGBUS;
+		code = BUS_ADRERR;
+	} else {
+		/*
+		 * Something tried to access memory that isn't in our memory
+		 * map.
+		 */
+		sig = SIGSEGV;
+		code = fault == VM_FAULT_BADACCESS ?
+			SEGV_ACCERR : SEGV_MAPERR;
+	}
+
+	__do_user_fault(tsk, addr, esr, sig, code, regs);
+	return 0;
+
+no_context:
+	__do_kernel_fault(mm, addr, esr, regs);
+	return 0;
+}
+
+/*
+ * First Level Translation Fault Handler
+ *
+ * We enter here because the first level page table doesn't contain a valid
+ * entry for the address.
+ *
+ * If the address is in kernel space (>= TASK_SIZE), then we are probably
+ * faulting in the vmalloc() area.
+ *
+ * If the init_task's first level page tables contains the relevant entry, we
+ * copy the it to this task.  If not, we send the process a signal, fixup the
+ * exception, or oops the kernel.
+ *
+ * NOTE! We MUST NOT take any locks for this case. We may be in an interrupt
+ * or a critical region, and should only copy the information from the master
+ * page table, nothing more.
+ */
+static int __kprobes do_translation_fault(unsigned long addr,
+					  unsigned int esr,
+					  struct pt_regs *regs)
+{
+	if (addr < TASK_SIZE)
+		return do_page_fault(addr, esr, regs);
+
+	do_bad_area(addr, esr, regs);
+	return 0;
+}
+
+/*
+ * Some section permission faults need to be handled gracefully.  They can
+ * happen due to a __{get,put}_user during an oops.
+ */
+static int do_sect_fault(unsigned long addr, unsigned int esr,
+			 struct pt_regs *regs)
+{
+	do_bad_area(addr, esr, regs);
+	return 0;
+}
+
+/*
+ * This abort handler always returns "fault".
+ */
+static int do_bad(unsigned long addr, unsigned int esr, struct pt_regs *regs)
+{
+	return 1;
+}
+
+static struct fault_info {
+	int	(*fn)(unsigned long addr, unsigned int esr, struct pt_regs *regs);
+	int	sig;
+	int	code;
+	const char *name;
+} fault_info[] = {
+	{ do_bad,		SIGBUS,  0,		"ttbr address size fault"	},
+	{ do_bad,		SIGBUS,  0,		"level 1 address size fault"	},
+	{ do_bad,		SIGBUS,  0,		"level 2 address size fault"	},
+	{ do_bad,		SIGBUS,  0,		"level 3 address size fault"	},
+	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"input address range fault"	},
+	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"level 1 translation fault"	},
+	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"level 2 translation fault"	},
+	{ do_page_fault,	SIGSEGV, SEGV_MAPERR,	"level 3 translation fault"	},
+	{ do_bad,		SIGBUS,  0,		"reserved access flag fault"	},
+	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"level 1 access flag fault"	},
+	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"level 2 access flag fault"	},
+	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 3 access flag fault"	},
+	{ do_bad,		SIGBUS,  0,		"reserved permission fault"	},
+	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"level 1 permission fault"	},
+	{ do_sect_fault,	SIGSEGV, SEGV_ACCERR,	"level 2 permission fault"	},
+	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 3 permission fault"	},
+	{ do_bad,		SIGBUS,  0,		"synchronous external abort"	},
+	{ do_bad,		SIGBUS,  0,		"asynchronous external abort"	},
+	{ do_bad,		SIGBUS,  0,		"unknown 18"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 19"			},
+	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
+	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
+	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
+	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
+	{ do_bad,		SIGBUS,  0,		"synchronous parity error"	},
+	{ do_bad,		SIGBUS,  0,		"asynchronous parity error"	},
+	{ do_bad,		SIGBUS,  0,		"unknown 26"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 27"			},
+	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk" },
+	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk" },
+	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk" },
+	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk" },
+	{ do_bad,		SIGBUS,  0,		"unknown 32"			},
+	{ do_bad,		SIGBUS,  BUS_ADRALN,	"alignment fault"		},
+	{ do_bad,		SIGBUS,  0,		"debug event"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 35"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 36"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 37"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 38"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 39"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 40"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 41"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 42"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 43"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 44"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 45"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 46"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 47"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 48"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 49"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 50"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 51"			},
+	{ do_bad,		SIGBUS,  0,		"implementation fault (lockdown abort)" },
+	{ do_bad,		SIGBUS,  0,		"unknown 53"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 54"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 55"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 56"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 57"			},
+	{ do_bad,		SIGBUS,  0,		"implementation fault (coprocessor abort)" },
+	{ do_bad,		SIGBUS,  0,		"unknown 59"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 60"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 61"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 62"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 63"			},
+};
+
+/*
+ * Dispatch a data abort to the relevant handler.
+ */
+asmlinkage void __exception do_mem_abort(unsigned long addr, unsigned int esr,
+					 struct pt_regs *regs)
+{
+	const struct fault_info *inf = fault_info + (esr & 63);
+	struct siginfo info;
+
+	if (!inf->fn(addr, esr, regs))
+		return;
+
+	pr_alert("Unhandled fault: %s (0x%08x) at 0x%016lx\n",
+		 inf->name, esr, addr);
+
+	info.si_signo = inf->sig;
+	info.si_errno = 0;
+	info.si_code  = inf->code;
+	info.si_addr  = (void __user *)addr;
+	arm64_notify_die("", regs, &info, esr);
+}
+
+/*
+ * Handle stack alignment exceptions.
+ */
+asmlinkage void __exception do_sp_pc_abort(unsigned long addr,
+					   unsigned int esr,
+					   struct pt_regs *regs)
+{
+	struct siginfo info;
+
+	info.si_signo = SIGBUS;
+	info.si_errno = 0;
+	info.si_code  = BUS_ADRALN;
+	info.si_addr  = (void __user *)addr;
+	arm64_notify_die("", regs, &info, esr);
+}
+
+static struct fault_info debug_fault_info[] = {
+	{ do_bad,	SIGTRAP,	TRAP_HWBKPT,	"hardware breakpoint"	},
+	{ do_bad,	SIGTRAP,	TRAP_HWBKPT,	"hardware single-step"	},
+	{ do_bad,	SIGTRAP,	TRAP_HWBKPT,	"hardware watchpoint"	},
+	{ do_bad,	SIGBUS,		0,		"unknown 3"		},
+	{ do_bad,	SIGTRAP,	TRAP_BRKPT,	"aarch32 BKPT"		},
+	{ do_bad,	SIGTRAP,	0,		"aarch32 vector catch"	},
+	{ do_bad,	SIGTRAP,	TRAP_BRKPT,	"aarch64 BRK"		},
+	{ do_bad,	SIGBUS,		0,		"unknown 7"		},
+};
+
+void __init hook_debug_fault_code(int nr,
+				  int (*fn)(unsigned long, unsigned int, struct pt_regs *),
+				  int sig, int code, const char *name)
+{
+	BUG_ON(nr < 0 || nr >= ARRAY_SIZE(debug_fault_info));
+
+	debug_fault_info[nr].fn		= fn;
+	debug_fault_info[nr].sig	= sig;
+	debug_fault_info[nr].code	= code;
+	debug_fault_info[nr].name	= name;
+}
+
+asmlinkage int __exception do_debug_exception(unsigned long addr,
+					      unsigned int esr,
+					      struct pt_regs *regs)
+{
+	const struct fault_info *inf = debug_fault_info + DBG_ESR_EVT(esr);
+	struct siginfo info;
+
+	if (!inf->fn(addr, esr, regs))
+		return 1;
+
+	pr_alert("Unhandled debug exception: %s (0x%08x) at 0x%016lx\n",
+		 inf->name, esr, addr);
+
+	info.si_signo = inf->sig;
+	info.si_errno = 0;
+	info.si_code  = inf->code;
+	info.si_addr  = (void __user *)addr;
+	arm64_notify_die("", regs, &info, esr);
+
+	return 0;
+}
diff --git a/arch/arm64/mm/mm.h b/arch/arm64/mm/mm.h
new file mode 100644
index 0000000..c84f68b
--- /dev/null
+++ b/arch/arm64/mm/mm.h
@@ -0,0 +1,2 @@
+extern void __flush_dcache_page(struct address_space *mapping, struct page *page);
+extern void __init bootmem_init(void);
diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
new file mode 100644
index 0000000..7c7be78
--- /dev/null
+++ b/arch/arm64/mm/mmap.c
@@ -0,0 +1,144 @@
+/*
+ * Based on arch/arm/mm/mmap.c
+ *
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/elf.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/export.h>
+#include <linux/shm.h>
+#include <linux/sched.h>
+#include <linux/io.h>
+#include <linux/personality.h>
+#include <linux/random.h>
+
+#include <asm/cputype.h>
+
+/*
+ * Leave enough space between the mmap area and the stack to honour ulimit in
+ * the face of randomisation.
+ */
+#define MIN_GAP (SZ_128M + ((STACK_RND_MASK << PAGE_SHIFT) + 1))
+#define MAX_GAP	(STACK_TOP/6*5)
+
+static int mmap_is_legacy(void)
+{
+	if (current->personality & ADDR_COMPAT_LAYOUT)
+		return 1;
+
+	if (rlimit(RLIMIT_STACK) == RLIM_INFINITY)
+		return 1;
+
+	return sysctl_legacy_va_layout;
+}
+
+/*
+ * Since get_random_int() returns the same value within a 1 jiffy window, we
+ * will almost always get the same randomisation for the stack and mmap
+ * region. This will mean the relative distance between stack and mmap will be
+ * the same.
+ *
+ * To avoid this we can shift the randomness by 1 bit.
+ */
+static unsigned long mmap_rnd(void)
+{
+	unsigned long rnd = 0;
+
+	if (current->flags & PF_RANDOMIZE)
+		rnd = (long)get_random_int() & (STACK_RND_MASK >> 1);
+
+	return rnd << (PAGE_SHIFT + 1);
+}
+
+static unsigned long mmap_base(void)
+{
+	unsigned long gap = rlimit(RLIMIT_STACK);
+
+	if (gap < MIN_GAP)
+		gap = MIN_GAP;
+	else if (gap > MAX_GAP)
+		gap = MAX_GAP;
+
+	return PAGE_ALIGN(STACK_TOP - gap - mmap_rnd());
+}
+
+/*
+ * This function, called very early during the creation of a new process VM
+ * image, sets up which VM layout function to use:
+ */
+void arch_pick_mmap_layout(struct mm_struct *mm)
+{
+	/*
+	 * Fall back to the standard layout if the personality bit is set, or
+	 * if the expected stack growth is unlimited:
+	 */
+	if (mmap_is_legacy()) {
+		mm->mmap_base = TASK_UNMAPPED_BASE;
+		mm->get_unmapped_area = arch_get_unmapped_area;
+		mm->unmap_area = arch_unmap_area;
+	} else {
+		mm->mmap_base = mmap_base();
+		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
+		mm->unmap_area = arch_unmap_area_topdown;
+	}
+}
+EXPORT_SYMBOL_GPL(arch_pick_mmap_layout);
+
+
+/*
+ * You really shouldn't be using read() or write() on /dev/mem.  This might go
+ * away in the future.
+ */
+int valid_phys_addr_range(unsigned long addr, size_t size)
+{
+	if (addr < PHYS_OFFSET)
+		return 0;
+	if (addr + size > __pa(high_memory - 1) + 1)
+		return 0;
+
+	return 1;
+}
+
+/*
+ * Do not allow /dev/mem mappings beyond the supported physical range.
+ */
+int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)
+{
+	return !(((pfn << PAGE_SHIFT) + size) & ~PHYS_MASK);
+}
+
+#ifdef CONFIG_STRICT_DEVMEM
+
+#include <linux/ioport.h>
+
+/*
+ * devmem_is_allowed() checks to see if /dev/mem access to a certain address
+ * is valid. The argument is a physical page number.  We mimic x86 here by
+ * disallowing access to system RAM as well as device-exclusive MMIO regions.
+ * This effectively disable read()/write() on /dev/mem.
+ */
+int devmem_is_allowed(unsigned long pfn)
+{
+	if (iomem_is_exclusive(pfn << PAGE_SHIFT))
+		return 0;
+	if (!page_is_ram(pfn))
+		return 1;
+	return 0;
+}
+
+#endif
diff --git a/arch/arm64/mm/pgd.c b/arch/arm64/mm/pgd.c
new file mode 100644
index 0000000..7083cda
--- /dev/null
+++ b/arch/arm64/mm/pgd.c
@@ -0,0 +1,54 @@
+/*
+ * PGD allocation/freeing
+ *
+ * Copyright (C) 2012 ARM Ltd.
+ * Author: Catalin Marinas <catalin.marinas@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/mm.h>
+#include <linux/gfp.h>
+#include <linux/highmem.h>
+#include <linux/slab.h>
+
+#include <asm/pgalloc.h>
+#include <asm/page.h>
+#include <asm/tlbflush.h>
+
+#include "mm.h"
+
+#define PGD_SIZE	(PTRS_PER_PGD * sizeof(pgd_t))
+
+pgd_t *pgd_alloc(struct mm_struct *mm)
+{
+	pgd_t *new_pgd;
+
+	if (PGD_SIZE == PAGE_SIZE)
+		new_pgd = (pgd_t *)get_zeroed_page(GFP_KERNEL);
+	else
+		new_pgd = kzalloc(PGD_SIZE, GFP_KERNEL);
+
+	if (!new_pgd)
+		return NULL;
+
+	return new_pgd;
+}
+
+void pgd_free(struct mm_struct *mm, pgd_t *pgd)
+{
+	if (PGD_SIZE == PAGE_SIZE)
+		free_page((unsigned long)pgd);
+	else
+		kfree(pgd);
+}

