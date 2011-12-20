Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab1LTH0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 02:26:14 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:54556 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab1LTH0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 02:26:08 -0500
X-AuditID: b753bd60-97991ba000007b1b-67-4ef0380a5043
X-AuditID: b753bd60-97991ba000007b1b-67-4ef0380a5043
Date: Tue, 20 Dec 2011 16:24:05 +0900
From: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@mit.edu>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kevin Hilman <khilman@ti.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Michal Marek <mmarek@suse.cz>, Rik van Riel <riel@redhat.com>,
        Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, frank.rowand@am.sony.com, jan.kiszka@web.de,
        yrl.pp-manager.tt@hitachi.com,
        YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 4/5] livedump: Add write protection management
Message-ID: <20111220072405.GE9220@t3500.sdl.hitachi.co.jp>
References: <20111220072028.9113.74876.stgit@t3500.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220072028.9113.74876.stgit@t3500.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes it possible to write-protect pages in kernel space and to
install a handler function that is called every time when page fault occurs
on the protected page. The write protection is executed in the stop-machine
state to protect all pages consistently.

Processing of write protection and handling is executed in the order as
follows:

(1) Write protection phase
  - Stops machine.
  - Handles sensitive pages.
    (described below about sensitive pages)
  - Sets up write protection.
  - Resumes machine.
(2) Page fault exception handling
  - Before unprotecting faulting page, calls the handler function.
(3) Sweep phase
  - Calls the handler function against the rest of pages.

This patch exports the following 4 ioctl operations.
- Ioctl to activate this feature of write protection
- Ioctl to deactivate this feature
- Ioctl to kick stop-machine and to set up write protection
- Ioctl to sweep all the rest of pages

States of processing is as follows. They can transit only in the order
shown below.
- WRPROTECT_UNINITIALIZED
- WRPROTECT_INIT
- WRPROTECT_STARTED (= write protection already set up)
- WRPROTECT_SWEPT

However, this order is protected by a normal integer variable, therefore,
to be exact, this code is not safe against concurrent operation.

The livedump module has to acquire consistent memory image of kernel space.
Therefore, write protection is set up while the update of memory state is
suspended. To do so, the livedump is using stop_machine currently.

Causing page fault during page fault handling results in kernel panic, and
so any pages that can be updated during page fault handling must not be
write-protected. For the same reason, any pages that can be updated during
NMI handling must not be write-protected. I call such pages "sensitive
page". The handler function is called against the sensitive pages during
the stop-machine state as if they caused page fault at this timing.

I list the sensitive pages in the following:

- Kernel/Exception/Interrupt stacks
- Page table structure
- All task_struct
- ".data" section of kernel
- per_cpu areas

This handler function is not called against the pages that are not updated
unless the function is called by someone else. To handle these pages, the
livedump module finally calls the handler function against each of the
pages. I call this phase "sweep", which is triggered by ioctl operation.

To specify which pages to be write-protected and how to handle the pages,
the following 3 types of hook functions need to be defined.

- void fn_select_pages(unsigned long *bmp)
    This function selects pages to be protected. Selection is returned in
    the form of bitmap of which bit corresponds to PFN (page frame number).
    This function is called outside the stop-machine state, and so the
    processing of this function doesn't make the stop-machine time longer.

- void fn_handle_page(unsigned long pfn)
    This function handles faulting pages. The argument pfn specifies which
    page caused page fault. How to handle the page can be defined
    arbitrarily.
    This function is called when page fault occurs on the pages protected
    by this module. It's also called during the stop-machine state to
    handle the above sensitive pages.

- void fn_handle_sensitive_pages(unsigned long *bmp)
    Someone who defines these hook functions may have additional sensitive
    pages, to say, pages that must not be write-protected. This function
    handles such pages during the stop-machine state. Bits in the bitmap
    corresponding to pages that are handled by this function must be
    cleared.

To be exact, if set_memory_rw is called between states of WRPROTECT_STARTED
and WRPROTECT_SWEPT, consistency of dumped memory image possibly breaks.
To solve this problem, I plan to add a hook into set_memory_rw in the next
version of the patch series.

Signed-off-by: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---

 arch/x86/include/asm/wrprotect.h |   23 ++
 arch/x86/mm/wrprotect.c          |  582 ++++++++++++++++++++++++++++++++++++++
 kernel/livedump.c                |   33 ++
 tools/livedump/livedump          |    4 
 4 files changed, 641 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/wrprotect.h b/arch/x86/include/asm/wrprotect.h
