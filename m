Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab2KOB5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 20:57:51 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58405 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab2KOB5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 20:57:49 -0500
From: Julius Werner <jwerner@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kevin Hilman <khilman@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Sameer Nanda <snanda@chromium.org>,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH] cpuidle: Measure idle state durations with monotonic clock
Date: Wed, 14 Nov 2012 17:56:30 -0800
Message-Id: <1352944590-8776-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <CAODwPW873M32d9zFT9fpJT9+PuMbz8htzUxdF1TNE+J1zR3jYA@mail.gmail.com>
References: <CAODwPW873M32d9zFT9fpJT9+PuMbz8htzUxdF1TNE+J1zR3jYA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many cpuidle drivers measure their time spent in an idle state by
reading the wallclock time before and after idling and calculating the
difference. This leads to erroneous results when the wallclock time gets
updated by another processor in the meantime, adding that clock
adjustment to the idle state's time counter.

If the clock adjustment was negative, the result is even worse due to an
erroneous cast from int to unsigned long long of the last_residency
variable. The negative 32 bit integer will zero-extend and result in a
forward time jump of roughly four billion milliseconds or 1.3 hours on
the idle state residency counter.

This patch changes all affected cpuidle drivers to either use the
monotonic clock for their measurements or make use of the generic time
measurement wrapper in cpuidle.c, which was already working correctly.
Some superfluous CLIs/STIs in the ACPI code are removed (interrupts
should always already be disabled before entering the idle function, and
not get reenabled until the generic wrapper has performed its second
measurement). It also removes the erroneous cast, making sure that
negative residency values are applied correctly even though they should
not appear anymore.

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 arch/powerpc/platforms/pseries/processor_idle.c |    4 +-
 drivers/acpi/processor_idle.c                   |   57 +---------------------
 drivers/cpuidle/cpuidle.c                       |    3 +-
 drivers/idle/intel_idle.c                       |   14 +-----
 4 files changed, 7 insertions(+), 71 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/processor_idle.c b/arch/powerpc/platforms/pseries/processor_idle.c
index 45d00e5..4d806b4 100644
--- a/arch/powerpc/platforms/pseries/processor_idle.c
+++ b/arch/powerpc/platforms/pseries/processor_idle.c
@@ -36,7 +36,7 @@ static struct cpuidle_state *cpuidle_state_table;
 static inline void idle_loop_prolog(unsigned long *in_purr, ktime_t *kt_before)
 {
 
-	*kt_before = ktime_get_real();
+	*kt_before = ktime_get();
 	*in_purr = mfspr(SPRN_PURR);
 	/*
 	 * Indicate to the HV that we are idle. Now would be
@@ -50,7 +50,7 @@ static inline  s64 idle_loop_epilog(unsigned long in_purr, ktime_t kt_before)
 	get_lppaca()->wait_state_cycles += mfspr(SPRN_PURR) - in_purr;
 	get_lppaca()->idle = 0;
 
-	return ktime_to_us(ktime_sub(ktime_get_real(), kt_before));
+	return ktime_to_us(ktime_sub(ktime_get(), kt_before));
 }
 
 static int snooze_loop(struct cpuidle_device *dev,
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index e8086c7..f1a5da4 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -735,31 +735,18 @@ static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
 static int acpi_idle_enter_c1(struct cpuidle_device *dev,
 		struct cpuidle_driver *drv, int index)
 {
-	ktime_t  kt1, kt2;
-	s64 idle_time;
 	struct acpi_processor *pr;
 	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
 	struct acpi_processor_cx *cx = cpuidle_get_statedata(state_usage);
 
 	pr = __this_cpu_read(processors);
-	dev->last_residency = 0;
 
 	if (unlikely(!pr))
 		return -EINVAL;
 
-	local_irq_disable();
-
-
 	lapic_timer_state_broadcast(pr, cx, 1);
-	kt1 = ktime_get_real();
 	acpi_idle_do_entry(cx);
-	kt2 = ktime_get_real();
-	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
-
-	/* Update device last_residency*/
-	dev->last_residency = (int)idle_time;
 
-	local_irq_enable();
 	lapic_timer_state_broadcast(pr, cx, 0);
 
 	return index;
@@ -806,19 +793,12 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 	struct acpi_processor *pr;
 	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
 	struct acpi_processor_cx *cx = cpuidle_get_statedata(state_usage);
-	ktime_t  kt1, kt2;
-	s64 idle_time_ns;
-	s64 idle_time;
 
 	pr = __this_cpu_read(processors);
-	dev->last_residency = 0;
 
 	if (unlikely(!pr))
 		return -EINVAL;
 
-	local_irq_disable();
-
-
 	if (cx->entry_method != ACPI_CSTATE_FFH) {
 		current_thread_info()->status &= ~TS_POLLING;
 		/*
@@ -829,7 +809,6 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 
 		if (unlikely(need_resched())) {
 			current_thread_info()->status |= TS_POLLING;
-			local_irq_enable();
 			return -EINVAL;
 		}
 	}
@@ -843,22 +822,12 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 	if (cx->type == ACPI_STATE_C3)
 		ACPI_FLUSH_CPU_CACHE();
 
-	kt1 = ktime_get_real();
 	/* Tell the scheduler that we are going deep-idle: */
 	sched_clock_idle_sleep_event();
 	acpi_idle_do_entry(cx);
-	kt2 = ktime_get_real();
-	idle_time_ns = ktime_to_ns(ktime_sub(kt2, kt1));
-	idle_time = idle_time_ns;
-	do_div(idle_time, NSEC_PER_USEC);
 
-	/* Update device last_residency*/
-	dev->last_residency = (int)idle_time;
+	sched_clock_idle_wakeup_event(0);
 
-	/* Tell the scheduler how much we idled: */
-	sched_clock_idle_wakeup_event(idle_time_ns);
-
-	local_irq_enable();
 	if (cx->entry_method != ACPI_CSTATE_FFH)
 		current_thread_info()->status |= TS_POLLING;
 
@@ -883,13 +852,8 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 	struct acpi_processor *pr;
 	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
 	struct acpi_processor_cx *cx = cpuidle_get_statedata(state_usage);
-	ktime_t  kt1, kt2;
-	s64 idle_time_ns;
-	s64 idle_time;
-
 
 	pr = __this_cpu_read(processors);
-	dev->last_residency = 0;
 
 	if (unlikely(!pr))
 		return -EINVAL;
@@ -899,16 +863,11 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 			return drv->states[drv->safe_state_index].enter(dev,
 						drv, drv->safe_state_index);
 		} else {
-			local_irq_disable();
 			acpi_safe_halt();
-			local_irq_enable();
 			return -EBUSY;
 		}
 	}
 
