Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab0LUFEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 00:04:51 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:13329 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab0LUFEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 00:04:48 -0500
Date: Tue, 21 Dec 2010 14:04:40 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 2/2] regulator: max8952 - support hibernation
In-reply-to: <1292907880-3353-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Axel Lin <axel.lin@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1292907880-3353-2-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
References: <1292907880-3353-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 21 Dec 2010 05:04:40.0757 (UTC)
 FILETIME=[92D7A650:01CBA0CC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike suspend, where the registers of max8952 are not reset, during
hibernation, the register values are reset with an instance of
hibernation.

This patch lets max8952 save and restore register values during
hibernation.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/max8952.c |   61 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 60 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index c7dae2b..530d3b6 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -30,10 +30,11 @@
 #include <linux/gpio.h>
 #include <linux/io.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 
 /* Registers */
 enum {
-	MAX8952_REG_MODE0,
+	MAX8952_REG_MODE0 = 0,
 	MAX8952_REG_MODE1,
 	MAX8952_REG_MODE2,
 	MAX8952_REG_MODE3,
@@ -311,6 +312,8 @@ static int __devinit max8952_pmic_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, max8952);
 
+	pm_runtime_set_active(max8952->dev);
+
 	return 0;
 
 err_reg:
@@ -340,11 +343,67 @@ static const struct i2c_device_id max8952_ids[] = {
 };
 MODULE_DEVICE_TABLE(i2c, max8952_ids);
 
+struct max8952_reg_dump {
+	u8	addr;
+	u8	val;
+};
+#define SAVE_ITEM(x)	{ .addr = (x), .val = 0x0, }
+static struct max8952_reg_dump max8952_dump[] = {
+	SAVE_ITEM(MAX8952_REG_MODE0),
+	SAVE_ITEM(MAX8952_REG_MODE1),
+	SAVE_ITEM(MAX8952_REG_MODE2),
+	SAVE_ITEM(MAX8952_REG_MODE3),
+	SAVE_ITEM(MAX8952_REG_CONTROL),
+	SAVE_ITEM(MAX8952_REG_SYNC),
+	SAVE_ITEM(MAX8952_REG_RAMP),
+};
+
+/* Save registers before hibernation */
+static int max8952_freeze(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct max8952_data *max8952 = i2c_get_clientdata(i2c);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(max8952_dump); i++) {
+		int val = max8952_read_reg(max8952, max8952_dump[i].addr);
+		if (val >= 0)
+			max8952_dump[i].val = val;
+		else {
+			dev_emerg(dev, "reading error %d\n", val);
+			return val;
+		}
+	}
+
+	return 0;
+}
+
+/* Restore registers after hibernation */
+static int max8952_restore(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct max8952_data *max8952 = i2c_get_clientdata(i2c);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(max8952_dump); i++)
+		max8952_write_reg(max8952, max8952_dump[i].addr,
+				max8952_dump[i].val);
+
+	return 0;
+}
+
+static const struct dev_pm_ops max8952_pm = {
+	.freeze = max8952_freeze,
+	.restore = max8952_restore,
+};
+
 static struct i2c_driver max8952_pmic_driver = {
 	.probe		= max8952_pmic_probe,
 	.remove		= __devexit_p(max8952_pmic_remove),
 	.driver		= {
 		.name	= "max8952",
+		.owner	= THIS_MODULE,
+		.pm	= &max8952_pm,
 	},
 	.id_table	= max8952_ids,
 };
-- 
1.7.1

