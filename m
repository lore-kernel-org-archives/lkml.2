Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab1BQA6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 19:58:10 -0500
Received: from xes-mad.com ([216.165.139.218]:52418 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877Ab1BQA6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 19:58:07 -0500
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
Subject: [PATCH v2 1/4] gpiolib: Add "unknown" direction support
Date: Wed, 16 Feb 2011 18:56:53 -0600
Message-Id: <1297904216-15219-1-git-send-email-ptyser@xes-inc.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, gpiolib would unconditionally flag all GPIO pins as inputs,
regardless of their true state.  This resulted in all GPIO output pins
initially being incorrectly identified as "input" in the GPIO sysfs.

Since the direction of GPIOs is not known prior to having their
direction set, instead set the default direction to "unknown" to prevent
user confusion.  A pin with an "unknown" direction can not be written or
read via sysfs; it must first be configured as an input or output before
it can be used.

While we're playing with the direction flag in/out defines, rename them to
a more descriptive FLAG_DIR_* format.

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
Change since V1:
- This patch is new and is based on feedback from Alan to support a new
  "unknown" direction.
- Rename FLAG_IS_OUT to FLAG_DIR_OUT, and add FLAG_DIR_IN

 drivers/gpio/gpiolib.c |   82 +++++++++++++++++++++++++++--------------------
 1 files changed, 47 insertions(+), 35 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 649550e..0113c10 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -49,13 +49,14 @@ struct gpio_desc {
 	unsigned long		flags;
 /* flag symbols are bit numbers */
 #define FLAG_REQUESTED	0
-#define FLAG_IS_OUT	1
-#define FLAG_RESERVED	2
-#define FLAG_EXPORT	3	/* protected by sysfs_lock */
-#define FLAG_SYSFS	4	/* exported via /sys/class/gpio/control */
-#define FLAG_TRIG_FALL	5	/* trigger on falling edge */
-#define FLAG_TRIG_RISE	6	/* trigger on rising edge */
-#define FLAG_ACTIVE_LOW	7	/* sysfs value has active low */
+#define FLAG_DIR_OUT	1	/* pin is an output */
+#define FLAG_DIR_IN	2	/* pin is an input */
+#define FLAG_RESERVED	3
+#define FLAG_EXPORT	4	/* protected by sysfs_lock */
+#define FLAG_SYSFS	5	/* exported via /sys/class/gpio/control */
+#define FLAG_TRIG_FALL	6	/* trigger on falling edge */
+#define FLAG_TRIG_RISE	7	/* trigger on rising edge */
+#define FLAG_ACTIVE_LOW	8	/* sysfs value has active low */
 
 #define ID_SHIFT	16	/* add new flags before this one */
 
@@ -220,15 +221,22 @@ static ssize_t gpio_direction_show(struct device *dev,
 {
 	const struct gpio_desc	*desc = dev_get_drvdata(dev);
 	ssize_t			status;
+	const char		*dir_str;
 
 	mutex_lock(&sysfs_lock);
 
-	if (!test_bit(FLAG_EXPORT, &desc->flags))
+	if (!test_bit(FLAG_EXPORT, &desc->flags)) {
 		status = -EIO;
-	else
-		status = sprintf(buf, "%s\n",
-			test_bit(FLAG_IS_OUT, &desc->flags)
-				? "out" : "in");
+	} else {
+		if (test_bit(FLAG_DIR_OUT, &desc->flags))
+			dir_str = "out";
+		else if (test_bit(FLAG_DIR_IN, &desc->flags))
+			dir_str = "in";
+		else
+			dir_str = "unknown";
+
+		status = sprintf(buf, "%s\n", dir_str);
+	}
 
 	mutex_unlock(&sysfs_lock);
 	return status;
@@ -272,6 +280,9 @@ static ssize_t gpio_value_show(struct device *dev,
 
 	if (!test_bit(FLAG_EXPORT, &desc->flags)) {
 		status = -EIO;
+	} else if ((!test_bit(FLAG_DIR_OUT, &desc->flags)) &&
+			(!test_bit(FLAG_DIR_IN, &desc->flags))) {
+		status = -EPERM;
 	} else {
 		int value;
 
@@ -297,7 +308,7 @@ static ssize_t gpio_value_store(struct device *dev,
 
 	if (!test_bit(FLAG_EXPORT, &desc->flags))
 		status = -EIO;
-	else if (!test_bit(FLAG_IS_OUT, &desc->flags))
+	else if (!test_bit(FLAG_DIR_OUT, &desc->flags))
 		status = -EPERM;
 	else {
 		long		value;
@@ -741,7 +752,7 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 
 			if (!status && gpio_to_irq(gpio) >= 0
 					&& (direction_may_change
-						|| !test_bit(FLAG_IS_OUT,
+						|| test_bit(FLAG_DIR_IN,
 							&desc->flags)))
 				status = device_create_file(dev,
 						&dev_attr_edge);
@@ -1059,22 +1070,10 @@ int gpiochip_add(struct gpio_chip *chip)
 			break;
 		}
 	}
-	if (status == 0) {
-		for (id = base; id < base + chip->ngpio; id++) {
+	if (status == 0)
+		for (id = base; id < base + chip->ngpio; id++)
 			gpio_desc[id].chip = chip;
 
-			/* REVISIT:  most hardware initializes GPIOs as
-			 * inputs (often with pullups enabled) so power
-			 * usage is minimized.  Linux code should set the
-			 * gpio direction first thing; but until it does,
-			 * we may expose the wrong direction in sysfs.
-			 */
-			gpio_desc[id].flags = !chip->direction_input
-				? (1 << FLAG_IS_OUT)
-				: 0;
-		}
-	}
-
 	of_gpiochip_add(chip);
 
 unlock:
@@ -1402,8 +1401,10 @@ int gpio_direction_input(unsigned gpio)
 	}
 
 	status = chip->direction_input(chip, gpio);
-	if (status == 0)
-		clear_bit(FLAG_IS_OUT, &desc->flags);
+	if (status == 0) {
+		clear_bit(FLAG_DIR_OUT, &desc->flags);
+		set_bit(FLAG_DIR_IN, &desc->flags);
+	}
 lose:
 	return status;
 fail:
@@ -1455,8 +1456,10 @@ int gpio_direction_output(unsigned gpio, int value)
 	}
 
 	status = chip->direction_output(chip, gpio, value);
-	if (status == 0)
-		set_bit(FLAG_IS_OUT, &desc->flags);
+	if (status == 0) {
+		clear_bit(FLAG_DIR_IN, &desc->flags);
+		set_bit(FLAG_DIR_OUT, &desc->flags);
+	}
 lose:
 	return status;
 fail:
@@ -1643,21 +1646,27 @@ static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 	unsigned		i;
 	unsigned		gpio = chip->base;
 	struct gpio_desc	*gdesc = &gpio_desc[gpio];
-	int			is_out;
+	const char		*dir_str;
+	int			unknown = 0;
 
 	for (i = 0; i < chip->ngpio; i++, gpio++, gdesc++) {
 		if (!test_bit(FLAG_REQUESTED, &gdesc->flags))
 			continue;
 
-		is_out = test_bit(FLAG_IS_OUT, &gdesc->flags);
-		seq_printf(s, " gpio-%-3d (%-20.20s) %s %s",
-			gpio, gdesc->label,
-			is_out ? "out" : "in ",
-			chip->get
-				? (chip->get(chip, i) ? "hi" : "lo")
-				: "?  ");
+		if (test_bit(FLAG_DIR_IN, &gdesc->flags)) {
+			dir_str = "in ";
+		} else if (test_bit(FLAG_DIR_OUT, &gdesc->flags)) {
+			dir_str = "out";
+		} else {
+			dir_str = "?  ";
+			unknown = 1;
+		}
+
+		seq_printf(s, " gpio-%-3d (%-20.20s) %s %s", gpio, gdesc->label,
+			dir_str, (chip->get && !unknown) ?
+			(chip->get(chip, i) ? "hi" : "lo") : "?");
 
-		if (!is_out) {
+		if (test_bit(FLAG_DIR_IN, &gdesc->flags)) {
 			int		irq = gpio_to_irq(gpio);
 			struct irq_desc	*desc = irq_to_desc(irq);
 
-- 
1.7.0.4

