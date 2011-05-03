Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab1ECQkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:40:37 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55097 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab1ECQkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:40:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=kGOXx22SxvzDM6/FJmnrHmWftxuIsFObl0CnXjyrGCzzrfQ4tChJJVVhdedmI56g26
         dcXGK5AdKzwFIfvO48G6KZ3HQF73rvRRUt8wm8BEKMtsImEG8zs9IUBcr03h5eIY9Fas
         ziHy4rTNejMv1tfwzO9rWJ7s2z65nhz/Ip0g4=
Subject: [PATCH 1/2] regulator: Put mutex lock down to
 mc13783_powermisc_rmw function
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Yong Shen <yong.shen@linaro.org>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 May 2011 00:40:30 +0800
Message-ID: <1304440830.16287.10.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mc13783_powermisc_rmw function is doing read/modify/write bitmask operations,
thus add the lock to protect it.
Then we can remove the lock/unlock from the caller.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/mc13783-regulator.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index 3e5d0c3..13d699c 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -235,11 +235,12 @@ static int mc13783_powermisc_rmw(struct mc13xxx_regulator_priv *priv, u32 mask,
 	int ret;
 	u32 valread;
 
+	mc13xxx_lock(mc13783);
 	BUG_ON(val & ~mask);
 
 	ret = mc13xxx_reg_read(mc13783, MC13783_REG_POWERMISC, &valread);
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Update the stored state for Power Gates. */
 	priv->powermisc_pwgt_state =
@@ -252,7 +253,10 @@ static int mc13783_powermisc_rmw(struct mc13xxx_regulator_priv *priv, u32 mask,
 	valread = (valread & ~MC13783_REG_POWERMISC_PWGTSPI_M) |
 						priv->powermisc_pwgt_state;
 
-	return mc13xxx_reg_write(mc13783, MC13783_REG_POWERMISC, valread);
+	ret = mc13xxx_reg_write(mc13783, MC13783_REG_POWERMISC, valread);
+out:
+	mc13xxx_unlock(mc13783);
+	return ret;
 }
 
 static int mc13783_gpo_regulator_enable(struct regulator_dev *rdev)
@@ -270,10 +274,8 @@ static int mc13783_gpo_regulator_enable(struct regulator_dev *rdev)
 	    id == MC13783_REG_PWGT2SPI)
 		en_val = 0;
 
-	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13783_powermisc_rmw(priv, mc13xxx_regulators[id].enable_bit,
 					en_val);
-	mc13xxx_unlock(priv->mc13xxx);
 
 	return ret;
 }
@@ -293,10 +295,8 @@ static int mc13783_gpo_regulator_disable(struct regulator_dev *rdev)
 	    id == MC13783_REG_PWGT2SPI)
 		dis_val = mc13xxx_regulators[id].enable_bit;
 
-	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13783_powermisc_rmw(priv, mc13xxx_regulators[id].enable_bit,
 					dis_val);
-	mc13xxx_unlock(priv->mc13xxx);
 
 	return ret;
 }
-- 
1.7.1



