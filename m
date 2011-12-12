Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab1LLWC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:02:29 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39072 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab1LLWCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:02:23 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Mike Turquette <mturquette@ti.com>, Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [RFC v2 4/9] of: add clock providers
Date: Mon, 12 Dec 2011 15:02:04 -0700
Message-Id: <1323727329-4989-4-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
References: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on work by Ben Herrenschmidt and Jeremy Kerr, this patch adds an
of_clk_get function to allow platforms to retrieve clock data from the
device tree.

Platform register a provider through of_clk_add_provider, which will be
called when a device references the provider's OF node for a clock
reference.

v2: - fixed errant ';' causing compile error
    - Editorial fixes from Shawn Guo
    - merged in adding lookup to clkdev
    - changed property names to match established convention. After
      working with the binding a bit it really made more sense to follow the
      lead of 'reg', 'gpios' and 'interrupts' by making the input simply
      'clocks' & 'clock-names' instead of 'clock-input-*', and to only use
      clock-output* for the producer nodes. (Sorry Shawn, this will mean
      you need to change some code, but it should be trivial)
    - Add ability to inherit clocks from parent nodes by using an empty
      'clock-ranges' property.  Useful for busses.  I could use some feedback
      on the new property name, 'clock-ranges' doesn't feel right to me.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Reviewed-by: Shawn Guo <shawn.guo@freescale.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Mike Turquette <mturquette@ti.com>
---
 .../devicetree/bindings/clock/clock-bindings.txt   |  114 ++++++++++++++
 .../devicetree/bindings/clock/fixed-clock.txt      |   21 +++
 drivers/clk/clkdev.c                               |    9 +
 drivers/of/Kconfig                                 |    6 +
 drivers/of/Makefile                                |    1 +
 drivers/of/clock.c                                 |  165 ++++++++++++++++++++
 include/linux/of_clk.h                             |   37 +++++
 7 files changed, 353 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/clock-bindings.txt
 create mode 100644 Documentation/devicetree/bindings/clock/fixed-clock.txt
 create mode 100644 drivers/of/clock.c
 create mode 100644 include/linux/of_clk.h

diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt b/Documentation/devicetree/bindings/clock/clock-bindings.txt
new file mode 100644
index 0000000..e40c436
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
@@ -0,0 +1,114 @@
+This binding is a work-in-progress, and are based on some experimental
+work by benh[1].
+
+Sources of clock signal can be represented by any node in the device
+tree.  Those nodes are designated as clock providers.  Clock consumer
+nodes use a phandle and clock specifier pair to connect clock provider
+outputs to clock inputs.  Similar to the gpio specifiers, a clock
+specifier is an array of one more more cells identifying the clock
+output on a device.  The length of a clock specifier is defined by the
+value of a #clock-cells property in the clock provider node.
+
+[1] http://patchwork.ozlabs.org/patch/31551/
+
+==Clock providers==
+
+Required properties:
+#clock-cells:	   Number of cells in a clock specifier; typically will be
+		   set to 1
+
+Optional properties:
+clock-output-names: Recommended to be a list of strings of clock output signal
+		    names indexed by the first cell in the clock specifier.
+		    However, the meaning of clock-output-name is domain
+		    specific to the clock provider, and is only provided to
+		    encourage using the same meaning for the majority of clock
+		    providers.  This format may not work for clock providers
+		    using a complex clock specifier format.  In those cases it
+		    is recommended to omit this property and create a binding
+		    specific names property.
+
+		   Clock consumer nodes must never directly reference
+		   the provider's clock-output-name property.
+
+For example:
+
+    oscillator {
+        #clock-cells = <1>;
+        clock-output-names = "ckil", "ckih";
+    };
+
+- this node defines a device with two clock outputs, the first named
+  "ckil" and the second named "ckih".  Consumer nodes always reference
+  clocks by index. The names should reflect the clock output signal
+  names for the device.
+
+==Clock consumers==
+
+Required properties:
+clocks:		List of phandle and clock specifier pairs, one pair
+		for each clock input to the device.
+clock-names:	List of clock input name strings sorted in the same
+		order as the clocks property.  Consumers drivers
+		will use clock-names to match clock input names
+		with clocks specifiers.
+
+Optional properties:
+clock-ranges:	Empty property indicating that child nodes can inherit named
+		clocks from this node. Useful for bus nodes to provide a
+		clock to their children.
+
+For example:
+
+    device {
+        clocks = <&osc 1>, <&ref 0>;
+        clock-names = "baud", "register";
+    };
+
+
+This represents a device with two clock inputs, named "baud" and "register".
+The baud clock is connected to output 1 of the &osc device, and the register
+clock is connected to output 0 of the &ref.
+
+==Example==
+
+    /* external oscillator */
+    osc: oscillator {
+        compatible = "fixed-clock";
+        #clock-cells = <1>;
+        clock-frequency  = <32678>;
+        clock-output-names = "osc";
+    };
+
+    /* phase-locked-loop device, generates a higher frequency clock
+     * from the external oscillator reference */
+    pll: pll@4c000 {
+        compatible = "vendor,some-pll-interface"
+        #clock-cells = <1>;
+        clocks = <&osc 0>;
+        clock-names = "ref";
+        reg = <0x4c000 0x1000>;
+        clock-output-names = "pll", "pll-switched";
+    };
+
+    /* UART, using the low frequency oscillator for the baud clock,
+     * and the high frequency switched PLL output for register
+     * clocking */
+    uart@a000 {
+        compatible = "fsl,imx-uart";
+        reg = <0xa000 0x1000>;
+        interrupts = <33>;
+        clocks = <&osc 0>, <&pll 1>;
+        clock-names = "baud", "register";
+    };
+
+This DT fragment defines three devices: an external oscillator to provide a
+low-frequency reference clock, a PLL device to generate a higher frequency
+clock signal, and a UART.
+
+* The oscillator is fixed-frequency, and provides one clock output, named "osc".
+* The PLL is both a clock provider and a clock consumer. It uses the clock
+  signal generated by the external oscillator, and provides two output signals
+  ("pll" and "pll-switched").
+* The UART has its baud clock connected the external oscillator and its
+  register clock connected to the PLL clock (the "pll-switched" signal)
diff --git a/Documentation/devicetree/bindings/clock/fixed-clock.txt b/Documentation/devicetree/bindings/clock/fixed-clock.txt
new file mode 100644
index 0000000..9a75342
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/fixed-clock.txt
@@ -0,0 +1,21 @@
+Binding for simple fixed-rate clock sources.
+
+This binding uses the common clock binding[1].
+
+[1] Documentation/devicetree/bindings/clock/fixed-clock.txt
+
+Required properties:
+- compatible : shall be "fixed-clock".
+- #clock-cells : from common clock binding; shall be set to 0.
+- clock-frequency : frequency of clock in Hz. May be multiple cells.
+
+Optional properties:
+- gpios : From common gpio binding; gpio connection to clock enable pin.
+- clock-output-names : From common clock binding
+
+Example:
+	clock {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <1000000000>;
+	};
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 6db161f..43628d0 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -19,6 +19,8 @@
 #include <linux/mutex.h>
 #include <linux/clk.h>
 #include <linux/clkdev.h>
+#include <linux/of.h>
+#include <linux/of_clk.h>
 
 static LIST_HEAD(clocks);
 static DEFINE_MUTEX(clocks_mutex);
@@ -78,6 +80,13 @@ EXPORT_SYMBOL(clk_get_sys);
 struct clk *clk_get(struct device *dev, const char *con_id)
 {
 	const char *dev_id = dev ? dev_name(dev) : NULL;
+	struct clk *clk;
+
+	if (dev) {
+		clk = of_clk_get_by_name(dev->of_node, con_id);
+		if (clk && __clk_get(clk))
+			return clk;
+	}
 
 	return clk_get_sys(dev_id, con_id);
 }
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 268163d..b49ab9c 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -47,6 +47,12 @@ config OF_IRQ
 	def_bool y
 	depends on !SPARC
 
