Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458Ab2CGNSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 08:18:52 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10395 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757792Ab2CGNSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 08:18:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 07 Mar 2012 05:18:49 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        jedu@slimlogic.co.uk, lrg@ti.com
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        ldewangan@nvidia.com
Subject: [PATCH V2 2/2] mfd: tps65910: Add support for device sleep
Date: Wed,  7 Mar 2012 18:46:06 +0530
Message-Id: <1331126166-3908-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1331126166-3908-1-git-send-email-ldewangan@nvidia.com>
References: <1331126166-3908-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for device sleep through the external
input control signal "SLEEP".
Changing the SLEEP signal state can switch the device
into SLEEP and ACTIVE state.
Also adding sleep configuration for different resources
so that they should be keep on during sleep state of
device.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/tps65910.c       |   62 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/tps65910.h |   14 +++++++++
 2 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index bf2b25e..ae7f47b 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -90,6 +90,66 @@ static const struct regmap_config tps65910_regmap_config = {
 	.cache_type = REGCACHE_RBTREE,
 };
 
+static int __init tps65910_sleepinit(struct tps65910 *tps65910,
+		struct tps65910_board *pmic_pdata)
+{
+	struct device *dev = NULL;
+	int ret = 0;
+
+	dev = tps65910->dev;
+
+	if (!pmic_pdata->en_dev_slp)
+		return 0;
+
+	/* enabling SLEEP device state */
+	ret = tps65910_set_bits(tps65910, TPS65910_DEVCTRL,
+				DEVCTRL_DEV_SLP_MASK);
+	if (ret < 0) {
+		dev_err(dev, "set dev_slp failed: %d\n", ret);
+		goto err_sleep_init;
+	}
+
+	/* Return if there is no sleep keepon data. */
+	if (!pmic_pdata->slp_keepon)
+		return 0;
+
+	if (pmic_pdata->slp_keepon->therm_keepon) {
+		ret = tps65910_set_bits(tps65910, TPS65910_SLEEP_KEEP_RES_ON,
+				SLEEP_KEEP_RES_ON_THERM_KEEPON_MASK);
+		if (ret < 0) {
+			dev_err(dev, "set therm_keepon failed: %d\n", ret);
+			goto disable_dev_slp;
+		}
+	}
+
+	if (pmic_pdata->slp_keepon->clkout32k_keepon) {
+		ret = tps65910_set_bits(tps65910, TPS65910_SLEEP_KEEP_RES_ON,
+				SLEEP_KEEP_RES_ON_CLKOUT32K_KEEPON_MASK);
+		if (ret < 0) {
+			dev_err(dev, "set clkout32k_keepon failed: %d\n", ret);
+			goto disable_dev_slp;
+		}
+	}
+
+	if (pmic_pdata->slp_keepon->i2chs_keepon) {
+		ret = tps65910_set_bits(tps65910, TPS65910_SLEEP_KEEP_RES_ON,
+				SLEEP_KEEP_RES_ON_I2CHS_KEEPON_MASK);
+		if (ret < 0) {
+			dev_err(dev, "set i2chs_keepon failed: %d\n", ret);
+			goto disable_dev_slp;
+		}
+	}
+
+	return 0;
+
+disable_dev_slp:
+	tps65910_clear_bits(tps65910, TPS65910_DEVCTRL, DEVCTRL_DEV_SLP_MASK);
+
+err_sleep_init:
+	return ret;
+}
+
+
 static int tps65910_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
@@ -140,6 +200,8 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 
 	tps65910_irq_init(tps65910, init_data->irq, init_data);
 
+	tps65910_sleepinit(tps65910, pmic_plat_data);
+
 	kfree(init_data);
 	return ret;
 
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 06a4cd6..3c87d40 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -782,6 +782,18 @@
 /* TPS65911 names the EN3 signal as SLEEP */
 #define TPS65911_SLEEP_CONTROL_EXT_INPUT_SLEEP		0x4
 
+/*
+ * Sleep keepon data: Maintains the state in sleep mode
+ * @therm_keepon: Keep on the thermal monitoring in sleep state.
+ * @clkout32k_keepon: Keep on the 32KHz clock output in sleep state.
+ * @i2chs_keepon: Keep on high speed internal clock in sleep state.
+ */
+struct tps65910_sleep_keepon_data {
+	unsigned therm_keepon:1;
+	unsigned clkout32k_keepon:1;
+	unsigned i2chs_keepon:1;
+};
+
 /**
  * struct tps65910_board
  * Board platform data may be used to initialize regulators.
@@ -793,6 +805,8 @@ struct tps65910_board {
 	int irq_base;
 	int vmbch_threshold;
 	int vmbch2_threshold;
+	bool en_dev_slp;
+	struct tps65910_sleep_keepon_data *slp_keepon;
 	unsigned long regulator_ext_sleep_control[TPS65910_NUM_REGS];
 	bool en_gpio_sleep[TPS6591X_MAX_NUM_GPIO];
 	struct regulator_init_data *tps65910_pmic_init_data[TPS65910_NUM_REGS];
-- 
1.7.1.1

