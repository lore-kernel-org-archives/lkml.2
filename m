Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0DDKPy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 06:15:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49927 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174Ab0DDKPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 06:15:46 -0400
Date: Sun, 4 Apr 2010 12:15:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20100404101531.GA8670@elte.hu>
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
Borislav Petkov (1):
      perf, probe-finder: Build fix on Debian

Frederic Weisbecker (4):
      perf: Correctly align perf event tracing buffer
      perf: Use hot regs with software sched switch/migrate events
      perf: Always build the stub perf_arch_fetch_caller_regs version
      perf: Always build the powerpc perf_arch_fetch_caller_regs version

Jason Wessel (1):
      x86,kgdb: Always initialize the hw breakpoint attribute

Mike Galbraith (1):
      perf: Fix 'perf sched record' deadlock

Peter Zijlstra (2):
      x86: Move notify_cpu_starting() callback to a later stage
      perf, x86: Fix AMD hotplug & constraint initialization

Tom Zanussi (1):
      perf/scripts: Tuple was set from long in both branches in python_process_event()

Torok Edwin (1):
      perf, x86: Fix callgraphs of 32-bit processes on 64-bit kernels


 arch/powerpc/kernel/misc.S                         |    2 -
 arch/x86/kernel/cpu/perf_event.c                   |   54 +++++++++++---
 arch/x86/kernel/cpu/perf_event_amd.c               |   80 ++++++++++++--------
 arch/x86/kernel/dumpstack.h                        |    5 +
 arch/x86/kernel/kgdb.c                             |    2 +-
 arch/x86/kernel/smpboot.c                          |    4 +-
 include/linux/perf_event.h                         |   21 ++++--
 kernel/perf_event.c                                |   22 ++++--
 kernel/trace/trace_event_perf.c                    |   11 ++-
 tools/perf/Makefile                                |   10 +-
 .../util/scripting-engines/trace-event-python.c    |   17 +++-
 11 files changed, 153 insertions(+), 75 deletions(-)

diff --git a/arch/powerpc/kernel/misc.S b/arch/powerpc/kernel/misc.S
index b485a87..22e507c 100644
--- a/arch/powerpc/kernel/misc.S
+++ b/arch/powerpc/kernel/misc.S
@@ -128,7 +128,6 @@ _GLOBAL(__restore_cpu_power7)
 	/* place holder */
 	blr
 
-#ifdef CONFIG_EVENT_TRACING
 /*
  * Get a minimal set of registers for our caller's nth caller.
  * r3 = regs pointer, r5 = n.
@@ -154,4 +153,3 @@ _GLOBAL(perf_arch_fetch_caller_regs)
 	PPC_STL	r4,_NIP-STACK_FRAME_OVERHEAD(r3)
 	PPC_STL	r7,_LINK-STACK_FRAME_OVERHEAD(r3)
 	blr
-#endif /* CONFIG_EVENT_TRACING */
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 60398a0..53ea4cf 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -28,6 +28,7 @@
 #include <asm/apic.h>
 #include <asm/stacktrace.h>
 #include <asm/nmi.h>
+#include <asm/compat.h>
 
 static u64 perf_event_mask __read_mostly;
 
@@ -158,7 +159,7 @@ struct x86_pmu {
 						 struct perf_event *event);
 	struct event_constraint *event_constraints;
 
-	void		(*cpu_prepare)(int cpu);
+	int		(*cpu_prepare)(int cpu);
 	void		(*cpu_starting)(int cpu);
 	void		(*cpu_dying)(int cpu);
 	void		(*cpu_dead)(int cpu);
@@ -1333,11 +1334,12 @@ static int __cpuinit
 x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (long)hcpu;
+	int ret = NOTIFY_OK;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
 		if (x86_pmu.cpu_prepare)
-			x86_pmu.cpu_prepare(cpu);
+			ret = x86_pmu.cpu_prepare(cpu);
 		break;
 
 	case CPU_STARTING:
@@ -1350,6 +1352,7 @@ x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 			x86_pmu.cpu_dying(cpu);
 		break;
 
+	case CPU_UP_CANCELED:
 	case CPU_DEAD:
 		if (x86_pmu.cpu_dead)
 			x86_pmu.cpu_dead(cpu);
