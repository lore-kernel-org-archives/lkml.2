Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab2BHWG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 17:06:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38825 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab2BHWG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 17:06:57 -0500
From: Matt Porter <matt@ohporter.com>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] omap: board-omap3evm: add required smsc911x regulators
Date: Wed,  8 Feb 2012 17:06:21 -0500
Message-Id: <1328738812-26755-1-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes smsc911x support on omap3evm that has been broken since
the smsc911x driver was updated to require the existence of vdd33a
and vddvario supplies.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 arch/arm/mach-omap2/board-omap3evm.c |   46 +++++++++++++++++++++++++++++++++-
 1 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index 003fe34..ca63dda 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -433,9 +433,10 @@ static struct twl4030_keypad_data omap3evm_kp_data = {
 /* ads7846 on SPI */
 static struct regulator_consumer_supply omap3evm_vio_supply[] = {
 	REGULATOR_SUPPLY("vcc", "spi1.0"),
+	REGULATOR_SUPPLY("vddvario", "smsc911x.0"),
 };
 
-/* VIO for ads7846 */
+/* VIO for ads7846, smsc911x, etc. */
 static struct regulator_init_data omap3evm_vio = {
 	.constraints = {
 		.min_uV			= 1800000,
@@ -450,6 +451,47 @@ static struct regulator_init_data omap3evm_vio = {
 	.consumer_supplies	= omap3evm_vio_supply,
 };
 
+/* OSK_3V3 for DVI, smsc911x, and expansion peripherals */
+static struct regulator_consumer_supply omap3evm_osk_3v3_supply[] = {
+	REGULATOR_SUPPLY("vdd33a", "smsc911x.0"),
+};
+
+static struct regulator_init_data omap3evm_osk_3v3 = {
+	.constraints = {
+		.min_uV			= 3300000,
+		.max_uV			= 3300000,
+		.valid_modes_mask	= REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask		= REGULATOR_CHANGE_MODE
+					| REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies	= ARRAY_SIZE(omap3evm_osk_3v3_supply),
+	.consumer_supplies	= omap3evm_osk_3v3_supply,
+};
+
+/*
+ * TWL4030 GPIO15 can control this regulator, but it is treated
+ * as always on since it is pulled down, enabling this regulator
+ * by default.
+ */
+static struct fixed_voltage_config omap3evm_osk_regulator_data = {
+	.supply_name		= "osk_3v3",
+	.microvolts		= 3300000, /* 3.30V */
+	.gpio			= -EINVAL,
+	.startup_delay		= 0,
+	.enable_high		= 0,
+	.enabled_at_boot	= 1,
+	.init_data		= &omap3evm_osk_3v3,
+};
+
+static struct platform_device omap3evm_osk_regulator = {
+	.name		= "reg-fixed-voltage",
+	.id		= 0,
+	.dev = {
+		.platform_data	= &omap3evm_osk_regulator_data,
+	},
+};
+
 #ifdef CONFIG_WL12XX_PLATFORM_DATA
 
 #define OMAP3EVM_WLAN_PMENA_GPIO	(150)
@@ -631,6 +673,8 @@ static void __init omap3_evm_init(void)
 
 	omap3_evm_i2c_init();
 
+	platform_device_register(&omap3evm_osk_regulator);
+
 	omap_display_init(&omap3_evm_dss_data);
 
 	omap_serial_init();
-- 
1.7.5.4

