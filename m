Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab1ECQmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:42:22 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42727 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab1ECQmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:42:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MJEjpxgt1A9HXyrXCYDKbBNNigrv1JcXwBq3Tb8wRt5GAzv1qHZjlM40n87hZTKLGR
         YM96/7vvteTjdoXoGue64vn8O1H3dgP9nqbgufk4umxaRnBeqH6Buz0vRH5jJWTO2rAA
         MKXibJKrHWpn5o/WCiJW0ny2gztrWn+e6FskA=
Subject: [PATCH 2/2] regulator: Put mutex lock down to
 mc13892_powermisc_rmw function
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Yong Shen <yong.shen@linaro.org>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1304440830.16287.10.camel@phoenix>
References: <1304440830.16287.10.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 May 2011 00:42:16 +0800
Message-ID: <1304440936.16287.12.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mc13892_powermisc_rmw function is doing read/modify/write bitmask operations,
thus add the lock to protect it.
Then we can remove the lock/unlock from the caller.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/mc13892-regulator.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index 679b315..763895d 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -302,11 +302,12 @@ static int mc13892_powermisc_rmw(struct mc13xxx_regulator_priv *priv, u32 mask,
 	int ret;
 	u32 valread;
 
+	mc13xxx_lock(mc13892);
 	BUG_ON(val & ~mask);
 
 	ret = mc13xxx_reg_read(mc13892, MC13892_POWERMISC, &valread);
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Update the stored state for Power Gates. */
 	priv->powermisc_pwgt_state =
@@ -319,7 +320,10 @@ static int mc13892_powermisc_rmw(struct mc13xxx_regulator_priv *priv, u32 mask,
 	valread = (valread & ~MC13892_POWERMISC_PWGTSPI_M) |
 		priv->powermisc_pwgt_state;
 
-	return mc13xxx_reg_write(mc13892, MC13892_POWERMISC, valread);
+	ret = mc13xxx_reg_write(mc13892, MC13892_POWERMISC, valread);
+out:
+	mc13xxx_unlock(mc13892);
+	return ret;
 }
 
 static int mc13892_gpo_regulator_enable(struct regulator_dev *rdev)
@@ -339,9 +343,7 @@ static int mc13892_gpo_regulator_enable(struct regulator_dev *rdev)
 	if (id == MC13892_GPO4)
 		mask |= MC13892_POWERMISC_GPO4ADINEN;
 
-	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13892_powermisc_rmw(priv, mask, en_val);
-	mc13xxx_unlock(priv->mc13xxx);
 
 	return ret;
 }
@@ -359,10 +361,8 @@ static int mc13892_gpo_regulator_disable(struct regulator_dev *rdev)
 	if (id == MC13892_PWGT1SPI || id == MC13892_PWGT2SPI)
 		dis_val = mc13892_regulators[id].enable_bit;
 
-	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13892_powermisc_rmw(priv, mc13892_regulators[id].enable_bit,
 		dis_val);
-	mc13xxx_unlock(priv->mc13xxx);
 
 	return ret;
 }
-- 
1.7.1