@@ -1359,7 +1362,7 @@ x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 		break;
 	}
 
-	return NOTIFY_OK;
+	return ret;
 }
 
 static void __init pmu_check_apic(void)
@@ -1628,14 +1631,42 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 	return len;
 }
 
-static int copy_stack_frame(const void __user *fp, struct stack_frame *frame)
+#ifdef CONFIG_COMPAT
+static inline int
+perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 {
-	unsigned long bytes;
+	/* 32-bit process in 64-bit kernel. */
+	struct stack_frame_ia32 frame;
+	const void __user *fp;
 
-	bytes = copy_from_user_nmi(frame, fp, sizeof(*frame));
+	if (!test_thread_flag(TIF_IA32))
+		return 0;
+
+	fp = compat_ptr(regs->bp);
+	while (entry->nr < PERF_MAX_STACK_DEPTH) {
+		unsigned long bytes;
+		frame.next_frame     = 0;
+		frame.return_address = 0;
+
+		bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
+		if (bytes != sizeof(frame))
+			break;
+
+		if (fp < compat_ptr(regs->sp))
+			break;
 
-	return bytes == sizeof(*frame);
+		callchain_store(entry, frame.return_address);
+		fp = compat_ptr(frame.next_frame);
+	}
+	return 1;
+}
+#else
+static inline int
+perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
+{
+    return 0;
 }
+#endif
 
 static void
 perf_callchain_user(struct pt_regs *regs, struct perf_callchain_entry *entry)
@@ -1651,11 +1682,16 @@ perf_callchain_user(struct pt_regs *regs, struct perf_callchain_entry *entry)
 	callchain_store(entry, PERF_CONTEXT_USER);
 	callchain_store(entry, regs->ip);
 
+	if (perf_callchain_user32(regs, entry))
+		return;
+
 	while (entry->nr < PERF_MAX_STACK_DEPTH) {
+		unsigned long bytes;
 		frame.next_frame	     = NULL;
 		frame.return_address = 0;
 
-		if (!copy_stack_frame(fp, &frame))
+		bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
+		if (bytes != sizeof(frame))
 			break;
 
 		if ((unsigned long)fp < regs->sp)
@@ -1702,7 +1738,6 @@ struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 	return entry;
 }
 
-#ifdef CONFIG_EVENT_TRACING
 void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int skip)
 {
 	regs->ip = ip;
@@ -1714,4 +1749,3 @@ void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int ski
 	regs->cs = __KERNEL_CS;
 	local_save_flags(regs->flags);
 }
-#endif
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index b87e0b6..db6f7d4 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -137,6 +137,13 @@ static inline int amd_is_nb_event(struct hw_perf_event *hwc)
 	return (hwc->config & 0xe0) == 0xe0;
 }
 
