Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121Ab0CPQHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 12:07:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35189 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758278Ab0CPQHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 12:07:08 -0400
Date: Tue, 16 Mar 2010 17:06:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20100316160632.GA24231@elte.hu>
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

Now that i look at the combo diff, it seems uncomfortably big to me :-/ A good 
chunk of that is due to three categories of fixes:

 - the hotplug cpu notifier fixes (kernel side)
 - the cpumap fix for hotplugged cpu enumeration (tools side)
 - the multi-event displaying fixes for perf report (tools side)

In hindsight, i could/should have pushed the last one to .35 and we could have 
saved ~200 lines of diffs. If you think it's not acceptable i'll rebase these 
bits and provide a more compact tree. (The rest of the cycle should be pretty 
quiet, we dont have any other pending regressions at the moment.)

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (4):
      perf tools: Don't trow away old map slices not overlapped by new maps
      perf probe: Add missing variable initialization
      perf report: Print the map table just after samples for which no map was found
      perf record: Don't try to find buildids in a zero sized file

Eric B Munson (5):
      perf record: Add ID and to recorded event data when recording multiple events
      perf session: Change add_hist_entry to take the tree root instead of session
      perf session: Add storage for seperating event types in report
      perf session: Change perf_session post processing functions to take histogram tree
      perf report: Add multiple event support

Frederic Weisbecker (5):
      lockdep: Move lock events under lockdep recursion protection
      perf/x86-64: Use frame pointer to walk on irq and process stacks
      perf: Introduce new perf_fetch_caller_regs() for hot regs snapshot
      perf: Take a hot regs snapshot for trace events
      perf: Drop the obsolete profile naming for trace events

John Kacur (1):
      perf: Make the install relative to DESTDIR if specified

Masami Hiramatsu (1):
      kprobes: Calculate the index correctly when freeing the out-of-line execution slot

Paul Mackerras (2):
      perf_event: Fix oops triggered by cpu offline/online
      perf tools: Fix sparse CPU numbering related bugs

Peter Zijlstra (15):
      perf: Rework and fix the arch CPU-hotplug hooks
      perf: Optimize perf_disable
      perf, x86, Do not user perf_disable from NMI context
      perf, x86: Remove superfluous arguments to x86_perf_event_set_period()
      perf, x86: Remove superfluous arguments to x86_perf_event_update()
      perf, x86: Change x86_pmu.{enable,disable} calling convention
      perf, x86: Use unlocked bitops
      perf, x86: Fix x86_pmu_start
      perf, x86: Avoid double disable on throttle vs ioctl(PERF_IOC_DISABLE)
      perf, x86: Properly account n_added
      perf, x86: Fix double disable calls
      perf, x86: Fix double enable calls
      perf: Provide better condition for event rotation
      perf, ppc: Fix compile error due to new cpu notifiers
      perf, x86: Fix hw_perf_enable() event assignment

Xiao Guangrong (1):
      perf: export perf_trace_regs and perf_arch_fetch_caller_regs


 arch/powerpc/kernel/perf_event.c                   |   21 ++-
 arch/sh/kernel/perf_event.c                        |   20 ++-
 arch/x86/kernel/cpu/perf_event.c                   |  182 +++++++++++---------
 arch/x86/kernel/cpu/perf_event_amd.c               |   62 +++----
 arch/x86/kernel/cpu/perf_event_intel.c             |   57 +++---
 arch/x86/kernel/cpu/perf_event_p6.c                |   10 +-
 arch/x86/kernel/dumpstack.h                        |   15 ++
 arch/x86/kernel/dumpstack_64.c                     |    4 +-
 include/linux/ftrace_event.h                       |   23 ++-
 include/linux/perf_event.h                         |   59 ++++++-
 include/linux/syscalls.h                           |   24 ++--
 include/trace/ftrace.h                             |   44 +++--
 include/trace/syscall.h                            |    8 +-
 kernel/kprobes.c                                   |    3 +-
 kernel/lockdep.c                                   |    9 +-
 kernel/perf_event.c                                |   82 ++++-----
 kernel/trace/Makefile                              |    2 +-
 .../{trace_event_profile.c => trace_event_perf.c}  |   48 +++---
 kernel/trace/trace_events.c                        |    2 +-
 kernel/trace/trace_kprobe.c                        |   29 ++--
 kernel/trace/trace_syscalls.c                      |   72 ++++----
 tools/perf/Documentation/Makefile                  |    4 +-
 tools/perf/Makefile                                |    6 +-
 tools/perf/builtin-annotate.c                      |    6 +-
 tools/perf/builtin-diff.c                          |   13 +-
 tools/perf/builtin-record.c                        |   13 +-
 tools/perf/builtin-report.c                        |  112 +++++++++++--
 tools/perf/builtin-stat.c                          |   10 +-
 tools/perf/builtin-top.c                           |    9 +-
 tools/perf/util/cpumap.c                           |   59 +++++++
 tools/perf/util/cpumap.h                           |    7 +
 tools/perf/util/event.h                            |    9 +
 tools/perf/util/hist.c                             |   50 +++---
 tools/perf/util/hist.h                             |   12 +-
 tools/perf/util/probe-finder.c                     |    2 +-
 tools/perf/util/session.c                          |    1 +
 tools/perf/util/session.h                          |    1 +
 tools/perf/util/thread.c                           |   41 ++++-
 tools/perf/util/thread.h                           |    3 +
 39 files changed, 736 insertions(+), 398 deletions(-)
 rename kernel/trace/{trace_event_profile.c => trace_event_perf.c} (69%)
 create mode 100644 tools/perf/util/cpumap.c
 create mode 100644 tools/perf/util/cpumap.h

diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index 5120bd4..08460a2 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -1287,7 +1287,7 @@ static void perf_event_interrupt(struct pt_regs *regs)
 		irq_exit();
 }
 
-void hw_perf_event_setup(int cpu)
+static void power_pmu_setup(int cpu)
 {
 	struct cpu_hw_events *cpuhw = &per_cpu(cpu_hw_events, cpu);
 
@@ -1297,6 +1297,23 @@ void hw_perf_event_setup(int cpu)
 	cpuhw->mmcr[0] = MMCR0_FC;
 }
 
+static int __cpuinit
+power_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (long)hcpu;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_UP_PREPARE:
+		power_pmu_setup(cpu);
+		break;
+
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
 int register_power_pmu(struct power_pmu *pmu)
 {
 	if (ppmu)
@@ -1314,5 +1331,7 @@ int register_power_pmu(struct power_pmu *pmu)
 		freeze_events_kernel = MMCR0_FCHV;
 #endif /* CONFIG_PPC64 */
 
+	perf_cpu_notifier(power_pmu_notifier);
+
 	return 0;
 }
diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
index 7ff0943..9f253e9 100644
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@ -275,13 +275,30 @@ const struct pmu *hw_perf_event_init(struct perf_event *event)
 	return &pmu;
 }
 
-void hw_perf_event_setup(int cpu)
+static void sh_pmu_setup(int cpu)
 {
 	struct cpu_hw_events *cpuhw = &per_cpu(cpu_hw_events, cpu);
 
 	memset(cpuhw, 0, sizeof(struct cpu_hw_events));
 }
 
+static int __cpuinit
+sh_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (long)hcpu;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_UP_PREPARE:
+		sh_pmu_setup(cpu);
+		break;
+
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
 void hw_perf_enable(void)
 {
 	if (!sh_pmu_initialized())
@@ -308,5 +325,6 @@ int register_sh_pmu(struct sh_pmu *pmu)
 
 	WARN_ON(pmu->num_events > MAX_HWEVENTS);
 
+	perf_cpu_notifier(sh_pmu_notifier);
 	return 0;
 }
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 42aafd1..7645fae 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -133,8 +133,8 @@ struct x86_pmu {
 	int		(*handle_irq)(struct pt_regs *);
 	void		(*disable_all)(void);
 	void		(*enable_all)(void);
-	void		(*enable)(struct hw_perf_event *, int);
-	void		(*disable)(struct hw_perf_event *, int);
+	void		(*enable)(struct perf_event *);
+	void		(*disable)(struct perf_event *);
 	unsigned	eventsel;
 	unsigned	perfctr;
 	u64		(*event_map)(int);
@@ -157,6 +157,11 @@ struct x86_pmu {
 	void		(*put_event_constraints)(struct cpu_hw_events *cpuc,
 						 struct perf_event *event);
 	struct event_constraint *event_constraints;
+
+	void		(*cpu_prepare)(int cpu);
+	void		(*cpu_starting)(int cpu);
+	void		(*cpu_dying)(int cpu);
+	void		(*cpu_dead)(int cpu);
 };
 
 static struct x86_pmu x86_pmu __read_mostly;
@@ -165,8 +170,7 @@ static DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
 	.enabled = 1,
 };
 
-static int x86_perf_event_set_period(struct perf_event *event,
-			     struct hw_perf_event *hwc, int idx);
+static int x86_perf_event_set_period(struct perf_event *event);
 
 /*
  * Generalized hw caching related hw_event table, filled
@@ -189,11 +193,12 @@ static u64 __read_mostly hw_cache_event_ids
  * Returns the delta events processed.
  */
 static u64
-x86_perf_event_update(struct perf_event *event,
-			struct hw_perf_event *hwc, int idx)
+x86_perf_event_update(struct perf_event *event)
 {
+	struct hw_perf_event *hwc = &event->hw;
 	int shift = 64 - x86_pmu.event_bits;
 	u64 prev_raw_count, new_raw_count;
+	int idx = hwc->idx;
 	s64 delta;
 
 	if (idx == X86_PMC_IDX_FIXED_BTS)
@@ -293,7 +298,7 @@ static inline bool bts_available(void)
 	return x86_pmu.enable_bts != NULL;
 }
 
-static inline void init_debug_store_on_cpu(int cpu)
+static void init_debug_store_on_cpu(int cpu)
 {
 	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
 
@@ -305,7 +310,7 @@ static inline void init_debug_store_on_cpu(int cpu)
 		     (u32)((u64)(unsigned long)ds >> 32));
 }
 
-static inline void fini_debug_store_on_cpu(int cpu)
+static void fini_debug_store_on_cpu(int cpu)
 {
 	if (!per_cpu(cpu_hw_events, cpu).ds)
 		return;
@@ -638,7 +643,7 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 		if (test_bit(hwc->idx, used_mask))
 			break;
 
-		set_bit(hwc->idx, used_mask);
+		__set_bit(hwc->idx, used_mask);
 		if (assign)
 			assign[i] = hwc->idx;
 	}
@@ -687,7 +692,7 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 			if (j == X86_PMC_IDX_MAX)
 				break;
 
-			set_bit(j, used_mask);
+			__set_bit(j, used_mask);
 
 			if (assign)
 				assign[i] = j;
@@ -780,6 +785,7 @@ static inline int match_prev_assignment(struct hw_perf_event *hwc,
 		hwc->last_tag == cpuc->tags[i];
 }
 
+static int x86_pmu_start(struct perf_event *event);
 static void x86_pmu_stop(struct perf_event *event);
 
 void hw_perf_enable(void)
