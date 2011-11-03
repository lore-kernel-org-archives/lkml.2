Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab1KCRIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:08:24 -0400
Received: from mail.fuel7.com ([74.222.0.51]:59250 "EHLO mail.fuel7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab1KCRIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:08:22 -0400
From: Kyle Manna <kyle.manna@fuel7.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Kyle Manna <kyle.manna@fuel7.com>
Subject: [PATCH v3 1/6] mfd: TPS65910: Handle non-existent devices
Date: Thu,  3 Nov 2011 12:08:01 -0500
Message-Id: <1320340086-15371-2-git-send-email-kyle.manna@fuel7.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320340086-15371-1-git-send-email-kyle.manna@fuel7.com>
References: <1320340086-15371-1-git-send-email-kyle.manna@fuel7.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The JTAGREVNUM register contains a silicon revision number in the lower
four bits and the upper four bits are to always read 0.

To detect the presence of the device, attempt to read JTAGREVNUM
register and check that it returns a valid value.  If the I2C device
fails to respond or returns an invalid value, return -ENODEV.

Signed-off-by: Kyle Manna <kyle.manna@fuel7.com>
---
 drivers/mfd/tps65910.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 6f5b8cf..0d9c3eb 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -138,6 +138,7 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	struct tps65910_board *pmic_plat_data;
 	struct tps65910_platform_data *init_data;
 	int ret = 0;
+	char reg = 0;
 
 	pmic_plat_data = dev_get_platdata(&i2c->dev);
 	if (!pmic_plat_data)
@@ -161,11 +162,19 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	tps65910->write = tps65910_i2c_write;
 	mutex_init(&tps65910->io_mutex);
 
-	ret = mfd_add_devices(tps65910->dev, -1,
-			      tps65910s, ARRAY_SIZE(tps65910s),
-			      NULL, 0);
-	if (ret < 0)
+	/* Check that the device is there */
+	ret = tps65910_i2c_read(tps65910, TPS65910_JTAGVERNUM, 1, &reg);
+	if (ret < 0 || (reg & ~JTAGVERNUM_VERNUM_MASK)) {
+		dev_err(tps65910->dev, "unknown version: JTAGREVNUM = 0x%x\n",
+				       reg);
+		ret = -ENODEV;
 		goto err;
+	}
+
+	ret = mfd_add_devices(tps65910->dev, -1, tps65910s,
+			ARRAY_SIZE(tps65910s), NULL, 0);
+	if (ret < 0)
+		goto err2;
 
 	init_data->irq = pmic_plat_data->irq;
 	init_data->irq_base = pmic_plat_data->irq;
@@ -174,13 +183,14 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 
 	ret = tps65910_irq_init(tps65910, init_data->irq, init_data);
 	if (ret < 0)
-		goto err;
+		goto err2;
 
 	kfree(init_data);
 	return ret;
 
-err:
+err2:
 	mfd_remove_devices(tps65910->dev);
+err:
 	kfree(tps65910);
 	kfree(init_data);
 	return ret;
-- 
1.7.5.4

