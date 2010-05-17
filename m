Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab0EQKFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 06:05:09 -0400
Received: from smtp.nokia.com ([192.100.105.134]:48758 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab0EQKFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 06:05:07 -0400
From: felipe.balbi@nokia.com
To: Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [PATCH 1/5] gpiolib: introduce set_debounce method
Date: Mon, 17 May 2010 13:02:30 +0300
Message-Id: <1274090554-19420-2-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1274090554-19420-1-git-send-email-felipe.balbi@nokia.com>
References: <1274090554-19420-1-git-send-email-felipe.balbi@nokia.com>
X-OriginalArrivalTime: 17 May 2010 10:04:31.0443 (UTC) FILETIME=[5812FA30:01CAF5A8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <felipe.balbi@nokia.com>

Few architectures, like OMAP, allow you to set
a debouncing time for the gpio before generating
the IRQ. Teach gpiolib about that.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 drivers/gpio/gpiolib.c     |   43 +++++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h |    5 +++++
 include/linux/gpio.h       |    5 +++++
 3 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index eb0c3fe..cd85fd1 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1447,6 +1447,49 @@ fail:
 }
 EXPORT_SYMBOL_GPL(gpio_direction_output);
 
+/**
+ * gpio_set_debounce - sets @debounce time for a @gpio
+ * @gpio: the gpio to set debounce time
+ * @debounce: debounce time is microseconds
+ */
+int gpio_set_debounce(unsigned gpio, unsigned debounce)
+{
+	unsigned long		flags;
+	struct gpio_chip	*chip;
+	struct gpio_desc	*desc = &gpio_desc[gpio];
+	int			status = -EINVAL;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+
+	if (!gpio_is_valid(gpio))
+		goto fail;
+	chip = desc->chip;
+	if (!chip || !chip->set || !chip->set_debounce)
+		goto fail;
+	gpio -= chip->base;
+	if (gpio >= chip->ngpio)
+		goto fail;
+	status = gpio_ensure_requested(desc, gpio);
+	if (status < 0)
+		goto fail;
+
+	/* now we know the gpio is valid and chip won't vanish */
+
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	might_sleep_if(extra_checks && chip->can_sleep);
+
+	return chip->set_debounce(chip, gpio, debounce);
+
+fail:
+	spin_unlock_irqrestore(&gpio_lock, flags);
+	if (status)
+		pr_debug("%s: gpio-%d status %d\n",
+			__func__, gpio, status);
+
+	return status;
+}
+EXPORT_SYMBOL_GPL(gpio_set_debounce);
 
 /* I/O calls are only valid after configuration completed; the relevant
  * "is this a valid GPIO" error checks should already have been done.
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 979c6a5..ce3eb87 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -88,6 +88,9 @@ struct gpio_chip {
 						unsigned offset);
 	int			(*direction_output)(struct gpio_chip *chip,
 						unsigned offset, int value);
+	int			(*set_debounce)(struct gpio_chip *chip,
+						unsigned offset, unsigned debounce);
+
 	void			(*set)(struct gpio_chip *chip,
 						unsigned offset, int value);
 
@@ -121,6 +124,8 @@ extern void gpio_free(unsigned gpio);
 extern int gpio_direction_input(unsigned gpio);
 extern int gpio_direction_output(unsigned gpio, int value);
 
+extern int gpio_set_debounce(unsigned gpio, unsigned debounce);
+
 extern int gpio_get_value_cansleep(unsigned gpio);
 extern void gpio_set_value_cansleep(unsigned gpio, int value);
 
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 4e949a5..03f616b 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -51,6 +51,11 @@ static inline int gpio_direction_output(unsigned gpio, int value)
 	return -ENOSYS;
 }
 
+static inline int gpio_set_debounce(unsigned gpio, unsigned debounce)
+{
+	return -ENOSYS;
+}
+
 static inline int gpio_get_value(unsigned gpio)
 {
 	/* GPIO can never have been requested or set as {in,out}put */
-- 
1.7.1

