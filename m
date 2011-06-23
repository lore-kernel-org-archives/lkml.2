Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276Ab1FWUIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 16:08:10 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45383 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759408Ab1FWUIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 16:08:07 -0400
X-Greylist: delayed 562 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Jun 2011 16:08:07 EDT
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>
Subject: RFC: drivers: swarren's pinmux API concept
Date: Thu, 23 Jun 2011 13:58:32 -0600
Message-Id: <1308859112-14260-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus W,

This "patch" is a quick-and-dirty outline of where I'd love to see the
pinmux API go, but this time in code rather than English description.

Note that I elided a bunch of stuff from the headers; some comments weren't
updated, I removed the inline functions for when pinmux is disabled, etc.
The code has not been compiled. The main idea is just to give an idea of
what I'm thinking.

Let me know if any of this looks reasonable to you; if so, I can look into
fixing the issues above, making the core pinmux code actually work in this
model, or whatever.

Thanks!

---
 drivers/pinctrl/pinmux-tegra2.c  |   85 ++++++++++++++++++++++
 include/linux/pinctrl/consumer.h |   47 ++++++++++++
 include/linux/pinctrl/machine.h  |   47 ++++++++++++
 include/linux/pinctrl/provider.h |  149 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 328 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pinctrl/pinmux-tegra2.c
 create mode 100644 include/linux/pinctrl/consumer.h
 create mode 100644 include/linux/pinctrl/machine.h
 create mode 100644 include/linux/pinctrl/provider.h

