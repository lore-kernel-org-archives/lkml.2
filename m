Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2H1LsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 07:48:17 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:36806 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab2H1LsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 07:48:14 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, lrg@ti.com, sameo@linux.intel.com,
        peter.ujfalusi@ti.com, s-guiriec@ti.com,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH 4/6] mfd: palmas add device tree handling to mfd
Date: Tue, 28 Aug 2012 13:47:38 +0200
Message-Id: <1346154460-20031-5-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346154460-20031-1-git-send-email-gg@slimlogic.co.uk>
References: <1346154460-20031-1-git-send-email-gg@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree handling to the palmas MFD. This takes the values
that can be set from platform data from the device tree nodes instead.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
---
 drivers/mfd/palmas.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index c4b99f4..b5905f0 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -23,6 +23,7 @@
 #include <linux/err.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/palmas.h>
+#include <linux/of_platform.h>
 
 enum palmas_ids {
 	PALMAS_PMIC_ID,
@@ -246,17 +247,56 @@ static struct regmap_irq_chip palmas_irq_chip = {
 			PALMAS_INT1_MASK),
 };
 
+static void __devinit palmas_dt_to_pdata(struct device_node *node,
+		struct palmas_platform_data *pdata)
+{
+	int ret;
+	u32 prop;
+
+	ret = of_property_read_u32(node, "ti,mux_pad1", &prop);
+	if (!ret) {
+		pdata->mux_from_pdata = 1;
+		pdata->pad1 = prop;
+	}
+
+	ret = of_property_read_u32(node, "ti,mux_pad2", &prop);
+	if (!ret) {
+		pdata->mux_from_pdata = 1;
+		pdata->pad2 = prop;
+	}
+
+	/* The default for this register is all masked */
+	ret = of_property_read_u32(node, "ti,power_ctrl", &prop);
+	if (!ret)
+		pdata->power_ctrl = prop;
+	else
+		pdata->power_ctrl = PALMAS_POWER_CTRL_NSLEEP_MASK |
+					PALMAS_POWER_CTRL_ENABLE1_MASK |
+					PALMAS_POWER_CTRL_ENABLE2_MASK;
+}
+
 static int __devinit palmas_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
 	struct palmas *palmas;
 	struct palmas_platform_data *pdata;
+	struct device_node *node = i2c->dev.of_node;
 	int ret = 0, i;
 	unsigned int reg, addr;
 	int slave;
 	struct mfd_cell *children;
 
 	pdata = dev_get_platdata(&i2c->dev);
+
+	if (node && !pdata) {
+		pdata = devm_kzalloc(&i2c->dev, sizeof(*pdata), GFP_KERNEL);
+
+		if (!pdata)
+			return -ENOMEM;
+
+		palmas_dt_to_pdata(node, pdata);
+	}
+
 	if (!pdata)
 		return -EINVAL;
 
@@ -379,6 +419,18 @@ static int __devinit palmas_i2c_probe(struct i2c_client *i2c,
 	if (ret)
 		goto err_irq;
 
+	/*
+	 * If we are probing with DT do this the DT way and return here
+	 * otherwise continue and add devices using mfd helpers.
+	 */
+	if (node) {
+		ret = of_platform_populate(node, NULL, NULL, &i2c->dev);
+		if (ret < 0)
+			goto err_irq;
+		else
+			return ret;
+	}
+
 	children = kmemdup(palmas_children, sizeof(palmas_children),
 			   GFP_KERNEL);
 	if (!children) {
-- 
1.7.9.5

