Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804Ab0IHGSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 02:18:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34740 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757336Ab0IHGSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 02:18:20 -0400
Message-ID: <61206.10.24.255.18.1283926699.squirrel@dbdmail.itg.ti.com>
Date: Wed, 8 Sep 2010 11:48:19 +0530 (IST)
Subject: [PATCH V3 2/2] omap4: platform changes for CMA3000
From: "Hemanth V" <hemanthv@ti.com>
To: linux-omap@vger.kernel.org
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8082870cc704d901d98cf0d6af90e45860927ceb Mon Sep 17 00:00:00 2001
From: Hemanth V <hemanthv@ti.com>
Date: Thu, 26 Aug 2010 17:49:12 +0530
Subject: [PATCH] Platform changes for CMA3000 Accelerometer driver

Update 4430 SDP board file with platform data for accelerometer driver
and select the driver in kconfig

Signed-off-by: Hemanth V <hemanthv@ti.com>
---
 arch/arm/mach-omap2/Kconfig         |    2 ++
 arch/arm/mach-omap2/board-4430sdp.c |   30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index a928fd6..e87c049 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -255,6 +255,8 @@ config MACH_OMAP_4430SDP
 	depends on ARCH_OMAP4
 	select INPUT_TOUCHSCREEN
 	select TOUCHSCREEN_SYNTM12XX
+	select INPUT_MISC
+ 	select INPUT_CMA3000_I2C

 config MACH_OMAP4_PANDA
 	bool "OMAP4 Panda Board"
diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index ed78cdb..8b94f1f 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -23,6 +23,8 @@
 #include <linux/gpio_keys.h>
 #include <linux/regulator/machine.h>
 #include <linux/leds.h>
+#include <linux/i2c/cma3000.h>
+#include <linux/interrupt.h>

 #include <mach/hardware.h>
 #include <mach/omap4-common.h>
@@ -44,6 +46,7 @@
 #define ETH_KS8851_QUART		138
 #define OMAP4SDP_MDM_PWR_EN_GPIO	157
 #define OMAP4_SFH7741_SENSOR_OUTPUT_GPIO	184
+#define OMAP4_CMA3000ACCL_GPIO		186
 #define OMAP4_SFH7741_ENABLE_GPIO	188

 static struct gpio_led sdp4430_gpio_leds[] = {
@@ -485,6 +488,27 @@ static struct twl4030_platform_data sdp4430_twldata = {
 	.vaux3		= &sdp4430_vaux3,
 };

+static struct cma3000_platform_data cma3000_platform_data = {
+	.fuzz_x = 25,
+	.fuzz_y = 25,
+	.fuzz_z = 25,
+	.g_range = CMARANGE_8G,
+	.mode = CMAMODE_MOTDET,
+	.mdthr = 0x8,
+	.mdfftmr = 0x33,
+	.ffthr = 0x8,
+	.irqflags = IRQF_TRIGGER_HIGH,
+};
+
+static void omap_cma3000accl_init(void)
+{
+	if (gpio_request(OMAP4_CMA3000ACCL_GPIO, "Accelerometer") < 0) {
+		pr_err("Accelerometer GPIO request failed\n");
+		return;
+	}
+	gpio_direction_input(OMAP4_CMA3000ACCL_GPIO);
+}
+
 static struct i2c_board_info __initdata sdp4430_i2c_boardinfo[] = {
 	{
 		I2C_BOARD_INFO("twl6030", 0x48),
@@ -518,6 +542,11 @@ static struct i2c_board_info __initdata sdp4430_i2c_4_boardinfo[] = {
 	{
 		I2C_BOARD_INFO("hmc5843", 0x1e),
 	},
+	{
+		I2C_BOARD_INFO("cma3000_accl", 0x1c),
+		.platform_data = &cma3000_platform_data,
+		.irq = OMAP_GPIO_IRQ(OMAP4_CMA3000ACCL_GPIO),
+	},
 };

 static const struct ehci_hcd_omap_platform_data ehci_pdata __initconst = {
@@ -570,6 +599,7 @@ static void __init omap_sfh7741prox_init(void)
 			 __func__, OMAP4_SFH7741_ENABLE_GPIO, error);
 		gpio_free(OMAP4_SFH7741_ENABLE_GPIO);
 	}
+	omap_cma3000accl_init();
 }

 static void __init omap_4430sdp_init(void)
-- 
1.5.4.3



