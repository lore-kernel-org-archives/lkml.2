Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933896Ab0HFFbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:31:51 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58729 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759032Ab0HFFbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:31:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=D3z/c5g44UhUFo8LshdvRE81qodJ9YTJfMnmX2x5QRWjfnbOEqGnYkiAUdbOE04iS6
         H/SZswEaa+ZJpW7UKfNRtc2lrsIpIouL3NRqUUhquezh7W5eJj4A1wICWpjN076cJ+U/
         JUy2WQKkHJQhKsW2mrnyYLgL0TX7YUmvRSWHo=
Subject: [PATCH] regulator: max1586 - fix a memory leak in
	max1586_pmic_remove()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Robert Jarzmik <robert.jarzmik@free.fr>
Content-Type: text/plain
Date: Fri, 06 Aug 2010 13:33:15 +0800
Message-Id: <1281072795.24426.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In max1586_pmic_probe(), we allocate memory for max1586.
In max1586_pmic_remove(), current implementation only free rdev
which is a member of struct max1586_data.
Thus, there is a small memory leak when we unload the module.

This patch fixes the memory leak by passing max1586 to i2c clientdata,
and properly kfree(max1586) in max1586_pmic_remove().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max1586.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index 2b54d9d..8867c27 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -223,7 +223,7 @@ static int __devinit max1586_pmic_probe(struct i2c_client *client,
 		}
 	}
 
-	i2c_set_clientdata(client, rdev);
+	i2c_set_clientdata(client, max1586);
 	dev_info(&client->dev, "Maxim 1586 regulator driver loaded\n");
 	return 0;
 
@@ -238,13 +238,13 @@ out:
 
 static int __devexit max1586_pmic_remove(struct i2c_client *client)
 {
-	struct regulator_dev **rdev = i2c_get_clientdata(client);
+	struct max1586_data *max1586 = i2c_get_clientdata(client);
 	int i;
 
 	for (i = 0; i <= MAX1586_V6; i++)
-		if (rdev[i])
-			regulator_unregister(rdev[i]);
-	kfree(rdev);
+		if (max1586->rdev[i])
+			regulator_unregister(max1586->rdev[i]);
+	kfree(max1586);
 
 	return 0;
 }
-- 
1.5.4.3



