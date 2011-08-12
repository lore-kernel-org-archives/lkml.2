Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab1HLIbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:31:07 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:59380 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753223Ab1HLIah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:30:37 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Philippe Langlais <philippe.langlais@stericsson.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 21/23] mfd/db5500-prcmu: spawn MFD cell for regulator
Date: Fri, 12 Aug 2011 10:30:25 +0200
Message-ID: <1313137825-31279-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Langlais <philippe.langlais@stericsson.com>

This spawns the necessary MFD cells off the DB5500 PRCMU
so that we can register a voltage domain (EPOD) regulator driver
against it.

Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Philippe Langlais <philippe.langlais@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db5500-prcmu.c |   89 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 89 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/db5500-prcmu.c b/drivers/mfd/db5500-prcmu.c
index b7cd655..47fd0e9 100644
--- a/drivers/mfd/db5500-prcmu.c
+++ b/drivers/mfd/db5500-prcmu.c
@@ -20,6 +20,9 @@
 #include <linux/jiffies.h>
 #include <linux/bitops.h>
 #include <linux/platform_device.h>
+#include <linux/mfd/core.h>
+#include <linux/regulator/db5500-prcmu.h>
+#include <linux/regulator/machine.h>
 #include <linux/interrupt.h>
 #include <linux/mfd/dbx500-prcmu.h>
 #include <mach/hardware.h>
@@ -1351,6 +1354,83 @@ void __init db5500_prcmu_early_init(void)
 	}
 }
 
+/*
+ * Power domain switches (ePODs) modeled as regulators for the DB5500 SoC
+ */
+static struct regulator_consumer_supply db5500_vape_consumers[] = {
+	REGULATOR_SUPPLY("v-ape", NULL),
+	REGULATOR_SUPPLY("v-i2c", "nmk-i2c.0"),
+	REGULATOR_SUPPLY("v-i2c", "nmk-i2c.1"),
+	REGULATOR_SUPPLY("v-i2c", "nmk-i2c.2"),
+	REGULATOR_SUPPLY("v-i2c", "nmk-i2c.3"),
+	REGULATOR_SUPPLY("vcore", "sdi0"),
+	REGULATOR_SUPPLY("vcore", "sdi1"),
+	REGULATOR_SUPPLY("vcore", "sdi2"),
+	REGULATOR_SUPPLY("vcore", "sdi3"),
+	REGULATOR_SUPPLY("vcore", "sdi4"),
+	REGULATOR_SUPPLY("vcore", "uart0"),
+	REGULATOR_SUPPLY("vcore", "uart1"),
+	REGULATOR_SUPPLY("vcore", "uart2"),
+	REGULATOR_SUPPLY("vcore", "uart3"),
+};
+
+static struct regulator_consumer_supply db5500_sga_consumers[] = {
+	REGULATOR_SUPPLY("v-mali", NULL),
+};
+
+static struct regulator_consumer_supply db5500_hva_consumers[] = {
+	REGULATOR_SUPPLY("v-hva", NULL),
+};
+
+static struct regulator_consumer_supply db5500_sia_consumers[] = {
+	REGULATOR_SUPPLY("v-sia", "mmio_camera"),
+};
+
+static struct regulator_consumer_supply db5500_disp_consumers[] = {
+	REGULATOR_SUPPLY("vsupply", "b2r2_bus"),
+	REGULATOR_SUPPLY("vsupply", "mcde"),
+};
+
+static struct regulator_consumer_supply db5500_esram12_consumers[] = {
+	REGULATOR_SUPPLY("v-esram12", "mcde"),
+	REGULATOR_SUPPLY("esram12", "cm_control"),
+};
+
+#define DB5500_REGULATOR_SWITCH(lower, upper)                           \
+[DB5500_REGULATOR_SWITCH_##upper] = {                                   \
+	.constraints = {                                                \
+		.valid_ops_mask = REGULATOR_CHANGE_STATUS,              \
+	},                                                              \
+	.consumer_supplies      = db5500_##lower##_consumers,            \
+	.num_consumer_supplies  = ARRAY_SIZE(db5500_##lower##_consumers),\
+}
+
+static struct regulator_init_data db5500_regulators[DB5500_NUM_REGULATORS] = {
+	[DB5500_REGULATOR_VAPE] = {
+		.constraints = {
+			.valid_ops_mask	= REGULATOR_CHANGE_STATUS,
+		},
+		.consumer_supplies	= db5500_vape_consumers,
+		.num_consumer_supplies	= ARRAY_SIZE(db5500_vape_consumers),
+	},
+	DB5500_REGULATOR_SWITCH(sga, SGA),
+	DB5500_REGULATOR_SWITCH(hva, HVA),
+	DB5500_REGULATOR_SWITCH(sia, SIA),
+	DB5500_REGULATOR_SWITCH(disp, DISP),
+	DB5500_REGULATOR_SWITCH(esram12, ESRAM12),
+};
+
+static struct mfd_cell db5500_prcmu_devs[] = {
+	{
+		.name = "db5500-prcmu-regulators",
+		.platform_data = &db5500_regulators,
+		.pdata_size = sizeof(db5500_regulators),
+	},
+	{
+		.name = "cpufreq-u5500",
+	},
+};
+
 /**
  * prcmu_fw_init - arch init call for the Linux PRCMU fw init logic
  *
@@ -1373,6 +1453,15 @@ static int __init db5500_prcmu_probe(struct platform_device *pdev)
 		goto no_irq_return;
 	}
 
+	err = mfd_add_devices(&pdev->dev, 0, db5500_prcmu_devs,
+			      ARRAY_SIZE(db5500_prcmu_devs), NULL,
+			      0);
+
+	if (err)
+		pr_err("prcmu: Failed to add subdevices\n");
+	else
+		pr_info("DB5500 PRCMU initialized\n");
+
 no_irq_return:
 	return err;
 
-- 
1.7.3.2

