Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab1KIBYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 20:24:42 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41908 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab1KIBXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 20:23:37 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Subject: [RFC 6/8] of: add clock providers
Date: Tue,  8 Nov 2011 18:19:41 -0700
Message-Id: <1320801583-12774-7-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
References: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on work by Ben Herrenschmidt and Jeremy Kerr, this patch adds an
of_clk_get function to allow platforms to retrieve clock data from the
device tree.

Platform register a provider through of_clk_add_provider, which will be
called when a device references the provider's OF node for a clock
reference.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 .../devicetree/bindings/clock/clock-bindings.txt   |  109 +++++++++++++++++
 drivers/of/Kconfig                                 |    6 +
 drivers/of/Makefile                                |    1 +
 drivers/of/clock.c                                 |  129 ++++++++++++++++++++
 include/linux/of_clk.h                             |   37 ++++++
 5 files changed, 282 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/clock-bindings.txt
 create mode 100644 drivers/of/clock.c
 create mode 100644 include/linux/of_clk.h

diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt b/Documentation/devicetree/bindings/clock/clock-bindings.txt
new file mode 100644
index 0000000..4770c7e
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
@@ -0,0 +1,109 @@
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
+clock-output-name: Recommended to be a list of strings of clock output signal
+		   names indexed by the first cell in the clock specifier.
+		   However, the meaning of clock-output-names is domain
+		   specific to the clock provider, and is only provided to
+		   encourage using the same meaning for the majority of clock
+		   providers.  This format may not work for clock providers
+		   using a complex clock specifier format.  In those cases it
+		   is recommended to omit this property and create a binding
+		   specific names property.
+
+		   Clock consumer nodes must never directly reference
+		   the provider's clock-output-names property.
+
+For example:
+
+    oscillator {
+        #clock-cells = <1>;
+        clock-output-name = "ckil", "ckih";
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
+clock-input:	List of phandle and clock specifier pairs, one pair
+		for each clock input to the device.
+clock-input-name: List of clock input name strings sorted in the same
+		order as the clock-input property.  Consumers drivers
+		will use clock-input-name to match clock input names
+		with clock-input specifiers.
+
+For example:
+
+    uart {
+        clock-input = <&osc 1> <&ref 0>;
+        clock-input-name = "baud", "register";
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
+        frequency  = <32678>;
+        clock-output-name = "osc";
+    };
+
+    /* phase-locked-loop device, generates a higher frequency clock
+     * from the external oscillator reference */
+    pll: pll {
+        compatible = "some-pll-interface"
+        #clock-cells = <1>;
+        clock-input = <&osc 0>;
+        clock-input-name = "ref";
+        reg = <0x4c000 0x1000>;
+        clock-output-name = "pll", "pll-switched";
+    };
+
+    /* UART, using the low frequency oscillator for the baud clock,
+     * and the high frequency switched PLL output for register
+     * clocking */
+    uart {
+        compatible = "fsl,imx-uart";
+        reg = <0xa000 0x1000>;
+        interrupts = <33>;
+        clock-input = <&osc 0>, <&pll 1>;
+        clock-input-name = "baud", "register";
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
index 0000000..542b9e4
--- /dev/null
+++ b/drivers/of/clock.c
@@ -0,0 +1,129 @@
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
+	rc = of_parse_phandle_with_args(np, "clock", "#clock-cells", index,
+					&clkspec);
+	if (rc)
+		return NULL;
+
+	clk = __of_clk_get_from_provider(&clkspec);
+	of_node_put(clkspec.np);
+	return clk;
+}
+
+struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
+{
+	int index = 0;
+
+	if (name)
+		index = of_property_match_string(np, "clock-input-names", name);
+	return of_clk_get(np, index);
+}
+
diff --git a/include/linux/of_clk.h b/include/linux/of_clk.h
new file mode 100644
index 0000000..e476a5f
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
+static struct clk *of_clk_get(struct device_node *np, int index);
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

