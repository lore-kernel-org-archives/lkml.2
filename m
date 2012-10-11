Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab2JKF70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 01:59:26 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:39027 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747Ab2JKF7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 01:59:24 -0400
X-AuditID: b753bd60-8ecbeba0000047ca-a4-50765f4ffaf0
X-AuditID: b753bd60-8ecbeba0000047ca-a4-50765f4ffaf0
From: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
Subject: [RFC PATCH 2/3 V3] livedump: Add write protection management
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Vivek Goyal" <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Cc: "Al Viro" <viro@zeniv.linux.org.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Andy Lutomirski" <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Prarit Bhargava" <prarit@redhat.com>,
        "Srikar Dronamraju" <srikar@linux.vnet.ibm.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, "Khalid Aziz" <khalid.aziz@hp.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Thu, 11 Oct 2012 14:53:56 +0900
Message-ID: <20121011055356.6719.45548.stgit@t3500.sdl.hitachi.co.jp>
In-Reply-To: <20121011055356.6719.46214.stgit@t3500.sdl.hitachi.co.jp>
References: <20121011055356.6719.46214.stgit@t3500.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes it possible to write-protect pages in kernel space and to
install a handler function that is called every time when page fault occurs
on the protected page. The write protection is executed in the stop-machine
state to protect all pages consistently.

Processing of write protection and fault handling is executed in the order
as follows:

(1) Initialization phase
  - Sets up data structure for write protection management.
  - Splits all large pages in kernel space into 4K pages since currently
    livedump can handle only 4K pages. In the future, this step (page
    splitting) should be eliminated.
(2) Write protection phase
  - Stops machine.
  - Handles sensitive pages.
    (described below about sensitive pages)
  - Sets up write protection.
  - Resumes machine.
(3) Page fault exception handling
  - Calls the handler function before unprotecting the faulted page.
(4) Sweep phase
  - Calls the handler function against the rest of pages.
(5) Uninitialization phase
  - Cleans up all data structure for write protection management.

This patch exports the following 4 ioctl operations.
- Ioctl to invoke initialization phase
- Ioctl to invoke write protection phase
- Ioctl to invoke sweep phase
- Ioctl to invoke uninitialization phase

States of processing is as follows. They can transit only in this order.
- STATE_UNINIT
- STATE_INITED
- STATE_STARTED (= write protection already set up)
- STATE_SWEPT

However, this order is protected by a normal integer variable, therefore,
to be exact, this code is not yet safe against concurrent operation.

The livedump module has to acquire consistent memory image of kernel space.
Therefore, write protection is set up while update of memory state is
suspended. To do so, the livedump uses stop_machine currently.

Causing livedump's page fault (LPF) during LPF handling results in nested
LPF handling. Since LPF handler uses spinlocks, this situation may cause
deadlock. Therefore, any pages that can be updated during LPF handling must
not be write-protected. For the same reason, any pages that can be updated
during NMI handling must not be write-protected. NMI can happen during LPF
handling, and so LPF during NMI handling also results in nested LPF
handling. I call such pages that must not be write-protected
"sensitive page". Against the sensitive pages, the handler function is
called during the stop-machine state and they are not write-protected.

I list the sensitive pages in the following:

- Kernel/Exception/Interrupt stacks
- Page table structure
- All task_struct
- ".data" section of kernel
- per_cpu areas

Pages that are not updated don't cause page fault and so the handler
function is not invoked against them. To handle these pages, the livedump
module finally needs to call the handler function against each of them.
I call this phase "sweep", which is triggered by ioctl operation.

Signed-off-by: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
---

 arch/x86/Kconfig                 |   16 +
 arch/x86/include/asm/wrprotect.h |   45 +++
 arch/x86/mm/Makefile             |    2 
 arch/x86/mm/fault.c              |    7 
 arch/x86/mm/wrprotect.c          |  548 ++++++++++++++++++++++++++++++++++++++
 kernel/livedump.c                |   46 +++
 tools/livedump/livedump          |   32 ++
 7 files changed, 695 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/wrprotect.h
 create mode 100644 arch/x86/mm/wrprotect.c
 create mode 100755 tools/livedump/livedump

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 39c0813..e3b4e33 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1734,9 +1734,23 @@ config CMDLINE_OVERRIDE
 	  This is used to work around broken boot loaders.  This should
 	  be set to 'N' under normal conditions.
 
