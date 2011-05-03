Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab1ECQ2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:28:11 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37821 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab1ECQ2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:28:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=mTU+zAjj81yrmM/tHEjNYAOnwyoq85BL3LUwhYE1WcicU6D7SV5WF69X76Iy79u+j+
         uJYves8+L149sosRD7Exfi2qE/02VMzRPC8Q7agUsAG1za+QwO1L+ABjheEn9aRyOZxQ
         EGeKsR3qgKP1os+0ve0KJkd/RtV7dzgzeiiN8=
Subject: [RFC][PATCH] mfd: mc13xxx-core: put mutex lock down to
 mc13xxx_reg_rmw function
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Yong Shen <yong.shen@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 May 2011 00:27:59 +0800
Message-ID: <1304440079.16287.7.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mc13xxx_reg_rmw function is doing read/modify/write bitmask operations,
thus add the lock to protect it.
Then we can remove the lock/unlock from the caller.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Note I don't have the hardware handy for testing.
I appreciate if someone who has the device can test this patch.
Regards,
Axel

 drivers/mfd/mc13xxx-core.c                 |    8 ++++++--
 drivers/regulator/mc13892-regulator.c      |   16 +++++++---------
 drivers/regulator/mc13xxx-regulator-core.c |    6 ------
 3 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 7e4d44b..5fb0fcc 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -249,15 +249,19 @@ int mc13xxx_reg_rmw(struct mc13xxx *mc13xxx, unsigned int offset,
 	int ret;
 	u32 valread;
 
+	mc13xxx_lock(mc13xxx);
 	BUG_ON(val & ~mask);
 
 	ret = mc13xxx_reg_read(mc13xxx, offset, &valread);
 	if (ret)
-		return ret;
+		goto out;
 
 	valread = (valread & ~mask) | val;
 
-	return mc13xxx_reg_write(mc13xxx, offset, valread);
+	ret = mc13xxx_reg_write(mc13xxx, offset, valread);
+out:
+	mc13xxx_unlock(mc13xxx);
+	return ret;
 }
 EXPORT_SYMBOL(mc13xxx_reg_rmw);
 
diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index 1b8f739..679b315 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -449,7 +449,8 @@ static int mc13892_sw_regulator_set_voltage(struct regulator_dev *rdev,
 	ret = mc13xxx_reg_read(priv->mc13xxx,
 		mc13892_regulators[id].vsel_reg, &val);
 	if (ret)
-		goto err;
+		mc13xxx_unlock(priv->mc13xxx);
+		return ret;
 
 	hi  = val & MC13892_SWITCHERS0_SWxHI;
 	if (value > 1375)
@@ -464,11 +465,10 @@ static int mc13892_sw_regulator_set_voltage(struct regulator_dev *rdev,
 		value = (value - 600000) / 25000;
 
 	mask = mc13892_regulators[id].vsel_mask | MC13892_SWITCHERS0_SWxHI;
-	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13892_regulators[id].vsel_reg,
-			mask, value << mc13892_regulators[id].vsel_shift);
-err:
 	mc13xxx_unlock(priv->mc13xxx);
 
+	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13892_regulators[id].vsel_reg,
+			mask, value << mc13892_regulators[id].vsel_shift);
 	return ret;
 }
 
@@ -488,10 +488,8 @@ static int mc13892_vcam_set_mode(struct regulator_dev *rdev, unsigned int mode)
 	if (mode == REGULATOR_MODE_FAST)
 		en_val = MC13892_REGULATORMODE1_VCAMCONFIGEN;
 
-	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13892_regulators[id].reg,
 		MC13892_REGULATORMODE1_VCAMCONFIGEN, en_val);
-	mc13xxx_unlock(priv->mc13xxx);
 
 	return ret;
 }
@@ -537,8 +535,10 @@ static int __devinit mc13892_regulator_probe(struct platform_device *pdev)
 
 	mc13xxx_lock(mc13892);
 	ret = mc13xxx_reg_read(mc13892, MC13892_REVISION, &val);
-	if (ret)
+	if (ret) {
+		mc13xxx_unlock(mc13892);
 		goto err_free;
+	}
 
 	/* enable switch auto mode */
 	if ((val & 0x0000FFFF) == 0x45d0) {
@@ -558,7 +558,6 @@ static int __devinit mc13892_regulator_probe(struct platform_device *pdev)
 		if (ret)
 			goto err_free;
 	}
-	mc13xxx_unlock(mc13892);
 
 	mc13892_regulators[MC13892_VCAM].desc.ops->set_mode
 		= mc13892_vcam_set_mode;
@@ -586,7 +585,6 @@ err:
 		regulator_unregister(priv->regulators[i]);
 
 err_free:
-	mc13xxx_unlock(mc13892);
 	kfree(priv);
 
 	return ret;
diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index 2bb5de1..efe77d5 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -34,11 +34,9 @@ static int mc13xxx_regulator_enable(struct regulator_dev *rdev)
 
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
 
-	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13xxx_regulators[id].reg,
 			mc13xxx_regulators[id].enable_bit,
 			mc13xxx_regulators[id].enable_bit);
-	mc13xxx_unlock(priv->mc13xxx);
 
 	return ret;
 }
@@ -52,10 +50,8 @@ static int mc13xxx_regulator_disable(struct regulator_dev *rdev)
 
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
 
-	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13xxx_regulators[id].reg,
 			mc13xxx_regulators[id].enable_bit, 0);
-	mc13xxx_unlock(priv->mc13xxx);
 
 	return ret;
 }
@@ -143,11 +139,9 @@ static int mc13xxx_regulator_set_voltage(struct regulator_dev *rdev, int min_uV,
 	if (value < 0)
 		return value;
 
-	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13xxx_regulators[id].vsel_reg,
 			mc13xxx_regulators[id].vsel_mask,
 			value << mc13xxx_regulators[id].vsel_shift);
-	mc13xxx_unlock(priv->mc13xxx);
 
 	return ret;
 }
-- 
1.7.1



