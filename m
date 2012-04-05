Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab2DEKo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 06:44:58 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4698 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab2DEKo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 06:44:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 05 Apr 2012 03:44:56 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, Len Brown <len.brown@intel.com>,
        Kevin Hilman <khilman@ti.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH] cpuidle: allow per cpu latencies
Date: Thu,  5 Apr 2012 13:44:10 +0300
Message-Id: <1333622662-22106-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some systems (eg Tegra30) latencies for a given C state are not equal for
all CPUs. Therefore we introduce a new per CPU structure which contains
those parameters.

--

This patch doesn't update all cpuidle device registrations. I will do that
in a next version after agreement on the exact data structure to be
introduced.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/cpuidle.c      |   15 +++++++++++----
 drivers/cpuidle/cpuidle.c          |   27 ++++++++++++++++++++++++---
 drivers/cpuidle/driver.c           |   25 -------------------------
 drivers/cpuidle/governors/ladder.c |   21 ++++++++++++---------
 drivers/cpuidle/governors/menu.c   |    7 ++++---
 drivers/cpuidle/sysfs.c            |   34 +++++++++++++++++++++++-----------
 include/linux/cpuidle.h            |   17 ++++++++++-------
 7 files changed, 84 insertions(+), 62 deletions(-)

diff --git a/arch/arm/mach-tegra/cpuidle.c b/arch/arm/mach-tegra/cpuidle.c
index d83a8c0..b8fdf02 100644
--- a/arch/arm/mach-tegra/cpuidle.c
+++ b/arch/arm/mach-tegra/cpuidle.c
@@ -41,14 +41,20 @@ struct cpuidle_driver tegra_idle_driver = {
 	.states = {
 		[0] = {
 			.enter			= tegra_idle_enter_lp3,
-			.exit_latency		= 10,
-			.target_residency	= 10,
-			.power_usage		= 600,
-			.flags			= CPUIDLE_FLAG_TIME_VALID,
 			.name			= "LP3",
 			.desc			= "CPU flow-controlled",
 		},
 	},
+	.power_specified = 1,
+};
+
+static struct cpuidle_state_parameters __initdata tegra_idle_parameters[] = {
+	[0] = {
+		.exit_latency		= 10,
+		.target_residency	= 10,
+		.power_usage		= 600,
+		.flags			= CPUIDLE_FLAG_TIME_VALID,
+	},
 };
 
 static DEFINE_PER_CPU(struct cpuidle_device, tegra_idle_device);
@@ -95,6 +101,7 @@ static int __init tegra_cpuidle_init(void)
 		dev->cpu = cpu;
 
 		dev->state_count = drv->state_count;
