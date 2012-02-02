Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab2BBMRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:17:32 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:34977 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756036Ab2BBMR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:17:28 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dtor@mail.ru>
Cc: Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC 6/7] OMAP: omap4panda: Add fixed regulator for twl6040 needs
Date: Thu,  2 Feb 2012 14:16:58 +0200
Message-Id: <1328185019-29575-7-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1328185019-29575-1-git-send-email-peter.ujfalusi@ti.com>
References: <1328185019-29575-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The twl6040 VIO power is connected to SMPS V1V8, the
V2V1 power is coming from SMPS V2V1 of twl6030.
These are fixed, always on regulators.
Create fixed voltage regulators for these supplies.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/mach-omap2/board-omap4panda.c |   62 +++++++++++++++++++++++++++++++-
 1 files changed, 61 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index da31a72..4d66c60 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -56,6 +56,10 @@
 #define HDMI_GPIO_HPD 60 /* Hot plug pin for HDMI */
 #define HDMI_GPIO_LS_OE 41 /* Level shifter for HDMI */
 
+#define FIXED_REG_VWLAN_ID	0
+#define FIXED_REG_V2V1_ID	1
+#define FIXED_REG_V1V8_ID	2
+
 /* wl127x BT, FM, GPS connectivity chip */
 static int wl1271_gpios[] = {46, -1, -1};
 static struct platform_device wl1271_device = {
@@ -116,10 +120,66 @@ static struct platform_device panda_abe_audio = {
 	},
 };
 
+static struct regulator_consumer_supply panda_vdd_v2v1_supply[] = {
+	REGULATOR_SUPPLY("v2v1", "1-004b"),
+};
+
+static struct regulator_init_data panda_v2v1smps = {
+	.constraints = {
+		.always_on		= true,
+	},
+	.num_consumer_supplies	= ARRAY_SIZE(panda_vdd_v2v1_supply),
+	.consumer_supplies	= panda_vdd_v2v1_supply,
+};
+
+static struct fixed_voltage_config panda_v2v1_pdata = {
+	.supply_name	= "VDD-V2V1",
+	.microvolts	= 2100000,
+	.init_data	= &panda_v2v1smps,
+	.gpio		= -EINVAL,
+};
+
+static struct platform_device panda_v2v1 = {
+	.name		= "reg-fixed-voltage",
+	.id		= FIXED_REG_V2V1_ID,
+	.dev = {
+		.platform_data = &panda_v2v1_pdata,
+	},
+};
+
+static struct regulator_consumer_supply panda_vio_v1v8_supply[] = {
+	REGULATOR_SUPPLY("vio", "1-004b"),
+};
+
+static struct regulator_init_data panda_v1v8smps = {
+	.constraints = {
+		.always_on		= true,
+	},
+	.num_consumer_supplies	= ARRAY_SIZE(panda_vio_v1v8_supply),
+	.consumer_supplies	= panda_vio_v1v8_supply,
+};
+
+static struct fixed_voltage_config panda_v1v8_pdata = {
+	.supply_name	= "VIO-V1V8",
+	.microvolts	= 1800000,
+	.init_data	= &panda_v1v8smps,
+	.gpio		= -EINVAL,
+};
+
+static struct platform_device panda_v1v8 = {
+	.name		= "reg-fixed-voltage",
+	.id		= FIXED_REG_V1V8_ID,
+	.dev = {
+		.platform_data = &panda_v1v8_pdata,
+	},
+};
+
 static struct platform_device *panda_devices[] __initdata = {
 	&leds_gpio,
 	&wl1271_device,
 	&panda_abe_audio,
+	&panda_v1v8,
+	&panda_v2v1,
 };
 
 static const struct usbhs_omap_board_data usbhs_bdata __initconst = {
@@ -218,7 +278,7 @@ static struct fixed_voltage_config panda_vwlan = {
 
 static struct platform_device omap_vwlan_device = {
 	.name		= "reg-fixed-voltage",
-	.id		= 1,
+	.id		= FIXED_REG_VWLAN_ID,
 	.dev = {
 		.platform_data = &panda_vwlan,
 	},
-- 
1.7.8.4

