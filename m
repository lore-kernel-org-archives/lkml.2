Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab1LBUsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 15:48:22 -0500
Received: from border.exmeritus.com ([70.167.241.26]:52724 "EHLO
	border.exmeritus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab1LBUsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 15:48:19 -0500
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: devicetree-discuss@lists.ozlabs.org
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/3] of_gpio: Add new helpers for easily requesting lots of GPIOs
Date: Fri,  2 Dec 2011 15:38:00 -0500
Message-Id: <1322858281-17831-3-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1322858281-17831-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1322858281-17831-1-git-send-email-Kyle.D.Moffett@boeing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mirroring the new gpio_request_array() interface, we add several a few
helper functions for operating on entire arrays of GPIOs.

Also, to make it easier to write various combinations of "of_get_gpio()"
followed by "gpio_request()", add several other new inline wrappers.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 drivers/of/gpio.c       |   96 +++++++++++++++++++++++++++++
 include/linux/of_gpio.h |  154 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 250 insertions(+), 0 deletions(-)

diff --git a/drivers/of/gpio.c b/drivers/of/gpio.c
index f349aaf..4c04f2f 100644
--- a/drivers/of/gpio.c
+++ b/drivers/of/gpio.c
@@ -83,6 +83,47 @@ err0:
 EXPORT_SYMBOL(of_get_named_gpio_flags);
 
 /**
+ * of_get_gpio_array_flags() - Get array of gpios to use with GPIO API
+ * @np:		device node to get GPIOs from
+ * @of_gpios:	array of "struct of_gpio" to select which GPIOs to look up
+ * @of_flags:	array of "enum of_gpio_flags" to be filled in (may be NULL)
+ * @gpios:	array of "struct gpio" to be filled in
+ * @num:	the number of GPIOs to look up
+ *
+ * Takes a constant array of "struct of_gpio" and looks up each item in the
+ * indicated device-node.  The results are stored into the @gpios array,
+ * along with the optional GPIO "label" and "flags" values from the "of_gpio"
+ * structure.
+ *
+ * If an array of @of_flags is provided then any flags from the translate
+ * function will be stored into the corresponding element there.
+ */
+int of_get_gpio_array_flags(struct device_node *np,
+		const struct of_gpio *of_gpios, enum of_gpio_flags *of_flags,
+		struct gpio *gpios, size_t num)
+{
+	int err = 0;
+
+	size_t i;
+	for (i = 0; i < num; i++) {
+		/* Copy over the GPIO values */
+		gpios[i].flags = of_gpios[i].gpio_flags;
+		gpios[i].label = of_gpios[i].gpio_label;
+
+		/* Now dig the rest out of the device-tree */
+		gpios[i].gpio = of_get_named_gpio_flags(np,
+				of_gpios[i].propname, of_gpios[i].index,
+				(of_flags ? &of_flags[num] : NULL));
+
+		if (gpios[i].gpio < 0)
+			err = err ?: gpios[i].gpio;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL(of_get_gpio_array_flags);
+
+/**
  * of_gpio_count_named - Count GPIOs for a device
  * @np:		device node to count GPIOs for
  * @propname:	property name containing gpio specifier(s)
@@ -116,6 +157,61 @@ unsigned int of_gpio_count_named(struct device_node *np, const char *propname)
 EXPORT_SYMBOL(of_gpio_count_named);
 
 /**
+ * of_gpio_request_named_flags() - Request a GPIO using the device-tree
+ * @np:		device node to get GPIO from
+ * @propname:	property name containing gpio specifier(s)
+ * @index:	index of the GPIO
+ * @flags:	a flags pointer to fill in
+ * @gpio_flags:	The setup flags to pass into the GPIO API
+ * @gpio_label:	The label to pass into the GPIO API
+ *
+ * This is a simple wrapper around gpio_request_one() that looks up the GPIO
+ * from the device-tree first using of_get_named_gpio_flags().
+ */
+int of_gpio_request_named_flags(struct device_node *np,
+		const char *propname, int index, enum of_gpio_flags *of_flags,
+		unsigned long gpio_flags, const char *gpio_label)
+{
+	int err;
+
+	/* Retrieve the GPIO information from the device-tree */
+	int gpio = of_get_named_gpio_flags(np, propname, index, of_flags);
+	if (gpio < 0)
+		return gpio;
+
+	/* Request the GPIO */
+	err = gpio_request_one(gpio, gpio_flags, gpio_label);
+	return err ? err : gpio;
+}
+EXPORT_SYMBOL(of_gpio_request_named_flags);
+
+/**
+ * of_gpio_request_array_flags() - Request GPIOs using the device-tree
+ * @np:		device node to get GPIO from
+ * @of_gpios:	array of "struct of_gpio" to select which GPIOs to request
+ * @of_flags:	array of "enum of_gpio_flags" to be filled in (may be NULL)
+ * @gpios:	array of "struct gpio" to be filled in
+ * @num:	the number of GPIOs to request
+ *
+ * This is a simple wrapper around gpio_request_array() that looks up the
+ * GPIOs from the device-tree first using of_get_gpio_array_flags().
+ */
+int of_gpio_request_array_flags(struct device_node *np,
+		const struct of_gpio *of_gpios, enum of_gpio_flags *of_flags,
+		struct gpio *gpios, size_t num)
+{
+	/* Retrieve the GPIO information from the device-tree */
+	int err = of_get_gpio_array_flags(np, of_gpios,
+			of_flags, gpios, num);
+	if (err)
+		return err;
+
+	/* Request all of the GPIOs */
+	return gpio_request_array(gpios, num);
+}
+EXPORT_SYMBOL(of_gpio_request_array_flags);
+
+/**
  * of_gpio_simple_xlate - translate gpio_spec to the GPIO number and flags
  * @gc:		pointer to the gpio_chip structure
  * @np:		device node of the GPIO chip
diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index 1411a06..babce09 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -30,6 +30,20 @@ enum of_gpio_flags {
 	OF_GPIO_ACTIVE_LOW = 0x1,
 };
 
+/*
+ * This struct is passed to of_named_gpio_request_array() to initialize the
+ * passed-in array of "struct gpio" for use by gpio_request_array().
+ */
+struct of_gpio {
+	/* These values are used to locate the GPIO in the device-tree */
+	const char *propname;
+	int index;
+
+	/* These values are used to request the discovered GPIO */
+	unsigned long gpio_flags;
+	const char *gpio_label;
+};
+
 #ifdef CONFIG_OF_GPIO
 
 /*
@@ -49,9 +63,21 @@ static inline struct of_mm_gpio_chip *to_of_mm_gpio_chip(struct gpio_chip *gc)
 extern int of_get_named_gpio_flags(struct device_node *np,
 		const char *list_name, int index, enum of_gpio_flags *flags);
 
+extern int of_get_gpio_array_flags(struct device_node *np,
+		const struct of_gpio *of_gpios, enum of_gpio_flags *of_flags,
+		struct gpio *gpios, size_t num);
+
 extern unsigned int of_gpio_count_named(struct device_node *np,
 		const char *propname);
 
+extern int of_gpio_request_named_flags(struct device_node *np,
+		const char *propname, int index, enum of_gpio_flags *of_flags,
+		unsigned long gpio_flags, const char *gpio_label);
+
+extern int of_gpio_request_array_flags(struct device_node *np,
+		const struct of_gpio *of_gpios, enum of_gpio_flags *of_flags,
+		struct gpio *gpios, size_t num);
+
 extern int of_mm_gpiochip_add(struct device_node *np,
 			      struct of_mm_gpio_chip *mm_gc);
 
@@ -70,12 +96,51 @@ static inline int of_get_named_gpio_flags(struct device_node *np,
 	return -ENOSYS;
 }
 
+static inline int of_get_gpio_array_flags(struct device_node *np,
+		const struct of_gpio *of_gpios, enum of_gpio_flags *of_flags,
+		struct gpio *gpios, size_t num)
+{
+	/*
+	 * This function must always initialize all the "struct gpio"s even
+	 * if they cannot be probed to allow the user to detect the source of
+	 * each error.
+	 */
+	size_t i;
+	for (i = 0; i < num; i++) {
+		gpios[i].gpio = -ENOSYS;
+		gpios[i].label = of_gpios[i].label;
+		gpios[i].flags = of_gpios[i].flags;
+	}
+	return -ENOSYS;
+}
+
 static inline unsigned int of_gpio_count_named(struct device_node *np,
 		const char *propname)
 {
 	return 0;
 }
 
+static inline int of_gpio_request_named_flags(struct device_node *np,
+		const char *propname, int index, enum of_gpio_flags *of_flags,
+		unsigned long gpio_flags, const char *gpio_label)
+{
+	return -ENOSYS;
+}
+
+static inline int of_gpio_request_array_flags(struct device_node *np,
+		const struct of_gpio *of_gpios, enum of_gpio_flags *of_flags,
+		struct gpio *gpios, size_t num)
+{
+	/* Same initialization as of_get_gpio_array_flags() above */
+	size_t i;
+	for (i = 0; i < num; i++) {
+		gpios[i].gpio = -ENOSYS;
+		gpios[i].label = of_gpios[i].label;
+		gpios[i].flags = of_gpios[i].flags;
+	}
+	return -ENOSYS;
+}
+
 static inline int of_gpio_simple_xlate(struct gpio_chip *gc,
 				       struct device_node *np,
 				       const void *gpio_spec, u32 *flags)
@@ -153,4 +218,93 @@ static inline int of_get_gpio(struct device_node *np, int index)
 	return of_get_gpio_flags(np, index, NULL);
 }
 