@@ -796,6 +802,7 @@ void hw_perf_enable(void)
 		return;
 
 	if (cpuc->n_added) {
+		int n_running = cpuc->n_events - cpuc->n_added;
 		/*
 		 * apply assignment obtained either from
 		 * hw_perf_group_sched_in() or x86_pmu_enable()
@@ -803,8 +810,7 @@ void hw_perf_enable(void)
 		 * step1: save events moving to new counters
 		 * step2: reprogram moved events into new counters
 		 */
-		for (i = 0; i < cpuc->n_events; i++) {
-
+		for (i = 0; i < n_running; i++) {
 			event = cpuc->event_list[i];
 			hwc = &event->hw;
 
@@ -819,29 +825,18 @@ void hw_perf_enable(void)
 				continue;
 
 			x86_pmu_stop(event);
-
-			hwc->idx = -1;
 		}
 
 		for (i = 0; i < cpuc->n_events; i++) {
-
 			event = cpuc->event_list[i];
 			hwc = &event->hw;
 
-			if (hwc->idx == -1) {
+			if (!match_prev_assignment(hwc, cpuc, i))
 				x86_assign_hw_event(event, cpuc, i);
-				x86_perf_event_set_period(event, hwc, hwc->idx);
-			}
-			/*
-			 * need to mark as active because x86_pmu_disable()
-			 * clear active_mask and events[] yet it preserves
-			 * idx
-			 */
-			set_bit(hwc->idx, cpuc->active_mask);
-			cpuc->events[hwc->idx] = event;
+			else if (i < n_running)
+				continue;
 
-			x86_pmu.enable(hwc, hwc->idx);
-			perf_event_update_userpage(event);
+			x86_pmu_start(event);
 		}
 		cpuc->n_added = 0;
 		perf_events_lapic_init();
@@ -853,15 +848,16 @@ void hw_perf_enable(void)
 	x86_pmu.enable_all();
 }
 
-static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc, int idx)
+static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc)
 {
-	(void)checking_wrmsrl(hwc->config_base + idx,
+	(void)checking_wrmsrl(hwc->config_base + hwc->idx,
 			      hwc->config | ARCH_PERFMON_EVENTSEL_ENABLE);
 }
 
-static inline void x86_pmu_disable_event(struct hw_perf_event *hwc, int idx)
+static inline void x86_pmu_disable_event(struct perf_event *event)
 {
-	(void)checking_wrmsrl(hwc->config_base + idx, hwc->config);
+	struct hw_perf_event *hwc = &event->hw;
+	(void)checking_wrmsrl(hwc->config_base + hwc->idx, hwc->config);
 }
 
 static DEFINE_PER_CPU(u64 [X86_PMC_IDX_MAX], pmc_prev_left);
@@ -871,12 +867,12 @@ static DEFINE_PER_CPU(u64 [X86_PMC_IDX_MAX], pmc_prev_left);
  * To be called with the event disabled in hw:
  */
 static int
-x86_perf_event_set_period(struct perf_event *event,
-			     struct hw_perf_event *hwc, int idx)
+x86_perf_event_set_period(struct perf_event *event)
 {
+	struct hw_perf_event *hwc = &event->hw;
 	s64 left = atomic64_read(&hwc->period_left);
 	s64 period = hwc->sample_period;
-	int err, ret = 0;
+	int err, ret = 0, idx = hwc->idx;
 
 	if (idx == X86_PMC_IDX_FIXED_BTS)
 		return 0;
@@ -922,11 +918,11 @@ x86_perf_event_set_period(struct perf_event *event,
 	return ret;
 }
 
-static void x86_pmu_enable_event(struct hw_perf_event *hwc, int idx)
+static void x86_pmu_enable_event(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	if (cpuc->enabled)
-		__x86_pmu_enable_event(hwc, idx);
+		__x86_pmu_enable_event(&event->hw);
 }
 
 /*
@@ -962,34 +958,32 @@ static int x86_pmu_enable(struct perf_event *event)
 	memcpy(cpuc->assign, assign, n*sizeof(int));
 
 	cpuc->n_events = n;
-	cpuc->n_added  = n - n0;
+	cpuc->n_added += n - n0;
 
 	return 0;
 }
 
 static int x86_pmu_start(struct perf_event *event)
 {
-	struct hw_perf_event *hwc = &event->hw;
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int idx = event->hw.idx;
 
-	if (hwc->idx == -1)
+	if (idx == -1)
 		return -EAGAIN;
 
-	x86_perf_event_set_period(event, hwc, hwc->idx);
-	x86_pmu.enable(hwc, hwc->idx);
+	x86_perf_event_set_period(event);
+	cpuc->events[idx] = event;
+	__set_bit(idx, cpuc->active_mask);
+	x86_pmu.enable(event);
+	perf_event_update_userpage(event);
 
 	return 0;
 }
 
 static void x86_pmu_unthrottle(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct hw_perf_event *hwc = &event->hw;
-
-	if (WARN_ON_ONCE(hwc->idx >= X86_PMC_IDX_MAX ||
-				cpuc->events[hwc->idx] != event))
-		return;
-
-	x86_pmu.enable(hwc, hwc->idx);
+	int ret = x86_pmu_start(event);
+	WARN_ON_ONCE(ret);
 }
 
 void perf_event_print_debug(void)
@@ -1049,18 +1043,16 @@ static void x86_pmu_stop(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
-	/*
-	 * Must be done before we disable, otherwise the nmi handler
-	 * could reenable again:
-	 */
-	clear_bit(idx, cpuc->active_mask);
-	x86_pmu.disable(hwc, idx);
+	if (!__test_and_clear_bit(idx, cpuc->active_mask))
+		return;
+
+	x86_pmu.disable(event);
 
 	/*
 	 * Drain the remaining delta count out of a event
 	 * that we are disabling:
 	 */
-	x86_perf_event_update(event, hwc, idx);
+	x86_perf_event_update(event);
 
 	cpuc->events[idx] = NULL;
 }
@@ -1108,7 +1100,7 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 		event = cpuc->events[idx];
 		hwc = &event->hw;
 
-		val = x86_perf_event_update(event, hwc, idx);
+		val = x86_perf_event_update(event);
 		if (val & (1ULL << (x86_pmu.event_bits - 1)))
 			continue;
 
@@ -1118,11 +1110,11 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 		handled		= 1;
 		data.period	= event->hw.last_period;
 
-		if (!x86_perf_event_set_period(event, hwc, idx))
+		if (!x86_perf_event_set_period(event))
 			continue;
 
 		if (perf_event_overflow(event, 1, &data, regs))
-			x86_pmu.disable(hwc, idx);
+			x86_pmu_stop(event);
 	}
 
 	if (handled)
@@ -1309,7 +1301,7 @@ int hw_perf_group_sched_in(struct perf_event *leader,
 	memcpy(cpuc->assign, assign, n0*sizeof(int));
 
 	cpuc->n_events  = n0;
-	cpuc->n_added   = n1;
+	cpuc->n_added  += n1;
 	ctx->nr_active += n1;
 
 	/*
@@ -1337,6 +1329,39 @@ undo:
 #include "perf_event_p6.c"
 #include "perf_event_intel.c"
 
+static int __cpuinit
+x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (long)hcpu;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_UP_PREPARE:
+		if (x86_pmu.cpu_prepare)
+			x86_pmu.cpu_prepare(cpu);
+		break;
+
+	case CPU_STARTING:
+		if (x86_pmu.cpu_starting)
+			x86_pmu.cpu_starting(cpu);
+		break;
+
+	case CPU_DYING:
+		if (x86_pmu.cpu_dying)
+			x86_pmu.cpu_dying(cpu);
+		break;
+
+	case CPU_DEAD:
+		if (x86_pmu.cpu_dead)
+			x86_pmu.cpu_dead(cpu);
+		break;
+
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
 static void __init pmu_check_apic(void)
 {
 	if (cpu_has_apic)
@@ -1415,11 +1440,13 @@ void __init init_hw_perf_events(void)
 	pr_info("... max period:             %016Lx\n", x86_pmu.max_period);
 	pr_info("... fixed-purpose events:   %d\n",     x86_pmu.num_events_fixed);
 	pr_info("... event mask:             %016Lx\n", perf_event_mask);
+
+	perf_cpu_notifier(x86_pmu_notifier);
 }
 
 static inline void x86_pmu_read(struct perf_event *event)
 {
-	x86_perf_event_update(event, &event->hw, event->hw.idx);
+	x86_perf_event_update(event);
 }
 
 static const struct pmu pmu = {
@@ -1675,28 +1702,15 @@ struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 	return entry;
 }
 
-void hw_perf_event_setup_online(int cpu)
+void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int skip)
 {
-	init_debug_store_on_cpu(cpu);
-
-	switch (boot_cpu_data.x86_vendor) {
-	case X86_VENDOR_AMD:
-		amd_pmu_cpu_online(cpu);
-		break;
-	default:
-		return;
-	}
-}
-
-void hw_perf_event_setup_offline(int cpu)
-{
-	init_debug_store_on_cpu(cpu);
-
-	switch (boot_cpu_data.x86_vendor) {
-	case X86_VENDOR_AMD:
-		amd_pmu_cpu_offline(cpu);
-		break;
-	default:
-		return;
-	}
+	regs->ip = ip;
+	/*
+	 * perf_arch_fetch_caller_regs adds another call, we need to increment
+	 * the skip level
+	 */
+	regs->bp = rewind_frame_pointer(skip + 1);
+	regs->cs = __KERNEL_CS;
+	local_save_flags(regs->flags);
 }
+EXPORT_SYMBOL_GPL(perf_arch_fetch_caller_regs);
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 8f3dbfd..573458f 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -271,28 +271,6 @@ done:
 	return &emptyconstraint;
 }
 
-static __initconst struct x86_pmu amd_pmu = {
-	.name			= "AMD",
-	.handle_irq		= x86_pmu_handle_irq,
-	.disable_all		= x86_pmu_disable_all,
-	.enable_all		= x86_pmu_enable_all,
-	.enable			= x86_pmu_enable_event,
-	.disable		= x86_pmu_disable_event,
-	.eventsel		= MSR_K7_EVNTSEL0,
-	.perfctr		= MSR_K7_PERFCTR0,
-	.event_map		= amd_pmu_event_map,
-	.raw_event		= amd_pmu_raw_event,
-	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
-	.num_events		= 4,
-	.event_bits		= 48,
-	.event_mask		= (1ULL << 48) - 1,
-	.apic			= 1,
-	/* use highest bit to detect overflow */
-	.max_period		= (1ULL << 47) - 1,
-	.get_event_constraints	= amd_get_event_constraints,
-	.put_event_constraints	= amd_put_event_constraints
-};
-
 static struct amd_nb *amd_alloc_nb(int cpu, int nb_id)
 {
 	struct amd_nb *nb;
@@ -309,7 +287,7 @@ static struct amd_nb *amd_alloc_nb(int cpu, int nb_id)
 	 * initialize all possible NB constraints
 	 */
 	for (i = 0; i < x86_pmu.num_events; i++) {
-		set_bit(i, nb->event_constraints[i].idxmsk);
+		__set_bit(i, nb->event_constraints[i].idxmsk);
 		nb->event_constraints[i].weight = 1;
 	}
 	return nb;
@@ -378,6 +356,31 @@ static void amd_pmu_cpu_offline(int cpu)
 	raw_spin_unlock(&amd_nb_lock);
 }
 
+static __initconst struct x86_pmu amd_pmu = {
+	.name			= "AMD",
+	.handle_irq		= x86_pmu_handle_irq,
+	.disable_all		= x86_pmu_disable_all,
+	.enable_all		= x86_pmu_enable_all,
+	.enable			= x86_pmu_enable_event,
+	.disable		= x86_pmu_disable_event,
+	.eventsel		= MSR_K7_EVNTSEL0,
+	.perfctr		= MSR_K7_PERFCTR0,
+	.event_map		= amd_pmu_event_map,
+	.raw_event		= amd_pmu_raw_event,
+	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
+	.num_events		= 4,
+	.event_bits		= 48,
+	.event_mask		= (1ULL << 48) - 1,
+	.apic			= 1,
+	/* use highest bit to detect overflow */
+	.max_period		= (1ULL << 47) - 1,
+	.get_event_constraints	= amd_get_event_constraints,
+	.put_event_constraints	= amd_put_event_constraints,
+
+	.cpu_prepare		= amd_pmu_cpu_online,
+	.cpu_dead		= amd_pmu_cpu_offline,
+};
+
 static __init int amd_pmu_init(void)
 {
 	/* Performance-monitoring supported from K7 and later: */
@@ -390,11 +393,6 @@ static __init int amd_pmu_init(void)
 	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
 	       sizeof(hw_cache_event_ids));
 
-	/*
-	 * explicitly initialize the boot cpu, other cpus will get
-	 * the cpu hotplug callbacks from smp_init()
-	 */
-	amd_pmu_cpu_online(smp_processor_id());
 	return 0;
 }
 
@@ -405,12 +403,4 @@ static int amd_pmu_init(void)
 	return 0;
 }
 
-static void amd_pmu_cpu_online(int cpu)
-{
-}
-
-static void amd_pmu_cpu_offline(int cpu)
-{
-}
-
 #endif
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 44b60c8..84bfde6 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -548,9 +548,9 @@ static inline void intel_pmu_ack_status(u64 ack)
 }
 
 static inline void
-intel_pmu_disable_fixed(struct hw_perf_event *hwc, int __idx)
+intel_pmu_disable_fixed(struct hw_perf_event *hwc)
 {
-	int idx = __idx - X86_PMC_IDX_FIXED;
+	int idx = hwc->idx - X86_PMC_IDX_FIXED;
 	u64 ctrl_val, mask;
 
 	mask = 0xfULL << (idx * 4);
@@ -621,26 +621,28 @@ static void intel_pmu_drain_bts_buffer(void)
 }
 
 static inline void
