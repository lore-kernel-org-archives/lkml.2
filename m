Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783Ab0IHNAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:00:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46905 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536Ab0IHNAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:00:36 -0400
Date: Wed, 8 Sep 2010 15:00:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf events fixes
Message-ID: <20100908130003.GA5951@elte.hu>
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
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Don Zickus (2):
      lockup_detector: Sync touch_*_watchdog back to old semantics
      perf, x86: Fix accidentally ack'ing a second event on intel perf counter

Frederic Weisbecker (1):
      perf: Initialize callchains roots's childen hits

Li Zefan (1):
      tracing: Fix a race in function profile

Peter Zijlstra (1):
      perf, x86: Fix handle_irq return values

Robert Richter (4):
      oprofile: fix crash when accessing freed task structs
      oprofile, x86: fix init_sysfs error handling
      oprofile, x86: fix init_sysfs() function stub
      perf, x86: Try to handle unknown nmis with an enabled PMU

Stephane Eranian (1):
      perf_events: Fix time tracking for events with pid != -1 and cpu != -1


 arch/x86/kernel/cpu/perf_event.c       |   59 +++++++++++++++++++++++++-------
 arch/x86/kernel/cpu/perf_event_intel.c |   15 +++++---
 arch/x86/kernel/cpu/perf_event_p4.c    |    2 +-
 arch/x86/oprofile/nmi_int.c            |   22 +++++++++---
 drivers/oprofile/buffer_sync.c         |   27 +++++++-------
 drivers/oprofile/cpu_buffer.c          |    2 -
 kernel/perf_event.c                    |   26 ++++++++++++--
 kernel/trace/ftrace.c                  |   15 ++++++--
 kernel/watchdog.c                      |   17 ++++++---
 tools/perf/util/callchain.h            |    1 +
 10 files changed, 133 insertions(+), 53 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index f2da20f..3efdf28 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1154,7 +1154,7 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 		/*
 		 * event overflow
 		 */
-		handled		= 1;
+		handled++;
 		data.period	= event->hw.last_period;
 
 		if (!x86_perf_event_set_period(event))
@@ -1200,12 +1200,20 @@ void perf_events_lapic_init(void)
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 }
 
+struct pmu_nmi_state {
+	unsigned int	marked;
+	int		handled;
+};
+
+static DEFINE_PER_CPU(struct pmu_nmi_state, pmu_nmi);
+
 static int __kprobes
 perf_event_nmi_handler(struct notifier_block *self,
 			 unsigned long cmd, void *__args)
 {
 	struct die_args *args = __args;
-	struct pt_regs *regs;
+	unsigned int this_nmi;
+	int handled;
 
 	if (!atomic_read(&active_events))
 		return NOTIFY_DONE;
@@ -1214,22 +1222,47 @@ perf_event_nmi_handler(struct notifier_block *self,
 	case DIE_NMI:
 	case DIE_NMI_IPI:
 		break;
-
+	case DIE_NMIUNKNOWN:
+		this_nmi = percpu_read(irq_stat.__nmi_count);
+		if (this_nmi != __get_cpu_var(pmu_nmi).marked)
+			/* let the kernel handle the unknown nmi */
+			return NOTIFY_DONE;
+		/*
+		 * This one is a PMU back-to-back nmi. Two events
+		 * trigger 'simultaneously' raising two back-to-back
+		 * NMIs. If the first NMI handles both, the latter
+		 * will be empty and daze the CPU. So, we drop it to
+		 * avoid false-positive 'unknown nmi' messages.
+		 */
+		return NOTIFY_STOP;
 	default:
 		return NOTIFY_DONE;
 	}
 
-	regs = args->regs;
-
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	/*
-	 * Can't rely on the handled return value to say it was our NMI, two
-	 * events could trigger 'simultaneously' raising two back-to-back NMIs.
-	 *
-	 * If the first NMI handles both, the latter will be empty and daze
-	 * the CPU.
-	 */
-	x86_pmu.handle_irq(regs);
+
+	handled = x86_pmu.handle_irq(args->regs);
+	if (!handled)
+		return NOTIFY_DONE;
+
+	this_nmi = percpu_read(irq_stat.__nmi_count);
+	if ((handled > 1) ||
+		/* the next nmi could be a back-to-back nmi */
+	    ((__get_cpu_var(pmu_nmi).marked == this_nmi) &&
+	     (__get_cpu_var(pmu_nmi).handled > 1))) {
+		/*
+		 * We could have two subsequent back-to-back nmis: The
+		 * first handles more than one counter, the 2nd
+		 * handles only one counter and the 3rd handles no
+		 * counter.
+		 *
+		 * This is the 2nd nmi because the previous was
+		 * handling more than one counter. We will mark the
+		 * next (3rd) and then drop it if unhandled.
+		 */
+		__get_cpu_var(pmu_nmi).marked	= this_nmi + 1;
+		__get_cpu_var(pmu_nmi).handled	= handled;
+	}
 
 	return NOTIFY_STOP;
 }
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index d8d86d0..ee05c90 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -712,7 +712,8 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	struct perf_sample_data data;
 	struct cpu_hw_events *cpuc;
 	int bit, loops;
