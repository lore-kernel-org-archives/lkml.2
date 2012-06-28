Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab2F1KUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 06:20:51 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54689 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466Ab2F1KUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 06:20:48 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 1/2] mfd: tps65910: add support for enabling external 32-kHz oscillator
Date: Thu, 28 Jun 2012 12:20:21 +0200
Message-Id: <1340878822-28444-2-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1340878822-28444-1-git-send-email-jhovold@gmail.com>
References: <1340878822-28444-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add flag to platform data to enable external 32-kHz crystal oscillator
(or square wave) input.

The tps6591x can use either an internal 32-kHz RC oscillator or an
external crystal (or square wave) to generate the 32-kHz clock.

The default setting depends on the selected boot mode. In boot mode 00
the internal RC oscillator is used at power-on, but the external crystal
oscillator (or square wave) can be enabled by clearing the ck32k_ctrl
flag in the device control register.

Note that there is no way to switch from the external crystal oscillator
to the internal RC oscillator.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/mfd/tps65910.c       |   21 ++++++++++++++++++++-
 include/linux/mfd/tps65910.h |    1 +
 2 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index be9e07b..b0526b7d 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -68,6 +68,25 @@ static const struct regmap_config tps65910_regmap_config = {
 	.cache_type = REGCACHE_RBTREE,
 };
 
+static int __devinit tps65910_misc_init(struct tps65910 *tps65910,
+					struct tps65910_board *pmic_pdata)
+{
+	struct device *dev = tps65910->dev;
+	int ret;
+
+	if (pmic_pdata->en_ck32k_xtal) {
+		ret = tps65910_reg_clear_bits(tps65910,
+						TPS65910_DEVCTRL,
+						DEVCTRL_CK32K_CTRL_MASK);
+		if (ret < 0) {
+			dev_err(dev, "clear ck32k_ctrl failed: %d\n", ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 static int __devinit tps65910_sleepinit(struct tps65910 *tps65910,
 		struct tps65910_board *pmic_pdata)
 {
@@ -243,7 +262,7 @@ static __devinit int tps65910_i2c_probe(struct i2c_client *i2c,
 	init_data->irq_base = pmic_plat_data->irq_base;
 
 	tps65910_irq_init(tps65910, init_data->irq, init_data);
-
+	tps65910_misc_init(tps65910, pmic_plat_data);
 	tps65910_sleepinit(tps65910, pmic_plat_data);
 
 	return ret;
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index dd8dc0a..a989d2b 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -807,6 +807,7 @@ struct tps65910_board {
 	int irq_base;
 	int vmbch_threshold;
 	int vmbch2_threshold;
+	bool en_ck32k_xtal;
 	bool en_dev_slp;
 	struct tps65910_sleep_keepon_data *slp_keepon;
 	bool en_gpio_sleep[TPS6591X_MAX_NUM_GPIO];
-- 
1.7.8.6

