Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab1DTG4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 02:56:46 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:44594 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab1DTG4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 02:56:43 -0400
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC PATCH V3 4/4] cpuidle: Single/Global registration of idle states
To: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        venki@google.com, ak@linux.intel.com, len.brown@intel.com
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-omap@vger.kernel.org, linux-acpi@vger.kernel.org
Date: Wed, 20 Apr 2011 12:26:34 +0530
Message-ID: <20110420065608.332.30043.stgit@tringupt.in.ibm.com>
In-Reply-To: <20110420065445.332.13688.stgit@tringupt.in.ibm.com>
References: <20110420065445.332.13688.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch there is single copy of cpuidle_states structure
instead of per-cpu. The statistics needed on per-cpu basis
by the governor are kept per-cpu. This simplifies the cpuidle
subsystem as state registration is done by single cpu only.
Having single copy of cpuidle_states saves memory. Rare case
of asymmetric C-states can be handled within the cpuidle driverand
architectures such as POWER do not have asymmetric C-states.

To Do:

1. Handle the case when idle states may change at run time
and acpi_processor_cst_has_changed() routine is called.

2. Handle acpi_processor_power_exit() correctly i.e. ensure
unregistration of cpuidle driver since registration is now
moved inside acpi_processor_power_init().

Signed-off-by: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
---

 arch/arm/mach-at91/cpuidle.c          |   31 +++++----
 arch/arm/mach-davinci/cpuidle.c       |   39 ++++++-----
 arch/arm/mach-kirkwood/cpuidle.c      |   30 +++++---
 arch/arm/mach-omap2/cpuidle34xx.c     |   97 +++++++++++++++++++++------
 arch/sh/kernel/cpu/shmobile/cpuidle.c |   18 +++--
 drivers/acpi/processor_driver.c       |   18 +----
 drivers/acpi/processor_idle.c         |  117 +++++++++++++++++++++++++++------
 drivers/cpuidle/cpuidle.c             |   46 ++++---------
 drivers/cpuidle/driver.c              |   25 +++++++
 drivers/cpuidle/governors/ladder.c    |   26 ++++---
 drivers/cpuidle/governors/menu.c      |   20 +++---
 drivers/cpuidle/sysfs.c               |    3 +
 drivers/idle/intel_idle.c             |   80 +++++++++++++++++------
 include/linux/cpuidle.h               |   21 ++++--
 14 files changed, 378 insertions(+), 193 deletions(-)

