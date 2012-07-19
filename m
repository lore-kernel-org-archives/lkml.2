Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab2GSDQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 23:16:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44126 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab2GSDQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 23:16:16 -0400
Message-ID: <1342667766.6294.2.camel@phoenix>
Subject: [PATCH 1/2] regulator: mc13783: Make mc13783_powermisc_rmw() lock
 protected
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Yong Shen <yong.shen@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 19 Jul 2012 11:16:06 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Then we can remove lock/unlock around the caller.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/mc13783-regulator.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index 4932e34..2587ea1 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -238,9 +238,10 @@ static int mc13783_powermisc_rmw(struct mc13xxx_regulator_priv *priv, u32 mask,
 
 	BUG_ON(val & ~mask);
 
+	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13xxx_reg_read(mc13783, MC13783_REG_POWERMISC, &valread);
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Update the stored state for Power Gates. */
 	priv->powermisc_pwgt_state =
@@ -253,7 +254,10 @@ static int mc13783_powermisc_rmw(struct mc13xxx_regulator_priv *priv, u32 mask,
 	valread = (valread & ~MC13783_REG_POWERMISC_PWGTSPI_M) |
 						priv->powermisc_pwgt_state;
 
-	return mc13xxx_reg_write(mc13783, MC13783_REG_POWERMISC, valread);
+	ret = mc13xxx_reg_write(mc13783, MC13783_REG_POWERMISC, valread);
+out:
+	mc13xxx_unlock(priv->mc13xxx);
+	return ret;
 }
 
 static int mc13783_gpo_regulator_enable(struct regulator_dev *rdev)
@@ -261,7 +265,6 @@ static int mc13783_gpo_regulator_enable(struct regulator_dev *rdev)
 	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
 	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
 	int id = rdev_get_id(rdev);
-	int ret;
 	u32 en_val = mc13xxx_regulators[id].enable_bit;
 
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
@@ -271,12 +274,8 @@ static int mc13783_gpo_regulator_enable(struct regulator_dev *rdev)
 	    id == MC13783_REG_PWGT2SPI)
 		en_val = 0;
 
-	mc13xxx_lock(priv->mc13xxx);
-	ret = mc13783_powermisc_rmw(priv, mc13xxx_regulators[id].enable_bit,
+	return mc13783_powermisc_rmw(priv, mc13xxx_regulators[id].enable_bit,
 					en_val);
-	mc13xxx_unlock(priv->mc13xxx);
-
-	return ret;
 }
 
 static int mc13783_gpo_regulator_disable(struct regulator_dev *rdev)
@@ -284,7 +283,6 @@ static int mc13783_gpo_regulator_disable(struct regulator_dev *rdev)
 	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
 	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
 	int id = rdev_get_id(rdev);
-	int ret;
 	u32 dis_val = 0;
 
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
@@ -294,12 +292,8 @@ static int mc13783_gpo_regulator_disable(struct regulator_dev *rdev)
 	    id == MC13783_REG_PWGT2SPI)
 		dis_val = mc13xxx_regulators[id].enable_bit;
 
-	mc13xxx_lock(priv->mc13xxx);
-	ret = mc13783_powermisc_rmw(priv, mc13xxx_regulators[id].enable_bit,
+	return mc13783_powermisc_rmw(priv, mc13xxx_regulators[id].enable_bit,
 					dis_val);
-	mc13xxx_unlock(priv->mc13xxx);
-
-	return ret;
 }
 
 static int mc13783_gpo_regulator_is_enabled(struct regulator_dev *rdev)
-- 
1.7.9.5



