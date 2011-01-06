Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1AFUOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:14:17 -0500
Received: from xes-mad.com ([216.165.139.218]:57952 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab1AFUOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:14:16 -0500
From: Peter Tyser <ptyser@xes-inc.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Tyser <ptyser@xes-inc.com>, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>
Subject: [PATCH 1/3] gpiolib: Add ability to get GPIO pin direction
Date: Thu,  6 Jan 2011 13:54:12 -0600
Message-Id: <1294343654-20354-1-git-send-email-ptyser@xes-inc.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new get_direction() function to the gpio_chip structure.  This is
useful so that the direction of a pin can be determined when its
exported.  Previously, the direction defaulted to 'in' regardless of the
actual configuration of the GPIO pin which resulted in the 'direction'
sysfs file often being incorrect.

If a GPIO driver implements get_direction(), it is called in
gpio_request() to set the initial direction of the pin accurately.

Cc: Alek Du <alek.du@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
---
 drivers/gpio/gpiolib.c     |   15 ++++++++-------
 include/asm-generic/gpio.h |    4 ++++
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 649550e..0a360d8 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1062,13 +1062,6 @@ int gpiochip_add(struct gpio_chip *chip)
 	if (status == 0) {
 		for (id = base; id < base + chip->ngpio; id++) {
 			gpio_desc[id].chip = chip;
-
-			/* REVISIT:  most hardware initializes GPIOs as
-			 * inputs (often with pullups enabled) so power
-			 * usage is minimized.  Linux code should set the
-			 * gpio direction first thing; but until it does,
-			 * we may expose the wrong direction in sysfs.
-			 */
 			gpio_desc[id].flags = !chip->direction_input
 				? (1 << FLAG_IS_OUT)
 				: 0;
@@ -1215,6 +1208,14 @@ int gpio_request(unsigned gpio, const char *label)
 		}
 	}
 
+	if (chip->get_direction) {
+		/* chip->get_direction may sleep */
+		spin_unlock_irqrestore(&gpio_lock, flags);
+		if (chip->get_direction(chip, gpio - chip->base) > 0)
+			set_bit(FLAG_IS_OUT, &desc->flags);
+		spin_lock_irqsave(&gpio_lock, flags);
+	}
+
 done:
 	if (status)
 		pr_debug("gpio_request: gpio-%d (%s) status %d\n",
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index ff5c660..7d55cf7 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -57,6 +57,8 @@ struct device_node;
  * @direction_input: configures signal "offset" as input, or returns error
  * @get: returns value for signal "offset"; for output signals this
  *	returns either the value actually sensed, or zero
+ * @get_direction: optional hook to determine if a GPIO signal is configured
+ *	as an input (0) or output (1).
  * @direction_output: configures signal "offset" as output, or returns error
  * @set: assigns output value for signal "offset"
  * @to_irq: optional hook supporting non-static gpio_to_irq() mappings;
@@ -101,6 +103,8 @@ struct gpio_chip {
 						unsigned offset);
 	int			(*get)(struct gpio_chip *chip,
 						unsigned offset);
+	int			(*get_direction)(struct gpio_chip *chip,
+						unsigned offset);
 	int			(*direction_output)(struct gpio_chip *chip,
 						unsigned offset, int value);
 	int			(*set_debounce)(struct gpio_chip *chip,
-- 
1.7.0.4