index 40489e0..f63b196 100644
--- a/arch/x86/include/asm/wrprotect.h
+++ b/arch/x86/include/asm/wrprotect.h
@@ -23,4 +23,27 @@
 
 extern int wrprotect_split(void);
 
+typedef int (*fn_select_pages_t)(unsigned long *pfn_bmp);
+typedef void (*fn_handle_sensitive_pages_t)(unsigned long *pgbmp);
+typedef void (*fn_handle_page_t)(unsigned long pfn);
+
+extern int wrprotect_init(
+		fn_select_pages_t fn_select_pages,
+		fn_handle_sensitive_pages_t fn_handle_sensitive_pages,
+		fn_handle_page_t fn_handle_page);
+extern void wrprotect_uninit(void);
+
+extern int wrprotect_start(void);
+extern int wrprotect_sweep(void);
+
+extern void wrprotect_unselect_pages_but_edges(
+		unsigned long *pgbmp,
+		unsigned long start,
+		unsigned long len);
+extern void wrprotect_handle_only_edges(
+		unsigned long *pgbmp,
+		fn_handle_page_t fn_handle_page,
+		unsigned long start,
+		unsigned long len);
+
 #endif /* _WRPROTECT_H */
diff --git a/arch/x86/mm/wrprotect.c b/arch/x86/mm/wrprotect.c
index 2a69735..bd5638c 100644
--- a/arch/x86/mm/wrprotect.c
+++ b/arch/x86/mm/wrprotect.c
@@ -19,7 +19,33 @@
  */
 
 #include <asm/wrprotect.h>
