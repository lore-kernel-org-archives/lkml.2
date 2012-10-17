Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab2JQFur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 01:50:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64457 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab2JQFuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 01:50:46 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-fa-507e4735346d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Dmitry Baryshkov'" <dbaryshkov@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 2/2] backlight: tosa: use devm_gpio_request_one
Date: Wed, 17 Oct 2012 14:50:44 +0900
Message-id: <003901cdac2b$5995e7a0$0cc1b6e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2sK1lStTcjZNO+Q1axxdwmjwdK/g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAV1T97oAg5vrRSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGhMY9zAXn+Cv2fPjI3MDYy9vFyMkhIWAicf/HREYIW0ziwr31
	bF2MXBxCAosYJabd3gvlzGaS2HTpFjtIFZuAmsSXL4fBbBGBCInmGbOYQWxmgUqJRau6weLC
	AvYS99ZdYAKxWQRUJXoXHQDbwCtgK/F70xdmCFtQ4sfkeywQvVoSm7c1sULY8hKb17wFquEA
	ukhd4tFfXYhVehKfTrYzQpSISOx78Y5xAqPALCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrP
	NdQrTswtLs1L10vOz93ECA7MZ1I7GFc2WBxiFOBgVOLh/TC7NkCINbGsuDL3EKMEB7OSCK95
	I1CINyWxsiq1KD++qDQntfgQozQHi5I4b7NHSoCQQHpiSWp2ampBahFMlomDU6qBkdNr/beo
	Nddeijpu9hfYqKNWaPKxlnfWhhc6CxuOfDetKmZkmJT15KH1feu4ppYkVY7ki2cPPks0Drle
	MePbwuTdvxMbbXMN487pC0wUcmvfN3Nhyvo7r97qbJ33iiH1qdQTvcuamoty8h2nZYlf0mjV
	eHSOWazi14ste0POJ0hnSXn56a28rMRSnJFoqMVcVJwIAO+RDaRIAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By using devm_gpio_request_one it is possible to set the direction
and initial value in one shot. Thus, using devm_gpio_request_one
can make the code simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 drivers/video/backlight/tosa_bl.c  |    6 ++----
 drivers/video/backlight/tosa_lcd.c |    8 ++------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/video/backlight/tosa_bl.c b/drivers/video/backlight/tosa_bl.c
index 49342e1..60f258c 100644
--- a/drivers/video/backlight/tosa_bl.c
+++ b/drivers/video/backlight/tosa_bl.c
@@ -92,14 +92,12 @@ static int __devinit tosa_bl_probe(struct i2c_client *client,
 
 	data->comadj = sharpsl_param.comadj == -1 ? COMADJ_DEFAULT : sharpsl_param.comadj;
 
-	ret = devm_gpio_request(&client->dev, TOSA_GPIO_BL_C20MA, "backlight");
+	ret = devm_gpio_request_one(&client->dev, TOSA_GPIO_BL_C20MA,
+				GPIOF_OUT_INIT_LOW, "backlight");
 	if (ret) {
 		dev_dbg(&data->bl->dev, "Unable to request gpio!\n");
 		return ret;
 	}
-	ret = gpio_direction_output(TOSA_GPIO_BL_C20MA, 0);
-	if (ret)
-		return ret;
 
 	i2c_set_clientdata(client, data);
 	data->i2c = client;
diff --git a/drivers/video/backlight/tosa_lcd.c b/drivers/video/backlight/tosa_lcd.c
index 33047a6..00a8f21 100644
--- a/drivers/video/backlight/tosa_lcd.c
+++ b/drivers/video/backlight/tosa_lcd.c
@@ -193,17 +193,13 @@ static int __devinit tosa_lcd_probe(struct spi_device *spi)
 	data->spi = spi;
 	dev_set_drvdata(&spi->dev, data);
 
-	ret = devm_gpio_request(&spi->dev, TOSA_GPIO_TG_ON, "tg #pwr");
+	ret = devm_gpio_request_one(&spi->dev, TOSA_GPIO_TG_ON,
+				GPIOF_OUT_INIT_LOW, "tg #pwr");
 	if (ret < 0)
 		goto err_gpio_tg;
 
 	mdelay(60);
 
-	ret = gpio_direction_output(TOSA_GPIO_TG_ON, 0);
-	if (ret < 0)
-		goto err_gpio_tg;
-
-	mdelay(60);
 	tosa_lcd_tg_init(data);
 
 	tosa_lcd_tg_on(data);
-- 
1.7.1


