Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3AGTS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 14:18:56 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:49068 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab3AGTSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 14:18:54 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: lm-sensors@lm-sensors.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Subject: [PATCH] hwmon: (sht15) check GPIO directions
Date: Mon,  7 Jan 2013 14:18:39 -0500
Message-Id: <1357586319-2089-2-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357586319-2089-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1357586319-2089-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch, the SHT15 driver may fail silently with a
non-bidirectional data line and/or an input-only clock line. The patch
checks the return value of gpio_direction_* function calls, prints an
error message for void-returning functions or returns the corresponding
error code otherwise.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 drivers/hwmon/sht15.c | 43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index 9a594e6..10b078c 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -216,7 +216,10 @@ static void sht15_connection_reset(struct sht15_data *data)
 {
 	int i;
 
-	gpio_direction_output(data->pdata->gpio_data, 1);
+	if (gpio_direction_output(data->pdata->gpio_data, 1)) {
+		dev_err(data->dev, "failed to set data line direction to output\n");
+		return;
+	}
 	ndelay(SHT15_TSCKL);
 	gpio_set_value(data->pdata->gpio_sck, 0);
 	ndelay(SHT15_TSCKL);
@@ -254,7 +257,10 @@ static inline void sht15_send_bit(struct sht15_data *data, int val)
 static void sht15_transmission_start(struct sht15_data *data)
 {
 	/* ensure data is high and output */
-	gpio_direction_output(data->pdata->gpio_data, 1);
+	if (gpio_direction_output(data->pdata->gpio_data, 1)) {
+		dev_err(data->dev, "failed to set data line direction to output\n");
+		return;
+	}
 	ndelay(SHT15_TSU);
 	gpio_set_value(data->pdata->gpio_sck, 0);
 	ndelay(SHT15_TSCKL);
@@ -293,7 +299,11 @@ static void sht15_send_byte(struct sht15_data *data, u8 byte)
  */
 static int sht15_wait_for_response(struct sht15_data *data)
 {
-	gpio_direction_input(data->pdata->gpio_data);
+	int err;
+
+	err = gpio_direction_input(data->pdata->gpio_data);
+	if (err)
+		return err;
 	gpio_set_value(data->pdata->gpio_sck, 1);
 	ndelay(SHT15_TSCKH);
 	if (gpio_get_value(data->pdata->gpio_data)) {
@@ -354,7 +364,10 @@ static int sht15_soft_reset(struct sht15_data *data)
  */
 static void sht15_ack(struct sht15_data *data)
 {
-	gpio_direction_output(data->pdata->gpio_data, 0);
+	if (gpio_direction_output(data->pdata->gpio_data, 0)) {
+		dev_err(data->dev, "failed to set data line direction to output\n");
+		return;
+	}
 	ndelay(SHT15_TSU);
 	gpio_set_value(data->pdata->gpio_sck, 1);
 	ndelay(SHT15_TSU);
@@ -362,7 +375,8 @@ static void sht15_ack(struct sht15_data *data)
 	ndelay(SHT15_TSU);
 	gpio_set_value(data->pdata->gpio_data, 1);
 
-	gpio_direction_input(data->pdata->gpio_data);
+	if (gpio_direction_input(data->pdata->gpio_data))
+		dev_err(data->dev, "failed to set data line direction to input\n");
 }
 
 /**
@@ -373,7 +387,10 @@ static void sht15_ack(struct sht15_data *data)
  */
 static void sht15_end_transmission(struct sht15_data *data)
 {
-	gpio_direction_output(data->pdata->gpio_data, 1);
+	if (gpio_direction_output(data->pdata->gpio_data, 1)) {
+		dev_err(data->dev, "failed to set data line direction to output\n");
+		return;
+	}
 	ndelay(SHT15_TSU);
 	gpio_set_value(data->pdata->gpio_sck, 1);
 	ndelay(SHT15_TSCKH);
@@ -415,7 +432,9 @@ static int sht15_send_status(struct sht15_data *data, u8 status)
 	ret = sht15_send_cmd(data, SHT15_WRITE_STATUS);
 	if (ret)
 		return ret;
-	gpio_direction_output(data->pdata->gpio_data, 1);
+	ret = gpio_direction_output(data->pdata->gpio_data, 1);
+	if (ret)
+		return ret;
 	ndelay(SHT15_TSU);
 	sht15_send_byte(data, status);
 	ret = sht15_wait_for_response(data);
@@ -511,7 +530,9 @@ static int sht15_measurement(struct sht15_data *data,
 	if (ret)
 		return ret;
 
-	gpio_direction_input(data->pdata->gpio_data);
+	ret = gpio_direction_input(data->pdata->gpio_data);
+	if (ret)
+		return ret;
 	atomic_set(&data->interrupt_handled, 0);
 
 	enable_irq(gpio_to_irq(data->pdata->gpio_data));
@@ -947,7 +968,11 @@ static int sht15_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "gpio request failed\n");
 		goto err_release_reg;
 	}
-	gpio_direction_output(data->pdata->gpio_sck, 0);
+	ret = gpio_direction_output(data->pdata->gpio_sck, 0);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to set clock line direction to output\n");
+		goto err_release_reg;
+	}
 
 	ret = devm_gpio_request(&pdev->dev, data->pdata->gpio_data,
 				"SHT15 data");
-- 
1.8.1

