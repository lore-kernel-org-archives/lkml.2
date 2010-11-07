Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab0KGSaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 13:30:39 -0500
Received: from moh1-ve1.go2.pl ([193.17.41.131]:40914 "EHLO moh1-ve1.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab0KGSai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 13:30:38 -0500
Message-ID: <4CD6F049.10102@o2.pl>
Date: Sun, 07 Nov 2010 19:30:33 +0100
From: Maciej Szmigiero <mhej@o2.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101024 Lightning/1.0b3pre Thunderbird/3.1.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-arch@vger.kernel.org, Anton Vorontsov <avorontsov@ru.mvista.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "Uwe Kleine-K?nig" <u.kleine-koenig@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Jonathan Cameron <jic23@cam.ac.uk>,
        Ben Nizette <bn@niasdigital.com>
Subject: [GPIO]implement sleeping GPIO chip removal
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-O2-Trust: 2, 66
X-O2-SPF: neutral
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[GPIO]implement sleeping GPIO chip removal

Existing GPIO chip removal code is only of "non-blocking" type: if the chip is currently
requested it just returns -EBUSY.
This is bad for devices which disappear and reappear, like those on hot pluggable buses,
because it forces the driver to call gpiochip_remove() in loop until it returns 0.

This patch implements a new function which sleeps until device is free instead of
returning -EBUSY like gpiochip_remove().

Signed-off-by: Maciej Szmigiero <mhej@o2.pl>

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 21da9c1..a41f614 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -11,7 +11,7 @@
 #include <linux/of_gpio.h>
 #include <linux/idr.h>
 #include <linux/slab.h>
-
+#include <linux/sched.h>
 
 /* Optional implementation infrastructure for GPIO interfaces.
  *
@@ -95,6 +95,10 @@ static int gpio_ensure_requested(struct gpio_desc *desc, unsigned offset)
 	const struct gpio_chip *chip = desc->chip;
 	const int gpio = chip->base + offset;
 
+	/* no new requests if chip is being deregistered */
+	if ((chip->dead) && (test_bit(FLAG_REQUESTED, &desc->flags) == 0))
+		return -ENODEV;
+
 	if (WARN(test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0,
 			"autorequest GPIO-%d\n", gpio)) {
 		if (!try_module_get(chip->owner)) {
@@ -1041,6 +1045,11 @@ int gpiochip_add(struct gpio_chip *chip)
 		goto fail;
 	}
 
+	/* make sure is not registered as already dead */
+	chip->dead = 0;
+
+	chip->removing_task = NULL;
+
 	spin_lock_irqsave(&gpio_lock, flags);
 
 	if (base < 0) {
@@ -1134,6 +1143,75 @@ int gpiochip_remove(struct gpio_chip *chip)
 EXPORT_SYMBOL_GPL(gpiochip_remove);
 
 /**
+ * gpiochip_remove_sleeping() - unregister a gpio_chip sleeping when needed
+ * @chip: the chip to unregister
+ * @interruptible: should the sleep be interruptible?
+ *
+ * If any of GPIOs are still requested this function will wait for them
+ * to be freed.
+ */
+int gpiochip_remove_sleeping(struct gpio_chip *chip, int interruptible)
+{
+	unsigned	id;
+	unsigned long	flags;
+
+	/* prevent new requests */
+	chip->dead = 1;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+
+	while (1) {
+		int busy = 0;
+
+		for (id = chip->base; id < chip->base + chip->ngpio; id++) {
+			if (test_bit(FLAG_REQUESTED, &gpio_desc[id].flags)) {
+				/* printk("ID %u is still requested\n", id); */
+				busy = 1;
+				break;
+			}
+		}
+
+		if (!busy)
+			break;
+
+		set_current_state(interruptible ?
+				TASK_INTERRUPTIBLE : TASK_UNINTERRUPTIBLE);
+		chip->removing_task = current;
+
+		spin_unlock_irqrestore(&gpio_lock, flags);
+
+		schedule();
+
+		/* printk("GPIO remove woken up\n"); */
+
+		spin_lock_irqsave(&gpio_lock, flags);
+
+		if (interruptible && (signal_pending(current))) {
+			/* printk("GPIO remove signal pending\n"); */
+			/* mark chip alive again */
+			chip->dead = 0;
+			chip->removing_task = NULL;
+
+			spin_unlock_irqrestore(&gpio_lock, flags);
+
+			return -EINTR;
+		}
+	}
+
+	of_gpiochip_remove(chip);
+
+	for (id = chip->base; id < chip->base + chip->ngpio; id++)
+		gpio_desc[id].chip = NULL;
+
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	gpiochip_unexport(chip);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(gpiochip_remove_sleeping);
+
+/**
  * gpiochip_find() - iterator for locating a specific gpio_chip
  * @data: data to pass to match function
  * @callback: Callback function to check gpio_chip
@@ -1186,6 +1264,12 @@ int gpio_request(unsigned gpio, const char *label)
 	if (chip == NULL)
 		goto done;
 
+	/* chip is being deregistered, prohibit new requests */
+	if (chip->dead) {
+		status = -ENODEV;
+		goto done;
+	}
+
 	if (!try_module_get(chip->owner))
 		goto done;
 
@@ -1254,6 +1338,9 @@ void gpio_free(unsigned gpio)
 		module_put(desc->chip->owner);
 		clear_bit(FLAG_ACTIVE_LOW, &desc->flags);
 		clear_bit(FLAG_REQUESTED, &desc->flags);
+
+		if (chip->removing_task != NULL)
+			wake_up_process(chip->removing_task);
 	} else
 		WARN_ON(extra_checks);
 
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index ff5c660..8576732 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -119,6 +119,9 @@ struct gpio_chip {
 	const char		*const *names;
 	unsigned		can_sleep:1;
 	unsigned		exported:1;
+	unsigned		dead:1;
+
+	struct task_struct	*removing_task;
 
 #if defined(CONFIG_OF_GPIO)
 	/*
@@ -139,6 +142,7 @@ extern int __must_check gpiochip_reserve(int start, int ngpio);
 /* add/remove chips */
 extern int gpiochip_add(struct gpio_chip *chip);
 extern int __must_check gpiochip_remove(struct gpio_chip *chip);
+extern int gpiochip_remove_sleeping(struct gpio_chip *chip, int interruptible);
 extern struct gpio_chip *gpiochip_find(void *data,
 					int (*match)(struct gpio_chip *chip,
 						     void *data));


