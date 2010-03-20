Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab0CTONt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:13:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59030 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab0CTONq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:13:46 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: kernel-janitors@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wolfram Sang <w.sang@pengutronix.de>
Date: Sat, 20 Mar 2010 15:12:45 +0100
Message-Id: <1269094385-16114-5-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 04/24] gpio: fix dangling pointers
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
---

Found using coccinelle, then reviewed. Full patchset is available via
kernel-janitors, linux-i2c, and LKML.
---
 drivers/gpio/adp5588-gpio.c |    1 +
 drivers/gpio/max732x.c      |    1 +
 drivers/gpio/pca953x.c      |    1 +
 drivers/gpio/pcf857x.c      |    7 ++++---
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/adp5588-gpio.c b/drivers/gpio/adp5588-gpio.c
index afc097a..c0cb5c1 100644
--- a/drivers/gpio/adp5588-gpio.c
+++ b/drivers/gpio/adp5588-gpio.c
@@ -227,6 +227,7 @@ static int __devexit adp5588_gpio_remove(struct i2c_client *client)
 		return ret;
 	}
 
+	i2c_set_clientdata(client, NULL);
 	kfree(dev);
 	return 0;
 }
diff --git a/drivers/gpio/max732x.c b/drivers/gpio/max732x.c
index f786824..85fe675 100644
--- a/drivers/gpio/max732x.c
+++ b/drivers/gpio/max732x.c
@@ -356,6 +356,7 @@ static int __devexit max732x_remove(struct i2c_client *client)
 	if (chip->client_dummy)
 		i2c_unregister_device(chip->client_dummy);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(chip);
 	return 0;
 }
diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index ab5daab..05242dc 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -571,6 +571,7 @@ static int pca953x_remove(struct i2c_client *client)
 
 	pca953x_irq_teardown(chip);
 	kfree(chip->dyn_pdata);
+	i2c_set_clientdata(client, NULL);
 	kfree(chip);
 	return 0;
 }
diff --git a/drivers/gpio/pcf857x.c b/drivers/gpio/pcf857x.c
index 29f19ce..c2aed8a 100644
--- a/drivers/gpio/pcf857x.c
+++ b/drivers/gpio/pcf857x.c
@@ -259,9 +259,7 @@ static int pcf857x_probe(struct i2c_client *client,
 		goto fail;
 
 	gpio->chip.label = client->name;
-
 	gpio->client = client;
-	i2c_set_clientdata(client, gpio);
 
 	/* NOTE:  these chips have strange "quasi-bidirectional" I/O pins.
 	 * We can't actually know whether a pin is configured (a) as output
@@ -307,6 +305,7 @@ static int pcf857x_probe(struct i2c_client *client,
 			dev_warn(&client->dev, "setup --> %d\n", status);
 	}
 
+	i2c_set_clientdata(client, gpio);
 	return 0;
 
 fail:
@@ -334,8 +333,10 @@ static int pcf857x_remove(struct i2c_client *client)
 	}
 
 	status = gpiochip_remove(&gpio->chip);
-	if (status == 0)
+	if (status == 0) {
+		i2c_set_clientdata(client, NULL);
 		kfree(gpio);
+	}
 	else
 		dev_err(&client->dev, "%s --> %d\n", "remove", status);
 	return status;
-- 
1.7.0

