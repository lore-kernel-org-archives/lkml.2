Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab1AZEoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 23:44:25 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56308 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab1AZEoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 23:44:23 -0500
Subject: [RFC PATCH 3/5] of: add clock providers
To: devicetree-discuss@lists.ozlabs.org, jeremy.kerr@canonical.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: nicolas.pitre@linaro.org
Date: Tue, 25 Jan 2011 21:44:17 -0700
Message-ID: <20110126044416.16410.68942.stgit@localhost6.localdomain6>
In-Reply-To: <20110126043338.16410.75019.stgit@localhost6.localdomain6>
References: <20110126043338.16410.75019.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Kerr <jeremy.kerr@canonical.com>

Based on work by Ben Herrenschmidt, this patch adds an of_clk_get
function to allow platforms to retrieve clock data from the device tree.

Platform register a provider through of_clk_add_provider, which will be
called when a device references the provider's OF node for a clock
reference.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
[grant.likely@secretlab.ca: fix Kconfig conflict]
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/of/Kconfig     |    5 ++
 drivers/of/Makefile    |    1 
 drivers/of/clock.c     |  134 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_clk.h |   36 +++++++++++++
 4 files changed, 176 insertions(+), 0 deletions(-)
 create mode 100644 drivers/of/clock.c
 create mode 100644 include/linux/of_clk.h

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 3c6e100..6650583 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -69,4 +69,9 @@ config OF_MDIO
 	help
 	  OpenFirmware MDIO bus (Ethernet PHY) accessors
 
+config OF_CLOCK
+	def_bool y
+	depends on HAVE_CLK
+	help
+	  OpenFirmware clock accessors
 endmenu # OF
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index 3ab21a0..c378c7b 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_OF_ADDRESS)  += address.o
 obj-$(CONFIG_OF_IRQ)    += irq.o
 obj-$(CONFIG_OF_DEVICE) += device.o platform.o
 obj-$(CONFIG_OF_GPIO)   += gpio.o
+obj-$(CONFIG_OF_CLOCK)	+= clock.o
 obj-$(CONFIG_OF_I2C)	+= of_i2c.o
 obj-$(CONFIG_OF_NET)	+= of_net.o
 obj-$(CONFIG_OF_SPI)	+= of_spi.o
diff --git a/drivers/of/clock.c b/drivers/of/clock.c
new file mode 100644
index 0000000..3e2b221
--- /dev/null
+++ b/drivers/of/clock.c
@@ -0,0 +1,134 @@
+/*
+ * Clock infrastructure for device tree platforms
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_clk.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+
+struct of_clk_provider {
+	struct list_head	link;
+	struct device_node	*node;
+
+	/* Return NULL if no such clock output */
+	struct clk		*(*get)(struct device_node *np,
+					const char *output_id, void *data);
+	void			*data;
+};
+
+static LIST_HEAD(of_clk_providers);
+static DEFINE_MUTEX(of_clk_lock);
+
+int of_clk_add_provider(struct device_node *np,
+		struct clk *(*clk_src_get)(struct device_node *np,
+			const char *output_id,
+			void *data),
+		void *data)
+{
+	struct of_clk_provider *cp;
+
+	cp = kzalloc(sizeof(struct of_clk_provider), GFP_KERNEL);
+	if (!cp)
+		return -ENOMEM;
+
+	cp->node = of_node_get(np);
+	cp->data = data;
+	cp->get = clk_src_get;
+
+	mutex_lock(&of_clk_lock);
+	list_add(&cp->link, &of_clk_providers);
+	mutex_unlock(&of_clk_lock);
+	pr_debug("Added clock from %s\n", np->full_name);
+
+	return 0;
+}
+
+void of_clk_del_provider(struct device_node *np,
+		struct clk *(*clk_src_get)(struct device_node *np,
+			const char *output_id,
+			void *data),
+		void *data)
+{
+	struct of_clk_provider *cp, *tmp;
+
+	mutex_lock(&of_clk_lock);
+	list_for_each_entry_safe(cp, tmp, &of_clk_providers, link) {
+		if (cp->node == np && cp->get == clk_src_get &&
+				cp->data == data) {
+			list_del(&cp->link);
+			of_node_put(cp->node);
+			kfree(cp);
+			break;
+		}
+	}
+	mutex_unlock(&of_clk_lock);
+}
+
+static struct clk *__of_clk_get_from_provider(struct device_node *np, const char *clk_output)
+{
+	struct of_clk_provider *provider;
+	struct clk *clk = NULL;
+
+	/* Check if we have such a provider in our array */
+	mutex_lock(&of_clk_lock);
+	list_for_each_entry(provider, &of_clk_providers, link) {
+		if (provider->node == np)
+			clk = provider->get(np, clk_output, provider->data);
+		if (clk)
+			break;
+	}
+	mutex_unlock(&of_clk_lock);
+
+	return clk;
+}
+
+struct clk *of_clk_get(struct device *dev, const char *id)
+{
+	struct device_node *provnode;
+	u32 provhandle;
+	int sz;
+	struct clk *clk;
+	char prop_name[32]; /* 32 is max size of property name */
+	const void *prop;
+
+	dev_dbg(dev, "Looking up %s-clock from device tree\n", id);
+
+	snprintf(prop_name, 32, "%s-clock", id ? id : "bus");
+	prop = of_get_property(dev->of_node, prop_name, &sz);
+	if (!prop || sz < 4)
+		return NULL;
+
+	/* Extract the phandle from the start of the property value */
+	provhandle = be32_to_cpup(prop);
+	prop += 4;
+	sz -= 4;
+
+	/* Make sure the clock name is properly terminated and within the
+	 * size of the property. */
+	if (strlen(prop) + 1 > sz)
+		return NULL;
+
+	/* Find the clock provider node; check if it is registered as a
+	 * provider, and ask it for the relevant clk structure */
+	provnode = of_find_node_by_phandle(provhandle);
+	if (!provnode) {
+		pr_warn("%s: %s property in node %s references invalid phandle",
+			__func__, prop_name, dev->of_node->full_name);
+		return NULL;
+	}
+	clk = __of_clk_get_from_provider(provnode, prop);
+	if (clk)
+		dev_dbg(dev, "Using clock from %s\n", provnode->full_name);
+
+	of_node_put(provnode);
+
+	return clk;
+}
+
diff --git a/include/linux/of_clk.h b/include/linux/of_clk.h
new file mode 100644
index 0000000..c2f6b5a
--- /dev/null
+++ b/include/linux/of_clk.h
@@ -0,0 +1,36 @@
+/*
+ * Clock infrastructure for device tree platforms
+ */
+#ifndef __OF_CLK_H
+#define __OF_CLK_H
+
+struct device;
+struct clk;
+
+#ifdef CONFIG_OF_CLOCK
+
+struct device_node;
+
+int of_clk_add_provider(struct device_node *np,
+		struct clk *(*clk_src_get)(struct device_node *np,
+			const char *output_id,
+			void *data),
+		void *data);
+
+void of_clk_del_provider(struct device_node *np,
+		struct clk *(*clk_src_get)(struct device_node *np,
+			const char *output_id,
+			void *data),
+		void *data);
+
+struct clk *of_clk_get(struct device *dev, const char *id);
+
+#else
+static inline struct clk *of_clk_get(struct device *dev, const char *id)
+{
+	return NULL;
+}
+#endif
+
+#endif /* __OF_CLK_H */
+

