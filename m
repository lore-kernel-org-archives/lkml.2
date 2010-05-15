Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab0EOU6q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 16:58:46 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:40456 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab0EOU6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 16:58:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-tuid:x-uid:x-length:to
         :reply-to:content-type:content-transfer-encoding:message-id;
        b=OMlfIuKdDATi+Fe3mrPXsswqfFNQGosHjPyQJN5xg29jxFZwM4GLlTBWpraKMGfKB0
         h+gLhddxPCojXPg+UIVxbX2LHhxVjugJB3jIjk2OkxlXR8E+Thpj31mWIMclRUQt8XiB
         /Ikb+S9oOzZveOzBxomLuzPzqyfdLtRmJdZRI=
From: Florian Fainelli <florian@openwrt.org>
Date: Sat, 15 May 2010 22:58:27 +0200
Subject: [PATCH v2] MFD: rdc321x: change resources flags to IORESOURCE_IO
MIME-Version: 1.0
X-TUID: d0e10975922db5ea
X-Length: 3706
To: Samuel Ortiz <sameo@linux.intel.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Reply-To: Florian Fainelli <florian@openwrt.org>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005152258.28538.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rdc321x southbridge PCI device has no MEM PCI resources that we could
pass to mfd_add_devices. Since 33254dd5, mfd_add_device checks for the
mem_base argument that we set to NULL. Changing the resources passed to
our MFD cells from IORESOURCE_MEM to IORESOURCE_IO fixes that. Since we use
those resources as offsets to the PCI configuration space base address of
the southbridge device this is also more adequate.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/drivers/gpio/rdc321x-gpio.c b/drivers/gpio/rdc321x-gpio.c
index e344907..22f31dc 100644
--- a/drivers/gpio/rdc321x-gpio.c
+++ b/drivers/gpio/rdc321x-gpio.c
@@ -147,7 +147,7 @@ static int __devinit rdc321x_gpio_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "gpio-reg1");
+	r = platform_get_resource_byname(pdev, IORESOURCE_IO, "gpio-reg1");
 	if (!r) {
 		dev_err(&pdev->dev, "failed to get gpio-reg1 resource\n");
 		err = -ENODEV;
@@ -159,7 +159,7 @@ static int __devinit rdc321x_gpio_probe(struct platform_device *pdev)
 	rdc321x_gpio_dev->reg1_ctrl_base = r->start;
 	rdc321x_gpio_dev->reg1_data_base = r->start + 0x4;
 
-	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "gpio-reg2");
+	r = platform_get_resource_byname(pdev, IORESOURCE_IO, "gpio-reg2");
 	if (!r) {
 		dev_err(&pdev->dev, "failed to get gpio-reg2 resource\n");
 		err = -ENODEV;
diff --git a/drivers/mfd/rdc321x-southbridge.c b/drivers/mfd/rdc321x-southbridge.c
index 256dd56..5092297 100644
--- a/drivers/mfd/rdc321x-southbridge.c
+++ b/drivers/mfd/rdc321x-southbridge.c
@@ -34,7 +34,7 @@ static struct resource rdc321x_wdt_resource[] = {
 		.name	= "wdt-reg",
 		.start	= RDC321X_WDT_CTRL,
 		.end	= RDC321X_WDT_CTRL + 0x3,
-		.flags	= IORESOURCE_MEM,
+		.flags	= IORESOURCE_IO,
 	}
 };
 
@@ -47,12 +47,12 @@ static struct resource rdc321x_gpio_resources[] = {
 		.name	= "gpio-reg1",
 		.start	= RDC321X_GPIO_CTRL_REG1,
 		.end	= RDC321X_GPIO_CTRL_REG1 + 0x7,
-		.flags	= IORESOURCE_MEM,
+		.flags	= IORESOURCE_IO,
 	}, {
 		.name	= "gpio-reg2",
 		.start	= RDC321X_GPIO_CTRL_REG2,
 		.end	= RDC321X_GPIO_CTRL_REG2 + 0x7,
-		.flags	= IORESOURCE_MEM,
+		.flags	= IORESOURCE_IO,
 	}
 };
 
diff --git a/drivers/watchdog/rdc321x_wdt.c b/drivers/watchdog/rdc321x_wdt.c
index 4733a99..428f8a1 100644
--- a/drivers/watchdog/rdc321x_wdt.c
+++ b/drivers/watchdog/rdc321x_wdt.c
@@ -237,7 +237,7 @@ static int __devinit rdc321x_wdt_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "wdt-reg");
+	r = platform_get_resource_byname(pdev, IORESOURCE_IO, "wdt-reg");
 	if (!r) {
 		dev_err(&pdev->dev, "failed to get wdt-reg resource\n");
 		return -ENODEV;
