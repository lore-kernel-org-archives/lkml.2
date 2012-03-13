Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181Ab2CMWaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 18:30:39 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:33139 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759900Ab2CMWac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 18:30:32 -0400
Date: Tue, 13 Mar 2012 15:29:56 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Andrew Morton <akpm@linux-foundation.org>, Robert Lee <rob.lee@linaro.org>,
        Jean Pihet <j-pihet@ti.com>, Kevin Hilman <khilman@ti.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: next-20120313 cpuidle freezes when booting
Message-ID: <alpine.LSU.2.00.1203131454500.1335@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Yesterday's 3.3.0-rc7-next-20120313 gives me unpredictable freezes
on x86_64, on a ThinkPad T420s - I've not dared it on more machines.

Usually when booting up (sometimes just after Freeing unused kernel
memory, sometimes random places elsewhere), but occasionally it manages
to get as far as X; doesn't usually manage to complete suspend+resume.

3.3.0-rc6-nex-20120309 behaved similarly; the last I tried before
that was 3.3.0-rc5-next20120227, which was okay.

Bisection led me to "cpuidle: Add common time keeping and irq enabling",
(from the cpuidle-cons tree I think), and reverting that has so far
given me a working system (it's a success if I complete this mail).

Below is the patch I've used to revert it (for other people having
problems with recent linux-next to try); but it's not quite correct,
because you did a merge on conflicting trees there, and I didn't spend
time to unravel all that, just get a working x86 system - since I've
left out some of your merge (in arch/arm/kernel/Makefile and arch/arm/
mach-at91/cpuidle.c), this reversion probably breaks arm as is.

Hugh

--- 3037n/arch/arm/include/asm/cpuidle.h	2012-03-13 03:52:08.180030668 -0700
+++ linux/arch/arm/include/asm/cpuidle.h	1969-12-31 16:00:00.000000000 -0800
@@ -1,22 +0,0 @@
-#ifndef __ASM_ARM_CPUIDLE_H
-#define __ASM_ARM_CPUIDLE_H
-
-#ifdef CONFIG_CPU_IDLE
-extern int arm_cpuidle_simple_enter(struct cpuidle_device *dev,
-		struct cpuidle_driver *drv, int index);
-#else
-static inline int arm_cpuidle_simple_enter(struct cpuidle_device *dev,
-		struct cpuidle_driver *drv, int index) { return -ENODEV; }
-#endif
-
-/* Common ARM WFI state */
-#define ARM_CPUIDLE_WFI_STATE {\
-	.enter                  = arm_cpuidle_simple_enter,\
-	.exit_latency           = 1,\
-	.target_residency       = 1,\
-	.flags                  = CPUIDLE_FLAG_TIME_VALID,\
-	.name                   = "WFI",\
-	.desc                   = "ARM WFI",\
-}
-
-#endif
--- 3037n/arch/arm/kernel/Makefile	2012-03-13 03:52:08.196030668 -0700
+++ linux/arch/arm/kernel/Makefile	2012-03-13 13:05:09.422973635 -0700
@@ -23,7 +23,7 @@ obj-$(CONFIG_DEPRECATED_PARAM_STRUCT) +=
 
 obj-$(CONFIG_LEDS)		+= leds.o
 obj-$(CONFIG_OC_ETM)		+= etm.o
-obj-$(CONFIG_CPU_IDLE)		+= cpuidle.o
+
 obj-$(CONFIG_ISA_DMA_API)	+= dma.o
 obj-$(CONFIG_FIQ)		+= fiq.o fiqasm.o
 obj-$(CONFIG_MODULES)		+= armksyms.o module.o
