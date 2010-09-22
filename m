Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab0IVPbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:31:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63756 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab0IVPbm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:31:42 -0400
MIME-Version: 1.0
X-Originating-IP: [81.241.220.68]
In-Reply-To: <201009180026.59482.trenn@suse.de>
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com>
	<201009171736.14170.trenn@suse.de>
	<20100917162412.GB3341@elte.hu>
	<201009180026.59482.trenn@suse.de>
Date: Wed, 22 Sep 2010 17:31:41 +0200
Message-ID: <AANLkTimMAr9kEzybFGai3qGyXx36v055iPpXq_C1vW8C@mail.gmail.com>
Subject: Re: [PATCH] tracing, perf: add more power related events
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, discuss@lesswatts.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-trace-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a patch that redefines the power events API. The advantages
are: easier maintainance of the kernel and the
user space tools, a cleaner and more generic interface, more
parameters for fine tracing and even documentation!

Thomas, this patch has your patch above merged in ('power-trace: Use
power_switch_state instead of power_start and power_end'). The revised
ACPI patch is coming asap.

The trace points for x86 and OMAP are also udated accordingly.

The pytimechart tool needs an update for the new API. This can be done
as soon as the kernel code gets merged in.
Please note the point below about the existing code in builtin-timechart.c.

On Sat, Sep 18, 2010 at 12:26 AM, Thomas Renninger <trenn@suse.de> wrote:
> On Friday 17 September 2010 18:24:12 Ingo Molnar wrote:
>>
>> * Thomas Renninger <trenn@suse.de> wrote:
>>
>> > On Friday 17 September 2010 16:24:59 Ingo Molnar wrote:
>
>> [ You dont even have to document it, as good code is self-explanatory ;-) ]
> I recently posted a patch exporting some things through /sys/kernel/debug/...
> Greg complained that a file for Documentation/ABI/{testing,stable}/* is missing
> and I fully agree.
The proposed patch has the documentation in
Documentation/trace/events-power.txt.

> If different userspace apps should make use of this (in above case nobody
> than my debug userspace tool will...) and this should be called something like an API,
> it should be documented and if something changes, it should
> first be marked deprecated, etc.
Note: the exsiting code in tools/perf/builtin-timechart.c needs an
update for the new events API. Is this code still maintained? I not,
could pytimechart be merged in instead?

Feedback is welcome!

>
>     Thomas
>

Thanks,
Jean

---
>From f37d1875050d33273b10e99497b4059b37e6680d Mon Sep 17 00:00:00 2001
From: Jean Pihet <jean.pihet@newoldbits.com>
Date: Wed, 22 Sep 2010 17:10:47 +0200
Subject: [PATCH] tools, perf: redefine the power events API

Redefine the API with:
- power_switch_state for C-, P- and S-states,
- clock and power_domain events

The new API allows easier maintainance of the kernel and the
user space tools, a cleaner and more generic interface,
more parameters for fine tracing and even documentation.

The new events are used by the x86 and OMAP platforms.

Signed-off-by: Jean Pihet <j-pihet@ti.com>
---
 Documentation/trace/events-power.txt |   70 +++++++++++++++++++++++++
 arch/arm/mach-omap2/cpuidle34xx.c    |    3 +
 arch/arm/mach-omap2/pm34xx.c         |   11 ++++
 arch/arm/mach-omap2/powerdomain.c    |    3 +
 arch/arm/plat-omap/clock.c           |   13 ++++-
 arch/arm/plat-omap/cpu-omap.c        |    3 +
 arch/x86/kernel/process.c            |   13 +++--
 arch/x86/kernel/process_32.c         |    3 +-
 arch/x86/kernel/process_64.c         |    3 +-
 drivers/cpufreq/cpufreq.c            |    3 +-
 drivers/cpuidle/cpuidle.c            |    2 +-
 drivers/idle/intel_idle.c            |    2 +-
 include/trace/events/power.h         |   95 ++++++++++++++++------------------
 kernel/trace/power-traces.c          |    2 -
 14 files changed, 161 insertions(+), 65 deletions(-)
 create mode 100644 Documentation/trace/events-power.txt

diff --git a/Documentation/trace/events-power.txt
b/Documentation/trace/events-power.txt
new file mode 100644
index 0000000..967f842
--- /dev/null
+++ b/Documentation/trace/events-power.txt
@@ -0,0 +1,70 @@
+
+			Subsystem Trace Points: power
+
+The power tracing system captures events related to power transitions
+within the kernel. Broadly speaking there are three major subheadings:
+
+  o Power state switch which reports events related to suspend (S-states),
+     cpuidle (C-states) and cpufreq (P-states)
+  o System clock related changes
+  o Power domains related changes and transitions
+
+This document describes what each of the tracepoints is and why they
+might be useful.
+
+Cf. include/trace/events/power.h for the events definitions.
+
+1. Power state switch events
+============================
+
+power_switch_state	type=%lu state=%lu sub_state=%lu cpu_id=%lu
+
+The 'type' parameter takes one of those macros:
+ . POWER_NONE	= 0,
+ . POWER_CSTATE	= 1,	/* C-State */
+ . POWER_PSTATE	= 2,	/* Fequency change or DVFS */
+ . POWER_SSTATE	= 3,	/* Suspend */
+
+The 'state' parameter is set depending on the type:
+ . Target C-state for type=POWER_CSTATE,
+ . Target frequency for type=POWER_PSTATE,
+ . Target suspend state for type=POWER_SSTATE
+
+Note: the value of '0' for state means an exit from the current state,
+i.e. power_switch_state(POWER_SSTATE, 1, 0, cpu) means 'the system enters
+the suspend state' while power_switch_state(POWER_SSTATE, 0, 0, cpu) means
+'the system exits the suspend state).
+
+The event which has 'state=0' is very important to the user space tools
+which are using it to detect the end of the current state, and so to correctly
+draw the states diagrams and to calculate accurate statistics etc.
+
+The 'sub_state' parameter is optional and is used as a sub state in the low
+power mode enter or exit, a return code or the real state the system
went into etc.
+
+2. Clocks events
+================
+The clock events are used for clock enable/disable and for
+clock rate change.
+
+clock_enable	%s state=%lu sub_state=%lu cpu_id=%lu
+clock_disable	%s state=%lu sub_state=%lu cpu_id=%lu
+clock_set_rate	%s state=%lu sub_state=%lu cpu_id=%lu
+
+The first parameter gives the clock name (e.g. "gpio1_iclk").
+The second parameter is '1' for enable, '0' for disable, the target
+clock rate for set_rate.
+The 'sub_state' parameter is optional and is used as a sub state in the low
+power mode enter or exit, a return code, the real state the system
went into etc.
+
+3. Power domains events
+=======================
+The power domain events are used for power domains transitions
+
+power_domain_target	"%s state=%lu sub_state=%lu cpu_id=%lu"
+
+The first parameter gives the power domain name (e.g. "mpu_pwrdm").
+The second parameter is the power domain target state.
+The 'sub_state' parameter is optional and is used as a sub state in the low
+power mode enter or exit, a return code, the real state the system
went into etc.
+
diff --git a/arch/arm/mach-omap2/cpuidle34xx.c
b/arch/arm/mach-omap2/cpuidle34xx.c
index 3d3d035..8fa317c 100644
--- a/arch/arm/mach-omap2/cpuidle34xx.c
+++ b/arch/arm/mach-omap2/cpuidle34xx.c
@@ -24,6 +24,7 @@

 #include <linux/sched.h>
 #include <linux/cpuidle.h>
