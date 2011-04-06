Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab1DFLLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:11:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52680 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab1DFLLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:11:16 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, tglx@linutronix.de, cbouatmailru@gmail.com,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net,
        Jamie Iles <jamie@jamieiles.com>
Subject: [RFC PATCH 3/7] basic_mmio_gpio: allow overriding number of gpio
Date: Wed,  6 Apr 2011 12:10:59 +0100
Message-Id: <1302088263-12714-4-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1302088263-12714-1-git-send-email-jamie@jamieiles.com>
References: <1302088263-12714-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms may have a number of GPIO that is less than the register
width of the peripheral.

Signed-off-by: Jamie Iles <jamie@jamieiles.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/gpio/basic_mmio_gpio.c  |   17 +++++++++++------
 include/linux/basic_mmio_gpio.h |    1 +
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
index e6cce48..68f8b8b 100644
--- a/drivers/gpio/basic_mmio_gpio.c
+++ b/drivers/gpio/basic_mmio_gpio.c
@@ -240,6 +240,7 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 	resource_size_t dat_sz;
 	int bits;
 	int ret;
+	int ngpio;
 
 	res_dat = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dat");
 	if (!res_dat)
@@ -250,6 +251,7 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	bits = dat_sz * 8;
+	ngpio = bits;
 	if (bits > BITS_PER_LONG)
 		return -EINVAL;
 
@@ -276,6 +278,13 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	if (pdata) {
+		bgc->gc.base = pdata->base;
+		if (pdata->ngpio > 0)
+			ngpio = pdata->ngpio;
+	} else
+		bgc->gc.base = -1;
+
 	bgc->bits = bits;
 	ret = bgpio_setup_accessors(pdev, bgc);
 	if (ret)
@@ -283,7 +292,8 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 
 	spin_lock_init(&bgc->lock);
 	bgc->data = bgc->read_reg(bgc->reg_dat);
-	bgc->gc.ngpio = bits;
+
+	bgc->gc.ngpio = ngpio;
 	bgc->gc.direction_input = bgpio_dir_in;
 	bgc->gc.direction_output = bgpio_dir_out;
 	bgc->gc.get = bgpio_get;
@@ -291,11 +301,6 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 	bgc->gc.dev = dev;
 	bgc->gc.label = dev_name(dev);
 
-	if (pdata)
-		bgc->gc.base = pdata->base;
-	else
-		bgc->gc.base = -1;
-
 	platform_set_drvdata(pdev, bgc);
 
 	ret = gpiochip_add(&bgc->gc);
diff --git a/include/linux/basic_mmio_gpio.h b/include/linux/basic_mmio_gpio.h
index 198087a..f23ec73 100644
--- a/include/linux/basic_mmio_gpio.h
+++ b/include/linux/basic_mmio_gpio.h
@@ -15,6 +15,7 @@
 
 struct bgpio_pdata {
 	int base;
+	int ngpio;
 };
 
 #endif /* __BASIC_MMIO_GPIO_H */
-- 
1.7.4

