Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab2FMLUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:20:31 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:64709 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2FMLUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:20:30 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-22-4fd8777d3e24
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Dmitry Baryshkov'" <dbaryshkov@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Axel Lin'" <axel.lin@gmail.com>
Subject: [PATCH 3/7] backlight: tosa_lcd: use devm_gpio_request()
Date: Wed, 13 Jun 2012 20:20:29 +0900
Message-id: <000401cd4956$89e2a700$9da7f500$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1JVonNoJvbbksZQQi+Krp3oBcwLg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t9jQd3a8hv+BtPfy1pc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mb+/OMRas4KnYNfUHewPjfK4uRk4OCQETiel7W9kgbDGJC/fW
	A9lcHEIC0xklvi3+zgrhzGaS6Lj2kR2kik1ATeLLl8NgtohAhETzjFnMIEXMAnMYJda8XsAC
	khAWcJTYd/M72FgWAVWJJ20bwWxeAVuJjvcHGSFsQYkfk++B1TMLaEms33mcCcKWl9i85i3Q
	UA6gk9QlHv3VhdilJ3FlTx9UiYjEvhfvGCcwCsxCMmkWkkmzkEyahaRlASPLKkbR1ILkguKk
	9FxDveLE3OLSvHS95PzcTYzg0HwmtYNxZYPFIUYBDkYlHt4NRTf8hVgTy4orcw8xSnAwK4nw
	PssGCvGmJFZWpRblxxeV5qQWH2KU5mBREudtsr7gLySQnliSmp2aWpBaBJNl4uCUamBceGGN
	5Z3gvTJ/u95+uTW9J6UveWXzKqb3Z6sCb6d/ZTio08izcPPLwghvZ8Vbk8ONZ/MrXth3IODh
	Jm+Tm8UbXy1wbTA9mqK0z7torvGZtu3/pbbJP8sx1VvKk3AgV6CizUL1XPuLKE7fKlY1+Taz
	xuvbl/FknBRhSTmldlfQTt6aVZJlZY4SS3FGoqEWc1FxIgAbqW+ZSQIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_gpio_request of these functions.

Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/tosa_lcd.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/tosa_lcd.c b/drivers/video/backlight/tosa_lcd.c
index 47823b8..33047a6 100644
--- a/drivers/video/backlight/tosa_lcd.c
+++ b/drivers/video/backlight/tosa_lcd.c
@@ -193,7 +193,7 @@ static int __devinit tosa_lcd_probe(struct spi_device *spi)
 	data->spi = spi;
 	dev_set_drvdata(&spi->dev, data);
 
-	ret = gpio_request(TOSA_GPIO_TG_ON, "tg #pwr");
+	ret = devm_gpio_request(&spi->dev, TOSA_GPIO_TG_ON, "tg #pwr");
 	if (ret < 0)
 		goto err_gpio_tg;
 
@@ -201,7 +201,7 @@ static int __devinit tosa_lcd_probe(struct spi_device *spi)
 
 	ret = gpio_direction_output(TOSA_GPIO_TG_ON, 0);
 	if (ret < 0)
-		goto err_gpio_dir;
+		goto err_gpio_tg;
 
 	mdelay(60);
 	tosa_lcd_tg_init(data);
@@ -221,8 +221,6 @@ static int __devinit tosa_lcd_probe(struct spi_device *spi)
 
 err_register:
 	tosa_lcd_tg_off(data);
-err_gpio_dir:
-	gpio_free(TOSA_GPIO_TG_ON);
 err_gpio_tg:
 	dev_set_drvdata(&spi->dev, NULL);
 	return ret;
@@ -239,7 +237,6 @@ static int __devexit tosa_lcd_remove(struct spi_device *spi)
 
 	tosa_lcd_tg_off(data);
 
-	gpio_free(TOSA_GPIO_TG_ON);
 	dev_set_drvdata(&spi->dev, NULL);
 
 	return 0;
-- 
1.7.1


