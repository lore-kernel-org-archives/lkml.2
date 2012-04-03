Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab2DCHdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 03:33:32 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:42517 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab2DCHdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 03:33:25 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Cc: plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de, olof@lixom.net,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2 05/13] USB: ohci-at91: rework and fix initialization
Date: Tue,  3 Apr 2012 09:32:49 +0200
Message-Id: <0ec972f229c333d056f4bbecbfd42113d1a43f43.1333437885.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <cover.1333437885.git.nicolas.ferre@atmel.com>
References: <cover.1333437885.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1333437885.git.nicolas.ferre@atmel.com>
References: <cover.1333437885.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DT information are filled in a pdata structure and then passed on
to the usual check code of the probe function. Thus we do not need to
redo the gpio checking and irq configuration in the DT-related code.
On the other hand, we setup GPIO direction in driver for vbus and
overcurrent. It will be useful when moving to pinctrl subsystem.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
 drivers/usb/host/ohci-at91.c |   88 ++++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 42 deletions(-)

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index 4d266ae..c30da6a 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -492,7 +492,7 @@ static u64 at91_ohci_dma_mask = DMA_BIT_MASK(32);
 static int __devinit ohci_at91_of_init(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
-	int i, ret, gpio;
+	int i, gpio;
 	enum of_gpio_flags flags;
 	struct at91_usbh_data	*pdata;
 	u32 ports;
@@ -520,42 +520,11 @@ static int __devinit ohci_at91_of_init(struct platform_device *pdev)
 		if (!gpio_is_valid(gpio))
 			continue;
 		pdata->vbus_pin_active_low[i] = flags & OF_GPIO_ACTIVE_LOW;
-		ret = gpio_request(gpio, "ohci_vbus");
-		if (ret) {
-			dev_warn(&pdev->dev, "can't request vbus gpio %d", gpio);
-			continue;
-		}
-		ret = gpio_direction_output(gpio, !(flags & OF_GPIO_ACTIVE_LOW) ^ 1);
-		if (ret)
-			dev_warn(&pdev->dev, "can't put vbus gpio %d as output %d",
-				 !(flags & OF_GPIO_ACTIVE_LOW) ^ 1, gpio);
 	}
 
-	for (i = 0; i < 2; i++) {
-		gpio = of_get_named_gpio_flags(np, "atmel,oc-gpio", i, &flags);
-		pdata->overcurrent_pin[i] = gpio;
-		if (!gpio_is_valid(gpio))
-			continue;
-		ret = gpio_request(gpio, "ohci_overcurrent");
-		if (ret) {
-			dev_err(&pdev->dev, "can't request overcurrent gpio %d", gpio);
-			continue;
-		}
-
-		ret = gpio_direction_input(gpio);
-		if (ret) {
-			dev_err(&pdev->dev, "can't configure overcurrent gpio %d as input", gpio);
-			continue;
-		}
-
-		ret = request_irq(gpio_to_irq(gpio),
-				  ohci_hcd_at91_overcurrent_irq,
-				  IRQF_SHARED, "ohci_overcurrent", pdev);
-		if (ret) {
-			gpio_free(gpio);
-			dev_warn(& pdev->dev, "cannot get GPIO IRQ for overcurrent\n");
-		}
-	}
+	for (i = 0; i < 2; i++)
+		pdata->overcurrent_pin[i] =
+			of_get_named_gpio_flags(np, "atmel,oc-gpio", i, &flags);
 
 	pdev->dev.platform_data = pdata;
 
@@ -574,6 +543,8 @@ static int ohci_hcd_at91_drv_probe(struct platform_device *pdev)
 {
 	struct at91_usbh_data	*pdata;
 	int			i;
+	int			gpio;
+	int			ret;
 
 	i = ohci_at91_of_init(pdev);
 
@@ -586,23 +557,56 @@ static int ohci_hcd_at91_drv_probe(struct platform_device *pdev)
 		for (i = 0; i < ARRAY_SIZE(pdata->vbus_pin); i++) {
 			if (!gpio_is_valid(pdata->vbus_pin[i]))
 				continue;
-			gpio_request(pdata->vbus_pin[i], "ohci_vbus");
+			gpio = pdata->vbus_pin[i];
+
+			ret = gpio_request(gpio, "ohci_vbus");
+			if (ret) {
+				dev_err(&pdev->dev,
+					"can't request vbus gpio %d\n", gpio);
+				continue;
+			}
+			ret = gpio_direction_output(gpio,
+						!pdata->vbus_pin_active_low[i]);
+			if (ret) {
+				dev_err(&pdev->dev,
+					"can't put vbus gpio %d as output %d\n",
+					gpio, !pdata->vbus_pin_active_low[i]);
+				gpio_free(gpio);
+				continue;
+			}
+
 			ohci_at91_usb_set_power(pdata, i, 1);
 		}
 
 		for (i = 0; i < ARRAY_SIZE(pdata->overcurrent_pin); i++) {
-			int ret;
-
 			if (!gpio_is_valid(pdata->overcurrent_pin[i]))
 				continue;
-			gpio_request(pdata->overcurrent_pin[i], "ohci_overcurrent");
+			gpio = pdata->overcurrent_pin[i];
+
+			ret = gpio_request(gpio, "ohci_overcurrent");
+			if (ret) {
+				dev_err(&pdev->dev,
+					"can't request overcurrent gpio %d\n",
+					gpio);
+				continue;
+			}
+
+			ret = gpio_direction_input(gpio);
+			if (ret) {
+				dev_err(&pdev->dev,
+					"can't configure overcurrent gpio %d as input\n",
+					gpio);
+				gpio_free(gpio);
+				continue;
+			}
 
-			ret = request_irq(gpio_to_irq(pdata->overcurrent_pin[i]),
+			ret = request_irq(gpio_to_irq(gpio),
 					  ohci_hcd_at91_overcurrent_irq,
 					  IRQF_SHARED, "ohci_overcurrent", pdev);
 			if (ret) {
-				gpio_free(pdata->overcurrent_pin[i]);
-				dev_warn(& pdev->dev, "cannot get GPIO IRQ for overcurrent\n");
+				gpio_free(gpio);
+				dev_err(&pdev->dev,
+					"can't get gpio IRQ for overcurrent\n");
 			}
 		}
 	}
-- 
1.7.9.4

