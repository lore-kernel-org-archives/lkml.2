Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935369Ab0HFFeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:34:01 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61621 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759032Ab0HFFd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:33:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=KePPSiyVOx5//eFv9CGoXg7Je4t7x++JtV9QwkNVhOlreCIVEz+NTGkWVUwjPRqsbQ
         kYb/3BUg3/IFT7l181hOuTrl2eh1uSvrlOpeOzbBmMaCuOnFOwf5MvXF3zpPmlWcYgtI
         kDO2iJX7CcPI+ev84AI88x4KU9yYt8UtJh9uA=
Subject: [PATCH] regulator: max8660 - fix a memory leak in max8660_remove()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Content-Type: text/plain
Date: Fri, 06 Aug 2010 13:35:27 +0800
Message-Id: <1281072927.24426.5.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In max8660_probe(), we allocate memory for max660.
In max8660_remove(), current implementation only free rdev
which is a member of struct max8660.
Thus, there is a small memory leak when we unload the module.

This patch fixes the memory leak by passing max660 to i2c clientdata,
and properly kfree(max8660) in max8660_remove().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8660.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index d97220e..c570e6e 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -450,7 +450,7 @@ static int __devinit max8660_probe(struct i2c_client *client,
 		}
 	}
 
-	i2c_set_clientdata(client, rdev);
+	i2c_set_clientdata(client, max8660);
 	dev_info(&client->dev, "Maxim 8660/8661 regulator driver loaded\n");
 	return 0;
 
@@ -465,13 +465,13 @@ out:
 
 static int __devexit max8660_remove(struct i2c_client *client)
 {
-	struct regulator_dev **rdev = i2c_get_clientdata(client);
+	struct max8660 *max8660 = i2c_get_clientdata(client);
 	int i;
 
 	for (i = 0; i < MAX8660_V_END; i++)
-		if (rdev[i])
-			regulator_unregister(rdev[i]);
-	kfree(rdev);
+		if (max8660->rdev[i])
+			regulator_unregister(max8660->rdev[i]);
+	kfree(max8660);
 
 	return 0;
 }
-- 
1.5.4.3



