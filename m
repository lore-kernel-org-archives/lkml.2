Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730Ab2GLHPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 03:15:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57910 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2GLHPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 03:15:11 -0400
Message-ID: <4FFE7979.4060000@googlemail.com>
Date: Thu, 12 Jul 2012 09:15:05 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@ti.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RESEND PATCH 1/1] clk: add DT support for clock gating control
Content-Type: multipart/mixed;
 boundary="------------050705000501050404000406"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050705000501050404000406
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

As Rob's clock binding support patch is now up on clk-next, I'd like to
draw attention on this patch again.
--
This patch adds support for using clock gates (clk-gate) from DT based
on Rob Herrings DT clk binding support for 3.6.

It adds a helper function to clk-gate to allocate all resources required by
a set of individual clock gates, i.e. register base address and lock. Each
clock gate is described as a child of the clock-gating-control in DT and
also created by the helper function.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Mike Turquette <mturquette@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
  .../bindings/clock/clock-gating-control.txt        |   80 +++++++++++++++++++
  drivers/clk/clk-gate.c                             |   84 ++++++++++++++++++++
  include/linux/clk-provider.h                       |    2 +
  3 files changed, 166 insertions(+)
  create mode 100644 Documentation/devicetree/bindings/clock/clock-gating-control.txt

diff --git a/Documentation/devicetree/bindings/clock/clock-gating-control.txt 
b/Documentation/devicetree/bindings/clock/clock-gating-control.txt
new file mode 100644
index 0000000..05f5728
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/clock-gating-control.txt
@@ -0,0 +1,80 @@
+Binding for simple clock gating control based on clock gate register with one
+bit per clock gate. This is a clock consumer and also a clock provider for a
+set of gated clocks that are described as children of this node. Each clock gate
+is described by a bit number and polarity to control the gate.
+
+This binding uses the common clock binding[1].
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+==Clock gating control==
+
+Required properties:
+- compatible : shall be "clock-gating-control".
+- reg : should contain the register physical address and length for
+        the clock gating control.
+- clocks : shared parent clock for all gated clocks.
+- #clock-cells : from common clock binding; shall be set to 0.
+- #address-cells : number of cells required to describe a clock gate;
+                   should be <2>.
+- #size-cells : should be zero.
+
+Each individual clock gate bit is described as a child of the
+corresponding gating control register with the following properties.
+
+Required child properties:
+- reg : should contain the individual bit and polarity to control
+        the clock gate. A polarity of 0 means that by setting the
+        bit to 1 the clock passes through the clock gate while
+	setting the bit to 0 disables the clock. Any other value
+     	for polarity inverts the meaning of the control bit.
+
+Optional child properties:
+- clocks : overrides the shared parent clock for this clock gate
+           by the clock passed in this property.
+- clock-output-names : from common clock binding; allows to set
+                       a specific name for the gated clock output.
+
+==Example==
+
+	/* fixed root clock */
+	osc: oscillator {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <166666667>;
+	};
+
+	/* sata peripheral clock */
+	sata_clk: ext-oscillator {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <25000000>;
+	};
+
+	/* register-based clock gating control */
+	gating-control@f10d0038 {
+		compatible = "clock-gating-control";
+		reg = <0xf10d0038 0x4>;
+		clocks = <&osc>;
+		#clock-cells = <0>;
+		#address-cells = <2>;
+		#size-cells = <0>;
+
+		/* USB0 clock gate on register bit 0 with inverted polarity */
+		cg_usb0: clockgate@0 {
+			reg = <0 1>; /* register bit 0, inverted polarity */
+		};
+
+		/* PCIe0 clock gate on register bit 1 with normal polarity
+		 * and named output clock */
+		cg_pcie0: clockgate@1 {
+			reg = <1 0>; /* register bit 1, normal polarity */
+			clock-output-names = "pcie0_clk";
+		};
+
+		/* SATA clock gate with different parent clock */
+		cg_sata: clockgate@3 {
+			reg = <3 0>; /* register bit 3, normal polarity */
+			clocks = <&sata_clk>;
+		};
+	};
diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
index 578465e..1e88907 100644
--- a/drivers/clk/clk-gate.c
+++ b/drivers/clk/clk-gate.c
@@ -15,6 +15,9 @@
  #include <linux/io.h>
  #include <linux/err.h>
  #include <linux/string.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
   /**
   * DOC: basic gatable clock which can gate and ungate it's ouput
@@ -148,3 +151,84 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
   	return clk;
  }
+
+#ifdef CONFIG_OF
+/**
+ * of_clock_gating_control_setup() - Setup function for clock gate control
+ *   This is a helper for using clk-gate from OF device tree. It allocates
+ *   a common lock for a base register and creates the individual clk-gates.
+ */
+void __init of_clock_gating_control_setup(struct device_node *np)
+{
+	struct device_node *child;
+	const char *pclk_name;
+	void __iomem *base;
+	spinlock_t *lockp;
+	unsigned int rnum;
+	u64 addr;
+
+	pclk_name = of_clk_get_parent_name(np, 0);
+	if (!pclk_name) {
+		pr_debug("%s: unable to get parent clock for %s\n",
+			__func__, np->full_name);
+		return;
+	}
+
+	lockp = kzalloc(sizeof(spinlock_t), GFP_KERNEL);
+	if (!lockp) {
+		pr_debug("%s: unable to allocate spinlock for %s\n",
+			 __func__, np->full_name);
+		return;
+	}
+
+	spin_lock_init(lockp);
+	base = of_iomap(np, 0);
+	rnum = sizeof(resource_size_t) * 8;
+	addr = of_translate_address(np, of_get_property(np, "reg", NULL));
+
+	pr_debug("create clock gate control %s\n", np->full_name);
+
+	for_each_child_of_node(np, child) {
+		struct clk *cg;
+		const char *cg_name;
+		const char *cg_pclk_name;
+		u32 propval[2];
+		unsigned int rbit;
+
+		if (of_property_read_u32_array(child, "reg", propval, 2)) {
+			pr_debug("%s: wrong #reg on %s\n",
+				 __func__, child->full_name);
+			continue;
+		}
+
+		rbit = propval[0];
+		if (rbit >= rnum) {
+			pr_debug("%s: bit position of %s exceeds resources\n",
+				 __func__, child->full_name);
+			continue;
+		}
+
+		cg_pclk_name = of_clk_get_parent_name(child, 0);
+		if (!pclk_name)
+			cg_pclk_name = pclk_name;
+
+		if (of_property_read_string(child, "clock-output-names",
+					    &cg_name)) {
+			unsigned int nlen = 4 + 16 + strlen(child->name);
+			char *name = kzalloc(nlen+1, GFP_KERNEL);
+			if (!name)
+				continue;
+			snprintf(name, nlen, "%u@%llx.%s", rbit,
+				 (unsigned long long)addr, child->name);
+			cg_name = name;
+		}
+
+		pr_debug("  create clock gate: %s\n", cg_name);
+
+		cg = clk_register_gate(NULL, cg_name, cg_pclk_name, 0,
+				       base, rbit, propval[1], lockp);
+		if (cg)
+			of_clk_add_provider(child, of_clk_src_simple_get, cg);
+	}
+}
+#endif
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index b97f61e..499eac2 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -205,6 +205,8 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
  		void __iomem *reg, u8 bit_idx,
  		u8 clk_gate_flags, spinlock_t *lock);
  +void of_clock_gating_control_setup(struct device_node *np);