diff --git a/arch/arm/mach-at91/cpuidle.c b/arch/arm/mach-at91/cpuidle.c
index ed38e3c..039b378 100644
--- a/arch/arm/mach-at91/cpuidle.c
+++ b/arch/arm/mach-at91/cpuidle.c
@@ -33,6 +33,7 @@ static struct cpuidle_driver at91_idle_driver = {
 
 /* Actual code that puts the SoC in different idle states */
 static int at91_enter_idle(struct cpuidle_device *dev,
+			struct cpuidle_driver *drv,
 			       int index)
 {
 	struct timeval before, after;
@@ -68,27 +69,29 @@ static int at91_enter_idle(struct cpuidle_device *dev,
 static int at91_init_cpuidle(void)
 {
 	struct cpuidle_device *device;
-
-	cpuidle_register_driver(&at91_idle_driver);
+	struct cpuidle_drive *driver = &at91_idle_driver;
 
 	device = &per_cpu(at91_cpuidle_device, smp_processor_id());
 	device->state_count = AT91_MAX_STATES;
+	driver->state_count = AT91_MAX_STATES;
 
 	/* Wait for interrupt state */
-	device->states[0].enter = at91_enter_idle;
-	device->states[0].exit_latency = 1;
-	device->states[0].target_residency = 10000;
-	device->states[0].flags = CPUIDLE_FLAG_TIME_VALID;
-	strcpy(device->states[0].name, "WFI");
-	strcpy(device->states[0].desc, "Wait for interrupt");
+	driver->states[0].enter = at91_enter_idle;
+	driver->states[0].exit_latency = 1;
+	driver->states[0].target_residency = 10000;
+	driver->states[0].flags = CPUIDLE_FLAG_TIME_VALID;
+	strcpy(driver->states[0].name, "WFI");
+	strcpy(driver->states[0].desc, "Wait for interrupt");
 
 	/* Wait for interrupt and RAM self refresh state */
-	device->states[1].enter = at91_enter_idle;
-	device->states[1].exit_latency = 10;
-	device->states[1].target_residency = 10000;
-	device->states[1].flags = CPUIDLE_FLAG_TIME_VALID;
-	strcpy(device->states[1].name, "RAM_SR");
-	strcpy(device->states[1].desc, "WFI and RAM Self Refresh");
+	driver->states[1].enter = at91_enter_idle;
+	driver->states[1].exit_latency = 10;
+	driver->states[1].target_residency = 10000;
+	driver->states[1].flags = CPUIDLE_FLAG_TIME_VALID;
+	strcpy(driver->states[1].name, "RAM_SR");
+	strcpy(driver->states[1].desc, "WFI and RAM Self Refresh");
+
+	cpuidle_register_driver(&at91_idle_driver);
 
 	if (cpuidle_register_device(device)) {
 		printk(KERN_ERR "at91_init_cpuidle: Failed registering\n");
diff --git a/arch/arm/mach-davinci/cpuidle.c b/arch/arm/mach-davinci/cpuidle.c
index e3aebe6..ba46a83 100644
--- a/arch/arm/mach-davinci/cpuidle.c
+++ b/arch/arm/mach-davinci/cpuidle.c
@@ -78,6 +78,7 @@ static struct davinci_ops davinci_states[DAVINCI_CPUIDLE_MAX_STATES] = {
 
 /* Actual code that puts the SoC in different idle states */
 static int davinci_enter_idle(struct cpuidle_device *dev,
+				struct cpuidle_driver *drv,
 						int index)
 {
 	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
@@ -112,6 +113,7 @@ static int __init davinci_cpuidle_probe(struct platform_device *pdev)
 {
 	int ret;
 	struct cpuidle_device *device;
+	strcut cpuidle_driver *driver = &davinci_idle_driver;
 	struct davinci_cpuidle_config *pdata = pdev->dev.platform_data;
 
 	device = &per_cpu(davinci_cpuidle_device, smp_processor_id());
@@ -123,32 +125,33 @@ static int __init davinci_cpuidle_probe(struct platform_device *pdev)
 
 	ddr2_reg_base = pdata->ddr2_ctlr_base;
 
-	ret = cpuidle_register_driver(&davinci_idle_driver);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to register driver\n");
-		return ret;
-	}
-
 	/* Wait for interrupt state */
-	device->states[0].enter = davinci_enter_idle;
-	device->states[0].exit_latency = 1;
-	device->states[0].target_residency = 10000;
-	device->states[0].flags = CPUIDLE_FLAG_TIME_VALID;
-	strcpy(device->states[0].name, "WFI");
-	strcpy(device->states[0].desc, "Wait for interrupt");
+	driver->states[0].enter = davinci_enter_idle;
+	driver->states[0].exit_latency = 1;
+	driver->states[0].target_residency = 10000;
+	driver->states[0].flags = CPUIDLE_FLAG_TIME_VALID;
+	strcpy(driver->states[0].name, "WFI");
+	strcpy(driver->states[0].desc, "Wait for interrupt");
 
 	/* Wait for interrupt and DDR self refresh state */
-	device->states[1].enter = davinci_enter_idle;
-	device->states[1].exit_latency = 10;
-	device->states[1].target_residency = 10000;
-	device->states[1].flags = CPUIDLE_FLAG_TIME_VALID;
-	strcpy(device->states[1].name, "DDR SR");
-	strcpy(device->states[1].desc, "WFI and DDR Self Refresh");
+	driver->states[1].enter = davinci_enter_idle;
+	driver->states[1].exit_latency = 10;
+	driver->states[1].target_residency = 10000;
+	driver->states[1].flags = CPUIDLE_FLAG_TIME_VALID;
+	strcpy(driver->states[1].name, "DDR SR");
+	strcpy(driver->states[1].desc, "WFI and DDR Self Refresh");
 	if (pdata->ddr2_pdown)
 		davinci_states[1].flags |= DAVINCI_CPUIDLE_FLAGS_DDR2_PWDN;
 	cpuidle_set_statedata(&device->states_usage[1], &davinci_states[1]);
 
 	device->state_count = DAVINCI_CPUIDLE_MAX_STATES;
+	driver->state_count = DAVINCI_CPUIDLE_MAX_STATES;
+
+	ret = cpuidle_register_driver(&davinci_idle_driver);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register driver\n");
+		return ret;
+	}
 
 	ret = cpuidle_register_device(device);
 	if (ret) {
diff --git a/arch/arm/mach-kirkwood/cpuidle.c b/arch/arm/mach-kirkwood/cpuidle.c
index d135a41..f04f6b1 100644
--- a/arch/arm/mach-kirkwood/cpuidle.c
+++ b/arch/arm/mach-kirkwood/cpuidle.c
@@ -32,6 +32,7 @@ static DEFINE_PER_CPU(struct cpuidle_device, kirkwood_cpuidle_device);
 
 /* Actual code that puts the SoC in different idle states */
 static int kirkwood_enter_idle(struct cpuidle_device *dev,
+				struct cpuidle_driver *drv,
 			       int index)
 {
 	struct timeval before, after;
@@ -70,28 +71,29 @@ static int kirkwood_enter_idle(struct cpuidle_device *dev,
 static int kirkwood_init_cpuidle(void)
 {
 	struct cpuidle_device *device;
-
-	cpuidle_register_driver(&kirkwood_idle_driver);
+	struct cpuidle_driver *driver = &kirkwood_idle_driver;
 
 	device = &per_cpu(kirkwood_cpuidle_device, smp_processor_id());
 	device->state_count = KIRKWOOD_MAX_STATES;
+	driver->state_count = KIRKWOOD_MAX_STATES;
 
 	/* Wait for interrupt state */
-	device->states[0].enter = kirkwood_enter_idle;
-	device->states[0].exit_latency = 1;
-	device->states[0].target_residency = 10000;
-	device->states[0].flags = CPUIDLE_FLAG_TIME_VALID;
-	strcpy(device->states[0].name, "WFI");
-	strcpy(device->states[0].desc, "Wait for interrupt");
+	driver->states[0].enter = kirkwood_enter_idle;
+	driver->states[0].exit_latency = 1;
+	driver->states[0].target_residency = 10000;
+	driver->states[0].flags = CPUIDLE_FLAG_TIME_VALID;
+	strcpy(driver->states[0].name, "WFI");
+	strcpy(driver->states[0].desc, "Wait for interrupt");
 
 	/* Wait for interrupt and DDR self refresh state */
-	device->states[1].enter = kirkwood_enter_idle;
-	device->states[1].exit_latency = 10;
-	device->states[1].target_residency = 10000;
-	device->states[1].flags = CPUIDLE_FLAG_TIME_VALID;
-	strcpy(device->states[1].name, "DDR SR");
-	strcpy(device->states[1].desc, "WFI and DDR Self Refresh");
+	driver->states[1].enter = kirkwood_enter_idle;
+	driver->states[1].exit_latency = 10;
+	driver->states[1].target_residency = 10000;
+	driver->states[1].flags = CPUIDLE_FLAG_TIME_VALID;
+	strcpy(driver->states[1].name, "DDR SR");
+	strcpy(driver->states[1].desc, "WFI and DDR Self Refresh");
 
+	cpuidle_register_driver(&kirkwood_idle_driver);
 	if (cpuidle_register_device(device)) {
 		printk(KERN_ERR "kirkwood_init_cpuidle: Failed registering\n");
 		return -EIO;
diff --git a/arch/arm/mach-omap2/cpuidle34xx.c b/arch/arm/mach-omap2/cpuidle34xx.c
index 4282420..6641574 100644
--- a/arch/arm/mach-omap2/cpuidle34xx.c
+++ b/arch/arm/mach-omap2/cpuidle34xx.c
@@ -114,12 +114,14 @@ static int _cpuidle_deny_idle(struct powerdomain *pwrdm,
 /**
  * omap3_enter_idle - Programs OMAP3 to enter the specified state
  * @dev: cpuidle device
+ * @drv: cpuidle driver
  * @index: the index of state to be entered
  *
  * Called from the CPUidle framework to program the device to the
  * specified target state selected by the governor.
  */
 static int omap3_enter_idle(struct cpuidle_device *dev,
+			struct cpuidle_driver *drv,
 			int index)
 {
 	struct omap3_processor_cx *cx =
@@ -175,6 +177,7 @@ return_sleep_time:
 /**
  * next_valid_state - Find next valid c-state
  * @dev: cpuidle device
+ * @drv: cpuidle driver
  * @index: Index of currently selected c-state
  *
  * If the state corresponding to index is valid, index is returned back
@@ -182,9 +185,10 @@ return_sleep_time:
  * still valid (as defined in omap3_power_states[]) and returns its index.
  */
 static int next_valid_state(struct cpuidle_device *dev,
+				struct cpuidle_driver *drv,
 						int index)
 {
-	struct cpuidle_state *curr = &dev->states[index];
+	struct cpuidle_state *curr = &drv->states[index];
 	struct cpuidle_state_usage *curr_usage = &dev->states_usage[index];
 	struct cpuidle_state *next = NULL;
 	struct omap3_processor_cx *cx;
@@ -202,8 +206,8 @@ static int next_valid_state(struct cpuidle_device *dev,
 		 * Reach the current state starting at highest C-state
 		 */
 		for (; idx >= OMAP3_STATE_C1; idx--) {
-			if (&dev->states[idx] == curr) {
-				next = &dev->states[idx];
+			if (&drv->states[idx] == curr) {
+				next = &drv->states[idx];
 				next_index = idx;
 				break;
 			}
@@ -224,7 +228,7 @@ static int next_valid_state(struct cpuidle_device *dev,
 
 			cx = cpuidle_get_statedata(&dev->states_usage[idx]);
 			if (cx->valid) {
-				next = &dev->states[idx];
+				next = &drv->states[idx];
 				next_index = idx;
 				break;
 			}
@@ -241,6 +245,7 @@ static int next_valid_state(struct cpuidle_device *dev,
 /**
  * omap3_enter_idle_bm - Checks for any bus activity
  * @dev: cpuidle device
+ * @drv: cpuidle driver
  * @index: array index of target state to be programmed
  *
  * Used for C states with CPUIDLE_FLAG_CHECK_BM flag set. This
@@ -248,18 +253,19 @@ static int next_valid_state(struct cpuidle_device *dev,
  * device to the specified or a safer state.
  */
 static int omap3_enter_idle_bm(struct cpuidle_device *dev,
+				struct cpuidle_driver *drv,
 			       int index)
 {
-	struct cpuidle_state *state = &dev->states[index];
-	int new_state_idx = next_valid_state(dev, index);
+	struct cpuidle_state *state = &drv->states[index];
+	int new_state_idx = next_valid_state(dev, drv, index);
 	u32 core_next_state, per_next_state = 0, per_saved_state = 0;
 	u32 cam_state;
 	struct omap3_processor_cx *cx;
 	int ret;
 
 	if ((state->flags & CPUIDLE_FLAG_CHECK_BM) && omap3_idle_bm_check()) {
-		BUG_ON(dev->safe_state_index < 0);
-		new_state_idx = dev->safe_state_index;
+		BUG_ON(drv->safe_state_index < 0);
+		new_state_idx = drv->safe_state_index;
 		goto select_state;
 	}
 
@@ -280,7 +286,7 @@ static int omap3_enter_idle_bm(struct cpuidle_device *dev,
 	 */
 	cam_state = pwrdm_read_pwrst(cam_pd);
 	if (cam_state == PWRDM_POWER_ON) {
-		new_state_idx = dev->safe_state_index;
+		new_state_idx = drv->safe_state_index;
 		goto select_state;
 	}
 
@@ -298,7 +304,7 @@ static int omap3_enter_idle_bm(struct cpuidle_device *dev,
 		pwrdm_set_next_pwrst(per_pd, per_next_state);
 
 select_state:
-	ret = omap3_enter_idle(dev, new_state_idx);
+	ret = omap3_enter_idle(dev, drv, new_state_idx);
 
 	/* Restore original PER state if it was modified */
 	if (per_next_state != per_saved_state)
@@ -497,18 +503,15 @@ struct cpuidle_driver omap3_idle_driver = {
 };
 
 /**
- * omap3_idle_init - Init routine for OMAP3 idle
+ * omap3_cpuidle_driver_init
  *
- * Registers the OMAP3 specific cpuidle driver with the cpuidle
- * framework with the valid set of states.
+ * Sets up and registers omap3 idle driver
  */
-int __init omap3_idle_init(void)
+static int omap3_cpuidle_driver_init(void)
 {
-	int i, count = 0;
+	int i, retval, count = 0;
 	struct omap3_processor_cx *cx;
 	struct cpuidle_state *state;
-	struct cpuidle_state_usage *state_usage;
-	struct cpuidle_device *dev;
 
 	mpu_pd = pwrdm_lookup("mpu_pwrdm");
 	core_pd = pwrdm_lookup("core_pwrdm");
@@ -516,18 +519,13 @@ int __init omap3_idle_init(void)
 	cam_pd = pwrdm_lookup("cam_pwrdm");
 
 	omap_init_power_states();
-	cpuidle_register_driver(&omap3_idle_driver);
-
-	dev = &per_cpu(omap3_idle_dev, smp_processor_id());
 
 	for (i = OMAP3_STATE_C1; i < OMAP3_MAX_STATES; i++) {
 		cx = &omap3_power_states[i];
-		state = &dev->states[count];
-		state_usage = &dev->states_usage[count];
+		state = &drv->states[count];
 
 		if (!cx->valid)
 			continue;
-		cpuidle_set_statedata(state_usage, cx);
 		state->exit_latency = cx->sleep_latency + cx->wakeup_latency;
 		state->target_residency = cx->threshold;
 		state->flags = cx->flags;
@@ -542,13 +540,64 @@ int __init omap3_idle_init(void)
 
 	if (!count)
 		return -EINVAL;
-	dev->state_count = count;
+	drv->state_count = count;
 
 	if (enable_off_mode)
 		omap3_cpuidle_update_states(PWRDM_POWER_OFF, PWRDM_POWER_OFF);
 	else
 		omap3_cpuidle_update_states(PWRDM_POWER_RET, PWRDM_POWER_RET);
 
+	retval = cpuidle_register_driver(&omap3_idle_driver);
+	if (retval) {
+		printk(KERN_ERR "%s: CPUidle register driver failed\n",
+		       __func__);
+		return retval;
+	}
+
+	return 0;
+}
+
+/**
+ * omap3_idle_init
+ *
+ * Registers the OMAP3 specific cpuidle driver with the cpuidle
+ * framework with the valid set of states, registers per cpu
+ * cpuidle device.
+ */
+int __init omap3_idle_init(void)
+{
+	int i, retval, count = 0;
+	static int cpuidle_drv_init;
+	struct omap3_processor_cx *cx;
+	struct cpuidle_state_usage *state_usage;
+	struct cpuidle_device *dev;
+
+	if (!cpuidle_drv_init) {
+		retval = omap3_cpuidle_driver_init();
+		if (retval) {
+			printk(KERN_ERR "%s: CPUidle register driver failed\n",
+		       __func__);
+			return retval;
+		}
+		cpuidle_drv_init++;
+	}
+
+	dev = &per_cpu(omap3_idle_dev, smp_processor_id());
+
+	for (i = OMAP3_STATE_C1; i < OMAP3_MAX_STATES; i++) {
+		cx = &omap3_power_states[i];
+		state_usage = &dev->states_usage[count];
+
+		if (!cx->valid)
+			continue;
+		cpuidle_set_statedata(state_usage, cx);
+		count++;
+	}
+
+	if (!count)
+		return -EINVAL;
+	dev->state_count = count;
+
 	if (cpuidle_register_device(dev)) {
 		printk(KERN_ERR "%s: CPUidle register device failed\n",
 		       __func__);
diff --git a/arch/sh/kernel/cpu/shmobile/cpuidle.c b/arch/sh/kernel/cpu/shmobile/cpuidle.c
index 2340d62..b689f17 100644
--- a/arch/sh/kernel/cpu/shmobile/cpuidle.c
+++ b/arch/sh/kernel/cpu/shmobile/cpuidle.c
@@ -25,6 +25,7 @@ static unsigned long cpuidle_mode[] = {
 };
 
 static int cpuidle_sleep_enter(struct cpuidle_device *dev,
+				struct cpuidle_driver *drv,
 				int index)
 {
 	unsigned long allowed_mode = arch_hwblk_sleep_mode();
@@ -67,19 +68,19 @@ static struct cpuidle_driver cpuidle_driver = {
 void sh_mobile_setup_cpuidle(void)
 {
 	struct cpuidle_device *dev = &cpuidle_dev;
+	struct cpuidle_driver *drv = &cpuidle_driver;
 	struct cpuidle_state *state;
 	int i;
 
-	cpuidle_register_driver(&cpuidle_driver);
 
 	for (i = 0; i < CPUIDLE_STATE_MAX; i++) {
-		dev->states[i].name[0] = '\0';
-		dev->states[i].desc[0] = '\0';
+		drv->states[i].name[0] = '\0';
+		drv->states[i].desc[0] = '\0';
 	}
 
 	i = CPUIDLE_DRIVER_STATE_START;
 
-	state = &dev->states[i++];
+	state = &drv->states[i++];
 	snprintf(state->name, CPUIDLE_NAME_LEN, "C1");
 	strncpy(state->desc, "SuperH Sleep Mode", CPUIDLE_DESC_LEN);
 	state->exit_latency = 1;
@@ -89,10 +90,10 @@ void sh_mobile_setup_cpuidle(void)
 	state->flags |= CPUIDLE_FLAG_TIME_VALID;
 	state->enter = cpuidle_sleep_enter;
 
-	dev->safe_state_index = i-1;
+	drv->safe_state_index = i-1;
 
 	if (sh_mobile_sleep_supported & SUSP_SH_SF) {
-		state = &dev->states[i++];
+		state = &drv->states[i++];
 		snprintf(state->name, CPUIDLE_NAME_LEN, "C2");
 		strncpy(state->desc, "SuperH Sleep Mode [SF]",
 			CPUIDLE_DESC_LEN);
@@ -105,7 +106,7 @@ void sh_mobile_setup_cpuidle(void)
 	}
 
 	if (sh_mobile_sleep_supported & SUSP_SH_STANDBY) {
-		state = &dev->states[i++];
+		state = &drv->states[i++];
 		snprintf(state->name, CPUIDLE_NAME_LEN, "C3");
 		strncpy(state->desc, "SuperH Mobile Standby Mode [SF]",
 			CPUIDLE_DESC_LEN);
@@ -117,7 +118,10 @@ void sh_mobile_setup_cpuidle(void)
 		state->enter = cpuidle_sleep_enter;
 	}
 
+	drv->state_count = i;
 	dev->state_count = i;
 
+	cpuidle_register_driver(&cpuidle_driver);
+
 	cpuidle_register_device(dev);
 }
diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index a4e0f1b..91464b4 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -503,8 +503,7 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
 	acpi_processor_get_throttling_info(pr);
 	acpi_processor_get_limit_info(pr);
 
-
-	if (cpuidle_get_driver() == &acpi_idle_driver)
+	if (!cpuidle_get_driver() || cpuidle_get_driver() == &acpi_idle_driver)
 		acpi_processor_power_init(pr, device);
 
 	pr->cdev = thermal_cooling_device_register("Processor", device,
@@ -800,17 +799,9 @@ static int __init acpi_processor_init(void)
 
 	memset(&errata, 0, sizeof(errata));
 
-	if (!cpuidle_register_driver(&acpi_idle_driver)) {
-		printk(KERN_DEBUG "ACPI: %s registered with cpuidle\n",
-			acpi_idle_driver.name);
-	} else {
-		printk(KERN_DEBUG "ACPI: acpi_idle yielding to %s\n",
-			cpuidle_get_driver()->name);
-	}
-
 	result = acpi_bus_register_driver(&acpi_processor_driver);
 	if (result < 0)
-		goto out_cpuidle;
+		return result;
 
 	acpi_processor_install_hotplug_notify();
 
@@ -821,11 +812,6 @@ static int __init acpi_processor_init(void)
 	acpi_processor_throttling_init();
 
 	return 0;
-
-out_cpuidle:
-	cpuidle_unregister_driver(&acpi_idle_driver);
-
-	return result;
 }
 
 static void __exit acpi_processor_exit(void)
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index bd29363..505355d 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -741,11 +741,13 @@ static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
 /**
  * acpi_idle_enter_c1 - enters an ACPI C1 state-type
  * @dev: the target CPU
+ * @drv: cpuidle driver containing cpuidle state info
  * @index: index of target state
  *
  * This is equivalent to the HALT instruction.
  */
-static int acpi_idle_enter_c1(struct cpuidle_device *dev, int index)
+static int acpi_idle_enter_c1(struct cpuidle_device *dev,
+		struct cpuidle_driver *drv, int index)
 {
 	ktime_t  kt1, kt2;
 	s64 idle_time;
@@ -789,9 +791,11 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev, int index)
 /**
  * acpi_idle_enter_simple - enters an ACPI state without BM handling
  * @dev: the target CPU
+ * @drv: cpuidle driver with cpuidle state information
  * @index: the index of suggested state
  */
-static int acpi_idle_enter_simple(struct cpuidle_device *dev, int index)
+static int acpi_idle_enter_simple(struct cpuidle_device *dev,
+		struct cpuidle_driver *drv, int index)
 {
 	struct acpi_processor *pr;
 	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
@@ -873,11 +877,13 @@ static DEFINE_SPINLOCK(c3_lock);
 /**
  * acpi_idle_enter_bm - enters C3 with proper BM handling
  * @dev: the target CPU
+ * @drv: cpuidle driver containing state data
  * @index: the index of suggested state
  *
  * If BM is detected, the deepest non-C3 idle state is entered instead.
  */
-static int acpi_idle_enter_bm(struct cpuidle_device *dev, int index)
+static int acpi_idle_enter_bm(struct cpuidle_device *dev,
+		struct cpuidle_driver *drv, int index)
 {
 	struct acpi_processor *pr;
 	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
@@ -900,9 +906,9 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev, int index)
 	}
 
 	if (!cx->bm_sts_skip && acpi_idle_bm_check()) {
-		if (dev->safe_state_index >= 0) {
-			return dev->states[dev->safe_state_index].enter(dev,
-						dev->safe_state_index);
+		if (drv->safe_state_index >= 0) {
+			return drv->states[drv->safe_state_index].enter(dev,
+						drv, drv->safe_state_index);
 		} else {
 			local_irq_disable();
 			acpi_safe_halt();
@@ -999,14 +1005,15 @@ struct cpuidle_driver acpi_idle_driver = {
 };
 
 /**
- * acpi_processor_setup_cpuidle - prepares and configures CPUIDLE
+ * acpi_processor_setup_cpuidle_cx - prepares and configures CPUIDLE
+ * device i.e. per-cpu data
+ *
  * @pr: the ACPI processor
  */
-static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
+static int acpi_processor_setup_cpuidle_cx(struct acpi_processor *pr)
 {
 	int i, count = CPUIDLE_DRIVER_STATE_START;
 	struct acpi_processor_cx *cx;
-	struct cpuidle_state *state;
 	struct cpuidle_state_usage *state_usage;
 	struct cpuidle_device *dev = &pr->power.dev;
 
@@ -1018,18 +1025,12 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 	}
 
 	dev->cpu = pr->id;
-	dev->safe_state_index = -1;
-	for (i = 0; i < CPUIDLE_STATE_MAX; i++) {
-		dev->states[i].name[0] = '\0';
-		dev->states[i].desc[0] = '\0';
-	}
 
 	if (max_cstate == 0)
 		max_cstate = 1;
 
 	for (i = 1; i < ACPI_PROCESSOR_MAX_POWER && i <= max_cstate; i++) {
 		cx = &pr->power.states[i];
-		state = &dev->states[count];
 		state_usage = &dev->states_usage[count];
 
 		if (!cx->valid)
@@ -1041,8 +1042,61 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 		    !(acpi_gbl_FADT.flags & ACPI_FADT_C2_MP_SUPPORTED))
 			continue;
 #endif
+
 		cpuidle_set_statedata(state_usage, cx);
 
+		count++;
+		if (count == CPUIDLE_STATE_MAX)
+			break;
+	}
+
+	dev->state_count = count;
+
+	if (!count)
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * acpi_processor_setup_cpuidle states- prepares and configures cpuidle
+ * global state data i.e. idle routines
+ *
+ * @pr: the ACPI processor
+ */
+static int acpi_processor_setup_cpuidle_states(struct acpi_processor *pr)
+{
+	int i, count = CPUIDLE_DRIVER_STATE_START;
+	struct acpi_processor_cx *cx;
+	struct cpuidle_state *state;
+	struct cpuidle_driver *drv = &acpi_idle_driver;
+
+	if (!pr->flags.power_setup_done)
+		return -EINVAL;
+
+	if (pr->flags.power == 0) {
+		return -EINVAL;
+	}
+
+	drv->safe_state_index = -1;
+
+	if (max_cstate == 0)
+		max_cstate = 1;
+
+	for (i = 1; i < ACPI_PROCESSOR_MAX_POWER && i <= max_cstate; i++) {
+		cx = &pr->power.states[i];
+
+		if (!cx->valid)
+			continue;
+
+#ifdef CONFIG_HOTPLUG_CPU
+		if ((cx->type != ACPI_STATE_C1) && (num_online_cpus() > 1) &&
+		    !pr->flags.has_cst &&
+		    !(acpi_gbl_FADT.flags & ACPI_FADT_C2_MP_SUPPORTED))
+			continue;
+#endif
+
+		state = &drv->states[count];
 		snprintf(state->name, CPUIDLE_NAME_LEN, "C%d", i);
 		strncpy(state->desc, cx->desc, CPUIDLE_DESC_LEN);
 		state->exit_latency = cx->latency;
@@ -1055,13 +1109,13 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 				state->flags |= CPUIDLE_FLAG_TIME_VALID;
 
 			state->enter = acpi_idle_enter_c1;
-			dev->safe_state_index = count;
+			drv->safe_state_index = count;
 			break;
 
 			case ACPI_STATE_C2:
 			state->flags |= CPUIDLE_FLAG_TIME_VALID;
 			state->enter = acpi_idle_enter_simple;
-			dev->safe_state_index = count;
+			drv->safe_state_index = count;
 			break;
 
 			case ACPI_STATE_C3:
@@ -1077,7 +1131,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 			break;
 	}
 
-	dev->state_count = count;
+	drv->state_count = count;
 
 	if (!count)
 		return -EINVAL;
@@ -1106,7 +1160,15 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
 	cpuidle_disable_device(&pr->power.dev);
 	acpi_processor_get_power_info(pr);
 	if (pr->flags.power) {
-		acpi_processor_setup_cpuidle(pr);
+		/*
+		 * To Do: Currently state data within driver
+		 * is not updated. So change this to also update
+		 * actual state data i.e. what this routine is
+		 * meant for. Maybe complete unregistration and
+		 * re-registration.
+		 *
+		 */
+		acpi_processor_setup_cpuidle_cx(pr);
 		ret = cpuidle_enable_device(&pr->power.dev);
 	}
 	cpuidle_resume_and_unlock();
@@ -1118,7 +1180,7 @@ int __cpuinit acpi_processor_power_init(struct acpi_processor *pr,
 			      struct acpi_device *device)
 {
 	acpi_status status = 0;
-	static int first_run;
+	static int first_run, acpi_processor_registered;
 
 	if (disabled_by_idle_boot_param())
 		return 0;
@@ -1154,7 +1216,15 @@ int __cpuinit acpi_processor_power_init(struct acpi_processor *pr,
 	 * platforms that only support C1.
 	 */
 	if (pr->flags.power) {
-		acpi_processor_setup_cpuidle(pr);
+		if (!acpi_processor_registered) {
+			acpi_processor_setup_cpuidle_states(pr);
+			if (!cpuidle_register_driver(&acpi_idle_driver)) {
+				printk(KERN_DEBUG "ACPI: %s registered with cpuidle\n",
+					acpi_idle_driver.name);
+				acpi_processor_registered = 1;
+			}
+		}
+		acpi_processor_setup_cpuidle_cx(pr);
 		if (cpuidle_register_device(&pr->power.dev))
 			return -EIO;
 	}
@@ -1168,6 +1238,11 @@ int acpi_processor_power_exit(struct acpi_processor *pr,
 		return 0;
 
 	cpuidle_unregister_device(&pr->power.dev);
+	/* We will have to have unregister driver as well here
+	 * since we move register_driver to power_init. Maybe
+	 * just do an unregister everytime; which will be successful
+	 * only during the last call.
+	 */
 	pr->flags.power_setup_done = 0;
 
 	return 0;
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 5d6f98d..845d3ef 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -50,6 +50,7 @@ static int __cpuidle_register_device(struct cpuidle_device *dev);
 static void cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
+	struct cpuidle_driver *drv = cpuidle_get_driver();
 	struct cpuidle_state *target_state;
 	int next_state, entered_state;
 
@@ -76,19 +77,19 @@ static void cpuidle_idle_call(void)
 #endif
 
 	/* ask the governor for the next state */
-	next_state = cpuidle_curr_governor->select(dev);
+	next_state = cpuidle_curr_governor->select(drv, dev);
 	if (need_resched()) {
 		local_irq_enable();
 		return;
 	}
 
-	target_state = &dev->states[next_state];
+	target_state = &drv->states[next_state];
 
 	/* Is using next_state here correct?? */
 	trace_power_start(POWER_CSTATE, next_state, dev->cpu);
 	trace_cpu_idle(next_state, dev->cpu);
 
-	entered_state = target_state->enter(dev, next_state);
+	entered_state = target_state->enter(dev, drv, next_state);
 
 	trace_power_end(dev->cpu);
 	trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
@@ -144,7 +145,8 @@ void cpuidle_resume_and_unlock(void)
 EXPORT_SYMBOL_GPL(cpuidle_resume_and_unlock);
 
 #ifdef CONFIG_ARCH_HAS_CPU_RELAX
-static int poll_idle(struct cpuidle_device *dev, int index)
+static int poll_idle(struct cpuidle_device *dev,
+		struct cpuidle_driver *drv, int index)
 {
 	ktime_t	t1, t2;
 	s64 diff;
@@ -167,12 +169,9 @@ static int poll_idle(struct cpuidle_device *dev, int index)
 	return index;
 }
 
-static void poll_idle_init(struct cpuidle_device *dev)
+static void poll_idle_init(struct cpuidle_driver *drv)
 {
-	struct cpuidle_state *state = &dev->states[0];
-	struct cpuidle_state_usage *state_usage = &dev->states_usage[0];
-
-	cpuidle_set_statedata(state_usage, NULL);
+	struct cpuidle_state *state = &drv->states[0];
 
 	snprintf(state->name, CPUIDLE_NAME_LEN, "POLL");
 	snprintf(state->desc, CPUIDLE_DESC_LEN, "CPUIDLE CORE POLL IDLE");
@@ -183,7 +182,7 @@ static void poll_idle_init(struct cpuidle_device *dev)
 	state->enter = poll_idle;
 }
 #else
-static void poll_idle_init(struct cpuidle_device *dev) {}
+static void poll_idle_init(struct cpuidle_driver *drv) {}
 #endif /* CONFIG_ARCH_HAS_CPU_RELAX */
 
 /**
@@ -210,13 +209,14 @@ int cpuidle_enable_device(struct cpuidle_device *dev)
 			return ret;
 	}
 
-	poll_idle_init(dev);
+	poll_idle_init(cpuidle_get_driver());
+	cpuidle_set_statedata(&dev->states_usage[0], NULL);
 
 	if ((ret = cpuidle_add_state_sysfs(dev)))
 		return ret;
 
 	if (cpuidle_curr_governor->enable &&
-	    (ret = cpuidle_curr_governor->enable(dev)))
+	    (ret = cpuidle_curr_governor->enable(cpuidle_get_driver(), dev)))
 		goto fail_sysfs;
 
 	for (i = 0; i < dev->state_count; i++) {
@@ -257,7 +257,7 @@ void cpuidle_disable_device(struct cpuidle_device *dev)
 	dev->enabled = 0;
 
 	if (cpuidle_curr_governor->disable)
-		cpuidle_curr_governor->disable(dev);
+		cpuidle_curr_governor->disable(cpuidle_get_driver(), dev);
 
 	cpuidle_remove_state_sysfs(dev);
 	enabled_devices--;
@@ -285,26 +285,6 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 
 	init_completion(&dev->kobj_unregister);
 
-	/*
-	 * cpuidle driver should set the dev->power_specified bit
-	 * before registering the device if the driver provides
-	 * power_usage numbers.
-	 *
-	 * For those devices whose ->power_specified is not set,
-	 * we fill in power_usage with decreasing values as the
-	 * cpuidle code has an implicit assumption that state Cn
-	 * uses less power than C(n-1).
-	 *
-	 * With CONFIG_ARCH_HAS_CPU_RELAX, C0 is already assigned
-	 * an power value of -1.  So we use -2, -3, etc, for other
-	 * c-states.
-	 */
-	if (!dev->power_specified) {
-		int i;
-		for (i = CPUIDLE_DRIVER_STATE_START; i < dev->state_count; i++)
-			dev->states[i].power_usage = -1 - i;
-	}
-
 	per_cpu(cpuidle_devices, dev->cpu) = dev;
 	list_add(&dev->device_list, &cpuidle_detected_devices);
 	if ((ret = cpuidle_add_sysfs(sys_dev))) {
diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index fd1601e..4b04129 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -17,6 +17,30 @@
 static struct cpuidle_driver *cpuidle_curr_driver;
 DEFINE_SPINLOCK(cpuidle_driver_lock);
 
+static void __cpuidle_register_driver(struct cpuidle_driver *drv)
+{
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
+	if (!drv->power_specified) {
+		int i;
+		for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++)
+			drv->states[i].power_usage = -1 - i;
+	}
+}
+
+
 /**
  * cpuidle_register_driver - registers a driver
  * @drv: the driver
@@ -31,6 +55,7 @@ int cpuidle_register_driver(struct cpuidle_driver *drv)
 		spin_unlock(&cpuidle_driver_lock);
 		return -EBUSY;
 	}
+	__cpuidle_register_driver(drv);
 	cpuidle_curr_driver = drv;
 	spin_unlock(&cpuidle_driver_lock);
 
diff --git a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
index 6a686a7..988d813 100644
--- a/drivers/cpuidle/governors/ladder.c
+++ b/drivers/cpuidle/governors/ladder.c
@@ -60,9 +60,11 @@ static inline void ladder_do_selection(struct ladder_device *ldev,
 
 /**
  * ladder_select_state - selects the next state to enter
+ * @drv: cpuidle driver
  * @dev: the CPU
  */
-static int ladder_select_state(struct cpuidle_device *dev)
+static int ladder_select_state(struct cpuidle_driver *drv,
+				struct cpuidle_device *dev)
 {
 	struct ladder_device *ldev = &__get_cpu_var(ladder_devices);
 	struct ladder_device_state *last_state;
@@ -77,15 +79,15 @@ static int ladder_select_state(struct cpuidle_device *dev)
 
 	last_state = &ldev->states[last_idx];
 
-	if (dev->states[last_idx].flags & CPUIDLE_FLAG_TIME_VALID)
-		last_residency = cpuidle_get_last_residency(dev) - dev->states[last_idx].exit_latency;
+	if (drv->states[last_idx].flags & CPUIDLE_FLAG_TIME_VALID)
+		last_residency = cpuidle_get_last_residency(dev) - drv->states[last_idx].exit_latency;
 	else
 		last_residency = last_state->threshold.promotion_time + 1;
 
 	/* consider promotion */
-	if (last_idx < dev->state_count - 1 &&
+	if (last_idx < drv->state_count - 1 &&
 	    last_residency > last_state->threshold.promotion_time &&
-	    dev->states[last_idx + 1].exit_latency <= latency_req) {
+	    drv->states[last_idx + 1].exit_latency <= latency_req) {
 		last_state->stats.promotion_count++;
 		last_state->stats.demotion_count = 0;
 		if (last_state->stats.promotion_count >= last_state->threshold.promotion_count) {
@@ -96,11 +98,11 @@ static int ladder_select_state(struct cpuidle_device *dev)
 
 	/* consider demotion */
 	if (last_idx > CPUIDLE_DRIVER_STATE_START &&
-	    dev->states[last_idx].exit_latency > latency_req) {
+	    drv->states[last_idx].exit_latency > latency_req) {
 		int i;
 
 		for (i = last_idx - 1; i > CPUIDLE_DRIVER_STATE_START; i--) {
-			if (dev->states[i].exit_latency <= latency_req)
+			if (drv->states[i].exit_latency <= latency_req)
 				break;
 		}
 		ladder_do_selection(ldev, last_idx, i);
@@ -123,9 +125,11 @@ static int ladder_select_state(struct cpuidle_device *dev)
 
 /**
  * ladder_enable_device - setup for the governor
+ * @drv: cpuidle driver
  * @dev: the CPU
  */
-static int ladder_enable_device(struct cpuidle_device *dev)
+static int ladder_enable_device(struct cpuidle_driver *drv,
+				struct cpuidle_device *dev)
 {
 	int i;
 	struct ladder_device *ldev = &per_cpu(ladder_devices, dev->cpu);
@@ -134,8 +138,8 @@ static int ladder_enable_device(struct cpuidle_device *dev)
 
 	ldev->last_state_idx = CPUIDLE_DRIVER_STATE_START;
 
-	for (i = 0; i < dev->state_count; i++) {
-		state = &dev->states[i];
+	for (i = 0; i < drv->state_count; i++) {
+		state = &drv->states[i];
 		lstate = &ldev->states[i];
 
 		lstate->stats.promotion_count = 0;
@@ -144,7 +148,7 @@ static int ladder_enable_device(struct cpuidle_device *dev)
 		lstate->threshold.promotion_count = PROMOTION_COUNT;
 		lstate->threshold.demotion_count = DEMOTION_COUNT;
 
-		if (i < dev->state_count - 1)
+		if (i < drv->state_count - 1)
 			lstate->threshold.promotion_time = state->exit_latency;
 		if (i > 0)
 			lstate->threshold.demotion_time = state->exit_latency;
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 40b5630..968149b 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -182,7 +182,7 @@ static inline int performance_multiplier(void)
 
 static DEFINE_PER_CPU(struct menu_device, menu_devices);
 
-static void menu_update(struct cpuidle_device *dev);
+static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev);
 
 /* This implements DIV_ROUND_CLOSEST but avoids 64 bit division */
 static u64 div_round64(u64 dividend, u32 divisor)
@@ -228,9 +228,10 @@ static void detect_repeating_patterns(struct menu_device *data)
 
 /**
  * menu_select - selects the next idle state to enter
+ * @drv: cpuidle driver containing state data
  * @dev: the CPU
  */
-static int menu_select(struct cpuidle_device *dev)
+static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
 	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
@@ -239,7 +240,7 @@ static int menu_select(struct cpuidle_device *dev)
 	int multiplier;
 
 	if (data->needs_update) {
-		menu_update(dev);
+		menu_update(drv, dev);
 		data->needs_update = 0;
 	}
 
@@ -283,8 +284,8 @@ static int menu_select(struct cpuidle_device *dev)
 	 * Find the idle state with the lowest power while satisfying
 	 * our constraints.
 	 */
-	for (i = CPUIDLE_DRIVER_STATE_START; i < dev->state_count; i++) {
-		struct cpuidle_state *s = &dev->states[i];
+	for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
+		struct cpuidle_state *s = &drv->states[i];
 
 		if (s->target_residency > data->predicted_us)
 			continue;
@@ -321,14 +322,15 @@ static void menu_reflect(struct cpuidle_device *dev, int index)
 
 /**
  * menu_update - attempts to guess what happened after entry
+ * @drv: cpuidle driver containing state data
  * @dev: the CPU
  */
-static void menu_update(struct cpuidle_device *dev)
+static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
 	int last_idx = data->last_state_idx;
 	unsigned int last_idle_us = cpuidle_get_last_residency(dev);
-	struct cpuidle_state *target = &dev->states[last_idx];
+	struct cpuidle_state *target = &drv->states[last_idx];
 	unsigned int measured_us;
 	u64 new_factor;
 
@@ -382,9 +384,11 @@ static void menu_update(struct cpuidle_device *dev)
 
 /**
  * menu_enable_device - scans a CPU's states and does setup
+ * @drv: cpuidle driver
  * @dev: the CPU
  */
-static int menu_enable_device(struct cpuidle_device *dev)
+static int menu_enable_device(struct cpuidle_driver *drv,
+				struct cpuidle_device *dev)
 {
 	struct menu_device *data = &per_cpu(menu_devices, dev->cpu);
 
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 09c9c77..90be2ad 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -318,13 +318,14 @@ int cpuidle_add_state_sysfs(struct cpuidle_device *device)
 {
 	int i, ret = -ENOMEM;
 	struct cpuidle_state_kobj *kobj;
+	struct cpuidle_driver *drv = cpuidle_get_driver();
 
 	/* state statistics */
 	for (i = 0; i < device->state_count; i++) {
 		kobj = kzalloc(sizeof(struct cpuidle_state_kobj), GFP_KERNEL);
 		if (!kobj)
 			goto error_state;
-		kobj->state = &device->states[i];
+		kobj->state = &drv->states[i];
 		kobj->state_usage = &device->states_usage[i];
 		init_completion(&kobj->kobj_unregister);
 
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 4f92d96..3bcd8c2 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -81,7 +81,8 @@ static unsigned int mwait_substates;
 static unsigned int lapic_timer_reliable_states = (1 << 1);	 /* Default to only C1 */
 
 static struct cpuidle_device __percpu *intel_idle_cpuidle_devices;
-static int intel_idle(struct cpuidle_device *dev, int index);
+static int intel_idle(struct cpuidle_device *dev,
+			struct cpuidle_driver *drv, int index);
 
 static struct cpuidle_state *cpuidle_state_table;
 
@@ -229,13 +230,15 @@ static int get_driver_data(int cstate)
 /**
  * intel_idle
  * @dev: cpuidle_device
+ * @drv: cpuidle driver
  * @index: index of cpuidle state
  *
  */
-static int intel_idle(struct cpuidle_device *dev, int index)
+static int intel_idle(struct cpuidle_device *dev,
+		struct cpuidle_driver *drv, int index)
 {
 	unsigned long ecx = 1; /* break on interrupt flag */
-	struct cpuidle_state *state = &dev->states[index];
+	struct cpuidle_state *state = &drv->states[index];
 	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
 	unsigned long eax = (unsigned long)cpuidle_get_statedata(state_usage);
 	unsigned int cstate;
@@ -424,6 +427,60 @@ static void intel_idle_cpuidle_devices_uninit(void)
 	return;
 }
 /*
+ * intel_idle_cpuidle_driver_init()
+ * allocate, initialize cpuidle_states
+ */
+static int intel_idle_cpuidle_driver_init(void)
+{
+	int cstate;
+	struct cpuidle_driver *drv = &intel_idle_driver;
+
+	drv->state_count = 1;
+
+	for (cstate = 1; cstate < MWAIT_MAX_NUM_CSTATES; ++cstate) {
+		int num_substates;
+
+		if (cstate > max_cstate) {
+			printk(PREFIX "max_cstate %d reached\n",
+				max_cstate);
+			break;
+		}
+
+		/* does the state exist in CPUID.MWAIT? */
+		num_substates = (mwait_substates >> ((cstate) * 4))
+					& MWAIT_SUBSTATE_MASK;
+		if (num_substates == 0)
+			continue;
+		/* is the state not enabled? */
+		if (cpuidle_state_table[cstate].enter == NULL) {
+			/* does the driver not know about the state? */
+			if (*cpuidle_state_table[cstate].name == '\0')
+				pr_debug(PREFIX "unaware of model 0x%x"
+					" MWAIT %d please"
+					" contact lenb@kernel.org",
+				boot_cpu_data.x86_model, cstate);
+			continue;
+		}
+
+		if ((cstate > 2) &&
+			!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
+			mark_tsc_unstable("TSC halts in idle"
+					" states deeper than C2");
+
+		drv->states[drv->state_count] =	/* structure copy */
+			cpuidle_state_table[cstate];
+
+		drv->state_count += 1;
+	}
+
+	if (auto_demotion_disable_flags)
+		smp_call_function(auto_demotion_disable, NULL, 1);
+
+	return 0;
+}
+
+
+/*
  * intel_idle_cpuidle_devices_init()
  * allocate, initialize, register cpuidle_devices
  */
@@ -457,23 +514,9 @@ static int intel_idle_cpuidle_devices_init(void)
 				continue;
 			/* is the state not enabled? */
 			if (cpuidle_state_table[cstate].enter == NULL) {
-				/* does the driver not know about the state? */
-				if (*cpuidle_state_table[cstate].name == '\0')
-					pr_debug(PREFIX "unaware of model 0x%x"
-						" MWAIT %d please"
-						" contact lenb@kernel.org",
-					boot_cpu_data.x86_model, cstate);
 				continue;
 			}
 
-			if ((cstate > 2) &&
-				!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
-				mark_tsc_unstable("TSC halts in idle"
-					" states deeper than C2");
-
-			dev->states[dev->state_count] =	/* structure copy */
-				cpuidle_state_table[cstate];
-
 			dev->states_usage[dev->state_count].driver_data =
 				(void *)get_driver_data(cstate);
 
@@ -488,8 +531,6 @@ static int intel_idle_cpuidle_devices_init(void)
 			return -EIO;
 		}
 	}
-	if (auto_demotion_disable_flags)
-		smp_call_function(auto_demotion_disable, NULL, 1);
 
 	return 0;
 }
@@ -507,6 +548,7 @@ static int __init intel_idle_init(void)
 	if (retval)
 		return retval;
 
+	intel_idle_cpuidle_driver_init();
 	retval = cpuidle_register_driver(&intel_idle_driver);
 	if (retval) {
 		printk(KERN_DEBUG PREFIX "intel_idle yielding to %s",
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 5a1a238..c70fb8c 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -22,6 +22,7 @@
 #define CPUIDLE_DESC_LEN	32
 
 struct cpuidle_device;
+struct cpuidle_driver;
 
 
 /****************************
@@ -45,6 +46,7 @@ struct cpuidle_state {
 	unsigned int	target_residency; /* in US */
 
 	int (*enter)	(struct cpuidle_device *dev,
+			struct cpuidle_driver *drv,
 			int index);
 };
 
@@ -83,20 +85,17 @@ struct cpuidle_state_kobj {
 struct cpuidle_device {
 	unsigned int		registered:1;
 	unsigned int		enabled:1;
-	unsigned int		power_specified:1;
 	unsigned int		cpu;
 
 	int			last_residency;
 	int			state_count;
-	struct cpuidle_state	states[CPUIDLE_STATE_MAX];
 	struct cpuidle_state_usage	states_usage[CPUIDLE_STATE_MAX];
 	struct cpuidle_state_kobj *kobjs[CPUIDLE_STATE_MAX];
 
-	struct list_head 	device_list;
+	struct list_head	device_list;
 	struct kobject		kobj;
 	struct completion	kobj_unregister;
 	void			*governor_data;
-	int			safe_state_index;
 };
 
 DECLARE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
@@ -120,6 +119,11 @@ static inline int cpuidle_get_last_residency(struct cpuidle_device *dev)
 struct cpuidle_driver {
 	char			name[CPUIDLE_NAME_LEN];
 	struct module 		*owner;
+
+	unsigned int		power_specified:1;
+	struct cpuidle_state	states[CPUIDLE_STATE_MAX];
+	int			state_count;
+	int			safe_state_index;
 };
 
 #ifdef CONFIG_CPU_IDLE
@@ -162,10 +166,13 @@ struct cpuidle_governor {
 	struct list_head 	governor_list;
 	unsigned int		rating;
 
-	int  (*enable)		(struct cpuidle_device *dev);
-	void (*disable)		(struct cpuidle_device *dev);
+	int  (*enable)		(struct cpuidle_driver *drv,
+					struct cpuidle_device *dev);
+	void (*disable)		(struct cpuidle_driver *drv,
+					struct cpuidle_device *dev);
 
-	int  (*select)		(struct cpuidle_device *dev);
+	int  (*select)		(struct cpuidle_driver *drv,
+					struct cpuidle_device *dev);
 	void (*reflect)		(struct cpuidle_device *dev, int index);
 
 	struct module 		*owner;

