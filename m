Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab1CKKzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 05:55:03 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:55408 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751948Ab1CKKyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 05:54:46 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/4] regulator: add ab8500 enable and raise time delays
Date: Fri, 11 Mar 2011 11:54:37 +0100
Message-ID: <1299840877-20646-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This uses the new infrastructure to provide proper delays when
enabling or setting the voltage of one specific regulator.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/regulator/ab8500.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 5a77630..ff2c51f 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -38,6 +38,7 @@
  * @voltage_mask: mask to control regulator voltage
  * @voltages: supported voltage table
  * @voltages_len: number of supported voltages for the regulator
+ * @delay: startup/set voltage delay in us
  */
 struct ab8500_regulator_info {
 	struct device		*dev;
@@ -55,6 +56,7 @@ struct ab8500_regulator_info {
 	u8 voltage_mask;
 	int const *voltages;
 	int voltages_len;
+	unsigned int delay;
 };
 
 /* voltage tables for the vauxn/vintcore supplies */
@@ -290,6 +292,29 @@ static int ab8500_regulator_set_voltage(struct regulator_dev *rdev,
 	return ret;
 }
 
+static int ab8500_regulator_enable_time(struct regulator_dev *rdev)
+{
+	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+
+	return info->delay;
+}
+
+static int ab8500_regulator_set_voltage_time(struct regulator_dev *rdev,
+					     int old_voltage,
+					     int new_voltage)
+{
+	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+	int ret;
+
+	/* If the regulator isn't on, it won't take time here */
+	ret = ab8500_regulator_is_enabled(rdev);
+	if (ret < 0)
+		return ret;
+	if (!ret)
+		return 0;
+	return info->delay;
+}
+
 static struct regulator_ops ab8500_regulator_ops = {
 	.enable		= ab8500_regulator_enable,
 	.disable	= ab8500_regulator_disable,
@@ -297,6 +322,8 @@ static struct regulator_ops ab8500_regulator_ops = {
 	.get_voltage	= ab8500_regulator_get_voltage,
 	.set_voltage	= ab8500_regulator_set_voltage,
 	.list_voltage	= ab8500_list_voltage,
+	.enable_time	= ab8500_regulator_enable_time,
+	.set_voltage_time = ab8500_regulator_set_voltage_time,
 };
 
 static int ab8500_fixed_get_voltage(struct regulator_dev *rdev)
@@ -317,6 +344,8 @@ static struct regulator_ops ab8500_regulator_fixed_ops = {
 	.is_enabled	= ab8500_regulator_is_enabled,
 	.get_voltage	= ab8500_fixed_get_voltage,
 	.list_voltage	= ab8500_list_voltage,
+	.enable_time	= ab8500_regulator_enable_time,
+	.set_voltage_time = ab8500_regulator_set_voltage_time,
 };
 
 static struct ab8500_regulator_info
@@ -426,6 +455,7 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 		},
+		.delay			= 10000,
 		.fixed_uV		= 2000000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
-- 
1.7.3.2

