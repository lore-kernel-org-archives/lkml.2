Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727Ab2C3KP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:15:28 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:34627 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760650Ab2C3KOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:14:31 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Robert Lee <rob.lee@linaro.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 08/76] ARM: davinci: Consolidate time keeping and irq enable
Date: Fri, 30 Mar 2012 06:13:11 -0400
Message-id: <19976c2a88d125aec16b9255c7197c297bbdd637.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Lee <rob.lee@linaro.org>

Enable core cpuidle timekeeping and irq enabling and remove that
handling from this code.

Signed-off-by: Robert Lee <rob.lee@linaro.org>
Reviewed-by: Kevin Hilman <khilman@ti.com>
Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Jean Pihet <j-pihet@ti.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/arm/mach-davinci/cpuidle.c |   82 ++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 49 deletions(-)

diff --git a/arch/arm/mach-davinci/cpuidle.c b/arch/arm/mach-davinci/cpuidle.c
index a30c7c5..93ae096 100644
--- a/arch/arm/mach-davinci/cpuidle.c
+++ b/arch/arm/mach-davinci/cpuidle.c
@@ -18,6 +18,7 @@
 #include <linux/io.h>
 #include <linux/export.h>
 #include <asm/proc-fns.h>
+#include <asm/cpuidle.h>
 
 #include <mach/cpuidle.h>
 #include <mach/ddr2.h>
@@ -30,12 +31,42 @@ struct davinci_ops {
 	u32 flags;
 };
 
+/* Actual code that puts the SoC in different idle states */
+static int davinci_enter_idle(struct cpuidle_device *dev,
+				struct cpuidle_driver *drv,
+						int index)
+{
+	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
+	struct davinci_ops *ops = cpuidle_get_statedata(state_usage);
+
+	if (ops && ops->enter)
+		ops->enter(ops->flags);
+
+	index = cpuidle_wrap_enter(dev,	drv, index,
+				arm_cpuidle_simple_enter);
+
+	if (ops && ops->exit)
+		ops->exit(ops->flags);
+
+	return index;
+}
+
 /* fields in davinci_ops.flags */
 #define DAVINCI_CPUIDLE_FLAGS_DDR2_PWDN	BIT(0)
 
 static struct cpuidle_driver davinci_idle_driver = {
-	.name	= "cpuidle-davinci",
-	.owner	= THIS_MODULE,
+	.name		= "cpuidle-davinci",
+	.owner		= THIS_MODULE,
+	.states[0]	= ARM_CPUIDLE_WFI_STATE,
+	.states[1]	= {
+		.enter			= davinci_enter_idle,
+		.exit_latency		= 10,
+		.target_residency	= 100000,
+		.flags			= CPUIDLE_FLAG_TIME_VALID,
+		.name			= "DDR SR",
+		.desc			= "WFI and DDR Self Refresh",
+	},
+	.state_count = DAVINCI_CPUIDLE_MAX_STATES,
 };
 
 static DEFINE_PER_CPU(struct cpuidle_device, davinci_cpuidle_device);
@@ -77,41 +108,10 @@ static struct davinci_ops davinci_states[DAVINCI_CPUIDLE_MAX_STATES] = {
 	},
 };
 
-/* Actual code that puts the SoC in different idle states */
-static int davinci_enter_idle(struct cpuidle_device *dev,
-				struct cpuidle_driver *drv,
-						int index)
-{
-	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
-	struct davinci_ops *ops = cpuidle_get_statedata(state_usage);
-	struct timeval before, after;
-	int idle_time;
-
-	local_irq_disable();
-	do_gettimeofday(&before);
-
-	if (ops && ops->enter)
-		ops->enter(ops->flags);
-	/* Wait for interrupt state */
-	cpu_do_idle();
-	if (ops && ops->exit)
-		ops->exit(ops->flags);
-
-	do_gettimeofday(&after);
-	local_irq_enable();
-	idle_time = (after.tv_sec - before.tv_sec) * USEC_PER_SEC +
-			(after.tv_usec - before.tv_usec);
-
-	dev->last_residency = idle_time;
-
-	return index;
-}
-
 static int __init davinci_cpuidle_probe(struct platform_device *pdev)
 {
 	int ret;
 	struct cpuidle_device *device;
-	struct cpuidle_driver *driver = &davinci_idle_driver;
 	struct davinci_cpuidle_config *pdata = pdev->dev.platform_data;
 
 	device = &per_cpu(davinci_cpuidle_device, smp_processor_id());
@@ -123,27 +123,11 @@ static int __init davinci_cpuidle_probe(struct platform_device *pdev)
 
 	ddr2_reg_base = pdata->ddr2_ctlr_base;
 
-	/* Wait for interrupt state */
-	driver->states[0].enter = davinci_enter_idle;
-	driver->states[0].exit_latency = 1;
-	driver->states[0].target_residency = 10000;
-	driver->states[0].flags = CPUIDLE_FLAG_TIME_VALID;
-	strcpy(driver->states[0].name, "WFI");
-	strcpy(driver->states[0].desc, "Wait for interrupt");
-
-	/* Wait for interrupt and DDR self refresh state */
-	driver->states[1].enter = davinci_enter_idle;
-	driver->states[1].exit_latency = 10;
-	driver->states[1].target_residency = 10000;
-	driver->states[1].flags = CPUIDLE_FLAG_TIME_VALID;
-	strcpy(driver->states[1].name, "DDR SR");
-	strcpy(driver->states[1].desc, "WFI and DDR Self Refresh");
 	if (pdata->ddr2_pdown)
 		davinci_states[1].flags |= DAVINCI_CPUIDLE_FLAGS_DDR2_PWDN;
 	cpuidle_set_statedata(&device->states_usage[1], &davinci_states[1]);
 
 	device->state_count = DAVINCI_CPUIDLE_MAX_STATES;
-	driver->state_count = DAVINCI_CPUIDLE_MAX_STATES;
 
 	ret = cpuidle_register_driver(&davinci_idle_driver);
 	if (ret) {
-- 
1.7.10.rc2.19.gfae9d