-intel_pmu_disable_event(struct hw_perf_event *hwc, int idx)
+intel_pmu_disable_event(struct perf_event *event)
 {
-	if (unlikely(idx == X86_PMC_IDX_FIXED_BTS)) {
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (unlikely(hwc->idx == X86_PMC_IDX_FIXED_BTS)) {
 		intel_pmu_disable_bts();
 		intel_pmu_drain_bts_buffer();
 		return;
 	}
 
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
-		intel_pmu_disable_fixed(hwc, idx);
+		intel_pmu_disable_fixed(hwc);
 		return;
 	}
 
-	x86_pmu_disable_event(hwc, idx);
+	x86_pmu_disable_event(event);
 }
 
 static inline void
-intel_pmu_enable_fixed(struct hw_perf_event *hwc, int __idx)
+intel_pmu_enable_fixed(struct hw_perf_event *hwc)
 {
-	int idx = __idx - X86_PMC_IDX_FIXED;
+	int idx = hwc->idx - X86_PMC_IDX_FIXED;
 	u64 ctrl_val, bits, mask;
 	int err;
 
@@ -670,9 +672,11 @@ intel_pmu_enable_fixed(struct hw_perf_event *hwc, int __idx)
 	err = checking_wrmsrl(hwc->config_base, ctrl_val);
 }
 
-static void intel_pmu_enable_event(struct hw_perf_event *hwc, int idx)
+static void intel_pmu_enable_event(struct perf_event *event)
 {
-	if (unlikely(idx == X86_PMC_IDX_FIXED_BTS)) {
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (unlikely(hwc->idx == X86_PMC_IDX_FIXED_BTS)) {
 		if (!__get_cpu_var(cpu_hw_events).enabled)
 			return;
 
@@ -681,11 +685,11 @@ static void intel_pmu_enable_event(struct hw_perf_event *hwc, int idx)
 	}
 
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
-		intel_pmu_enable_fixed(hwc, idx);
+		intel_pmu_enable_fixed(hwc);
 		return;
 	}
 
-	__x86_pmu_enable_event(hwc, idx);
+	__x86_pmu_enable_event(hwc);
 }
 
 /*
@@ -694,14 +698,8 @@ static void intel_pmu_enable_event(struct hw_perf_event *hwc, int idx)
  */
 static int intel_pmu_save_and_restart(struct perf_event *event)
 {
-	struct hw_perf_event *hwc = &event->hw;
-	int idx = hwc->idx;
-	int ret;
-
-	x86_perf_event_update(event, hwc, idx);
-	ret = x86_perf_event_set_period(event, hwc, idx);
-
-	return ret;
+	x86_perf_event_update(event);
+	return x86_perf_event_set_period(event);
 }
 
 static void intel_pmu_reset(void)
@@ -745,11 +743,11 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
-	perf_disable();
+	intel_pmu_disable_all();
 	intel_pmu_drain_bts_buffer();
 	status = intel_pmu_get_status();
 	if (!status) {
-		perf_enable();
+		intel_pmu_enable_all();
 		return 0;
 	}
 
@@ -759,8 +757,7 @@ again:
 		WARN_ONCE(1, "perfevents: irq loop stuck!\n");
 		perf_event_print_debug();
 		intel_pmu_reset();
-		perf_enable();
-		return 1;
+		goto done;
 	}
 
 	inc_irq_stat(apic_perf_irqs);
@@ -768,7 +765,6 @@ again:
 	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
 		struct perf_event *event = cpuc->events[bit];
 
-		clear_bit(bit, (unsigned long *) &status);
 		if (!test_bit(bit, cpuc->active_mask))
 			continue;
 
@@ -778,7 +774,7 @@ again:
 		data.period = event->hw.last_period;
 
 		if (perf_event_overflow(event, 1, &data, regs))
-			intel_pmu_disable_event(&event->hw, bit);
+			x86_pmu_stop(event);
 	}
 
 	intel_pmu_ack_status(ack);
@@ -790,8 +786,8 @@ again:
 	if (status)
 		goto again;
 
-	perf_enable();
-
+done:
+	intel_pmu_enable_all();
 	return 1;
 }
 
@@ -870,7 +866,10 @@ static __initconst struct x86_pmu intel_pmu = {
 	.max_period		= (1ULL << 31) - 1,
 	.enable_bts		= intel_pmu_enable_bts,
 	.disable_bts		= intel_pmu_disable_bts,
-	.get_event_constraints	= intel_get_event_constraints
+	.get_event_constraints	= intel_get_event_constraints,
+
+	.cpu_starting		= init_debug_store_on_cpu,
+	.cpu_dying		= fini_debug_store_on_cpu,
 };
 
 static __init int intel_pmu_init(void)
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index a4e67b9..a330485 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -77,27 +77,29 @@ static void p6_pmu_enable_all(void)
 }
 
 static inline void
-p6_pmu_disable_event(struct hw_perf_event *hwc, int idx)
+p6_pmu_disable_event(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct hw_perf_event *hwc = &event->hw;
 	u64 val = P6_NOP_EVENT;
 
 	if (cpuc->enabled)
 		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 
-	(void)checking_wrmsrl(hwc->config_base + idx, val);
+	(void)checking_wrmsrl(hwc->config_base + hwc->idx, val);
 }
 
-static void p6_pmu_enable_event(struct hw_perf_event *hwc, int idx)
+static void p6_pmu_enable_event(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct hw_perf_event *hwc = &event->hw;
 	u64 val;
 
 	val = hwc->config;
 	if (cpuc->enabled)
 		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 
-	(void)checking_wrmsrl(hwc->config_base + idx, val);
+	(void)checking_wrmsrl(hwc->config_base + hwc->idx, val);
 }
 
 static __initconst struct x86_pmu p6_pmu = {
diff --git a/arch/x86/kernel/dumpstack.h b/arch/x86/kernel/dumpstack.h
index 4fd1420..29e5f7c 100644
--- a/arch/x86/kernel/dumpstack.h
+++ b/arch/x86/kernel/dumpstack.h
@@ -29,4 +29,19 @@ struct stack_frame {
 	struct stack_frame *next_frame;
 	unsigned long return_address;
 };
+
+static inline unsigned long rewind_frame_pointer(int n)
+{
+	struct stack_frame *frame;
+
+	get_bp(frame);
+
+#ifdef CONFIG_FRAME_POINTER
+	while (n--)
+		frame = frame->next_frame;
 #endif
+
+	return (unsigned long)frame;
+}
+
+#endif /* DUMPSTACK_H */
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index d5e2a2e..272c9f1 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -208,7 +208,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 			if (in_irq_stack(stack, irq_stack, irq_stack_end)) {
 				if (ops->stack(data, "IRQ") < 0)
 					break;
-				bp = print_context_stack(tinfo, stack, bp,
+				bp = ops->walk_stack(tinfo, stack, bp,
 					ops, data, irq_stack_end, &graph);
 				/*
 				 * We link to the next stack (which would be
@@ -229,7 +229,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	/*
 	 * This handles the process stack:
 	 */
-	bp = print_context_stack(tinfo, stack, bp, ops, data, NULL, &graph);
+	bp = ops->walk_stack(tinfo, stack, bp, ops, data, NULL, &graph);
 	put_cpu();
 }
 EXPORT_SYMBOL(dump_trace);
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 6b7c444..c0f4b36 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -131,12 +131,12 @@ struct ftrace_event_call {
 	void			*mod;
 	void			*data;
 
-	int			profile_count;
-	int			(*profile_enable)(struct ftrace_event_call *);
-	void			(*profile_disable)(struct ftrace_event_call *);
+	int			perf_refcount;
+	int			(*perf_event_enable)(struct ftrace_event_call *);
+	void			(*perf_event_disable)(struct ftrace_event_call *);
 };
 
-#define FTRACE_MAX_PROFILE_SIZE	2048
+#define PERF_MAX_TRACE_SIZE	2048
 
 #define MAX_FILTER_PRED		32
 #define MAX_FILTER_STR_VAL	256	/* Should handle KSYM_SYMBOL_LEN */
@@ -187,22 +187,25 @@ do {									\
 
 #ifdef CONFIG_PERF_EVENTS
 struct perf_event;
-extern int ftrace_profile_enable(int event_id);
-extern void ftrace_profile_disable(int event_id);
+
+DECLARE_PER_CPU(struct pt_regs, perf_trace_regs);
+
+extern int perf_trace_enable(int event_id);
+extern void perf_trace_disable(int event_id);
 extern int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 				     char *filter_str);
 extern void ftrace_profile_free_filter(struct perf_event *event);
 extern void *
-ftrace_perf_buf_prepare(int size, unsigned short type, int *rctxp,
+perf_trace_buf_prepare(int size, unsigned short type, int *rctxp,
 			 unsigned long *irq_flags);
 
 static inline void
-ftrace_perf_buf_submit(void *raw_data, int size, int rctx, u64 addr,
-		       u64 count, unsigned long irq_flags)
+perf_trace_buf_submit(void *raw_data, int size, int rctx, u64 addr,
+		       u64 count, unsigned long irq_flags, struct pt_regs *regs)
 {
 	struct trace_entry *entry = raw_data;
 
-	perf_tp_event(entry->type, addr, count, raw_data, size);
+	perf_tp_event(entry->type, addr, count, raw_data, size, regs);
 	perf_swevent_put_recursion_context(rctx);
 	local_irq_restore(irq_flags);
 }
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6f8cd7d..9547703 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -452,6 +452,8 @@ enum perf_callchain_context {
 #include <linux/fs.h>
 #include <linux/pid_namespace.h>
 #include <linux/workqueue.h>
+#include <linux/ftrace.h>
+#include <linux/cpu.h>
 #include <asm/atomic.h>
 
 #define PERF_MAX_STACK_DEPTH		255
@@ -847,6 +849,44 @@ perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
 		__perf_sw_event(event_id, nr, nmi, regs, addr);
 }
 
+extern void
+perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int skip);
+
+/*
+ * Take a snapshot of the regs. Skip ip and frame pointer to
+ * the nth caller. We only need a few of the regs:
+ * - ip for PERF_SAMPLE_IP
+ * - cs for user_mode() tests
+ * - bp for callchains
+ * - eflags, for future purposes, just in case
+ */
+static inline void perf_fetch_caller_regs(struct pt_regs *regs, int skip)
+{
+	unsigned long ip;
+
+	memset(regs, 0, sizeof(*regs));
+
+	switch (skip) {
+	case 1 :
+		ip = CALLER_ADDR0;
+		break;
+	case 2 :
+		ip = CALLER_ADDR1;
+		break;
+	case 3 :
+		ip = CALLER_ADDR2;
+		break;
+	case 4:
+		ip = CALLER_ADDR3;
+		break;
+	/* No need to support further for now */
+	default:
+		ip = 0;
+	}
+
+	return perf_arch_fetch_caller_regs(regs, ip, skip);
+}
+
 extern void __perf_event_mmap(struct vm_area_struct *vma);
 
 static inline void perf_event_mmap(struct vm_area_struct *vma)
@@ -880,7 +920,8 @@ static inline bool perf_paranoid_kernel(void)
 }
 
 extern void perf_event_init(void);
-extern void perf_tp_event(int event_id, u64 addr, u64 count, void *record, int entry_size);
+extern void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
+			  int entry_size, struct pt_regs *regs);
 extern void perf_bp_event(struct perf_event *event, void *data);
 
 #ifndef perf_misc_flags
@@ -936,5 +977,21 @@ static inline void perf_event_disable(struct perf_event *event)		{ }
 #define perf_output_put(handle, x) \
 	perf_output_copy((handle), &(x), sizeof(x))
 