-#include <linux/highmem.h>
+#include <linux/mm.h>		/* num_physpages, __get_free_page, etc. */
+#include <linux/bitmap.h>	/* bit operations */
+#include <linux/slab.h>		/* kmalloc, kfree */
+#include <linux/hugetlb.h>	/* __flush_tlb_all */
+#include <linux/stop_machine.h>	/* stop_machine */
+#include <asm/traps.h>		/* page_fault_notifier_list */
+#include <asm/sections.h>	/* __per_cpu_* */
+
+/* wrprotect's stuffs */
+static struct wrprotect {
+	int state;
+#define STATE_UNINIT 0
+#define STATE_INITIALIZED 1
+#define STATE_STARTED 2
+#define STATE_SWEPT 3
+} wrprotect;
+
+/* Bitmap specifying pages being write-protected */
+static unsigned long *pgbmp;
+#define PGBMP_LEN (sizeof(long) * BITS_TO_LONGS(num_physpages))
+
+/* wrprotect's hook functions, which define which and how to handle pages */
+static struct {
+	fn_select_pages_t select_pages;
+	fn_handle_sensitive_pages_t handle_sensitive_pages;
+	fn_handle_page_t handle_page;
+} ops;
 
 int wrprotect_split(void)
 {
@@ -31,3 +57,557 @@ int wrprotect_split(void)
 	}
 	return 0;
 }
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
+/* wrprotect_unselect_pages_but_edges
+ *
+ * Clear bits corresponding to pages that cover a range
+ * from start to start+len-1.
+ * However, if edges (start and/or start+len) are not aligned to PAGE_SIZE,
+ * the first and the last bits are not cleared.
+ */
+void wrprotect_unselect_pages_but_edges(
+		unsigned long *pgbmp,
+		unsigned long start,
+		unsigned long len)
+{
+	unsigned long end = (start + len) & PAGE_MASK;
+
+	start = (start + PAGE_SIZE - 1) & PAGE_MASK;
+	while (start < end) {
+		unsigned long pfn = __pa(start) >> PAGE_SHIFT;
+		clear_bit(pfn, pgbmp);
+		start += PAGE_SIZE;
+	}
+}
+
+/* wrprotect_handle_only_edges
+ *
+ * Call fn_handle_page against the first and the last pages
+ * if the corresponding bits are set.
+ * When fn_handle_page is called, the corresponding bit is cleared.
+ */
+void wrprotect_handle_only_edges(
+		unsigned long *pgbmp,
+		fn_handle_page_t fn_handle_page,
+		unsigned long start,
+		unsigned long len)
+{
+	unsigned long pfn_begin = __pa(start) >> PAGE_SHIFT;
+	unsigned long pfn_last = __pa(start + len - 1) >> PAGE_SHIFT;
+
+	if (test_bit(pfn_begin, pgbmp)) {
+		fn_handle_page(pfn_begin);
+		clear_bit(pfn_begin, pgbmp);
+	}
+	if (test_bit(pfn_last, pgbmp)) {
+		fn_handle_page(pfn_last);
+		clear_bit(pfn_last, pgbmp);
+	}
+}
+
+/* handle_addr_range
+ *
+ * Call fn_handle_page in turns against pages that cover a range
+ * from start to start+len-1.
+ * At the same time, bits corresponding to the pages are cleared.
+ */
+static void handle_addr_range(
+		unsigned long *pgbmp,
+		fn_handle_page_t fn_handle_page,
+		unsigned long start,
+		unsigned long len)
+{
+	unsigned long end = start + len;
+
+	while (start < end) {
+		unsigned long pfn = __pa(start) >> PAGE_SHIFT;
+		if (test_bit(pfn, pgbmp)) {
+			fn_handle_page(pfn);
+			clear_bit(pfn, pgbmp);
+		}
+		start += PAGE_SIZE;
+	}
+}
+
+/* handle_task
+ *
+ * Call handle_addr_range against a given task_struct & thread_info
+ */
+static void handle_task(
+		unsigned long *pgbmp,
+		fn_handle_page_t fn_handle_page,
+		struct task_struct *t)
+{
+	BUG_ON(!t);
+	BUG_ON(!t->stack);
+	BUG_ON((unsigned long)t->stack & ~PAGE_MASK);
+	handle_addr_range(pgbmp, fn_handle_page,
+			(unsigned long)t, sizeof(*t));
+	handle_addr_range(pgbmp, fn_handle_page,
+			(unsigned long)t->stack, THREAD_SIZE);
+}
+
+/* handle_tasks
+ *
+ * Call handle_task against all tasks (including idle_task's).
+ */
+static void handle_tasks(
+		unsigned long *pgbmp,
+		fn_handle_page_t fn_handle_page)
+{
+	struct task_struct *p, *t;
+	unsigned int cpu;
+
+	do_each_thread(p, t) {
+		handle_task(pgbmp, fn_handle_page, t);
+	} while_each_thread(p, t);
+
+	for_each_online_cpu(cpu)
+		handle_task(pgbmp, fn_handle_page, idle_task(cpu));
+}
+
+static void handle_pmd(
+		unsigned long *pgbmp,
+		fn_handle_page_t fn_handle_page,
+		pmd_t *pmd)
+{
+	unsigned long i;
+
+	handle_addr_range(pgbmp, fn_handle_page,
+			(unsigned long)pmd, PAGE_SIZE);
+	for (i = 0; i < PTRS_PER_PMD; i++) {
+		if (pmd_present(pmd[i]) && !pmd_large(pmd[i]))
+			handle_addr_range(pgbmp, fn_handle_page,
+					pmd_page_vaddr(pmd[i]), PAGE_SIZE);
+	}
+}
+
+static void handle_pud(
+		unsigned long *pgbmp,
+		fn_handle_page_t fn_handle_page,
+		pud_t *pud)
+{
+	unsigned long i;
+
+	handle_addr_range(pgbmp, fn_handle_page,
+			(unsigned long)pud, PAGE_SIZE);
+	for (i = 0; i < PTRS_PER_PUD; i++) {
+		if (pud_present(pud[i]) && !pud_large(pud[i]))
+			handle_pmd(pgbmp, fn_handle_page,
+					(pmd_t *)pud_page_vaddr(pud[i]));
+	}
+}
+
+/* handle_page_table
+ *
+ * Call fn_handle_page against all pages of page table structure
+ * and clear all bits corresponding to the pages.
+ */
+static void handle_page_table(
+		unsigned long *pgbmp,
+		fn_handle_page_t fn_handle_page)
+{
+	pgd_t *pgd;
+	unsigned long i;
+
+	pgd = __va(read_cr3() & PAGE_MASK);
+	handle_addr_range(pgbmp, fn_handle_page,
+			(unsigned long)pgd, PAGE_SIZE);
+	for (i = pgd_index(PAGE_OFFSET); i < PTRS_PER_PGD; i++) {
+		if (pgd_present(pgd[i]))
+			handle_pud(pgbmp, fn_handle_page,
+					(pud_t *)pgd_page_vaddr(pgd[i]));
+	}
+}
+
+/* handle_sensitive_pages
+ *
+ * Call fn_handle_page against the following pages and
+ * clear bits corresponding them.
+ */
+static void handle_sensitive_pages(
+		unsigned long *pgbmp,
+		fn_handle_page_t fn_handle_page)
+{
+	handle_tasks(pgbmp, fn_handle_page);
+	handle_page_table(pgbmp, fn_handle_page);
+	handle_addr_range(pgbmp, fn_handle_page,
+			(unsigned long)__per_cpu_offset[0], PMD_PAGE_SIZE);
+	handle_addr_range(pgbmp, fn_handle_page,
+			(unsigned long)_sdata, _end - _sdata);
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
+static int wrprotect_page_fault_notifier(
+		struct notifier_block *n, unsigned long val, void *v)
+{
+	unsigned long error_code = val;
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
+	if (test_and_clear_bit(pfn, pgbmp)) {
+		ops.handle_page(pfn);
+		protect_page(pfn, 0);
+	}
+
+	return NOTIFY_OK;
+
+not_processed:
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block wrprotect_page_fault_notifier_block = {
+	.notifier_call = wrprotect_page_fault_notifier,
+	.priority = 0,
+};
+
+/* sm_leader
+ *
+ * Is executed by a leader CPU during stop-machine.
+ *
+ * Does the following:
+ * (1)Handle sensitive pages, which must not be write-protected.
+ * (2)Register notifier-call-chain into the kernel's page fault handler.
+ * (3)Write-protect pages which are specified by the bitmap.
+ * (4)Flush TLB cache of the leader CPU.
+ */
+static int sm_leader(void *arg)
+{
+	int ret;
+	unsigned long pfn;
+
+	handle_sensitive_pages(pgbmp, ops.handle_page);
+	wrprotect_handle_only_edges(pgbmp, ops.handle_page,
+			(unsigned long)pgbmp, PGBMP_LEN);
+	wrprotect_handle_only_edges(pgbmp, ops.handle_page,
+			(unsigned long)&wrprotect, sizeof(wrprotect));
+	ops.handle_sensitive_pages(pgbmp);
+
+	ret = atomic_notifier_chain_register(
+			&page_fault_notifier_list,
+			&wrprotect_page_fault_notifier_block);
+	if (WARN(ret, "livedump: Failed to register notifier.\n"))
+		return ret;
+
+	for_each_set_bit(pfn, pgbmp, num_physpages)
+		if (!protect_page(pfn, 1))
+			clear_bit(pfn, pgbmp);
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
+ * Set up write protection on the kernel space in the stop-machine state.
+ */
+int wrprotect_start(void)
+{
+	int ret;
+
+	if (WARN(STATE_INITIALIZED != wrprotect.state,
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
+ * On every page specified by the bitmap, the following is executed.
+ *  - Handle the page by the way defined as ops.handle_page.
+ *  - Change the page's flags by calling protect_page.
+ *
+ * The above work can be executed on the same page at the same time
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
+	for_each_set_bit(pfn, pgbmp, num_physpages) {
+		if (!test_and_clear_bit(pfn, pgbmp))
+			continue;
+		ops.handle_page(pfn);
+		protect_page(pfn, 0);
+		if (!(pfn & 0xffUL))
+			cond_resched();
+	}
+	wrprotect.state = STATE_SWEPT;
+	return 0;
+}
+
+static int default_select_pages(unsigned long *pgmap)
+{
+	unsigned long pfn;
+
+	for (pfn = 0; pfn < num_physpages; pfn++) {
+		if (e820_any_mapped(pfn << PAGE_SHIFT,
+				    (pfn + 1) << PAGE_SHIFT,
+				    E820_RAM))
+			bitmap_set(pgbmp, pfn, 1);
+		if (!(pfn & 0xffUL))
+			cond_resched();
+	}
+	return 0;
+}
+
+static void default_handle_sensitive_pages(unsigned long *pgbmp)
+{
+}
+
+static void default_handle_page(unsigned long pfn)
+{
+}
+
+int wrprotect_init(
+		fn_select_pages_t fn_select_pages,
+		fn_handle_sensitive_pages_t fn_handle_sensitive_pages,
+		fn_handle_page_t fn_handle_page)
+{
+	int ret;
+
+	if (WARN(STATE_UNINIT != wrprotect.state,
+			"livedump: wrprotect is already initialized.\n"))
+		return 0;
+
+	if (fn_select_pages && fn_handle_sensitive_pages && fn_handle_page) {
+		ops.select_pages = fn_select_pages;
+		ops.handle_sensitive_pages = fn_handle_sensitive_pages;
+		ops.handle_page = fn_handle_page;
+	} else {
+		ops.select_pages = default_select_pages;
+		ops.handle_sensitive_pages = default_handle_sensitive_pages;
+		ops.handle_page = default_handle_page;
+	}
+
+	ret = -ENOMEM;
+	pgbmp = kzalloc(PGBMP_LEN, GFP_KERNEL);
+	if (!pgbmp)
+		goto err;
+
+	ret = ops.select_pages(pgbmp);
+	if (ret)
+		goto err;
+
+	wrprotect_unselect_pages_but_edges(
+			pgbmp, (unsigned long)pgbmp, PGBMP_LEN);
+	wrprotect_unselect_pages_but_edges(
+			pgbmp, (unsigned long)&wrprotect, sizeof(wrprotect));
+
+	wrprotect.state = STATE_INITIALIZED;
+	return 0;
+
+err:
+	kfree(pgbmp);
+	pgbmp = NULL;
+
+	return ret;
+}
+
+void wrprotect_uninit(void)
+{
+	int ret;
+	unsigned long pfn;
+
+	if (STATE_UNINIT == wrprotect.state)
+		return;
+
+	if (STATE_STARTED == wrprotect.state) {
+		for_each_set_bit(pfn, pgbmp, num_physpages) {
+			if (!test_and_clear_bit(pfn, pgbmp))
+				continue;
+			protect_page(pfn, 0);
+			cond_resched();
+		}
+
+		flush_tlb_all();
+	}
+
+	if (STATE_STARTED <= wrprotect.state) {
+		ret = atomic_notifier_chain_unregister(
+				&page_fault_notifier_list,
+				&wrprotect_page_fault_notifier_block);
+		WARN(ret, "livedump: Failed to unregister notifier "
+				"w/errno=%d.\n", -ret);
+	}
+
+	ops.select_pages = NULL;
+	ops.handle_sensitive_pages = NULL;
+	ops.handle_page = NULL;
+
+	kfree(pgbmp);
+	pgbmp = NULL;
+
+	wrprotect.state = STATE_UNINIT;
+}
diff --git a/kernel/livedump.c b/kernel/livedump.c
index 899d572..99b49b9 100644
--- a/kernel/livedump.c
+++ b/kernel/livedump.c
@@ -28,6 +28,29 @@
 
 #define LIVEDUMP_IOC(x)	_IO(0xff, x)
 #define LIVEDUMP_IOC_SPLIT LIVEDUMP_IOC(1)
+#define LIVEDUMP_IOC_START LIVEDUMP_IOC(2)
+#define LIVEDUMP_IOC_SWEEP LIVEDUMP_IOC(3)
+#define LIVEDUMP_IOC_INIT LIVEDUMP_IOC(100)
+#define LIVEDUMP_IOC_UNINIT LIVEDUMP_IOC(101)
+
+static void do_uninit(void)
+{
+	wrprotect_uninit();
+}
+
+static int do_init(void)
+{
+	int ret;
+
+	ret = wrprotect_init(NULL, NULL, NULL);
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
@@ -35,6 +58,15 @@ static long livedump_ioctl(
 	switch (cmd) {
 	case LIVEDUMP_IOC_SPLIT:
 		return wrprotect_split();
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
@@ -80,6 +112,7 @@ module_init(livedump_module_init);
 static void livedump_module_exit(void)
 {
 	misc_deregister(&livedump_misc);
+	do_uninit();
 }
 module_exit(livedump_module_exit);
 
diff --git a/tools/livedump/livedump b/tools/livedump/livedump
index c5e34d6..838347d 100755
--- a/tools/livedump/livedump
+++ b/tools/livedump/livedump
@@ -5,6 +5,10 @@ import fcntl
 
 cmds = {
 	'split':0xff01,
+	'start':0xff02,
+	'sweep':0xff03,
+	'init':0xff64,
+	'uninit':0xff65
 	}
 cmd = cmds[sys.argv[1]]
 

