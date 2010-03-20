Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab0CTOP4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:15:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59160 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab0CTOPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:15:52 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: kernel-janitors@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wolfram Sang <w.sang@pengutronix.de>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sat, 20 Mar 2010 15:12:58 +0100
Message-Id: <1269094385-16114-18-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 17/24] regulator: fix dangling pointers
X-SA-Exim-Version: 4.2.1 (built Sat, 01 Aug 2009 12:09:26 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix I2C-drivers which missed setting clientdata to NULL before freeing the
structure it points to. Also fix drivers which do this _after_ the structure
was freed already.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

Found using coccinelle, then reviewed. Full patchset is available via
kernel-janitors, linux-i2c, and LKML.
---
 drivers/regulator/max1586.c |    2 +-
 drivers/regulator/max8649.c |    3 ++-
 drivers/regulator/max8660.c |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index a49fc95..c0b09e1 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -243,8 +243,8 @@ static int __devexit max1586_pmic_remove(struct i2c_client *client)
 	for (i = 0; i <= MAX1586_V6; i++)
 		if (rdev[i])
 			regulator_unregister(rdev[i]);
-	kfree(rdev);
 	i2c_set_clientdata(client, NULL);
+	kfree(rdev);
 
 	return 0;
 }
diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 3ebdf69..833aaed 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -356,6 +356,7 @@ static int __devinit max8649_regulator_probe(struct i2c_client *client,
 	dev_info(info->dev, "Max8649 regulator device is detected.\n");
 	return 0;
 out:
+	i2c_set_clientdata(client, NULL);
 	kfree(info);
 	return ret;
 }
@@ -367,9 +368,9 @@ static int __devexit max8649_regulator_remove(struct i2c_client *client)
 	if (info) {
 		if (info->regulator)
 			regulator_unregister(info->regulator);
+		i2c_set_clientdata(client, NULL);
 		kfree(info);
 	}
-	i2c_set_clientdata(client, NULL);
 
 	return 0;
 }
diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index f12f1bb..47f90b2 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -470,8 +470,8 @@ static int __devexit max8660_remove(struct i2c_client *client)
 	for (i = 0; i < MAX8660_V_END; i++)
 		if (rdev[i])
 			regulator_unregister(rdev[i]);
-	kfree(rdev);
 	i2c_set_clientdata(client, NULL);
+	kfree(rdev);
 
 	return 0;
 }
-- 
1.7.0