+config WRPROTECT
+	bool "Write protection on kernel space"
+	depends on X86_64
+	---help---
+	  Set this option to 'Y' to allow the kernel to write protect
+	  its own memory space and to handle page fault caused by the
+	  write protection.
+
+	  This feature regularly causes small overhead on kernel.
+	  Once this feature is activated, it causes much more overhead
+	  on kernel.
+
+	  If in doubt, say N.
+
 config LIVEDUMP
 	bool "Live Dump support"
-	depends on X86_64
+	depends on WRPROTECT
 	---help---
 	  Set this option to 'Y' to allow the kernel support to acquire
 	  a consistent snapshot of kernel space without stopping system.
diff --git a/arch/x86/include/asm/wrprotect.h b/arch/x86/include/asm/wrprotect.h
new file mode 100644
index 0000000..f674998
--- /dev/null
+++ b/arch/x86/include/asm/wrprotect.h
@@ -0,0 +1,45 @@
+/* wrprortect.h - Kernel space write protection support
+ * Copyright (C) 2012 Hitachi, Ltd.
+ * Author: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
+ * MA  02110-1301, USA.
+ */
+
+#ifndef _WRPROTECT_H
+#define _WRPROTECT_H
+
+typedef void (*fn_handle_page_t)(unsigned long pfn, int for_sweep);
+
+extern unsigned long *wrprotect_create_page_bitmap(void);
+extern void wrprotect_destroy_page_bitmap(unsigned long *pgbmp);
+
+extern int wrprotect_init(
+		unsigned long *pgbmp,
+		fn_handle_page_t fn_handle_page);
+extern void wrprotect_uninit(void);
+
+extern int wrprotect_start(void);
+extern int wrprotect_sweep(void);
+
+extern void wrprotect_unselect_pages(
+		unsigned long *pgbmp,
+		unsigned long start,
+		unsigned long len);
+
+extern int wrprotect_is_on;
+extern int wrprotect_page_fault_handler(unsigned long error_code);
+
+#endif /* _WRPROTECT_H */
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 23d8e5f..58f1428 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -28,3 +28,5 @@ obj-$(CONFIG_ACPI_NUMA)		+= srat.o
 obj-$(CONFIG_NUMA_EMU)		+= numa_emulation.o
 
 obj-$(CONFIG_MEMTEST)		+= memtest.o
+
+obj-$(CONFIG_WRPROTECT)		+= wrprotect.o
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 76dcd9d..fb30c98 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -18,6 +18,7 @@
 #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
 #include <asm/kmemcheck.h>		/* kmemcheck_*(), ...		*/
 #include <asm/fixmap.h>			/* VSYSCALL_START		*/
+#include <asm/wrprotect.h>		/* wrprotect_is_on, ...		*/
 
 /*
  * Page fault error code bits:
@@ -1018,6 +1019,12 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	/* Get the faulting address: */
 	address = read_cr2();
 
