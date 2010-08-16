Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0HPPOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 11:14:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52418 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab0HPPOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 11:14:52 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [RFC] gpio/stmpe: add bitmask to block requests to unavailable GPIOs
Date: Mon, 16 Aug 2010 17:14:44 +0200
Message-Id: <1281971684-16505-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.1
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIOs on these controller are multi-functional. If you decided to use
some of them e.g. as input channels for the ADC, you surely don't want
those pins to be reassigned as simple GPIOs (which may be triggered even
from userspace via 'export'). Same for the touchscreen controller pins.
Since knowledge about the hardware is needed to decide which GPIOs to
reserve, let this bitmask be inside platform_data and provide some
defines to assist potential users.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---

Tested on a custom board. I'm not sure if this is the best solution. Now, using
'export' might fail without the GPIO in question appearing in debugfs. That
might be confusing. Still, it should be a lot safer than being able to change
the pins via userspace.

 drivers/gpio/stmpe-gpio.c |    5 +++++
 include/linux/mfd/stmpe.h |    6 ++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/stmpe-gpio.c b/drivers/gpio/stmpe-gpio.c
index 4e1f1b9..65b9960 100644
--- a/drivers/gpio/stmpe-gpio.c
+++ b/drivers/gpio/stmpe-gpio.c
@@ -30,6 +30,7 @@ struct stmpe_gpio {
 	struct mutex irq_lock;
 
 	int irq_base;
+	unsigned norequest_mask;
 
 	/* Caches of interrupt control registers for bus_lock */
 	u8 regs[CACHE_NR_REGS][CACHE_NR_BANKS];
@@ -103,6 +104,9 @@ static int stmpe_gpio_request(struct gpio_chip *chip, unsigned offset)
 	struct stmpe_gpio *stmpe_gpio = to_stmpe_gpio(chip);
 	struct stmpe *stmpe = stmpe_gpio->stmpe;
 
+	if (stmpe_gpio->norequest_mask & (1 << offset))
+		return -EINVAL;
+
 	return stmpe_set_altfunc(stmpe, 1 << offset, STMPE_BLOCK_GPIO);
 }
 
@@ -302,6 +306,7 @@ static int __devinit stmpe_gpio_probe(struct platform_device *pdev)
 
 	stmpe_gpio->dev = &pdev->dev;
 	stmpe_gpio->stmpe = stmpe;
+	stmpe_gpio->norequest_mask = pdata ? pdata->norequest_mask : 0;
 
 	stmpe_gpio->chip = template_chip;
 	stmpe_gpio->chip.ngpio = stmpe->num_gpios;
diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
index 90faa98..845abaa 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -112,13 +112,19 @@ struct stmpe_keypad_platform_data {
 	bool no_autorepeat;
 };
 
+#define STMPE_GPIO_NOREQ_811_TOUCH	(0xf0)
+
 /**
  * struct stmpe_gpio_platform_data - STMPE GPIO platform data
  * @gpio_base: first gpio number assigned.  A maximum of
  *	       %STMPE_NR_GPIOS GPIOs will be allocated.
+ * @norequest_mask: bitmask specifying which GPIOs should _not_ be
+ *		    requestable due to different usage (e.g. touch, keypad)
+ *		    STMPE_GPIO_NOREQ_* macros can be used here.
  */
 struct stmpe_gpio_platform_data {
 	int gpio_base;
+	unsigned norequest_mask;
 	void (*setup)(struct stmpe *stmpe, unsigned gpio_base);
 	void (*remove)(struct stmpe *stmpe, unsigned gpio_base);
 };
-- 
1.7.1