+static inline int amd_has_nb(struct cpu_hw_events *cpuc)
+{
+	struct amd_nb *nb = cpuc->amd_nb;
+
+	return nb && nb->nb_id != -1;
+}
+
 static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
 				      struct perf_event *event)
 {
@@ -147,7 +154,7 @@ static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
 	/*
 	 * only care about NB events
 	 */
-	if (!(nb && amd_is_nb_event(hwc)))
+	if (!(amd_has_nb(cpuc) && amd_is_nb_event(hwc)))
 		return;
 
 	/*
@@ -214,7 +221,7 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	/*
 	 * if not NB event or no NB, then no constraints
 	 */
-	if (!(nb && amd_is_nb_event(hwc)))
+	if (!(amd_has_nb(cpuc) && amd_is_nb_event(hwc)))
 		return &unconstrained;
 
 	/*
@@ -293,51 +300,55 @@ static struct amd_nb *amd_alloc_nb(int cpu, int nb_id)
 	return nb;
 }
 
-static void amd_pmu_cpu_online(int cpu)
+static int amd_pmu_cpu_prepare(int cpu)
+{
+	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
+
+	WARN_ON_ONCE(cpuc->amd_nb);
+
+	if (boot_cpu_data.x86_max_cores < 2)
+		return NOTIFY_OK;
+
+	cpuc->amd_nb = amd_alloc_nb(cpu, -1);
+	if (!cpuc->amd_nb)
+		return NOTIFY_BAD;
+
+	return NOTIFY_OK;
+}
+
+static void amd_pmu_cpu_starting(int cpu)
 {
-	struct cpu_hw_events *cpu1, *cpu2;
-	struct amd_nb *nb = NULL;
+	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
+	struct amd_nb *nb;
 	int i, nb_id;
 
 	if (boot_cpu_data.x86_max_cores < 2)
 		return;
 
-	/*
-	 * function may be called too early in the
-	 * boot process, in which case nb_id is bogus
-	 */
 	nb_id = amd_get_nb_id(cpu);
-	if (nb_id == BAD_APICID)
-		return;
-
-	cpu1 = &per_cpu(cpu_hw_events, cpu);
-	cpu1->amd_nb = NULL;
+	WARN_ON_ONCE(nb_id == BAD_APICID);
 
 	raw_spin_lock(&amd_nb_lock);
 
 	for_each_online_cpu(i) {
-		cpu2 = &per_cpu(cpu_hw_events, i);
-		nb = cpu2->amd_nb;
-		if (!nb)
+		nb = per_cpu(cpu_hw_events, i).amd_nb;
+		if (WARN_ON_ONCE(!nb))
 			continue;
-		if (nb->nb_id == nb_id)
-			goto found;
-	}
 
-	nb = amd_alloc_nb(cpu, nb_id);
-	if (!nb) {
-		pr_err("perf_events: failed NB allocation for CPU%d\n", cpu);
-		raw_spin_unlock(&amd_nb_lock);
-		return;
+		if (nb->nb_id == nb_id) {
+			kfree(cpuc->amd_nb);
+			cpuc->amd_nb = nb;
+			break;
+		}
 	}
-found:
-	nb->refcnt++;
-	cpu1->amd_nb = nb;
+
+	cpuc->amd_nb->nb_id = nb_id;
+	cpuc->amd_nb->refcnt++;
 
 	raw_spin_unlock(&amd_nb_lock);
 }
 
-static void amd_pmu_cpu_offline(int cpu)
+static void amd_pmu_cpu_dead(int cpu)
 {
 	struct cpu_hw_events *cpuhw;
 
@@ -349,8 +360,10 @@ static void amd_pmu_cpu_offline(int cpu)
 	raw_spin_lock(&amd_nb_lock);
 
 	if (cpuhw->amd_nb) {
-		if (--cpuhw->amd_nb->refcnt == 0)
-			kfree(cpuhw->amd_nb);
+		struct amd_nb *nb = cpuhw->amd_nb;
+
+		if (nb->nb_id == -1 || --nb->refcnt == 0)
+			kfree(nb);
 
 		cpuhw->amd_nb = NULL;
 	}
@@ -379,8 +392,9 @@ static __initconst struct x86_pmu amd_pmu = {
 	.get_event_constraints	= amd_get_event_constraints,
 	.put_event_constraints	= amd_put_event_constraints,
 
-	.cpu_prepare		= amd_pmu_cpu_online,
-	.cpu_dead		= amd_pmu_cpu_offline,
+	.cpu_prepare		= amd_pmu_cpu_prepare,
+	.cpu_starting		= amd_pmu_cpu_starting,
+	.cpu_dead		= amd_pmu_cpu_dead,
 };
 
 static __init int amd_pmu_init(void)
diff --git a/arch/x86/kernel/dumpstack.h b/arch/x86/kernel/dumpstack.h
index 29e5f7c..e39e771 100644
--- a/arch/x86/kernel/dumpstack.h
+++ b/arch/x86/kernel/dumpstack.h
@@ -30,6 +30,11 @@ struct stack_frame {
 	unsigned long return_address;
 };
 
+struct stack_frame_ia32 {
+    u32 next_frame;
+    u32 return_address;
+};
+
 static inline unsigned long rewind_frame_pointer(int n)
 {
 	struct stack_frame *frame;
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index bfba601..b2258ca 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -618,8 +618,8 @@ int kgdb_arch_init(void)
 	 * portion of kgdb because this operation requires mutexs to
 	 * complete.
 	 */
+	hw_breakpoint_init(&attr);
 	attr.bp_addr = (unsigned long)kgdb_arch_init;
-	attr.type = PERF_TYPE_BREAKPOINT;
 	attr.bp_len = HW_BREAKPOINT_LEN_1;
 	attr.bp_type = HW_BREAKPOINT_W;
 	attr.disabled = 1;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 06d98ae..6808b93 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -242,8 +242,6 @@ static void __cpuinit smp_callin(void)
 	end_local_APIC_setup();
 	map_cpu_to_logical_apicid();
 
-	notify_cpu_starting(cpuid);
-
 	/*
 	 * Need to setup vector mappings before we enable interrupts.
 	 */
@@ -264,6 +262,8 @@ static void __cpuinit smp_callin(void)
 	 */
 	smp_store_cpu_info(cpuid);
 
+	notify_cpu_starting(cpuid);
+
 	/*
 	 * Allow the master to continue.
 	 */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 9547703..c8e3754 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -842,13 +842,6 @@ extern atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
 extern void __perf_sw_event(u32, u64, int, struct pt_regs *, u64);
 
-static inline void
-perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
-{
-	if (atomic_read(&perf_swevent_enabled[event_id]))
-		__perf_sw_event(event_id, nr, nmi, regs, addr);
-}
-
 extern void
 perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int skip);
 
@@ -887,6 +880,20 @@ static inline void perf_fetch_caller_regs(struct pt_regs *regs, int skip)
 	return perf_arch_fetch_caller_regs(regs, ip, skip);
 }
 