+#ifdef CONFIG_WRPROTECT
+	if (unlikely(wrprotect_is_on))
+		if (wrprotect_page_fault_handler(error_code))
+			return;
+#endif /* CONFIG_WRPROTECT */
+
 	/*
 	 * Detect and handle instructions that would cause a page fault for
 	 * both a tracked kernel page and a userspace page.
diff --git a/arch/x86/mm/wrprotect.c b/arch/x86/mm/wrprotect.c
new file mode 100644
index 0000000..4431724
--- /dev/null
+++ b/arch/x86/mm/wrprotect.c
@@ -0,0 +1,548 @@
+/* wrprotect.c - Kernel space write protection support
+ * Copyright (C) 2012 Hitachi, Ltd.
+ * Author: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
+ * MA  02110-1301, USA.
+ */
+
+#include <asm/wrprotect.h>
+#include <linux/mm.h>		/* num_physpages, __get_free_page, etc. */
+#include <linux/bitmap.h>	/* bit operations */
+#include <linux/vmalloc.h>	/* vzalloc, vfree */
+#include <linux/hugetlb.h>	/* __flush_tlb_all */
+#include <linux/stop_machine.h>	/* stop_machine */
+#include <asm/sections.h>	/* __per_cpu_* */
+
+int wrprotect_is_on;
+
+/* wrprotect's stuffs */
+static struct wrprotect {
+	int state;
+#define STATE_UNINIT 0
+#define STATE_INITED 1
+#define STATE_STARTED 2
+#define STATE_SWEPT 3
+
+	unsigned long *pgbmp;
+#define PGBMP_LEN PAGE_ALIGN(sizeof(long) * BITS_TO_LONGS(num_physpages))
+
+	fn_handle_page_t handle_page;
+} __aligned(PAGE_SIZE) wrprotect;
+
+/* split_large_pages
+ *
+ * This function splits all large pages in straight mapping area into 4K ones.
+ * Currently wrprotect supports only 4K pages, and so this is needed.
+ */
+static int split_large_pages(void)
+{
+	unsigned long pfn;
+	for (pfn = 0; pfn < num_physpages; pfn++) {
+		int ret = set_memory_4k((unsigned long)pfn_to_kaddr(pfn), 1);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+struct sm_context {
+	int leader_cpu;
+	int leader_done;
+	int (*fn_leader)(void *arg);
+	int (*fn_follower)(void *arg);
+	void *arg;
+};
+
+static int call_leader_follower(void *data)
+{
+	int ret;
+	struct sm_context *ctx = data;
+
+	if (smp_processor_id() == ctx->leader_cpu) {
+		ret = ctx->fn_leader(ctx->arg);
+		ctx->leader_done = 1;
+	} else {
+		while (!ctx->leader_done)
+			cpu_relax();
+		ret = ctx->fn_follower(ctx->arg);
+	}
+
+	return ret;
+}
+
+/* stop_machine_leader_follower
+ *
+ * Calls stop_machine with a leader CPU and follower CPUs
+ * executing different codes.
+ * At first, the leader CPU is selected randomly and executes its code.
+ * After that, follower CPUs execute their codes.
+ */
+static int stop_machine_leader_follower(
+		int (*fn_leader)(void *),
+		int (*fn_follower)(void *),
+		void *arg)
+{
+	int cpu;
+	struct sm_context ctx;
+
+	preempt_disable();
+	cpu = smp_processor_id();
+	preempt_enable();
+
+	memset(&ctx, 0, sizeof(ctx));
+	ctx.leader_cpu = cpu;
+	ctx.leader_done = 0;
+	ctx.fn_leader = fn_leader;
+	ctx.fn_follower = fn_follower;
+	ctx.arg = arg;
+
+	return stop_machine(call_leader_follower, &ctx, cpu_online_mask);
+}
+
+/* wrprotect_unselect_pages
+ *
+ * This function clears bits corresponding to pages that cover a range
+ * from start to start+len.
+ */
+void wrprotect_unselect_pages(
+		unsigned long *bmp,
+		unsigned long start,
+		unsigned long len)
+{
+	unsigned long addr;
+
+	BUG_ON(start & ~PAGE_MASK);
+	BUG_ON(len & ~PAGE_MASK);
+
+	for (addr = start; addr < start + len; addr += PAGE_SIZE) {
+		unsigned long pfn = __pa(addr) >> PAGE_SHIFT;
+		clear_bit(pfn, bmp);
+	}
+}
+
+/* handle_addr_range
+ *
+ * This function executes wrprotect.handle_page in turns against pages that
+ * cover a range from start to start+len.
+ * At the same time, it clears bits corresponding to the pages.
+ */
+static void handle_addr_range(unsigned long start, unsigned long len)
+{
+	unsigned long end = start + len;
+
+	while (start < end) {
+		unsigned long pfn = __pa(start) >> PAGE_SHIFT;
+		if (test_bit(pfn, wrprotect.pgbmp)) {
+			wrprotect.handle_page(pfn, 0);
+			clear_bit(pfn, wrprotect.pgbmp);
+		}
+		start += PAGE_SIZE;
+	}
+}
+
+/* handle_task
+ *
+ * This function executes handle_addr_range against task_struct & thread_info.
+ */
+static void handle_task(struct task_struct *t)
+{
+	BUG_ON(!t);
+	BUG_ON(!t->stack);
+	BUG_ON((unsigned long)t->stack & ~PAGE_MASK);
+	handle_addr_range((unsigned long)t, sizeof(*t));
+	handle_addr_range((unsigned long)t->stack, THREAD_SIZE);
+}
+
+/* handle_tasks
+ *
+ * This function executes handle_task against all tasks (including idle_task).
+ */
+static void handle_tasks(void)
+{
+	struct task_struct *p, *t;
+	unsigned int cpu;
+
+	do_each_thread(p, t) {
+		handle_task(t);
+	} while_each_thread(p, t);
+
+	for_each_online_cpu(cpu)
+		handle_task(idle_task(cpu));
+}
+
+static void handle_pmd(pmd_t *pmd)
+{
+	unsigned long i;
+
+	handle_addr_range((unsigned long)pmd, PAGE_SIZE);
+	for (i = 0; i < PTRS_PER_PMD; i++) {
+		if (pmd_present(pmd[i]) && !pmd_large(pmd[i]))
+			handle_addr_range(pmd_page_vaddr(pmd[i]), PAGE_SIZE);
+	}
+}
+
+static void handle_pud(pud_t *pud)
+{
+	unsigned long i;
+
+	handle_addr_range((unsigned long)pud, PAGE_SIZE);
+	for (i = 0; i < PTRS_PER_PUD; i++) {
+		if (pud_present(pud[i]) && !pud_large(pud[i]))
+			handle_pmd((pmd_t *)pud_page_vaddr(pud[i]));
+	}
+}
+
+/* handle_page_table
+ *
+ * This function executes wrprotect.handle_page against all pages that make up
+ * page table structure and clears all bits corresponding to the pages.
+ */
+static void handle_page_table(void)
+{
+	pgd_t *pgd;
+	unsigned long i;
+
+	pgd = __va(read_cr3() & PAGE_MASK);
+	handle_addr_range((unsigned long)pgd, PAGE_SIZE);
+	for (i = pgd_index(PAGE_OFFSET); i < PTRS_PER_PGD; i++) {
+		if (pgd_present(pgd[i]))
+			handle_pud((pud_t *)pgd_page_vaddr(pgd[i]));
+	}
+}
+
+/* handle_sensitive_pages
+ *
+ * This function executes wrprotect.handle_page against the following pages and
+ * clears bits corresponding to them.
+ * - All pages that include task_struct & thread_info
+ * - All pages that make up page table structure
+ * - All pages that include per_cpu variables
+ * - All pages that cover kernel's data section
+ */
+static void handle_sensitive_pages(void)
+{
+	handle_tasks();
+	handle_page_table();
+	handle_addr_range((unsigned long)__per_cpu_offset[0], PMD_PAGE_SIZE);
+	handle_addr_range((unsigned long)_sdata, _end - _sdata);
+}
+
+/* protect_page
+ *
+ * Changes a specified page's _PAGE_RW flag and _PAGE_UNUSED1 flag.
+ * If the argument protect is non-zero:
+ *  - _PAGE_RW flag is cleared
+ *  - _PAGE_UNUSED1 flag is set
+ * If the argument protect is zero:
+ *  - _PAGE_RW flag is set
+ *  - _PAGE_UNUSED1 flag is cleared
+ *
+ * The change is executed only when all the following are true.
+ *  - The page is mapped by the straight mapping area.
+ *  - The page is mapped as 4K page.
+ *  - The page is originally writable.
+ *
+ * Returns 1 if the change is actually executed, otherwise returns 0.
+ */
+static int protect_page(unsigned long pfn, int protect)
+{
+	unsigned long addr = (unsigned long)pfn_to_kaddr(pfn);
+	pte_t *ptep, pte;
+	unsigned int level;
+
+	ptep = lookup_address(addr, &level);
+	if (WARN(!ptep, "livedump: Page=%016lx isn't mapped.\n", addr) ||
+	    WARN(!pte_present(*ptep),
+		    "livedump: Page=%016lx isn't mapped.\n", addr) ||
+	    WARN(PG_LEVEL_NONE == level,
+		    "livedump: Page=%016lx isn't mapped.\n", addr) ||
+	    WARN(PG_LEVEL_2M == level,
+		    "livedump: Page=%016lx is consisted of 2M page.\n", addr) ||
+	    WARN(PG_LEVEL_1G == level,
+		    "livedump: Page=%016lx is consisted of 1G page.\n", addr)) {
+		return 0;
+	}
+
+	pte = *ptep;
+	if (protect) {
+		if (pte_write(pte)) {
+			pte = pte_wrprotect(pte);
+			pte = pte_set_flags(pte, _PAGE_UNUSED1);
+		}
+	} else {
+		pte = pte_mkwrite(pte);
+		pte = pte_clear_flags(pte, _PAGE_UNUSED1);
+	}
+	*ptep = pte;
+
+	return 1;
+}
+
+/*
+ * Page fault error code bits:
+ *
+ *   bit 0 ==	 0: no page found	1: protection fault
+ *   bit 1 ==	 0: read access		1: write access
+ *   bit 2 ==	 0: kernel-mode access	1: user-mode access
+ *   bit 3 ==				1: use of reserved bit detected
+ *   bit 4 ==				1: fault was an instruction fetch
+ */
+enum x86_pf_error_code {
+	PF_PROT		=		1 << 0,
+	PF_WRITE	=		1 << 1,
+	PF_USER		=		1 << 2,
+	PF_RSVD		=		1 << 3,
+	PF_INSTR	=		1 << 4,
+};
+
+int wrprotect_page_fault_handler(unsigned long error_code)
+{
+	pte_t *ptep, pte;
+	unsigned int level;
+	unsigned long pfn;
+
+	/*
+	 * Handle only kernel-mode write access
+	 *
+	 * error_code must be:
+	 *  (1) PF_PROT
+	 *  (2) PF_WRITE
+	 *  (3) not PF_USER
+	 *  (4) not PF_SRVD
+	 *  (5) not PF_INSTR
+	 */
+	if (!(PF_PROT  & error_code) ||
+	    !(PF_WRITE & error_code) ||
+	     (PF_USER  & error_code) ||
+	     (PF_RSVD  & error_code) ||
+	     (PF_INSTR & error_code))
+		goto not_processed;
+
+	ptep = lookup_address(read_cr2(), &level);
+	if (!ptep)
+		goto not_processed;
+	pte = *ptep;
+	if (!pte_present(pte) || PG_LEVEL_4K != level)
+		goto not_processed;
+	if (!(pte_flags(pte) & _PAGE_UNUSED1))
+		goto not_processed;
+
+	pfn = pte_pfn(pte);
+	if (test_and_clear_bit(pfn, wrprotect.pgbmp)) {
+		wrprotect.handle_page(pfn, 0);
+		protect_page(pfn, 0);
+	}
+
+	return true;
+
+not_processed:
+	return false;
+}
+
+/* sm_leader
+ *
+ * Is executed by a leader CPU during stop-machine.
+ *
+ * This function does the following:
+ * (1)Handle pages that must not be write-protected.
+ * (2)Turn on the callback in the page fault handler.
+ * (3)Write-protect pages which are specified by the bitmap.
+ * (4)Flush TLB cache of the leader CPU.
+ */
+static int sm_leader(void *arg)
+{
+	unsigned long pfn;
+
+	handle_sensitive_pages();
+
+	wrprotect_is_on = true;
+
+	for_each_set_bit(pfn, wrprotect.pgbmp, num_physpages)
+		if (!protect_page(pfn, 1))
+			clear_bit(pfn, wrprotect.pgbmp);
+
+	__flush_tlb_all();
+
+	return 0;
+}
+
+/* sm_follower
+ *
+ * Is executed by follower CPUs during stop-machine.
+ * Flushes TLB cache of each CPU.
+ */
+static int sm_follower(void *arg)
+{
+	__flush_tlb_all();
+	return 0;
+}
+
+/* wrprotect_start
+ *
+ * This function sets up write protection on the kernel space during the
+ * stop-machine state.
+ */
+int wrprotect_start(void)
+{
+	int ret;
+
+	if (WARN(STATE_INITED != wrprotect.state,
+				"livedump: wrprotect isn't initialized yet.\n"))
+		return 0;
+
+	ret = stop_machine_leader_follower(sm_leader, sm_follower, NULL);
+	if (WARN(ret, "livedump: Failed to protect pages w/errno=%d.\n", ret))
+		return ret;
+
+	wrprotect.state = STATE_STARTED;
+	return 0;
+}
+
+/* wrprotect_sweep
+ *
+ * On every page specified by the bitmap, this function executes the following.
+ *  - Handle the page by calling wrprotect.handle_page.
+ *  - Unprotect the page by calling protect_page.
+ *
+ * The above work may be executed on the same page at the same time
+ * by the notifer-call-chain.
+ * test_and_clear_bit is used for exclusion control.
+ */
+int wrprotect_sweep(void)
+{
+	unsigned long pfn;
+
+	if (WARN(STATE_STARTED != wrprotect.state,
+				"livedump: Pages aren't protected yet.\n"))
+		return 0;
+	for_each_set_bit(pfn, wrprotect.pgbmp, num_physpages) {
+		if (!test_and_clear_bit(pfn, wrprotect.pgbmp))
+			continue;
+		wrprotect.handle_page(pfn, 1);
+		protect_page(pfn, 0);
+		if (!(pfn & 0xffUL))
+			cond_resched();
+	}
+	wrprotect.state = STATE_SWEPT;
+	return 0;
+}
+
+/* wrprotect_create_page_bitmap
+ *
+ * This function creates bitmap of which each bit corresponds to physical page.
+ * Here, all ram pages are selected as being write-protected.
+ */
+unsigned long *wrprotect_create_page_bitmap(void)
+{
+	unsigned long *bmp;
+	unsigned long pfn;
+
+	/* allocate on vmap area */
+	bmp = vzalloc(PGBMP_LEN);
+	if (!bmp)
+		return NULL;
+
+	/* select all ram pages */
+	for (pfn = 0; pfn < num_physpages; pfn++) {
+		if (e820_any_mapped(pfn << PAGE_SHIFT,
+				    (pfn + 1) << PAGE_SHIFT,
+				    E820_RAM))
+			set_bit(pfn, bmp);
+		if (!(pfn & 0xffUL))
+			cond_resched();
+	}
+
+	return bmp;
+}
+
+/* wrprotect_destroy_page_bitmap
+ *
+ * This function frees the page bitmap created by wrprotect_create_page_bitmap.
+ */
+void wrprotect_destroy_page_bitmap(unsigned long *bmp)
+{
+	vfree(bmp);
+}
+
+static void default_handle_page(unsigned long pfn, int for_sweep)
+{
+}
+
+/* wrprotect_init
+ *
+ * pgbmp:
+ *   This is a bitmap of which each bit corresponds to a physical page.
+ *   Marked pages are write protected (or handled during stop-machine).
+ *
+ * fn_handle_page:
+ *   This callback is invoked to handle faulting pages.
+ *   This function takes 2 arguments.
+ *   First one is PFN that tells which page caused page fault.
+ *   Second one is a flag that tells whether it's called in the sweep phase.
+ */
+int wrprotect_init(unsigned long *pgbmp, fn_handle_page_t fn_handle_page)
+{
+	int ret;
+
+	if (WARN(STATE_UNINIT != wrprotect.state,
+			"livedump: wrprotect is already initialized.\n"))
+		return 0;
+
+	/* split all large pages in straight mapping area */
+	ret = split_large_pages();
+	if (ret)
+		goto err;
+
+	/* unselect internal stuffs of wrprotect */
+	wrprotect_unselect_pages(
+			pgbmp, (unsigned long)&wrprotect, sizeof(wrprotect));
+
+	wrprotect.pgbmp = pgbmp;
+	wrprotect.handle_page = fn_handle_page ?: default_handle_page;
+
+	wrprotect.state = STATE_INITED;
+	return 0;
+
+err:
+	return ret;
+}
+
+void wrprotect_uninit(void)
+{
+	unsigned long pfn;
+
+	if (STATE_UNINIT == wrprotect.state)
+		return;
+
+	if (STATE_STARTED == wrprotect.state) {
+		for_each_set_bit(pfn, wrprotect.pgbmp, num_physpages) {
+			if (!test_and_clear_bit(pfn, wrprotect.pgbmp))
+				continue;
+			protect_page(pfn, 0);
+			cond_resched();
+		}
+
+		flush_tlb_all();
+	}
+
+	if (STATE_STARTED <= wrprotect.state)
+		wrprotect_is_on = false;
+
+	wrprotect.pgbmp = NULL;
+	wrprotect.handle_page = NULL;
+
+	wrprotect.state = STATE_UNINIT;
+}
diff --git a/kernel/livedump.c b/kernel/livedump.c
index 409f7ed..3cf0f53 100644
--- a/kernel/livedump.c
+++ b/kernel/livedump.c
@@ -18,6 +18,8 @@
  * MA  02110-1301, USA.
  */
 
+#include <asm/wrprotect.h>
+
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
@@ -26,11 +28,54 @@
 #define DEVICE_NAME	"livedump"
 
 #define LIVEDUMP_IOC(x)	_IO(0xff, x)
+#define LIVEDUMP_IOC_START LIVEDUMP_IOC(1)
+#define LIVEDUMP_IOC_SWEEP LIVEDUMP_IOC(2)
+#define LIVEDUMP_IOC_INIT LIVEDUMP_IOC(100)
+#define LIVEDUMP_IOC_UNINIT LIVEDUMP_IOC(101)
+
+unsigned long *pgbmp;
+
+static void do_uninit(void)
+{
+	wrprotect_uninit();
+	if (pgbmp) {
+		wrprotect_destroy_page_bitmap(pgbmp);
+		pgbmp = NULL;
+	}
+}
+
+static int do_init(void)
+{
+	int ret;
+
+	ret = -ENOMEM;
+	pgbmp = wrprotect_create_page_bitmap();
+	if (!pgbmp)
+		goto err;
+
+	ret = wrprotect_init(pgbmp, NULL);
+	if (WARN(ret, "livedump: Failed to initialize Protection manager.\n"))
+		goto err;
+
+	return 0;
+err:
+	do_uninit();
+	return ret;
+}
 
 static long livedump_ioctl(
 		struct file *file, unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
+	case LIVEDUMP_IOC_START:
+		return wrprotect_start();
+	case LIVEDUMP_IOC_SWEEP:
+		return wrprotect_sweep();
+	case LIVEDUMP_IOC_INIT:
+		return do_init();
+	case LIVEDUMP_IOC_UNINIT:
+		do_uninit();
+		return 0;
 	default:
 		return -ENOIOCTLCMD;
 	}
@@ -48,6 +93,7 @@ static struct miscdevice livedump_misc = {
 static int livedump_exit(struct notifier_block *_, unsigned long __, void *___)
 {
 	misc_deregister(&livedump_misc);
+	do_uninit();
 	return NOTIFY_DONE;
 }
 static struct notifier_block livedump_nb = {
diff --git a/tools/livedump/livedump b/tools/livedump/livedump
new file mode 100755
index 0000000..2025fc4
--- /dev/null
+++ b/tools/livedump/livedump
@@ -0,0 +1,32 @@
+#!/usr/bin/python
+
+import sys
+import fcntl
+
+def ioctl_init(f):
+	fcntl.ioctl(f, 0xff64)
+
+def ioctl_uninit(f):
+	fcntl.ioctl(f, 0xff65)
+
+def ioctl_start(f):
+	fcntl.ioctl(f, 0xff01)
+
+def ioctl_sweep(f):
+	fcntl.ioctl(f, 0xff02)
+
+if __name__ == '__main__':
+	# open livedump device file
+	f = open('/dev/livedump')
+	# execute subcommand
+	subcmd = sys.argv[1]
+	if 'init' == subcmd:
+		ioctl_init(f)
+	elif 'uninit' == subcmd:
+		ioctl_uninit(f)
+	elif 'start' == subcmd:
+		ioctl_start(f)
+	elif 'sweep' == subcmd:
+		ioctl_sweep(f)
+	# close livedump device file
+	f.close