diff --git a/drivers/pinctrl/pinmux-tegra2.c b/drivers/pinctrl/pinmux-tegra2.c
new file mode 100644
index 0000000..d010f9c
--- /dev/null
+++ b/drivers/pinctrl/pinmux-tegra2.c
@@ -0,0 +1,85 @@
+/*
+ * pinctrl driver for NVIDIA Tegra 2
+ *
+ * Author: Stephen Warren <swarren@nvidia.com>
+ * Copyright (C) 2011 NVIDIA, Inc.
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#include <linux/pinmux/provider.h>
+
+struct tegra_pin {
+	struct pinctrl_pin core;
+	int reg_addr; /* e.g. for per-pin config */
+	/* And other info */
+};
+
+struct tegra_function {
+	struct pinctrl_function core;
+	int reg_value;
+	/* And other info */
+}
+
+struct tegra_group {
+	struct pinctrl_group core;
+	int reg_addr; /* e.g. for muxing and per-pin config */
+	int reg_bit;
+	/* And other info */
+}
+
+struct tegra_pin tegra_pins[] = {
+	{ .core = { .name = "a0", }, }, /* 0 */
+	{ .core = { .name = "a1", }, }, /* 1 */
+	{ .core = { .name = "b0", }, }, /* 2 */
+	{ .core = { .name = "b1", }, }, /* 3 */
+	{ .core = { .name = "c0", }, }, /* 4 */
+	{ .core = { .name = "c1", }, }, /* 5 */
+	{ .core = { .name = "d0", }, }, /* 6 */
+	{ .core = { .name = "d1", }, }, /* 7 */
+	{ .core = { .name = "e0", }, }, /* 8 */
+	{ .core = { .name = "e1", }, }, /* 9 */
+
+/* Or: */
+#define PIN_B0 2
+	.PIN_B0 = { .core = { .name = "b0", }, },
+};
+
+struct tegra_function tegra_function[] = {
+	{ .core = { .name = "kbc-col-1:0", }, 1     }, /* 0 */
+	{ .core = { .name = "kbc-row-1:0", }, 2     }, /* 1 */
+	{ .core = { .name = "i2c0", },        3     }, /* 2 */
+	{ .core = { .name = "uartrxtx0", },   4     }, /* 3 */
+	{ .core = { .name = "spiclkdata0", }, 5     }, /* 4 */
+	{ .core = { .name = "gpioctrlr0", },  0x8001}, /* 5 */
+	{ .core = { .name = "gpioctrlr1", },  0x8002}, /* 6 */
+
+/* Or: */
+#define FUNC_I2C0 2
+	.FUNC_I2C0 = { .core = { .name = "i2c0", }, 3},
+
+};
+
+int pins_kbca[] = { 0, 1 };
+int funcs_kbca[] = { 0, 5 };
+
+int pins_kbcb[] = { 2, 3 };
+int funcs_kbcb[] = { 1, 5 };
+
+int pins_ddca[] = { 4, 5 };
+int funcs_ddca[] = { 2, 3, 5, 6 };
+
+int pins_ddcb[] = { 6, 7 };
+int funcs_ddcb[] = { 2, 4, 5, 6 };
+
+int pins_xx[] = { 8, 9};
+int funcs_xx[] = { 5, 6};
+
+struct tegra_group tegra_groups[] = {
+	{ .core = { .name = "kbca", npins = 2, pins = pins_kbca, nfunctions = 2, functions = funcs_kbca} },
+	{ .core = { .name = "kbcb", npins = 2, pins = pins_kbcb, nfunctions = 2, functions = funcs_kbcb} },
+	{ .core = { .name = "ddca", npins = 2, pins = pins_ddca, nfunctions = 4, functions = funcs_ddca} },
+	{ .core = { .name = "ddcb", npins = 2, pins = pins_ddcb, nfunctions = 4, functions = funcs_ddcb} },
+	{ .core = { .name = "xx",   npins = 2, pins = pins_xx,   nfunctions = 2, functions = funcs_xx  } },
+};
+
diff --git a/include/linux/pinctrl/consumer.h b/include/linux/pinctrl/consumer.h
new file mode 100644
index 0000000..81cedf3
--- /dev/null
+++ b/include/linux/pinctrl/consumer.h
@@ -0,0 +1,47 @@
+/*
+ * pinctrl subsystem's client/consumer interface
+ *
+ * Copyright (C) 2011 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ * Based on bits of regulator core, gpio core and clk core
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * Copyright (C) 2011 NVIDIA, Inc.
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+#ifndef __LINUX_PINCTRL_CONSUMER_H
+#define __LINUX_PINCTRL_CONSUMER_H
+
+#include <linux/list.h>
+#include <linux/seq_file.h>
+
+/* This struct is private to the core and should be regarded as a cookie */
+struct pinctrl;
+
+/* Not sure this is useful: */
+extern bool pin_is_valid(int pin);
+
+/* Basic pinmux API: */
+extern struct pinctrl *pinctrl_get(struct device *dev, const char *mapping);
+extern void pinctrl_put(struct pinctrl *pmx);
+extern int pinctrl_enable(struct pinctrl *pmx);
+extern void pinctrl_disable(struct pinctrl *pmx);
+
+/*
+ * Custom config interface:
+ * Drivers would probably use the first function, since they would
+ * already have pinctrl_get()d the mapping they want to configure.
+ *
+ * Generic setup code couuldn't use pinctrl_get since that actually
+ * reserved that mapping. Plus, we potentially need a way to configure
+ * individual pins
+ */
+extern int pinctrl_config(struct pinctrl *pmx, u16 param, unsigned long *data);
+extern int pinctrl_config_group(const char *chip, const char* groupname,
+				u16 param, unsigned long *data);
+extern int pinctrl_config_pin(const char *chip, const char* pinname, u16 param,
+			      unsigned long *data);
+
+#endif /* __LINUX_PINCTRL_CONSUMER_H */
diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
new file mode 100644
index 0000000..5797e84
--- /dev/null
+++ b/include/linux/pinctrl/machine.h
@@ -0,0 +1,47 @@
+/*
+ * pinctrl subsystem's machine/board mapping configuration interface
+ *
+ * Copyright (C) 2011 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ * Based on bits of regulator core, gpio core and clk core
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * Copyright (C) 2011 NVIDIA, Inc.
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+#ifndef __LINUX_PINMUX_MACHINE_H
+#define __LINUX_PINMUX_MACHINE_H
+
+/**
+ * struct pinctrl_map - boards/machines shall provide this map for devices
+ * @dev_name: the name of the device using this specific mapping, the name
+ *	must be the same as in your struct device*
+ * @mapping: the mapping name being defined
+ * @chip: the chip on which to set the mux
+ * @group: the group on which to set the mux
+ * @function: the function to select
+ */
+/*
+ * Example:
+ * { "tegra-kbc",   NULL,      "tegra", "kbca", "kbc-col-1:0" },
+ * { "tegra-kbc",   NULL,      "tegra", "kbcb", "kbc-row-1:0" },
+ * { "tegra-i2c.0", "bus0",    "tegra", "ddca", "i2c0"        },
+ * { "tegra-i2c.0", "bus1",    "tegra", "ddcb", "i2c0"        },
+ * { NULL,          "bootup",  "tegra", "xx",   "gpioctrlr0"  },
+ *
+ * (Machine boot code searches for "bootup" and activates everything there)
+ */
+struct pinctrl_map {
+	const char *dev_name;
+	const char *mapping;
+	const char *chip;
+	const char *group;
+	const char *function;
+};
+
+extern int pinctrl_register_mappings(struct pinctrl_map const *map,
+				unsigned num_maps);
+
+#endif /* __LINUX_PINCTRL_MACHINE_H */
diff --git a/include/linux/pinctrl/provider.h b/include/linux/pinctrl/provider.h
new file mode 100644
index 0000000..ee355f3
--- /dev/null
+++ b/include/linux/pinctrl/provider.h
@@ -0,0 +1,149 @@
+/*
+ * pinctrl subsystem's pinctrl driver interface
+ *
+ * Copyright (C) 2011 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ * Based on bits of regulator core, gpio core and clk core
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * Copyright (C) 2011 NVIDIA, Inc.
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+#ifndef __LINUX_PINCTRL_PROVIDER_H
+#define __LINUX_PINCTRL_PROVIDER_H
+
+#include <linux/list.h>
+#include <linux/seq_file.h>
+
+struct pinctrl_dev;
+
+struct pinctrl_pin {
+	char *name;
+};
+
+struct pinctrl_function {
+	char *name;
+};
+
+struct pinctrl_group {
+	char *name;
+	int npins;
+	int *pinids;
+	int nfunctions;
+	int *functionids;
+};
+
+/**
+ * struct pinctrl_ops - pinctrl operations, to be implemented by drivers
+ * @request: called by the core to see if a certain pin can be made available
+ *	available for muxing. This is called by the core to acquire the pins
+ *	before selecting any actual mux setting across a function. The driver
+ *	is allowed to answer "no" by returning a negative error code
+ * @free: the reverse function of the request() callback, frees a pin after
+ *	being requested
+ * @enable: enable a certain muxing enumerator. The driver does not need to
+ *	figure out whether enabling this function conflicts some other use
+ *	of the pins, such collisions are handled by the pinctrl subsystem
+ * @disable: disable a certain muxing enumerator
+ * @config: custom configuration function for a certain muxing enumerator -
+ *	this works a bit like an ioctl() and can pass in and return arbitrary
+ *	configuration data to the pinctrl
+ * @dbg_show: optional debugfs display hook that will provide per-device
+ *	info for a certain pin in debugfs
+ */
+struct pinctrl_ops {
+	struct pinctrl_pin *(*get_pin) (struct pinctrl_dev *pctrldev, int id);
+	struct pinctrl_function *(*get_function) (struct pinctrl_dev *pctrldev,
+						  int id);
+	struct pinctrl_group *(*get_group) (struct pinctrl_dev *pctrldev,
+					    int id);
+
+	/*
+	 * request is still problematic; to perform any custom rules, the
+	 * driver must compare the requested assignment to the previously
+	 * requested, but not necessarily enabled, state. This means the
+	 * driver must:
+	 * a) Maintain a mirror of the requested state that the core is
+	 *    already managing.
+	 * b) Have some way to look into the state that the core is
+	 *    already managing. This could be implemented by storing (part
+	 *     of) that state in the driver-provided struct pinctrl_groups
+	 */
+	int (*request) (struct pinctrl_dev *pctrldev, int groupid,
+			int functionid);
+	int (*free) (struct pinctrl_dev *pctrldev, int groupid);
+
+	int (*enable) (struct pinctrl_dev *pctrldev, int groupid,
+		       int functionid);
+	void (*disable) (struct pinctrl_dev *pctrldev, int groupid);
+
+	int (*config_pin) (struct pinctrl_dev *pctrldev, int pinid, u16 param,
+			   unsigned long *data);
+	int (*config_group) (struct pinctrl_dev *pctrldev, int groupid,
+			     u16 param, unsigned long *data);
+
+	void (*dbg_show_pin) (struct pinctrl_dev *pctrldev, struct seq_file *s,
+			      int pinid);
+	void (*dbg_show_group) (struct pinctrl_dev *pctrldev,
+				struct seq_file *s, int groupid);
+};
+
+/**
+ * struct pinctrl_desc - pinctrl descriptor, register this to pinctrl subsystem
+ * @name: name for the pinctrl
+ * @ops: pinctrl operation table
+ * @owner: module providing the pinctrl, used for refcounting
+ * @base: the number of the first pin handled by this pinctrl, in the global
+ *	pin space, subtracted from a given pin to get the offset into the range
+ *	of a certain pinctrl
+ * @npins: the number of pins handled by this pinctrl - if your driver handles
+ *	8 pins that each can be muxed in 3 different ways, you reserve 8
+ *	pins in the global pin space and set this to 8
+ */
+struct pinctrl_desc {
+	const char *name;
+	struct pinctrl_ops *ops;
+	struct module *owner;
+	int base;
+	int npins;
+	int nfunctions;
+	int ngroups;
+};
+
+/**
+ * struct pinctrl_dev - pinctrl class device
+ * @desc: the descriptor supplied when initializing this pinctrl
+ * @node: node to include this pinctrl in the global pinctrl list
+ * @dev: the device entry for this pinctrl
+ * @owner: module providing the pinctrl, used for refcounting
+ * @driver_data: driver data for drivers registering to the subsystem
+ *
+ * This should be dereferenced and used by the pinctrl core ONLY
+ */
+struct pinctrl_dev {
+	const struct pinctrl_desc *desc;
+	struct list_head node;
+	struct device dev;
+	struct module *owner;
+	void *driver_data;
+};
+
+/* These should only be used from drives */
+static inline const char *pctrldev_get_name(struct pinctrl_dev *pctrldev)
+{
+	/* We're not allowed to register devices without name */
+	return pctrldev->desc->name;
+}
+
+static inline void *pctrldev_get_drvdata(struct pinctrl_dev *pctrldev)
+{
+	return pctrldev->driver_data;
+}
+
+extern struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pmxdesc,
+				struct device *dev, void *driver_data);
+extern void pinctrl_unregister(struct pinctrl_dev *pctrldev);
+
+#endif /* __LINUX_PINCTRL_PROVIDER_H */
-- 
1.7.0.4

