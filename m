Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab2H1LsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 07:48:09 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:36794 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab2H1LsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 07:48:06 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, lrg@ti.com, sameo@linux.intel.com,
        peter.ujfalusi@ti.com, s-guiriec@ti.com,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH 1/6] mfd: palmas improve the error exit path
Date: Tue, 28 Aug 2012 13:47:35 +0200
Message-Id: <1346154460-20031-2-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346154460-20031-1-git-send-email-gg@slimlogic.co.uk>
References: <1346154460-20031-1-git-send-email-gg@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve the error exit path so that we correctly de-allocate resources
that have been allocated upto the point where error occurs.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
---
 drivers/mfd/palmas.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index c4a69f1..5ffd330 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -377,11 +377,11 @@ static int __devinit palmas_i2c_probe(struct i2c_client *i2c,
 		reg = pdata->pad1;
 		ret = regmap_write(palmas->regmap[slave], addr, reg);
 		if (ret)
-			goto err;
+			goto err_irq;
 	} else {
 		ret = regmap_read(palmas->regmap[slave], addr, &reg);
 		if (ret)
-			goto err;
+			goto err_irq;
 	}
 
 	if (!(reg & PALMAS_PRIMARY_SECONDARY_PAD1_GPIO_0))
@@ -412,11 +412,11 @@ static int __devinit palmas_i2c_probe(struct i2c_client *i2c,
 		reg = pdata->pad2;
 		ret = regmap_write(palmas->regmap[slave], addr, reg);
 		if (ret)
-			goto err;
+			goto err_irq;
 	} else {
 		ret = regmap_read(palmas->regmap[slave], addr, &reg);
 		if (ret)
-			goto err;
+			goto err_irq;
 	}
 
 	if (!(reg & PALMAS_PRIMARY_SECONDARY_PAD2_GPIO_4))
@@ -439,13 +439,13 @@ static int __devinit palmas_i2c_probe(struct i2c_client *i2c,
 
 	ret = regmap_write(palmas->regmap[slave], addr, reg);
 	if (ret)
-		goto err;
+		goto err_irq;
 
 	children = kmemdup(palmas_children, sizeof(palmas_children),
 			   GFP_KERNEL);
 	if (!children) {
 		ret = -ENOMEM;
-		goto err;
+		goto err_irq;
 	}
 
 	children[PALMAS_PMIC_ID].platform_data = pdata->pmic_pdata;
@@ -457,13 +457,15 @@ static int __devinit palmas_i2c_probe(struct i2c_client *i2c,
 	kfree(children);
 
 	if (ret < 0)
-		goto err;
+		goto err_devices;
 
 	return ret;
 
-err:
+err_devices:
 	mfd_remove_devices(palmas->dev);
-	kfree(palmas);
+err_irq:
+	regmap_del_irq_chip(palmas->irq, palmas->irq_data);
+err:
 	return ret;
 }
 
-- 
1.7.9.5