-	local_irq_disable();
-
-
 	if (cx->entry_method != ACPI_CSTATE_FFH) {
 		current_thread_info()->status &= ~TS_POLLING;
 		/*
@@ -919,7 +878,6 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 
 		if (unlikely(need_resched())) {
 			current_thread_info()->status |= TS_POLLING;
-			local_irq_enable();
 			return -EINVAL;
 		}
 	}
@@ -934,7 +892,6 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 	 */
 	lapic_timer_state_broadcast(pr, cx, 1);
 
-	kt1 = ktime_get_real();
 	/*
 	 * disable bus master
 	 * bm_check implies we need ARB_DIS
@@ -965,18 +922,9 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 		c3_cpu_count--;
 		raw_spin_unlock(&c3_lock);
 	}
-	kt2 = ktime_get_real();
-	idle_time_ns = ktime_to_ns(ktime_sub(kt2, kt1));
-	idle_time = idle_time_ns;
-	do_div(idle_time, NSEC_PER_USEC);
-
-	/* Update device last_residency*/
-	dev->last_residency = (int)idle_time;
 
-	/* Tell the scheduler how much we idled: */
-	sched_clock_idle_wakeup_event(idle_time_ns);
+	sched_clock_idle_wakeup_event(0);
 
-	local_irq_enable();
 	if (cx->entry_method != ACPI_CSTATE_FFH)
 		current_thread_info()->status |= TS_POLLING;
 
@@ -987,6 +935,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 struct cpuidle_driver acpi_idle_driver = {
 	.name =		"acpi_idle",
 	.owner =	THIS_MODULE,
+	.en_core_tk_irqen = 1,
 };
 
 /**
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 7f15b85..1536edd 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -109,8 +109,7 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
 		/* This can be moved to within driver enter routine
 		 * but that results in multiple copies of same code.
 		 */
-		dev->states_usage[entered_state].time +=
-				(unsigned long long)dev->last_residency;
+		dev->states_usage[entered_state].time += dev->last_residency;
 		dev->states_usage[entered_state].usage++;
 	} else {
 		dev->last_residency = 0;
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index b0f6b4c..c49c04d 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -56,7 +56,6 @@
 #include <linux/kernel.h>
 #include <linux/cpuidle.h>
 #include <linux/clockchips.h>
-#include <linux/hrtimer.h>	/* ktime_get_real() */
 #include <trace/events/power.h>
 #include <linux/sched.h>
 #include <linux/notifier.h>
@@ -72,6 +71,7 @@
 static struct cpuidle_driver intel_idle_driver = {
 	.name = "intel_idle",
 	.owner = THIS_MODULE,
+	.en_core_tk_irqen = 1,
 };
 /* intel_idle.max_cstate=0 disables driver */
 static int max_cstate = MWAIT_MAX_NUM_CSTATES - 1;
@@ -281,8 +281,6 @@ static int intel_idle(struct cpuidle_device *dev,
 	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
 	unsigned long eax = (unsigned long)cpuidle_get_statedata(state_usage);
 	unsigned int cstate;
-	ktime_t kt_before, kt_after;
-	s64 usec_delta;
 	int cpu = smp_processor_id();
 
 	cstate = (((eax) >> MWAIT_SUBSTATE_SIZE) & MWAIT_CSTATE_MASK) + 1;
@@ -297,8 +295,6 @@ static int intel_idle(struct cpuidle_device *dev,
 	if (!(lapic_timer_reliable_states & (1 << (cstate))))
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
 
-	kt_before = ktime_get_real();
-
 	stop_critical_timings();
 	if (!need_resched()) {
 
@@ -310,17 +306,9 @@ static int intel_idle(struct cpuidle_device *dev,
 
 	start_critical_timings();
 
-	kt_after = ktime_get_real();
-	usec_delta = ktime_to_us(ktime_sub(kt_after, kt_before));
-
-	local_irq_enable();
-
 	if (!(lapic_timer_reliable_states & (1 << (cstate))))
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
 
-	/* Update cpuidle counters */
-	dev->last_residency = (int)usec_delta;
-
 	return index;
 }
 
-- 
1.7.8.6