-	u64 ack, status;
+	u64 status;
+	int handled = 0;
 
 	perf_sample_data_init(&data, 0);
 
@@ -728,6 +729,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 
 	loops = 0;
 again:
+	intel_pmu_ack_status(status);
 	if (++loops > 100) {
 		WARN_ONCE(1, "perfevents: irq loop stuck!\n");
 		perf_event_print_debug();
@@ -736,19 +738,22 @@ again:
 	}
 
 	inc_irq_stat(apic_perf_irqs);
-	ack = status;
 
 	intel_pmu_lbr_read();
 
 	/*
 	 * PEBS overflow sets bit 62 in the global status register
 	 */
-	if (__test_and_clear_bit(62, (unsigned long *)&status))
+	if (__test_and_clear_bit(62, (unsigned long *)&status)) {
+		handled++;
 		x86_pmu.drain_pebs(regs);
+	}
 
 	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
 		struct perf_event *event = cpuc->events[bit];
 
+		handled++;
+
 		if (!test_bit(bit, cpuc->active_mask))
 			continue;
 
@@ -761,8 +766,6 @@ again:
 			x86_pmu_stop(event);
 	}
 
-	intel_pmu_ack_status(ack);
-
 	/*
 	 * Repeat if there is more work to be done:
 	 */
@@ -772,7 +775,7 @@ again:
 
 done:
 	intel_pmu_enable_all(0);
-	return 1;
+	return handled;
 }
 
 static struct event_constraint *
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 7e578e9..b560db3 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -692,7 +692,7 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 		inc_irq_stat(apic_perf_irqs);
 	}
 
-	return handled > 0;
+	return handled;
 }
 
 /*
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index f6b48f6..cfe4faa 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -568,8 +568,13 @@ static int __init init_sysfs(void)
 	int error;
 
 	error = sysdev_class_register(&oprofile_sysclass);
-	if (!error)
-		error = sysdev_register(&device_oprofile);
+	if (error)
+		return error;
+
+	error = sysdev_register(&device_oprofile);
+	if (error)
+		sysdev_class_unregister(&oprofile_sysclass);
+
 	return error;
 }
 
@@ -580,8 +585,10 @@ static void exit_sysfs(void)
 }
 
 #else
-#define init_sysfs() do { } while (0)
-#define exit_sysfs() do { } while (0)
+
+static inline int  init_sysfs(void) { return 0; }
+static inline void exit_sysfs(void) { }
+
 #endif /* CONFIG_PM */
 
 static int __init p4_init(char **cpu_type)
@@ -695,6 +702,8 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 	char *cpu_type = NULL;
 	int ret = 0;
 
+	using_nmi = 0;
+
 	if (!cpu_has_apic)
 		return -ENODEV;
 