--- 3037n/arch/arm/kernel/cpuidle.c	2012-03-13 03:52:08.200030668 -0700
+++ linux/arch/arm/kernel/cpuidle.c	1969-12-31 16:00:00.000000000 -0800
@@ -1,21 +0,0 @@
-/*
- * Copyright 2012 Linaro Ltd.
- *
- * The code contained herein is licensed under the GNU General Public
- * License. You may obtain a copy of the GNU General Public License
- * Version 2 or later at the following locations:
- *
- * http://www.opensource.org/licenses/gpl-license.html
- * http://www.gnu.org/copyleft/gpl.html
- */
-
-#include <linux/cpuidle.h>
-#include <asm/proc-fns.h>
-
-int arm_cpuidle_simple_enter(struct cpuidle_device *dev,
-		struct cpuidle_driver *drv, int index)
-{
-	cpu_do_idle();
-
-	return index;
-}
--- 3037n/drivers/cpuidle/cpuidle.c	2012-03-13 03:52:09.884030708 -0700
+++ linux/drivers/cpuidle/cpuidle.c	2012-03-13 14:18:36.703077748 -0700
@@ -53,24 +53,6 @@ static void cpuidle_kick_cpus(void) {}
 
 static int __cpuidle_register_device(struct cpuidle_device *dev);
 
-static inline int cpuidle_enter(struct cpuidle_device *dev,
-				struct cpuidle_driver *drv, int index)
-{
-	struct cpuidle_state *target_state = &drv->states[index];
-	return target_state->enter(dev, drv, index);
-}
-
-static inline int cpuidle_enter_tk(struct cpuidle_device *dev,
-			       struct cpuidle_driver *drv, int index)
-{
-	return cpuidle_wrap_enter(dev, drv, index, cpuidle_enter);
-}
-
-typedef int (*cpuidle_enter_t)(struct cpuidle_device *dev,
-			       struct cpuidle_driver *drv, int index);
-
-static cpuidle_enter_t cpuidle_enter_ops;
-
 /**
  * cpuidle_idle_call - the main idle loop
  *
@@ -81,6 +63,7 @@ int cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_driver *drv = cpuidle_get_driver();
+	struct cpuidle_state *target_state;
 	int next_state, entered_state;
 
 	if (off)
@@ -109,10 +92,12 @@ int cpuidle_idle_call(void)
 		return 0;
 	}
 
+	target_state = &drv->states[next_state];
+
 	trace_power_start_rcuidle(POWER_CSTATE, next_state, dev->cpu);
 	trace_cpu_idle_rcuidle(next_state, dev->cpu);
 
-	entered_state = cpuidle_enter_ops(dev, drv, next_state);
+	entered_state = target_state->enter(dev, drv, next_state);
 
 	trace_power_end_rcuidle(dev->cpu);
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
@@ -125,8 +110,6 @@ int cpuidle_idle_call(void)
 		dev->states_usage[entered_state].time +=
 				(unsigned long long)dev->last_residency;
 		dev->states_usage[entered_state].usage++;
-	} else {
-		dev->last_residency = 0;
 	}
 
 	/* give the governor an opportunity to reflect on the outcome */
@@ -181,29 +164,20 @@ void cpuidle_resume_and_unlock(void)
 
 EXPORT_SYMBOL_GPL(cpuidle_resume_and_unlock);
 
