Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab2KHN5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:57:45 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:43454 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755680Ab2KHN5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:57:43 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v2] gpiolib: iron out include ladder mistakes
Date: Thu, 8 Nov 2012 14:57:19 +0100
Message-ID: <1352383039-12269-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The <*/gpio.h> includes are updated again: now we need to account
for the problem introduced by commit:
595679a8038584df7b9398bf34f61db3c038bfea
"gpiolib: fix up function prototypes etc"

Actually we need static inlines in include/asm-generic/gpio.h
as well since we may have GPIOLIB but not PINCTRL.
Make sure to move all the CONFIG_PINCTRL business
to the end of the file so we are sure we have
declared struct gpio_chip.

And we need to keep the static inlines in <linux/gpio.h>
but here for the !CONFIG_GENERIC_GPIO case, and then we
may as well throw in a few warnings like the other
prototypes there, if someone would have the bad taste
of compiling without GENERIC_GPIO even.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Move function prototypes below all other #ifdefs at the
  bottom of the file so we know we have struct irq_chip
  defines
- Provide a proper return value from the
  gpiochip_add_pin_range() stub
- Thanks to Stephen Rothwell for pointing this out.
---
 include/asm-generic/gpio.h | 56 +++++++++++++++++++++++++++++-----------------
 include/linux/gpio.h       |  7 +++---
 2 files changed, 38 insertions(+), 25 deletions(-)

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 50d995e..2b84fc3 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -48,27 +48,6 @@ struct seq_file;
 struct module;
 struct device_node;
 
-#ifdef CONFIG_PINCTRL
-
-/**
- * struct gpio_pin_range - pin range controlled by a gpio chip
- * @head: list for maintaining set of pin ranges, used internally
- * @pctldev: pinctrl device which handles corresponding pins
- * @range: actual range of pins controlled by a gpio controller
- */
-
-struct gpio_pin_range {
-	struct list_head node;
-	struct pinctrl_dev *pctldev;
-	struct pinctrl_gpio_range range;
-};
-
-int gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
-			   unsigned int pin_base, unsigned int npins);
-void gpiochip_remove_pin_ranges(struct gpio_chip *chip);
-
-#endif
-
 /**
  * struct gpio_chip - abstract a GPIO controller
  * @label: for diagnostics
@@ -288,4 +267,39 @@ static inline void gpio_unexport(unsigned gpio)
 }
 #endif	/* CONFIG_GPIO_SYSFS */
 
+#ifdef CONFIG_PINCTRL
+
+/**
+ * struct gpio_pin_range - pin range controlled by a gpio chip
+ * @head: list for maintaining set of pin ranges, used internally
+ * @pctldev: pinctrl device which handles corresponding pins
+ * @range: actual range of pins controlled by a gpio controller
+ */
+
+struct gpio_pin_range {
+	struct list_head node;
+	struct pinctrl_dev *pctldev;
+	struct pinctrl_gpio_range range;
+};
+
+int gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
+			   unsigned int pin_base, unsigned int npins);
+void gpiochip_remove_pin_ranges(struct gpio_chip *chip);
+
+#else
+
+static inline int
+gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
+		       unsigned int pin_base, unsigned int npins)
+{
+	return 0;
+}
+
+static inline void
+gpiochip_remove_pin_ranges(struct gpio_chip *chip)
+{
+}
+
+#endif /* CONFIG_PINCTRL */
+
 #endif /* _ASM_GENERIC_GPIO_H */
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 81bbfe5..7ba2762 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -231,21 +231,20 @@ static inline int irq_to_gpio(unsigned irq)
 	return -EINVAL;
 }
 
-#ifdef CONFIG_PINCTRL
-
 static inline int
 gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
 		       unsigned int pin_base, unsigned int npins)
 {
+	WARN_ON(1);
+	return -EINVAL;
 }
 
 static inline void
 gpiochip_remove_pin_ranges(struct gpio_chip *chip)
 {
+	WARN_ON(1);
 }
 
-#endif /* CONFIG_PINCTRL */
-
 #endif /* ! CONFIG_GENERIC_GPIO */
 
 #endif /* __LINUX_GPIO_H */
-- 
1.7.11.3

