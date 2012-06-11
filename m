Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2FKN6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 09:58:36 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:59395 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab2FKN6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 09:58:33 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18XlscZv+D8p6mQsGnlYkXh
Date: Mon, 11 Jun 2012 06:58:28 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] pinctrl: Add one-register-per-pin type device tree based
 pinctrl driver
Message-ID: <20120611135826.GB12766@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add one-register-per-pin type device tree based pinctrl driver.

Currently this driver only works on omap2+ series of processors,
where there is either an 8 or 16-bit padconf register for each pin.
Support for other similar pinmux controllers can be added.

Signed-off-by: Tony Lindgren <tony@atomide.com>

---

Here's this one updated, I renamed it from pinctrl-simple to pinctrl-single
to limit it to one-register-per-mux type MMIO controllers. The bindings
for mapping bits in random registers started looking a bit too complex for
this patch to solve. Hopefully this should also solve the issues of different
expectations of what simple means :)

---
diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-omap2plus.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-omap2plus.txt
new file mode 100644
index 0000000..21b183e
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-omap2plus.txt
@@ -0,0 +1,12 @@
+Pinctrl driver for omap2plus using pinctrl-single driver
+
+Required properties:
+- compatible:  one of:
+	- "ti,omap2420-padconf"
+	- "ti,omap2430-padconf"
+	- "ti,omap3-padconf"
+	- "ti,omap4-padconf"
+
+All omaps starting with omap2 are using pinctrl-single driver for
+the padconf registers. See pinctrl-single.txt in this directory for
+more information.
diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
new file mode 100644
index 0000000..6a6abf9
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
@@ -0,0 +1,102 @@
+One-register-per-pin type device tree based pinctrl driver
+
+Required properties:
+- compatible :  one of:
+	- "pinctrl-single"
+- reg : offset and length of the register set for the mux registers
+- pinctrl-single,register-width : pinmux register access width
+- pinctrl-single,function-mask : mask of allowed pinmux function bits
+- pinctrl-single,function-off : function off mode for disabled state
+- pinctrl-single,pinconf-mask : mask of allowed pinconf bits
+
+This driver uses the common pinctrl bindings as specified in the
+pinctrl-bindings.txt document in this directory.
+
+The pinctrl register offsets and default values are specified as pairs
+using pinctrl-single,pins. For example, setting uart2_rx pin on omap2plus
+can be done with:
+
+	pinctrl-single,pins = <0xdc 0x118>;
+
+Where 0xdc is the offset from the pinctrl ioremapped area for the
+uart2_rx register, and 0x118 contains the desired default value for
+for the pin setting it to INPUT_PULLUP | MODE0. See the uart example and
+static board pins example below for more information.
+
+If you are concerned about the boot time, set up the static pins in
+the bootloader, and only set up selected pins as device tree entries.
+
+This driver assumes that there is only one register for each pin. If you
+have some pins with more complicated configuration, you can set up a separate
+hardware specific driver for those pins.
+
+Note that this driver tries to avoid understanding pin and function
+names because of the extra bloat they would cause especially in the
+omap2plus case. This driver just sets what is specified for the board
+in the .dts file. Further user space debugging tools can be developed
+to decipher the pin and function names using debugfs.
+
+Example:
+
+/* SoC common file, such as omap4.dtsi */
+
+/* first controller instance for pins in core domain */
+omap4_pmx_core: pinmux@4a100040 {
+	compatible = "ti,omap4-padconf";
+	reg = <0x4a100040 0x0196>;
+	#address-cells = <1>;
+	#size-cells = <0>;
+	pinctrl-single,register-width = <16>;
+	pinctrl-single,function-mask = <0x7>;
+	pinctrl-single,function-off = <0xffffffff>;
+	pinctrl-single,pinconf-mask = <0xfff8>;
+};
+
+/* second controller instance for pins in wkup domain */
+omap4_pmx_wkup: pinmux@4a31e040 {
+	compatible = "ti,omap4-padconf";
+	reg = <0x4a31e040 0x0038>;
+	#address-cells = <1>;
+	#size-cells = <0>;
+	pinctrl-single,register-width = <16>;
+	pinctrl-single,function-mask = <0x7>;
+	pinctrl-single,function-off = <0xffffffff>;
+	pinctrl-single,pinconf-mask = <0xfff8>;
+};
+
+
+/* board specific .dts file, such as omap4-sdp.dts */
+
+&omap4_pmx_core {
+
+	/*
+	 * map all board specific static pins enabled by the pinctrl driver
+	 * itself during the boot (or just set them up in the bootloader)
+	 */
+	pinctrl-names = "default";
+	pinctrl-0 = <&board_pins>;
+
+	board_pins: pinmux_board_pins {
+		pinctrl-single,pins = <
+			0x6c 0xf	/* csi21_dx3 OUTPUT | MODE7 */
+			0x6e 0xf	/* csi21_dy3 OUTPUT | MODE7 */
+			0x70 0xf	/* csi21_dx4 OUTPUT | MODE7 */
+			0x72 0xf	/* csi21_dy4 OUTPUT | MODE7 */
+		>;
+	};
+
+	/* map uart2 pins */
+	uart2_pins: pinmux_uart2_pins {
+		pinctrl-single,pins = <
+			0xd8 0x118	/* uart2_cts INPUT_PULLUP | MODE0 */
+			0xda 0		/* uart2_rts OUTPUT | MODE0 */
+			0xdc 0x118	/* uart2_rx INPUT_PULLUP | MODE0 */
+			0xde 0		/* uart2_tx OUTPUT | MODE0 */
+		>;
+	};
+};
+
+&uart2 {
+       pinctrl-names = "default";
+       pinctrl-0 = <&uart2_pins>;
+};
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index c6e6ae0..8071a31 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -102,6 +102,14 @@ config PINCTRL_PXA910
 	select PINCTRL_PXA3xx
 	select PINCONF
 
