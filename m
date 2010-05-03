Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab0ECGmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 02:42:36 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:58560 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275Ab0ECGmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 02:42:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Ffssej3ri4K+jTuDmtF1lgHbtJ1K6cBnS3xlenD+uw07wNu5+Iw+2b/oOH/OIYQ7Xq
         jE+4sJQYb+ygVBPcrg3+4q+AwjTa6PtuoWABeVFKA/UvYVWfQ0ggDy6RTW2Ra7AHaUbX
         ol1FYSFCGUlfpokcIqoOMm9+Vbklp8HKMtl70=
Subject: [PATCH] l4f00242t03: fix error handling in l4f00242t03_probe
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Alberto Panizzo <maramaopercheseimorto@gmail.com>,
       ";Richard Purdie" <rpurdie@linux.intel.com>
Content-Type: text/plain
Date: Mon, 03 May 2010 14:42:44 +0800
Message-Id: <1272868964.2861.5.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch includes below fixes for properly error handling:
1. In the case of kzalloc failure, simple return -ENOMEM instead of goto
err. ( priv is NULL in this case )
2. In the case of gpio_request fail for reset_gpio and data_enable_gpio,
   properly release resources by goto err and err2 respectively.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/l4f00242t03.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/l4f00242t03.c
b/drivers/video/backlight/l4f00242t03.c
index bcdb12c..a4632db 100644
--- a/drivers/video/backlight/l4f00242t03.c
+++ b/drivers/video/backlight/l4f00242t03.c
@@ -125,8 +125,7 @@ static int __devinit l4f00242t03_probe(struct
spi_device *spi)
 
 	if (priv == NULL) {
 		dev_err(&spi->dev, "No memory for this device.\n");
-		ret = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 
 	dev_set_drvdata(&spi->dev, priv);
@@ -139,7 +138,7 @@ static int __devinit l4f00242t03_probe(struct
spi_device *spi)
 	if (ret) {
 		dev_err(&spi->dev,
 			"Unable to get the lcd l4f00242t03 reset gpio.\n");
-		return ret;
+		goto err;
 	}
 
 	ret = gpio_direction_output(pdata->reset_gpio, 1);
@@ -151,7 +150,7 @@ static int __devinit l4f00242t03_probe(struct
spi_device *spi)
 	if (ret) {
 		dev_err(&spi->dev,
 			"Unable to get the lcd l4f00242t03 data en gpio.\n");
-		return ret;
+		goto err2;
 	}
 
 	ret = gpio_direction_output(pdata->data_enable_gpio, 0);
-- 
1.5.4.3



