Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab1LBUsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 15:48:21 -0500
Received: from border.exmeritus.com ([70.167.241.26]:52722 "EHLO
	border.exmeritus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab1LBUsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 15:48:19 -0500
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Dec 2011 15:48:19 EST
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: devicetree-discuss@lists.ozlabs.org
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/3] of_gpio: Extend of_gpio_count() to support other property names
Date: Fri,  2 Dec 2011 15:37:59 -0500
Message-Id: <1322858281-17831-2-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1322858281-17831-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1322858281-17831-1-git-send-email-Kyle.D.Moffett@boeing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_get_named_gpio_flags() function allows the caller to specify the
property name which should be read for a list of GPIOs.

Unfortunately there is no easy way to *count* the number of GPIOs listed
in an arbitrary property.

To resolve this, rename of_gpio_count() to of_gpio_count_named() and add
a new "propname" parameter.

Also add a static inline replacement for of_gpio_count() which calls
of_gpio_count_named() with "gpios" to avoid breaking existing users.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 drivers/of/gpio.c       |   13 ++++++-------
 include/linux/of_gpio.h |   27 +++++++++++++++++++++++++--
 2 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/of/gpio.c b/drivers/of/gpio.c
index ef0105f..f349aaf 100644
--- a/drivers/of/gpio.c
+++ b/drivers/of/gpio.c
@@ -83,8 +83,9 @@ err0:
 EXPORT_SYMBOL(of_get_named_gpio_flags);
 
 /**
- * of_gpio_count - Count GPIOs for a device
+ * of_gpio_count_named - Count GPIOs for a device
  * @np:		device node to count GPIOs for
+ * @propname:	property name containing gpio specifier(s)
  *
  * The function returns the count of GPIOs specified for a node.
  *
@@ -98,15 +99,13 @@ EXPORT_SYMBOL(of_get_named_gpio_flags);
  * defines four GPIOs (so this function will return 4), two of which
  * are not specified.
  */
-unsigned int of_gpio_count(struct device_node *np)
+unsigned int of_gpio_count_named(struct device_node *np, const char *propname)
 {
 	unsigned int cnt = 0;
 
 	do {
-		int ret;
-
-		ret = of_parse_phandles_with_args(np, "gpios", "#gpio-cells",
-						  cnt, NULL, NULL);
+		int ret = of_parse_phandles_with_args(np, propname,
+				"#gpio-cells", cnt, NULL, NULL);
 		/* A hole in the gpios = <> counts anyway. */
 		if (ret < 0 && ret != -EEXIST)
 			break;
@@ -114,7 +113,7 @@ unsigned int of_gpio_count(struct device_node *np)
 
 	return cnt;
 }
-EXPORT_SYMBOL(of_gpio_count);
+EXPORT_SYMBOL(of_gpio_count_named);
 
 /**
  * of_gpio_simple_xlate - translate gpio_spec to the GPIO number and flags
diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index 52280a2..1411a06 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -49,7 +49,8 @@ static inline struct of_mm_gpio_chip *to_of_mm_gpio_chip(struct gpio_chip *gc)
 extern int of_get_named_gpio_flags(struct device_node *np,
 		const char *list_name, int index, enum of_gpio_flags *flags);
 
-extern unsigned int of_gpio_count(struct device_node *np);
+extern unsigned int of_gpio_count_named(struct device_node *np,
+		const char *propname);
 
 extern int of_mm_gpiochip_add(struct device_node *np,
 			      struct of_mm_gpio_chip *mm_gc);
@@ -69,7 +70,8 @@ static inline int of_get_named_gpio_flags(struct device_node *np,
 	return -ENOSYS;
 }
 
-static inline unsigned int of_gpio_count(struct device_node *np)
+static inline unsigned int of_gpio_count_named(struct device_node *np,
+		const char *propname)
 {
 	return 0;
 }
@@ -87,6 +89,27 @@ static inline void of_gpiochip_remove(struct gpio_chip *gc) { }
 #endif /* CONFIG_OF_GPIO */
 
 /**
+ * of_gpio_count - Count GPIOs for a device
+ * @np:		device node to count GPIOs for
+ *
+ * The function returns the count of GPIOs specified for a node.
+ *
+ * Note that the empty GPIO specifiers counts too. For example,
+ *
+ * gpios = <0
+ *          &pio1 1 2
+ *          0
+ *          &pio2 3 4>;
+ *
+ * defines four GPIOs (so this function will return 4), two of which
+ * are not specified.
+ */
+static inline unsigned int of_gpio_count(struct device_node *np)
+{
+	return of_gpio_count_named(np, "gpios");
+}
+
+/**
  * of_get_gpio_flags() - Get a GPIO number and flags to use with GPIO API
  * @np:		device node to get GPIO from
  * @index:	index of the GPIO
-- 
1.7.2.5

