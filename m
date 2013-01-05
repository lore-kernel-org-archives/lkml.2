Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab3AEBtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 20:49:25 -0500
Received: from mail.windriver.com ([147.11.1.11]:51156 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab3AEBtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 20:49:21 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-pm@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 1/1] tracing: remove deprecated power trace API
Date: Fri,  4 Jan 2013 20:49:04 -0500
Message-Id: <1357350544-32704-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357350544-32704-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357350544-32704-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The text in Documentation said it would be removed in 2.6.41;
the text in the Kconfig said removal in the 3.1 release.  Either
way you look at it, we are well past both, so push it off a cliff.

Note that the POWER_CSTATE and the POWER_PSTATE are part of the
legacy tracing API.  Remove all tracepoints which use these flags.
As can be seen from context, most already have a trace entry via
trace_cpu_idle anyways.

Also, the cpufreq/cpufreq.c PSTATE one is actually unpaired, as
compared to the CSTATE ones which all have a clear start/stop.
As part of this, the trace_power_frequency also becomes orphaned,
so it too is deleted.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 Documentation/trace/events-power.txt | 27 +----------
 arch/arm/mach-omap2/pm34xx.c         |  2 -
 arch/x86/kernel/process.c            |  6 ---
 drivers/cpufreq/cpufreq.c            |  1 -
 drivers/cpuidle/cpuidle.c            |  2 -
 include/trace/events/power.h         | 92 ------------------------------------
 kernel/trace/Kconfig                 | 15 ------
 kernel/trace/power-traces.c          |  3 --
 8 files changed, 1 insertion(+), 147 deletions(-)

diff --git a/Documentation/trace/events-power.txt b/Documentation/trace/events-power.txt
index cf794af..e1498ff 100644
--- a/Documentation/trace/events-power.txt
+++ b/Documentation/trace/events-power.txt
@@ -17,7 +17,7 @@ Cf. include/trace/events/power.h for the events definitions.
 1. Power state switch events
 ============================
 
-1.1 New trace API
+1.1 Trace API
 -----------------
 
 A 'cpu' event class gathers the CPU-related events: cpuidle and
@@ -41,31 +41,6 @@ The event which has 'state=4294967295' in the trace is very important to the use
 space tools which are using it to detect the end of the current state, and so to
 correctly draw the states diagrams and to calculate accurate statistics etc.
 
-1.2 DEPRECATED trace API
-------------------------
-
-A new Kconfig option CONFIG_EVENT_POWER_TRACING_DEPRECATED with the default value of
-'y' has been created. This allows the legacy trace power API to be used conjointly
-with the new trace API.
-The Kconfig option, the old trace API (in include/trace/events/power.h) and the
-old trace points will disappear in a future release (namely 2.6.41).
-
-power_start		"type=%lu state=%lu cpu_id=%lu"
-power_frequency		"type=%lu state=%lu cpu_id=%lu"
-power_end		"cpu_id=%lu"
-
-The 'type' parameter takes one of those macros:
- . POWER_NONE	= 0,
- . POWER_CSTATE	= 1,	/* C-State */
- . POWER_PSTATE	= 2,	/* Frequency change or DVFS */
-
-The 'state' parameter is set depending on the type:
- . Target C-state for type=POWER_CSTATE,
- . Target frequency for type=POWER_PSTATE,
-
-power_end is used to indicate the exit of a state, corresponding to the latest
-power_start event.
-
 2. Clocks events
 ================
 The clock events are used for clock enable/disable and for
diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index 7be3622..2d93d8b 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -351,12 +351,10 @@ static void omap3_pm_idle(void)
 	if (omap_irq_pending())
 		goto out;
 
-	trace_power_start(POWER_CSTATE, 1, smp_processor_id());
 	trace_cpu_idle(1, smp_processor_id());
 
 	omap_sram_idle();
 