+/*
+ * This has to have a higher priority than migration_notifier in sched.c.
+ */
+#define perf_cpu_notifier(fn)					\
+do {								\
+	static struct notifier_block fn##_nb __cpuinitdata =	\
+		{ .notifier_call = fn, .priority = 20 };	\
+	fn(&fn##_nb, (unsigned long)CPU_UP_PREPARE,		\
+		(void *)(unsigned long)smp_processor_id());	\
+	fn(&fn##_nb, (unsigned long)CPU_STARTING,		\
+		(void *)(unsigned long)smp_processor_id());	\
+	fn(&fn##_nb, (unsigned long)CPU_ONLINE,			\
+		(void *)(unsigned long)smp_processor_id());	\
+	register_cpu_notifier(&fn##_nb);			\
+} while (0)
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_PERF_EVENT_H */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 8126f23..51435bc 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -101,18 +101,18 @@ struct perf_event_attr;
 
 #ifdef CONFIG_PERF_EVENTS
 
-#define TRACE_SYS_ENTER_PROFILE_INIT(sname)				       \
-	.profile_enable = prof_sysenter_enable,				       \
-	.profile_disable = prof_sysenter_disable,
+#define TRACE_SYS_ENTER_PERF_INIT(sname)				       \
+	.perf_event_enable = perf_sysenter_enable,			       \
+	.perf_event_disable = perf_sysenter_disable,
 
-#define TRACE_SYS_EXIT_PROFILE_INIT(sname)				       \
-	.profile_enable = prof_sysexit_enable,				       \
-	.profile_disable = prof_sysexit_disable,
+#define TRACE_SYS_EXIT_PERF_INIT(sname)					       \
+	.perf_event_enable = perf_sysexit_enable,			       \
+	.perf_event_disable = perf_sysexit_disable,
 #else
-#define TRACE_SYS_ENTER_PROFILE(sname)
-#define TRACE_SYS_ENTER_PROFILE_INIT(sname)
-#define TRACE_SYS_EXIT_PROFILE(sname)
-#define TRACE_SYS_EXIT_PROFILE_INIT(sname)
+#define TRACE_SYS_ENTER_PERF(sname)
+#define TRACE_SYS_ENTER_PERF_INIT(sname)
+#define TRACE_SYS_EXIT_PERF(sname)
+#define TRACE_SYS_EXIT_PERF_INIT(sname)
 #endif /* CONFIG_PERF_EVENTS */
 
 #ifdef CONFIG_FTRACE_SYSCALLS
@@ -149,7 +149,7 @@ struct perf_event_attr;
 		.regfunc		= reg_event_syscall_enter,	\
 		.unregfunc		= unreg_event_syscall_enter,	\
 		.data			= (void *)&__syscall_meta_##sname,\
-		TRACE_SYS_ENTER_PROFILE_INIT(sname)			\
+		TRACE_SYS_ENTER_PERF_INIT(sname)			\
 	}
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
@@ -171,7 +171,7 @@ struct perf_event_attr;
 		.regfunc		= reg_event_syscall_exit,	\
 		.unregfunc		= unreg_event_syscall_exit,	\
 		.data			= (void *)&__syscall_meta_##sname,\
-		TRACE_SYS_EXIT_PROFILE_INIT(sname)			\
+		TRACE_SYS_EXIT_PERF_INIT(sname)			\
 	}
 
 #define SYSCALL_METADATA(sname, nb)				\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 0804cd5..25ab56f 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -401,18 +401,18 @@ static inline notrace int ftrace_get_offsets_##call(			\
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args)			\
 									\
-static void ftrace_profile_##name(proto);				\
+static void perf_trace_##name(proto);					\
 									\
 static notrace int							\
-ftrace_profile_enable_##name(struct ftrace_event_call *unused)		\
+perf_trace_enable_##name(struct ftrace_event_call *unused)		\
 {									\
-	return register_trace_##name(ftrace_profile_##name);		\
+	return register_trace_##name(perf_trace_##name);		\
 }									\
 									\
 static notrace void							\
-ftrace_profile_disable_##name(struct ftrace_event_call *unused)		\
+perf_trace_disable_##name(struct ftrace_event_call *unused)		\
 {									\
-	unregister_trace_##name(ftrace_profile_##name);			\
+	unregister_trace_##name(perf_trace_##name);			\
 }
 
 #undef DEFINE_EVENT_PRINT
@@ -507,12 +507,12 @@ ftrace_profile_disable_##name(struct ftrace_event_call *unused)		\
 
 #ifdef CONFIG_PERF_EVENTS
 
-#define _TRACE_PROFILE_INIT(call)					\
-	.profile_enable = ftrace_profile_enable_##call,			\
-	.profile_disable = ftrace_profile_disable_##call,
+#define _TRACE_PERF_INIT(call)						\
+	.perf_event_enable = perf_trace_enable_##call,			\
+	.perf_event_disable = perf_trace_disable_##call,
 
 #else
-#define _TRACE_PROFILE_INIT(call)
+#define _TRACE_PERF_INIT(call)
 #endif /* CONFIG_PERF_EVENTS */
 
 #undef __entry
@@ -638,7 +638,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
 	.print_fmt		= print_fmt_##template,			\
 	.define_fields		= ftrace_define_fields_##template,	\
-	_TRACE_PROFILE_INIT(call)					\
+	_TRACE_PERF_INIT(call)					\
 }
 
 #undef DEFINE_EVENT_PRINT
@@ -657,18 +657,18 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
 	.print_fmt		= print_fmt_##call,			\
 	.define_fields		= ftrace_define_fields_##template,	\
