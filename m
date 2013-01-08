Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab3AHHT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 02:19:28 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11566 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab3AHHTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 02:19:25 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 07 Jan 2013 23:16:33 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: Guenter Roeck <linux@roeck-us.net>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 2/4] gpiolib: add gpiod_get and gpiod_put functions
Date: Tue, 8 Jan 2013 16:18:53 +0900
Message-ID: <1357629535-26033-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357629535-26033-1-git-send-email-acourbot@nvidia.com>
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds new GPIO allocation functions that work with the opaque descriptor
interface.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c        | 164 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/gpio/consumer.h |   8 +++
 include/linux/gpio/driver.h   |  21 ++++++
 3 files changed, 193 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d04b90b..06ffadb 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -3,6 +3,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/spinlock.h>
+#include <linux/list.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/debugfs.h>
@@ -74,6 +75,11 @@ struct gpio_desc {
 };
 static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
 
+/* protects both gpio_lookup_list and gpio_chips */
+static DEFINE_MUTEX(gpio_lookup_lock);
+static LIST_HEAD(gpio_lookup_list);
+static LIST_HEAD(gpio_chips);
+
 #ifdef CONFIG_GPIO_SYSFS
 static DEFINE_IDR(dirent_idr);
 #endif
@@ -1162,6 +1168,11 @@ int gpiochip_add(struct gpio_chip *chip)
 
 	of_gpiochip_add(chip);
 
+	INIT_LIST_HEAD(&chip->list);
+	mutex_lock(&gpio_lookup_lock);
+	list_add(&chip->list, &gpio_chips);
+	mutex_unlock(&gpio_lookup_lock);
+
 unlock:
 	spin_unlock_irqrestore(&gpio_lock, flags);
 
@@ -1200,6 +1211,10 @@ int gpiochip_remove(struct gpio_chip *chip)
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
+	mutex_lock(&gpio_lookup_lock);
+	list_del_init(&chip->list);
+	mutex_unlock(&gpio_lookup_lock);
+
 	gpiochip_remove_pin_ranges(chip);
 	of_gpiochip_remove(chip);
 
@@ -1924,6 +1939,155 @@ void gpiod_set_value_cansleep(struct gpio_desc *desc, int value)
 }
 EXPORT_SYMBOL_GPL(gpiod_set_value_cansleep);
 
