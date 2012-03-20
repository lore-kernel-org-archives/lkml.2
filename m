Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964943Ab2CTUX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 16:23:29 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:33025 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964805Ab2CTUXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 16:23:24 -0400
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
Subject: [PATCH v8 7/8] ARM: shmobile: Consolidate time keeping and irq enable
Date: Tue, 20 Mar 2012 15:22:48 -0500
Message-Id: <1332274969-15782-8-git-send-email-rob.lee@linaro.org>
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
 arch/arm/mach-shmobile/cpuidle.c |   31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mach-shmobile/cpuidle.c b/arch/arm/mach-shmobile/cpuidle.c
index 1b23342..ca23b20 100644
--- a/arch/arm/mach-shmobile/cpuidle.c
+++ b/arch/arm/mach-shmobile/cpuidle.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/err.h>
 #include <asm/system.h>
+#include <asm/cpuidle.h>
 #include <asm/io.h>
 
 static void shmobile_enter_wfi(void)
@@ -29,37 +30,19 @@ static int shmobile_cpuidle_enter(struct cpuidle_device *dev,
 				  struct cpuidle_driver *drv,
 				  int index)
 {
-	ktime_t before, after;
-
-	before = ktime_get();
-
-	local_irq_disable();
-	local_fiq_disable();
-
 	shmobile_cpuidle_modes[index]();
 
-	local_irq_enable();
-	local_fiq_enable();
-
-	after = ktime_get();
-	dev->last_residency = ktime_to_ns(ktime_sub(after, before)) >> 10;
-
 	return index;
 }
 
 static struct cpuidle_device shmobile_cpuidle_dev;
 static struct cpuidle_driver shmobile_cpuidle_driver = {
-	.name =		"shmobile_cpuidle",
-	.owner =	THIS_MODULE,
-	.states[0] = {
-		.name = "C1",
-		.desc = "WFI",
-		.exit_latency = 1,
-		.target_residency = 1 * 2,
-		.flags = CPUIDLE_FLAG_TIME_VALID,
-	},
-	.safe_state_index = 0, /* C1 */
-	.state_count = 1,
+	.name			= "shmobile_cpuidle",
+	.owner			= THIS_MODULE,
+	.en_core_tk_irqen	= 1,
+	.states[0]		= ARM_CPUIDLE_WFI_STATE,
+	.safe_state_index	= 0, /* C1 */
+	.state_count		= 1,
 };
 
 void (*shmobile_cpuidle_setup)(struct cpuidle_driver *drv);
-- 
1.7.9.4