-	trace_power_end(smp_processor_id());
 	trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
 
 out:
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 2ed787f..dcfc1f4 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -375,7 +375,6 @@ void cpu_idle(void)
  */
 void default_idle(void)
 {
-	trace_power_start_rcuidle(POWER_CSTATE, 1, smp_processor_id());
 	trace_cpu_idle_rcuidle(1, smp_processor_id());
 	current_thread_info()->status &= ~TS_POLLING;
 	/*
@@ -389,7 +388,6 @@ void default_idle(void)
 	else
 		local_irq_enable();
 	current_thread_info()->status |= TS_POLLING;
-	trace_power_end_rcuidle(smp_processor_id());
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 }
 #ifdef CONFIG_APM_MODULE
@@ -423,7 +421,6 @@ void stop_this_cpu(void *dummy)
 static void mwait_idle(void)
 {
 	if (!need_resched()) {
-		trace_power_start_rcuidle(POWER_CSTATE, 1, smp_processor_id());
 		trace_cpu_idle_rcuidle(1, smp_processor_id());
 		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
@@ -434,7 +431,6 @@ static void mwait_idle(void)
 			__sti_mwait(0, 0);
 		else
 			local_irq_enable();
-		trace_power_end_rcuidle(smp_processor_id());
 		trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 	} else
 		local_irq_enable();
@@ -447,12 +443,10 @@ static void mwait_idle(void)
  */
 static void poll_idle(void)
 {
-	trace_power_start_rcuidle(POWER_CSTATE, 0, smp_processor_id());
 	trace_cpu_idle_rcuidle(0, smp_processor_id());
 	local_irq_enable();
 	while (!need_resched())
 		cpu_relax();
-	trace_power_end_rcuidle(smp_processor_id());
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 }
 
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 1f93dbd..99faadf 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -294,7 +294,6 @@ void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state)
 		adjust_jiffies(CPUFREQ_POSTCHANGE, freqs);
 		pr_debug("FREQ: %lu - CPU: %lu", (unsigned long)freqs->new,
 			(unsigned long)freqs->cpu);
-		trace_power_frequency(POWER_PSTATE, freqs->new, freqs->cpu);
 		trace_cpu_frequency(freqs->new, freqs->cpu);
 		srcu_notifier_call_chain(&cpufreq_transition_notifier_list,
 				CPUFREQ_POSTCHANGE, freqs);
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 8df53dd..d4713fe 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -153,7 +153,6 @@ int cpuidle_idle_call(void)
 		return 0;
 	}
 
-	trace_power_start_rcuidle(POWER_CSTATE, next_state, dev->cpu);
 	trace_cpu_idle_rcuidle(next_state, dev->cpu);
 
 	if (cpuidle_state_is_coupled(dev, drv, next_state))
@@ -162,7 +161,6 @@ int cpuidle_idle_call(void)
 	else
 		entered_state = cpuidle_enter_state(dev, drv, next_state);
 
-	trace_power_end_rcuidle(dev->cpu);
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
 
 	/* give the governor an opportunity to reflect on the outcome */
diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index 0c97838..427acab 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -99,98 +99,6 @@ DEFINE_EVENT(wakeup_source, wakeup_source_deactivate,
 	TP_ARGS(name, state)
 );
 
