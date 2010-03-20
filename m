Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab0CTOQJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:16:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59172 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab0CTOQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:16:04 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: kernel-janitors@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wolfram Sang <w.sang@pengutronix.de>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Date: Sat, 20 Mar 2010 15:12:59 +0100
Message-Id: <1269094385-16114-19-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 18/24] rtc: fix dangling pointers
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
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
---

Found using coccinelle, then reviewed. Full patchset is available via
kernel-janitors, linux-i2c, and LKML.
---
 drivers/rtc/rtc-ds1307.c  |    2 ++
 drivers/rtc/rtc-fm3130.c  |    2 ++
 drivers/rtc/rtc-m41t80.c  |    2 ++
 drivers/rtc/rtc-pcf8563.c |    2 ++
 drivers/rtc/rtc-pcf8583.c |    2 ++
 drivers/rtc/rtc-rs5c372.c |    2 ++
 drivers/rtc/rtc-s35390a.c |    4 ++--
 7 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index c4ec5c1..eee887c 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -900,6 +900,7 @@ read_rtc:
 exit_irq:
 	rtc_device_unregister(ds1307->rtc);
 exit_free:
+	i2c_set_clientdata(client, NULL);
 	kfree(ds1307);
 	return err;
 }
@@ -917,6 +918,7 @@ static int __devexit ds1307_remove(struct i2c_client *client)
 		sysfs_remove_bin_file(&client->dev.kobj, &nvram);
 
 	rtc_device_unregister(ds1307->rtc);
+	i2c_set_clientdata(client, NULL);
 	kfree(ds1307);
 	return 0;
 }
diff --git a/drivers/rtc/rtc-fm3130.c b/drivers/rtc/rtc-fm3130.c
index 812c667..6c4e90f 100644
--- a/drivers/rtc/rtc-fm3130.c
+++ b/drivers/rtc/rtc-fm3130.c
@@ -462,6 +462,7 @@ exit_bad:
 	}
 	return 0;
 exit_free:
+	i2c_set_clientdata(client, NULL);
 	kfree(fm3130);
 	return err;
 }
@@ -471,6 +472,7 @@ static int __devexit fm3130_remove(struct i2c_client *client)
 	struct fm3130 *fm3130 = i2c_get_clientdata(client);
 
 	rtc_device_unregister(fm3130->rtc);
+	i2c_set_clientdata(client, NULL);
 	kfree(fm3130);
 	return 0;
 }
diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index 60fe266..2fd8d7c 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -863,6 +863,7 @@ ht_err:
 exit:
 	if (rtc)
 		rtc_device_unregister(rtc);
+	i2c_set_clientdata(client, NULL);
 	kfree(clientdata);
 	return rc;
 }
@@ -880,6 +881,7 @@ static int m41t80_remove(struct i2c_client *client)
 #endif
 	if (rtc)
 		rtc_device_unregister(rtc);
+	i2c_set_clientdata(client, NULL);
 	kfree(clientdata);
 
 	return 0;
diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index 65f346b..4be76a4 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -225,6 +225,7 @@ static int pcf8563_probe(struct i2c_client *client,
 	return 0;
 
 exit_kfree:
+	i2c_set_clientdata(client, NULL);
 	kfree(pcf8563);
 
 	return err;
@@ -237,6 +238,7 @@ static int pcf8563_remove(struct i2c_client *client)
 	if (pcf8563->rtc)
 		rtc_device_unregister(pcf8563->rtc);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(pcf8563);
 
 	return 0;
diff --git a/drivers/rtc/rtc-pcf8583.c b/drivers/rtc/rtc-pcf8583.c
index 2d201af..e122d9f 100644
--- a/drivers/rtc/rtc-pcf8583.c
+++ b/drivers/rtc/rtc-pcf8583.c
@@ -290,6 +290,7 @@ static int pcf8583_probe(struct i2c_client *client,
 	return 0;
 
 exit_kfree:
+	i2c_set_clientdata(client, NULL);
 	kfree(pcf8583);
 	return err;
 }
@@ -300,6 +301,7 @@ static int __devexit pcf8583_remove(struct i2c_client *client)
 
 	if (pcf8583->rtc)
 		rtc_device_unregister(pcf8583->rtc);
+	i2c_set_clientdata(client, NULL);
 	kfree(pcf8583);
 	return 0;
 }
diff --git a/drivers/rtc/rtc-rs5c372.c b/drivers/rtc/rtc-rs5c372.c
index 2f2c68d..75e0423 100644
--- a/drivers/rtc/rtc-rs5c372.c
+++ b/drivers/rtc/rtc-rs5c372.c
@@ -694,6 +694,7 @@ exit_devreg:
 	rtc_device_unregister(rs5c372->rtc);
 
 exit_kfree:
+	i2c_set_clientdata(client, NULL);
 	kfree(rs5c372);
 
 exit:
@@ -706,6 +707,7 @@ static int rs5c372_remove(struct i2c_client *client)
 
 	rtc_device_unregister(rs5c372->rtc);
 	rs5c_sysfs_unregister(&client->dev);
+	i2c_set_clientdata(client, NULL);
 	kfree(rs5c372);
 	return 0;
 }
diff --git a/drivers/rtc/rtc-s35390a.c b/drivers/rtc/rtc-s35390a.c
index def4d39..da39041 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -274,8 +274,8 @@ exit_dummy:
 	for (i = 1; i < 8; ++i)
 		if (s35390a->client[i])
 			i2c_unregister_device(s35390a->client[i]);
-	kfree(s35390a);
 	i2c_set_clientdata(client, NULL);
+	kfree(s35390a);
 
 exit:
 	return err;
@@ -291,8 +291,8 @@ static int s35390a_remove(struct i2c_client *client)
 			i2c_unregister_device(s35390a->client[i]);
 
 	rtc_device_unregister(s35390a->rtc);
-	kfree(s35390a);
 	i2c_set_clientdata(client, NULL);
+	kfree(s35390a);
 
 	return 0;
 }
-- 
1.7.0

