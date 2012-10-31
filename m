Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab2JaHAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:00:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:39912 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab2JaHAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:00:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,685,1344236400"; 
   d="scan'208";a="213353586"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH 1/2] gpio: move those interface depends on GPIOLIB into proper section
Date: Wed, 31 Oct 2012 15:00:54 +0800
Message-Id: <1351666855-23854-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 2 issues with current code:

1. redefinition of 'gpio_cansleep':
include/linux/gpio.h:60:19: error: redefinition of 'gpio_cansleep'
include/asm-generic/gpio.h:212:19: note: previous definition of 'gpio_cansleep' was here

The root cause is include/linux/gpio.h has a defintion of it. And if
CONFIG_GPIOLIB is not set, include/asm-generic/gpio.h has another
definition.

2. include/linux/gpio.h:62:2: error: implicit declaration of function '__gpio_cansleep'

Only happens when CONFIG_GPIOLIB is not set, too. Since it called
gpiolib functions without putting something like: #ifdef CONFIG_GPIOLIB

So, move those functions into proper section at
include/asm-generic/gpio.h would resolve 2 above issues.

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 include/asm-generic/gpio.h |   39 +++++++++++++++++++++++++++++++++++++++
 include/linux/gpio.h       |   22 +---------------------
 2 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index a9432fc..a73272d 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -199,14 +199,53 @@ extern void gpio_unexport(unsigned gpio);
 
 #endif	/* CONFIG_GPIO_SYSFS */
 
+static inline int gpio_get_value(unsigned int gpio)
+{
+	return __gpio_get_value(gpio);
+}
+
+static inline void gpio_set_value(unsigned int gpio, int value)
+{
+	__gpio_set_value(gpio, value);
+}
+
+static inline int gpio_cansleep(unsigned int gpio)
+{
+	return __gpio_cansleep(gpio);
+}
+
+static inline int gpio_to_irq(unsigned int gpio)
+{
+	return __gpio_to_irq(gpio);
+}
+
+
 #else	/* !CONFIG_GPIOLIB */
 
+static inline int gpio_get_value(unsigned int gpio)
+{
+	WARN_ON(1);
+	return 0;
+}
+
+static inline void gpio_set_value(unsigned int gpio, int value)
+{
+	WARN_ON(1);
+}
+
 static inline bool gpio_is_valid(int number)
 {
 	/* only non-negative numbers are valid */
 	return number >= 0;
 }
 
+static inline int gpio_to_irq(unsigned int gpio)
+{
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+
 /* platforms that don't directly support access to GPIOs through I2C, SPI,
  * or other blocking infrastructure can use these wrappers.
  */
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 2e31e8b..eb6e6ac 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -47,26 +47,6 @@ struct gpio {
 
 #include <asm-generic/gpio.h>
 
-static inline int gpio_get_value(unsigned int gpio)
-{
-	return __gpio_get_value(gpio);
-}
-
-static inline void gpio_set_value(unsigned int gpio, int value)
-{
-	__gpio_set_value(gpio, value);
-}
-
-static inline int gpio_cansleep(unsigned int gpio)
-{
-	return __gpio_cansleep(gpio);
-}
-
-static inline int gpio_to_irq(unsigned int gpio)
-{
-	return __gpio_to_irq(gpio);
-}
-
 static inline int irq_to_gpio(unsigned int irq)
 {
 	return -EINVAL;
@@ -74,7 +54,7 @@ static inline int irq_to_gpio(unsigned int irq)
 
 #endif
 
-#else
+#else /* !CONFIG_GENERIC_GPIO */
 
 #include <linux/kernel.h>
 #include <linux/types.h>
-- 
1.7.7.6