+
  /**
   * struct clk_divider - adjustable divider clock
   *
-- 
1.7.10


--------------050705000501050404000406
Content-Type: text/plain;
 name="Attached Message Part"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Attached Message Part"

This patch adds support for using clock gates (clk-gate) from DT based
on Rob Herrings DT clk binding support for 3.6.

It adds a helper function to clk-gate to allocate all resources required by
a set of individual clock gates, i.e. register base address and lock. Each
clock gate is described as a child of the clock-gating-control in DT and
also created by the helper function.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Mike Turquette <mturquette@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 .../bindings/clock/clock-gating-control.txt        |   80 +++++++++++++++++++
 drivers/clk/clk-gate.c                             |   84 ++++++++++++++++++++
 include/linux/clk-provider.h                       |    2 +
 3 files changed, 166 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/clock-gating-control.txt

diff --git a/Documentation/devicetree/bindings/clock/clock-gating-control.txt b/Documentation/devicetree/bindings/clock/clock-gating-control.txt
new file mode 100644
index 0000000..05f5728
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/clock-gating-control.txt
@@ -0,0 +1,80 @@
+Binding for simple clock gating control based on clock gate register with one
+bit per clock gate. This is a clock consumer and also a clock provider for a
+set of gated clocks that are described as children of this node. Each clock gate
+is described by a bit number and polarity to control the gate.
+
+This binding uses the common clock binding[1].
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+==Clock gating control==
+
+Required properties:
+- compatible : shall be "clock-gating-control".
+- reg : should contain the register physical address and length for
+        the clock gating control.
+- clocks : shared parent clock for all gated clocks.
+- #clock-cells : from common clock binding; shall be set to 0.
+- #address-cells : number of cells required to describe a clock gate;
+                   should be <2>.
+- #size-cells : should be zero.
+
+Each individual clock gate bit is described as a child of the
+corresponding gating control register with the following properties.
+
+Required child properties:
+- reg : should contain the individual bit and polarity to control
+        the clock gate. A polarity of 0 means that by setting the
+        bit to 1 the clock passes through the clock gate while
+	setting the bit to 0 disables the clock. Any other value
+     	for polarity inverts the meaning of the control bit.
+
+Optional child properties:
+- clocks : overrides the shared parent clock for this clock gate
+           by the clock passed in this property.
+- clock-output-names : from common clock binding; allows to set
+                       a specific name for the gated clock output.
+
+==Example==
+
+	/* fixed root clock */
+	osc: oscillator {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <166666667>;
+	};
+
+	/* sata peripheral clock */
+	sata_clk: ext-oscillator {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <25000000>;
+	};
+
+	/* register-based clock gating control */
+	gating-control@f10d0038 {
+		compatible = "clock-gating-control";
+		reg = <0xf10d0038 0x4>;
+		clocks = <&osc>;
+		#clock-cells = <0>;
+		#address-cells = <2>;
+		#size-cells = <0>;
+
+		/* USB0 clock gate on register bit 0 with inverted polarity */
+		cg_usb0: clockgate@0 {
+			reg = <0 1>; /* register bit 0, inverted polarity */
+		};
+
+		/* PCIe0 clock gate on register bit 1 with normal polarity
+		 * and named output clock */
+		cg_pcie0: clockgate@1 {
+			reg = <1 0>; /* register bit 1, normal polarity */
+			clock-output-names = "pcie0_clk";
+		};
+
+		/* SATA clock gate with different parent clock */
+		cg_sata: clockgate@3 {
+			reg = <3 0>; /* register bit 3, normal polarity */
+			clocks = <&sata_clk>;
+		};
+	};
diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
index 578465e..1e88907 100644
--- a/drivers/clk/clk-gate.c
+++ b/drivers/clk/clk-gate.c
@@ -15,6 +15,9 @@
 #include <linux/io.h>
 #include <linux/err.h>
 #include <linux/string.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
 
 /**
  * DOC: basic gatable clock which can gate and ungate it's ouput
@@ -148,3 +151,84 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
 
 	return clk;
 }
+
+#ifdef CONFIG_OF
+/**
+ * of_clock_gating_control_setup() - Setup function for clock gate control
+ *   This is a helper for using clk-gate from OF device tree. It allocates
+ *   a common lock for a base register and creates the individual clk-gates.
+ */
+void __init of_clock_gating_control_setup(struct device_node *np)
+{
+	struct device_node *child;
+	const char *pclk_name;
+	void __iomem *base;
+	spinlock_t *lockp;
+	unsigned int rnum;
+	u64 addr;
+
+	pclk_name = of_clk_get_parent_name(np, 0);
+	if (!pclk_name) {
+		pr_debug("%s: unable to get parent clock for %s\n",
+			__func__, np->full_name);
+		return;
+	}
+
+	lockp = kzalloc(sizeof(spinlock_t), GFP_KERNEL);
+	if (!lockp) {
+		pr_debug("%s: unable to allocate spinlock for %s\n",
+			 __func__, np->full_name);
+		return;
+	}
+
+	spin_lock_init(lockp);
+	base = of_iomap(np, 0);
+	rnum = sizeof(resource_size_t) * 8;
+	addr = of_translate_address(np, of_get_property(np, "reg", NULL));
+
+	pr_debug("create clock gate control %s\n", np->full_name);
+
+	for_each_child_of_node(np, child) {
+		struct clk *cg;
+		const char *cg_name;
+		const char *cg_pclk_name;
+		u32 propval[2];
+		unsigned int rbit;
+
+		if (of_property_read_u32_array(child, "reg", propval, 2)) {
+			pr_debug("%s: wrong #reg on %s\n",
+				 __func__, child->full_name);
+			continue;
+		}
+
+		rbit = propval[0];
+		if (rbit >= rnum) {
+			pr_debug("%s: bit position of %s exceeds resources\n",
+				 __func__, child->full_name);
+			continue;
+		}
+
+		cg_pclk_name = of_clk_get_parent_name(child, 0);
+		if (!pclk_name)
+			cg_pclk_name = pclk_name;
+
+		if (of_property_read_string(child, "clock-output-names",
+					    &cg_name)) {
+			unsigned int nlen = 4 + 16 + strlen(child->name);
+			char *name = kzalloc(nlen+1, GFP_KERNEL);
+			if (!name)
+				continue;
+			snprintf(name, nlen, "%u@%llx.%s", rbit,
+				 (unsigned long long)addr, child->name);
+			cg_name = name;
+		}
+
+		pr_debug("  create clock gate: %s\n", cg_name);
+
+		cg = clk_register_gate(NULL, cg_name, cg_pclk_name, 0,
+				       base, rbit, propval[1], lockp);
+		if (cg)
+			of_clk_add_provider(child, of_clk_src_simple_get, cg);
+	}
+}
+#endif
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index b97f61e..499eac2 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -205,6 +205,8 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
 		void __iomem *reg, u8 bit_idx,
 		u8 clk_gate_flags, spinlock_t *lock);
 
+void of_clock_gating_control_setup(struct device_node *np);
+
 /**
  * struct clk_divider - adjustable divider clock
  *
-- 
1.7.10


--------------050705000501050404000406--
