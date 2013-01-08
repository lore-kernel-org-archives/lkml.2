Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab3AHHTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 02:19:36 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10815 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab3AHHTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 02:19:30 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 07 Jan 2013 23:14:55 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: Guenter Roeck <linux@roeck-us.net>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 3/4] gpiolib: of: convert OF helpers to descriptor API
Date: Tue, 8 Jan 2013 16:18:54 +0900
Message-ID: <1357629535-26033-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357629535-26033-1-git-send-email-acourbot@nvidia.com>
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert gpiolib-of.c's internals to rely on descriptors instead of
integers and add the gpiod_ counterparts of existing OF functions.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib-of.c     | 26 +++++++++------
 include/linux/gpio/consumer.h | 56 +++++++++++++++++++++++++++++++++
 include/linux/gpio/driver.h   | 38 ++++++++++++++++++++++
 include/linux/of_gpio.h       | 73 ++++++-------------------------------------
 4 files changed, 120 insertions(+), 73 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index d542a14..8c9f8c5 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -13,6 +13,7 @@
 
 #include <linux/device.h>
 #include <linux/errno.h>
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
@@ -22,12 +23,14 @@
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/slab.h>
 
+struct gpio_desc;
+
 /* Private data structure for of_gpiochip_find_and_xlate */
 struct gg_data {
 	enum of_gpio_flags *flags;
 	struct of_phandle_args gpiospec;
 
-	int out_gpio;
+	struct gpio_desc *out_gpio;
 };
 
 /* Private function for resolving node pointer to gpio_chip */
@@ -45,28 +48,31 @@ static int of_gpiochip_find_and_xlate(struct gpio_chip *gc, void *data)
 	if (ret < 0)
 		return false;
 
-	gg_data->out_gpio = ret + gc->base;
+	gg_data->out_gpio = gpio_to_desc(ret + gc->base);
 	return true;
 }
 
 /**
- * of_get_named_gpio_flags() - Get a GPIO number and flags to use with GPIO API
+ * of_get_named_gpiod_flags() - Get a GPIO descriptor and flags for GPIO API
  * @np:		device node to get GPIO from
  * @propname:	property name containing gpio specifier(s)
  * @index:	index of the GPIO
  * @flags:	a flags pointer to fill in
  *
- * Returns GPIO number to use with Linux generic GPIO API, or one of the errno
+ * Returns GPIO descriptor to use with Linux GPIO API, or one of the errno
  * value on the error condition. If @flags is not NULL the function also fills
  * in flags for the GPIO.
  */
-int of_get_named_gpio_flags(struct device_node *np, const char *propname,
-                           int index, enum of_gpio_flags *flags)
+struct gpio_desc *of_get_named_gpiod_flags(struct device_node *np,
+		const char *propname, int index, enum of_gpio_flags *flags)
 {
 	/* Return -EPROBE_DEFER to support probe() functions to be called
 	 * later when the GPIO actually becomes available
 	 */
-	struct gg_data gg_data = { .flags = flags, .out_gpio = -EPROBE_DEFER };
+	struct gg_data gg_data = {
+		.flags = flags,
+		.out_gpio = ERR_PTR(-EPROBE_DEFER),
+	};
 	int ret;
 
 	/* .of_xlate might decide to not fill in the flags, so clear it. */
@@ -77,13 +83,15 @@ int of_get_named_gpio_flags(struct device_node *np, const char *propname,
 					 &gg_data.gpiospec);
 	if (ret) {
 		pr_debug("%s: can't parse gpios property\n", __func__);
-		return ret;
+		return ERR_PTR(ret);
 	}
 
 	gpiochip_find(&gg_data, of_gpiochip_find_and_xlate);
 
 	of_node_put(gg_data.gpiospec.np);
-	pr_debug("%s exited with status %d\n", __func__, gg_data.out_gpio);
+
+	ret = PTR_RET(gg_data.out_gpio);
+	pr_debug("%s exited with status %d\n", __func__, ret);
 	return gg_data.out_gpio;
 }
 EXPORT_SYMBOL(of_get_named_gpio_flags);
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index 2f30761..b6a3bc8 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -3,6 +3,8 @@
 
 #ifdef CONFIG_GPIOLIB
 
+#include <linux/kernel.h>
+
 struct device;
 struct gpio_chip;
 
@@ -67,6 +69,60 @@ static inline void gpiod_unexport(struct gpio_desc *desc)
 
 #endif	/* CONFIG_GPIO_SYSFS */
 
