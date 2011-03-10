Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab1CJNoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 08:44:12 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:53241 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752575Ab1CJNoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 08:44:10 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/4] regulator: add ab8500 per-regulator startup delay
Date: Thu, 10 Mar 2011 14:43:41 +0100
Message-ID: <1299764621-2532-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

Since some regulators can take some time to come online, we
define a per-regulator millisecond delay value and assign
to the slow TV-out regulator.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/regulator/ab8500.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 5a77630..4e11980 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/err.h>
+#include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/ab8500.h>
 #include <linux/mfd/abx500.h>
@@ -38,6 +39,7 @@
  * @voltage_mask: mask to control regulator voltage
  * @voltages: supported voltage table
  * @voltages_len: number of supported voltages for the regulator
+ * @delay: startup delay in ms
  */
 struct ab8500_regulator_info {
 	struct device		*dev;
@@ -55,6 +57,7 @@ struct ab8500_regulator_info {
 	u8 voltage_mask;
 	int const *voltages;
 	int voltages_len;
+	unsigned int delay;
 };
 
 /* voltage tables for the vauxn/vintcore supplies */
@@ -115,6 +118,8 @@ static int ab8500_regulator_enable(struct regulator_dev *rdev)
 		dev_err(rdev_get_dev(rdev),
 			"couldn't set enable bits for regulator\n");
 
+	msleep(info->delay);
+
 	dev_vdbg(rdev_get_dev(rdev),
 		"%s-enable (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
 		info->desc.name, info->update_bank, info->update_reg,
@@ -140,6 +145,8 @@ static int ab8500_regulator_disable(struct regulator_dev *rdev)
 		dev_err(rdev_get_dev(rdev),
 			"couldn't set disable bits for regulator\n");
 
+	msleep(info->delay);
+
 	dev_vdbg(rdev_get_dev(rdev),
 		"%s-disable (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
 		info->desc.name, info->update_bank, info->update_reg,
@@ -281,6 +288,8 @@ static int ab8500_regulator_set_voltage(struct regulator_dev *rdev,
 		dev_err(rdev_get_dev(rdev),
 		"couldn't set voltage reg for regulator\n");
 
+	msleep(info->delay);
+
 	dev_vdbg(rdev_get_dev(rdev),
 		"%s-set_voltage (bank, reg, mask, value): 0x%x, 0x%x, 0x%x,"
 		" 0x%x\n",
@@ -426,6 +435,7 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 		},
+		.delay			= 10,
 		.fixed_uV		= 2000000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
-- 
1.7.3.2

