Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab1FTWvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:51:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41318 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055Ab1FTWvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:51:07 -0400
Subject: [PATCH] of/gpio: Add new method for getting gpios under different
	property names
To: glikely@secretlab.ca, linux-kernel@vger.kernel.org
From: John Bonesio <bones@secretlab.ca>
Date: Mon, 20 Jun 2011 15:51:03 -0700
Message-ID: <20110620225103.4559.67928.stgit@riker>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new routine, of_get_named_gpio_flags(), which takes the
property name as a parameter rather than assuming "gpios".

of_get_gpio_flags() is modified to call of_get_named_gpio_flags() with "gpios"
as the property parameter.

Signed-off-by: John Bonesio <bones@secretlab.ca>
---

 drivers/of/gpio.c       |   12 +++++++-----
 include/linux/of_gpio.h |   42 ++++++++++++++++++++++++++++++++++++++----
 2 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/drivers/of/gpio.c b/drivers/of/gpio.c
index 9059603..6e6a786 100644
--- a/drivers/of/gpio.c
+++ b/drivers/of/gpio.c
@@ -20,9 +20,11 @@
 #include <linux/of_gpio.h>
 #include <linux/slab.h>
 
+
 /**
- * of_get_gpio_flags - Get a GPIO number and flags to use with GPIO API
+ * of_get_named_gpio_flags - Get a GPIO number and flags to use with GPIO API
  * @np:		device node to get GPIO from
+ * @list_name:	property name that contains a list
  * @index:	index of the GPIO
  * @flags:	a flags pointer to fill in
  *
@@ -30,8 +32,8 @@
  * value on the error condition. If @flags is not NULL the function also fills
  * in flags for the GPIO.
  */
-int of_get_gpio_flags(struct device_node *np, int index,
-		      enum of_gpio_flags *flags)
+int of_get_named_gpio_flags(struct device_node *np, const char *list_name,
+                           int index, enum of_gpio_flags *flags)
 {
 	int ret;
 	struct device_node *gpio_np;
@@ -40,7 +42,7 @@ int of_get_gpio_flags(struct device_node *np, int index,
 	const void *gpio_spec;
 	const __be32 *gpio_cells;
 
-	ret = of_parse_phandles_with_args(np, "gpios", "#gpio-cells", index,
+	ret = of_parse_phandles_with_args(np, list_name, "#gpio-cells", index,
 					  &gpio_np, &gpio_spec);
 	if (ret) {
 		pr_debug("%s: can't parse gpios property\n", __func__);
@@ -79,7 +81,7 @@ err0:
 	pr_debug("%s exited with status %d\n", __func__, ret);
 	return ret;
 }
-EXPORT_SYMBOL(of_get_gpio_flags);
+EXPORT_SYMBOL(of_get_named_gpio_flags);
 
 /**
  * of_gpio_count - Count GPIOs for a device
diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index 6598c04..920f195 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -46,8 +46,9 @@ static inline struct of_mm_gpio_chip *to_of_mm_gpio_chip(struct gpio_chip *gc)
 	return container_of(gc, struct of_mm_gpio_chip, gc);
 }
 
-extern int of_get_gpio_flags(struct device_node *np, int index,
-			     enum of_gpio_flags *flags);
+extern int of_get_named_gpio_flags(struct device_node *np,
+		const char *list_name, int index, enum of_gpio_flags *flags);
+
 extern unsigned int of_gpio_count(struct device_node *np);
 
 extern int of_mm_gpiochip_add(struct device_node *np,
@@ -60,8 +61,8 @@ extern struct gpio_chip *of_node_to_gpiochip(struct device_node *np);
 #else /* CONFIG_OF_GPIO */
 
 /* Drivers may not strictly depend on the GPIO support, so let them link. */
-static inline int of_get_gpio_flags(struct device_node *np, int index,
-				    enum of_gpio_flags *flags)
+static inline int of_get_named_gpio_flags(struct device_node *np,
+		const char *list_name, int index, enum of_gpio_flags *flags)
 {
 	return -ENOSYS;
 }
@@ -77,6 +78,39 @@ static inline void of_gpiochip_remove(struct gpio_chip *gc) { }
 #endif /* CONFIG_OF_GPIO */
 
 /**
+ * of_get_gpio_flags - Get a GPIO number and flags to use with GPIO API
+ * @np:		device node to get GPIO from
+ * @index:	index of the GPIO
+ * @flags:	a flags pointer to fill in
+ *
+ * Returns GPIO number to use with Linux generic GPIO API, or one of the errno
+ * value on the error condition. If @flags is not NULL the function also fills
+ * in flags for the GPIO.
+ */
+static inline int of_get_gpio_flags(struct device_node *np, int index,
+		      enum of_gpio_flags *flags)
+{
+	return of_get_named_gpio_flags(np, "gpios", index, flags);
+}
+
+
+/**
+ * of_get_named_gpio - Get a GPIO number to use with GPIO API
+ * @np:		device node to get GPIO from
+ * @list_name:	property name that contains a list
+ * @index:	index of the GPIO
+ *
+ * Returns GPIO number to use with Linux generic GPIO API, or one of the errno
+ * value on the error condition.
+ */
+static inline int of_get_named_gpio(struct device_node *np,
+                                   const char *list_name, int index)
+{
+	return of_get_named_gpio_flags(np, list_name, index, NULL);
+}
+
+
+/**
  * of_get_gpio - Get a GPIO number to use with GPIO API
  * @np:		device node to get GPIO from
  * @index:	index of the GPIO

