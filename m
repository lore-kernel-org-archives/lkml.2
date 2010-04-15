Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab0DOLHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 07:07:47 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:56212 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab0DOLHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 07:07:45 -0400
Date: Thu, 15 Apr 2010 16:37:38 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: peterz@infradead.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [v12 PATCH 3/8]: cpuidle: cleanup driver/cpuidle/sysfs.c and
 governor.c
Message-ID: <20100415110738.GD16760@linux.vnet.ibm.com>
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

This patch cleans up drivers/cpuidle/sysfs.c to incorporate the new design,
since we are doing away with cpuidle_device structure, this patch moves the
code around a little bit.

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 drivers/cpuidle/governor.c         |   20 ++--------
 drivers/cpuidle/governors/ladder.c |   27 ++++++-------
 drivers/cpuidle/governors/menu.c   |   26 +++++--------
 drivers/cpuidle/sysfs.c            |   72 +++++++++++++++++++------------------
 4 files changed, 67 insertions(+), 78 deletions(-)

Index: linux.trees.git/drivers/cpuidle/governor.c
===================================================================
--- linux.trees.git.orig/drivers/cpuidle/governor.c
+++ linux.trees.git/drivers/cpuidle/governor.c
@@ -43,27 +43,17 @@ static struct cpuidle_governor * __cpuid
  */
 int cpuidle_switch_governor(struct cpuidle_governor *gov)
 {
-	struct cpuidle_device *dev;
-
 	if (gov == cpuidle_curr_governor)
 		return 0;
 
-	cpuidle_uninstall_idle_handler();
-
-	if (cpuidle_curr_governor) {
-		list_for_each_entry(dev, &cpuidle_detected_devices, device_list)
-			cpuidle_disable_device(dev);
+	if (cpuidle_curr_governor)
 		module_put(cpuidle_curr_governor->owner);
-	}
 
 	cpuidle_curr_governor = gov;
 
 	if (gov) {
 		if (!try_module_get(cpuidle_curr_governor->owner))
 			return -EINVAL;
-		list_for_each_entry(dev, &cpuidle_detected_devices, device_list)
-			cpuidle_enable_device(dev);
-		cpuidle_install_idle_handler();
 		printk(KERN_INFO "cpuidle: using governor %s\n", gov->name);
 	}
 
@@ -81,7 +71,7 @@ int cpuidle_register_governor(struct cpu
 	if (!gov || !gov->select)
 		return -EINVAL;
 
-	mutex_lock(&cpuidle_lock);
+	cpuidle_pause_and_lock();
 	if (__cpuidle_find_governor(gov->name) == NULL) {
 		ret = 0;
 		list_add_tail(&gov->governor_list, &cpuidle_governors);
@@ -89,7 +79,7 @@ int cpuidle_register_governor(struct cpu
 		    cpuidle_curr_governor->rating < gov->rating)
 			cpuidle_switch_governor(gov);
 	}
-	mutex_unlock(&cpuidle_lock);
+	cpuidle_resume_and_unlock();
 
 	return ret;
 }
@@ -126,13 +116,13 @@ void cpuidle_unregister_governor(struct 
 	if (!gov)
 		return;
 
-	mutex_lock(&cpuidle_lock);
+	cpuidle_pause_and_lock();
 	if (gov == cpuidle_curr_governor) {
 		struct cpuidle_governor *new_gov;
 		new_gov = cpuidle_replace_governor(gov->rating);
 		cpuidle_switch_governor(new_gov);
 	}
 	list_del(&gov->governor_list);
-	mutex_unlock(&cpuidle_lock);
+	cpuidle_resume_and_unlock();
 }
 
Index: linux.trees.git/drivers/cpuidle/sysfs.c
===================================================================
--- linux.trees.git.orig/drivers/cpuidle/sysfs.c
+++ linux.trees.git/drivers/cpuidle/sysfs.c
@@ -156,8 +156,8 @@ void cpuidle_remove_class_sysfs(struct s
 
 struct cpuidle_attr {
 	struct attribute attr;
-	ssize_t (*show)(struct cpuidle_device *, char *);
-	ssize_t (*store)(struct cpuidle_device *, const char *, size_t count);
+	ssize_t (*show)(struct cpuidle_stats *, char *);
+	ssize_t (*store)(struct cpuidle_stats *, const char *, size_t count);
 };
 
 #define define_one_ro(_name, show) \
@@ -165,17 +165,17 @@ struct cpuidle_attr {
 #define define_one_rw(_name, show, store) \
 	static struct cpuidle_attr attr_##_name = __ATTR(_name, 0644, show, store)
 
-#define kobj_to_cpuidledev(k) container_of(k, struct cpuidle_device, kobj)
+#define kobj_to_cpuidlestats(k) container_of(k, struct cpuidle_stats, kobj)
 #define attr_to_cpuidleattr(a) container_of(a, struct cpuidle_attr, attr)
 static ssize_t cpuidle_show(struct kobject * kobj, struct attribute * attr ,char * buf)
 {
 	int ret = -EIO;
-	struct cpuidle_device *dev = kobj_to_cpuidledev(kobj);
+	struct cpuidle_stats *st = kobj_to_cpuidlestats(kobj);
 	struct cpuidle_attr * cattr = attr_to_cpuidleattr(attr);
 
 	if (cattr->show) {
 		mutex_lock(&cpuidle_lock);
-		ret = cattr->show(dev, buf);
+		ret = cattr->show(st, buf);
 		mutex_unlock(&cpuidle_lock);
 	}
 	return ret;
@@ -185,12 +185,12 @@ static ssize_t cpuidle_store(struct kobj
 		     const char * buf, size_t count)
 {
 	int ret = -EIO;
-	struct cpuidle_device *dev = kobj_to_cpuidledev(kobj);
+	struct cpuidle_stats *st = kobj_to_cpuidlestats(kobj);
 	struct cpuidle_attr * cattr = attr_to_cpuidleattr(attr);
 
 	if (cattr->store) {
 		mutex_lock(&cpuidle_lock);
-		ret = cattr->store(dev, buf, count);
+		ret = cattr->store(st, buf, count);
 		mutex_unlock(&cpuidle_lock);
 	}
 	return ret;
@@ -203,9 +203,9 @@ static const struct sysfs_ops cpuidle_sy
 
 static void cpuidle_sysfs_release(struct kobject *kobj)
 {
-	struct cpuidle_device *dev = kobj_to_cpuidledev(kobj);
+	struct cpuidle_stats *st = kobj_to_cpuidlestats(kobj);
 
-	complete(&dev->kobj_unregister);
+	complete(&st->kobj_unregister);
 }
 
 static struct kobj_type ktype_cpuidle = {
@@ -231,7 +231,7 @@ static ssize_t show_state_##_name(struct
 #define define_show_state_ull_function(_name) \
 static ssize_t show_state_##_name(struct cpuidle_state *state, char *buf) \
 { \
-	return sprintf(buf, "%llu\n", state->_name);\
+	return sprintf(buf, "%llu\n", *state->_name);\
 }
 
 #define define_show_state_str_function(_name) \
@@ -267,15 +267,20 @@ static struct attribute *cpuidle_state_d
 };
 
 #define kobj_to_state_obj(k) container_of(k, struct cpuidle_state_kobj, kobj)
+#define kobj_to_cpuid(k) (kobj_to_state_obj(k)->cpuid)
 #define kobj_to_state(k) (kobj_to_state_obj(k)->state)
 #define attr_to_stateattr(a) container_of(a, struct cpuidle_state_attr, attr)
 static ssize_t cpuidle_state_show(struct kobject * kobj,
 	struct attribute * attr ,char * buf)
 {
 	int ret = -EIO;
+	int cpu = kobj_to_cpuid(kobj);
 	struct cpuidle_state *state = kobj_to_state(kobj);
 	struct cpuidle_state_attr * cattr = attr_to_stateattr(attr);
 
+	state->usage = &per_cpu(stats, cpu).usage[state->state_index];
+	state->time = &per_cpu(stats, cpu).time[state->state_index];
+
 	if (cattr->show)
 		ret = cattr->show(state, buf);
 
@@ -299,59 +304,58 @@ static struct kobj_type ktype_state_cpui
 	.release = cpuidle_state_sysfs_release,
 };
 
-static void inline cpuidle_free_state_kobj(struct cpuidle_device *device, int i)
+static void inline cpuidle_free_state_kobj(int cpu, int i)
 {
-	kobject_put(&device->kobjs[i]->kobj);
-	wait_for_completion(&device->kobjs[i]->kobj_unregister);
-	kfree(device->kobjs[i]);
-	device->kobjs[i] = NULL;
+	kobject_put(&per_cpu(stats, cpu).kobjs[i]->kobj);
+	wait_for_completion(&per_cpu(stats, cpu).kobjs[i]->kobj_unregister);
+	kfree(per_cpu(stats, cpu).kobjs[i]);
+	per_cpu(stats, cpu).kobjs[i] = NULL;
 }
 
 /**
  * cpuidle_add_driver_sysfs - adds driver-specific sysfs attributes
- * @device: the target device
  */
-int cpuidle_add_state_sysfs(struct cpuidle_device *device)
+int cpuidle_add_state_sysfs(int cpu)
 {
 	int i, ret = -ENOMEM;
 	struct cpuidle_state_kobj *kobj;
 
 	/* state statistics */
-	for (i = 0; i < device->state_count; i++) {
+	for (i = 0; i < cpuidle_subsys.state_count; i++) {
 		kobj = kzalloc(sizeof(struct cpuidle_state_kobj), GFP_KERNEL);
 		if (!kobj)
 			goto error_state;
-		kobj->state = &device->states[i];
+		kobj->state = &cpuidle_subsys.states[i];
 		init_completion(&kobj->kobj_unregister);
 
-		ret = kobject_init_and_add(&kobj->kobj, &ktype_state_cpuidle, &device->kobj,
-					   "state%d", i);
+		ret = kobject_init_and_add(&kobj->kobj, &ktype_state_cpuidle,
+				&per_cpu(stats, cpu).kobj, "state%d", i);
 		if (ret) {
 			kfree(kobj);
 			goto error_state;
 		}
 		kobject_uevent(&kobj->kobj, KOBJ_ADD);
-		device->kobjs[i] = kobj;
+		per_cpu(stats, cpu).kobjs[i] = kobj;
+		kobj->cpuid = cpu;
 	}
 
 	return 0;
 
 error_state:
 	for (i = i - 1; i >= 0; i--)
-		cpuidle_free_state_kobj(device, i);
+		cpuidle_free_state_kobj(cpu, i);
 	return ret;
 }
 
 /**
  * cpuidle_remove_driver_sysfs - removes driver-specific sysfs attributes
- * @device: the target device
  */
-void cpuidle_remove_state_sysfs(struct cpuidle_device *device)
+void cpuidle_remove_state_sysfs(int cpu)
 {
 	int i;
 
-	for (i = 0; i < device->state_count; i++)
-		cpuidle_free_state_kobj(device, i);
+	for (i = 0; i < cpuidle_subsys.state_count; i++)
+		cpuidle_free_state_kobj(cpu, i);
 }
 
 /**
@@ -361,14 +365,14 @@ void cpuidle_remove_state_sysfs(struct c
 int cpuidle_add_sysfs(struct sys_device *sysdev)
 {
 	int cpu = sysdev->id;
-	struct cpuidle_device *dev;
+	struct cpuidle_stats *st;
 	int error;
 
-	dev = per_cpu(cpuidle_devices, cpu);
-	error = kobject_init_and_add(&dev->kobj, &ktype_cpuidle, &sysdev->kobj,
+	st = &per_cpu(stats, cpu);
+	error = kobject_init_and_add(&st->kobj, &ktype_cpuidle, &sysdev->kobj,
 				     "cpuidle");
 	if (!error)
-		kobject_uevent(&dev->kobj, KOBJ_ADD);
+		kobject_uevent(&st->kobj, KOBJ_ADD);
 	return error;
 }
 
@@ -379,8 +383,8 @@ int cpuidle_add_sysfs(struct sys_device 
 void cpuidle_remove_sysfs(struct sys_device *sysdev)
 {
 	int cpu = sysdev->id;
-	struct cpuidle_device *dev;
+	struct cpuidle_stats *st;
 
-	dev = per_cpu(cpuidle_devices, cpu);
-	kobject_put(&dev->kobj);
+	st = &per_cpu(stats, cpu);
+	kobject_put(&st->kobj);
 }
Index: linux.trees.git/drivers/cpuidle/governors/ladder.c
===================================================================
--- linux.trees.git.orig/drivers/cpuidle/governors/ladder.c
+++ linux.trees.git/drivers/cpuidle/governors/ladder.c
@@ -60,9 +60,8 @@ static inline void ladder_do_selection(s
 
 /**
  * ladder_select_state - selects the next state to enter
- * @dev: the CPU
  */
-static int ladder_select_state(struct cpuidle_device *dev)
+static int ladder_select_state(int cpu)
 {
 	struct ladder_device *ldev = &__get_cpu_var(ladder_devices);
 	struct ladder_device_state *last_state;
@@ -77,15 +76,16 @@ static int ladder_select_state(struct cp
 
 	last_state = &ldev->states[last_idx];
 
-	if (dev->states[last_idx].flags & CPUIDLE_FLAG_TIME_VALID)
-		last_residency = cpuidle_get_last_residency(dev) - dev->states[last_idx].exit_latency;
+	if (cpuidle_subsys.states[last_idx].flags & CPUIDLE_FLAG_TIME_VALID)
+		last_residency = cpuidle_get_last_residency(cpu) -
+			cpuidle_subsys.states[last_idx].exit_latency;
 	else
 		last_residency = last_state->threshold.promotion_time + 1;
 
 	/* consider promotion */
-	if (last_idx < dev->state_count - 1 &&
+	if (last_idx < cpuidle_subsys.state_count - 1 &&
 	    last_residency > last_state->threshold.promotion_time &&
-	    dev->states[last_idx + 1].exit_latency <= latency_req) {
+	    cpuidle_subsys.states[last_idx + 1].exit_latency <= latency_req) {
 		last_state->stats.promotion_count++;
 		last_state->stats.demotion_count = 0;
 		if (last_state->stats.promotion_count >= last_state->threshold.promotion_count) {
@@ -96,11 +96,11 @@ static int ladder_select_state(struct cp
 
 	/* consider demotion */
 	if (last_idx > CPUIDLE_DRIVER_STATE_START &&
-	    dev->states[last_idx].exit_latency > latency_req) {
+	    cpuidle_subsys.states[last_idx].exit_latency > latency_req) {
 		int i;
 
 		for (i = last_idx - 1; i > CPUIDLE_DRIVER_STATE_START; i--) {
-			if (dev->states[i].exit_latency <= latency_req)
+			if (cpuidle_subsys.states[i].exit_latency <= latency_req)
 				break;
 		}
 		ladder_do_selection(ldev, last_idx, i);
@@ -123,19 +123,18 @@ static int ladder_select_state(struct cp
 
 /**
  * ladder_enable_device - setup for the governor
- * @dev: the CPU
  */
-static int ladder_enable_device(struct cpuidle_device *dev)
+static int ladder_enable_device(int cpu)
 {
 	int i;
-	struct ladder_device *ldev = &per_cpu(ladder_devices, dev->cpu);
+	struct ladder_device *ldev = &per_cpu(ladder_devices, cpu);
 	struct ladder_device_state *lstate;
 	struct cpuidle_state *state;
 
 	ldev->last_state_idx = CPUIDLE_DRIVER_STATE_START;
 
-	for (i = 0; i < dev->state_count; i++) {
-		state = &dev->states[i];
+	for (i = 0; i < cpuidle_subsys.state_count; i++) {
+		state = &cpuidle_subsys.states[i];
 		lstate = &ldev->states[i];
 
 		lstate->stats.promotion_count = 0;
@@ -144,7 +143,7 @@ static int ladder_enable_device(struct c
 		lstate->threshold.promotion_count = PROMOTION_COUNT;
 		lstate->threshold.demotion_count = DEMOTION_COUNT;
 
-		if (i < dev->state_count - 1)
+		if (i < cpuidle_subsys.state_count - 1)
 			lstate->threshold.promotion_time = state->exit_latency;
 		if (i > 0)
 			lstate->threshold.demotion_time = state->exit_latency;
Index: linux.trees.git/drivers/cpuidle/governors/menu.c
===================================================================
--- linux.trees.git.orig/drivers/cpuidle/governors/menu.c
+++ linux.trees.git/drivers/cpuidle/governors/menu.c
@@ -168,7 +168,7 @@ static inline int performance_multiplier
 
 static DEFINE_PER_CPU(struct menu_device, menu_devices);
 
-static void menu_update(struct cpuidle_device *dev);
+static void menu_update(int cpu);
 
 /* This implements DIV_ROUND_CLOSEST but avoids 64 bit division */
 static u64 div_round64(u64 dividend, u32 divisor)
@@ -178,9 +178,8 @@ static u64 div_round64(u64 dividend, u32
 
 /**
  * menu_select - selects the next idle state to enter
- * @dev: the CPU
  */
-static int menu_select(struct cpuidle_device *dev)
+static int menu_select(int cpu)
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
 	int latency_req = pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY);
@@ -191,7 +190,7 @@ static int menu_select(struct cpuidle_de
 	data->exit_us = 0;
 
 	if (data->needs_update) {
-		menu_update(dev);
+		menu_update(cpu);
 		data->needs_update = 0;
 	}
 
@@ -228,8 +227,8 @@ static int menu_select(struct cpuidle_de
 
 
 	/* find the deepest idle state that satisfies our constraints */
-	for (i = CPUIDLE_DRIVER_STATE_START; i < dev->state_count; i++) {
-		struct cpuidle_state *s = &dev->states[i];
+	for (i = CPUIDLE_DRIVER_STATE_START; i < cpuidle_subsys.state_count; i++) {
+		struct cpuidle_state *s = &cpuidle_subsys.states[i];
 
 		if (s->target_residency > data->predicted_us)
 			break;
@@ -246,12 +245,11 @@ static int menu_select(struct cpuidle_de
 
 /**
  * menu_reflect - records that data structures need update
- * @dev: the CPU
  *
  * NOTE: it's important to be fast here because this operation will add to
  *       the overall exit latency.
  */
-static void menu_reflect(struct cpuidle_device *dev)
+static void menu_reflect(int cpu)
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
 	data->needs_update = 1;
@@ -259,14 +257,13 @@ static void menu_reflect(struct cpuidle_
 
 /**
  * menu_update - attempts to guess what happened after entry
- * @dev: the CPU
  */
-static void menu_update(struct cpuidle_device *dev)
+static void menu_update(int cpu)
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
 	int last_idx = data->last_state_idx;
-	unsigned int last_idle_us = cpuidle_get_last_residency(dev);
-	struct cpuidle_state *target = &dev->states[last_idx];
+	unsigned int last_idle_us = cpuidle_get_last_residency(cpu);
+	struct cpuidle_state *target = &cpuidle_subsys.states[last_idx];
 	unsigned int measured_us;
 	u64 new_factor;
 
@@ -315,11 +312,10 @@ static void menu_update(struct cpuidle_d
 
 /**
  * menu_enable_device - scans a CPU's states and does setup
- * @dev: the CPU
  */
-static int menu_enable_device(struct cpuidle_device *dev)
+static int menu_enable_device(int cpu)
 {
-	struct menu_device *data = &per_cpu(menu_devices, dev->cpu);
+	struct menu_device *data = &per_cpu(menu_devices, cpu);
 
 	memset(data, 0, sizeof(struct menu_device));
 
