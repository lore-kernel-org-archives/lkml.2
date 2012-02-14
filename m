Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042Ab2BNLFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:05:06 -0500
Received: from skyrme.org ([193.175.80.135]:34719 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759886Ab2BNLDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:03:46 -0500
Date: 14 Feb 2012 10:34:31 +0000
Message-Id: <1329215672-15706-7-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: sameo@linux.intel.com
Cc: dmitry.torokhov@gmail.com, kernel@pengutronix.de,
        u.kleine-koenig@pengutronix.de, philippe.retornaz@epfl.ch,
        michael.thalmeier@hale.at, linux-kernel@vger.kernel.org,
        "Oskar Schirmer" <oskar@scara.com>
Subject: [PATCH 6/7] input/touchscreen: add calibration functionality with
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1329215672-15706-1-git-send-email-oskar@scara.com>
References: <1329215672-15706-1-git-send-email-oskar@scara.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently mc13xxx_ts does provide uncalibrated data only.
Add means to calibrate touchscreen through simple matrix calculus,
parameters accessible via sysfs.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
---
 drivers/input/touchscreen/Kconfig      |    1 +
 drivers/input/touchscreen/mc13xxx_ts.c |   87 +++++++++++++++++++++++++++++---
 2 files changed, 81 insertions(+), 7 deletions(-)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 51d19cb..9e315d7 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -587,6 +587,7 @@ config TOUCHSCREEN_USB_COMPOSITE
 config TOUCHSCREEN_MC13XXX
 	tristate "Freescale MC13XXX touchscreen input driver"
 	depends on MFD_MC13XXX
+	select SYSFS
 	help
 	  Say Y here if you have an Freescale MC13XXX PMIC on your
 	  board and want to use its touchscreen
diff --git a/drivers/input/touchscreen/mc13xxx_ts.c b/drivers/input/touchscreen/mc13xxx_ts.c
index 802228e..02f61a7 100644
--- a/drivers/input/touchscreen/mc13xxx_ts.c
+++ b/drivers/input/touchscreen/mc13xxx_ts.c
@@ -48,6 +48,7 @@ struct mc13xxx_ts_priv {
 	struct delayed_work work;
 	struct workqueue_struct *workq;
 	unsigned int sample[4];
+	int calibration[7];
 };
 
 static irqreturn_t mc13xxx_ts_handler(int irq, void *data)
@@ -76,6 +77,26 @@ static irqreturn_t mc13xxx_ts_handler(int irq, void *data)
 			swap(a0, a1);					\
 		})
 
+static void mc13xxx_report_abs_calibrated(struct mc13xxx_ts_priv *priv,
+			struct input_dev *idev, int x, int y)
+{
+	int *calib = priv->calibration;
+	int xc, yc;
+	if (calib[6]) {
+		xc = (calib[0] * x + calib[1] * y + calib[2]) / calib[6];
+		if (xc < 0)
+			xc = 0;
+		yc = (calib[3] * x + calib[4] * y + calib[5]) / calib[6];
+		if (yc < 0)
+			yc = 0;
+	} else {
+		xc = x;
+		yc = y;
+	}
+	input_report_abs(idev, ABS_X, xc);
+	input_report_abs(idev, ABS_Y, yc);
+}
+
 static void mc13783_ts_report_sample(struct mc13xxx_ts_priv *priv)
 {
 	struct input_dev *idev = priv->idev;
@@ -109,9 +130,7 @@ static void mc13783_ts_report_sample(struct mc13xxx_ts_priv *priv)
 			 y2 - y0 < sample_tolerance)) {
 		/* report the median coordinate and average pressure */
 		if (cr0) {
-			input_report_abs(idev, ABS_X, x1);
-			input_report_abs(idev, ABS_Y, y1);
-
+			mc13xxx_report_abs_calibrated(priv, idev, x1, y1);
 			dev_dbg(&idev->dev, "report (%d, %d, %d)\n",
 					x1, y1, 0x1000 - cr0);
 			queue_delayed_work(priv->workq, &priv->work, HZ / 50);
@@ -163,9 +182,7 @@ static void mc13892_ts_report_sample(struct mc13xxx_ts_priv *priv)
 		if (cr0) {
 			x0 = (x0 + x1) / 2;
 			y0 = (y0 + y1) / 2;
-			input_report_abs(idev, ABS_X, x0);
-			input_report_abs(idev, ABS_Y, y0);
-
+			mc13xxx_report_abs_calibrated(priv, idev, x0, y0);
 			dev_dbg(&idev->dev, "report (%d, %d, %d)\n",
 					x0, y0, cr0);
 			queue_delayed_work(priv->workq, &priv->work, HZ / 50);
@@ -239,6 +256,53 @@ static void mc13xxx_ts_close(struct input_dev *dev)
 	cancel_delayed_work_sync(&priv->work);
 }
 
+static ssize_t mc13xxx_calibration_show(struct device *d,
+		struct device_attribute *attr, char *buf)
+{
+	struct mc13xxx_ts_priv *priv = dev_get_drvdata(d);
+	int i, p, r;
+
+	p = 0;
+	for (i = 0; i < 7; i++) {
+		r = sprintf(&buf[p], i == 6 ? "%d\n" : "%d ",
+				priv->calibration[i]);
+		if (r < 0)
+			return r;
+		p += r;
+	}
+	return p;
+}
+
+static ssize_t mc13xxx_calibration_store(struct device *d,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct mc13xxx_ts_priv *priv = dev_get_drvdata(d);
+	int i, p, r;
+	int c[7];
+
+	p = 0;
+	for (i = 0; i < 7; i++) {
+		if (sscanf(&buf[p], "%d%n", &c[i], &r) != 1)
+			return -EINVAL;
+		p += r;
+	}
+	memcpy(priv->calibration, c, sizeof(priv->calibration));
+	return count;
+}
+
+static DEVICE_ATTR(calibration, S_IWUSR | S_IRUGO,
+		mc13xxx_calibration_show, mc13xxx_calibration_store);
+
+static int mc13xxx_init_sysfs(struct device *d)
+{
+	return device_create_file(d, &dev_attr_calibration);
+}
+
+static void mc13xxx_free_sysfs(struct device *d)
+{
+	device_remove_file(d, &dev_attr_calibration);
+}
+
 static int __init mc13xxx_ts_probe(struct platform_device *pdev)
 {
 	struct mc13xxx_ts_priv *priv;
@@ -286,16 +350,24 @@ static int __init mc13xxx_ts_probe(struct platform_device *pdev)
 
 	input_set_drvdata(idev, priv);
 
+	ret = mc13xxx_init_sysfs(&pdev->dev);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to init sysfs.\n");
+		goto err_destroy_wq;
+	}
+
 	ret = input_register_device(priv->idev);
 	if (ret) {
 		dev_err(&pdev->dev,
 			"register input device failed with %d\n", ret);
-		goto err_destroy_wq;
+		goto err_free_sysfs;
 	}
 
 	platform_set_drvdata(pdev, priv);
 	return 0;
 
+err_free_sysfs:
+	mc13xxx_free_sysfs(&pdev->dev);
 err_destroy_wq:
 	destroy_workqueue(priv->workq);
 err_free_mem:
@@ -310,6 +382,7 @@ static int __devexit mc13xxx_ts_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 
+	mc13xxx_free_sysfs(&pdev->dev);
 	destroy_workqueue(priv->workq);
 	input_unregister_device(priv->idev);
 	kfree(priv);
-- 
1.7.5.4

