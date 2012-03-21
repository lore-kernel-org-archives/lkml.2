Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030313Ab2CUBZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 21:25:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61647 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab2CUBZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 21:25:06 -0400
Message-ID: <1332293097.10465.1.camel@phoenix>
Subject: [PATCH] Staging: android: timed_gpio: Fix resource leak in
 timed_gpio_probe error paths
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Mike Lockwood <lockwood@android.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 21 Mar 2012 09:24:57 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If gpio_request fails, we need to free all allocated resources.
Current code uses wrong array index to access gpio_data array.
So current code actually frees gpio_data[i].gpio by j times.

This patch moves the error handling code to err_out and thus improves
readability.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/staging/android/timed_gpio.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/android/timed_gpio.c b/drivers/staging/android/timed_gpio.c
index bc723ef..45c522c 100644
--- a/drivers/staging/android/timed_gpio.c
+++ b/drivers/staging/android/timed_gpio.c
@@ -85,7 +85,7 @@ static int timed_gpio_probe(struct platform_device *pdev)
 	struct timed_gpio_platform_data *pdata = pdev->dev.platform_data;
 	struct timed_gpio *cur_gpio;
 	struct timed_gpio_data *gpio_data, *gpio_dat;
-	int i, j, ret = 0;
+	int i, ret;
 
 	if (!pdata)
 		return -EBUSY;
@@ -108,18 +108,12 @@ static int timed_gpio_probe(struct platform_device *pdev)
 		gpio_dat->dev.get_time = gpio_get_time;
 		gpio_dat->dev.enable = gpio_enable;
 		ret = gpio_request(cur_gpio->gpio, cur_gpio->name);
-		if (ret >= 0) {
-			ret = timed_output_dev_register(&gpio_dat->dev);
-			if (ret < 0)
-				gpio_free(cur_gpio->gpio);
-		}
+		if (ret < 0)
+			goto err_out;
+		ret = timed_output_dev_register(&gpio_dat->dev);
 		if (ret < 0) {
-			for (j = 0; j < i; j++) {
-				timed_output_dev_unregister(&gpio_data[i].dev);
-				gpio_free(gpio_data[i].gpio);
-			}
-			kfree(gpio_data);
-			return ret;
+			gpio_free(cur_gpio->gpio);
+			goto err_out;
 		}
 
 		gpio_dat->gpio = cur_gpio->gpio;
@@ -131,6 +125,15 @@ static int timed_gpio_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, gpio_data);
 
 	return 0;
+
+err_out:
+	while (--i >= 0) {
+		timed_output_dev_unregister(&gpio_data[i].dev);
+		gpio_free(gpio_data[i].gpio);
+	}
+	kfree(gpio_data);
+
+	return ret;
 }
 
 static int timed_gpio_remove(struct platform_device *pdev)
-- 
1.7.5.4



