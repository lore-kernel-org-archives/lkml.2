Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab0CTOPW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:15:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59143 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab0CTOPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:15:16 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: kernel-janitors@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wolfram Sang <w.sang@pengutronix.de>
Date: Sat, 20 Mar 2010 15:12:56 +0100
Message-Id: <1269094385-16114-16-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 15/24] misc/eeprom: fix dangling pointers
X-SA-Exim-Version: 4.2.1 (built Sat, 01 Aug 2009 12:09:26 +0000)
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); Unknown failure
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix I2C-drivers which missed setting clientdata to NULL before freeing the
structure it points to. Also fix drivers which do this _after_ the structure
was freed already.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---

Found using coccinelle, then reviewed. Full patchset is available via
kernel-janitors, linux-i2c, and LKML.
---
 drivers/misc/eeprom/at24.c    |    2 +-
 drivers/misc/eeprom/eeprom.c  |    6 +++++-
 drivers/misc/eeprom/max6875.c |    2 ++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index db7d0f2..cff9b93 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -603,8 +603,8 @@ static int __devexit at24_remove(struct i2c_client *client)
 		i2c_unregister_device(at24->client[i]);
 
 	kfree(at24->writebuf);
-	kfree(at24);
 	i2c_set_clientdata(client, NULL);
+	kfree(at24);
 	return 0;
 }
 
diff --git a/drivers/misc/eeprom/eeprom.c b/drivers/misc/eeprom/eeprom.c
index f939ebc..2643582 100644
--- a/drivers/misc/eeprom/eeprom.c
+++ b/drivers/misc/eeprom/eeprom.c
@@ -201,6 +201,7 @@ static int eeprom_probe(struct i2c_client *client,
 	return 0;
 
 exit_kfree:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -208,8 +209,11 @@ exit:
 
 static int eeprom_remove(struct i2c_client *client)
 {
+	struct eeprom_data *data = i2c_get_clientdata(client);
+
 	sysfs_remove_bin_file(&client->dev.kobj, &eeprom_attr);
-	kfree(i2c_get_clientdata(client));
+	i2c_set_clientdata(client, NULL);
+	kfree(data);
 
 	return 0;
 }
diff --git a/drivers/misc/eeprom/max6875.c b/drivers/misc/eeprom/max6875.c
index 5a6b2bc..54fc568 100644
--- a/drivers/misc/eeprom/max6875.c
+++ b/drivers/misc/eeprom/max6875.c
@@ -178,6 +178,7 @@ static int max6875_probe(struct i2c_client *client,
 exit_remove_fake:
 	i2c_unregister_device(data->fake_client);
 exit_kfree:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return err;
 }
@@ -189,6 +190,7 @@ static int max6875_remove(struct i2c_client *client)
 	i2c_unregister_device(data->fake_client);
 
 	sysfs_remove_bin_file(&client->dev.kobj, &user_eeprom_attr);
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 
 	return 0;
-- 
1.7.0