-#ifdef CONFIG_EVENT_POWER_TRACING_DEPRECATED
-
-/*
- * The power events are used for cpuidle & suspend (power_start, power_end)
- *  and for cpufreq (power_frequency)
- */
-DECLARE_EVENT_CLASS(power,
-
-	TP_PROTO(unsigned int type, unsigned int state, unsigned int cpu_id),
-
-	TP_ARGS(type, state, cpu_id),
-
-	TP_STRUCT__entry(
-		__field(	u64,		type		)
-		__field(	u64,		state		)
-		__field(	u64,		cpu_id		)
-	),
-
-	TP_fast_assign(
-		__entry->type = type;
-		__entry->state = state;
-		__entry->cpu_id = cpu_id;
-	),
-
-	TP_printk("type=%lu state=%lu cpu_id=%lu", (unsigned long)__entry->type,
-		(unsigned long)__entry->state, (unsigned long)__entry->cpu_id)
-);
-
-DEFINE_EVENT(power, power_start,
-
-	TP_PROTO(unsigned int type, unsigned int state, unsigned int cpu_id),
-
-	TP_ARGS(type, state, cpu_id)
-);
-
-DEFINE_EVENT(power, power_frequency,
-
-	TP_PROTO(unsigned int type, unsigned int state, unsigned int cpu_id),
-
-	TP_ARGS(type, state, cpu_id)
-);
-
-TRACE_EVENT(power_end,
-
-	TP_PROTO(unsigned int cpu_id),
-
-	TP_ARGS(cpu_id),
-
-	TP_STRUCT__entry(
-		__field(	u64,		cpu_id		)
-	),
-
-	TP_fast_assign(
-		__entry->cpu_id = cpu_id;
-	),
-
-	TP_printk("cpu_id=%lu", (unsigned long)__entry->cpu_id)
-
-);
-
-/* Deprecated dummy functions must be protected against multi-declartion */
-#ifndef _PWR_EVENT_AVOID_DOUBLE_DEFINING_DEPRECATED
-#define _PWR_EVENT_AVOID_DOUBLE_DEFINING_DEPRECATED
-
-enum {
-	POWER_NONE = 0,
-	POWER_CSTATE = 1,
-	POWER_PSTATE = 2,
-};
-#endif /* _PWR_EVENT_AVOID_DOUBLE_DEFINING_DEPRECATED */
-
-#else /* CONFIG_EVENT_POWER_TRACING_DEPRECATED */
-
-#ifndef _PWR_EVENT_AVOID_DOUBLE_DEFINING_DEPRECATED
-#define _PWR_EVENT_AVOID_DOUBLE_DEFINING_DEPRECATED
-enum {
-       POWER_NONE = 0,
-       POWER_CSTATE = 1,
-       POWER_PSTATE = 2,
-};
-
-/* These dummy declaration have to be ripped out when the deprecated
-   events get removed */
-static inline void trace_power_start(u64 type, u64 state, u64 cpuid) {};
-static inline void trace_power_end(u64 cpuid) {};
-static inline void trace_power_start_rcuidle(u64 type, u64 state, u64 cpuid) {};
-static inline void trace_power_end_rcuidle(u64 cpuid) {};
-static inline void trace_power_frequency(u64 type, u64 state, u64 cpuid) {};
-#endif /* _PWR_EVENT_AVOID_DOUBLE_DEFINING_DEPRECATED */
-
-#endif /* CONFIG_EVENT_POWER_TRACING_DEPRECATED */
-
 /*
  * The clock events are used for clock enable/disable and for
  *  clock rate change
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 5d89335..ad0a067 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -78,21 +78,6 @@ config EVENT_TRACING
 	select CONTEXT_SWITCH_TRACER
 	bool
 
-config EVENT_POWER_TRACING_DEPRECATED
-	depends on EVENT_TRACING
-	bool "Deprecated power event trace API, to be removed"
-	default y
-	help
-	  Provides old power event types:
-	  C-state/idle accounting events:
-	  power:power_start
-	  power:power_end
-	  and old cpufreq accounting event:
-	  power:power_frequency
-	  This is for userspace compatibility
-	  and will vanish after 5 kernel iterations,
-	  namely 3.1.
-
 config CONTEXT_SWITCH_TRACER
 	bool
 
diff --git a/kernel/trace/power-traces.c b/kernel/trace/power-traces.c
index f55fcf6..1c71382 100644
--- a/kernel/trace/power-traces.c
+++ b/kernel/trace/power-traces.c
@@ -13,8 +13,5 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/power.h>
 
-#ifdef EVENT_POWER_TRACING_DEPRECATED
-EXPORT_TRACEPOINT_SYMBOL_GPL(power_start);
-#endif
 EXPORT_TRACEPOINT_SYMBOL_GPL(cpu_idle);
 
-- 
1.8.1

