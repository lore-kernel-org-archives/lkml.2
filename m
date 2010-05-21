Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab0EUGxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 02:53:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33772 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758173Ab0EUGxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 02:53:05 -0400
Message-ID: <15504.10.24.255.17.1274424784.squirrel@dbdmail.itg.ti.com>
Date: Fri, 21 May 2010 12:23:04 +0530 (IST)
Subject: [RFC ] [PATCH  V2  2/2] Platform changes for CMA3000
From: "Hemanth V" <hemanthv@ti.com>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
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

From: Hemanth V <hemanthv@ti.com>
Date: Thu, 20 May 2010 20:33:03 +0530
Subject: [PATCH] Platform changes for CMA3000 Accelerometer driver


Signed-off-by: Hemanth V <hemanthv@ti.com>
---
 arch/arm/mach-omap2/board-4430sdp.c |   37 ++++++++++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index 3005558..b5b3d0b 100755
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -19,9 +19,11 @@
 #include <linux/gpio.h>
 #include <linux/usb/otg.h>
 #include <linux/i2c/twl.h>
+#include <linux/i2c/cma3000.h>
 #include <linux/regulator/machine.h>
 #include <linux/spi/spi.h>
 #include <linux/input.h>
+#include <linux/interrupt.h>
 #include <linux/input/matrix_keypad.h>
 #include <linux/input/sfh7741.h>

@@ -66,6 +68,8 @@ static struct platform_device sdp4430_proximity_device = {
 	},
 };

+#define OMAP4_CMA3000ACCL_GPIO		186
+
 static int sdp4430_keymap[] = {
 	KEY(0, 0, KEY_E),
 	KEY(0, 1, KEY_R),
@@ -575,6 +579,18 @@ static struct twl4030_platform_data sdp4430_twldata = {
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
 static struct i2c_board_info __initdata sdp4430_i2c_boardinfo[] = {
 	{
 		I2C_BOARD_INFO("twl6030", 0x48),
@@ -598,6 +614,14 @@ static struct i2c_board_info __initdata sdp4430_i2c_3_boardinfo[] = {
 	},
 };

+static struct i2c_board_info __initdata sdp4430_i2c_4_boardinfo[] = {
+	{
+		I2C_BOARD_INFO("cma3000_accl", 0x1c),
+		.platform_data = &cma3000_platform_data,
+		.irq = OMAP_GPIO_IRQ(OMAP4_CMA3000ACCL_GPIO),
+	},
+};
+
 static int __init omap4_i2c_init(void)
 {
 	/* Phoenix Audio IC needs I2C1 to start with 400 KHz and less */
@@ -607,7 +631,8 @@ static int __init omap4_i2c_init(void)
 				ARRAY_SIZE(sdp4430_i2c_2_boardinfo));
 	omap_register_i2c_bus(3, 400, sdp4430_i2c_3_boardinfo,
 				ARRAY_SIZE(sdp4430_i2c_3_boardinfo));
-	omap_register_i2c_bus(4, 400, NULL, 0);
+	omap_register_i2c_bus(4, 400, sdp4430_i2c_4_boardinfo,
+				ARRAY_SIZE(sdp4430_i2c_4_boardinfo));
 	return 0;
 }

@@ -661,6 +686,15 @@ fail1:
 	gpio_free(OMAP4_SFH7741_SENSOR_OUTPUT_GPIO);
 }

+static void omap_cma3000accl_init(void)
+{
+	if (gpio_request(OMAP4_CMA3000ACCL_GPIO, "Accelerometer") < 0) {
+		pr_err("Accelerometer GPIO request failed\n");
+		return;
+	}
+	gpio_direction_input(OMAP4_CMA3000ACCL_GPIO);
+}
+
 static void __init omap_4430sdp_init(void)
 {
 	int status;
@@ -686,6 +720,7 @@ static void __init omap_4430sdp_init(void)
 				ARRAY_SIZE(sdp4430_spi_board_info));
 	}
 	omap_sfh7741prox_init();
+	omap_cma3000accl_init();
 }

 static void __init omap_4430sdp_map_io(void)
-- 
1.5.6.3



