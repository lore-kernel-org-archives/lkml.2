Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab1BKMAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 07:00:37 -0500
Received: from mail.work-microwave.de ([62.245.205.51]:57308 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755968Ab1BKMAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 07:00:36 -0500
From: stigge@antcom.de
To: linux-kernel@vger.kernel.org, info@pengutronix.de
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] max730x: Added setup/teardown hooks
Date: Fri, 11 Feb 2011 13:00:06 +0100
Message-Id: <1297425606-13290-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.2.3
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max730x: Added setup/teardown hooks

This patch adds setup and teardown hooks for configuration of GPIO lines via
platform_data, similar to the pca953x driver.

Signed-off-by: Roland Stigge <stigge@antcom.de>

diff --git a/drivers/gpio/max730x.c b/drivers/gpio/max730x.c
index 94ce773..ccd624d 100644
--- a/drivers/gpio/max730x.c
+++ b/drivers/gpio/max730x.c
@@ -219,6 +219,12 @@ int __devinit __max730x_probe(struct max7301 *ts)
 	if (ret)
 		goto exit_destroy;
 
+	if (pdata->setup) {
+		ret = pdata->setup(ts->chip.base,
+				ts->chip.ngpio, pdata->context);
+		if (ret < 0)
+			dev_warn(dev, "setup failed, %d\n", ret);
+	}
 	return ret;
 
 exit_destroy:
@@ -230,12 +236,24 @@ EXPORT_SYMBOL_GPL(__max730x_probe);
 
 int __devexit __max730x_remove(struct device *dev)
 {
+	struct max7301_platform_data *pdata;
 	struct max7301 *ts = dev_get_drvdata(dev);
 	int ret;
 
 	if (ts == NULL)
 		return -ENODEV;
 
+	pdata = dev->platform_data;
+
+	if (pdata && pdata->teardown) {
+		ret = pdata->teardown(ts->chip.base,
+				ts->chip.ngpio, pdata->context);
+		if (ret < 0) {
+			dev_err(dev, "teardown failed, %d\n", ret);
+			return ret;
+		}
+	}
+
 	dev_set_drvdata(dev, NULL);
 
 	/* Power down the chip and disable IRQ output */
diff --git a/include/linux/spi/max7301.h b/include/linux/spi/max7301.h
index bcaa2f7..02d685a 100644
--- a/include/linux/spi/max7301.h
+++ b/include/linux/spi/max7301.h
@@ -28,6 +28,13 @@ struct max7301_platform_data {
 	 * ports of the controller are not used, too.
 	 */
 	u32		input_pullup_active;
+
+	void		*context;	/* param to setup/teardown */
+
+	int		(*setup)(unsigned gpio, unsigned ngpio,
+				void *context);
+	int		(*teardown)(unsigned gpio, unsigned ngpio,
+				void *context);
 };
 
 extern int __max730x_remove(struct device *dev);