-	_TRACE_PROFILE_INIT(call)					\
+	_TRACE_PERF_INIT(call)					\
 }
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 /*
- * Define the insertion callback to profile events
+ * Define the insertion callback to perf events
  *
  * The job is very similar to ftrace_raw_event_<call> except that we don't
  * insert in the ring buffer but in a perf counter.
  *
- * static void ftrace_profile_<call>(proto)
+ * static void ftrace_perf_<call>(proto)
  * {
  *	struct ftrace_data_offsets_<call> __maybe_unused __data_offsets;
  *	struct ftrace_event_call *event_call = &event_<call>;
@@ -757,13 +757,14 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 static notrace void							\
-ftrace_profile_templ_##call(struct ftrace_event_call *event_call,	\
+perf_trace_templ_##call(struct ftrace_event_call *event_call,		\
 			    proto)					\
 {									\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
 	struct ftrace_raw_##call *entry;				\
 	u64 __addr = 0, __count = 1;					\
 	unsigned long irq_flags;					\
+	struct pt_regs *__regs;						\
 	int __entry_size;						\
 	int __data_size;						\
 	int rctx;							\
@@ -773,10 +774,10 @@ ftrace_profile_templ_##call(struct ftrace_event_call *event_call,	\
 			     sizeof(u64));				\
 	__entry_size -= sizeof(u32);					\
 									\
-	if (WARN_ONCE(__entry_size > FTRACE_MAX_PROFILE_SIZE,		\
+	if (WARN_ONCE(__entry_size > PERF_MAX_TRACE_SIZE,		\
 		      "profile buffer not large enough"))		\
 		return;							\
-	entry = (struct ftrace_raw_##call *)ftrace_perf_buf_prepare(	\
+	entry = (struct ftrace_raw_##call *)perf_trace_buf_prepare(	\
 		__entry_size, event_call->id, &rctx, &irq_flags);	\
 	if (!entry)							\
 		return;							\
@@ -784,17 +785,20 @@ ftrace_profile_templ_##call(struct ftrace_event_call *event_call,	\
 									\
 	{ assign; }							\
 									\
-	ftrace_perf_buf_submit(entry, __entry_size, rctx, __addr,	\
-			       __count, irq_flags);			\
+	__regs = &__get_cpu_var(perf_trace_regs);			\
+	perf_fetch_caller_regs(__regs, 2);				\
+									\
+	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
+			       __count, irq_flags, __regs);		\
 }
 
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, call, proto, args)		\
-static notrace void ftrace_profile_##call(proto)		\
+static notrace void perf_trace_##call(proto)			\
 {								\
 	struct ftrace_event_call *event_call = &event_##call;	\
 								\
-	ftrace_profile_templ_##template(event_call, args);	\
+	perf_trace_templ_##template(event_call, args);		\
 }
 
 #undef DEFINE_EVENT_PRINT
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 0387100..e5e5f48 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -47,10 +47,10 @@ enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags);
 #endif
 
 #ifdef CONFIG_PERF_EVENTS
-int prof_sysenter_enable(struct ftrace_event_call *call);
-void prof_sysenter_disable(struct ftrace_event_call *call);
-int prof_sysexit_enable(struct ftrace_event_call *call);
-void prof_sysexit_disable(struct ftrace_event_call *call);
+int perf_sysenter_enable(struct ftrace_event_call *call);
+void perf_sysenter_disable(struct ftrace_event_call *call);
+int perf_sysexit_enable(struct ftrace_event_call *call);
+void perf_sysexit_disable(struct ftrace_event_call *call);
 #endif
 
 #endif /* _TRACE_SYSCALL_H */
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index fa034d2..0ed46f3 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -259,7 +259,8 @@ static void __kprobes __free_insn_slot(struct kprobe_insn_cache *c,
 	struct kprobe_insn_page *kip;
 
 	list_for_each_entry(kip, &c->pages, list) {
-		long idx = ((long)slot - (long)kip->insns) / c->insn_size;
+		long idx = ((long)slot - (long)kip->insns) /
+				(c->insn_size * sizeof(kprobe_opcode_t));
 		if (idx >= 0 && idx < slots_per_page(c)) {
 			WARN_ON(kip->slot_used[idx] != SLOT_USED);
 			if (dirty) {
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 0c30d04..65b5f5b 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3211,8 +3211,6 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 {
 	unsigned long flags;
 
-	trace_lock_acquire(lock, subclass, trylock, read, check, nest_lock, ip);
-
 	if (unlikely(current->lockdep_recursion))
 		return;
 
@@ -3220,6 +3218,7 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	check_flags(flags);
 
 	current->lockdep_recursion = 1;
+	trace_lock_acquire(lock, subclass, trylock, read, check, nest_lock, ip);
 	__lock_acquire(lock, subclass, trylock, read, check,
 		       irqs_disabled_flags(flags), nest_lock, ip, 0);
 	current->lockdep_recursion = 0;
@@ -3232,14 +3231,13 @@ void lock_release(struct lockdep_map *lock, int nested,
 {
 	unsigned long flags;
 
-	trace_lock_release(lock, nested, ip);
-
 	if (unlikely(current->lockdep_recursion))
 		return;
 
 	raw_local_irq_save(flags);
 	check_flags(flags);
 	current->lockdep_recursion = 1;
+	trace_lock_release(lock, nested, ip);
 	__lock_release(lock, nested, ip);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
@@ -3413,8 +3411,6 @@ void lock_contended(struct lockdep_map *lock, unsigned long ip)
 {
 	unsigned long flags;
 
-	trace_lock_contended(lock, ip);
-
 	if (unlikely(!lock_stat))
 		return;
 
@@ -3424,6 +3420,7 @@ void lock_contended(struct lockdep_map *lock, unsigned long ip)
 	raw_local_irq_save(flags);
 	check_flags(flags);
 	current->lockdep_recursion = 1;
+	trace_lock_contended(lock, ip);
 	__lock_contended(lock, ip);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 4393b9e..fb3031c 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -81,10 +81,6 @@ extern __weak const struct pmu *hw_perf_event_init(struct perf_event *event)
 void __weak hw_perf_disable(void)		{ barrier(); }
 void __weak hw_perf_enable(void)		{ barrier(); }
 
-void __weak hw_perf_event_setup(int cpu)	{ barrier(); }
-void __weak hw_perf_event_setup_online(int cpu)	{ barrier(); }
-void __weak hw_perf_event_setup_offline(int cpu)	{ barrier(); }
-
 int __weak
 hw_perf_group_sched_in(struct perf_event *group_leader,
 	       struct perf_cpu_context *cpuctx,
@@ -97,25 +93,15 @@ void __weak perf_event_print_debug(void)	{ }
 
 static DEFINE_PER_CPU(int, perf_disable_count);
 
-void __perf_disable(void)
-{
-	__get_cpu_var(perf_disable_count)++;
-}
-
-bool __perf_enable(void)
-{
-	return !--__get_cpu_var(perf_disable_count);
-}
-
 void perf_disable(void)
 {
-	__perf_disable();
-	hw_perf_disable();
+	if (!__get_cpu_var(perf_disable_count)++)
+		hw_perf_disable();
 }
 
 void perf_enable(void)
 {
-	if (__perf_enable())
+	if (!--__get_cpu_var(perf_disable_count))
 		hw_perf_enable();
 }
 
@@ -1538,12 +1524,15 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
 		 */
 		if (interrupts == MAX_INTERRUPTS) {
 			perf_log_throttle(event, 1);
+			perf_disable();
 			event->pmu->unthrottle(event);
+			perf_enable();
 		}
 
 		if (!event->attr.freq || !event->attr.sample_freq)
 			continue;
 
+		perf_disable();
 		event->pmu->read(event);
 		now = atomic64_read(&event->count);
 		delta = now - hwc->freq_count_stamp;
@@ -1551,6 +1540,7 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
 
 		if (delta > 0)
 			perf_adjust_period(event, TICK_NSEC, delta);
+		perf_enable();
 	}
 	raw_spin_unlock(&ctx->lock);
 }
@@ -1560,9 +1550,6 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
  */
 static void rotate_ctx(struct perf_event_context *ctx)
 {
-	if (!ctx->nr_events)
-		return;
-
 	raw_spin_lock(&ctx->lock);
 
 	/* Rotate the first entry last of non-pinned groups */
@@ -1575,19 +1562,28 @@ void perf_event_task_tick(struct task_struct *curr)
 {
 	struct perf_cpu_context *cpuctx;
 	struct perf_event_context *ctx;
+	int rotate = 0;
 
 	if (!atomic_read(&nr_events))
 		return;
 
 	cpuctx = &__get_cpu_var(perf_cpu_context);
-	ctx = curr->perf_event_ctxp;
+	if (cpuctx->ctx.nr_events &&
+	    cpuctx->ctx.nr_events != cpuctx->ctx.nr_active)
+		rotate = 1;
 
-	perf_disable();
+	ctx = curr->perf_event_ctxp;
+	if (ctx && ctx->nr_events && ctx->nr_events != ctx->nr_active)
+		rotate = 1;
 
 	perf_ctx_adjust_freq(&cpuctx->ctx);
 	if (ctx)
 		perf_ctx_adjust_freq(ctx);
 
+	if (!rotate)
+		return;
+
+	perf_disable();
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 	if (ctx)
 		task_ctx_sched_out(ctx, EVENT_FLEXIBLE);
@@ -1599,7 +1595,6 @@ void perf_event_task_tick(struct task_struct *curr)
 	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
 	if (ctx)
 		task_ctx_sched_in(curr, EVENT_FLEXIBLE);
-
 	perf_enable();
 }
 
@@ -2791,6 +2786,11 @@ __weak struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 	return NULL;
 }
 
+__weak
+void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int skip)
+{
+}
+
 /*
  * Output
  */
@@ -4318,9 +4318,8 @@ static const struct pmu perf_ops_task_clock = {
 #ifdef CONFIG_EVENT_TRACING
 
 void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
-			  int entry_size)
+		   int entry_size, struct pt_regs *regs)
 {
-	struct pt_regs *regs = get_irq_regs();
 	struct perf_sample_data data;
 	struct perf_raw_record raw = {
 		.size = entry_size,
@@ -4330,12 +4329,9 @@ void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
 	perf_sample_data_init(&data, addr);
 	data.raw = &raw;
 
-	if (!regs)
-		regs = task_pt_regs(current);
-
 	/* Trace events already protected against recursion */
 	do_perf_sw_event(PERF_TYPE_TRACEPOINT, event_id, count, 1,
-				&data, regs);
+			 &data, regs);
 }
 EXPORT_SYMBOL_GPL(perf_tp_event);
 
@@ -4351,7 +4347,7 @@ static int perf_tp_event_match(struct perf_event *event,
 
 static void tp_perf_event_destroy(struct perf_event *event)
 {
-	ftrace_profile_disable(event->attr.config);
+	perf_trace_disable(event->attr.config);
 }
 
 static const struct pmu *tp_perf_event_init(struct perf_event *event)
@@ -4365,7 +4361,7 @@ static const struct pmu *tp_perf_event_init(struct perf_event *event)
 			!capable(CAP_SYS_ADMIN))
 		return ERR_PTR(-EPERM);
 
-	if (ftrace_profile_enable(event->attr.config))
+	if (perf_trace_enable(event->attr.config))
 		return NULL;
 
 	event->destroy = tp_perf_event_destroy;
@@ -5372,18 +5368,26 @@ int perf_event_init_task(struct task_struct *child)
 	return ret;
 }
 
+static void __init perf_event_init_all_cpus(void)
+{
+	int cpu;
+	struct perf_cpu_context *cpuctx;
+
+	for_each_possible_cpu(cpu) {
+		cpuctx = &per_cpu(perf_cpu_context, cpu);
+		__perf_event_init_context(&cpuctx->ctx, NULL);
+	}
+}
+
 static void __cpuinit perf_event_init_cpu(int cpu)
 {
 	struct perf_cpu_context *cpuctx;
 
 	cpuctx = &per_cpu(perf_cpu_context, cpu);
-	__perf_event_init_context(&cpuctx->ctx, NULL);
 
 	spin_lock(&perf_resource_lock);
 	cpuctx->max_pertask = perf_max_events - perf_reserved_percpu;
 	spin_unlock(&perf_resource_lock);
-
-	hw_perf_event_setup(cpu);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -5423,20 +5427,11 @@ perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 		perf_event_init_cpu(cpu);
 		break;
 
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		hw_perf_event_setup_online(cpu);
-		break;
-
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
 		perf_event_exit_cpu(cpu);
 		break;
 
-	case CPU_DEAD:
-		hw_perf_event_setup_offline(cpu);
-		break;
-
 	default:
 		break;
 	}
@@ -5454,6 +5449,7 @@ static struct notifier_block __cpuinitdata perf_cpu_nb = {
 
 void __init perf_event_init(void)
 {
+	perf_event_init_all_cpus();
 	perf_cpu_notify(&perf_cpu_nb, (unsigned long)CPU_UP_PREPARE,
 			(void *)(long)smp_processor_id());
 	perf_cpu_notify(&perf_cpu_nb, (unsigned long)CPU_ONLINE,
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index d00c6fe..78edc64 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -52,7 +52,7 @@ obj-$(CONFIG_EVENT_TRACING) += trace_events.o
 obj-$(CONFIG_EVENT_TRACING) += trace_export.o
 obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
 ifeq ($(CONFIG_PERF_EVENTS),y)
-obj-$(CONFIG_EVENT_TRACING) += trace_event_profile.o
+obj-$(CONFIG_EVENT_TRACING) += trace_event_perf.o
 endif
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
 obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_perf.c
similarity index 69%
rename from kernel/trace/trace_event_profile.c
rename to kernel/trace/trace_event_perf.c
index f0d6930..0709e4f 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_perf.c
@@ -1,32 +1,34 @@
 /*
- * trace event based perf counter profiling
+ * trace event based perf event profiling/tracing
  *
  * Copyright (C) 2009 Red Hat Inc, Peter Zijlstra <pzijlstr@redhat.com>
- *
+ * Copyright (C) 2009-2010 Frederic Weisbecker <fweisbec@gmail.com>
  */
 
 #include <linux/module.h>
 #include <linux/kprobes.h>
 #include "trace.h"
 
+DEFINE_PER_CPU(struct pt_regs, perf_trace_regs);
+EXPORT_PER_CPU_SYMBOL_GPL(perf_trace_regs);
 
 static char *perf_trace_buf;
 static char *perf_trace_buf_nmi;
 
-typedef typeof(char [FTRACE_MAX_PROFILE_SIZE]) perf_trace_t ;
+typedef typeof(char [PERF_MAX_TRACE_SIZE]) perf_trace_t ;
 
 /* Count the events in use (per event id, not per instance) */
-static int	total_profile_count;
+static int	total_ref_count;
 
-static int ftrace_profile_enable_event(struct ftrace_event_call *event)
+static int perf_trace_event_enable(struct ftrace_event_call *event)
 {
 	char *buf;
 	int ret = -ENOMEM;
 
-	if (event->profile_count++ > 0)
+	if (event->perf_refcount++ > 0)
 		return 0;
 
-	if (!total_profile_count) {
+	if (!total_ref_count) {
 		buf = (char *)alloc_percpu(perf_trace_t);
 		if (!buf)
 			goto fail_buf;
@@ -40,35 +42,35 @@ static int ftrace_profile_enable_event(struct ftrace_event_call *event)
 		rcu_assign_pointer(perf_trace_buf_nmi, buf);
 	}
 
-	ret = event->profile_enable(event);
+	ret = event->perf_event_enable(event);
 	if (!ret) {
-		total_profile_count++;
+		total_ref_count++;
 		return 0;
 	}
 
 fail_buf_nmi:
-	if (!total_profile_count) {
+	if (!total_ref_count) {
 		free_percpu(perf_trace_buf_nmi);
 		free_percpu(perf_trace_buf);
 		perf_trace_buf_nmi = NULL;
 		perf_trace_buf = NULL;
 	}
 fail_buf:
-	event->profile_count--;
+	event->perf_refcount--;
 
 	return ret;
 }
 
-int ftrace_profile_enable(int event_id)
+int perf_trace_enable(int event_id)
 {
 	struct ftrace_event_call *event;
 	int ret = -EINVAL;
 
 	mutex_lock(&event_mutex);
 	list_for_each_entry(event, &ftrace_events, list) {
-		if (event->id == event_id && event->profile_enable &&
+		if (event->id == event_id && event->perf_event_enable &&
 		    try_module_get(event->mod)) {
-			ret = ftrace_profile_enable_event(event);
+			ret = perf_trace_event_enable(event);
 			break;
 		}
 	}
@@ -77,16 +79,16 @@ int ftrace_profile_enable(int event_id)
 	return ret;
 }
 
-static void ftrace_profile_disable_event(struct ftrace_event_call *event)
+static void perf_trace_event_disable(struct ftrace_event_call *event)
 {
 	char *buf, *nmi_buf;
 
-	if (--event->profile_count > 0)
+	if (--event->perf_refcount > 0)
 		return;
 
-	event->profile_disable(event);
+	event->perf_event_disable(event);
 
-	if (!--total_profile_count) {
+	if (!--total_ref_count) {
 		buf = perf_trace_buf;
 		rcu_assign_pointer(perf_trace_buf, NULL);
 
@@ -104,14 +106,14 @@ static void ftrace_profile_disable_event(struct ftrace_event_call *event)
 	}
 }
 
-void ftrace_profile_disable(int event_id)
+void perf_trace_disable(int event_id)
 {
 	struct ftrace_event_call *event;
 
 	mutex_lock(&event_mutex);
 	list_for_each_entry(event, &ftrace_events, list) {
 		if (event->id == event_id) {
-			ftrace_profile_disable_event(event);
+			perf_trace_event_disable(event);
 			module_put(event->mod);
 			break;
 		}
@@ -119,8 +121,8 @@ void ftrace_profile_disable(int event_id)
 	mutex_unlock(&event_mutex);
 }
 
-__kprobes void *ftrace_perf_buf_prepare(int size, unsigned short type,
-					int *rctxp, unsigned long *irq_flags)
+__kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
+				       int *rctxp, unsigned long *irq_flags)
 {
 	struct trace_entry *entry;
 	char *trace_buf, *raw_data;
@@ -161,4 +163,4 @@ err_recursion:
 	local_irq_restore(*irq_flags);
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(ftrace_perf_buf_prepare);
+EXPORT_SYMBOL_GPL(perf_trace_buf_prepare);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 3f972ad..beab8bf 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -938,7 +938,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		trace_create_file("enable", 0644, call->dir, call,
 				  enable);
 
-	if (call->id && call->profile_enable)
+	if (call->id && call->perf_event_enable)
 		trace_create_file("id", 0444, call->dir, call,
 		 		  id);
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 505c922..1251e36 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1214,7 +1214,7 @@ static int set_print_fmt(struct trace_probe *tp)
 #ifdef CONFIG_PERF_EVENTS
 
 /* Kprobe profile handler */
-static __kprobes void kprobe_profile_func(struct kprobe *kp,
+static __kprobes void kprobe_perf_func(struct kprobe *kp,
 					 struct pt_regs *regs)
 {
 	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
@@ -1227,11 +1227,11 @@ static __kprobes void kprobe_profile_func(struct kprobe *kp,
 	__size = SIZEOF_KPROBE_TRACE_ENTRY(tp->nr_args);
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
-	if (WARN_ONCE(size > FTRACE_MAX_PROFILE_SIZE,
+	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
 		     "profile buffer not large enough"))
 		return;
 
-	entry = ftrace_perf_buf_prepare(size, call->id, &rctx, &irq_flags);
+	entry = perf_trace_buf_prepare(size, call->id, &rctx, &irq_flags);
 	if (!entry)
 		return;
 
@@ -1240,11 +1240,11 @@ static __kprobes void kprobe_profile_func(struct kprobe *kp,
 	for (i = 0; i < tp->nr_args; i++)
 		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
 
-	ftrace_perf_buf_submit(entry, size, rctx, entry->ip, 1, irq_flags);
+	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, irq_flags, regs);
 }
 
 /* Kretprobe profile handler */
-static __kprobes void kretprobe_profile_func(struct kretprobe_instance *ri,
+static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 					    struct pt_regs *regs)
 {
 	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
@@ -1257,11 +1257,11 @@ static __kprobes void kretprobe_profile_func(struct kretprobe_instance *ri,
 	__size = SIZEOF_KRETPROBE_TRACE_ENTRY(tp->nr_args);
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
-	if (WARN_ONCE(size > FTRACE_MAX_PROFILE_SIZE,
+	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
 		     "profile buffer not large enough"))
 		return;
 
-	entry = ftrace_perf_buf_prepare(size, call->id, &rctx, &irq_flags);
+	entry = perf_trace_buf_prepare(size, call->id, &rctx, &irq_flags);
 	if (!entry)
 		return;
 
@@ -1271,10 +1271,11 @@ static __kprobes void kretprobe_profile_func(struct kretprobe_instance *ri,
 	for (i = 0; i < tp->nr_args; i++)
 		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
 
-	ftrace_perf_buf_submit(entry, size, rctx, entry->ret_ip, 1, irq_flags);
+	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1,
+			       irq_flags, regs);
 }
 
-static int probe_profile_enable(struct ftrace_event_call *call)
+static int probe_perf_enable(struct ftrace_event_call *call)
 {
 	struct trace_probe *tp = (struct trace_probe *)call->data;
 
@@ -1286,7 +1287,7 @@ static int probe_profile_enable(struct ftrace_event_call *call)
 		return enable_kprobe(&tp->rp.kp);
 }
 
-static void probe_profile_disable(struct ftrace_event_call *call)
+static void probe_perf_disable(struct ftrace_event_call *call)
 {
 	struct trace_probe *tp = (struct trace_probe *)call->data;
 
@@ -1311,7 +1312,7 @@ int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
 		kprobe_trace_func(kp, regs);
 #ifdef CONFIG_PERF_EVENTS
 	if (tp->flags & TP_FLAG_PROFILE)
-		kprobe_profile_func(kp, regs);
+		kprobe_perf_func(kp, regs);
 #endif
 	return 0;	/* We don't tweek kernel, so just return 0 */
 }
@@ -1325,7 +1326,7 @@ int kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
 		kretprobe_trace_func(ri, regs);
 #ifdef CONFIG_PERF_EVENTS
 	if (tp->flags & TP_FLAG_PROFILE)
-		kretprobe_profile_func(ri, regs);
+		kretprobe_perf_func(ri, regs);
 #endif
 	return 0;	/* We don't tweek kernel, so just return 0 */
 }
@@ -1358,8 +1359,8 @@ static int register_probe_event(struct trace_probe *tp)
 	call->unregfunc = probe_event_disable;
 
 #ifdef CONFIG_PERF_EVENTS
-	call->profile_enable = probe_profile_enable;
-	call->profile_disable = probe_profile_disable;
+	call->perf_event_enable = probe_perf_enable;
+	call->perf_event_disable = probe_perf_disable;
 #endif
 	call->data = tp;
 	ret = trace_add_event_call(call);
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index cba47d7..33c2a5b 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -428,12 +428,12 @@ core_initcall(init_ftrace_syscalls);
 
 #ifdef CONFIG_PERF_EVENTS
 
-static DECLARE_BITMAP(enabled_prof_enter_syscalls, NR_syscalls);
-static DECLARE_BITMAP(enabled_prof_exit_syscalls, NR_syscalls);
-static int sys_prof_refcount_enter;
-static int sys_prof_refcount_exit;
+static DECLARE_BITMAP(enabled_perf_enter_syscalls, NR_syscalls);
+static DECLARE_BITMAP(enabled_perf_exit_syscalls, NR_syscalls);
+static int sys_perf_refcount_enter;
+static int sys_perf_refcount_exit;
 
-static void prof_syscall_enter(struct pt_regs *regs, long id)
+static void perf_syscall_enter(struct pt_regs *regs, long id)
 {
 	struct syscall_metadata *sys_data;
 	struct syscall_trace_enter *rec;
@@ -443,7 +443,7 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 	int size;
 
 	syscall_nr = syscall_get_nr(current, regs);
-	if (!test_bit(syscall_nr, enabled_prof_enter_syscalls))
+	if (!test_bit(syscall_nr, enabled_perf_enter_syscalls))
 		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
@@ -455,11 +455,11 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 	size = ALIGN(size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
 
-	if (WARN_ONCE(size > FTRACE_MAX_PROFILE_SIZE,
-		      "profile buffer not large enough"))
+	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
+		      "perf buffer not large enough"))
 		return;
 
-	rec = (struct syscall_trace_enter *)ftrace_perf_buf_prepare(size,
+	rec = (struct syscall_trace_enter *)perf_trace_buf_prepare(size,
 				sys_data->enter_event->id, &rctx, &flags);
 	if (!rec)
 		return;
@@ -467,10 +467,10 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 	rec->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
 			       (unsigned long *)&rec->args);
-	ftrace_perf_buf_submit(rec, size, rctx, 0, 1, flags);
+	perf_trace_buf_submit(rec, size, rctx, 0, 1, flags, regs);
 }
 
-int prof_sysenter_enable(struct ftrace_event_call *call)
+int perf_sysenter_enable(struct ftrace_event_call *call)
 {
 	int ret = 0;
 	int num;
@@ -478,34 +478,34 @@ int prof_sysenter_enable(struct ftrace_event_call *call)
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
 
 	mutex_lock(&syscall_trace_lock);
-	if (!sys_prof_refcount_enter)
-		ret = register_trace_sys_enter(prof_syscall_enter);
+	if (!sys_perf_refcount_enter)
+		ret = register_trace_sys_enter(perf_syscall_enter);
 	if (ret) {
 		pr_info("event trace: Could not activate"
 				"syscall entry trace point");
 	} else {
-		set_bit(num, enabled_prof_enter_syscalls);
-		sys_prof_refcount_enter++;
+		set_bit(num, enabled_perf_enter_syscalls);
+		sys_perf_refcount_enter++;
 	}
 	mutex_unlock(&syscall_trace_lock);
 	return ret;
 }
 
-void prof_sysenter_disable(struct ftrace_event_call *call)
+void perf_sysenter_disable(struct ftrace_event_call *call)
 {
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
 
 	mutex_lock(&syscall_trace_lock);
-	sys_prof_refcount_enter--;
-	clear_bit(num, enabled_prof_enter_syscalls);
-	if (!sys_prof_refcount_enter)
-		unregister_trace_sys_enter(prof_syscall_enter);
+	sys_perf_refcount_enter--;
+	clear_bit(num, enabled_perf_enter_syscalls);
+	if (!sys_perf_refcount_enter)
+		unregister_trace_sys_enter(perf_syscall_enter);
 	mutex_unlock(&syscall_trace_lock);
 }
 
-static void prof_syscall_exit(struct pt_regs *regs, long ret)
+static void perf_syscall_exit(struct pt_regs *regs, long ret)
 {
 	struct syscall_metadata *sys_data;
 	struct syscall_trace_exit *rec;
@@ -515,7 +515,7 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 	int size;
 
 	syscall_nr = syscall_get_nr(current, regs);
-	if (!test_bit(syscall_nr, enabled_prof_exit_syscalls))
+	if (!test_bit(syscall_nr, enabled_perf_exit_syscalls))
 		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
@@ -530,11 +530,11 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 	 * Impossible, but be paranoid with the future
 	 * How to put this check outside runtime?
 	 */
-	if (WARN_ONCE(size > FTRACE_MAX_PROFILE_SIZE,
-		"exit event has grown above profile buffer size"))
+	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
+		"exit event has grown above perf buffer size"))
 		return;
 
-	rec = (struct syscall_trace_exit *)ftrace_perf_buf_prepare(size,
+	rec = (struct syscall_trace_exit *)perf_trace_buf_prepare(size,
 				sys_data->exit_event->id, &rctx, &flags);
 	if (!rec)
 		return;
@@ -542,10 +542,10 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 	rec->nr = syscall_nr;
 	rec->ret = syscall_get_return_value(current, regs);
 
-	ftrace_perf_buf_submit(rec, size, rctx, 0, 1, flags);
+	perf_trace_buf_submit(rec, size, rctx, 0, 1, flags, regs);
 }
 
-int prof_sysexit_enable(struct ftrace_event_call *call)
+int perf_sysexit_enable(struct ftrace_event_call *call)
 {
 	int ret = 0;
 	int num;
@@ -553,30 +553,30 @@ int prof_sysexit_enable(struct ftrace_event_call *call)
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
 
 	mutex_lock(&syscall_trace_lock);
-	if (!sys_prof_refcount_exit)
-		ret = register_trace_sys_exit(prof_syscall_exit);
+	if (!sys_perf_refcount_exit)
+		ret = register_trace_sys_exit(perf_syscall_exit);
 	if (ret) {
 		pr_info("event trace: Could not activate"
 				"syscall exit trace point");
 	} else {
-		set_bit(num, enabled_prof_exit_syscalls);
-		sys_prof_refcount_exit++;
+		set_bit(num, enabled_perf_exit_syscalls);
+		sys_perf_refcount_exit++;
 	}
 	mutex_unlock(&syscall_trace_lock);
 	return ret;
 }
 
-void prof_sysexit_disable(struct ftrace_event_call *call)
+void perf_sysexit_disable(struct ftrace_event_call *call)
 {
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
 
 	mutex_lock(&syscall_trace_lock);
-	sys_prof_refcount_exit--;
-	clear_bit(num, enabled_prof_exit_syscalls);
-	if (!sys_prof_refcount_exit)
-		unregister_trace_sys_exit(prof_syscall_exit);
+	sys_perf_refcount_exit--;
+	clear_bit(num, enabled_perf_exit_syscalls);
+	if (!sys_perf_refcount_exit)
+		unregister_trace_sys_exit(perf_syscall_exit);
 	mutex_unlock(&syscall_trace_lock);
 }
 
diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index bdd3b7e..bd498d4 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -24,7 +24,10 @@ DOC_MAN1=$(patsubst %.txt,%.1,$(MAN1_TXT))
 DOC_MAN5=$(patsubst %.txt,%.5,$(MAN5_TXT))
 DOC_MAN7=$(patsubst %.txt,%.7,$(MAN7_TXT))
 
+# Make the path relative to DESTDIR, not prefix
+ifndef DESTDIR
 prefix?=$(HOME)
+endif
 bindir?=$(prefix)/bin
 htmldir?=$(prefix)/share/doc/perf-doc
 pdfdir?=$(prefix)/share/doc/perf-doc
@@ -32,7 +35,6 @@ mandir?=$(prefix)/share/man
 man1dir=$(mandir)/man1
 man5dir=$(mandir)/man5
 man7dir=$(mandir)/man7
-# DESTDIR=
 
 ASCIIDOC=asciidoc
 ASCIIDOC_EXTRA = --unsafe
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2d53738..8a8f52d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -216,7 +216,10 @@ STRIP ?= strip
 # runtime figures out where they are based on the path to the executable.
 # This can help installing the suite in a relocatable way.
 
+# Make the path relative to DESTDIR, not to prefix
+ifndef DESTDIR
 prefix = $(HOME)
+endif
 bindir_relative = bin
 bindir = $(prefix)/$(bindir_relative)
 mandir = share/man
@@ -233,7 +236,6 @@ sysconfdir = $(prefix)/etc
 ETC_PERFCONFIG = etc/perfconfig
 endif
 lib = lib
-# DESTDIR=
 
 export prefix bindir sharedir sysconfdir
 
@@ -387,6 +389,7 @@ LIB_H += util/thread.h
 LIB_H += util/trace-event.h
 LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
+LIB_H += util/cpumap.h
 
 LIB_OBJS += util/abspath.o
 LIB_OBJS += util/alias.o
@@ -433,6 +436,7 @@ LIB_OBJS += util/sort.o
 LIB_OBJS += util/hist.o
 LIB_OBJS += util/probe-event.o
 LIB_OBJS += util/util.o
+LIB_OBJS += util/cpumap.o
 
 BUILTIN_OBJS += builtin-annotate.o
 
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 5ec5de9..6ad7148 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -116,7 +116,7 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 		return 0;
 	}
 
-	he = __perf_session__add_hist_entry(self, al, NULL, count, &hit);
+	he = __perf_session__add_hist_entry(&self->hists, al, NULL, count, &hit);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -564,8 +564,8 @@ static int __cmd_annotate(void)
 	if (verbose > 2)
 		dsos__fprintf(stdout);
 
-	perf_session__collapse_resort(session);
-	perf_session__output_resort(session, session->event_total[0]);
+	perf_session__collapse_resort(&session->hists);
+	perf_session__output_resort(&session->hists, session->event_total[0]);
 	perf_session__find_annotations(session);
 out_delete:
 	perf_session__delete(session);
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 18b3f50..1ea15d8 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -26,7 +26,8 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 					struct addr_location *al, u64 count)
 {
 	bool hit;
-	struct hist_entry *he = __perf_session__add_hist_entry(self, al, NULL,
+	struct hist_entry *he = __perf_session__add_hist_entry(&self->hists,
+							       al, NULL,
 							       count, &hit);
 	if (he == NULL)
 		return -ENOMEM;
@@ -114,7 +115,7 @@ static void perf_session__resort_hist_entries(struct perf_session *self)
 
 static void perf_session__set_hist_entries_positions(struct perf_session *self)
 {
-	perf_session__output_resort(self, self->events_stats.total);
+	perf_session__output_resort(&self->hists, self->events_stats.total);
 	perf_session__resort_hist_entries(self);
 }
 
@@ -166,13 +167,15 @@ static int __cmd_diff(void)
 			goto out_delete;
 	}
 
-	perf_session__output_resort(session[1], session[1]->events_stats.total);
+	perf_session__output_resort(&session[1]->hists,
+				    session[1]->events_stats.total);
 	if (show_displacement)
 		perf_session__set_hist_entries_positions(session[0]);
 
 	perf_session__match_hists(session[0], session[1]);
-	perf_session__fprintf_hists(session[1], session[0],
-				    show_displacement, stdout);
+	perf_session__fprintf_hists(&session[1]->hists, session[0],
+				    show_displacement, stdout,
+				    session[1]->events_stats.total);
 out_delete:
 	for (i = 0; i < 2; ++i)
 		perf_session__delete(session[i]);
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 771533c..3b8b638 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -22,6 +22,7 @@
 #include "util/debug.h"
 #include "util/session.h"
 #include "util/symbol.h"
+#include "util/cpumap.h"
 
 #include <unistd.h>
 #include <sched.h>
@@ -244,6 +245,9 @@ static void create_counter(int counter, int cpu, pid_t pid)
 
 	attr->sample_type	|= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
+	if (nr_counters > 1)
+		attr->sample_type |= PERF_SAMPLE_ID;
+
 	if (freq) {
 		attr->sample_type	|= PERF_SAMPLE_PERIOD;
 		attr->freq		= 1;
@@ -391,6 +395,9 @@ static int process_buildids(void)
 {
 	u64 size = lseek(output, 0, SEEK_CUR);
 
+	if (size == 0)
+		return 0;
+
 	session->fd = output;
 	return __perf_session__process_events(session, post_processing_offset,
 					      size - post_processing_offset,
@@ -418,9 +425,6 @@ static int __cmd_record(int argc, const char **argv)
 	char buf;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
-	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
-	assert(nr_cpus <= MAX_NR_CPUS);
-	assert(nr_cpus >= 0);
 
 	atexit(sig_atexit);
 	signal(SIGCHLD, sig_handler);
@@ -544,8 +548,9 @@ static int __cmd_record(int argc, const char **argv)
 	if ((!system_wide && !inherit) || profile_cpu != -1) {
 		open_counters(profile_cpu, target_pid);
 	} else {
+		nr_cpus = read_cpu_map();
 		for (i = 0; i < nr_cpus; i++)
-			open_counters(i, target_pid);
+			open_counters(cpumap[i], target_pid);
 	}
 
 	if (file_new) {
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index cfc655d..f815de2 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -45,28 +45,71 @@ static char		*pretty_printing_style = default_pretty_printing_style;
 
 static char		callchain_default_opt[] = "fractal,0.5";
 
+static struct event_stat_id *get_stats(struct perf_session *self,
+				       u64 event_stream, u32 type, u64 config)
+{
+	struct rb_node **p = &self->stats_by_id.rb_node;
+	struct rb_node *parent = NULL;
+	struct event_stat_id *iter, *new;
+
+	while (*p != NULL) {
+		parent = *p;
+		iter = rb_entry(parent, struct event_stat_id, rb_node);
+		if (iter->config == config)
+			return iter;
+
+
+		if (config > iter->config)
+			p = &(*p)->rb_right;
+		else
+			p = &(*p)->rb_left;
+	}
+
+	new = malloc(sizeof(struct event_stat_id));
+	if (new == NULL)
+		return NULL;
+	memset(new, 0, sizeof(struct event_stat_id));
+	new->event_stream = event_stream;
+	new->config = config;
+	new->type = type;
+	rb_link_node(&new->rb_node, parent, p);
+	rb_insert_color(&new->rb_node, &self->stats_by_id);
+	return new;
+}
+
 static int perf_session__add_hist_entry(struct perf_session *self,
 					struct addr_location *al,
-					struct ip_callchain *chain, u64 count)
+					struct sample_data *data)
 {
 	struct symbol **syms = NULL, *parent = NULL;
 	bool hit;
 	struct hist_entry *he;
+	struct event_stat_id *stats;
+	struct perf_event_attr *attr;
 
-	if ((sort__has_parent || symbol_conf.use_callchain) && chain)
+	if ((sort__has_parent || symbol_conf.use_callchain) && data->callchain)
 		syms = perf_session__resolve_callchain(self, al->thread,
-						       chain, &parent);
-	he = __perf_session__add_hist_entry(self, al, parent, count, &hit);
+						       data->callchain, &parent);
+
+	attr = perf_header__find_attr(data->id, &self->header);
+	if (attr)
+		stats = get_stats(self, data->id, attr->type, attr->config);
+	else
+		stats = get_stats(self, data->id, 0, 0);
+	if (stats == NULL)
+		return -ENOMEM;
+	he = __perf_session__add_hist_entry(&stats->hists, al, parent,
+					    data->period, &hit);
 	if (he == NULL)
 		return -ENOMEM;
 
 	if (hit)
-		he->count += count;
+		he->count += data->period;
 
 	if (symbol_conf.use_callchain) {
 		if (!hit)
 			callchain_init(&he->callchain);
-		append_chain(&he->callchain, chain, syms);
+		append_chain(&he->callchain, data->callchain, syms);
 		free(syms);
 	}
 
@@ -86,10 +129,30 @@ static int validate_chain(struct ip_callchain *chain, event_t *event)
 	return 0;
 }
 
+static int add_event_total(struct perf_session *session,
+			   struct sample_data *data,
+			   struct perf_event_attr *attr)
+{
+	struct event_stat_id *stats;
+
+	if (attr)
+		stats = get_stats(session, data->id, attr->type, attr->config);
+	else
+		stats = get_stats(session, data->id, 0, 0);
+
+	if (!stats)
+		return -ENOMEM;
+
+	stats->stats.total += data->period;
+	session->events_stats.total += data->period;
+	return 0;
+}
+
 static int process_sample_event(event_t *event, struct perf_session *session)
 {
 	struct sample_data data = { .period = 1, };
 	struct addr_location al;
+	struct perf_event_attr *attr;
 
 	event__parse_sample(event, session->sample_type, &data);
 
@@ -123,12 +186,18 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	if (al.filtered || (hide_unresolved && al.sym == NULL))
 		return 0;
 
-	if (perf_session__add_hist_entry(session, &al, data.callchain, data.period)) {
+	if (perf_session__add_hist_entry(session, &al, &data)) {
 		pr_debug("problem incrementing symbol count, skipping event\n");
 		return -1;
 	}
 
-	session->events_stats.total += data.period;
+	attr = perf_header__find_attr(data.id, &session->header);
+
+	if (add_event_total(session, &data, attr)) {
+		pr_debug("problem adding event count\n");
+		return -1;
+	}
+
 	return 0;
 }
 
@@ -197,6 +266,7 @@ static int __cmd_report(void)
 {
 	int ret = -EINVAL;
 	struct perf_session *session;
+	struct rb_node *next;
 
 	session = perf_session__new(input_name, O_RDONLY, force);
 	if (session == NULL)
@@ -224,10 +294,28 @@ static int __cmd_report(void)
 	if (verbose > 2)
 		dsos__fprintf(stdout);
 
-	perf_session__collapse_resort(session);
-	perf_session__output_resort(session, session->events_stats.total);
-	fprintf(stdout, "# Samples: %Ld\n#\n", session->events_stats.total);
-	perf_session__fprintf_hists(session, NULL, false, stdout);
+	next = rb_first(&session->stats_by_id);
+	while (next) {
+		struct event_stat_id *stats;
+
+		stats = rb_entry(next, struct event_stat_id, rb_node);
+		perf_session__collapse_resort(&stats->hists);
+		perf_session__output_resort(&stats->hists, stats->stats.total);
+		if (rb_first(&session->stats_by_id) ==
+		    rb_last(&session->stats_by_id))
+			fprintf(stdout, "# Samples: %Ld\n#\n",
+				stats->stats.total);
+		else
+			fprintf(stdout, "# Samples: %Ld %s\n#\n",
+				stats->stats.total,
+				__event_name(stats->type, stats->config));
+
+		perf_session__fprintf_hists(&stats->hists, NULL, false, stdout,
+					    stats->stats.total);
+		fprintf(stdout, "\n\n");
+		next = rb_next(&stats->rb_node);
+	}
+
 	if (sort_order == default_sort_order &&
 	    parent_pattern == default_parent_pattern)
 		fprintf(stdout, "#\n# (For a higher level overview, try: perf report --sort comm,dso)\n#\n");
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e8c85d5..95db31c 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -45,6 +45,7 @@
 #include "util/event.h"
 #include "util/debug.h"
 #include "util/header.h"
+#include "util/cpumap.h"
 
 #include <sys/prctl.h>
 #include <math.h>
@@ -151,7 +152,7 @@ static void create_perf_stat_counter(int counter, int pid)
 		unsigned int cpu;
 
 		for (cpu = 0; cpu < nr_cpus; cpu++) {
-			fd[cpu][counter] = sys_perf_event_open(attr, -1, cpu, -1, 0);
+			fd[cpu][counter] = sys_perf_event_open(attr, -1, cpumap[cpu], -1, 0);
 			if (fd[cpu][counter] < 0 && verbose)
 				fprintf(stderr, ERR_PERF_OPEN, counter,
 					fd[cpu][counter], strerror(errno));
@@ -519,9 +520,10 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		nr_counters = ARRAY_SIZE(default_attrs);
 	}
 
-	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
-	assert(nr_cpus <= MAX_NR_CPUS);
-	assert((int)nr_cpus >= 0);
+	if (system_wide)
+		nr_cpus = read_cpu_map();
+	else
+		nr_cpus = 1;
 
 	/*
 	 * We dont want to block the signals - that would cause
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 31f2e59..0b719e3 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -28,6 +28,7 @@
 #include <linux/rbtree.h>
 #include "util/parse-options.h"
 #include "util/parse-events.h"
+#include "util/cpumap.h"
 
 #include "util/debug.h"
 
@@ -1123,7 +1124,7 @@ static void start_counter(int i, int counter)
 
 	cpu = profile_cpu;
 	if (target_pid == -1 && profile_cpu == -1)
-		cpu = i;
+		cpu = cpumap[i];
 
 	attr = attrs + counter;
 
@@ -1347,12 +1348,10 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		attrs[counter].sample_period = default_interval;
 	}
 
-	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
-	assert(nr_cpus <= MAX_NR_CPUS);
-	assert(nr_cpus >= 0);
-
 	if (target_pid != -1 || profile_cpu != -1)
 		nr_cpus = 1;
+	else
+		nr_cpus = read_cpu_map();
 
 	get_term_dimensions(&winsize);
 	if (print_entries == 0) {
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
new file mode 100644
index 0000000..4e01490
--- /dev/null
+++ b/tools/perf/util/cpumap.c
@@ -0,0 +1,59 @@
+#include "util.h"
+#include "../perf.h"
+#include "cpumap.h"
+#include <assert.h>
+#include <stdio.h>
+
+int cpumap[MAX_NR_CPUS];
+
+static int default_cpu_map(void)
+{
+	int nr_cpus, i;
+
+	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+	assert(nr_cpus <= MAX_NR_CPUS);
+	assert((int)nr_cpus >= 0);
+
+	for (i = 0; i < nr_cpus; ++i)
+		cpumap[i] = i;
+
+	return nr_cpus;
+}
+
+int read_cpu_map(void)
+{
+	FILE *onlnf;
+	int nr_cpus = 0;
+	int n, cpu, prev;
+	char sep;
+
+	onlnf = fopen("/sys/devices/system/cpu/online", "r");
+	if (!onlnf)
+		return default_cpu_map();
+
+	sep = 0;
+	prev = -1;
+	for (;;) {
+		n = fscanf(onlnf, "%u%c", &cpu, &sep);
+		if (n <= 0)
+			break;
+		if (prev >= 0) {
+			assert(nr_cpus + cpu - prev - 1 < MAX_NR_CPUS);
+			while (++prev < cpu)
+				cpumap[nr_cpus++] = prev;
+		}
+		assert (nr_cpus < MAX_NR_CPUS);
+		cpumap[nr_cpus++] = cpu;
+		if (n == 2 && sep == '-')
+			prev = cpu;
+		else
+			prev = -1;
+		if (n == 1 || sep == '\n')
+			break;
+	}
+	fclose(onlnf);
+	if (nr_cpus > 0)
+		return nr_cpus;
+
+	return default_cpu_map();
+}
diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
new file mode 100644
index 0000000..86c78bb
--- /dev/null
+++ b/tools/perf/util/cpumap.h
@@ -0,0 +1,7 @@
+#ifndef __PERF_CPUMAP_H
+#define __PERF_CPUMAP_H
+
+extern int read_cpu_map(void);
+extern int cpumap[];
+
+#endif /* __PERF_CPUMAP_H */
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 50a7132..a33b949 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -99,6 +99,15 @@ struct events_stats {
 	u64 lost;
 };
 
+struct event_stat_id {
+	struct rb_node		rb_node;
+	struct rb_root		hists;
+	struct events_stats	stats;
+	u64			config;
+	u64			event_stream;
+	u32			type;
+};
+
 void event__print_totals(void);
 
 struct perf_session;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index e8daf5c..bdcfd61 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -12,12 +12,12 @@ struct callchain_param	callchain_param = {
  * histogram, sorted on item, collects counts
  */
 
-struct hist_entry *__perf_session__add_hist_entry(struct perf_session *self,
+struct hist_entry *__perf_session__add_hist_entry(struct rb_root *hists,
 						  struct addr_location *al,
 						  struct symbol *sym_parent,
 						  u64 count, bool *hit)
 {
-	struct rb_node **p = &self->hists.rb_node;
+	struct rb_node **p = &hists->rb_node;
 	struct rb_node *parent = NULL;
 	struct hist_entry *he;
 	struct hist_entry entry = {
@@ -53,7 +53,7 @@ struct hist_entry *__perf_session__add_hist_entry(struct perf_session *self,
 		return NULL;
 	*he = entry;
 	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, &self->hists);
+	rb_insert_color(&he->rb_node, hists);
 	*hit = false;
 	return he;
 }
@@ -130,7 +130,7 @@ static void collapse__insert_entry(struct rb_root *root, struct hist_entry *he)
 	rb_insert_color(&he->rb_node, root);
 }
 
-void perf_session__collapse_resort(struct perf_session *self)
+void perf_session__collapse_resort(struct rb_root *hists)
 {
 	struct rb_root tmp;
 	struct rb_node *next;
@@ -140,17 +140,17 @@ void perf_session__collapse_resort(struct perf_session *self)
 		return;
 
 	tmp = RB_ROOT;
-	next = rb_first(&self->hists);
+	next = rb_first(hists);
 
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
 		next = rb_next(&n->rb_node);
 
-		rb_erase(&n->rb_node, &self->hists);
+		rb_erase(&n->rb_node, hists);
 		collapse__insert_entry(&tmp, n);
 	}
 
-	self->hists = tmp;
+	*hists = tmp;
 }
 
 /*
@@ -183,7 +183,7 @@ static void perf_session__insert_output_hist_entry(struct rb_root *root,
 	rb_insert_color(&he->rb_node, root);
 }
 
-void perf_session__output_resort(struct perf_session *self, u64 total_samples)
+void perf_session__output_resort(struct rb_root *hists, u64 total_samples)
 {
 	struct rb_root tmp;
 	struct rb_node *next;
@@ -194,18 +194,18 @@ void perf_session__output_resort(struct perf_session *self, u64 total_samples)
 		total_samples * (callchain_param.min_percent / 100);
 
 	tmp = RB_ROOT;
-	next = rb_first(&self->hists);
+	next = rb_first(hists);
 
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
 		next = rb_next(&n->rb_node);
 
-		rb_erase(&n->rb_node, &self->hists);
+		rb_erase(&n->rb_node, hists);
 		perf_session__insert_output_hist_entry(&tmp, n,
 						       min_callchain_hits);
 	}
 
-	self->hists = tmp;
+	*hists = tmp;
 }
 
 static size_t callchain__fprintf_left_margin(FILE *fp, int left_margin)
@@ -456,10 +456,10 @@ static size_t hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
 }
 
 static size_t hist_entry__fprintf(struct hist_entry *self,
-				  struct perf_session *session,
 				  struct perf_session *pair_session,
 				  bool show_displacement,
-				  long displacement, FILE *fp)
+				  long displacement, FILE *fp,
+				  u64 session_total)
 {
 	struct sort_entry *se;
 	u64 count, total;
@@ -474,7 +474,7 @@ static size_t hist_entry__fprintf(struct hist_entry *self,
 		total = pair_session->events_stats.total;
 	} else {
 		count = self->count;
-		total = session->events_stats.total;
+		total = session_total;
 	}
 
 	if (total)
@@ -496,8 +496,8 @@ static size_t hist_entry__fprintf(struct hist_entry *self,
 
 		if (total > 0)
 			old_percent = (count * 100.0) / total;
-		if (session->events_stats.total > 0)
-			new_percent = (self->count * 100.0) / session->events_stats.total;
+		if (session_total > 0)
+			new_percent = (self->count * 100.0) / session_total;
 
 		diff = new_percent - old_percent;
 
@@ -544,16 +544,17 @@ static size_t hist_entry__fprintf(struct hist_entry *self,
 			left_margin -= thread__comm_len(self->thread);
 		}
 
-		hist_entry_callchain__fprintf(fp, self, session->events_stats.total,
+		hist_entry_callchain__fprintf(fp, self, session_total,
 					      left_margin);
 	}
 
 	return ret;
 }
 
-size_t perf_session__fprintf_hists(struct perf_session *self,
+size_t perf_session__fprintf_hists(struct rb_root *hists,
 				   struct perf_session *pair,
-				   bool show_displacement, FILE *fp)
+				   bool show_displacement, FILE *fp,
+				   u64 session_total)
 {
 	struct sort_entry *se;
 	struct rb_node *nd;
@@ -641,7 +642,7 @@ size_t perf_session__fprintf_hists(struct perf_session *self,
 	fprintf(fp, "\n#\n");
 
 print_entries:
-	for (nd = rb_first(&self->hists); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(hists); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
 		if (show_displacement) {
@@ -652,8 +653,13 @@ print_entries:
 				displacement = 0;
 			++position;
 		}
-		ret += hist_entry__fprintf(h, self, pair, show_displacement,
-					   displacement, fp);
+		ret += hist_entry__fprintf(h, pair, show_displacement,
+					   displacement, fp, session_total);
+		if (h->map == NULL && verbose > 1) {
+			__map_groups__fprintf_maps(&h->thread->mg,
+						   MAP__FUNCTION, fp);
+			fprintf(fp, "%.10s end\n", graph_dotted_line);
+		}
 	}
 
 	free(rem_sq_bracket);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index e5f99b2..16f360c 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -10,8 +10,9 @@ struct perf_session;
 struct hist_entry;
 struct addr_location;
 struct symbol;
+struct rb_root;
 
-struct hist_entry *__perf_session__add_hist_entry(struct perf_session *self,
+struct hist_entry *__perf_session__add_hist_entry(struct rb_root *hists,
 						  struct addr_location *al,
 						  struct symbol *parent,
 						  u64 count, bool *hit);
@@ -19,9 +20,10 @@ extern int64_t hist_entry__cmp(struct hist_entry *, struct hist_entry *);
 extern int64_t hist_entry__collapse(struct hist_entry *, struct hist_entry *);
 void hist_entry__free(struct hist_entry *);
 
-void perf_session__output_resort(struct perf_session *self, u64 total_samples);
-void perf_session__collapse_resort(struct perf_session *self);
-size_t perf_session__fprintf_hists(struct perf_session *self,
+void perf_session__output_resort(struct rb_root *hists, u64 total_samples);
+void perf_session__collapse_resort(struct rb_root *hists);
+size_t perf_session__fprintf_hists(struct rb_root *hists,
 				   struct perf_session *pair,
-				   bool show_displacement, FILE *fp);
+				   bool show_displacement, FILE *fp,
+				   u64 session_total);
 #endif	/* __PERF_HIST_H */
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index e77dc88..1e6c65e 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -169,7 +169,7 @@ static const char *cu_find_realpath(Dwarf_Die *cu_die, const char *fname)
 {
 	Dwarf_Files *files;
 	size_t nfiles, i;
-	const char *src;
+	const char *src = NULL;
 	int ret;
 
 	if (!fname)
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 0de7258..eed1cb8 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -70,6 +70,7 @@ struct perf_session *perf_session__new(const char *filename, int mode, bool forc
 
 	memcpy(self->filename, filename, len);
 	self->threads = RB_ROOT;
+	self->stats_by_id = RB_ROOT;
 	self->last_match = NULL;
 	self->mmap_window = 32;
 	self->cwd = NULL;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 31950fc..5c33417 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -20,6 +20,7 @@ struct perf_session {
 	struct thread		*last_match;
 	struct map		*vmlinux_maps[MAP__NR_TYPES];
 	struct events_stats	events_stats;
+	struct rb_root		stats_by_id;
 	unsigned long		event_total[PERF_RECORD_MAX];
 	unsigned long		unknown_events;
 	struct rb_root		hists;
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 21b9216..fa96831 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -79,8 +79,8 @@ int thread__comm_len(struct thread *self)
 	return self->comm_len;
 }
 
-static size_t __map_groups__fprintf_maps(struct map_groups *self,
-					 enum map_type type, FILE *fp)
+size_t __map_groups__fprintf_maps(struct map_groups *self,
+				  enum map_type type, FILE *fp)
 {
 	size_t printed = fprintf(fp, "%s:\n", map_type__name[type]);
 	struct rb_node *nd;
@@ -89,7 +89,7 @@ static size_t __map_groups__fprintf_maps(struct map_groups *self,
 		struct map *pos = rb_entry(nd, struct map, rb_node);
 		printed += fprintf(fp, "Map:");
 		printed += map__fprintf(pos, fp);
-		if (verbose > 1) {
+		if (verbose > 2) {
 			printed += dso__fprintf(pos->dso, type, fp);
 			printed += fprintf(fp, "--\n");
 		}
@@ -183,8 +183,8 @@ struct thread *perf_session__findnew(struct perf_session *self, pid_t pid)
 	return th;
 }
 
-static void map_groups__remove_overlappings(struct map_groups *self,
-					    struct map *map)
+static int map_groups__fixup_overlappings(struct map_groups *self,
+					  struct map *map)
 {
 	struct rb_root *root = &self->maps[map->type];
 	struct rb_node *next = rb_first(root);
@@ -209,7 +209,36 @@ static void map_groups__remove_overlappings(struct map_groups *self,
 		 * list.
 		 */
 		list_add_tail(&pos->node, &self->removed_maps[map->type]);
+		/*
+		 * Now check if we need to create new maps for areas not
+		 * overlapped by the new map:
+		 */
+		if (map->start > pos->start) {
+			struct map *before = map__clone(pos);
+
+			if (before == NULL)
+				return -ENOMEM;
+
+			before->end = map->start - 1;
+			map_groups__insert(self, before);
+			if (verbose >= 2)
+				map__fprintf(before, stderr);
+		}
+
+		if (map->end < pos->end) {
+			struct map *after = map__clone(pos);
+
+			if (after == NULL)
+				return -ENOMEM;
+
+			after->start = map->end + 1;
+			map_groups__insert(self, after);
+			if (verbose >= 2)
+				map__fprintf(after, stderr);
+		}
 	}
+
+	return 0;
 }
 
 void maps__insert(struct rb_root *maps, struct map *map)
@@ -254,7 +283,7 @@ struct map *maps__find(struct rb_root *maps, u64 ip)
 
 void thread__insert_map(struct thread *self, struct map *map)
 {
-	map_groups__remove_overlappings(&self->mg, map);
+	map_groups__fixup_overlappings(&self->mg, map);
 	map_groups__insert(&self->mg, map);
 }
 
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 0a28f39..dcf7030 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -10,6 +10,9 @@ struct map_groups {
 	struct list_head	removed_maps[MAP__NR_TYPES];
 };
 
+size_t __map_groups__fprintf_maps(struct map_groups *self,
+				  enum map_type type, FILE *fp);
+
 struct thread {
 	struct rb_node		rb_node;
 	struct map_groups	mg;
