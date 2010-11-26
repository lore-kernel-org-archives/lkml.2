Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab0KZNVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 08:21:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47692 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421Ab0KZNVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 08:21:07 -0500
Date: Fri, 26 Nov 2010 14:20:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20101126132045.GA19479@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      perf record: Handle restrictive permissions in /proc/{kallsyms,modules}

Frederic Weisbecker (1):
      x86: Ignore trap bits on single step exceptions

Jason Wessel (1):
      perf,hw_breakpoint: Initialize hardware api earlier

Masami Hiramatsu (1):
      x86/kprobes: Prevent kprobes to probe on save_args()

Peter Zijlstra (1):
      perf: Fix owner-list vs exit

Rabin Vincent (1):
      perf symbols: Remove incorrect open-coded container_of()

Rakib Mullick (1):
      x86, hw_nmi: Move backtrace_mask declaration under ARCH_HAS_NMI_WATCHDOG

Sergio Aguirre (1):
      irq_work: Drop cmpxchg() result

Steven Rostedt (3):
      tracing: Fix module use of trace_bprintk()
      tracing: Force arch_local_irq_* notrace for paravirt
      tracing: Fix recursive user stack trace


 arch/x86/include/asm/paravirt.h |   10 +++---
 arch/x86/kernel/apic/hw_nmi.c   |    7 ++--
 arch/x86/kernel/entry_64.S      |    2 +
 arch/x86/kernel/hw_breakpoint.c |    4 ++
 include/linux/hw_breakpoint.h   |    4 ++
 kernel/hw_breakpoint.c          |    3 +-
 kernel/irq_work.c               |    4 ++-
 kernel/module.c                 |   12 +++++++
 kernel/perf_event.c             |   69 ++++++++++++++++++++++++++++++++-------
 kernel/trace/trace.c            |   19 +++++++++++
 tools/perf/builtin-record.c     |   17 +++++----
 tools/perf/util/symbol.c        |    4 ++-
 12 files changed, 123 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 18e3b8a..ef99758 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -824,27 +824,27 @@ static __always_inline void arch_spin_unlock(struct arch_spinlock *lock)
 #define __PV_IS_CALLEE_SAVE(func)			\
 	((struct paravirt_callee_save) { func })
 
-static inline unsigned long arch_local_save_flags(void)
+static inline notrace unsigned long arch_local_save_flags(void)
 {
 	return PVOP_CALLEE0(unsigned long, pv_irq_ops.save_fl);
 }
 
-static inline void arch_local_irq_restore(unsigned long f)
+static inline notrace void arch_local_irq_restore(unsigned long f)
 {
 	PVOP_VCALLEE1(pv_irq_ops.restore_fl, f);
 }
 
-static inline void arch_local_irq_disable(void)
+static inline notrace void arch_local_irq_disable(void)
 {
 	PVOP_VCALLEE0(pv_irq_ops.irq_disable);
 }
 
-static inline void arch_local_irq_enable(void)
+static inline notrace void arch_local_irq_enable(void)
 {
 	PVOP_VCALLEE0(pv_irq_ops.irq_enable);
 }
 