+static inline void
+perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
+{
+	if (atomic_read(&perf_swevent_enabled[event_id])) {
+		struct pt_regs hot_regs;
+
+		if (!regs) {
+			perf_fetch_caller_regs(&hot_regs, 1);
+			regs = &hot_regs;
+		}
+		__perf_sw_event(event_id, nr, nmi, regs, addr);
+	}
+}
+
 extern void __perf_event_mmap(struct vm_area_struct *vma);
 
 static inline void perf_event_mmap(struct vm_area_struct *vma)
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 574ee58..681af80 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1164,11 +1164,9 @@ void perf_event_task_sched_out(struct task_struct *task,
 	struct perf_event_context *ctx = task->perf_event_ctxp;
 	struct perf_event_context *next_ctx;
 	struct perf_event_context *parent;
-	struct pt_regs *regs;
 	int do_switch = 1;
 
-	regs = task_pt_regs(task);
-	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, regs, 0);
+	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
 
 	if (likely(!ctx || !cpuctx->task_ctx))
 		return;
@@ -2786,12 +2784,11 @@ __weak struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 	return NULL;
 }
 
-#ifdef CONFIG_EVENT_TRACING
 __weak
 void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int skip)
 {
 }
-#endif
+
 
 /*
  * Output
@@ -3378,15 +3375,23 @@ static void perf_event_task_output(struct perf_event *event,
 				     struct perf_task_event *task_event)
 {
 	struct perf_output_handle handle;
-	int size;
 	struct task_struct *task = task_event->task;
-	int ret;
+	unsigned long flags;
+	int size, ret;
+
+	/*
+	 * If this CPU attempts to acquire an rq lock held by a CPU spinning
+	 * in perf_output_lock() from interrupt context, it's game over.
+	 */
+	local_irq_save(flags);
 
 	size  = task_event->event_id.header.size;
 	ret = perf_output_begin(&handle, event, size, 0, 0);
 
-	if (ret)
+	if (ret) {
+		local_irq_restore(flags);
 		return;
+	}
 
 	task_event->event_id.pid = perf_event_pid(event, task);
 	task_event->event_id.ppid = perf_event_pid(event, current);
@@ -3397,6 +3402,7 @@ static void perf_event_task_output(struct perf_event *event,
 	perf_output_put(&handle, task_event->event_id);
 
 	perf_output_end(&handle);
+	local_irq_restore(flags);
 }
 
 static int perf_event_task_match(struct perf_event *event)
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 81f691e..0565bb4 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -17,7 +17,12 @@ EXPORT_SYMBOL_GPL(perf_arch_fetch_caller_regs);
 static char *perf_trace_buf;
 static char *perf_trace_buf_nmi;
 
-typedef typeof(char [PERF_MAX_TRACE_SIZE]) perf_trace_t ;
+/*
+ * Force it to be aligned to unsigned long to avoid misaligned accesses
+ * suprises
+ */
+typedef typeof(unsigned long [PERF_MAX_TRACE_SIZE / sizeof(unsigned long)])
+	perf_trace_t;
 
 /* Count the events in use (per event id, not per instance) */
 static int	total_ref_count;