@@ -774,7 +783,10 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 
 	mux_init(ops);
 
-	init_sysfs();
+	ret = init_sysfs();
+	if (ret)
+		return ret;
+
 	using_nmi = 1;
 	printk(KERN_INFO "oprofile: using NMI interrupt.\n");
 	return 0;
diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index a9352b2..b7e755f 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -141,16 +141,6 @@ static struct notifier_block module_load_nb = {
 	.notifier_call = module_load_notify,
 };
 
-
-static void end_sync(void)
-{
-	end_cpu_work();
-	/* make sure we don't leak task structs */
-	process_task_mortuary();
-	process_task_mortuary();
-}
-
-
 int sync_start(void)
 {
 	int err;
@@ -158,7 +148,7 @@ int sync_start(void)
 	if (!zalloc_cpumask_var(&marked_cpus, GFP_KERNEL))
 		return -ENOMEM;
 
-	start_cpu_work();
+	mutex_lock(&buffer_mutex);
 
 	err = task_handoff_register(&task_free_nb);
 	if (err)
@@ -173,7 +163,10 @@ int sync_start(void)
 	if (err)
 		goto out4;
 
+	start_cpu_work();
+
 out:
+	mutex_unlock(&buffer_mutex);
 	return err;
 out4:
 	profile_event_unregister(PROFILE_MUNMAP, &munmap_nb);
@@ -182,7 +175,6 @@ out3:
 out2:
 	task_handoff_unregister(&task_free_nb);
 out1:
-	end_sync();
 	free_cpumask_var(marked_cpus);
 	goto out;
 }
@@ -190,11 +182,20 @@ out1:
 
 void sync_stop(void)
 {
+	/* flush buffers */
+	mutex_lock(&buffer_mutex);
+	end_cpu_work();
 	unregister_module_notifier(&module_load_nb);
 	profile_event_unregister(PROFILE_MUNMAP, &munmap_nb);
 	profile_event_unregister(PROFILE_TASK_EXIT, &task_exit_nb);
 	task_handoff_unregister(&task_free_nb);
-	end_sync();
+	mutex_unlock(&buffer_mutex);
+	flush_scheduled_work();
+
+	/* make sure we don't leak task structs */
+	process_task_mortuary();
+	process_task_mortuary();
+
 	free_cpumask_var(marked_cpus);
 }
 
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 219f79e..f179ac2 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -120,8 +120,6 @@ void end_cpu_work(void)
 
 		cancel_delayed_work(&b->work);
 	}
-
-	flush_scheduled_work();
 }
 
 /*
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 403d180..657555a 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -402,11 +402,31 @@ static void perf_group_detach(struct perf_event *event)
 	}
 }
 
+static inline int
+event_filter_match(struct perf_event *event)
+{
+	return event->cpu == -1 || event->cpu == smp_processor_id();
+}
+
 static void
 event_sched_out(struct perf_event *event,
 		  struct perf_cpu_context *cpuctx,
 		  struct perf_event_context *ctx)
 {
+	u64 delta;
+	/*
+	 * An event which could not be activated because of
+	 * filter mismatch still needs to have its timings
+	 * maintained, otherwise bogus information is return
+	 * via read() for time_enabled, time_running:
+	 */
+	if (event->state == PERF_EVENT_STATE_INACTIVE
+	    && !event_filter_match(event)) {
+		delta = ctx->time - event->tstamp_stopped;
+		event->tstamp_running += delta;
+		event->tstamp_stopped = ctx->time;
+	}
+
 	if (event->state != PERF_EVENT_STATE_ACTIVE)
 		return;
 
