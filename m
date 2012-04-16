Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab2DPJVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 05:21:37 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:10345 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2DPJVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 05:21:34 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, olof@lixom.net
Cc: plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org
Subject: [PATCH 12/12] USB: gadget/at91_udc: add gpio_to_irq() function to vbus interrupt
Date: Mon, 16 Apr 2012 11:20:56 +0200
Message-Id: <041833f4078b6c28cf8a286fad8982bfae18f4b8.1334567594.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1334567594.git.nicolas.ferre@atmel.com>
References: <cover.1334567594.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1334567594.git.nicolas.ferre@atmel.com>
References: <cover.1334567594.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we are using irqdomains, we need to convert GPIO pins to Linux
IRQ numbers using the gpio_to_irq() function.
This call is added to request/free_irq calls.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/gadget/at91_udc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 0c935d7..9d7bcd9 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1863,8 +1863,8 @@ static int __devinit at91udc_probe(struct platform_device *pdev)
 			mod_timer(&udc->vbus_timer,
 				  jiffies + VBUS_POLL_TIMEOUT);
 		} else {
-			if (request_irq(udc->board.vbus_pin, at91_vbus_irq,
-					0, driver_name, udc)) {
+			if (request_irq(gpio_to_irq(udc->board.vbus_pin),
+					at91_vbus_irq, 0, driver_name, udc)) {
 				DBG("request vbus irq %d failed\n",
 				    udc->board.vbus_pin);
 				retval = -EBUSY;
@@ -1886,7 +1886,7 @@ static int __devinit at91udc_probe(struct platform_device *pdev)
 	return 0;
 fail4:
 	if (gpio_is_valid(udc->board.vbus_pin) && !udc->board.vbus_polled)
-		free_irq(udc->board.vbus_pin, udc);
+		free_irq(gpio_to_irq(udc->board.vbus_pin), udc);
 fail3:
 	if (gpio_is_valid(udc->board.vbus_pin))
 		gpio_free(udc->board.vbus_pin);
@@ -1924,7 +1924,7 @@ static int __exit at91udc_remove(struct platform_device *pdev)
 	device_init_wakeup(&pdev->dev, 0);
 	remove_debug_file(udc);
 	if (gpio_is_valid(udc->board.vbus_pin)) {
-		free_irq(udc->board.vbus_pin, udc);
+		free_irq(gpio_to_irq(udc->board.vbus_pin), udc);
 		gpio_free(udc->board.vbus_pin);
 	}
 	free_irq(udc->udp_irq, udc);
-- 
1.7.10