-static inline unsigned long arch_local_irq_save(void)
+static inline notrace unsigned long arch_local_irq_save(void)
 {
 	unsigned long f;
 
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index cefd694..62f6e1e 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -17,15 +17,16 @@
 #include <linux/nmi.h>
 #include <linux/module.h>
 
-/* For reliability, we're prepared to waste bits here. */
-static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
-
 u64 hw_nmi_get_sample_period(void)
 {
 	return (u64)(cpu_khz) * 1000 * 60;
 }
 
 #ifdef ARCH_HAS_NMI_WATCHDOG
+
+/* For reliability, we're prepared to waste bits here. */
+static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
+
 void arch_trigger_all_cpu_backtrace(void)
 {
 	int i;
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index fe2690d..e3ba417 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -295,6 +295,7 @@ ENDPROC(native_usergs_sysret64)
 	.endm
 
 /* save partial stack frame */
+	.pushsection .kprobes.text, "ax"
 ENTRY(save_args)
 	XCPT_FRAME
 	cld
@@ -334,6 +335,7 @@ ENTRY(save_args)
 	ret
 	CFI_ENDPROC
 END(save_args)
+	.popsection
 
 ENTRY(save_rest)
 	PARTIAL_FRAME 1 REST_SKIP+8
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index ff15c9d..42c5942 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -433,6 +433,10 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
 	dr6_p = (unsigned long *)ERR_PTR(args->err);
 	dr6 = *dr6_p;
 
+	/* If it's a single step, TRAP bits are random */
+	if (dr6 & DR_STEP)
+		return NOTIFY_DONE;
+
 	/* Do an early return if no trap bits are set in DR6 */
 	if ((dr6 & DR_TRAP_BITS) == 0)
 		return NOTIFY_DONE;
diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index a2d6ea4..d1e55fe 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -33,6 +33,8 @@ enum bp_type_idx {
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 
+extern int __init init_hw_breakpoint(void);
+
 static inline void hw_breakpoint_init(struct perf_event_attr *attr)
 {
 	memset(attr, 0, sizeof(*attr));
@@ -108,6 +110,8 @@ static inline struct arch_hw_breakpoint *counter_arch_bp(struct perf_event *bp)
 
 #else /* !CONFIG_HAVE_HW_BREAKPOINT */
 
+static inline int __init init_hw_breakpoint(void) { return 0; }
+
 static inline struct perf_event *
 register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 2c9120f..e532582 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -620,7 +620,7 @@ static struct pmu perf_breakpoint = {
 	.read		= hw_breakpoint_pmu_read,
 };
 
-static int __init init_hw_breakpoint(void)
+int __init init_hw_breakpoint(void)
 {
 	unsigned int **task_bp_pinned;
 	int cpu, err_cpu;
@@ -655,6 +655,5 @@ static int __init init_hw_breakpoint(void)
 
 	return -ENOMEM;
 }
-core_initcall(init_hw_breakpoint);
 
 
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index f16763f..90f8819 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -145,7 +145,9 @@ void irq_work_run(void)
 		 * Clear the BUSY bit and return to the free state if
 		 * no-one else claimed it meanwhile.
 		 */
-		cmpxchg(&entry->next, next_flags(NULL, IRQ_WORK_BUSY), NULL);
+		(void)cmpxchg(&entry->next,
+			      next_flags(NULL, IRQ_WORK_BUSY),
+			      NULL);
 	}
 }
 EXPORT_SYMBOL_GPL(irq_work_run);
diff --git a/kernel/module.c b/kernel/module.c
index 437a74a..d190664 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2326,6 +2326,18 @@ static void find_module_sections(struct module *mod, struct load_info *info)
 	kmemleak_scan_area(mod->trace_events, sizeof(*mod->trace_events) *
 			   mod->num_trace_events, GFP_KERNEL);
 #endif
+#ifdef CONFIG_TRACING
+	mod->trace_bprintk_fmt_start = section_objs(info, "__trace_printk_fmt",
+					 sizeof(*mod->trace_bprintk_fmt_start),
+					 &mod->num_trace_bprintk_fmt);
+	/*
+	 * This section contains pointers to allocated objects in the trace
+	 * code and not scanning it leads to false positives.
+	 */
+	kmemleak_scan_area(mod->trace_bprintk_fmt_start,
+			   sizeof(*mod->trace_bprintk_fmt_start) *
+			   mod->num_trace_bprintk_fmt, GFP_KERNEL);
+#endif
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 	/* sechdrs[0].sh_size is always zero */
 	mod->ftrace_callsites = section_objs(info, "__mcount_loc",
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index cb6c0d2..671f6c8 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -31,6 +31,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/perf_event.h>
 #include <linux/ftrace_event.h>
+#include <linux/hw_breakpoint.h>
 
 #include <asm/irq_regs.h>
 
@@ -2234,11 +2235,6 @@ int perf_event_release_kernel(struct perf_event *event)
 	raw_spin_unlock_irq(&ctx->lock);
 	mutex_unlock(&ctx->mutex);
 
-	mutex_lock(&event->owner->perf_event_mutex);
-	list_del_init(&event->owner_entry);
-	mutex_unlock(&event->owner->perf_event_mutex);
-	put_task_struct(event->owner);
-
 	free_event(event);
 
 	return 0;
@@ -2251,9 +2247,43 @@ EXPORT_SYMBOL_GPL(perf_event_release_kernel);
 static int perf_release(struct inode *inode, struct file *file)
 {
 	struct perf_event *event = file->private_data;
+	struct task_struct *owner;
 
 	file->private_data = NULL;
 
+	rcu_read_lock();
+	owner = ACCESS_ONCE(event->owner);
+	/*
+	 * Matches the smp_wmb() in perf_event_exit_task(). If we observe
+	 * !owner it means the list deletion is complete and we can indeed
+	 * free this event, otherwise we need to serialize on
+	 * owner->perf_event_mutex.
+	 */
+	smp_read_barrier_depends();
+	if (owner) {
+		/*
+		 * Since delayed_put_task_struct() also drops the last
+		 * task reference we can safely take a new reference
+		 * while holding the rcu_read_lock().
+		 */
+		get_task_struct(owner);
+	}
+	rcu_read_unlock();
+
+	if (owner) {
+		mutex_lock(&owner->perf_event_mutex);
+		/*
+		 * We have to re-check the event->owner field, if it is cleared
+		 * we raced with perf_event_exit_task(), acquiring the mutex
+		 * ensured they're done, and we can proceed with freeing the
+		 * event.
+		 */
+		if (event->owner)
+			list_del_init(&event->owner_entry);
+		mutex_unlock(&owner->perf_event_mutex);
+		put_task_struct(owner);
+	}
+
 	return perf_event_release_kernel(event);
 }
 
@@ -5677,7 +5707,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	mutex_unlock(&ctx->mutex);
 
 	event->owner = current;
-	get_task_struct(current);
+
 	mutex_lock(&current->perf_event_mutex);
 	list_add_tail(&event->owner_entry, &current->perf_event_list);
 	mutex_unlock(&current->perf_event_mutex);
@@ -5745,12 +5775,6 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	++ctx->generation;
 	mutex_unlock(&ctx->mutex);
 
-	event->owner = current;
-	get_task_struct(current);
-	mutex_lock(&current->perf_event_mutex);
-	list_add_tail(&event->owner_entry, &current->perf_event_list);
-	mutex_unlock(&current->perf_event_mutex);
-
 	return event;
 
 err_free:
@@ -5901,8 +5925,24 @@ again:
  */
 void perf_event_exit_task(struct task_struct *child)
 {
+	struct perf_event *event, *tmp;
 	int ctxn;
 
+	mutex_lock(&child->perf_event_mutex);
+	list_for_each_entry_safe(event, tmp, &child->perf_event_list,
+				 owner_entry) {
+		list_del_init(&event->owner_entry);
+
+		/*
+		 * Ensure the list deletion is visible before we clear
+		 * the owner, closes a race against perf_release() where
+		 * we need to serialize on the owner->perf_event_mutex.
+		 */
+		smp_wmb();
+		event->owner = NULL;
+	}
+	mutex_unlock(&child->perf_event_mutex);
+
 	for_each_task_context_nr(ctxn)
 		perf_event_exit_task_context(child, ctxn);
 }
@@ -6321,6 +6361,8 @@ perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 
 void __init perf_event_init(void)
 {
+	int ret;
+
 	perf_event_init_all_cpus();
 	init_srcu_struct(&pmus_srcu);
 	perf_pmu_register(&perf_swevent);
@@ -6328,4 +6370,7 @@ void __init perf_event_init(void)
 	perf_pmu_register(&perf_task_clock);
 	perf_tp_register();
 	perf_cpu_notifier(perf_cpu_notify);
+
+	ret = init_hw_breakpoint();
+	WARN(ret, "hw_breakpoint initialization failed with: %d", ret);
 }
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 82d9b81..ee6a733 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1284,6 +1284,8 @@ void trace_dump_stack(void)
 	__ftrace_trace_stack(global_trace.buffer, flags, 3, preempt_count());
 }
 
+static DEFINE_PER_CPU(int, user_stack_count);
+
 void
 ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
 {
@@ -1302,6 +1304,18 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
 	if (unlikely(in_nmi()))
 		return;
 
+	/*
+	 * prevent recursion, since the user stack tracing may
+	 * trigger other kernel events.
+	 */
+	preempt_disable();
+	if (__this_cpu_read(user_stack_count))
+		goto out;
+
+	__this_cpu_inc(user_stack_count);
+
+
+
 	event = trace_buffer_lock_reserve(buffer, TRACE_USER_STACK,
 					  sizeof(*entry), flags, pc);
 	if (!event)
@@ -1319,6 +1333,11 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
 	save_stack_trace_user(&trace);
 	if (!filter_check_discard(call, entry, buffer, event))
 		ring_buffer_unlock_commit(buffer, event);
+
+	__this_cpu_dec(user_stack_count);
+
+ out:
+	preempt_enable();
 }
 
 #ifdef UNUSED
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 93bd2ff..e2c2de2 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -697,17 +697,18 @@ static int __cmd_record(int argc, const char **argv)
 	if (err < 0)
 		err = event__synthesize_kernel_mmap(process_synthesized_event,
 						    session, machine, "_stext");
-	if (err < 0) {
-		pr_err("Couldn't record kernel reference relocation symbol.\n");
-		return err;
-	}
+	if (err < 0)
+		pr_err("Couldn't record kernel reference relocation symbol\n"
+		       "Symbol resolution may be skewed if relocation was used (e.g. kexec).\n"
+		       "Check /proc/kallsyms permission or run as root.\n");
 
 	err = event__synthesize_modules(process_synthesized_event,
 					session, machine);
-	if (err < 0) {
-		pr_err("Couldn't record kernel reference relocation symbol.\n");
-		return err;
-	}
+	if (err < 0)
+		pr_err("Couldn't record kernel module information.\n"
+		       "Symbol resolution may be skewed if relocation was used (e.g. kexec).\n"
+		       "Check /proc/modules permission or run as root.\n");
+
 	if (perf_guest)
 		perf_session__process_machines(session, event__synthesize_guest_os);
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b39f499..0500895 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -295,7 +295,9 @@ static void symbols__insert_by_name(struct rb_root *self, struct symbol *sym)
 {
 	struct rb_node **p = &self->rb_node;
 	struct rb_node *parent = NULL;
-	struct symbol_name_rb_node *symn = ((void *)sym) - sizeof(*parent), *s;
+	struct symbol_name_rb_node *symn, *s;
+
+	symn = container_of(sym, struct symbol_name_rb_node, sym);
 
 	while (*p != NULL) {
 		parent = *p;