+/**
+ * of_gpio_request_one_flags() - Request a GPIO using the device-tree
+ * @np:		device node to get GPIO from
+ * @index:	index of the GPIO
+ * @flags:	a flags pointer to fill in
+ * @gpio_flags:	The setup flags to pass into the GPIO API
+ * @gpio_label:	The label to pass into the GPIO API
+ *
+ * This is a simple wrapper around gpio_request_one() that looks up the GPIO
+ * from the device-tree first using of_get_gpio_flags().
+ */
+static inline int of_gpio_request_one_flags(struct device_node *np,
+		int index, enum of_gpio_flags *of_flags,
+		unsigned long gpio_flags, const char *gpio_label)
+{
+	return of_gpio_request_named_flags(np, "gpios", index,
+			of_flags, gpio_flags, gpio_label);
+}
+
+/**
+ * of_gpio_request_named() - Request a GPIO using the device-tree
+ * @np:		device node to get GPIO from
+ * @propname:	Name of property containing gpio specifier(s)
+ * @index:	index of the GPIO
+ * @gpio_flags:	The setup flags to pass into the GPIO API
+ * @gpio_label:	The label to pass into the GPIO API
+ *
+ * This is a simple wrapper around gpio_request_one() that looks up the GPIO
+ * from the device-tree first using of_get_named_gpio().
+ */
+static inline int of_gpio_request_named(struct device_node *np,
+		const char *propname, int index,
+		unsigned long gpio_flags, const char *gpio_label)
+{
+	return of_gpio_request_named_flags(np, propname, index,
+			NULL, gpio_flags, gpio_label);
+}
+
+/**
+ * of_gpio_request_one() - Request a GPIO using the device-tree
+ * @np:		device node to get GPIO from
+ * @index:	index of the GPIO
+ * @gpio_flags:	The setup flags to pass into the GPIO API
+ * @gpio_label:	The label to pass into the GPIO API
+ *
+ * This is a simple wrapper around gpio_request_one() that looks up the GPIO
+ * from the device-tree first using of_get_gpio().
+ */
+static inline int of_gpio_request_one(struct device_node *np,
+		int index, unsigned long gpio_flags, const char *gpio_label)
+{
+	return of_gpio_request_one_flags(np, index, NULL,
+			gpio_flags, gpio_label);
+}
+
+/**
+ * of_get_gpio_array() - Get an array of GPIO numbers to use with GPIO API
+ * @np:		device node to get GPIO from
+ * @of_gpios:	array of "struct of_gpio" to select which GPIOs to look up
+ * @gpios:	array of "struct gpio" to be filled in
+ * @num:	the number of GPIOs to look up
+ *
+ * Takes a constant array of "struct of_gpio" and looks up each item in the
+ * indicated device-node.  The results are stored into the @gpios array,
+ * along with the optional GPIO "label" and "flags" values from the "of_gpio"
+ * structure.
+ */
+static inline int of_get_gpio_array(struct device_node *np,
+		const struct of_gpio *of_gpios, struct gpio *gpios, size_t num)
+{
+	return of_get_gpio_array_flags(np, of_gpios, NULL, gpios, num);
+}
+
+/**
+ * of_gpio_request_array() - Request GPIOs using the device-tree
+ * @np:		device node to get GPIO from
+ * @of_gpios:	array of "struct of_gpio" to select which GPIOs to request
+ * @gpios:	array of "struct gpio" to be filled in
+ * @num:	the number of GPIOs to request
+ *
+ * This is a simple wrapper around gpio_request_array() that looks up the
+ * GPIOs from the device-tree first using of_get_gpio_array().
+ */
+static inline int of_gpio_request_array(struct device_node *np,
+		const struct of_gpio *of_gpios, struct gpio *gpios, size_t num)
+{
+	return of_gpio_request_array_flags(np, of_gpios, NULL, gpios, num);
+}
+
 #endif /* __LINUX_OF_GPIO_H */
-- 
1.7.2.5

