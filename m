Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab0DOLG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 07:06:57 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:55567 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab0DOLG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 07:06:56 -0400
Date: Thu, 15 Apr 2010 16:36:25 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: peterz@infradead.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [v12 PATCH 2/8]: cpuidle: cleanup drivers/cpuidle/cpuidle.c
Message-ID: <20100415110625.GC16760@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20100415110046.GA16760@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100415110046.GA16760@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2010-04-15 16:30:46]:

This patch cleans up cpuidle.c by doing away with per-cpu
registration for cpuidle. Instead it introduces a single
registration system to register to cpuidle subsystem.


Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 drivers/cpuidle/cpuidle.c |  269 ++++++++++------------------------------------
 1 file changed, 60 insertions(+), 209 deletions(-)

Index: linux.trees.git/drivers/cpuidle/cpuidle.c
===================================================================
--- linux.trees.git.orig/drivers/cpuidle/cpuidle.c
+++ linux.trees.git/drivers/cpuidle/cpuidle.c
@@ -21,13 +21,10 @@
 
 #include "cpuidle.h"
 
-DEFINE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
+struct cpuidle_subsystem cpuidle_subsys;
 
 DEFINE_MUTEX(cpuidle_lock);
-LIST_HEAD(cpuidle_detected_devices);
-static void (*pm_idle_old)(void);
-
-static int enabled_devices;
+DEFINE_PER_CPU(struct cpuidle_stats, stats);
 
 #if defined(CONFIG_ARCH_HAS_CPU_IDLE_WAIT)
 static void cpuidle_kick_cpus(void)
@@ -40,24 +37,20 @@ static void cpuidle_kick_cpus(void)
 static void cpuidle_kick_cpus(void) {}
 #endif
 
-static int __cpuidle_register_device(struct cpuidle_device *dev);
-
 /**
  * cpuidle_idle_call - the main idle loop
  *
  * NOTE: no locks or semaphores should be used here
  */
