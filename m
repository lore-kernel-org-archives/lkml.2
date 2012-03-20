Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab2CTUXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 16:23:22 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:37855 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912Ab2CTUXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 16:23:11 -0400
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
Subject: [PATCH v8 3/8] ARM: kirkwood: Consolidate time keeping and irq enable
Date: Tue, 20 Mar 2012 15:22:44 -0500
Message-Id: <1332274969-15782-4-git-send-email-rob.lee@linaro.org>
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
 arch/arm/mach-kirkwood/cpuidle.c |   72 +++++++++++---------------------------
 1 file changed, 21 insertions(+), 51 deletions(-)

diff --git a/arch/arm/mach-kirkwood/cpuidle.c b/arch/arm/mach-kirkwood/cpuidle.c
index 7088180..0f17109 100644
--- a/arch/arm/mach-kirkwood/cpuidle.c
+++ b/arch/arm/mach-kirkwood/cpuidle.c
@@ -20,77 +20,47 @@
 #include <linux/io.h>
 #include <linux/export.h>
 #include <asm/proc-fns.h>
+#include <asm/cpuidle.h>
 #include <mach/kirkwood.h>
 
 #define KIRKWOOD_MAX_STATES	2
 
-static struct cpuidle_driver kirkwood_idle_driver = {
-	.name =         "kirkwood_idle",
-	.owner =        THIS_MODULE,
-};
-
-static DEFINE_PER_CPU(struct cpuidle_device, kirkwood_cpuidle_device);
-
 /* Actual code that puts the SoC in different idle states */
 static int kirkwood_enter_idle(struct cpuidle_device *dev,
 				struct cpuidle_driver *drv,
 			       int index)
 {
-	struct timeval before, after;
-	int idle_time;
-
-	local_irq_disable();
-	do_gettimeofday(&before);
-	if (index == 0)
-		/* Wait for interrupt state */
-		cpu_do_idle();
-	else if (index == 1) {
-		/*
-		 * Following write will put DDR in self refresh.
-		 * Note that we have 256 cycles before DDR puts it
-		 * self in self-refresh, so the wait-for-interrupt
-		 * call afterwards won't get the DDR from self refresh
-		 * mode.
-		 */
-		writel(0x7, DDR_OPERATION_BASE);
-		cpu_do_idle();
-	}
-	do_gettimeofday(&after);
-	local_irq_enable();
-	idle_time = (after.tv_sec - before.tv_sec) * USEC_PER_SEC +
-			(after.tv_usec - before.tv_usec);
-
-	/* Update last residency */
-	dev->last_residency = idle_time;
+	writel(0x7, DDR_OPERATION_BASE);
+	cpu_do_idle();
 
 	return index;
 }
 
+static struct cpuidle_driver kirkwood_idle_driver = {
+	.name			= "kirkwood_idle",
+	.owner			= THIS_MODULE,
+	.en_core_tk_irqen	= 1,
+	.states[0]		= ARM_CPUIDLE_WFI_STATE,
+	.states[1]		= {
+		.enter			= kirkwood_enter_idle,
+		.exit_latency		= 10,
+		.target_residency	= 100000,
+		.flags			= CPUIDLE_FLAG_TIME_VALID,
+		.name			= "DDR SR",
+		.desc			= "WFI and DDR Self Refresh",
+	},
+	.state_count = KIRKWOOD_MAX_STATES,
+};
+
+static DEFINE_PER_CPU(struct cpuidle_device, kirkwood_cpuidle_device);
+
 /* Initialize CPU idle by registering the idle states */
 static int kirkwood_init_cpuidle(void)
 {
 	struct cpuidle_device *device;
-	struct cpuidle_driver *driver = &kirkwood_idle_driver;
 
 	device = &per_cpu(kirkwood_cpuidle_device, smp_processor_id());
 	device->state_count = KIRKWOOD_MAX_STATES;
-	driver->state_count = KIRKWOOD_MAX_STATES;
-
-	/* Wait for interrupt state */
-	driver->states[0].enter = kirkwood_enter_idle;
-	driver->states[0].exit_latency = 1;
-	driver->states[0].target_residency = 10000;
-	driver->states[0].flags = CPUIDLE_FLAG_TIME_VALID;
-	strcpy(driver->states[0].name, "WFI");
-	strcpy(driver->states[0].desc, "Wait for interrupt");
-
-	/* Wait for interrupt and DDR self refresh state */
-	driver->states[1].enter = kirkwood_enter_idle;
-	driver->states[1].exit_latency = 10;
-	driver->states[1].target_residency = 10000;
-	driver->states[1].flags = CPUIDLE_FLAG_TIME_VALID;
-	strcpy(driver->states[1].name, "DDR SR");
-	strcpy(driver->states[1].desc, "WFI and DDR Self Refresh");
 
 	cpuidle_register_driver(&kirkwood_idle_driver);
 	if (cpuidle_register_device(device)) {
-- 
1.7.9.4

