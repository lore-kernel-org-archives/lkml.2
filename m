Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3AJQwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:52:13 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56261 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279Ab3AJQwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:52:10 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <sameo@linux.intel.com>, <tony@atomide.com>,
        <kishon@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>
Subject: [PATCH 12/14] ARM: OMAP2+: omap4panda: Adapt HUB power to regulator framework
Date: Thu, 10 Jan 2013 18:51:32 +0200
Message-ID: <1357836694-30788-13-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357836694-30788-1-git-send-email-rogerq@ti.com>
References: <1357836694-30788-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We model the HUB_POWER GPIO as a fixed regulator device. This regulator
is then used as "vcc" supply for the USB PHY device and is managed
by the PHY driver.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-omap4panda.c |   38 +++++++++++++++++++++++++++----
 1 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index 350c4db..a4831cc 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -132,12 +132,45 @@ static struct platform_device btwilink_device = {
 	.id	= -1,
 };
 
+/* Regulator for USB HUB supply */
+static struct regulator_consumer_supply hub_power_supplies[] = {
+/* Link PHY device to USB HUB supply so it gets enabled in the PHY driver */
+	REGULATOR_SUPPLY("vcc", "nop_usb_xceiv.0"),
+};
+
+static struct regulator_init_data hub_power_data = {
+	.constraints = {
+		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	},
+	.consumer_supplies	= hub_power_supplies,
+	.num_consumer_supplies	= ARRAY_SIZE(hub_power_supplies),
+};
+
+static struct fixed_voltage_config hub_power_config = {
+	.supply_name    = "vhub",
+	.microvolts = 3300000,
+	.gpio = GPIO_HUB_POWER,
+	.startup_delay = 70000, /* 70msec */
+	.enable_high = 1,
+	.enabled_at_boot = 0,
+	.init_data = &hub_power_data,
+};
+
+static struct platform_device hub_power_device = {
+	.name	= "reg-fixed-voltage",
+	.id	= 2,
+	.dev = {
+		.platform_data = &hub_power_config,
+	},
+};
+
 static struct platform_device *panda_devices[] __initdata = {
 	&leds_gpio,
 	&wl1271_device,
 	&panda_abe_audio,
 	&panda_hdmi_audio_codec,
 	&btwilink_device,
+	&hub_power_device,
 };
 
 static struct nop_usb_xceiv_platform_data phy_pdata0 = {
@@ -164,7 +197,6 @@ static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 };
 
 static struct gpio panda_ehci_gpios[] __initdata = {
-	{ GPIO_HUB_POWER,	GPIOF_OUT_INIT_LOW,  "hub_power"  },
 	{ GPIO_HUB_NRESET,	GPIOF_OUT_INIT_LOW,  "hub_nreset" },
 };
 
@@ -180,7 +212,6 @@ static void __init omap4_ehci_init(void)
 		return;
 	}
 
-	gpio_export(GPIO_HUB_POWER, 0);
 	gpio_export(GPIO_HUB_NRESET, 0);
 	gpio_set_value(GPIO_HUB_NRESET, 1);
 
@@ -190,9 +221,6 @@ static void __init omap4_ehci_init(void)
 		pr_err("Failed to add main_clk alias to auxclk3_ck\n");
 
 	usbhs_init(&usbhs_bdata);
-
-	/* enable power to hub */
-	gpio_set_value(GPIO_HUB_POWER, 1);
 }
 
 static struct omap_musb_board_data musb_board_data = {
-- 
1.7.4.1

