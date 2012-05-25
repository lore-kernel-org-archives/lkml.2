Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012Ab2EYNgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:36:09 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:8380
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754541Ab2EYNdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:33:52 -0400
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839hd24he5bhf0ah)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>, <devicetree-discuss@lists.ozlabs.org>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <b29396@freescale.com>
Subject: [PATCH v4 4/6] gpio: introduce lock mechanism for gpiochip_find
Date: Fri, 25 May 2012 21:36:18 +0800
Message-ID: <1337952980-14621-4-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337952980-14621-1-git-send-email-b29396@freescale.com>
References: <1337952980-14621-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

The module lock will be automatically claimed for gpiochip_find function
in case the gpio module is removed during the using of gpiochip instance.
Users are responsible to call gpiochip_put to release the lock after
the using.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 drivers/gpio/gpiolib-of.c  |    5 ++++-
 drivers/gpio/gpiolib.c     |   17 +++++++++++++++++
 include/asm-generic/gpio.h |    2 +-
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index b8010a9..d521452 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -63,6 +63,7 @@ int of_get_named_gpio_flags(struct device_node *np, const char *propname,
                            int index, enum of_gpio_flags *flags)
 {
 	struct gg_data gg_data = { .flags = flags, .out_gpio = -ENODEV };
+	struct gpio_chip *chip;
 	int ret;
 
 	/* .of_xlate might decide to not fill in the flags, so clear it. */
@@ -76,7 +77,9 @@ int of_get_named_gpio_flags(struct device_node *np, const char *propname,
 		return -EINVAL;
 	}
 
-	gpiochip_find(&gg_data, of_gpiochip_find_and_xlate);
+	chip = gpiochip_find(&gg_data, of_gpiochip_find_and_xlate);
+	if (chip)
+		gpiochip_put(chip);
 
 	of_node_put(gg_data.gpiospec.np);
 	pr_debug("%s exited with status %d\n", __func__, ret);
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 120b2a0..6453d43 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1144,6 +1144,18 @@ int gpiochip_remove(struct gpio_chip *chip)
 EXPORT_SYMBOL_GPL(gpiochip_remove);
 
 /**
+ * gpiochip_put() - release a gpio_chip
+ * @chip: the chip to release
+ */
+inline void gpiochip_put(struct gpio_chip *chip)
+{
+	BUG_ON(!chip);
+
+	module_put(chip->owner);
+}
+EXPORT_SYMBOL_GPL(gpiochip_put);
+
+/**
  * gpiochip_find() - iterator for locating a specific gpio_chip
  * @data: data to pass to match function
  * @callback: Callback function to check gpio_chip
@@ -1153,6 +1165,9 @@ EXPORT_SYMBOL_GPL(gpiochip_remove);
  * 0 if the device doesn't match and non-zero if it does.  If the callback is
  * non-zero, this function will return to the caller and not iterate over any
  * more gpio_chips.
+ *
+ * Note the gpio_chip is returned with the module locked, users are responsible
+ * to release the lock with gpiochip_put(chip) after using it.
  */
 struct gpio_chip *gpiochip_find(void *data,
 				int (*match)(struct gpio_chip *chip,
@@ -1169,6 +1184,8 @@ struct gpio_chip *gpiochip_find(void *data,
 
 		if (match(gpio_desc[i].chip, data)) {
 			chip = gpio_desc[i].chip;
+			if (!try_module_get(chip->owner))
+				chip = NULL;
 			break;
 		}
 	}
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 365ea09..af372be 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -145,7 +145,7 @@ extern int __must_check gpiochip_remove(struct gpio_chip *chip);
 extern struct gpio_chip *gpiochip_find(void *data,
 					int (*match)(struct gpio_chip *chip,
 						     void *data));
-
+extern void gpiochip_put(struct gpio_chip *chip);
 
 /* Always use the library code for GPIO management calls,
  * or when sleeping may be involved.
-- 
1.7.0.4