+config OF_CLOCK
+	def_bool y
+	depends on HAVE_CLK
+	help
+	  OpenFirmware clock accessors
+
 config OF_DEVICE
 	def_bool y
 
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index a73f5a5..e7ad1e9 100644
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
index 0000000..6519e96
--- /dev/null
+++ b/drivers/of/clock.c
@@ -0,0 +1,165 @@
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
+/**
+ * struct of_clk_provider - Clock provider registration structure
+ * @link: Entry in global list of clock providers
+ * @node: Pointer to device tree node of clock provider
+ * @get: Get clock callback.  Returns NULL or a struct clk for the
+ *       given clock specifier
+ * @data: context pointer to be passed into @get callback
+ */
+struct of_clk_provider {
+	struct list_head link;
+
+	struct device_node *node;
+	struct clk *(*get)(struct of_phandle_args *clkspec, void *data);
+	void *data;
+};
+
+static LIST_HEAD(of_clk_providers);
+static DEFINE_MUTEX(of_clk_lock);
+
+/**
+ * of_clk_add_provider() - Register a clock provider for a node
+ * @np: Device node pointer associated with clock provider
+ * @clk_src_get: callback for decoding clock
+ * @data: context pointer for @clk_src_get callback.
+ */
+int of_clk_add_provider(struct device_node *np,
+			struct clk *(*clk_src_get)(struct of_phandle_args *clkspec,
+						   void *data),
+			void *data)
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
+/**
+ * of_clk_del_provider() - Remove a previously registered clock provider
+ * @np: Device node pointer associated with clock provider
+ */
+void of_clk_del_provider(struct device_node *np)
+{
+	struct of_clk_provider *cp;
+
+	mutex_lock(&of_clk_lock);
+	list_for_each_entry(cp, &of_clk_providers, link) {
+		if (cp->node == np) {
+			list_del(&cp->link);
+			of_node_put(cp->node);
+			kfree(cp);
+			break;
+		}
+	}
+	mutex_unlock(&of_clk_lock);
+}
+
+static struct clk *__of_clk_get_from_provider(struct of_phandle_args *clkspec)
+{
+	struct of_clk_provider *provider;
+	struct clk *clk = NULL;
+
+	/* Check if we have such a provider in our array */
+	mutex_lock(&of_clk_lock);
+	list_for_each_entry(provider, &of_clk_providers, link) {
+		if (provider->node == clkspec->np)
+			clk = provider->get(clkspec, provider->data);
+		if (clk)
+			break;
+	}
+	mutex_unlock(&of_clk_lock);
+
+	return clk;
+}
+
+struct clk *of_clk_get(struct device_node *np, int index)
+{
+	struct of_phandle_args clkspec;
+	struct clk *clk;
+	int rc;
+
+	if (index < 0)
+		return NULL;
+
+	rc = of_parse_phandle_with_args(np, "clocks", "#clock-cells", index,
+					&clkspec);
+	if (rc)
+		return NULL;
+
+	clk = __of_clk_get_from_provider(&clkspec);
+	of_node_put(clkspec.np);
+	return clk;
+}
+
+/**
+ * of_clk_get_by_name() - Parse and lookup a clock referenced by a device node
+ * @np: pointer to clock consumer node
+ * @name: name of consumer's clock input, or NULL for the first clock reference
+ *
+ * This function parses the clocks and clock-names properties,
+ * and uses them to look up the struct clk from the registered list of clock
+ * providers.
+ */
+struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
+{
+	struct clk *clk = NULL;
+
+	/* Walk up the tree of devices looking for a clock that matches */
+	while (np) {
+		int index = 0;
+
+		/*
+		 * For named clocks, first look up the name in the
+		 * "clock-names" property.  If it cannot be found, then
+		 * index will be an error code, and of_clk_get() will fail.
+		 */
+		if (name)
+			index = of_property_match_string(np, "clock-names", name);
+		clk = of_clk_get(np, index);
+		if (clk)
+			break;
+		else if (name && index >= 0) {
+			pr_err("ERROR: could not get clock %s:%s(%i)\n",
+				 np->full_name, name ? name : "", index);
+			return NULL;
+		}
+
+		/*
+		 * No matching clock found on this node.  If the parent node
+		 * has a "clock-ranges" property, then we can try one of its
+		 * clocks.
+		 */
+		np = np->parent;
+		if (np && !of_get_property(np, "clock-ranges", NULL))
+			break;
+	}
+
+	return clk;
+}
diff --git a/include/linux/of_clk.h b/include/linux/of_clk.h
new file mode 100644
index 0000000..dcbd27b
--- /dev/null
+++ b/include/linux/of_clk.h
@@ -0,0 +1,37 @@
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
+			struct clk *(*clk_src_get)(struct of_phandle_args *args,
+						   void *data),
+			void *data);
+
+void of_clk_del_provider(struct device_node *np);
+
+struct clk *of_clk_get(struct device_node *np, int index);
+struct clk *of_clk_get_by_name(struct device_node *np, const char *name);
+
+#else
+static struct clk *of_clk_get(struct device_node *np, int index)
+{
+	return NULL;
+}
+
+static struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
+{
+	return NULL;
+}
+#endif
+
+#endif /* __OF_CLK_H */
+
-- 
1.7.5.4

