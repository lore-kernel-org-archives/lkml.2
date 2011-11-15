Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1KOJmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 04:42:09 -0500
Received: from mail-am1.bigfish.com ([213.199.180.138]:1309 "EHLO
	AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754403Ab1KOJmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 04:42:07 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Dong Aisheng <dong.aisheng@linaro.org>
To: <linux-kernel@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <arnd@arndb.de>
Subject: [PATCH 1/1] gpio: introduce gpio_export_array to ease export for gpio arrays
Date: Tue, 15 Nov 2011 17:54:01 +0800
Message-ID: <1321350841-8549-1-git-send-email-dong.aisheng@linaro.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce gpio_export_array function to ease the export operation
for gpio arrays.
This can cooperate with the exist gpio_request_array function.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Arnd Bergmann <arnd@arndb.de>

---
We already have gpio_request_array, i'm wondering if we can have
a gpio_export_array to cooperate to ease the export operation
for gpio arrays.
---
 drivers/gpio/gpiolib.c     |   35 +++++++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h |   14 ++++++++++++++
 include/linux/gpio.h       |   15 +++++++++++++++
 3 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index a971e3d..e9f2374 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -816,6 +816,29 @@ done:
 }
 EXPORT_SYMBOL_GPL(gpio_export_link);
 
+/**
+ * gpio_export_array - export multiple GPIOs in a single call
+ * @array:	array of the 'struct gpio'
+ * @num:	how many GPIOs in the array
+ */
+int gpio_export_array(const struct gpio *array, size_t num,
+			bool direction_may_change)
+{
+	int i, err;
+
+	for (i = 0; i < num; i++, array++) {
+		err = gpio_export(array->gpio, direction_may_change);
+		if (err)
+			goto err_export;
+	}
+	return 0;
+
+err_export:
+	while (i--)
+		gpio_unexport((--array)->gpio);
+	return err;
+}
+EXPORT_SYMBOL_GPL(gpio_export_array);
 
 /**
  * gpio_sysfs_set_active_low - set the polarity of gpio sysfs value
@@ -903,6 +926,18 @@ done:
 }
 EXPORT_SYMBOL_GPL(gpio_unexport);
 
+/**
+ * gpio_unexport_array - unexport multiple GPIOs in a single call
+ * @array:	array of the 'struct gpio'
+ * @num:	how many GPIOs in the array
+ */
+void gpio_unexport_array(const struct gpio *array, size_t num)
+{
+	while (num--)
+		gpio_unexport((array++)->gpio);
+}
+EXPORT_SYMBOL_GPL(gpio_unexport_array);
+
 static int gpiochip_export(struct gpio_chip *chip)
 {
 	int		status;
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 8c86210..ed0ce4d 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -182,10 +182,13 @@ extern void gpio_free_array(const struct gpio *array, size_t num);
  * but more typically is configured entirely from userspace.
  */
 extern int gpio_export(unsigned gpio, bool direction_may_change);
+extern int gpio_export_array(const struct gpio *array, size_t num,
+			bool direction_may_change);
 extern int gpio_export_link(struct device *dev, const char *name,
 			unsigned gpio);
 extern int gpio_sysfs_set_active_low(unsigned gpio, int value);
 extern void gpio_unexport(unsigned gpio);
+extern void gpio_unexport_array(const struct gpio *array, size_t num);
 
 #endif	/* CONFIG_GPIO_SYSFS */
 
@@ -237,6 +240,12 @@ static inline int gpio_export_link(struct device *dev, const char *name,
 	return -ENOSYS;
 }
 
+static inline int gpio_export_array(const struct gpio *array, size_t num,
+			bool direction_may_change)
+{
+	return -ENOSYS;
+}
+
 static inline int gpio_sysfs_set_active_low(unsigned gpio, int value)
 {
 	return -ENOSYS;
@@ -245,6 +254,11 @@ static inline int gpio_sysfs_set_active_low(unsigned gpio, int value)
 static inline void gpio_unexport(unsigned gpio)
 {
 }
+
+static inline void gpio_unexport_array(const struct gpio *array,
+			size_t num)
+{
+}
 #endif	/* CONFIG_GPIO_SYSFS */
 
 #endif /* _ASM_GENERIC_GPIO_H */
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 38ac48b..9b5aae5 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -138,6 +138,14 @@ static inline int gpio_export_link(struct device *dev, const char *name,
 	return -EINVAL;
 }
 
+static inline int gpio_export_array(const struct gpio *array, size_t num,
+			bool direction_may_change)
+{
+	/* GPIO can never have been requested or set as {in,out}put */
+	WARN_ON(1);
+	return -EINVAL;
+}
+
 static inline int gpio_sysfs_set_active_low(unsigned gpio, int value)
 {
 	/* GPIO can never have been requested */
@@ -151,6 +159,13 @@ static inline void gpio_unexport(unsigned gpio)
 	WARN_ON(1);
 }
 
+static inline void gpio_unexport_array(const struct gpio *array,
+			size_t num)
+{
+	/* GPIO array can never have been exported */
+	WARN_ON(1);
+}
+
 static inline int gpio_to_irq(unsigned gpio)
 {
 	/* GPIO can never have been requested or set as input */
-- 
1.7.0.4


