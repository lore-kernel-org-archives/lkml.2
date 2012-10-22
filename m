Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab2JVNmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:42:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:61889 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634Ab2JVNmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:42:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,629,1344236400"; 
   d="scan'208";a="238524318"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: linus.walleij@stericsson.com
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [RFC PATCH] gpiolib: add gpio get direction support
Date: Mon, 22 Oct 2012 16:44:14 +0300
Message-Id: <1350913454-26927-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add gpio_get_direction() for checking the current direction of a gpio.
Returns 1 for input, 0 for output, or negative error.
Gpio drivers need to set the gpio_chip .get_direction callback for this
functionality, otherwise gpio_get_direction() returns error.

If the .get_direction callback is set, then gpiolib will use it
for showing correct gpio direction in sysfs and debug. If not set
then it will work the old way; e.g. guessing everything is input
until direction is set.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/gpio/gpiolib.c     |   64 ++++++++++++++++++++++++++++++++++++++++++-
 include/asm-generic/gpio.h |    6 +++-
 include/linux/gpio.h       |    5 +++
 3 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index de0213c..28deb86 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -223,6 +223,7 @@ static ssize_t gpio_direction_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	const struct gpio_desc	*desc = dev_get_drvdata(dev);
+	unsigned		gpio = desc - gpio_desc;
 	ssize_t			status;
 
 	mutex_lock(&sysfs_lock);
@@ -230,6 +231,7 @@ static ssize_t gpio_direction_show(struct device *dev,
 	if (!test_bit(FLAG_EXPORT, &desc->flags))
 		status = -EIO;
 	else
+		gpio_get_direction(gpio);
 		status = sprintf(buf, "%s\n",
 			test_bit(FLAG_IS_OUT, &desc->flags)
 				? "out" : "in");
@@ -1073,6 +1075,7 @@ int gpiochip_add(struct gpio_chip *chip)
 			 * inputs (often with pullups enabled) so power
 			 * usage is minimized.  Linux code should set the
 			 * gpio direction first thing; but until it does,
+			 * and in case chip->get_direction is not set,
 			 * we may expose the wrong direction in sysfs.
 			 */
 			gpio_desc[id].flags = !chip->direction_input
@@ -1392,6 +1395,62 @@ EXPORT_SYMBOL_GPL(gpiochip_is_requested);
  * rely on gpio_request() having been called beforehand.
  */
 
+int gpio_get_direction(unsigned gpio)
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
+	if (!chip || !chip->get_direction)
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
+	might_sleep_if(chip->can_sleep);
+
+	if (status) {
+		status = chip->request(chip, gpio);
+		if (status < 0) {
+			pr_debug("GPIO-%d: chip request fail, %d\n",
+				chip->base + gpio, status);
+			/* and it's not available to anyone else ...
+			 * gpio_request() is the fully clean solution.
+			 */
+			return status;
+		}
+	}
+
+	status = chip->get_direction(chip, gpio);
+	if (status > 0) {
+		/* GPIOF_DIR_IN, or other positive */
+		status = 1;
+		clear_bit(FLAG_IS_OUT, &desc->flags);
+	}
+	if (status == 0) {
+		/* GPIOF_DIR_OUT */
+		set_bit(FLAG_IS_OUT, &desc->flags);
+	}
+	return status;
+fail:
+	spin_unlock_irqrestore(&gpio_lock, flags);
+	return status;
+}
+EXPORT_SYMBOL_GPL(gpio_get_direction);
+
 int gpio_direction_input(unsigned gpio)
 {
 	unsigned long		flags;
@@ -1761,8 +1820,9 @@ static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 	for (i = 0; i < chip->ngpio; i++, gpio++, gdesc++) {
 		if (!test_bit(FLAG_REQUESTED, &gdesc->flags))
 			continue;
-
-		is_out = test_bit(FLAG_IS_OUT, &gdesc->flags);
+		chip->get_direction
+			? (is_out = !chip->get_direction(chip, i))
+			: (is_out = test_bit(FLAG_IS_OUT, &gdesc->flags));
 		seq_printf(s, " gpio-%-3d (%-20.20s) %s %s",
 			gpio, gdesc->label,
 			is_out ? "out" : "in ",
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 365ea09..4e58743 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -56,6 +56,8 @@ struct device_node;
  *	enabling module power and clock; may sleep
  * @free: optional hook for chip-specific deactivation, such as
  *	disabling module power and clock; may sleep
+ * @get_direction: returns direction for signal "offset", 0=out, 1=in,
+ *	(same as GPIOF_DIR_XXX), or negative error
  * @direction_input: configures signal "offset" as input, or returns error
  * @get: returns value for signal "offset"; for output signals this
  *	returns either the value actually sensed, or zero
@@ -98,7 +100,8 @@ struct gpio_chip {
 						unsigned offset);
 	void			(*free)(struct gpio_chip *chip,
 						unsigned offset);
-
+	int			(*get_direction)(struct gpio_chip *chip,
+						unsigned offset);
 	int			(*direction_input)(struct gpio_chip *chip,
 						unsigned offset);
 	int			(*get)(struct gpio_chip *chip,
@@ -153,6 +156,7 @@ extern struct gpio_chip *gpiochip_find(void *data,
 extern int gpio_request(unsigned gpio, const char *label);
 extern void gpio_free(unsigned gpio);
 
+extern int gpio_get_direction(unsigned gpio);
 extern int gpio_direction_input(unsigned gpio);
 extern int gpio_direction_output(unsigned gpio, int value);
 
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 2e31e8b..9bfc008 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -141,6 +141,11 @@ static inline void gpio_free_array(const struct gpio *array, size_t num)
 	WARN_ON(1);
 }
 
+static inline int gpio_get_direction(unsigned gpio)
+{
+	return -ENOSYS;
+}
+
 static inline int gpio_direction_input(unsigned gpio)
 {
 	return -ENOSYS;
-- 
1.7.4.1

