Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab0CTOOa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:14:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59072 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab0CTOO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:14:27 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: kernel-janitors@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wolfram Sang <w.sang@pengutronix.de>,
       Richard Purdie <rpurdie@rpsys.net>, Riku Voipio <riku.voipio@iki.fi>
Date: Sat, 20 Mar 2010 15:12:49 +0100
Message-Id: <1269094385-16114-9-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 08/24] leds: fix dangling pointers
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
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Riku Voipio <riku.voipio@iki.fi>
---

Found using coccinelle, then reviewed. Full patchset is available via
kernel-janitors, linux-i2c, and LKML.
---
 drivers/leds/leds-lp3944.c  |    2 +-
 drivers/leds/leds-pca9532.c |    4 ++--
 drivers/leds/leds-pca955x.c |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/leds-lp3944.c b/drivers/leds/leds-lp3944.c
index 5946208..7dca8f2 100644
--- a/drivers/leds/leds-lp3944.c
+++ b/drivers/leds/leds-lp3944.c
@@ -425,8 +425,8 @@ static int __devexit lp3944_remove(struct i2c_client *client)
 			break;
 		}
 
-	kfree(data);
 	i2c_set_clientdata(client, NULL);
+	kfree(data);
 
 	return 0;
 }
diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index adc561e..0f1f8f9 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -320,8 +320,8 @@ static int pca9532_probe(struct i2c_client *client,
 
 	err = pca9532_configure(client, data, pca9532_pdata);
 	if (err) {
-		kfree(data);
 		i2c_set_clientdata(client, NULL);
+		kfree(data);
 	}
 
 	return err;
@@ -349,8 +349,8 @@ static int pca9532_remove(struct i2c_client *client)
 			break;
 		}
 
-	kfree(data);
 	i2c_set_clientdata(client, NULL);
+	kfree(data);
 	return 0;
 }
 
diff --git a/drivers/leds/leds-pca955x.c b/drivers/leds/leds-pca955x.c
index 4e2d1a4..279fc31 100644
--- a/drivers/leds/leds-pca955x.c
+++ b/drivers/leds/leds-pca955x.c
@@ -340,8 +340,8 @@ exit:
 		cancel_work_sync(&pca955x[i].work);
 	}
 
-	kfree(pca955x);
 	i2c_set_clientdata(client, NULL);
+	kfree(pca955x);
 
 	return err;
 }
@@ -356,8 +356,8 @@ static int __devexit pca955x_remove(struct i2c_client *client)
 		cancel_work_sync(&pca955x[i].work);
 	}
 
-	kfree(pca955x);
 	i2c_set_clientdata(client, NULL);
+	kfree(pca955x);
 
 	return 0;
 }
-- 
1.7.0

