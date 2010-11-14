Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab0KNNWs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 08:22:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56586 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755464Ab0KNNWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 08:22:47 -0500
From: Thomas Renninger <trenn@suse.de>
To: mingo@elte.hu
Subject: Re: [PATCH 2/3] PERF(kernel): Cleanup power events
Date: Sun, 14 Nov 2010 07:22:39 -0600
User-Agent: KMail/1.9.10
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, arjan@linux.intel.com,
        jean.pihet@newoldbits.com
References: <1289498595-25806-1-git-send-email-trenn@suse.de> <1289498595-25806-3-git-send-email-trenn@suse.de>
In-Reply-To: <1289498595-25806-3-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201011140722.39832.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PERF(kernel): Cleanup power events

Recent changes:
  - Fix pre-processor conditionals which got messed up silently by a recent merge/pull
  - Add a comment to EVENT_POWER_TRACING_DEPRECATED .config option

New power trace events:
power:cpu_idle
power:cpu_frequency
power:machine_suspend


C-state/idle accounting events:
  power:power_start
  power:power_end
are replaced with:
  power:cpu_idle

and
  power:power_frequency
is replaced with:
  power:cpu_frequency

power:machine_suspend
is newly introduced.
Jean Pihet has a patch integrated into the generic layer
(kernel/power/suspend.c) which will make use of it.

the type= field got removed from both, it was never
used and the type is differed by the event type itself.

perf timechart
userspace tool gets adjusted in a separate patch.