-static void cpuidle_idle_call(void)
+void cpuidle_idle_call(void)
 {
-	struct cpuidle_device *dev = __get_cpu_var(cpuidle_devices);
+	int cpu = smp_processor_id();
 	struct cpuidle_state *target_state;
+	struct cpuidle_stats *state_stats;
 	int next_state;
 
 	/* check if the device is ready */
-	if (!dev || !dev->enabled) {
-		if (pm_idle_old)
-			pm_idle_old();
-		else
+	if (!cpuidle_subsys.registered) {
 #if defined(CONFIG_ARCH_HAS_DEFAULT_IDLE)
 			default_idle();
 #else
@@ -75,50 +68,36 @@ static void cpuidle_idle_call(void)
 	hrtimer_peek_ahead_timers();
 #endif
 	/* ask the governor for the next state */
-	next_state = cpuidle_curr_governor->select(dev);
+	next_state = cpuidle_curr_governor->select(cpu);
 	if (need_resched()) {
 		local_irq_enable();
 		return;
 	}
 
-	target_state = &dev->states[next_state];
+	target_state = &cpuidle_subsys.states[next_state];
+	state_stats = &per_cpu(stats, cpu);
 
 	/* enter the state and update stats */
-	dev->last_state = target_state;
-	dev->last_residency = target_state->enter(dev, target_state);
-	if (dev->last_state)
-		target_state = dev->last_state;
+	cpuidle_subsys.last_state[cpu] = target_state;
+	cpuidle_subsys.last_residency[cpu] = target_state->enter(target_state);
+	if (cpuidle_subsys.last_state[cpu])
+		target_state = cpuidle_subsys.last_state[cpu];
 
-	target_state->time += (unsigned long long)dev->last_residency;
-	target_state->usage++;
+	state_stats->time[next_state] += (unsigned long long)(cpuidle_subsys.last_residency[cpu]);
+	state_stats->usage[next_state]++;
 
 	/* give the governor an opportunity to reflect on the outcome */
 	if (cpuidle_curr_governor->reflect)
-		cpuidle_curr_governor->reflect(dev);
+		cpuidle_curr_governor->reflect(cpu);
 	trace_power_end(0);
 }
 
 /**
- * cpuidle_install_idle_handler - installs the cpuidle idle loop handler
- */
-void cpuidle_install_idle_handler(void)
-{
-	if (enabled_devices && (pm_idle != cpuidle_idle_call)) {
-		/* Make sure all changes finished before we switch to new idle */
-		smp_wmb();
-		pm_idle = cpuidle_idle_call;
-	}
-}
-
-/**
  * cpuidle_uninstall_idle_handler - uninstalls the cpuidle idle loop handler
  */
 void cpuidle_uninstall_idle_handler(void)
 {
-	if (enabled_devices && pm_idle_old && (pm_idle != pm_idle_old)) {
-		pm_idle = pm_idle_old;
-		cpuidle_kick_cpus();
-	}
+	cpuidle_kick_cpus();
 }
 
 /**
@@ -137,213 +116,87 @@ EXPORT_SYMBOL_GPL(cpuidle_pause_and_lock
  */
 void cpuidle_resume_and_unlock(void)
 {
-	cpuidle_install_idle_handler();
 	mutex_unlock(&cpuidle_lock);
 }
 
 EXPORT_SYMBOL_GPL(cpuidle_resume_and_unlock);
 
-/**
- * cpuidle_enable_device - enables idle PM for a CPU
- * @dev: the CPU
- *
- * This function must be called between cpuidle_pause_and_lock and
- * cpuidle_resume_and_unlock when used externally.
- */
-int cpuidle_enable_device(struct cpuidle_device *dev)
+static void cpuidle_clear_stats(int cpu, int state_count)
 {
-	int ret, i;
-
-	if (dev->enabled)
-		return 0;
-	if (!cpuidle_curr_driver || !cpuidle_curr_governor)
-		return -EIO;
-	if (!dev->state_count)
-		return -EINVAL;
-
-	if (dev->registered == 0) {
-		ret = __cpuidle_register_device(dev);
-		if (ret)
-			return ret;
-	}
+	int i;
 
-	if ((ret = cpuidle_add_state_sysfs(dev)))
-		return ret;
-
-	if (cpuidle_curr_governor->enable &&
-	    (ret = cpuidle_curr_governor->enable(dev)))
-		goto fail_sysfs;
-
-	for (i = 0; i < dev->state_count; i++) {
-		dev->states[i].usage = 0;
-		dev->states[i].time = 0;
+	for (i = 0; i < state_count; i++) {
+		per_cpu(stats, cpu).usage[i] = 0;
+		per_cpu(stats, cpu).time[i] = 0;
+		cpuidle_subsys.states[i].state_index = i;
 	}
-	dev->last_residency = 0;
-	dev->last_state = NULL;
-
-	smp_wmb();
-
-	dev->enabled = 1;
-
-	enabled_devices++;
-	return 0;
-
-fail_sysfs:
-	cpuidle_remove_state_sysfs(dev);
-
-	return ret;
 }
 
-EXPORT_SYMBOL_GPL(cpuidle_enable_device);
-
 /**
- * cpuidle_disable_device - disables idle PM for a CPU
- * @dev: the CPU
- *
- * This function must be called between cpuidle_pause_and_lock and
- * cpuidle_resume_and_unlock when used externally.
+ * cpuidle_register_subsystem - registers a CPU's idle PM feature
+ * @state_count: number of idle states available
  */
-void cpuidle_disable_device(struct cpuidle_device *dev)
+int cpuidle_register_subsystem(int state_count)
 {
-	if (!dev->enabled)
-		return;
-	if (!cpuidle_curr_driver || !cpuidle_curr_governor)
-		return;
-
-	dev->enabled = 0;
-
-	if (cpuidle_curr_governor->disable)
-		cpuidle_curr_governor->disable(dev);
-
-	cpuidle_remove_state_sysfs(dev);
-	enabled_devices--;
-}
-
-EXPORT_SYMBOL_GPL(cpuidle_disable_device);
-
-#ifdef CONFIG_ARCH_HAS_CPU_RELAX
-static int poll_idle(struct cpuidle_device *dev, struct cpuidle_state *st)
-{
-	ktime_t	t1, t2;
-	s64 diff;
-	int ret;
-
-	t1 = ktime_get();
-	local_irq_enable();
-	while (!need_resched())
-		cpu_relax();
-
-	t2 = ktime_get();
-	diff = ktime_to_us(ktime_sub(t2, t1));
-	if (diff > INT_MAX)
-		diff = INT_MAX;
-
-	ret = (int) diff;
-	return ret;
-}
+	int cpu, ret;
+	struct sys_device *sys_dev;
 
-static void poll_idle_init(struct cpuidle_device *dev)
-{
-	struct cpuidle_state *state = &dev->states[0];
-
-	cpuidle_set_statedata(state, NULL);
-
-	snprintf(state->name, CPUIDLE_NAME_LEN, "C0");
-	snprintf(state->desc, CPUIDLE_DESC_LEN, "CPUIDLE CORE POLL IDLE");
-	state->exit_latency = 0;
-	state->target_residency = 0;
-	state->power_usage = -1;
-	state->flags = CPUIDLE_FLAG_POLL;
-	state->enter = poll_idle;
-}
-#else
-static void poll_idle_init(struct cpuidle_device *dev) {}
-#endif /* CONFIG_ARCH_HAS_CPU_RELAX */
-
-/**
- * __cpuidle_register_device - internal register function called before register
- * and enable routines
- * @dev: the cpu
- *
- * cpuidle_lock mutex must be held before this is called
- */
-static int __cpuidle_register_device(struct cpuidle_device *dev)
-{
-	int ret;
-	struct sys_device *sys_dev = get_cpu_sysdev((unsigned long)dev->cpu);
-
-	if (!sys_dev)
-		return -EINVAL;
-	if (!try_module_get(cpuidle_curr_driver->owner))
-		return -EINVAL;
-
-	init_completion(&dev->kobj_unregister);
+	cpuidle_pause_and_lock();
 
-	poll_idle_init(dev);
+	cpuidle_subsys.state_count = state_count;
 
-	per_cpu(cpuidle_devices, dev->cpu) = dev;
-	list_add(&dev->device_list, &cpuidle_detected_devices);
-	if ((ret = cpuidle_add_sysfs(sys_dev))) {
-		module_put(cpuidle_curr_driver->owner);
-		return ret;
-	}
-
-	dev->registered = 1;
-	return 0;
-}
+	for_each_online_cpu(cpu) {
+		init_completion(&per_cpu(stats, cpu).kobj_unregister);
+		sys_dev = get_cpu_sysdev(cpu);
 
-/**
- * cpuidle_register_device - registers a CPU's idle PM feature
- * @dev: the cpu
- */
-int cpuidle_register_device(struct cpuidle_device *dev)
-{
-	int ret;
+		cpuidle_clear_stats(cpu, state_count);
+		if ((ret = cpuidle_add_sysfs(sys_dev)))
+			return ret;
 
-	mutex_lock(&cpuidle_lock);
+		if ((ret = cpuidle_add_state_sysfs(cpu)))
+			return ret;
 
-	if ((ret = __cpuidle_register_device(dev))) {
-		mutex_unlock(&cpuidle_lock);
-		return ret;
+		if (cpuidle_curr_governor->enable &&
+			(ret = cpuidle_curr_governor->enable(cpu)))
+			return ret;
 	}
 
-	cpuidle_enable_device(dev);
-	cpuidle_install_idle_handler();
+	cpuidle_subsys.registered = 1;
 
-	mutex_unlock(&cpuidle_lock);
+	cpuidle_resume_and_unlock();
 
 	return 0;
-
 }
 
-EXPORT_SYMBOL_GPL(cpuidle_register_device);
+EXPORT_SYMBOL_GPL(cpuidle_register_subsystem);
 
 /**
- * cpuidle_unregister_device - unregisters a CPU's idle PM feature
- * @dev: the cpu
+ * cpuidle_unregister_subsystem - unregisters a CPU's idle PM feature
  */
-void cpuidle_unregister_device(struct cpuidle_device *dev)
+void cpuidle_unregister_subsystem(void)
 {
-	struct sys_device *sys_dev = get_cpu_sysdev((unsigned long)dev->cpu);
-
-	if (dev->registered == 0)
-		return;
+	int cpu;
+	struct sys_device *sys_dev;
 
 	cpuidle_pause_and_lock();
 
-	cpuidle_disable_device(dev);
+	cpuidle_subsys.registered = 0;
 
-	cpuidle_remove_sysfs(sys_dev);
-	list_del(&dev->device_list);
-	wait_for_completion(&dev->kobj_unregister);
-	per_cpu(cpuidle_devices, dev->cpu) = NULL;
+	for_each_online_cpu(cpu) {
+		sys_dev = get_cpu_sysdev(cpu);
 
-	cpuidle_resume_and_unlock();
+		if (cpuidle_curr_governor->disable)
+			cpuidle_curr_governor->disable(cpu);
 
-	module_put(cpuidle_curr_driver->owner);
+		cpuidle_remove_state_sysfs(cpu);
+		cpuidle_remove_sysfs(sys_dev);
+		wait_for_completion(&per_cpu(stats, cpu).kobj_unregister);
+	}
+
+	cpuidle_resume_and_unlock();
 }
 
-EXPORT_SYMBOL_GPL(cpuidle_unregister_device);
+EXPORT_SYMBOL_GPL(cpuidle_unregister_subsystem);
 
 #ifdef CONFIG_SMP
 
@@ -387,8 +240,6 @@ static int __init cpuidle_init(void)
 {
 	int ret;
 
-	pm_idle_old = pm_idle;
-
 	ret = cpuidle_add_class_sysfs(&cpu_sysdev_class);
 	if (ret)
 		return ret;