+
+struct device_node;
+
+/*
+ * This is Linux-specific flags. By default controllers' and Linux' mapping
+ * match, but GPIO controllers are free to translate their own flags to
+ * Linux-specific in their .xlate callback. Though, 1:1 mapping is recommended.
+ */
+enum of_gpio_flags {
+	OF_GPIO_ACTIVE_LOW = 0x1,
+};
+
+#ifdef CONFIG_OF_GPIO
+
+extern unsigned int of_gpio_named_count(struct device_node *np,
+					const char *propname);
+
+extern struct gpio_desc *of_get_named_gpiod_flags(struct device_node *np,
+		const char *list_name, int index, enum of_gpio_flags *flags);
+
+#else
+
+/* Drivers may not strictly depend on the GPIO support, so let them link. */
+static inline unsigned int of_gpio_named_count(struct device_node *np,
+					       const char *propname)
+{
+	return 0;
+}
+
+static inline struct gpio_desc *of_get_named_gpiod_flags(struct device_node *np,
+		const char *list_name, int index, enum of_gpio_flags *flags)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+#endif /* CONFIG_OF_GPIO */
+
+static inline struct gpio_desc *of_get_gpiod_flags(struct device_node *np,
+					int index, enum of_gpio_flags *flags)
+{
+	return of_get_named_gpiod_flags(np, "gpios", index, flags);
+}
+
+static inline struct gpio_desc *of_get_named_gpiod(struct device_node *np,
+					const char *propname, int index)
+{
+	return of_get_named_gpiod_flags(np, propname, index, NULL);
+}
+
+static inline struct gpio_desc *of_get_gpiod(struct device_node *np, int index)
+{
+	return of_get_gpiod_flags(np, index, NULL);
+}
+
 #endif /* CONFIG_GPIOLIB */
 
 #endif
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index d43d671..84447a5 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -128,6 +128,44 @@ struct gpiod_lookup {
 
 void gpiod_add_table(struct gpiod_lookup *table, size_t size);
 
+#ifdef CONFIG_OF_GPIO
+
+/*
+ * OF GPIO chip for memory mapped banks
+ */
+struct of_mm_gpio_chip {
+	struct gpio_chip gc;
+	void (*save_regs)(struct of_mm_gpio_chip *mm_gc);
+	void __iomem *regs;
+};
+
+static inline struct of_mm_gpio_chip *to_of_mm_gpio_chip(struct gpio_chip *gc)
+{
+	return container_of(gc, struct of_mm_gpio_chip, gc);
+}
+
+extern int of_mm_gpiochip_add(struct device_node *np,
+			      struct of_mm_gpio_chip *mm_gc);
+extern void of_gpiochip_add(struct gpio_chip *gc);
+extern void of_gpiochip_remove(struct gpio_chip *gc);
+extern int of_gpio_simple_xlate(struct gpio_chip *gc,
+				const struct of_phandle_args *gpiospec,
+				u32 *flags);
+
+#else
+
+static inline int of_gpio_simple_xlate(struct gpio_chip *gc,
+				       const struct of_phandle_args *gpiospec,
+				       u32 *flags)
+{
+	return -ENOSYS;
+}
+
+static inline void of_gpiochip_add(struct gpio_chip *gc) { }
+static inline void of_gpiochip_remove(struct gpio_chip *gc) { }
+
+#endif /* CONFIG_OF_GPIO */
+
 #endif /* CONFIG_GPIOLIB */
 
 #endif
diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index c454f57..f703707 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -17,78 +17,23 @@
 #include <linux/compiler.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
+#include <linux/err.h>
 #include <linux/gpio.h>
 #include <linux/of.h>
+#include <linux/gpio/consumer.h>
+#include <linux/gpio/driver.h>
 
-struct device_node;
-
-/*
- * This is Linux-specific flags. By default controllers' and Linux' mapping
- * match, but GPIO controllers are free to translate their own flags to
- * Linux-specific in their .xlate callback. Though, 1:1 mapping is recommended.
- */
-enum of_gpio_flags {
-	OF_GPIO_ACTIVE_LOW = 0x1,
-};
-
-#ifdef CONFIG_OF_GPIO
-
-/*
- * OF GPIO chip for memory mapped banks
- */
-struct of_mm_gpio_chip {
-	struct gpio_chip gc;
-	void (*save_regs)(struct of_mm_gpio_chip *mm_gc);
-	void __iomem *regs;
-};
-
-static inline struct of_mm_gpio_chip *to_of_mm_gpio_chip(struct gpio_chip *gc)
-{
-	return container_of(gc, struct of_mm_gpio_chip, gc);
-}
-
-extern int of_get_named_gpio_flags(struct device_node *np,
-		const char *list_name, int index, enum of_gpio_flags *flags);
-
-extern unsigned int of_gpio_named_count(struct device_node *np,
-					const char* propname);
-
-extern int of_mm_gpiochip_add(struct device_node *np,
-			      struct of_mm_gpio_chip *mm_gc);
-
-extern void of_gpiochip_add(struct gpio_chip *gc);
-extern void of_gpiochip_remove(struct gpio_chip *gc);
-extern int of_gpio_simple_xlate(struct gpio_chip *gc,
-				const struct of_phandle_args *gpiospec,
-				u32 *flags);
-
-#else /* CONFIG_OF_GPIO */
-
-/* Drivers may not strictly depend on the GPIO support, so let them link. */
 static inline int of_get_named_gpio_flags(struct device_node *np,
 		const char *list_name, int index, enum of_gpio_flags *flags)
 {
-	return -ENOSYS;
-}
-
-static inline unsigned int of_gpio_named_count(struct device_node *np,
-					const char* propname)
-{
-	return 0;
-}
-
-static inline int of_gpio_simple_xlate(struct gpio_chip *gc,
-				       const struct of_phandle_args *gpiospec,
-				       u32 *flags)
-{
-	return -ENOSYS;
+	struct gpio_desc *desc;
+	desc = of_get_named_gpiod_flags(np, list_name, index, flags);
+	if (IS_ERR(desc))
+		return PTR_ERR(desc);
+	else
+		return desc_to_gpio(desc);
 }
 
-static inline void of_gpiochip_add(struct gpio_chip *gc) { }
-static inline void of_gpiochip_remove(struct gpio_chip *gc) { }
-
-#endif /* CONFIG_OF_GPIO */
-
 /**
  * of_gpio_count - Count GPIOs for a device
  * @np:		device node to count GPIOs for
-- 
1.8.1