+		dev->state_parameters[0] =  tegra_idle_parameters[0];
 		ret = cpuidle_register_device(dev);
 		if (ret) {
 			pr_err("CPU%u: CPUidle device registration failed\n",
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 87411ce..b992d00 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -87,8 +87,9 @@ int cpuidle_play_dead(void)
 	for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
 		struct cpuidle_state *s = &drv->states[i];
 
-		if (s->power_usage < power_usage && s->enter_dead) {
-			power_usage = s->power_usage;
+		if (dev->state_parameters[i].power_usage < power_usage
+				&& s->enter_dead) {
+			power_usage = dev->state_parameters[i].power_usage;
 			dead_state = i;
 		}
 	}
@@ -371,7 +372,7 @@ EXPORT_SYMBOL_GPL(cpuidle_disable_device);
  */
 static int __cpuidle_register_device(struct cpuidle_device *dev)
 {
-	int ret;
+	int ret, i;
 	struct device *cpu_dev = get_cpu_device((unsigned long)dev->cpu);
 	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
 
@@ -389,6 +390,26 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 		return ret;
 	}
 
+	/*
+	 * cpuidle driver should set the drv->power_specified bit
+	 * before registering if the driver provides
+	 * power_usage numbers.
+	 *
+	 * If power_specified is not set,
+	 * we fill in power_usage with decreasing values as the
+	 * cpuidle code has an implicit assumption that state Cn
+	 * uses less power than C(n-1).
+	 *
+	 * With CONFIG_ARCH_HAS_CPU_RELAX, C0 is already assigned
+	 * an power value of -1.  So we use -2, -3, etc, for other
+	 * c-states.
+	 */
+	if (!cpuidle_driver->power_specified) {
+		for (i = CPUIDLE_DRIVER_STATE_START;
+				i < cpuidle_driver->state_count; i++)
+			dev->state_parameters[i].power_usage = -1 - i;
+	}
+
 	dev->registered = 1;
 	return 0;
 }
diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index 40cd3f3..d81c6db 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -17,30 +17,6 @@
 static struct cpuidle_driver *cpuidle_curr_driver;
 DEFINE_SPINLOCK(cpuidle_driver_lock);
 
-static void __cpuidle_register_driver(struct cpuidle_driver *drv)
-{
-	int i;
-	/*
-	 * cpuidle driver should set the drv->power_specified bit
-	 * before registering if the driver provides
-	 * power_usage numbers.
-	 *
-	 * If power_specified is not set,
-	 * we fill in power_usage with decreasing values as the
-	 * cpuidle code has an implicit assumption that state Cn
-	 * uses less power than C(n-1).
-	 *
-	 * With CONFIG_ARCH_HAS_CPU_RELAX, C0 is already assigned
-	 * an power value of -1.  So we use -2, -3, etc, for other
-	 * c-states.
-	 */
-	if (!drv->power_specified) {
-		for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++)
-			drv->states[i].power_usage = -1 - i;
-	}
-}
-
-
 /**
  * cpuidle_register_driver - registers a driver
  * @drv: the driver
@@ -58,7 +34,6 @@ int cpuidle_register_driver(struct cpuidle_driver *drv)
 		spin_unlock(&cpuidle_driver_lock);
 		return -EBUSY;
 	}
-	__cpuidle_register_driver(drv);
 	cpuidle_curr_driver = drv;
 	spin_unlock(&cpuidle_driver_lock);
 
diff --git a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
index b6a09ea..2e7ea8c 100644
--- a/drivers/cpuidle/governors/ladder.c
+++ b/drivers/cpuidle/governors/ladder.c
@@ -79,9 +79,9 @@ static int ladder_select_state(struct cpuidle_driver *drv,
 
 	last_state = &ldev->states[last_idx];
 
-	if (drv->states[last_idx].flags & CPUIDLE_FLAG_TIME_VALID) {
+	if (dev->state_parameters[last_idx].flags & CPUIDLE_FLAG_TIME_VALID) {
 		last_residency = cpuidle_get_last_residency(dev) - \
-					 drv->states[last_idx].exit_latency;
+				 dev->state_parameters[last_idx].exit_latency;
 	}
 	else
 		last_residency = last_state->threshold.promotion_time + 1;
@@ -89,7 +89,7 @@ static int ladder_select_state(struct cpuidle_driver *drv,
 	/* consider promotion */
 	if (last_idx < drv->state_count - 1 &&
 	    last_residency > last_state->threshold.promotion_time &&
-	    drv->states[last_idx + 1].exit_latency <= latency_req) {
+	    dev->state_parameters[last_idx + 1].exit_latency <= latency_req) {
 		last_state->stats.promotion_count++;
 		last_state->stats.demotion_count = 0;
 		if (last_state->stats.promotion_count >= last_state->threshold.promotion_count) {
@@ -100,11 +100,12 @@ static int ladder_select_state(struct cpuidle_driver *drv,
 
 	/* consider demotion */
 	if (last_idx > CPUIDLE_DRIVER_STATE_START &&
-	    drv->states[last_idx].exit_latency > latency_req) {
+	    dev->state_parameters[last_idx].exit_latency > latency_req) {
 		int i;
 
 		for (i = last_idx - 1; i > CPUIDLE_DRIVER_STATE_START; i--) {
-			if (drv->states[i].exit_latency <= latency_req)
+			if (dev->state_parameters[i].exit_latency <=
+					latency_req)
 				break;
 		}
 		ladder_do_selection(ldev, last_idx, i);
@@ -136,12 +137,12 @@ static int ladder_enable_device(struct cpuidle_driver *drv,
 	int i;
 	struct ladder_device *ldev = &per_cpu(ladder_devices, dev->cpu);
 	struct ladder_device_state *lstate;
-	struct cpuidle_state *state;
+	struct cpuidle_state_parameters *state_parameters;
 
 	ldev->last_state_idx = CPUIDLE_DRIVER_STATE_START;
 
 	for (i = 0; i < drv->state_count; i++) {
-		state = &drv->states[i];
+		state_parameters = &dev->state_parameters[i];
 		lstate = &ldev->states[i];
 
 		lstate->stats.promotion_count = 0;
@@ -151,9 +152,11 @@ static int ladder_enable_device(struct cpuidle_driver *drv,
 		lstate->threshold.demotion_count = DEMOTION_COUNT;
 
 		if (i < drv->state_count - 1)
-			lstate->threshold.promotion_time = state->exit_latency;
+			lstate->threshold.promotion_time =
+				state_parameters->exit_latency;
 		if (i > 0)
-			lstate->threshold.demotion_time = state->exit_latency;
+			lstate->threshold.demotion_time =
+				state_parameters->exit_latency;
 	}
 
 	return 0;
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 0633575..e9bbc20 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -281,7 +281,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	 * unless the timer is happening really really soon.
 	 */
 	if (data->expected_us > 5 &&
-		drv->states[CPUIDLE_DRIVER_STATE_START].disable == 0)
+		dev->state_parameters[CPUIDLE_DRIVER_STATE_START].disable == 0)
 		data->last_state_idx = CPUIDLE_DRIVER_STATE_START;
 
 	/*
@@ -289,7 +289,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	 * our constraints.
 	 */
 	for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
-		struct cpuidle_state *s = &drv->states[i];
+		struct cpuidle_state_parameters *s = &dev->state_parameters[i];
 
 		if (s->disable)
 			continue;
@@ -336,7 +336,8 @@ static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	struct menu_device *data = &__get_cpu_var(menu_devices);
 	int last_idx = data->last_state_idx;
 	unsigned int last_idle_us = cpuidle_get_last_residency(dev);
-	struct cpuidle_state *target = &drv->states[last_idx];
+	struct cpuidle_state_parameters *target =
+			&dev->state_parameters[last_idx];
 	unsigned int measured_us;
 	u64 new_factor;
 
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 88032b4..7b17413 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -215,9 +215,10 @@ static struct kobj_type ktype_cpuidle = {
 
 struct cpuidle_state_attr {
 	struct attribute attr;
-	ssize_t (*show)(struct cpuidle_state *, \
-					struct cpuidle_state_usage *, char *);
-	ssize_t (*store)(struct cpuidle_state *, const char *, size_t);
+	ssize_t (*show)(struct cpuidle_state *, struct cpuidle_state_usage *,
+				struct cpuidle_state_parameters *, char *);
+	ssize_t (*store)(struct cpuidle_state_parameters *, const char *,
+				size_t);
 };
 
 #define define_one_state_ro(_name, show) \
@@ -228,13 +229,15 @@ static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0644, show, store)
 
 #define define_show_state_function(_name) \
 static ssize_t show_state_##_name(struct cpuidle_state *state, \
-			 struct cpuidle_state_usage *state_usage, char *buf) \
+			 struct cpuidle_state_usage *state_usage, \
+			 struct cpuidle_state_parameters *state_parameters, \
+			 char *buf) \
 { \
-	return sprintf(buf, "%u\n", state->_name);\
+	return sprintf(buf, "%u\n", state_parameters->_name);\
 }
 
 #define define_store_state_function(_name) \
-static ssize_t store_state_##_name(struct cpuidle_state *state, \
+static ssize_t store_state_##_name(struct cpuidle_state_parameters *state, \
 		const char *buf, size_t size) \
 { \
 	long value; \
@@ -253,14 +256,18 @@ static ssize_t store_state_##_name(struct cpuidle_state *state, \
 
 #define define_show_state_ull_function(_name) \
 static ssize_t show_state_##_name(struct cpuidle_state *state, \
-			struct cpuidle_state_usage *state_usage, char *buf) \
+			struct cpuidle_state_usage *state_usage, \
+			struct cpuidle_state_parameters *state_parameters, \
+			char *buf) \
 { \
 	return sprintf(buf, "%llu\n", state_usage->_name);\
 }
 
 #define define_show_state_str_function(_name) \
 static ssize_t show_state_##_name(struct cpuidle_state *state, \
-			struct cpuidle_state_usage *state_usage, char *buf) \
+			struct cpuidle_state_usage *state_usage, \
+			struct cpuidle_state_parameters *state_parameters, \
+			char *buf) \
 { \
 	if (state->_name[0] == '\0')\
 		return sprintf(buf, "<null>\n");\
@@ -298,6 +305,7 @@ static struct attribute *cpuidle_state_default_attrs[] = {
 #define kobj_to_state_obj(k) container_of(k, struct cpuidle_state_kobj, kobj)
 #define kobj_to_state(k) (kobj_to_state_obj(k)->state)
 #define kobj_to_state_usage(k) (kobj_to_state_obj(k)->state_usage)
+#define kobj_to_state_parameters(k) (kobj_to_state_obj(k)->state_parameters)
 #define attr_to_stateattr(a) container_of(a, struct cpuidle_state_attr, attr)
 static ssize_t cpuidle_state_show(struct kobject * kobj,
 	struct attribute * attr ,char * buf)
@@ -305,10 +313,12 @@ static ssize_t cpuidle_state_show(struct kobject * kobj,
 	int ret = -EIO;
 	struct cpuidle_state *state = kobj_to_state(kobj);
 	struct cpuidle_state_usage *state_usage = kobj_to_state_usage(kobj);
+	struct cpuidle_state_parameters *state_parameters =
+				kobj_to_state_parameters(kobj);
 	struct cpuidle_state_attr * cattr = attr_to_stateattr(attr);
 
 	if (cattr->show)
-		ret = cattr->show(state, state_usage, buf);
+		ret = cattr->show(state, state_usage, state_parameters, buf);
 
 	return ret;
 }
@@ -317,11 +327,12 @@ static ssize_t cpuidle_state_store(struct kobject *kobj,
 	struct attribute *attr, const char *buf, size_t size)
 {
 	int ret = -EIO;
-	struct cpuidle_state *state = kobj_to_state(kobj);
+	struct cpuidle_state_parameters *state_parameters =
+				kobj_to_state_parameters(kobj);
 	struct cpuidle_state_attr *cattr = attr_to_stateattr(attr);
 
 	if (cattr->store)
-		ret = cattr->store(state, buf, size);
+		ret = cattr->store(state_parameters, buf, size);
 
 	return ret;
 }
@@ -369,6 +380,7 @@ int cpuidle_add_state_sysfs(struct cpuidle_device *device)
 			goto error_state;
 		kobj->state = &drv->states[i];
 		kobj->state_usage = &device->states_usage[i];
+		kobj->state_parameters = &device->state_parameters[i];
 		init_completion(&kobj->kobj_unregister);
 
 		ret = kobject_init_and_add(&kobj->kobj, &ktype_state_cpuidle, &device->kobj,
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 6c26a3d..cddbd34 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -42,12 +42,6 @@ struct cpuidle_state {
 	char		name[CPUIDLE_NAME_LEN];
 	char		desc[CPUIDLE_DESC_LEN];
 
-	unsigned int	flags;
-	unsigned int	exit_latency; /* in US */
-	int		power_usage; /* in mW */
-	unsigned int	target_residency; /* in US */
-	unsigned int    disable;
-
 	int (*enter)	(struct cpuidle_device *dev,
 			struct cpuidle_driver *drv,
 			int index);
@@ -55,6 +49,14 @@ struct cpuidle_state {
 	int (*enter_dead) (struct cpuidle_device *dev, int index);
 };
 
+struct cpuidle_state_parameters {
+	unsigned int	flags;
+	unsigned int	exit_latency; /* in US */
+	int		power_usage; /* in mW */
+	unsigned int	target_residency; /* in US */
+	unsigned int    disable;
+};
+
 /* Idle State Flags */
 #define CPUIDLE_FLAG_TIME_VALID	(0x01) /* is residency time measurable? */
 
@@ -83,6 +85,7 @@ cpuidle_set_statedata(struct cpuidle_state_usage *st_usage, void *data)
 struct cpuidle_state_kobj {
 	struct cpuidle_state *state;
 	struct cpuidle_state_usage *state_usage;
+	struct cpuidle_state_parameters *state_parameters;
 	struct completion kobj_unregister;
 	struct kobject kobj;
 };
@@ -96,7 +99,7 @@ struct cpuidle_device {
 	int			state_count;
 	struct cpuidle_state_usage	states_usage[CPUIDLE_STATE_MAX];
 	struct cpuidle_state_kobj *kobjs[CPUIDLE_STATE_MAX];
-
+	struct cpuidle_state_parameters state_parameters[CPUIDLE_STATE_MAX];
 	struct list_head 	device_list;
 	struct kobject		kobj;
 	struct completion	kobj_unregister;
-- 
1.7.7.rc0.72.g4b5ea.dirty

