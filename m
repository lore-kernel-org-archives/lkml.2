Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760527Ab2C3LPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:15:06 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:58394 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760274Ab2C3LO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:14:58 -0400
X-Greylist: delayed 3614 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Mar 2012 07:14:57 EDT
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Robert Lee <rob.lee@linaro.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 06/76] ARM: at91: Consolidate time keeping and irq enable
Date: Fri, 30 Mar 2012 06:13:09 -0400
Message-id: <7e348b9012522fa0efd854d20d210d5e57fcedd1.1333101989.git.len.brown@intel.com>
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
 arch/arm/mach-at91/cpuidle.c |   67 +++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 43 deletions(-)

diff --git a/arch/arm/mach-at91/cpuidle.c b/arch/arm/mach-at91/cpuidle.c
index a851e6c..d40b3f3 100644
--- a/arch/arm/mach-at91/cpuidle.c
+++ b/arch/arm/mach-at91/cpuidle.c
@@ -17,9 +17,10 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/cpuidle.h>
-#include <asm/proc-fns.h>
 #include <linux/io.h>
 #include <linux/export.h>
+#include <asm/proc-fns.h>
+#include <asm/cpuidle.h>
 
 #include "pm.h"
 
@@ -27,66 +28,46 @@
 
 static DEFINE_PER_CPU(struct cpuidle_device, at91_cpuidle_device);
 
-static struct cpuidle_driver at91_idle_driver = {
-	.name =         "at91_idle",
-	.owner =        THIS_MODULE,
-};
-
 /* Actual code that puts the SoC in different idle states */
 static int at91_enter_idle(struct cpuidle_device *dev,
 			struct cpuidle_driver *drv,
 			       int index)
 {
-	struct timeval before, after;
-	int idle_time;
 	u32 saved_lpr;
 
-	local_irq_disable();
-	do_gettimeofday(&before);
-	if (index == 0)
-		/* Wait for interrupt state */
-		cpu_do_idle();
-	else if (index == 1) {
-		asm("b 1f; .align 5; 1:");
-		asm("mcr p15, 0, r0, c7, c10, 4");	/* drain write buffer */
-		saved_lpr = sdram_selfrefresh_enable();
-		cpu_do_idle();
-		sdram_selfrefresh_disable(saved_lpr);
-	}
-	do_gettimeofday(&after);
-	local_irq_enable();
-	idle_time = (after.tv_sec - before.tv_sec) * USEC_PER_SEC +
-			(after.tv_usec - before.tv_usec);
+	__asm__("b 1f; .align 5; 1:\n"
+	"	mcr p15, 0, r0, c7, c10, 4");	/* drain write buffer */
+
+	saved_lpr = sdram_selfrefresh_enable();
+	cpu_do_idle();
+	sdram_selfrefresh_disable(saved_lpr);
 
-	dev->last_residency = idle_time;
 	return index;
 }
 
+static struct cpuidle_driver at91_idle_driver = {
+	.name			= "at91_idle",
+	.owner			= THIS_MODULE,
+	.en_core_tk_irqen	= 1,
+	.states[0]		= ARM_CPUIDLE_WFI_STATE,
+	.states[1]		= {
+		.enter			= at91_enter_idle,
+		.exit_latency		= 10,
+		.target_residency	= 100000,
+		.flags			= CPUIDLE_FLAG_TIME_VALID,
+		.name			= "RAM_SR",
+		.desc			= "WFI and DDR Self Refresh",
+	},
+	.state_count = AT91_MAX_STATES,
+};
+
 /* Initialize CPU idle by registering the idle states */
 static int at91_init_cpuidle(void)
 {
 	struct cpuidle_device *device;
-	struct cpuidle_driver *driver = &at91_idle_driver;
 
 	device = &per_cpu(at91_cpuidle_device, smp_processor_id());
 	device->state_count = AT91_MAX_STATES;
-	driver->state_count = AT91_MAX_STATES;
-
-	/* Wait for interrupt state */
-	driver->states[0].enter = at91_enter_idle;
-	driver->states[0].exit_latency = 1;
-	driver->states[0].target_residency = 10000;
-	driver->states[0].flags = CPUIDLE_FLAG_TIME_VALID;
-	strcpy(driver->states[0].name, "WFI");
-	strcpy(driver->states[0].desc, "Wait for interrupt");
-
-	/* Wait for interrupt and RAM self refresh state */
-	driver->states[1].enter = at91_enter_idle;
-	driver->states[1].exit_latency = 10;
-	driver->states[1].target_residency = 10000;
-	driver->states[1].flags = CPUIDLE_FLAG_TIME_VALID;
-	strcpy(driver->states[1].name, "RAM_SR");
-	strcpy(driver->states[1].desc, "WFI and RAM Self Refresh");
 
 	cpuidle_register_driver(&at91_idle_driver);
 
-- 
1.7.10.rc2.19.gfae9d