+#include <trace/events/power.h>

 #include <plat/prcm.h>
 #include <plat/irqs.h>
@@ -122,6 +123,8 @@ static int omap3_enter_idle(struct cpuidle_device *dev,
 	struct timespec ts_preidle, ts_postidle, ts_idle;
 	u32 mpu_state = cx->mpu_state, core_state = cx->core_state;

+	trace_power_switch_state(POWER_CSTATE, cx->type, 0, smp_processor_id());
+
 	current_cx_state = *cx;

 	/* Used to keep track of the total time in idle */
diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index 7b03426..8b774b1 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -28,6 +28,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <trace/events/power.h>

 #include <plat/sram.h>
 #include <plat/clockdomain.h>
@@ -557,6 +558,8 @@ static void omap3_pm_idle(void)
 	if (omap_irq_pending() || need_resched())
 		goto out;

+	trace_power_switch_state(POWER_CSTATE, 1, 0, smp_processor_id());
+
 	omap_sram_idle();

 out:
@@ -595,6 +598,8 @@ static int omap3_pm_suspend(void)
 	struct power_state *pwrst;
 	int state, ret = 0;

+	trace_power_switch_state(POWER_SSTATE, 1, 0, smp_processor_id());
+
 	if (wakeup_timer_seconds || wakeup_timer_milliseconds)
 		omap2_pm_wakeup_on_timer(wakeup_timer_seconds,
 					 wakeup_timer_milliseconds);
@@ -623,6 +628,10 @@ restore:
 			printk(KERN_INFO "Powerdomain (%s) didn't enter "
 			       "target state %d\n",
 			       pwrst->pwrdm->name, pwrst->next_state);
+			trace_power_domain_target(pwrst->pwrdm->name,
+						  pwrst->next_state,
+						  state,
+						  smp_processor_id());
 			ret = -1;
 		}
 		set_pwrdm_state(pwrst->pwrdm, pwrst->saved_state);
