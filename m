Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab2ADCUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 21:20:23 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:53621 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756295Ab2ADCUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 21:20:20 -0500
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: linus.walleij@linaro.org, swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, arnd@arndb.de
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: [PATCH v4 3/3] gpio: pxa: request pinmux function for gpio
Date: Wed,  4 Jan 2012 10:26:35 +0800
Message-Id: <1325643995-20745-4-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1325643995-20745-1-git-send-email-haojian.zhuang@marvell.com>
References: <1325643995-20745-1-git-send-email-haojian.zhuang@marvell.com>
X-OriginalArrivalTime: 04 Jan 2012 02:19:32.0592 (UTC) FILETIME=[4BACE700:01CCCA87]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While gpio is requested for pxa, gpio driver will request function ready
on pin.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/gpio/gpio-pxa.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-pxa.c b/drivers/gpio/gpio-pxa.c
index b2d3ee1..5e12c19 100644
--- a/drivers/gpio/gpio-pxa.c
+++ b/drivers/gpio/gpio-pxa.c
@@ -19,6 +19,7 @@
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
+#include <linux/pinctrl/pinmux.h>
 #include <linux/syscore_ops.h>
 #include <linux/slab.h>
 
@@ -267,6 +268,16 @@ static void pxa_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 				(value ? GPSR_OFFSET : GPCR_OFFSET));
 }
 
+static int pxa_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	return pinmux_request_gpio(chip->base + offset);
+}
+
+static void pxa_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	pinmux_free_gpio(chip->base + offset);
+}
+
 static int __devinit pxa_init_gpio_chip(int gpio_end)
 {
 	int i, gpio, nbanks = gpio_to_bank(gpio_end) + 1;
@@ -292,6 +303,8 @@ static int __devinit pxa_init_gpio_chip(int gpio_end)
 		c->get = pxa_gpio_get;
 		c->set = pxa_gpio_set;
 		c->to_irq = pxa_gpio_to_irq;
+		c->request = pxa_gpio_request;
+		c->free = pxa_gpio_free;
 
 		/* number of GPIOs on last bank may be less than 32 */
 		c->ngpio = (gpio + 31 > gpio_end) ? (gpio_end - gpio + 1) : 32;
-- 
1.7.0.4

