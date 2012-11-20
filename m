Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab2KTLqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 06:46:24 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:33988 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753100Ab2KTLqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 06:46:23 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] gpiolib: let gpiochip_add_pin_range() specify offset
Date: Tue, 20 Nov 2012 12:45:53 +0100
Message-ID: <1353411953-27423-1-git-send-email-linus.walleij@stericsson.com>
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
 drivers/gpio/gpiolib.c     | 18 ++++++++++++++++--
 include/asm-generic/gpio.h |  6 ++++--
 include/linux/gpio.h       |  3 ++-
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index c5f6500..0b08d27 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1187,8 +1187,18 @@ EXPORT_SYMBOL_GPL(gpiochip_find);
 
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
 
@@ -1200,7 +1210,7 @@ int gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
 	}
 
 	pin_range->range.name = chip->label;
-	pin_range->range.base = chip->base;
+	pin_range->range.base = chip->base + offset;
 	pin_range->range.pin_base = pin_base;
 	pin_range->range.npins = npins;
 	pin_range->pctldev = find_pinctrl_and_add_gpio_range(pinctl_name,
@@ -1212,6 +1222,10 @@ int gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
 }
 EXPORT_SYMBOL_GPL(gpiochip_add_pin_range);
 
+/**
+ * gpiochip_remove_pin_ranges() - remove all the GPIO <-> pin mappings
+ * @chip: the chip to remove all the mappings for
+ */
 void gpiochip_remove_pin_ranges(struct gpio_chip *chip)
 {
 	struct gpio_pin_range *pin_range, *tmp;
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

