Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906Ab1JNNcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 09:32:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49045 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab1JNNcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 09:32:11 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 2/2] gpio: pca953x: propagate the errno from the chip_init functions
Date: Fri, 14 Oct 2011 15:32:00 +0200
Message-Id: <1318599120-413-2-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1318599120-413-1-git-send-email-w.sang@pengutronix.de>
References: <1318599120-413-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initializing the chips may return with an error, but this error gets
dropped in probe(). Propagate this further to the driver core. Also,
simplify returning the error in one of the init functions.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/gpio/gpio-pca953x.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 45de6a4..a3fef0c 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -595,9 +595,6 @@ static int __devinit device_pca953x_init(struct pca953x_chip *chip, int invert)
 
 	/* set platform specific polarity inversion */
 	ret = pca953x_write_reg(chip, PCA953X_INVERT, invert);
-	if (ret)
-		goto out;
-	return 0;
 out:
 	return ret;
 }
@@ -639,7 +636,7 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 	struct pca953x_platform_data *pdata;
 	struct pca953x_chip *chip;
 	int irq_base=0, invert=0;
-	int ret = 0;
+	int ret;
 
 	chip = kzalloc(sizeof(struct pca953x_chip), GFP_KERNEL);
 	if (chip == NULL)
@@ -672,9 +669,11 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 	pca953x_setup_gpio(chip, id->driver_data & PCA_GPIO_MASK);
 
 	if (chip->chip_type == PCA953X_TYPE)
-		device_pca953x_init(chip, invert);
+		ret = device_pca953x_init(chip, invert);
 	else
-		device_pca957x_init(chip, invert);
+		ret = device_pca957x_init(chip, invert);
+	if (ret)
+		goto out_failed;
 
 	ret = pca953x_irq_setup(chip, id, irq_base);
 	if (ret)
-- 
1.7.6.3