@@ -432,9 +452,7 @@ group_sched_out(struct perf_event *group_event,
 		struct perf_event_context *ctx)
 {
 	struct perf_event *event;
-
-	if (group_event->state != PERF_EVENT_STATE_ACTIVE)
-		return;
+	int state = group_event->state;
 
 	event_sched_out(group_event, cpuctx, ctx);
 
@@ -444,7 +462,7 @@ group_sched_out(struct perf_event *group_event,
 	list_for_each_entry(event, &group_event->sibling_list, group_entry)
 		event_sched_out(event, cpuctx, ctx);
 
-	if (group_event->attr.exclusive)
+	if (state == PERF_EVENT_STATE_ACTIVE && group_event->attr.exclusive)
 		cpuctx->exclusive = 0;
 }
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0d88ce9..7cb1f45 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -381,12 +381,19 @@ static int function_stat_show(struct seq_file *m, void *v)
 {
 	struct ftrace_profile *rec = v;
 	char str[KSYM_SYMBOL_LEN];
+	int ret = 0;
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	static DEFINE_MUTEX(mutex);
 	static struct trace_seq s;
 	unsigned long long avg;
 	unsigned long long stddev;
 #endif
+	mutex_lock(&ftrace_profile_lock);
+
+	/* we raced with function_profile_reset() */
+	if (unlikely(rec->counter == 0)) {
+		ret = -EBUSY;
+		goto out;
+	}
 
 	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
 	seq_printf(m, "  %-30.30s  %10lu", str, rec->counter);
@@ -408,7 +415,6 @@ static int function_stat_show(struct seq_file *m, void *v)
 		do_div(stddev, (rec->counter - 1) * 1000);
 	}
 
-	mutex_lock(&mutex);
 	trace_seq_init(&s);
 	trace_print_graph_duration(rec->time, &s);
 	trace_seq_puts(&s, "    ");
@@ -416,11 +422,12 @@ static int function_stat_show(struct seq_file *m, void *v)
 	trace_seq_puts(&s, "    ");
 	trace_print_graph_duration(stddev, &s);
 	trace_print_seq(m, &s);
-	mutex_unlock(&mutex);
 #endif
 	seq_putc(m, '\n');
+out:
+	mutex_unlock(&ftrace_profile_lock);
 
-	return 0;
+	return ret;
 }
 
 static void ftrace_profile_reset(struct ftrace_profile_stat *stat)
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 0d53c8e..7f9c3c5 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -122,7 +122,7 @@ static void __touch_watchdog(void)
 
 void touch_softlockup_watchdog(void)
 {
-	__get_cpu_var(watchdog_touch_ts) = 0;
+	__raw_get_cpu_var(watchdog_touch_ts) = 0;
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
@@ -142,7 +142,14 @@ void touch_all_softlockup_watchdogs(void)
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 void touch_nmi_watchdog(void)
 {
-	__get_cpu_var(watchdog_nmi_touch) = true;
+	if (watchdog_enabled) {
+		unsigned cpu;
+
+		for_each_present_cpu(cpu) {
+			if (per_cpu(watchdog_nmi_touch, cpu) != true)
+				per_cpu(watchdog_nmi_touch, cpu) = true;
+		}
+	}
 	touch_softlockup_watchdog();
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
@@ -433,6 +440,9 @@ static int watchdog_enable(int cpu)
 		wake_up_process(p);
 	}
 
+	/* if any cpu succeeds, watchdog is considered enabled for the system */
+	watchdog_enabled = 1;
+
 	return 0;
 }
 
@@ -455,9 +465,6 @@ static void watchdog_disable(int cpu)
 		per_cpu(softlockup_watchdog, cpu) = NULL;
 		kthread_stop(p);
 	}
-
-	/* if any cpu succeeds, watchdog is considered enabled for the system */
-	watchdog_enabled = 1;
 }
 
 static void watchdog_enable_all_cpus(void)
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 624a96c..6de4313 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -50,6 +50,7 @@ static inline void callchain_init(struct callchain_node *node)
 	INIT_LIST_HEAD(&node->children);
 	INIT_LIST_HEAD(&node->val);
 
+	node->children_hit = 0;
 	node->parent = NULL;
 	node->hit = 0;
 }