@@ -130,6 +135,8 @@ __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
 	char *trace_buf, *raw_data;
 	int pc, cpu;
 
+	BUILD_BUG_ON(PERF_MAX_TRACE_SIZE % sizeof(unsigned long));
+
 	pc = preempt_count();
 
 	/* Protect the per cpu buffer, begin the rcu read side */
@@ -152,7 +159,7 @@ __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
 	raw_data = per_cpu_ptr(trace_buf, cpu);
 
 	/* zero the dead bytes from align to not leak stack to user */
-	*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
+	memset(&raw_data[size - sizeof(u64)], 0, sizeof(u64));
 
 	entry = (struct trace_entry *)raw_data;
 	tracing_generic_entry_update(entry, *irq_flags, pc);
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 8a8f52d..bc0f670 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -200,7 +200,7 @@ endif
 
 CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
-ALL_CFLAGS = $(CFLAGS)
+ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
 ALL_LDFLAGS = $(LDFLAGS)
 STRIP ?= strip
 
@@ -492,19 +492,19 @@ ifeq ($(uname_S),Darwin)
 	PTHREAD_LIBS =
 endif
 
-ifeq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
-ifneq ($(shell sh -c "(echo '\#include <gnu/libc-version.h>'; echo 'int main(void) { const char * version = gnu_get_libc_version(); return (long)version; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
+ifeq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
+ifneq ($(shell sh -c "(echo '\#include <gnu/libc-version.h>'; echo 'int main(void) { const char * version = gnu_get_libc_version(); return (long)version; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 	msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
 endif
 
-	ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
+	ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 		BASIC_CFLAGS += -DLIBELF_NO_MMAP
 	endif
 else
 	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el]);
 endif
 
-ifneq ($(shell sh -c "(echo '\#include <dwarf.h>'; echo '\#include <libdw.h>'; echo 'int main(void) { Dwarf *dbg; dbg = dwarf_begin(0, DWARF_C_READ); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -I/usr/include/elfutils -ldw -lelf -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
+ifneq ($(shell sh -c "(echo '\#include <dwarf.h>'; echo '\#include <libdw.h>'; echo 'int main(void) { Dwarf *dbg; dbg = dwarf_begin(0, DWARF_C_READ); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -I/usr/include/elfutils -ldw -lelf -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 	msg := $(warning No libdw.h found or old libdw.h found, disables dwarf support. Please install elfutils-devel/elfutils-dev);
 	BASIC_CFLAGS += -DNO_DWARF_SUPPORT
 else
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 33a414b..6a72f14 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -208,7 +208,7 @@ static void python_process_event(int cpu, void *data,
 				 int size __unused,
 				 unsigned long long nsecs, char *comm)
 {
-	PyObject *handler, *retval, *context, *t;
+	PyObject *handler, *retval, *context, *t, *obj;
 	static char handler_name[256];
 	struct format_field *field;
 	unsigned long long val;
@@ -256,16 +256,23 @@ static void python_process_event(int cpu, void *data,
 				offset &= 0xffff;
 			} else
 				offset = field->offset;
-			PyTuple_SetItem(t, n++,
-				PyString_FromString((char *)data + offset));
+			obj = PyString_FromString((char *)data + offset);
 		} else { /* FIELD_IS_NUMERIC */
 			val = read_size(data + field->offset, field->size);
 			if (field->flags & FIELD_IS_SIGNED) {
-				PyTuple_SetItem(t, n++, PyInt_FromLong(val));
+				if ((long long)val >= LONG_MIN &&
+				    (long long)val <= LONG_MAX)
+					obj = PyInt_FromLong(val);
+				else
+					obj = PyLong_FromLongLong(val);
 			} else {
-				PyTuple_SetItem(t, n++, PyInt_FromLong(val));
+				if (val <= LONG_MAX)
+					obj = PyInt_FromLong(val);
+				else
+					obj = PyLong_FromUnsignedLongLong(val);
 			}
 		}
+		PyTuple_SetItem(t, n++, obj);
 	}
 
 	if (_PyTuple_Resize(&t, n) == -1)
