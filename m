Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab1LVINp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 03:13:45 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:49511 "HELO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754501Ab1LVINm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 03:13:42 -0500
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: linus.walleij@linaro.org, swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, arnd@arndb.de
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: [PATCH v3 3/3] gpio: pxa: request pinmux function for gpio
Date: Thu, 22 Dec 2011 16:17:35 +0800
Message-Id: <1324541855-19911-4-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1324541855-19911-1-git-send-email-haojian.zhuang@marvell.com>
References: <1324541855-19911-1-git-send-email-haojian.zhuang@marvell.com>
X-OriginalArrivalTime: 22 Dec 2011 08:13:12.0501 (UTC) FILETIME=[8C5B4E50:01CCC081]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While gpio is requested for pxa, gpio driver will request function ready
on pin.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/gpio/gpio-pxa.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-pxa.c b/drivers/gpio/gpio-pxa.c
index b2d3ee1..4f33ba2 100644
--- a/drivers/gpio/gpio-pxa.c
+++ b/drivers/gpio/gpio-pxa.c
@@ -19,6 +19,7 @@
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
+#include <linux/pinctrl/pinmux.h>
 #include <linux/syscore_ops.h>
 #include <linux/slab.h>
 
@@ -267,6 +268,21 @@ static void pxa_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 				(value ? GPSR_OFFSET : GPCR_OFFSET));
 }
 
+#ifdef CONFIG_PINMUX
+static int pxa_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	return pinmux_request_gpio(chip->base + offset);
+}
+
+static void pxa_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	pinmux_free_gpio(chip->base + offset);
+}
+#else
+static int pxa_gpio_request(struct gpio_chip *chip, unsigned offset) {return 0;}
+static void pxa_gpio_free(struct gpio_chip *chip, unsigned offset) {}
+#endif
+
 static int __devinit pxa_init_gpio_chip(int gpio_end)
 {
 	int i, gpio, nbanks = gpio_to_bank(gpio_end) + 1;
@@ -292,6 +308,8 @@ static int __devinit pxa_init_gpio_chip(int gpio_end)
 		c->get = pxa_gpio_get;
 		c->set = pxa_gpio_set;
 		c->to_irq = pxa_gpio_to_irq;
+		c->request = pxa_gpio_request;
+		c->free = pxa_gpio_free;
 
 		/* number of GPIOs on last bank may be less than 32 */
 		c->ngpio = (gpio + 31 > gpio_end) ? (gpio_end - gpio + 1) : 32;
-- 
1.7.0.4

