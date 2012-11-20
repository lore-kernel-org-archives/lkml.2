Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab2KTOEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:04:54 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:55034 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752508Ab2KTOEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:04:52 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/7 v2] gpiolib: let gpiochip_add_pin_range() specify offset
Date: Tue, 20 Nov 2012 15:04:09 +0100
Message-ID: <1353420249-17957-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Like with commit 3c739ad0df5eb41cd7adad879eda6aa09879eb76
it is not always enough to specify all the pins of a gpio_chip
from offset zero to be added to a pin map range, since the
mapping from GPIO to pin controller may not be linear at all,
but need to be broken into a few consecutive sub-ranges or
1-pin entries for complicated cases. The ranges may also be
sparse.

This alters the signature of the function to accept offsets
into both the GPIO-chip local pinspace and the pin controller
local pinspace.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpiolib.c     | 32 +++++++++++++++++++++++++++++---
 include/asm-generic/gpio.h |  6 ++++--
 include/linux/gpio.h       |  3 ++-
 3 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index c5f6500..6d13bea 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1187,24 +1187,45 @@ EXPORT_SYMBOL_GPL(gpiochip_find);
 
 #ifdef CONFIG_PINCTRL
 
+/**
+ * gpiochip_add_pin_range() - add a range for GPIO <-> pin mapping
+ * @chip: the gpiochip to add the range for
+ * @pinctrl_name: the dev_name() of the pin controller to map to
+ * @offset: the start offset in the current gpio_chip number space
+ * @pin_base: the start offset in the pin controller number space
+ * @npins: the number of pins from the offset of each pin space (GPIO and
+ *	pin controller) to accumulate in this range
+ */
 int gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
-			   unsigned int pin_base, unsigned int npins)
+			   unsigned int offset, unsigned int pin_base,
+			   unsigned int npins)
 {
 	struct gpio_pin_range *pin_range;
 
-	pin_range = devm_kzalloc(chip->dev, sizeof(*pin_range), GFP_KERNEL);
+	pin_range = kzalloc(sizeof(*pin_range), GFP_KERNEL);
 	if (!pin_range) {
 		pr_err("%s: GPIO chip: failed to allocate pin ranges\n",
 				chip->label);
 		return -ENOMEM;
 	}
 
+	/* Use local offset as range ID */
+	pin_range->range.id = offset;
+	pin_range->range.gc = chip;
 	pin_range->range.name = chip->label;
-	pin_range->range.base = chip->base;
+	pin_range->range.base = chip->base + offset;
 	pin_range->range.pin_base = pin_base;
 	pin_range->range.npins = npins;
 	pin_range->pctldev = find_pinctrl_and_add_gpio_range(pinctl_name,
 			&pin_range->range);
+	if (!pin_range->pctldev) {
+		pr_err("%s: GPIO chip: could not create pin range\n",
+		       chip->label);
+		kfree(pin_range);
+	}
+	pr_debug("%s: GPIO chip: created GPIO range %d->%d ==> PIN %d->%d\n",
+		 chip->label, offset, offset + npins - 1,
+		 pin_base, pin_base + npins - 1);
 
 	list_add_tail(&pin_range->node, &chip->pin_ranges);
 
@@ -1212,6 +1233,10 @@ int gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
 }
 EXPORT_SYMBOL_GPL(gpiochip_add_pin_range);
 
+/**
+ * gpiochip_remove_pin_ranges() - remove all the GPIO <-> pin mappings
+ * @chip: the chip to remove all the mappings for
+ */
 void gpiochip_remove_pin_ranges(struct gpio_chip *chip)
 {
 	struct gpio_pin_range *pin_range, *tmp;
@@ -1220,6 +1245,7 @@ void gpiochip_remove_pin_ranges(struct gpio_chip *chip)
 		list_del(&pin_range->node);
 		pinctrl_remove_gpio_range(pin_range->pctldev,
 				&pin_range->range);
+		kfree(pin_range);
 	}
 }
 EXPORT_SYMBOL_GPL(gpiochip_remove_pin_ranges);
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 2b84fc3..ec58fdb 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -283,14 +283,16 @@ struct gpio_pin_range {
 };
 
 int gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
-			   unsigned int pin_base, unsigned int npins);
+			   unsigned int offset, unsigned int pin_base,
+			   unsigned int npins);
 void gpiochip_remove_pin_ranges(struct gpio_chip *chip);
 
 #else
 
 static inline int
 gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
-		       unsigned int pin_base, unsigned int npins)
+		       unsigned int offset, unsigned int pin_base,
+		       unsigned int npins)
 {
 	return 0;
 }
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 7ba2762..99861c6 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -233,7 +233,8 @@ static inline int irq_to_gpio(unsigned irq)
 
 static inline int
 gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
-		       unsigned int pin_base, unsigned int npins)
+		       unsigned int offset, unsigned int pin_base,
+		       unsigned int npins)
 {
 	WARN_ON(1);
 	return -EINVAL;
-- 
1.7.11.3

