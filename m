Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465Ab1EIJtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 05:49:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55776 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab1EIJts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 05:49:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=MQUKEnUnezzgKYPRM78AF4Zj8LiH9IFZb/AbcdHGRjdsHo2anqXG3XBTSJMgoGfZHQ
         Lw2ZB795ronasawQ9bfwyecokpKa/JNOMLv0+Wt1LYp3xS9fhPGsiV80f4n6czQm+raw
         dxlA0tuWMsSLLWVahq+Wp1vh5Rsw4HwDZFti4=
Subject: [PATCH] regulator: Use mc13xxx_reg_write instead of
 mc13xxx_reg_rmw in mc13892_sw_regulator_set_voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Yong Shen <yong.shen@linaro.org>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 17:49:40 +0800
Message-ID: <1304934580.9600.7.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we call mc13xxx_reg_read and mc13xxx_reg_rmw for the same register.
This can be converted to simply a mc13xxx_reg_read and a mc13xxx_reg_write,
thus save a redundant register read.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
hi Uwe, Yong,
I don't have this hardware handy,
I appreciate if you can help to test this patch if you think this patch is ok.

Regards,
Axel

 drivers/regulator/mc13892-regulator.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index 1b8f739..33d43b2 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -431,7 +431,8 @@ static int mc13892_sw_regulator_set_voltage(struct regulator_dev *rdev,
 		int min_uV, int max_uV, unsigned *selector)
 {
 	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
-	int hi, value, val, mask, id = rdev_get_id(rdev);
+	int hi, value, mask, id = rdev_get_id(rdev);
+	u32 valread;
 	int ret;
 
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d min_uV: %d max_uV: %d\n",
@@ -447,15 +448,16 @@ static int mc13892_sw_regulator_set_voltage(struct regulator_dev *rdev,
 
 	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13xxx_reg_read(priv->mc13xxx,
-		mc13892_regulators[id].vsel_reg, &val);
+		mc13892_regulators[id].vsel_reg, &valread);
 	if (ret)
 		goto err;
 
-	hi  = val & MC13892_SWITCHERS0_SWxHI;
 	if (value > 1375)
 		hi = 1;
-	if (value < 1100)
+	else if (value < 1100)
 		hi = 0;
+	else
+		hi = valread & MC13892_SWITCHERS0_SWxHI;
 
 	if (hi) {
 		value = (value - 1100000) / 25000;
@@ -464,8 +466,10 @@ static int mc13892_sw_regulator_set_voltage(struct regulator_dev *rdev,
 		value = (value - 600000) / 25000;
 
 	mask = mc13892_regulators[id].vsel_mask | MC13892_SWITCHERS0_SWxHI;
-	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13892_regulators[id].vsel_reg,
-			mask, value << mc13892_regulators[id].vsel_shift);
+	valread = (valread & ~mask) |
+			(value << mc13892_regulators[id].vsel_shift);
+	ret = mc13xxx_reg_write(priv->mc13xxx, mc13892_regulators[id].vsel_reg,
+			valread);
 err:
 	mc13xxx_unlock(priv->mc13xxx);
 
-- 
1.7.1