+
+/**
+ * gpioh_add_table() - register GPIO device consumers
+ * @table: array of consumers to register
+ * @num: number of consumers in table
+ */
+void gpiod_add_table(struct gpiod_lookup *table, size_t size)
+{
+	mutex_lock(&gpio_lookup_lock);
+
+	while (size--) {
+		list_add_tail(&table->list, &gpio_lookup_list);
+		table++;
+	}
+
+	mutex_unlock(&gpio_lookup_lock);
+}
+
+/*
+ * Caller must have a acquired gpio_lookup_lock
+ */
+static struct gpio_chip *find_chip_by_name(const char *name)
+{
+	struct gpio_chip *chip = NULL;
+
+	list_for_each_entry(chip, &gpio_lookup_list, list) {
+		if (chip->label == NULL)
+			continue;
+		if (!strcmp(chip->label, name))
+			break;
+	}
+
+	return chip;
+}
+
+#ifdef CONFIG_OF
+static struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id)
+{
+	char prop_name[32]; /* 32 is max size of property name */
+
+	if (con_id)
+		snprintf(prop_name, 32, "%s-gpios", con_id);
+	else
+		snprintf(prop_name, 32, "gpios");
+
+	return of_get_named_gpiod_flags(dev->of_node, prop_name, 0, NULL);
+}
+#else
+static struct device_node *of_find_gpio(struct device *dev, const char *id)
+{
+	return NULL;
+}
+#endif
+
+static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id)
+{
+	const char *dev_id = dev ? dev_name(dev) : NULL;
+	struct gpio_desc *desc = ERR_PTR(-ENODEV);
+	unsigned int match, best = 0;
+	struct gpiod_lookup *p;
+
+	mutex_lock(&gpio_lookup_lock);
+
+	list_for_each_entry(p, &gpio_lookup_list, list) {
+		match = 0;
+
+		if (p->dev_id) {
+			if (!dev_id || strcmp(p->dev_id, dev_id))
+				continue;
+
+			match += 2;
+		}
+
+		if (p->con_id) {
+			if (!con_id || strcmp(p->con_id, con_id))
+				continue;
+
+			match += 1;
+		}
+
+		if (match > best) {
+			struct gpio_chip *chip;
+
+			chip = find_chip_by_name(p->chip_label);
+			if (!chip) {
+				dev_warn(dev, "cannot find GPIO chip %s\n",
+					 p->chip_label);
+				continue;
+			}
+
+			if (chip->ngpio >= p->chip_hwnum) {
+				dev_warn(dev, "GPIO chip %s has %d GPIOs\n",
+					 chip->label, chip->ngpio);
+				continue;
+			}
+
+			desc = gpio_to_desc(chip->base + p->chip_hwnum);
+
+			if (match != 3)
+				best = match;
+			else
+				break;
+		}
+	}
+
+	mutex_unlock(&gpio_lookup_lock);
+
+	return desc;
+}
+
+/**
+ *
+ */
+struct gpio_desc *__must_check gpiod_get(struct device *dev, const char *con_id)
+{
+	struct gpio_desc *desc;
+	int status;
+
+	dev_dbg(dev, "GPIO lookup for consumer %s\n", con_id);
+
+	/* Using device tree? */
+	if (IS_ENABLED(CONFIG_OF) && dev && dev->of_node) {
+		dev_dbg(dev, "using device tree for GPIO lookup\n");
+		desc = of_find_gpio(dev, con_id);
+	} else {
+		dev_dbg(dev, "using lookup tables for GPIO lookup");
+		desc = gpiod_find(dev, con_id);
+	}
+
+	if (IS_ERR(desc)) {
+		dev_warn(dev, "lookup for GPIO %s failed\n", con_id);
+		return desc;
+	}
+
+	status = gpiod_request(desc, con_id);
+
+	if (status < 0)
+		return ERR_PTR(status);
+
+	return desc;
+}
+EXPORT_SYMBOL_GPL(gpiod_get);
+
+void gpiod_put(struct gpio_desc *desc)
+{
+	gpiod_free(desc);
+}
+EXPORT_SYMBOL_GPL(gpiod_put);
+
 #ifdef CONFIG_DEBUG_FS
 
 static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index 0ce96cf..2f30761 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -15,6 +15,14 @@ struct gpio_chip;
  */
 struct gpio_desc;
 
+struct gpio_desc *__must_check gpiod_get(struct device *dev,
+					 const char *con_id);
+void gpiod_put(struct gpio_desc *desc);
+
+struct gpio_desc *__must_check devm_gpiod_get(struct device *dev,
+					      const char *con_id);
+void devm_gpiod_put(struct device *dev, struct gpio_desc *desc);
+
 struct gpio_desc *gpio_to_desc(unsigned gpio);
 int desc_to_gpio(const struct gpio_desc *desc);
 struct gpio_chip *gpiod_to_chip(struct gpio_desc *desc);
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index d42f941..d43d671 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -4,12 +4,14 @@
 #ifdef CONFIG_GPIOLIB
 
 #include <linux/types.h>
+#include <linux/list.h>
 
 /**
  * struct gpio_chip - abstract a GPIO controller
  * @label: for diagnostics
  * @dev: optional device providing the GPIOs
  * @owner: helps prevent removal of modules exporting active GPIOs
+ * @list: links gpio_chips together for traversal
  * @request: optional hook for chip-specific activation, such as
  *	enabling module power and clock; may sleep
  * @free: optional hook for chip-specific deactivation, such as
@@ -55,6 +57,7 @@ struct gpio_chip {
 	const char		*label;
 	struct device		*dev;
 	struct module		*owner;
+	struct list_head	list;
 
 	int			(*request)(struct gpio_chip *chip,
 						unsigned offset);
@@ -107,6 +110,24 @@ struct gpio_chip {
 #endif
 };
 
+struct gpiod_lookup {
+	struct list_head list;
+	const char *chip_label;
+	u16 chip_hwnum;
+	const char *dev_id;
+	const char *con_id;
+};
+
+#define GPIO_LOOKUP(_chip_label, _chip_hwnum, _dev_id, _con_id)	\
+{								\
+	.chip_label = _chip_label,				\
+	.chip_hwnum = _chip_hwnum,				\
+	.dev_id = _dev_id,					\
+	.con_id = _con_id,					\
+}
+
+void gpiod_add_table(struct gpiod_lookup *table, size_t size);
+
 #endif /* CONFIG_GPIOLIB */
 
 #endif
-- 
1.8.1

