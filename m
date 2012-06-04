Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab2FDH1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 03:27:20 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:59066 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab2FDH1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 03:27:19 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18aqLxgeUjc0KbAyBxJcTnJ
Date: Mon, 4 Jun 2012 00:27:16 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lauri Leukkunen <lauri.leukkunen@nokia.com>,
        Sebastian Reichel <sre@debian.org>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Ameya Palande <ameya.palande@nokia.com>
Subject: [PATCH] ARM: OMAP: Fix lis3lv02d accelerometer to use gpio_to_irq
Message-ID: <20120604072715.GW12766@atomide.com>
References: <1621273.5PNGJFOirm@pali>
 <20120509000734.GZ5088@atomide.com>
 <20120521160840.GK17852@atomide.com>
 <11538481.hbXYTSlcIX@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11538481.hbXYTSlcIX@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3b511201 (ARM: OMAP: rx51: Platform support for lis3lv02d accelerometer)
added support for lis3lv02d accelerometer.

The patch was still using OMAP_GPIO_IRQ which no longer exists.

Fix it by using gpio_to_irq().

Signed-off-by: Tony Lindgren <tony@atomide.com>

---

Here's this one fixed. Compile and boot tested only, I don't have
physical access to my n900 right now.

--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -144,7 +144,6 @@ static struct lis3lv02d_platform_data rx51_lis3lv02d_data = {
 	.release_resources = lis302_release,
 	.st_min_limits = {-32, 3, 3},
 	.st_max_limits = {-3, 32, 32},
-	.irq2 = OMAP_GPIO_IRQ(LIS302_IRQ2_GPIO),
 };
 #endif
 
@@ -1030,7 +1029,6 @@ static struct i2c_board_info __initdata rx51_peripherals_i2c_board_info_3[] = {
 	{
 		I2C_BOARD_INFO("lis3lv02d", 0x1d),
 		.platform_data = &rx51_lis3lv02d_data,
-		.irq = OMAP_GPIO_IRQ(LIS302_IRQ1_GPIO),
 	},
 #endif
 };
@@ -1056,6 +1054,10 @@ static int __init rx51_i2c_init(void)
 	omap_pmic_init(1, 2200, "twl5030", INT_34XX_SYS_NIRQ, &rx51_twldata);
 	omap_register_i2c_bus(2, 100, rx51_peripherals_i2c_board_info_2,
 			      ARRAY_SIZE(rx51_peripherals_i2c_board_info_2));
+#if defined(CONFIG_SENSORS_LIS3_I2C) || defined(CONFIG_SENSORS_LIS3_I2C_MODULE)
+	rx51_lis3lv02d_data.irq2 = gpio_to_irq(LIS302_IRQ2_GPIO);
+	rx51_peripherals_i2c_board_info_3[0].irq = gpio_to_irq(LIS302_IRQ1_GPIO);
+#endif
 	omap_register_i2c_bus(3, 400, rx51_peripherals_i2c_board_info_3,
 			      ARRAY_SIZE(rx51_peripherals_i2c_board_info_3));
 	return 0;
