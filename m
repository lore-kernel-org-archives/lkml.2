Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab2KFQVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 11:21:20 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:52539 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751208Ab2KFQVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 11:21:18 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] gpiolib: iron out include ladder mistakes
Date: Tue, 6 Nov 2012 17:21:03 +0100
Message-ID: <1352218863-2037-1-git-send-email-linus.walleij@stericsson.com>
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

And we need to keep the static inlines in <linux/gpio.h>
but here for the !CONFIG_GENERIC_GPIO case, and then we
may as well throw in a few warnings like the other
prototypes there, if someone would have the bad taste
of compiling without GENERIC_GPIO even.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 include/asm-generic/gpio.h | 13 +++++++++++++
 include/linux/gpio.h       |  7 +++----
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 50d995e..b546edb 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -67,6 +67,19 @@ int gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
 			   unsigned int pin_base, unsigned int npins);
 void gpiochip_remove_pin_ranges(struct gpio_chip *chip);
 
+#else
+
+static inline int
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
 #endif
 
 /**
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

