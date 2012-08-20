Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab2HTBId (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 21:08:33 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5164 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab2HTBIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 21:08:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 19 Aug 2012 18:02:45 -0700
From: Bill Huang <bilhuang@nvidia.com>
To: <sameo@linux.intel.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>
CC: <broonie@opensource.wolfsonmicro.com>, <ldewangan@nvidia.com>,
        <thierry.reding@avionic-design.de>, <swarren@wwwdotorg.org>,
        <xxie@nvidia.com>, <lrg@slimlogic.co.uk>, <jhovold@gmail.com>,
        <kyle.manna@fuel7.com>, <rklein@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Bill Huang <bilhuang@nvidia.com>
Subject: [PATCH v2 2/2] mfd: dt: tps65910: add power off control
Date: Sun, 19 Aug 2012 18:07:56 -0700
Message-ID: <1345424876-4365-3-git-send-email-bilhuang@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1345424876-4365-1-git-send-email-bilhuang@nvidia.com>
References: <1345424876-4365-1-git-send-email-bilhuang@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT property "ti,system-power-controller" telling whether or not this
pmic is in charge of controlling the system power, so the power off
routine can be hooked up to system call "pm_power_off".

Based on the work by:
Dan Willemsen <dwillemsen@nvidia.com>

Signed-off-by: Bill Huang <bilhuang@nvidia.com>
Tested-by: Stephen Warren <swarren@wwwdotorg.org>
---
 Documentation/devicetree/bindings/mfd/tps65910.txt |    4 +++
 drivers/mfd/tps65910.c                             |   22 ++++++++++++++++++++
 include/linux/mfd/tps65910.h                       |    3 ++
 3 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/tps65910.txt b/Documentation/devicetree/bindings/mfd/tps65910.txt
index db03599..2e33048 100644
--- a/Documentation/devicetree/bindings/mfd/tps65910.txt
+++ b/Documentation/devicetree/bindings/mfd/tps65910.txt
@@ -59,6 +59,8 @@ Optional properties:
   in TPS6591X datasheet)
 - ti,en-gpio-sleep: enable sleep control for gpios
   There should be 9 entries here, one for each gpio.
+- ti,system-power-controller: Telling whether or not this pmic is controlling
+  the system power.
 
 Regulator Optional properties:
 - ti,regulator-ext-sleep-control: enable external sleep
@@ -79,6 +81,8 @@ Example:
 		#interrupt-cells = <2>;
 		interrupt-controller;
 
+		ti,system-power-controller;
+
 		ti,vmbch-threshold = 0;
 		ti,vmbch2-threshold = 0;
 		ti,en-ck32k-xtal;
diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 1c56379..574ae2b 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -198,6 +198,8 @@ static struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
 
 	board_info->irq = client->irq;
 	board_info->irq_base = -1;
+	board_info->pm_off = of_property_read_bool(np,
+			"ti,system-power-controller");
 
 	return board_info;
 }
@@ -210,6 +212,21 @@ struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
 }
 #endif
 
+static struct i2c_client *tps65910_i2c_client;
+static void tps65910_power_off(void)
+{
+	struct tps65910 *tps65910;
+
+	tps65910 = dev_get_drvdata(&tps65910_i2c_client->dev);
+
+	if (tps65910_reg_set_bits(tps65910, TPS65910_DEVCTRL,
+			DEVCTRL_PWR_OFF_MASK) < 0)
+		return;
+
+	tps65910_reg_clear_bits(tps65910, TPS65910_DEVCTRL,
+			DEVCTRL_DEV_ON_MASK);
+}
+
 static __devinit int tps65910_i2c_probe(struct i2c_client *i2c,
 					const struct i2c_device_id *id)
 {
@@ -267,6 +284,11 @@ static __devinit int tps65910_i2c_probe(struct i2c_client *i2c,
 	tps65910_ck32k_init(tps65910, pmic_plat_data);
 	tps65910_sleepinit(tps65910, pmic_plat_data);
 
+	if (pmic_plat_data->pm_off && !pm_power_off) {
+		tps65910_i2c_client = i2c;
+		pm_power_off = tps65910_power_off;
+	}
+
 	return ret;
 }
 
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 9bf8767..ac772b3 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -366,6 +366,8 @@
 
 
 /*Register DEVCTRL  (0x80) register.RegisterDescription */
+#define DEVCTRL_PWR_OFF_MASK				0x80
+#define DEVCTRL_PWR_OFF_SHIFT				7
 #define DEVCTRL_RTC_PWDN_MASK				0x40
 #define DEVCTRL_RTC_PWDN_SHIFT				6
 #define DEVCTRL_CK32K_CTRL_MASK				0x20
@@ -809,6 +811,7 @@ struct tps65910_board {
 	int vmbch2_threshold;
 	bool en_ck32k_xtal;
 	bool en_dev_slp;
+	bool pm_off;
 	struct tps65910_sleep_keepon_data *slp_keepon;
 	bool en_gpio_sleep[TPS6591X_MAX_NUM_GPIO];
 	unsigned long regulator_ext_sleep_control[TPS65910_NUM_REGS];
-- 
1.7.4.1