@@ -633,6 +642,8 @@ restore:
 		printk(KERN_INFO "Successfully put all powerdomains "
 		       "to target state\n");

+	trace_power_switch_state(POWER_SSTATE, 0, 0, smp_processor_id());
+
 	return ret;
 }

diff --git a/arch/arm/mach-omap2/powerdomain.c
b/arch/arm/mach-omap2/powerdomain.c
index 6527ec3..03d286e 100644
--- a/arch/arm/mach-omap2/powerdomain.c
+++ b/arch/arm/mach-omap2/powerdomain.c
@@ -23,6 +23,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/io.h>
+#include <trace/events/power.h>

 #include <asm/atomic.h>

@@ -440,6 +441,8 @@ int pwrdm_set_next_pwrst(struct powerdomain
*pwrdm, u8 pwrst)
 	pr_debug("powerdomain: setting next powerstate for %s to %0x\n",
 		 pwrdm->name, pwrst);

+	trace_power_domain_target(pwrdm->name, pwrst, 0, smp_processor_id());
+
 	prm_rmw_mod_reg_bits(OMAP_POWERSTATE_MASK,
 			     (pwrst << OMAP_POWERSTATE_SHIFT),
 			     pwrdm->prcm_offs, pwrstctrl_reg_offs);
diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
index 7190cbd..d42739d 100644
--- a/arch/arm/plat-omap/clock.c
+++ b/arch/arm/plat-omap/clock.c
@@ -21,6 +21,7 @@
 #include <linux/cpufreq.h>
 #include <linux/debugfs.h>
 #include <linux/io.h>
+#include <trace/events/power.h>

 #include <plat/clock.h>

@@ -43,8 +44,10 @@ int clk_enable(struct clk *clk)
 		return -EINVAL;

 	spin_lock_irqsave(&clockfw_lock, flags);
-	if (arch_clock->clk_enable)
+	if (arch_clock->clk_enable) {
+		trace_clock_enable(clk->name, 1, 0, smp_processor_id());
 		ret = arch_clock->clk_enable(clk);
+	}
 	spin_unlock_irqrestore(&clockfw_lock, flags);

 	return ret;
@@ -66,8 +69,10 @@ void clk_disable(struct clk *clk)
 		goto out;
 	}

