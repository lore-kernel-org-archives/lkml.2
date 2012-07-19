Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab2GSDR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 23:17:26 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47757 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab2GSDRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 23:17:21 -0400
Message-ID: <1342667835.6294.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: mc13892: Make mc13892_powermisc_rmw() lock
 protected
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 19 Jul 2012 11:17:15 +0800
In-Reply-To: <1342667766.6294.2.camel@phoenix>
References: <1342667766.6294.2.camel@phoenix>
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
 drivers/regulator/mc13892-regulator.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index b388b74..9d4296b 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -305,9 +305,10 @@ static int mc13892_powermisc_rmw(struct mc13xxx_regulator_priv *priv, u32 mask,
 
 	BUG_ON(val & ~mask);
 
+	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13xxx_reg_read(mc13892, MC13892_POWERMISC, &valread);
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Update the stored state for Power Gates. */
 	priv->powermisc_pwgt_state =
@@ -320,14 +321,16 @@ static int mc13892_powermisc_rmw(struct mc13xxx_regulator_priv *priv, u32 mask,
 	valread = (valread & ~MC13892_POWERMISC_PWGTSPI_M) |
 		priv->powermisc_pwgt_state;
 
-	return mc13xxx_reg_write(mc13892, MC13892_POWERMISC, valread);
+	ret = mc13xxx_reg_write(mc13892, MC13892_POWERMISC, valread);
+out:
+	mc13xxx_unlock(priv->mc13xxx);
+	return ret;
 }
 
 static int mc13892_gpo_regulator_enable(struct regulator_dev *rdev)
 {
 	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
 	int id = rdev_get_id(rdev);
-	int ret;
 	u32 en_val = mc13892_regulators[id].enable_bit;
 	u32 mask = mc13892_regulators[id].enable_bit;
 
@@ -340,18 +343,13 @@ static int mc13892_gpo_regulator_enable(struct regulator_dev *rdev)
 	if (id == MC13892_GPO4)
 		mask |= MC13892_POWERMISC_GPO4ADINEN;
 
-	mc13xxx_lock(priv->mc13xxx);
-	ret = mc13892_powermisc_rmw(priv, mask, en_val);
-	mc13xxx_unlock(priv->mc13xxx);
-
-	return ret;
+	return mc13892_powermisc_rmw(priv, mask, en_val);
 }
 
 static int mc13892_gpo_regulator_disable(struct regulator_dev *rdev)
 {
 	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
 	int id = rdev_get_id(rdev);
-	int ret;
 	u32 dis_val = 0;
 
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
@@ -360,12 +358,8 @@ static int mc13892_gpo_regulator_disable(struct regulator_dev *rdev)
 	if (id == MC13892_PWGT1SPI || id == MC13892_PWGT2SPI)
 		dis_val = mc13892_regulators[id].enable_bit;
 
-	mc13xxx_lock(priv->mc13xxx);
-	ret = mc13892_powermisc_rmw(priv, mc13892_regulators[id].enable_bit,
+	return mc13892_powermisc_rmw(priv, mc13892_regulators[id].enable_bit,
 		dis_val);
-	mc13xxx_unlock(priv->mc13xxx);
-
-	return ret;
 }
 
 static int mc13892_gpo_regulator_is_enabled(struct regulator_dev *rdev)
-- 
1.7.9.5