-/**
- * cpuidle_wrap_enter - performs timekeeping and irqen around enter function
- * @dev: pointer to a valid cpuidle_device object
- * @drv: pointer to a valid cpuidle_driver object
- * @index: index of the target cpuidle state.
- */
-int cpuidle_wrap_enter(struct cpuidle_device *dev,
-				struct cpuidle_driver *drv, int index,
-				int (*enter)(struct cpuidle_device *dev,
-					struct cpuidle_driver *drv, int index))
+#ifdef CONFIG_ARCH_HAS_CPU_RELAX
+static int poll_idle(struct cpuidle_device *dev,
+		struct cpuidle_driver *drv, int index)
 {
-	ktime_t time_start, time_end;
+	ktime_t	t1, t2;
 	s64 diff;
 
-	time_start = ktime_get();
-
-	index = enter(dev, drv, index);
-
-	time_end = ktime_get();
-
+	t1 = ktime_get();
 	local_irq_enable();
+	while (!need_resched())
+		cpu_relax();
 
-	diff = ktime_to_us(ktime_sub(time_end, time_start));
+	t2 = ktime_get();
+	diff = ktime_to_us(ktime_sub(t2, t1));
 	if (diff > INT_MAX)
 		diff = INT_MAX;
 
@@ -212,23 +186,6 @@ int cpuidle_wrap_enter(struct cpuidle_de
 	return index;
 }
 
-#ifdef CONFIG_ARCH_HAS_CPU_RELAX
-static inline int __poll_idle(struct cpuidle_device *dev,
-		struct cpuidle_driver *drv, int index)
-{
-	while (!need_resched())
-		cpu_relax();
-
-	return index;
-}
-
-static int poll_idle(struct cpuidle_device *dev,
-		struct cpuidle_driver *drv, int index)
-{
-	return cpuidle_wrap_enter(dev,	drv, index,
-				__poll_idle);
-}
-
 static void poll_idle_init(struct cpuidle_driver *drv)
 {
 	struct cpuidle_state *state = &drv->states[0];
@@ -256,11 +213,10 @@ static void poll_idle_init(struct cpuidl
 int cpuidle_enable_device(struct cpuidle_device *dev)
 {
 	int ret, i;
-	struct cpuidle_driver *drv = cpuidle_get_driver();
 
 	if (dev->enabled)
 		return 0;
-	if (!drv || !cpuidle_curr_governor)
+	if (!cpuidle_get_driver() || !cpuidle_curr_governor)
 		return -EIO;
 	if (!dev->state_count)
 		return -EINVAL;
@@ -271,16 +227,13 @@ int cpuidle_enable_device(struct cpuidle
 			return ret;
 	}
 
-	cpuidle_enter_ops = drv->en_core_tk_irqen ?
-		cpuidle_enter_tk : cpuidle_enter;
-
-	poll_idle_init(drv);
+	poll_idle_init(cpuidle_get_driver());
 
 	if ((ret = cpuidle_add_state_sysfs(dev)))
 		return ret;
 
 	if (cpuidle_curr_governor->enable &&
-	    (ret = cpuidle_curr_governor->enable(drv, dev)))
+	    (ret = cpuidle_curr_governor->enable(cpuidle_get_driver(), dev)))
 		goto fail_sysfs;
 
 	for (i = 0; i < dev->state_count; i++) {
--- 3037n/include/linux/cpuidle.h	2012-03-13 03:52:14.812030826 -0700
+++ linux/include/linux/cpuidle.h	2012-03-13 13:05:09.422973635 -0700
@@ -15,7 +15,6 @@
 #include <linux/list.h>
 #include <linux/kobject.h>
 #include <linux/completion.h>
-#include <linux/hrtimer.h>
 
 #define CPUIDLE_STATE_MAX	8
 #define CPUIDLE_NAME_LEN	16
@@ -124,8 +123,6 @@ struct cpuidle_driver {
 	struct module 		*owner;
 
 	unsigned int		power_specified:1;
-	/* set to 1 to use the core cpuidle time keeping (for all states). */
-	unsigned int		en_core_tk_irqen:1;
 	struct cpuidle_state	states[CPUIDLE_STATE_MAX];
 	int			state_count;
 	int			safe_state_index;
@@ -144,10 +141,7 @@ extern void cpuidle_pause_and_lock(void)
 extern void cpuidle_resume_and_unlock(void);
 extern int cpuidle_enable_device(struct cpuidle_device *dev);
 extern void cpuidle_disable_device(struct cpuidle_device *dev);
-extern int cpuidle_wrap_enter(struct cpuidle_device *dev,
-				struct cpuidle_driver *drv, int index,
-				int (*enter)(struct cpuidle_device *dev,
-					struct cpuidle_driver *drv, int index));
+
 #else
 static inline void disable_cpuidle(void) { }
 static inline int cpuidle_idle_call(void) { return -ENODEV; }
@@ -164,11 +158,6 @@ static inline void cpuidle_resume_and_un
 static inline int cpuidle_enable_device(struct cpuidle_device *dev)
 {return -ENODEV; }
 static inline void cpuidle_disable_device(struct cpuidle_device *dev) { }
-static inline int cpuidle_wrap_enter(struct cpuidle_device *dev,
-				struct cpuidle_driver *drv, int index,
-				int (*enter)(struct cpuidle_device *dev,
-					struct cpuidle_driver *drv, int index))
-{ return -ENODEV; }
 
 #endif
 