Signed-off-by: Thomas Renninger <trenn@suse.de>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Jean Pihet <jean.pihet@newoldbits.com>
CC: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: rjw@sisk.pl
CC: linux-kernel@vger.kernel.org

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 57d1868..155d975 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -374,6 +374,7 @@ void default_idle(void)
 {
 	if (hlt_use_halt()) {
 		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
+		trace_cpu_idle(1, smp_processor_id());
 		current_thread_info()->status &= ~TS_POLLING;
 		/*
 		 * TS_POLLING-cleared state must be visible before we
@@ -444,6 +445,7 @@ EXPORT_SYMBOL_GPL(cpu_idle_wait);
 void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 {
 	trace_power_start(POWER_CSTATE, (ax>>4)+1, smp_processor_id());
+	trace_cpu_idle((ax>>4)+1, smp_processor_id());
 	if (!need_resched()) {
 		if (cpu_has(&current_cpu_data, X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
@@ -460,6 +462,7 @@ static void mwait_idle(void)
 {
 	if (!need_resched()) {
 		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
+		trace_cpu_idle(1, smp_processor_id());
 		if (cpu_has(&current_cpu_data, X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
 
@@ -481,10 +484,12 @@ static void mwait_idle(void)
 static void poll_idle(void)
 {
 	trace_power_start(POWER_CSTATE, 0, smp_processor_id());
+	trace_cpu_idle(0, smp_processor_id());
 	local_irq_enable();
 	while (!need_resched())
 		cpu_relax();
-	trace_power_end(0);
+	trace_power_end(smp_processor_id());
+	trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
 }
 
 /*
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 96586c3..4b9befa 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -113,8 +113,8 @@ void cpu_idle(void)
 			stop_critical_timings();
 			pm_idle();
 			start_critical_timings();
-
 			trace_power_end(smp_processor_id());
+			trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
 		}
 		tick_nohz_restart_sched_tick();
 		preempt_enable_no_resched();
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b3d7a3a..4c818a7 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -142,6 +142,8 @@ void cpu_idle(void)
 			start_critical_timings();
 
 			trace_power_end(smp_processor_id());
+			trace_cpu_idle(PWR_EVENT_EXIT,
+				       smp_processor_id());
 
 			/* In many cases the interrupt that ended idle
 			   has already called exit_idle. But some idle
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index c63a438..1109f68 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -355,6 +355,7 @@ void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state)
 		dprintk("FREQ: %lu - CPU: %lu", (unsigned long)freqs->new,
 			(unsigned long)freqs->cpu);
 		trace_power_frequency(POWER_PSTATE, freqs->new, freqs->cpu);
+		trace_cpu_frequency(freqs->new, freqs->cpu);
 		srcu_notifier_call_chain(&cpufreq_transition_notifier_list,
 				CPUFREQ_POSTCHANGE, freqs);
 		if (likely(policy) && likely(policy->cpu == freqs->cpu))
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index a507108..08d5f05 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -107,6 +107,7 @@ static void cpuidle_idle_call(void)
 	if (cpuidle_curr_governor->reflect)
 		cpuidle_curr_governor->reflect(dev);
 	trace_power_end(smp_processor_id());
+	trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
 }
 
 /**
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 3c95325..ba5134f 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -221,6 +221,7 @@ static int intel_idle(struct cpuidle_device *dev, struct cpuidle_state *state)
 
 	stop_critical_timings();
 	trace_power_start(POWER_CSTATE, (eax >> 4) + 1, cpu);
+	trace_cpu_idle((eax >> 4) + 1, cpu);
 	if (!need_resched()) {
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index 286784d..00d9819 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -7,16 +7,67 @@
 #include <linux/ktime.h>
 #include <linux/tracepoint.h>
 
-#ifndef _TRACE_POWER_ENUM_
-#define _TRACE_POWER_ENUM_
-enum {
-	POWER_NONE	= 0,
-	POWER_CSTATE	= 1,	/* C-State */
-	POWER_PSTATE	= 2,	/* Fequency change or DVFS */
-	POWER_SSTATE	= 3,	/* Suspend */
-};
+DECLARE_EVENT_CLASS(cpu,
+
+	TP_PROTO(unsigned int state, unsigned int cpu_id),
+
+	TP_ARGS(state, cpu_id),
+
+	TP_STRUCT__entry(
+		__field(	u32,		state		)
+		__field(	u32,		cpu_id		)
+	),
+
+	TP_fast_assign(
+		__entry->state = state;
+		__entry->cpu_id = cpu_id;
+	),
+
+	TP_printk("state=%lu cpu_id=%lu", (unsigned long)__entry->state,
+		  (unsigned long)__entry->cpu_id)
+);
+
+DEFINE_EVENT(cpu, cpu_idle,
+
+	TP_PROTO(unsigned int state, unsigned int cpu_id),
+
+	TP_ARGS(state, cpu_id)
+);
+
+/* This file can get included multiple times, TRACE_HEADER_MULTI_READ at top */
+#ifndef _PWR_EVENT_AVOID_DOUBLE_DEFINING
+#define _PWR_EVENT_AVOID_DOUBLE_DEFINING
+
+#define PWR_EVENT_EXIT -1
 #endif
 
+DEFINE_EVENT(cpu, cpu_frequency,
+
+	TP_PROTO(unsigned int frequency, unsigned int cpu_id),
+
+	TP_ARGS(frequency, cpu_id)
+);
+
+TRACE_EVENT(machine_suspend,
+
+	TP_PROTO(unsigned int state),
+
+	TP_ARGS(state),
+
+	TP_STRUCT__entry(
+		__field(	u32,		state		)
+	),
+
+	TP_fast_assign(
+		__entry->state = state;
+	),
+
+	TP_printk("state=%lu", (unsigned long)__entry->state)
+);
+
+/* This code will be removed after deprecation time exceeded (2.6.41) */
+#ifdef CONFIG_EVENT_POWER_TRACING_DEPRECATED
+
 /*
  * The power events are used for cpuidle & suspend (power_start, power_end)
  *  and for cpufreq (power_frequency)
@@ -75,6 +126,24 @@ TRACE_EVENT(power_end,
 
 );
 
+/* Deprecated dummy functions must be protected against multi-declartion */
+#ifndef _PWR_EVENT_AVOID_DOUBLE_DEFINING_DEPRECATED
+#define _PWR_EVENT_AVOID_DOUBLE_DEFINING_DEPRECATED
+
+enum {
+	POWER_NONE = 0,
+	POWER_CSTATE = 1,
+	POWER_PSTATE = 2,
+};
+#endif /* _PWR_EVENT_AVOID_DOUBLE_DEFINING_DEPRECATED */
+#else
+/* These dummy declaration have to be ripped out when the deprecated
+   events get removed */
+static inline void trace_power_start(u64 type, u64 state, u64 cpuid) {};
+static inline void trace_power_end(u64 cpuid) {};
+static inline void trace_power_frequency(u64 type, u64 state, u64 cpuid) {};
+#endif /* CONFIG_EVENT_POWER_TRACING_DEPRECATED */
+
 /*
  * The clock events are used for clock enable/disable and for
  *  clock rate change
@@ -153,7 +222,6 @@ DEFINE_EVENT(power_domain, power_domain_target,
 
 	TP_ARGS(name, state, cpu_id)
 );
-
 #endif /* _TRACE_POWER_H */
 
 /* This part must be outside protection */
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index e04b8bc..59b44a1 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -69,6 +69,21 @@ config EVENT_TRACING
 	select CONTEXT_SWITCH_TRACER
 	bool
 
+config EVENT_POWER_TRACING_DEPRECATED
+	depends on EVENT_TRACING
+	bool "Deprecated power event trace API, to be removed"
+	default y
+	help
+	  Provides old power event types:
+	  C-state/idle accounting events:
+	  power:power_start
+	  power:power_end
+	  and old cpufreq accounting event:
+	  power:power_frequency
+	  This is for userspace compatibility
+	  and will vanish after 5 kernel iterations,
+	  namely 2.6.41.
+
 config CONTEXT_SWITCH_TRACER
 	bool
 
diff --git a/kernel/trace/power-traces.c b/kernel/trace/power-traces.c
index 0e0497d..f55fcf6 100644
--- a/kernel/trace/power-traces.c
+++ b/kernel/trace/power-traces.c
@@ -13,5 +13,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/power.h>
 
+#ifdef EVENT_POWER_TRACING_DEPRECATED
 EXPORT_TRACEPOINT_SYMBOL_GPL(power_start);
+#endif
+EXPORT_TRACEPOINT_SYMBOL_GPL(cpu_idle);
 
