Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab2KFPQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 10:16:50 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:46822 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751168Ab2KFPQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 10:16:49 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/5] gpiolib: fix up function prototypes etc
Date: Tue, 6 Nov 2012 16:16:34 +0100
Message-ID: <1352214994-30232-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Commit 69e1601bca88809dc118abd1becb02c15a02ec71
"gpiolib: provide provision to register pin ranges"

Got most of it's function prototypes wrong, so fix this up by:

- Moving the void declarations into static inlines in
  <linux/gpio.h> (previously the actual prototypes were declared
  here...)

- Declare the gpiochip_add_pin_range() and
  gpiochip_remove_pin_ranges() functions in <asm-generic/gpio.h>
  together with the pin range struct declaration itself.

- Actually only implement these very functions in gpiolib.c
  if CONFIG_PINCTRL is set.

- Additionally export the symbols since modules will need to
  be able to do this.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpiolib.c     | 10 +++++-----
 include/asm-generic/gpio.h |  6 ++++++
 include/linux/gpio.h       | 24 ++++++++++++++++++------
 3 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 3e84796..10fc9c3 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1183,6 +1183,7 @@ struct gpio_chip *gpiochip_find(void *data,
 EXPORT_SYMBOL_GPL(gpiochip_find);
 
 #ifdef CONFIG_PINCTRL
+
 void gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
 		unsigned int pin_base, unsigned int npins)
 {
@@ -1204,6 +1205,7 @@ void gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
 
 	list_add_tail(&pin_range->node, &chip->pin_ranges);
 }
+EXPORT_SYMBOL_GPL(gpiochip_add_pin_range);
 
 void gpiochip_remove_pin_ranges(struct gpio_chip *chip)
 {
@@ -1215,11 +1217,9 @@ void gpiochip_remove_pin_ranges(struct gpio_chip *chip)
 				&pin_range->range);
 	}
 }
-#else
-void gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
-		unsigned int pin_base, unsigned int npins) {}
-void gpiochip_remove_pin_ranges(struct gpio_chip *chip) {}
-#endif
+EXPORT_SYMBOL_GPL(gpiochip_remove_pin_ranges);
+
+#endif /* CONFIG_PINCTRL */
 
 /* These "optional" allocation calls help prevent drivers from stomping
  * on each other, and help provide better diagnostics in debugfs.
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 92e5c43..2e60de4 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -49,6 +49,7 @@ struct module;
 struct device_node;
 
 #ifdef CONFIG_PINCTRL
+
 /**
  * struct gpio_pin_range - pin range controlled by a gpio chip
  * @head: list for maintaining set of pin ranges, used internally
@@ -61,6 +62,11 @@ struct gpio_pin_range {
 	struct pinctrl_dev *pctldev;
 	struct pinctrl_gpio_range range;
 };
+
+void gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
+			    unsigned int pin_base, unsigned int npins);
+void gpiochip_remove_pin_ranges(struct gpio_chip *chip);
+
 #endif
 
 /**
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index a284459..21d28b9 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -72,9 +72,9 @@ static inline int irq_to_gpio(unsigned int irq)
 	return -EINVAL;
 }
 
-#endif
+#endif /* ! CONFIG_ARCH_HAVE_CUSTOM_GPIO_H */
 
-#else
+#else /* ! CONFIG_GENERIC_GPIO */
 
 #include <linux/kernel.h>
 #include <linux/types.h>
@@ -231,9 +231,21 @@ static inline int irq_to_gpio(unsigned irq)
 	return -EINVAL;
 }
 
-void gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
-		unsigned int pin_base, unsigned int npins);
-void gpiochip_remove_pin_ranges(struct gpio_chip *chip);
-#endif
+#ifdef CONFIG_PINCTRL
+
+static inline void
+gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
+		       unsigned int pin_base, unsigned int npins)
+{
+}
+
+static inline void
+gpiochip_remove_pin_ranges(struct gpio_chip *chip)
+{
+}
+
+#endif /* CONFIG_PINCTRL */
+
+#endif /* ! CONFIG_GENERIC_GPIO */
 
 #endif /* __LINUX_GPIO_H */
-- 
1.7.11.3

