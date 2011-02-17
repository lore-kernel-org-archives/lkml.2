Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab1BQA56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 19:57:58 -0500
Received: from xes-mad.com ([216.165.139.218]:36480 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008Ab1BQA5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 19:57:54 -0500
From: Peter Tyser <ptyser@xes-inc.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Tyser <ptyser@xes-inc.com>, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v2 2/4] gpiolib: Add ability to get GPIO pin direction
Date: Wed, 16 Feb 2011 18:56:54 -0600
Message-Id: <1297904216-15219-2-git-send-email-ptyser@xes-inc.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1297904216-15219-1-git-send-email-ptyser@xes-inc.com>
References: <1297904216-15219-1-git-send-email-ptyser@xes-inc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new get_direction() function to the gpio_chip structure.  This is
useful so that the direction of a pin can be determined when its
initially exported.  Previously, the direction defaulted to "unknown"
regardless of the actual configuration of the GPIO pin.

If a GPIO driver implements get_direction(), it is called in
gpio_request() to set the initial direction of the pin accurately.

Cc: Alek Du <alek.du@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Joe Perches <joe@perches.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
---
Changes since v1:
- Add support for "unknown" direction

 drivers/gpio/gpiolib.c     |   20 ++++++++++++++++++++
 include/asm-generic/gpio.h |    4 ++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 0113c10..7723beb 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1214,6 +1214,26 @@ int gpio_request(unsigned gpio, const char *label)
 		}
 	}
 
+	if (chip->get_direction) {
+		/* chip->get_direction may sleep */
+		spin_unlock_irqrestore(&gpio_lock, flags);
+		switch (chip->get_direction(chip, gpio - chip->base)) {
+		case -1:
+			clear_bit(FLAG_DIR_OUT, &desc->flags);
+			clear_bit(FLAG_DIR_IN, &desc->flags);
+			break;
+		case 0:
+			set_bit(FLAG_DIR_IN, &desc->flags);
+			clear_bit(FLAG_DIR_OUT, &desc->flags);
+			break;
+		case 1:
+			set_bit(FLAG_DIR_OUT, &desc->flags);
+			clear_bit(FLAG_DIR_IN, &desc->flags);
+			break;
+		}
+		spin_lock_irqsave(&gpio_lock, flags);
+	}
+
 done:
 	if (status)
 		pr_debug("gpio_request: gpio-%d (%s) status %d\n",
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index ff5c660..6af5a3e 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -57,6 +57,8 @@ struct device_node;
  * @direction_input: configures signal "offset" as input, or returns error
  * @get: returns value for signal "offset"; for output signals this
  *	returns either the value actually sensed, or zero
+ * @get_direction: optional hook to determine if a GPIO signal is configured
+ *	as an input (0) or output (1), or unknown (-1)
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

