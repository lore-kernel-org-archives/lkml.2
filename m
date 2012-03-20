Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab2CTUZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 16:25:07 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33899 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757868Ab2CTUXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 16:23:06 -0400
From: Robert Lee <rob.lee@linaro.org>
To: len.brown@intel.com
Cc: akpm@linux-foundation.org, rjw@sisk.pl, khilman@ti.com,
        robherring2@gmail.com, Baohua.Song@csr.com, amit.kucheria@linaro.org,
        nicolas.ferre@atmel.com, linux@maxim.org.za, kgene.kim@samsung.com,
        amit.kachhap@linaro.org, magnus.damm@gmail.com, nsekhar@ti.com,
        daniel.lezcano@linaro.org, mturquette@linaro.org,
        vincent.guittot@linaro.org, arnd.bergmann@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        deepthi@linux.vnet.ibm.com, broonie@opensource.wolfsonmicro.com,
        nicolas.pitre@linaro.org, linux@arm.linux.org.uk,
        jean.pihet@newoldbits.com, venki@google.com, ccross@google.com,
        g.trinabh@gmail.com, kernel@wantstofly.org, lethal@linux-sh.org,
        jon-hunter@ti.com, tony@atomide.com, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH v8 2/8] ARM: at91: Consolidate time keeping and irq enable
Date: Tue, 20 Mar 2012 15:22:43 -0500
Message-Id: <1332274969-15782-3-git-send-email-rob.lee@linaro.org>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <1332274969-15782-1-git-send-email-rob.lee@linaro.org>
References: <1332274969-15782-1-git-send-email-rob.lee@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable core cpuidle timekeeping and irq enabling and remove that
handling from this code.

Signed-off-by: Robert Lee <rob.lee@linaro.org>
Reviewed-by: Kevin Hilman <khilman@ti.com>
Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Jean Pihet<j-pihet@ti.com>
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
1.7.9.4

