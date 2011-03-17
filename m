Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab1CQMZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 08:25:25 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:60878 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752662Ab1CQMZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 08:25:18 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 3/3] regulator: add ab8500 enable and raise time delays
Date: Thu, 17 Mar 2011 13:25:02 +0100
Message-ID: <1300364702-27629-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This uses the new infrastructure to provide proper delays when
enabling or setting the voltage of one specific regulator.

Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/regulator/ab8500.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index d157146..02f3c23 100644
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
+static int ab8500_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
+					     unsigned int old_sel,
+					     unsigned int new_sel)
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
+	.set_voltage_time_sel = ab8500_regulator_set_voltage_time_sel,
 };
 
 static int ab8500_fixed_get_voltage(struct regulator_dev *rdev)
@@ -317,6 +344,8 @@ static struct regulator_ops ab8500_regulator_fixed_ops = {
 	.is_enabled	= ab8500_regulator_is_enabled,
 	.get_voltage	= ab8500_fixed_get_voltage,
 	.list_voltage	= ab8500_list_voltage,
+	.enable_time	= ab8500_regulator_enable_time,
+	.set_voltage_time_sel = ab8500_regulator_set_voltage_time_sel,
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

