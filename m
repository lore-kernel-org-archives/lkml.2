Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab0IQFjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 01:39:03 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36378 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab0IQFjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 01:39:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=GRr/huV3Yahb/Mg0cCwU8D1kq/Z2H8d1kYU092Bh3AF67t1cAaLsaSSvBfUfKGm8oD
         h42n9UPDkOrsfDK3estl6zZJ9SdyBpeKtsQf27rkPPIi1dtadmuHYq8q6q6/Rbd264h+
         65GOUkwP9+6XVfI0tC8iTg2u+E+KW188vXTI8=
Subject: [PATCH] Regulator: lp3972 cleanup
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Fri, 17 Sep 2010 13:44:17 +0800
Message-Id: <1284702257.9481.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes below fixes based on Mark's comment.
 - Return actual error if i2c_smbus_read_byte_data() fail
 - Add spaces around bitwise AND operator(&) to improve readability
 - Add comment to explain why we need to update voltage change control register
   for LDO1 and LDO5
 - Logging the value for diagnostics if chip reported incorrect voltage value
 - Add __devinit annotation for setup_regulators()
 - Logging the value for diagnostics if failed to detect device

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---

Each fix item is trivial, so I sent the fixes in one patch.

 drivers/regulator/lp3972.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/lp3972.c b/drivers/regulator/lp3972.c
index 0d9b475..c22650a 100644
--- a/drivers/regulator/lp3972.c
+++ b/drivers/regulator/lp3972.c
@@ -192,7 +192,7 @@ static int lp3972_i2c_read(struct i2c_client *i2c, char reg, int count,
 		return -EIO;
 	ret = i2c_smbus_read_byte_data(i2c, reg);
 	if (ret < 0)
-		return -EIO;
+		return ret;
 
 	*dest = ret;
 	return 0;
@@ -215,7 +215,7 @@ static u8 lp3972_reg_read(struct lp3972 *lp3972, u8 reg)
 	lp3972_i2c_read(lp3972->i2c, reg, 1, &val);
 
 	dev_dbg(lp3972->dev, "reg read 0x%02x -> 0x%02x\n", (int)reg,
-		(unsigned)val&0xff);
+		(unsigned)val & 0xff);
 
 	mutex_unlock(&lp3972->io_lock);
 
@@ -234,7 +234,7 @@ static int lp3972_set_bits(struct lp3972 *lp3972, u8 reg, u16 mask, u16 val)
 	if (ret == 0) {
 		ret = lp3972_i2c_write(lp3972->i2c, reg, 1, &tmp);
 		dev_dbg(lp3972->dev, "reg write 0x%02x -> 0x%02x\n", (int)reg,
-			(unsigned)val&0xff);
+			(unsigned)val & 0xff);
 	}
 	mutex_unlock(&lp3972->io_lock);
 
@@ -320,6 +320,13 @@ static int lp3972_ldo_set_voltage(struct regulator_dev *dev,
 	if (ret)
 		return ret;
 
+	/*
+	 * LDO1 and LDO5 support voltage control by either target voltage1
+	 * or target voltage2 register.
+	 * We use target voltage1 register for LDO1 and LDO5 in this driver.
+	 * We need to update voltage change control register(0x20) to enable
+	 * LDO1 and LDO5 to change to their programmed target values.
+	 */
 	switch (ldo) {
 	case LP3972_LDO1:
 	case LP3972_LDO5:
@@ -401,7 +408,8 @@ static int lp3972_dcdc_get_voltage(struct regulator_dev *dev)
 		val = 1000 * buck_voltage_map[buck][reg];
 	else {
 		val = 0;
-		dev_warn(&dev->dev, "chip reported incorrect voltage value.\n");
+		dev_warn(&dev->dev, "chip reported incorrect voltage value."
+				    " reg = %d\n", reg);
 	}
 
 	return val;
@@ -523,7 +531,7 @@ static struct regulator_desc regulators[] = {
 	},
 };
 
-static int setup_regulators(struct lp3972 *lp3972,
+static int __devinit setup_regulators(struct lp3972 *lp3972,
 	struct lp3972_platform_data *pdata)
 {
 	int i, err;
@@ -587,7 +595,7 @@ static int __devinit lp3972_i2c_probe(struct i2c_client *i2c,
 	if (ret == 0 && (val & SYS_CONTROL1_INIT_MASK) != SYS_CONTROL1_INIT_VAL)
 		ret = -ENODEV;
 	if (ret < 0) {
-		dev_err(&i2c->dev, "failed to detect device\n");
+		dev_err(&i2c->dev, "failed to detect device: %d\n", ret);
 		goto err_detect;
 	}
 
-- 
1.7.2



