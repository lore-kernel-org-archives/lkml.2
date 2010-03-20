Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab0CTOPI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:15:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59122 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab0CTOPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:15:02 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: kernel-janitors@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wolfram Sang <w.sang@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sat, 20 Mar 2010 15:12:54 +0100
Message-Id: <1269094385-16114-14-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 13/24] mfd: fix dangling pointers
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
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

Found using coccinelle, then reviewed. Full patchset is available via
kernel-janitors, linux-i2c, and LKML.
---
 drivers/mfd/88pm860x-i2c.c  |    1 +
 drivers/mfd/ab3100-core.c   |    2 ++
 drivers/mfd/da903x.c        |    1 +
 drivers/mfd/menelaus.c      |    3 ++-
 drivers/mfd/pcf50633-core.c |    1 +
 drivers/mfd/tps65010.c      |    2 +-
 drivers/mfd/wm8350-i2c.c    |    2 ++
 7 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/88pm860x-i2c.c b/drivers/mfd/88pm860x-i2c.c
index c37e12b..aa81448 100644
--- a/drivers/mfd/88pm860x-i2c.c
+++ b/drivers/mfd/88pm860x-i2c.c
@@ -201,6 +201,7 @@ static int __devexit pm860x_remove(struct i2c_client *client)
 	i2c_unregister_device(chip->companion);
 	i2c_set_clientdata(chip->companion, NULL);
 	i2c_set_clientdata(chip->client, NULL);
+	i2c_set_clientdata(client, NULL);
 	kfree(chip);
 	return 0;
 }
diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index a2ce3b6..e6fc43f 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -919,6 +919,7 @@ static int __init ab3100_probe(struct i2c_client *client,
 	i2c_unregister_device(ab3100->testreg_client);
  exit_no_testreg_client:
  exit_no_detect:
+	i2c_set_clientdata(client, NULL);
 	kfree(ab3100);
 	return err;
 }
@@ -940,6 +941,7 @@ static int __exit ab3100_remove(struct i2c_client *client)
 	 * their notifiers so deactivate IRQ
 	 */
 	free_irq(client->irq, ab3100);
+	i2c_set_clientdata(client, NULL);
 	kfree(ab3100);
 	return 0;
 }
diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
index e5ffe56..ec8178c 100644
--- a/drivers/mfd/da903x.c
+++ b/drivers/mfd/da903x.c
@@ -543,6 +543,7 @@ static int __devexit da903x_remove(struct i2c_client *client)
 	struct da903x_chip *chip = i2c_get_clientdata(client);
 
 	da903x_remove_subdevs(chip);
+	i2c_set_clientdata(client, NULL);
 	kfree(chip);
 	return 0;
 }
diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index 970afa1..d9e60ba 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -1227,6 +1227,7 @@ fail2:
 	free_irq(client->irq, menelaus);
 	flush_scheduled_work();
 fail1:
+	i2c_set_clientdata(client, NULL);
 	kfree(menelaus);
 	return err;
 }
@@ -1236,8 +1237,8 @@ static int __exit menelaus_remove(struct i2c_client *client)
 	struct menelaus_chip	*menelaus = i2c_get_clientdata(client);
 
 	free_irq(client->irq, menelaus);
-	kfree(menelaus);
 	i2c_set_clientdata(client, NULL);
+	kfree(menelaus);
 	the_menelaus = NULL;
 	return 0;
 }
diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 03dcc92..ab7b4dd 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -675,6 +675,7 @@ static int __devexit pcf50633_remove(struct i2c_client *client)
 	for (i = 0; i < PCF50633_NUM_REGULATORS; i++)
 		platform_device_unregister(pcf->regulator_pdev[i]);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(pcf);
 
 	return 0;
diff --git a/drivers/mfd/tps65010.c b/drivers/mfd/tps65010.c
index e595530..9b22a77 100644
--- a/drivers/mfd/tps65010.c
+++ b/drivers/mfd/tps65010.c
@@ -530,8 +530,8 @@ static int __exit tps65010_remove(struct i2c_client *client)
 	cancel_delayed_work(&tps->work);
 	flush_scheduled_work();
 	debugfs_remove(tps->file);
-	kfree(tps);
 	i2c_set_clientdata(client, NULL);
+	kfree(tps);
 	the_tps = NULL;
 	return 0;
 }
diff --git a/drivers/mfd/wm8350-i2c.c b/drivers/mfd/wm8350-i2c.c
index 8d8c932..2dd3e8a 100644
--- a/drivers/mfd/wm8350-i2c.c
+++ b/drivers/mfd/wm8350-i2c.c
@@ -81,6 +81,7 @@ static int wm8350_i2c_probe(struct i2c_client *i2c,
 	return ret;
 
 err:
+	i2c_set_clientdata(i2c, NULL);
 	kfree(wm8350);
 	return ret;
 }
@@ -90,6 +91,7 @@ static int wm8350_i2c_remove(struct i2c_client *i2c)
 	struct wm8350 *wm8350 = i2c_get_clientdata(i2c);
 
 	wm8350_device_exit(wm8350);
+	i2c_set_clientdata(i2c, NULL);
 	kfree(wm8350);
 
 	return 0;
-- 
1.7.0

