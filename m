Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab2COEtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 00:49:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41690 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2COEtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 00:49:17 -0400
Message-ID: <1331786949.4709.1.camel@phoenix>
Subject: [PATCH] regulator: Fix unbalanced lock/unlock in
 mc13892_regulator_probe error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Yong Shen <yong.shen@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 15 Mar 2012 12:49:09 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not hold a lock while registering regulator, thus should not call unlock
if regulator_register fails.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/mc13892-regulator.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index e8cfc99..845aa22 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -552,7 +552,7 @@ static int __devinit mc13892_regulator_probe(struct platform_device *pdev)
 	mc13xxx_lock(mc13892);
 	ret = mc13xxx_reg_read(mc13892, MC13892_REVISION, &val);
 	if (ret)
-		goto err_free;
+		goto err_unlock;
 
 	/* enable switch auto mode */
 	if ((val & 0x0000FFFF) == 0x45d0) {
@@ -562,7 +562,7 @@ static int __devinit mc13892_regulator_probe(struct platform_device *pdev)
 			MC13892_SWITCHERS4_SW1MODE_AUTO |
 			MC13892_SWITCHERS4_SW2MODE_AUTO);
 		if (ret)
-			goto err_free;
+			goto err_unlock;
 
 		ret = mc13xxx_reg_rmw(mc13892, MC13892_SWITCHERS5,
 			MC13892_SWITCHERS5_SW3MODE_M |
@@ -570,7 +570,7 @@ static int __devinit mc13892_regulator_probe(struct platform_device *pdev)
 			MC13892_SWITCHERS5_SW3MODE_AUTO |
 			MC13892_SWITCHERS5_SW4MODE_AUTO);
 		if (ret)
-			goto err_free;
+			goto err_unlock;
 	}
 	mc13xxx_unlock(mc13892);
 
@@ -612,10 +612,10 @@ static int __devinit mc13892_regulator_probe(struct platform_device *pdev)
 err:
 	while (--i >= 0)
 		regulator_unregister(priv->regulators[i]);
+	return ret;
 
-err_free:
+err_unlock:
 	mc13xxx_unlock(mc13892);
-
 	return ret;
 }
 
-- 
1.7.5.4