-	if (arch_clock->clk_disable)
+	if (arch_clock->clk_disable) {
+		trace_clock_disable(clk->name, 0, 0, smp_processor_id());
 		arch_clock->clk_disable(clk);
+	}

 out:
 	spin_unlock_irqrestore(&clockfw_lock, flags);
@@ -120,8 +125,10 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 		return ret;

 	spin_lock_irqsave(&clockfw_lock, flags);
-	if (arch_clock->clk_set_rate)
+	if (arch_clock->clk_set_rate) {
+		trace_clock_set_rate(clk->name, rate, 0, smp_processor_id());
 		ret = arch_clock->clk_set_rate(clk, rate);
+	}
 	if (ret == 0) {
 		if (clk->recalc)
 			clk->rate = clk->recalc(clk);
diff --git a/arch/arm/plat-omap/cpu-omap.c b/arch/arm/plat-omap/cpu-omap.c
index 6d3d333..5b6aa61 100644
--- a/arch/arm/plat-omap/cpu-omap.c
+++ b/arch/arm/plat-omap/cpu-omap.c
@@ -21,6 +21,7 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <trace/events/power.h>

 #include <mach/hardware.h>
 #include <plat/clock.h>
@@ -95,6 +96,8 @@ static int omap_target(struct cpufreq_policy *policy,
 	printk(KERN_DEBUG "cpufreq-omap: transition: %u --> %u\n",
 	       freqs.old, freqs.new);
 #endif
+	trace_power_switch_state(POWER_PSTATE, freqs.new, 0,
+				 smp_processor_id());
 	ret = clk_set_rate(mpu_clk, freqs.new * 1000);
 	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e8a5ad1..496d4af 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -372,7 +372,8 @@ static inline int hlt_use_halt(void)
 void default_idle(void)
 {
 	if (hlt_use_halt()) {
-		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
+		trace_power_switch_state(POWER_CSTATE, 1, 0,
+					 smp_processor_id());
 		current_thread_info()->status &= ~TS_POLLING;
 		/*
 		 * TS_POLLING-cleared state must be visible before we
@@ -442,7 +443,8 @@ EXPORT_SYMBOL_GPL(cpu_idle_wait);
  */
 void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 {
-	trace_power_start(POWER_CSTATE, (ax>>4)+1, smp_processor_id());
+	trace_power_switch_state(POWER_CSTATE, (ax>>4)+1, 0,
+				 smp_processor_id());
 	if (!need_resched()) {
 		if (cpu_has(&current_cpu_data, X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
@@ -458,7 +460,8 @@ void mwait_idle_with_hints(unsigned long ax,
unsigned long cx)
 static void mwait_idle(void)
 {
 	if (!need_resched()) {
-		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
+		trace_power_switch_state(POWER_CSTATE, 1, 0,
+					 smp_processor_id());
 		if (cpu_has(&current_cpu_data, X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);

@@ -479,11 +482,11 @@ static void mwait_idle(void)
  */
 static void poll_idle(void)
 {
-	trace_power_start(POWER_CSTATE, 0, smp_processor_id());
+	trace_power_switch_state(POWER_CSTATE, 0, 0, smp_processor_id());
 	local_irq_enable();
 	while (!need_resched())
 		cpu_relax();
-	trace_power_end(0);
+	trace_power_switch_state(POWER_CSTATE, 0, 0, smp_processor_id());
 }

 /*
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 96586c3..b2415b2 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -114,7 +114,8 @@ void cpu_idle(void)
 			pm_idle();
 			start_critical_timings();

-			trace_power_end(smp_processor_id());
+			trace_power_switch_state(POWER_CSTATE, 0, 0,
+						 smp_processor_id());
 		}
 		tick_nohz_restart_sched_tick();
 		preempt_enable_no_resched();
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b3d7a3a..64279b1 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -141,7 +141,8 @@ void cpu_idle(void)
 			pm_idle();
 			start_critical_timings();

-			trace_power_end(smp_processor_id());
+			trace_power_switch_state(POWER_CSTATE, 0, 0,
+						 smp_processor_id());

 			/* In many cases the interrupt that ended idle
 			   has already called exit_idle. But some idle
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 199dcb9..013c274 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -354,7 +354,8 @@ void cpufreq_notify_transition(struct
cpufreq_freqs *freqs, unsigned int state)
 		adjust_jiffies(CPUFREQ_POSTCHANGE, freqs);
 		dprintk("FREQ: %lu - CPU: %lu", (unsigned long)freqs->new,
 			(unsigned long)freqs->cpu);
-		trace_power_frequency(POWER_PSTATE, freqs->new, freqs->cpu);
+		trace_power_switch_state(POWER_PSTATE, freqs->new, freqs->cpu,
+					 smp_processor_id());
 		srcu_notifier_call_chain(&cpufreq_transition_notifier_list,
 				CPUFREQ_POSTCHANGE, freqs);
 		if (likely(policy) && likely(policy->cpu == freqs->cpu))
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index a507108..301261a 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -106,7 +106,7 @@ static void cpuidle_idle_call(void)
 	/* give the governor an opportunity to reflect on the outcome */
 	if (cpuidle_curr_governor->reflect)
 		cpuidle_curr_governor->reflect(dev);
-	trace_power_end(smp_processor_id());
+	trace_power_switch_state(POWER_CSTATE, 0, 0, smp_processor_id());
 }

 /**
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 065c804..2b122f1 100755
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -185,7 +185,7 @@ static int intel_idle(struct cpuidle_device *dev,
struct cpuidle_state *state)

 	stop_critical_timings();
 #ifndef MODULE
-	trace_power_start(POWER_CSTATE, (eax >> 4) + 1, cpu);
+	trace_power_switch_state(POWER_CSTATE, (eax >> 4) + 1, 0, cpu);
 #endif
 	if (!need_resched()) {

diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index 286784d..192543a 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -18,61 +18,42 @@ enum {
 #endif

 /*
- * The power events are used for cpuidle & suspend (power_start, power_end)
- *  and for cpufreq (power_frequency)
+ * The power events are used for cpuidle & suspend and for cpufreq
  */
 DECLARE_EVENT_CLASS(power,

-	TP_PROTO(unsigned int type, unsigned int state, unsigned int cpu_id),
+	TP_PROTO(unsigned int type, unsigned int state,
+		 unsigned int sub_state, unsigned int cpu_id),

-	TP_ARGS(type, state, cpu_id),
+	TP_ARGS(type, state, sub_state, cpu_id),

 	TP_STRUCT__entry(
 		__field(	u64,		type		)
 		__field(	u64,		state		)
+		__field(	u64,		sub_state	)
 		__field(	u64,		cpu_id		)
 	),

 	TP_fast_assign(
 		__entry->type = type;
 		__entry->state = state;
+		__entry->sub_state = sub_state;
 		__entry->cpu_id = cpu_id;
 	),

-	TP_printk("type=%lu state=%lu cpu_id=%lu", (unsigned long)__entry->type,
-		(unsigned long)__entry->state, (unsigned long)__entry->cpu_id)
+	TP_printk("type=%lu state=%lu sub_state=%lu cpu_id=%lu",
+		  (unsigned long)__entry->type,
+		  (unsigned long)__entry->state,
+		  (unsigned long)__entry->sub_state,
+		  (unsigned long)__entry->cpu_id)
 );

-DEFINE_EVENT(power, power_start,
+DEFINE_EVENT(power, power_switch_state,

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
+	TP_PROTO(unsigned int type, unsigned int state,
+		 unsigned int sub_state, unsigned int cpu_id),

+	TP_ARGS(type, state, sub_state, cpu_id)
 );

 /*
@@ -81,45 +62,53 @@ TRACE_EVENT(power_end,
  */
 DECLARE_EVENT_CLASS(clock,

-	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+	TP_PROTO(const char *name, unsigned int state,
+		 unsigned int sub_state, unsigned int cpu_id),

-	TP_ARGS(name, state, cpu_id),
+	TP_ARGS(name, state, sub_state, cpu_id),

 	TP_STRUCT__entry(
 		__string(       name,           name            )
 		__field(        u64,            state           )
+		__field(        u64,            sub_state       )
 		__field(        u64,            cpu_id          )
 	),

 	TP_fast_assign(
 		__assign_str(name, name);
 		__entry->state = state;
+		__entry->sub_state = sub_state;
 		__entry->cpu_id = cpu_id;
 	),

-	TP_printk("%s state=%lu cpu_id=%lu", __get_str(name),
-		(unsigned long)__entry->state, (unsigned long)__entry->cpu_id)
+	TP_printk("%s state=%lu sub_state=%lu cpu_id=%lu", __get_str(name),
+		  (unsigned long)__entry->state,
+		  (unsigned long)__entry->sub_state,
+		  (unsigned long)__entry->cpu_id)
 );

 DEFINE_EVENT(clock, clock_enable,

-	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+	TP_PROTO(const char *name, unsigned int state,
+		 unsigned int sub_state, unsigned int cpu_id),

-	TP_ARGS(name, state, cpu_id)
+	TP_ARGS(name, state, sub_state, cpu_id)
 );

 DEFINE_EVENT(clock, clock_disable,

-	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+	TP_PROTO(const char *name, unsigned int state,
+		 unsigned int sub_state, unsigned int cpu_id),

-	TP_ARGS(name, state, cpu_id)
+	TP_ARGS(name, state, sub_state, cpu_id)
 );

 DEFINE_EVENT(clock, clock_set_rate,

-	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+	TP_PROTO(const char *name, unsigned int state,
+		 unsigned int sub_state, unsigned int cpu_id),

-	TP_ARGS(name, state, cpu_id)
+	TP_ARGS(name, state, sub_state, cpu_id)
 );

 /*
@@ -127,31 +116,37 @@ DEFINE_EVENT(clock, clock_set_rate,
  */
 DECLARE_EVENT_CLASS(power_domain,

-	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+	TP_PROTO(const char *name, unsigned int state,
+		 unsigned int sub_state, unsigned int cpu_id),

-	TP_ARGS(name, state, cpu_id),
+	TP_ARGS(name, state, sub_state, cpu_id),

 	TP_STRUCT__entry(
 		__string(       name,           name            )
 		__field(        u64,            state           )
+		__field(        u64,            sub_state       )
 		__field(        u64,            cpu_id          )
 	),

 	TP_fast_assign(
 		__assign_str(name, name);
 		__entry->state = state;
+		__entry->sub_state = sub_state;
 		__entry->cpu_id = cpu_id;
 ),

-	TP_printk("%s state=%lu cpu_id=%lu", __get_str(name),
-		(unsigned long)__entry->state, (unsigned long)__entry->cpu_id)
+	TP_printk("%s state=%lu sub_state=%lu cpu_id=%lu", __get_str(name),
+		  (unsigned long)__entry->state,
+		  (unsigned long)__entry->sub_state,
+		  (unsigned long)__entry->cpu_id)
 );

 DEFINE_EVENT(power_domain, power_domain_target,

-	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+	TP_PROTO(const char *name, unsigned int state,
+		 unsigned int sub_state, unsigned int cpu_id),

-	TP_ARGS(name, state, cpu_id)
+	TP_ARGS(name, state, sub_state, cpu_id)
 );

 #endif /* _TRACE_POWER_H */
diff --git a/kernel/trace/power-traces.c b/kernel/trace/power-traces.c
index a22582a..7da72b0 100644
--- a/kernel/trace/power-traces.c
+++ b/kernel/trace/power-traces.c
@@ -13,5 +13,3 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/power.h>

-EXPORT_TRACEPOINT_SYMBOL_GPL(power_frequency);
-
-- 
1.7.1
