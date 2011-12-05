Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab1LEHuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 02:50:55 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35825 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1LEHuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 02:50:54 -0500
Message-ID: <1323071447.20963.3.camel@phoenix>
Subject: [PATCH] spi: use gpio_request_one() instead of spi_gpio_alloc()
 helper function
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net
Date: Mon, 05 Dec 2011 15:50:47 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/spi/spi-gpio.c |   21 ++++-----------------
 1 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/spi/spi-gpio.c b/drivers/spi/spi-gpio.c
index e093d3e..85c2eca 100644
--- a/drivers/spi/spi-gpio.c
+++ b/drivers/spi/spi-gpio.c
@@ -256,20 +256,6 @@ static void spi_gpio_cleanup(struct spi_device *spi)
 	spi_bitbang_cleanup(spi);
 }
 
-static int __init spi_gpio_alloc(unsigned pin, const char *label, bool is_in)
-{
-	int value;
-
-	value = gpio_request(pin, label);
-	if (value == 0) {
-		if (is_in)
-			value = gpio_direction_input(pin);
-		else
-			value = gpio_direction_output(pin, 0);
-	}
-	return value;
-}
-
 static int __init
 spi_gpio_request(struct spi_gpio_platform_data *pdata, const char *label,
 	u16 *res_flags)
@@ -279,7 +265,8 @@ spi_gpio_request(struct spi_gpio_platform_data *pdata, const char *label,
 	/* NOTE:  SPI_*_GPIO symbols may reference "pdata" */
 
 	if (SPI_MOSI_GPIO != SPI_GPIO_NO_MOSI) {
-		value = spi_gpio_alloc(SPI_MOSI_GPIO, label, false);
+		value = gpio_request_one(SPI_MOSI_GPIO, GPIOF_OUT_INIT_LOW,
+					 label);
 		if (value)
 			goto done;
 	} else {
@@ -288,7 +275,7 @@ spi_gpio_request(struct spi_gpio_platform_data *pdata, const char *label,
 	}
 
 	if (SPI_MISO_GPIO != SPI_GPIO_NO_MISO) {
-		value = spi_gpio_alloc(SPI_MISO_GPIO, label, true);
+		value = gpio_request_one(SPI_MISO_GPIO, GPIOF_IN, label);
 		if (value)
 			goto free_mosi;
 	} else {
@@ -296,7 +283,7 @@ spi_gpio_request(struct spi_gpio_platform_data *pdata, const char *label,
 		*res_flags |= SPI_MASTER_NO_RX;
 	}
 
-	value = spi_gpio_alloc(SPI_SCK_GPIO, label, false);
+	value = gpio_request_one(SPI_SCK_GPIO, GPIOF_OUT_INIT_LOW, label);
 	if (value)
 		goto free_miso;
 
-- 
1.7.5.4



