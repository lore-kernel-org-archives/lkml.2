Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab2BWOQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:16:03 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51729 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab2BWOQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:16:01 -0500
From: Matt Porter <mporter@ti.com>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] ARM: OMAP2+: gpmc-smsc911x: add required smsc911x regulators
Date: Thu, 23 Feb 2012 09:16:04 -0500
Message-Id: <1330006564-13290-1-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes smsc911x support on platforms using gpmc_smsc911x_init().

Commit c7e963f6888816 (net/smsc911x: Add regulator support) added
the requirement that platforms provide vdd33a and vddvario supplies.

Signed-off-by: Matt Porter <mporter@ti.com>
---
Changes for v2:
   - temporary fix to avoid platform device id conflicts
   - add commit summary from the smsc911x regulator support commit
   - incorporate platform device registration error cause reporting
Changes for v3:
   - remove unneeded local variable err

 arch/arm/mach-omap2/gpmc-smsc911x.c |   52 +++++++++++++++++++++++++++++++++++
 1 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc-smsc911x.c b/arch/arm/mach-omap2/gpmc-smsc911x.c
index 9970331..bbb870c 100644
--- a/arch/arm/mach-omap2/gpmc-smsc911x.c
+++ b/arch/arm/mach-omap2/gpmc-smsc911x.c
@@ -19,6 +19,8 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/smsc911x.h>
+#include <linux/regulator/fixed.h>
+#include <linux/regulator/machine.h>
 
 #include <plat/board.h>
 #include <plat/gpmc.h>
@@ -42,6 +44,50 @@ static struct smsc911x_platform_config gpmc_smsc911x_config = {
 	.flags		= SMSC911X_USE_16BIT,
 };
 
+static struct regulator_consumer_supply gpmc_smsc911x_supply[] = {
+	REGULATOR_SUPPLY("vddvario", "smsc911x.0"),
+	REGULATOR_SUPPLY("vdd33a", "smsc911x.0"),
+};
+
+/* Generic regulator definition to satisfy smsc911x */
+static struct regulator_init_data gpmc_smsc911x_reg_init_data = {
+	.constraints = {
+		.min_uV			= 3300000,
+		.max_uV			= 3300000,
+		.valid_modes_mask	= REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask		= REGULATOR_CHANGE_MODE
+					| REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies	= ARRAY_SIZE(gpmc_smsc911x_supply),
+	.consumer_supplies	= gpmc_smsc911x_supply,
+};
+
+static struct fixed_voltage_config gpmc_smsc911x_fixed_reg_data = {
+	.supply_name		= "gpmc_smsc911x",
+	.microvolts		= 3300000,
+	.gpio			= -EINVAL,
+	.startup_delay		= 0,
+	.enable_high		= 0,
+	.enabled_at_boot	= 1,
+	.init_data		= &gpmc_smsc911x_reg_init_data,
+};
+
+/*
+ * Platform device id of 42 is a temporary fix to avoid conflicts
+ * with other reg-fixed-voltage devices. The real fix should
+ * involve the driver core providing a way of dynamically
+ * assigning a unique id on registration for platform devices
+ * in the same name space.
+ */
+static struct platform_device gpmc_smsc911x_regulator = {
+	.name		= "reg-fixed-voltage",
+	.id		= 42,
+	.dev = {
+		.platform_data	= &gpmc_smsc911x_fixed_reg_data,
+	},
+};
+
 /*
  * Initialize smsc911x device connected to the GPMC. Note that we
  * assume that pin multiplexing is done in the board-*.c file,
@@ -55,6 +101,12 @@ void __init gpmc_smsc911x_init(struct omap_smsc911x_platform_data *board_data)
 
 	gpmc_cfg = board_data;
 
+	ret = platform_device_register(&gpmc_smsc911x_regulator);
+	if (ret < 0) {
+		pr_err("Unable to register smsc911x regulators: %d\n", ret);
+		return;
+	}
+
 	if (gpmc_cs_request(gpmc_cfg->cs, SZ_16M, &cs_mem_base) < 0) {
 		pr_err("Failed to request GPMC mem region\n");
 		return;
-- 
1.7.5.4

