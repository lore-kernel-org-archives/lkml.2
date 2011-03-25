Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab1CYWDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 18:03:19 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:46166 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab1CYWDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 18:03:17 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-209.messagelabs.com!1301090595!374866!2
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.178]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: gpio: pca953x: prevent freeing IRQ 0 on probe error
Date: Fri, 25 Mar 2011 15:02:54 -0700
User-Agent: KMail/1.9.9
CC: <grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201103251502.54348.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_GPIO_PCA953X_IRQ is enabled and an error occurs in the probe
before pca953x_irq_setup() is called chip->client->irq will be 0 due to
the kmalloc.  pca953x_irq_teardown() will then try to free_irq(0, chip)
which will produce a:

	WARN(1, "Trying to free already-free IRQ %d\n", irq);

Add an error path to prevent this.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Grant Likely <grant.likely@secretlab.ca>

---

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index 2fc25de..e1ff4d5 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -523,7 +523,7 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 	if (pdata == NULL) {
 		dev_dbg(&client->dev, "no platform data\n");
 		ret = -EINVAL;
-		goto out_failed;
+		goto out_free;
 	}
 
 	chip->client = client;
@@ -541,20 +541,20 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 
 	ret = pca953x_read_reg(chip, PCA953X_OUTPUT, &chip->reg_output);
 	if (ret)
-		goto out_failed;
+		goto out_free;
 
 	ret = pca953x_read_reg(chip, PCA953X_DIRECTION, &chip->reg_direction);
 	if (ret)
-		goto out_failed;
+		goto out_free;
 
 	/* set platform specific polarity inversion */
 	ret = pca953x_write_reg(chip, PCA953X_INVERT, pdata->invert);
 	if (ret)
-		goto out_failed;
+		goto out_free;
 
 	ret = pca953x_irq_setup(chip, id);
 	if (ret)
-		goto out_failed;
+		goto out_free;
 
 	ret = gpiochip_add(&chip->gpio_chip);
 	if (ret)
@@ -572,6 +572,7 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 
 out_failed:
 	pca953x_irq_teardown(chip);
+out_free:
 	kfree(chip->dyn_pdata);
 	kfree(chip);
 	return ret;