+config PINCTRL_SINGLE
+	tristate "One-register-per-pin type device tree based pinctrl driver"
+	depends on OF
+	select PINMUX
+	select PINCONF
+	help
+	  This selects the device tree based generic pinctrl driver.
+
 config PINCTRL_SIRF
 	bool "CSR SiRFprimaII pin controller driver"
 	depends on ARCH_PRIMA2
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 8c07437..f40b1f8 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_PINCTRL_NOMADIK)	+= pinctrl-nomadik.o
 obj-$(CONFIG_PINCTRL_DB8500)	+= pinctrl-nomadik-db8500.o
 obj-$(CONFIG_PINCTRL_PXA168)	+= pinctrl-pxa168.o
 obj-$(CONFIG_PINCTRL_PXA910)	+= pinctrl-pxa910.o
+obj-$(CONFIG_PINCTRL_SINGLE)	+= pinctrl-single.o
 obj-$(CONFIG_PINCTRL_SIRF)	+= pinctrl-sirf.o
 obj-$(CONFIG_PINCTRL_TEGRA)	+= pinctrl-tegra.o
 obj-$(CONFIG_PINCTRL_TEGRA20)	+= pinctrl-tegra20.o
diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
new file mode 100644
index 0000000..531c3f4
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -0,0 +1,1012 @@
+/*
+ * Generic device tree based pinctrl driver for one register per pin
+ * type pinmux controllers
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/list.h>
+
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_address.h>
+
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+
+#include "core.h"
+
+#define DRIVER_NAME			"pinctrl-single"
+#define PCS_MUX_NAME			"pinctrl-single,pins"
+#define PCS_REG_NAME_LEN		((sizeof(unsigned long) * 2) + 1)
+
+/**
+ * struct pcs_pingroup - pingroups for a function
+ * @np:		pingroup device node pointer
+ * @name:	pingroup name
+ * @gpins:	array of the pins in the group
+ * @ngpins:	number of pins in the group
+ * @node:	list node
+ */
+struct pcs_pingroup {
+	struct device_node *np;
+	const char *name;
+	int *gpins;
+	int ngpins;
+	struct list_head node;
+};
+
+/**
+ * struct pcs_func_vals - mux function register offset and value pair
+ * @reg:	register virtual address
+ * @defval:	default value
+ */
+struct pcs_func_vals {
+	void __iomem *reg;
+	unsigned defval;
+};
+
+/**
+ * struct pcs_function - pinctrl function
+ * @name:	pinctrl function name
+ * @vals:	register and vals array
+ * @nvals:	number of entries in vals array
+ * @pgnames:	array of pingroup names the function uses
+ * @npgnames:	number of pingroup names the function uses
+ * @node:	list node
+ */
+struct pcs_function {
+	const char *name;
+	struct pcs_func_vals *vals;
+	unsigned nvals;
+	const char **pgnames;
+	int npgnames;
+	struct list_head node;
+};
+
+/**
+ * struct pcs_data - wrapper for data needed by pinctrl framework
+ * @pa:		pindesc array
+ * @cur:	index to current element
+ *
+ * REVISIT: We should be able to drop this eventually by adding
+ * support for registering pins individually in the pinctrl
+ * framework for those drivers that don't need a static array.
+ */
+struct pcs_data {
+	struct pinctrl_pin_desc *pa;
+	int cur;
+};
+
+/**
+ * struct pcs_name - register name for a pin
+ * @name:	name of the pinctrl register
+ *
+ * REVISIT: We may want to make names optional in the pinctrl
+ * framework as some drivers may not care about pin names to
+ * avoid kernel bloat. The pin names can be deciphered by user
+ * space tools using debugfs based on the register address and
+ * SoC packaging information.
+ */
+struct pcs_name {
+	char name[PCS_REG_NAME_LEN];
+};
+
+/**
+ * struct pcs_device - mux device instance
+ * @res:	resources
+ * @base:	virtual address of the controller
+ * @size:	size of the ioremapped area
+ * @dev:	device entry
+ * @pctl:	pin controller device
+ * @mutex:	mutex protecting the lists
+ * @width:	bits per mux register
+ * @fmask:	function register mask
+ * @fshift:	function register shift
+ * @foff:	value to turn mux off
+ * @cmask:	pinconf mask
+ * @fmax:	max number of functions in fmask
+ * @names:	array of register names for pins
+ * @pins:	physical pins on the SoC
+ * @pgtree:	pingroup index radix tree
+ * @ftree:	function index radix tree
+ * @pingroups:	list of pingroups
+ * @functions:	list of functions
+ * @ngroups:	number of pingroups
+ * @nfuncs:	number of functions
+ * @desc:	pin controller descriptor
+ * @read:	register read function to use
+ * @write:	register write function to use
+ */
+struct pcs_device {
+	struct resource *res;
+	void __iomem *base;
+	unsigned size;
+	struct device *dev;
+	struct pinctrl_dev *pctl;
+	struct mutex mutex;
+	unsigned width;
+	unsigned fmask;
+	unsigned fshift;
+	unsigned foff;
+	unsigned cmask;
+	unsigned fmax;
+	struct pcs_name *names;
+	struct pcs_data pins;
+	struct radix_tree_root pgtree;
+	struct radix_tree_root ftree;
+	struct list_head pingroups;
+	struct list_head functions;
+	unsigned ngroups;
+	unsigned nfuncs;
+	struct pinctrl_desc *desc;
+	unsigned (*read)(void __iomem *reg);
+	void (*write)(unsigned val, void __iomem *reg);
+};
+
+/*
+ * REVISIT: Reads and writes could eventually use regmap or something
+ * generic. But at least on omaps, some mux registers are performance
+ * critical as they may need to be remuxed every time before and after
+ * idle. Adding tests for register access width for every read and
+ * write like regmap is doing is not desired, and caching the registers
+ * does not help in this case.
+ */
+
+static unsigned __maybe_unused pcs_readb(void __iomem *reg)
+{
+	return readb(reg);
+}
+
+static unsigned __maybe_unused pcs_readw(void __iomem *reg)
+{
+	return readw(reg);
+}
+
+static unsigned __maybe_unused pcs_readl(void __iomem *reg)
+{
+	return readl(reg);
+}
+
+static void __maybe_unused pcs_writeb(unsigned val, void __iomem *reg)
+{
+	writeb(val, reg);
+}
+
+static void __maybe_unused pcs_writew(unsigned val, void __iomem *reg)
+{
+	writew(val, reg);
+}
+
+static void __maybe_unused pcs_writel(unsigned val, void __iomem *reg)
+{
+	writel(val, reg);
+}
+
+static int pcs_get_groups_count(struct pinctrl_dev *pctldev)
+{
+	struct pcs_device *pcs;
+
+	pcs = pinctrl_dev_get_drvdata(pctldev);
+
+	return pcs->ngroups;
+}
+
+static const char *pcs_get_group_name(struct pinctrl_dev *pctldev,
+					unsigned gselector)
+{
+	struct pcs_device *pcs;
+	struct pcs_pingroup *group;
+
+	pcs = pinctrl_dev_get_drvdata(pctldev);
+	group = radix_tree_lookup(&pcs->pgtree, gselector);
+	if (!group) {
+		dev_err(pcs->dev, "%s could not find pingroup%i\n",
+			__func__, gselector);
+		return NULL;
+	}
+
+	return group->name;
+}
+
+static int pcs_get_group_pins(struct pinctrl_dev *pctldev,
+					unsigned gselector,
+					const unsigned **pins,
+					unsigned *npins)
+{
+	struct pcs_device *pcs;
+	struct pcs_pingroup *group;
+
+	pcs = pinctrl_dev_get_drvdata(pctldev);
+	group = radix_tree_lookup(&pcs->pgtree, gselector);
+	if (!group) {
+		dev_err(pcs->dev, "%s could not find pingroup%i\n",
+			__func__, gselector);
+		return -EINVAL;
+	}
+
+	*pins = group->gpins;
+	*npins = group->ngpins;
+
+	return 0;
+}
+
+static void pcs_pin_dbg_show(struct pinctrl_dev *pctldev,
+					struct seq_file *s,
+					unsigned offset)
+{
+	seq_printf(s, " " DRIVER_NAME);
+}
+
+static void pcs_dt_free_map(struct pinctrl_dev *pctldev,
+				struct pinctrl_map *map, unsigned num_maps)
+{
+	struct pcs_device *pcs;
+
+	pcs = pinctrl_dev_get_drvdata(pctldev);
+	devm_kfree(pcs->dev, map);
+}
+
+static int pcs_dt_node_to_map(struct pinctrl_dev *pctldev,
+				struct device_node *np_config,
+				struct pinctrl_map **map, unsigned *num_maps);
+
+static struct pinctrl_ops pcs_pinctrl_ops = {
+	.get_groups_count = pcs_get_groups_count,
+	.get_group_name = pcs_get_group_name,
+	.get_group_pins = pcs_get_group_pins,
+	.pin_dbg_show = pcs_pin_dbg_show,
+	.dt_node_to_map = pcs_dt_node_to_map,
+	.dt_free_map = pcs_dt_free_map,
+};
+
+static int pcs_get_functions_count(struct pinctrl_dev *pctldev)
+{
+	struct pcs_device *pcs;
+
+	pcs = pinctrl_dev_get_drvdata(pctldev);
+
+	return pcs->nfuncs;
+}
+
+static const char *pcs_get_function_name(struct pinctrl_dev *pctldev,
+						unsigned fselector)
+{
+	struct pcs_device *pcs;
+	struct pcs_function *func;
+
+	pcs = pinctrl_dev_get_drvdata(pctldev);
+	func = radix_tree_lookup(&pcs->ftree, fselector);
+	if (!func) {
+		dev_err(pcs->dev, "%s could not find function%i\n",
+			__func__, fselector);
+		return NULL;
+	}
+
+	return func->name;
+}
+
+static int pcs_get_function_groups(struct pinctrl_dev *pctldev,
+					unsigned fselector,
+					const char * const **groups,
+					unsigned * const ngroups)
+{
+	struct pcs_device *pcs;
+	struct pcs_function *func;
+
+	pcs = pinctrl_dev_get_drvdata(pctldev);
+	func = radix_tree_lookup(&pcs->ftree, fselector);
+	if (!func) {
+		dev_err(pcs->dev, "%s could not find function%i\n",
+			__func__, fselector);
+		return -EINVAL;
+	}
+	*groups = func->pgnames;
+	*ngroups = func->npgnames;
+
+	return 0;
+}
+
+static int pcs_enable(struct pinctrl_dev *pctldev, unsigned fselector,
+	unsigned group)
+{
+	struct pcs_device *pcs;
+	struct pcs_function *func;
+	int i;
+
+	pcs = pinctrl_dev_get_drvdata(pctldev);
+	func = radix_tree_lookup(&pcs->ftree, fselector);
+	if (!func)
+		return -EINVAL;
+
+	dev_dbg(pcs->dev, "enabling function%i %s\n",
+		fselector, func->name);
+
+	for (i = 0; i < func->nvals; i++) {
+		struct pcs_func_vals *vals;
+		unsigned val;
+
+		vals = &func->vals[i];
+		val = pcs->read(vals->reg);
+		val &= ~(pcs->cmask | pcs->fmask);
+		val |= vals->defval;
+		pcs->write(val, vals->reg);
+	}
+
+	return 0;
+}
+
+static void pcs_disable(struct pinctrl_dev *pctldev, unsigned fselector,
+					unsigned group)
+{
+	struct pcs_device *pcs;
+	struct pcs_function *func;
+	int i;
+
+	pcs = pinctrl_dev_get_drvdata(pctldev);
+	func = radix_tree_lookup(&pcs->ftree, fselector);
+	if (!func) {
+		dev_err(pcs->dev, "%s could not find function%i\n",
+			__func__, fselector);
+		return;
+	}
+
+	/*
+	 * Do not touch modes if off mode is larger than supported
+	 * modes. Some hardware does not have clearly defined off modes.
+	 */
+	if ((pcs->foff << pcs->fshift) > pcs->fshift) {
+		dev_dbg(pcs->dev, "not updating mode for disable\n");
+		return;
+	}
+
+	dev_dbg(pcs->dev, "disabling function%i %s\n",
+		fselector, func->name);
+
+	for (i = 0; i < func->nvals; i++) {
+		struct pcs_func_vals *vals;
+		unsigned val;
+
+		vals = &func->vals[i];
+		val = pcs->read(vals->reg);
+		val &= ~(pcs->cmask | pcs->fmask);
+		val |= pcs->foff << pcs->fshift;
+		pcs->write(val, vals->reg);
+	}
+}
+
+static int pcs_request_gpio(struct pinctrl_dev *pctldev,
+			struct pinctrl_gpio_range *range, unsigned offset)
+{
+	return -ENOTSUPP;
+}
+
+static struct pinmux_ops pcs_pinmux_ops = {
+	.get_functions_count = pcs_get_functions_count,
+	.get_function_name = pcs_get_function_name,
+	.get_function_groups = pcs_get_function_groups,
+	.enable = pcs_enable,
+	.disable = pcs_disable,
+	.gpio_request_enable = pcs_request_gpio,
+};
+
+static int pcs_pinconf_get(struct pinctrl_dev *pctldev,
+				unsigned pin, unsigned long *config)
+{
+	return -ENOTSUPP;
+}
+
+static int pcs_pinconf_set(struct pinctrl_dev *pctldev,
+				unsigned pin, unsigned long config)
+{
+	return -ENOTSUPP;
+}
+
+static int pcs_pinconf_group_get(struct pinctrl_dev *pctldev,
+				unsigned group, unsigned long *config)
+{
+	return -ENOTSUPP;
+}
+
+static int pcs_pinconf_group_set(struct pinctrl_dev *pctldev,
+				unsigned group, unsigned long config)
+{
+	return -ENOTSUPP;
+}
+
+static void pcs_pinconf_dbg_show(struct pinctrl_dev *pctldev,
+				struct seq_file *s, unsigned offset)
+{
+}
+
+static void pcs_pinconf_group_dbg_show(struct pinctrl_dev *pctldev,
+				struct seq_file *s, unsigned selector)
+{
+}
+
+static struct pinconf_ops pcs_pinconf_ops = {
+	.pin_config_get = pcs_pinconf_get,
+	.pin_config_set = pcs_pinconf_set,
+	.pin_config_group_get = pcs_pinconf_group_get,
+	.pin_config_group_set = pcs_pinconf_group_set,
+	.pin_config_dbg_show = pcs_pinconf_dbg_show,
+	.pin_config_group_dbg_show = pcs_pinconf_group_dbg_show,
+};
+
+/**
+ * pcs_add_pin() - add a pin to the static per controller pin array
+ * @pcs: pcs driver instance
+ * @offset: register offset from base
+ */
+static int __devinit pcs_add_pin(struct pcs_device *pcs, unsigned offset)
+{
+	struct pinctrl_pin_desc *pin;
+	struct pcs_name *pn;
+	char *name;
+	int i;
+
+	i = pcs->pins.cur;
+	if (i >= pcs->desc->npins) {
+		dev_err(pcs->dev, "too many pins, max %i\n",
+			pcs->desc->npins);
+		return -ENOMEM;
+	}
+
+	pin = &pcs->pins.pa[i];
+	pn = &pcs->names[i];
+	name = pn->name;
+	sprintf(name, "%lx",
+		(unsigned long)pcs->res->start + offset);
+	pin->name = name;
+	pin->number = i;
+	pcs->pins.cur++;
+
+	return i;
+}
+
+/**
+ * pcs_allocate_pin_table() - adds all the pins for the pinctrl driver
+ * @pcs: pcs driver instance
+ *
+ * In case of errors, resources are freed in pcs_free_resources.
+ *
+ * If your hardware needs holes in the address space, then just set
+ * up multiple driver instances.
+ */
+static int __devinit pcs_allocate_pin_table(struct pcs_device *pcs)
+{
+	int mux_bytes, nr_pins, i;
+
+	mux_bytes = pcs->width / BITS_PER_BYTE;
+	nr_pins = pcs->size / mux_bytes;
+
+	dev_dbg(pcs->dev, "allocating %i pins\n", nr_pins);
+	pcs->pins.pa = devm_kzalloc(pcs->dev,
+				sizeof(*pcs->pins.pa) * nr_pins,
+				GFP_KERNEL);
+	if (!pcs->pins.pa)
+		return -ENOMEM;
+
+	pcs->names = devm_kzalloc(pcs->dev,
+				sizeof(struct pcs_name) * nr_pins,
+				GFP_KERNEL);
+	if (!pcs->names)
+		return -ENOMEM;
+
+	pcs->desc->pins = pcs->pins.pa;
+	pcs->desc->npins = nr_pins;
+
+	for (i = 0; i < pcs->desc->npins; i++) {
+		unsigned offset;
+		int res;
+
+		offset = i * mux_bytes;
+		res = pcs_add_pin(pcs, offset);
+		if (res < 0) {
+			dev_err(pcs->dev, "error adding pins: %i\n", res);
+			return res;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * pcs_add_function() - adds a new function to the function list
+ * @pcs: pcs driver instance
+ * @np: device node of the mux entry
+ * @name: name of the function
+ * @vals: array of mux register value pairs used by the function
+ * @nvals: number of mux register value pairs
+ * @pgnames: array of pingroup names for the function
+ * @npgnames: number of pingroup names
+ */
+static struct pcs_function *pcs_add_function(struct pcs_device *pcs,
+					struct device_node *np,
+					const char *name,
+					struct pcs_func_vals *vals,
+					unsigned nvals,
+					const char **pgnames,
+					unsigned npgnames)
+{
+	struct pcs_function *function;
+
+	function = devm_kzalloc(pcs->dev, sizeof(*function), GFP_KERNEL);
+	if (!function)
+		return NULL;
+
+	function->name = name;
+	function->vals = vals;
+	function->nvals = nvals;
+	function->pgnames = pgnames;
+	function->npgnames = npgnames;
+
+	mutex_lock(&pcs->mutex);
+	list_add_tail(&function->node, &pcs->functions);
+	radix_tree_insert(&pcs->ftree, pcs->nfuncs, function);
+	pcs->nfuncs++;
+	mutex_unlock(&pcs->mutex);
+
+	return function;
+}
+
+static void pcs_remove_function(struct pcs_device *pcs,
+				struct pcs_function *function)
+{
+	int i;
+
+	mutex_lock(&pcs->mutex);
+	for (i = 0; i < pcs->nfuncs; i++) {
+		struct pcs_function *found;
+
+		found = radix_tree_lookup(&pcs->ftree, i);
+		if (found == function)
+			radix_tree_delete(&pcs->ftree, i);
+	}
+	list_del(&function->node);
+	mutex_unlock(&pcs->mutex);
+}
+
+/**
+ * pcs_add_pingroup() - add a pingroup to the pingroup list
+ * @pcs: pcs driver instance
+ * @np: device node of the mux entry
+ * @name: name of the pingroup
+ * @gpins: array of the pins that belong to the group
+ * @ngpins: number of pins in the group
+ */
+static int pcs_add_pingroup(struct pcs_device *pcs,
+					struct device_node *np,
+					const char *name,
+					int *gpins,
+					int ngpins)
+{
+	struct pcs_pingroup *pingroup;
+
+	pingroup = devm_kzalloc(pcs->dev, sizeof(*pingroup), GFP_KERNEL);
+	if (!pingroup)
+		return -ENOMEM;
+
+	pingroup->name = name;
+	pingroup->np = np;
+	pingroup->gpins = gpins;
+	pingroup->ngpins = ngpins;
+
+	mutex_lock(&pcs->mutex);
+	list_add_tail(&pingroup->node, &pcs->pingroups);
+	radix_tree_insert(&pcs->pgtree, pcs->ngroups, pingroup);
+	pcs->ngroups++;
+	mutex_unlock(&pcs->mutex);
+
+	return 0;
+}
+
+/**
+ * pcs_get_pin_by_offset() - get a pin index based on the register offset
+ * @pcs: pcs driver instance
+ * @offset: register offset from the base
+ *
+ * Note that this is OK as long as the pins are in a static array.
+ */
+static int pcs_get_pin_by_offset(struct pcs_device *pcs, unsigned offset)
+{
+	unsigned index;
+
+	if (offset >= pcs->size) {
+		dev_err(pcs->dev, "mux offset out of range: 0x%x (0x%x)\n",
+			offset, pcs->size);
+		return -EINVAL;
+	}
+
+	index = offset / (pcs->width / BITS_PER_BYTE);
+
+	return index;
+}
+
+/**
+ * smux_parse_one_pinctrl_entry() - parses a device tree mux entry
+ * @pcs: pinctrl driver instance
+ * @np: device node of the mux entry
+ * @map: map entry
+ * @pgnames: pingroup names
+ *
+ * Note that this currently supports only sets of one register + value.
+ */
+static int pcs_parse_one_pinctrl_entry(struct pcs_device *pcs,
+						struct device_node *np,
+						struct pinctrl_map **map,
+						const char **pgnames)
+{
+	struct pcs_func_vals *vals;
+	const __be32 *mux;
+	int size, rows, *pins, index = 0, found = 0, res = -ENOMEM;
+	struct pcs_function *function;
+
+	mux = of_get_property(np, PCS_MUX_NAME, &size);
+	if ((!mux) || (size < sizeof(*mux) * 2)) {
+		dev_err(pcs->dev, "bad data for mux %s\n",
+			np->name);
+		return -EINVAL;
+	}
+
+	size /= sizeof(*mux);	/* Number of elements in array */
+	rows = size / 2;	/* Each row is a key value pair */
+
+	vals = devm_kzalloc(pcs->dev, sizeof(*vals) * rows, GFP_KERNEL);
+	if (!vals)
+		return -ENOMEM;
+
+	pins = devm_kzalloc(pcs->dev, sizeof(*pins) * rows, GFP_KERNEL);
+	if (!pins)
+		goto free_vals;
+
+	while (index < size) {
+		unsigned offset, defval;
+		int pin;
+
+		offset = be32_to_cpup(mux + index++);
+		defval = be32_to_cpup(mux + index++);
+		vals[found].reg = pcs->base + offset;
+		vals[found].defval = defval;
+
+		pin = pcs_get_pin_by_offset(pcs, offset);
+		if (pin < 0) {
+			dev_err(pcs->dev,
+				"could not add functions for %s %ux\n",
+				np->name, offset);
+			break;
+		}
+		pins[found++] = pin;
+	}
+
+	pgnames[0] = np->name;
+	function = pcs_add_function(pcs, np, np->name, vals, found, pgnames, 1);
+	if (!function)
+		goto free_pins;
+
+	res = pcs_add_pingroup(pcs, np, np->name, pins, found);
+	if (res < 0)
+		goto free_function;
+
+	(*map)->type = PIN_MAP_TYPE_MUX_GROUP;
+	(*map)->data.mux.group = np->name;
+	(*map)->data.mux.function = np->name;
+
+	return 0;
+
+free_function:
+	pcs_remove_function(pcs, function);
+
+free_pins:
+	devm_kfree(pcs->dev, pins);
+
+free_vals:
+	devm_kfree(pcs->dev, vals);
+
+	return res;
+}
+/**
+ * pcs_dt_node_to_map() - allocates and parses pinctrl maps
+ * @pctldev: pinctrl instance
+ * @np_config: device tree pinmux entry
+ * @map: array of map entries
+ * @num_maps: number of maps
+ */
+static int pcs_dt_node_to_map(struct pinctrl_dev *pctldev,
+				struct device_node *np_config,
+				struct pinctrl_map **map, unsigned *num_maps)
+{
+	struct pcs_device *pcs;
+	const char **pgnames;
+	int ret;
+
+	pcs = pinctrl_dev_get_drvdata(pctldev);
+
+	*map = devm_kzalloc(pcs->dev, sizeof(**map), GFP_KERNEL);
+	if (!map)
+		return -ENOMEM;
+
+	*num_maps = 0;
+
+	pgnames = devm_kzalloc(pcs->dev, sizeof(*pgnames), GFP_KERNEL);
+	if (!pgnames) {
+		ret = -ENOMEM;
+		goto free_map;
+	}
+
+	ret = pcs_parse_one_pinctrl_entry(pcs, np_config, map, pgnames);
+	if (ret < 0) {
+		dev_err(pcs->dev, "no pins entries for %s\n",
+			np_config->name);
+		goto free_pgnames;
+	}
+	*num_maps = 1;
+
+	return 0;
+
+free_pgnames:
+	devm_kfree(pcs->dev, pgnames);
+free_map:
+	devm_kfree(pcs->dev, *map);
+
+	return ret;
+}
+
+/**
+ * pcs_free_funcs() - free memory used by functions
+ * @pcs: pcs driver instance
+ */
+static void pcs_free_funcs(struct pcs_device *pcs)
+{
+	struct list_head *pos, *tmp;
+	int i;
+
+	mutex_lock(&pcs->mutex);
+	for (i = 0; i < pcs->nfuncs; i++) {
+		struct pcs_function *func;
+
+		func = radix_tree_lookup(&pcs->ftree, i);
+		if (!func)
+			continue;
+		radix_tree_delete(&pcs->ftree, i);
+	}
+	list_for_each_safe(pos, tmp, &pcs->functions) {
+		struct pcs_function *function;
+
+		function = list_entry(pos, struct pcs_function, node);
+		list_del(&function->node);
+	}
+	mutex_unlock(&pcs->mutex);
+}
+
+/**
+ * pcs_free_pingroups() - free memory used by pingroups
+ * @pcs: pcs driver instance
+ */
+static void pcs_free_pingroups(struct pcs_device *pcs)
+{
+	struct list_head *pos, *tmp;
+	int i;
+
+	mutex_lock(&pcs->mutex);
+	for (i = 0; i < pcs->ngroups; i++) {
+		struct pcs_pingroup *pingroup;
+
+		pingroup = radix_tree_lookup(&pcs->pgtree, i);
+		if (!pingroup)
+			continue;
+		radix_tree_delete(&pcs->pgtree, i);
+	}
+	list_for_each_safe(pos, tmp, &pcs->pingroups) {
+		struct pcs_pingroup *pingroup;
+
+		pingroup = list_entry(pos, struct pcs_pingroup, node);
+		list_del(&pingroup->node);
+	}
+	mutex_unlock(&pcs->mutex);
+}
+
+/**
+ * pcs_free_resources() - free memory used by this driver
+ * @pcs: pcs driver instance
+ */
+static void pcs_free_resources(struct pcs_device *pcs)
+{
+	if (pcs->pctl)
+		pinctrl_unregister(pcs->pctl);
+
+	pcs_free_funcs(pcs);
+	pcs_free_pingroups(pcs);
+}
+
+/**
+ * pcs_register() - initializes and registers with pinctrl framework
+ * @pcs: pcs driver instance
+ */
+static int __devinit pcs_register(struct pcs_device *pcs)
+{
+	int ret;
+
+	if (!pcs->dev->of_node)
+		return -ENODEV;
+
+	pcs->desc = devm_kzalloc(pcs->dev, sizeof(*pcs->desc), GFP_KERNEL);
+	if (!pcs->desc)
+		return -ENOMEM;
+	pcs->desc->name = DRIVER_NAME;
+	pcs->desc->pctlops = &pcs_pinctrl_ops;
+	pcs->desc->pmxops = &pcs_pinmux_ops;
+	pcs->desc->confops = &pcs_pinconf_ops;
+	pcs->desc->owner = THIS_MODULE;
+
+	ret = pcs_allocate_pin_table(pcs);
+	if (ret < 0)
+		goto free;
+
+	pcs->pctl = pinctrl_register(pcs->desc, pcs->dev, pcs);
+	if (!pcs->pctl) {
+		dev_err(pcs->dev, "could not register single pinctrl driver\n");
+		ret = -EINVAL;
+		goto free;
+	}
+
+	dev_info(pcs->dev, "%i pins at pa %p size %u\n",
+		 pcs->desc->npins, pcs->base, pcs->size);
+
+	return 0;
+
+free:
+	pcs_free_resources(pcs);
+
+	return ret;
+}
+
+#define PCS_GET_PROP_U32(name, reg, err)				\
+	do {								\
+		ret = of_property_read_u32(np, name, reg);		\
+		if (ret) {						\
+			dev_err(pcs->dev, err);				\
+			goto out;					\
+		}							\
+	} while (0);
+
+static struct of_device_id pcs_of_match[];
+
+static int __devinit pcs_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	const struct of_device_id *match;
+	struct resource res;
+	struct pcs_device *pcs;
+	int ret;
+
+	match = of_match_device(pcs_of_match, &pdev->dev);
+	if (!match)
+		return -EINVAL;
+
+	pcs = devm_kzalloc(&pdev->dev, sizeof(*pcs), GFP_KERNEL);
+	if (!pcs) {
+		dev_err(&pdev->dev, "could not allocate\n");
+		return -ENOMEM;
+	}
+	pcs->dev = &pdev->dev;
+	mutex_init(&pcs->mutex);
+	INIT_LIST_HEAD(&pcs->pingroups);
+	INIT_LIST_HEAD(&pcs->functions);
+
+	PCS_GET_PROP_U32("pinctrl-single,register-width", &pcs->width,
+			 "register width not specified\n");
+
+	PCS_GET_PROP_U32("pinctrl-single,function-mask", &pcs->fmask,
+			 "function register mask not specified\n");
+	pcs->fshift = ffs(pcs->fmask) - 1;
+	pcs->fmax = pcs->fmask >> pcs->fshift;
+
+	PCS_GET_PROP_U32("pinctrl-single,function-off", &pcs->foff,
+			 "function off mode not specified\n");
+
+	PCS_GET_PROP_U32("pinctrl-single,pinconf-mask", &pcs->cmask,
+			 "pinconf mask not specified\n");
+
+	ret = of_address_to_resource(pdev->dev.of_node, 0, &res);
+	if (ret) {
+		dev_err(pcs->dev, "could not get resource\n");
+		goto out;
+	}
+
+	pcs->res = devm_request_mem_region(pcs->dev, res.start,
+			resource_size(&res), DRIVER_NAME);
+	if (!pcs->res) {
+		dev_err(pcs->dev, "could not get mem_region\n");
+		ret = -EBUSY;
+		goto out;
+	}
+
+	pcs->size = resource_size(pcs->res);
+	pcs->base = devm_ioremap(pcs->dev, pcs->res->start, pcs->size);
+	if (!pcs->base) {
+		dev_err(pcs->dev, "could not ioremap\n");
+		ret = -ENODEV;
+		goto out;
+	}
+
+	INIT_RADIX_TREE(&pcs->pgtree, GFP_KERNEL);
+	INIT_RADIX_TREE(&pcs->ftree, GFP_KERNEL);
+	platform_set_drvdata(pdev, pcs);
+
+	switch (pcs->width) {
+	case 8:
+		pcs->read = pcs_readb;
+		pcs->write = pcs_writeb;
+		break;
+	case 16:
+		pcs->read = pcs_readw;
+		pcs->write = pcs_writew;
+		break;
+	case 32:
+		pcs->read = pcs_readl;
+		pcs->write = pcs_writel;
+		break;
+	default:
+		break;
+	}
+
+	ret = pcs_register(pcs);
+	if (ret < 0) {
+		dev_err(pcs->dev, "could not add mux registers: %i\n", ret);
+		goto out;
+	}
+
+	return 0;
+
+out:
+	return ret;
+}
+
+static int __devexit pcs_remove(struct platform_device *pdev)
+{
+	struct pcs_device *pcs = platform_get_drvdata(pdev);
+
+	if (!pcs)
+		return 0;
+
+	pcs_free_resources(pcs);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct of_device_id pcs_of_match[] __devinitdata = {
+	{ .compatible = DRIVER_NAME, },
+	{ .compatible = "ti,omap2420-padconf", },
+	{ .compatible = "ti,omap2430-padconf", },
+	{ .compatible = "ti,omap3-padconf", },
+	{ .compatible = "ti,omap4-padconf", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, pcs_of_match);
+
+static struct platform_driver pcs_driver = {
+	.probe		= pcs_probe,
+	.remove		= __devexit_p(pcs_remove),
+	.driver = {
+		.owner		= THIS_MODULE,
+		.name		= DRIVER_NAME,
+		.of_match_table	= pcs_of_match,
+	},
+};
+
+module_platform_driver(pcs_driver);
+
+MODULE_AUTHOR("Tony Lindgren <tony@atomide.com>");
+MODULE_DESCRIPTION("One-register-per-pin type device tree based pinctrl driver");
+MODULE_LICENSE("GPL");
