Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299Ab2CFWFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 17:05:35 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:44379 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755383Ab2CFWFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 17:05:34 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/4] pinctrl: introduce generic pin config
Date: Tue, 6 Mar 2012 23:05:09 +0100
Message-ID: <1331071509-24661-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This is a split-off from the earlier patch set which adds generic
pin configuration for the pin controllers that want it. Since
we may have a system with mixed generic and custom pin controllers,
we pass a boolean in the pin controller ops vtable to indicate
if it is generic.

ChangeLog v1->v5:
- Follow parent patch versioning number system.
- Document the semantic meaning of return values from pin config
  get functions, so we can iterate over pins and check their
  properties from debugfs as part of the generic config code.
- Use proper cast functions in the generic debugfs pin config
  file.
- Expand generic config to optionally cover groups too.
ChangeLog v5->v6:
- Update to match underlying changes.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/Kconfig                 |    4 +
 drivers/pinctrl/Makefile                |    1 +
 drivers/pinctrl/pinconf-generic.c       |  123 ++++++++++++++++++++++++++
 drivers/pinctrl/pinconf.c               |    6 +-
 drivers/pinctrl/pinconf.h               |   43 +++++++++-
 include/linux/pinctrl/pinconf-generic.h |  147 +++++++++++++++++++++++++++++++
 include/linux/pinctrl/pinconf.h         |    5 +
 7 files changed, 325 insertions(+), 4 deletions(-)
 create mode 100644 drivers/pinctrl/pinconf-generic.c
 create mode 100644 include/linux/pinctrl/pinconf-generic.h

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 3bea79f..ef197cc 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -17,6 +17,10 @@ config PINMUX
 config PINCONF
 	bool "Support pin configuration controllers"
 
+config GENERIC_PINCONF
+	bool
+	select PINCONF
+
 config DEBUG_PINCTRL
 	bool "Debug PINCTRL calls"
 	depends on DEBUG_KERNEL
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index c95d91e..5a46679 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -5,6 +5,7 @@ ccflags-$(CONFIG_DEBUG_PINCTRL)	+= -DDEBUG
 obj-$(CONFIG_PINCTRL)		+= core.o
 obj-$(CONFIG_PINMUX)		+= pinmux.o
 obj-$(CONFIG_PINCONF)		+= pinconf.o
+obj-$(CONFIG_GENERIC_PINCONF)	+= pinconf-generic.o
 obj-$(CONFIG_PINCTRL_PXA3xx)	+= pinctrl-pxa3xx.o
 obj-$(CONFIG_PINCTRL_MMP2)	+= pinctrl-mmp2.o
 obj-$(CONFIG_PINCTRL_PXA168)	+= pinctrl-pxa168.o
diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
new file mode 100644
index 0000000..594b820
--- /dev/null
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -0,0 +1,123 @@
+/*
+ * Core driver for the generic pin config portions of the pin control subsystem
+ *
+ * Copyright (C) 2011 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#define pr_fmt(fmt) "generic pinconfig core: " fmt
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinconf.h>
+#include <linux/pinctrl/pinconf-generic.h>
+#include "core.h"
+#include "pinconf.h"
+
+#ifdef CONFIG_DEBUG_FS
+
+struct pin_config_item {
+	const enum pin_config_param param;
+	const char * const display;
+	const char * const format;
+};
+
+#define PCONFDUMP(a, b, c) { .param = a, .display = b, .format = c }
+
+struct pin_config_item conf_items[] = {
+	PCONFDUMP(PIN_CONFIG_BIAS_DISABLE, "input bias disabled", NULL),
+	PCONFDUMP(PIN_CONFIG_BIAS_HIGH_IMPEDANCE, "input bias high impedance", NULL),
+	PCONFDUMP(PIN_CONFIG_BIAS_PULL_UP, "input bias pull up", "Ohm"),
+	PCONFDUMP(PIN_CONFIG_BIAS_PULL_DOWN, "input bias pull down", "Ohm"),
+	PCONFDUMP(PIN_CONFIG_BIAS_HIGH, "input bias high", NULL),
+	PCONFDUMP(PIN_CONFIG_BIAS_GROUND, "input bias ground", NULL),
+	PCONFDUMP(PIN_CONFIG_DRIVE_PUSH_PULL, "output drive push pull", "X stages"),
+	PCONFDUMP(PIN_CONFIG_DRIVE_OPEN_DRAIN, "output drive open drain", "X stages"),
+	PCONFDUMP(PIN_CONFIG_DRIVE_OPEN_SOURCE, "output drive open source", "X stages"),
+	PCONFDUMP(PIN_CONFIG_DRIVE_OFF, "output drive off", NULL),
+	PCONFDUMP(PIN_CONFIG_INPUT_SCHMITT, "input schmitt trigger", NULL),
+	PCONFDUMP(PIN_CONFIG_INPUT_DEBOUNCE, "input debounce", "time units"),
+	PCONFDUMP(PIN_CONFIG_SLEW_RATE_RISING, "output slew rate rising", "of max"),
+	PCONFDUMP(PIN_CONFIG_SLEW_RATE_FALLING, "output slew rate falling", "of max"),
+	PCONFDUMP(PIN_CONFIG_POWER_SOURCE, "pin power source", "selector"),
+	PCONFDUMP(PIN_CONFIG_LOW_POWER_MODE, "pin low power", "mode"),
+	PCONFDUMP(PIN_CONFIG_WAKEUP, "input wakeup", NULL),
+};
+
+void pinconf_generic_dump_pin(struct pinctrl_dev *pctldev,
+			      struct seq_file *s, unsigned pin)
+{
+	const struct pinconf_ops *ops = pctldev->desc->confops;
+	int i;
+
+	if (!ops->is_generic)
+		return;
+
+	for(i = 0; i < ARRAY_SIZE(conf_items); i++) {
+		unsigned long config;
+		int ret;
+
+		/* We want to check out this parameter */
+		config = to_config_packed(conf_items[i].param, 0);
+		ret = pin_config_get_for_pin(pctldev, pin, &config);
+		/* These are legal errors */
+		if (ret == -EINVAL || ret == -ENOTSUPP)
+			continue;
+		if (ret) {
+			seq_printf(s, "ERROR READING CONFIG SETTING %d ", i);
+			continue;
+		}
+		/* Space between multiple configs */
+		seq_puts(s, " ");
+		seq_puts(s, conf_items[i].display);
+		/* Print unit if available */
+		if (conf_items[i].format && to_config_argument(config) != 0)
+			seq_printf(s, " (%u %s)", to_config_argument(config),
+				   conf_items[i].format);
+	}
+}
+
+void pinconf_generic_dump_group(struct pinctrl_dev *pctldev,
+			      struct seq_file *s, const char *gname)
+{
+	const struct pinconf_ops *ops = pctldev->desc->confops;
+	int i;
+
+	if (!ops->is_generic)
+		return;
+
+	for(i = 0; i < ARRAY_SIZE(conf_items); i++) {
+		unsigned long config;
+		int ret;
+
+		/* We want to check out this parameter */
+		config = to_config_packed(conf_items[i].param, 0);
+		ret = pin_config_group_get(dev_name(pctldev->dev), gname,
+					   &config);
+		/* These are legal errors */
+		if (ret == -EINVAL || ret == -ENOTSUPP)
+			continue;
+		if (ret) {
+			seq_printf(s, "ERROR READING CONFIG SETTING %d ", i);
+			continue;
+		}
+		/* Space between multiple configs */
+		seq_puts(s, " ");
+		seq_puts(s, conf_items[i].display);
+		/* Print unit if available */
+		if (conf_items[i].format && config != 0)
+			seq_printf(s, " (%u %s)", to_config_argument(config),
+				   conf_items[i].format);
+	}
+}
+
+#endif
diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index 84869f2..247b9f2 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -54,7 +54,7 @@ int pinconf_validate_map(struct pinctrl_map const *map, int i)
 	return 0;
 }
 
-static int pin_config_get_for_pin(struct pinctrl_dev *pctldev, unsigned pin,
+int pin_config_get_for_pin(struct pinctrl_dev *pctldev, unsigned pin,
 			   unsigned long *config)
 {
 	const struct pinconf_ops *ops = pctldev->desc->confops;
@@ -432,6 +432,8 @@ static void pinconf_dump_pin(struct pinctrl_dev *pctldev,
 {
 	const struct pinconf_ops *ops = pctldev->desc->confops;
 
+	/* no-op when not using generic pin config */
+	pinconf_generic_dump_pin(pctldev, s, pin);
 	if (ops && ops->pin_config_dbg_show)
 		ops->pin_config_dbg_show(pctldev, s, pin);
 }
@@ -475,6 +477,8 @@ static void pinconf_dump_group(struct pinctrl_dev *pctldev,
 {
 	const struct pinconf_ops *ops = pctldev->desc->confops;
 
+	/* no-op when not using generic pin config */
+	pinconf_generic_dump_group(pctldev, s, gname);
 	if (ops && ops->pin_config_group_dbg_show)
 		ops->pin_config_group_dbg_show(pctldev, s, selector);
 }
diff --git a/drivers/pinctrl/pinconf.h b/drivers/pinctrl/pinconf.h
index 0ded227..54510de 100644
--- a/drivers/pinctrl/pinconf.h
+++ b/drivers/pinctrl/pinconf.h
@@ -14,20 +14,26 @@
 #ifdef CONFIG_PINCONF
 
 int pinconf_check_ops(struct pinctrl_dev *pctldev);
-
 int pinconf_validate_map(struct pinctrl_map const *map, int i);
-
 int pinconf_map_to_setting(struct pinctrl_map const *map,
 			  struct pinctrl_setting *setting);
 void pinconf_free_setting(struct pinctrl_setting const *setting);
 int pinconf_apply_setting(struct pinctrl_setting const *setting);
-
 void pinconf_show_map(struct seq_file *s, struct pinctrl_map const *map);
 void pinconf_show_setting(struct seq_file *s,
 			  struct pinctrl_setting const *setting);
 void pinconf_init_device_debugfs(struct dentry *devroot,
 				 struct pinctrl_dev *pctldev);
 
+/*
+ * You will only be interested in these if you're using PINCONF
+ * so don't supply any stubs for these.
+ */
+int pin_config_get_for_pin(struct pinctrl_dev *pctldev, unsigned pin,
+			   unsigned long *config);
+int pin_config_group_get(const char *dev_name, const char *pin_group,
+			 unsigned long *config);
+
 #else
 
 static inline int pinconf_check_ops(struct pinctrl_dev *pctldev)
@@ -71,3 +77,34 @@ static inline void pinconf_init_device_debugfs(struct dentry *devroot,
 }
 
 #endif
+
+/*
+ * The following functions are available if the driver uses the generic
+ * pin config.
+ */
+
+#ifdef CONFIG_GENERIC_PINCONF
+
+void pinconf_generic_dump_pin(struct pinctrl_dev *pctldev,
+			      struct seq_file *s, unsigned pin);
+
+void pinconf_generic_dump_group(struct pinctrl_dev *pctldev,
+			      struct seq_file *s, const char *gname);
+
+#else
+
+static inline void pinconf_generic_dump_pin(struct pinctrl_dev *pctldev,
+					    struct seq_file *s,
+					    unsigned pin)
+{
+	return;
+}
+
+static inline void pinconf_generic_dump_group(struct pinctrl_dev *pctldev,
+					      struct seq_file *s,
+					      const char *gname)
+{
+	return;
+}
+
+#endif
diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
new file mode 100644
index 0000000..a47613b
--- /dev/null
+++ b/include/linux/pinctrl/pinconf-generic.h
@@ -0,0 +1,147 @@
+/*
+ * Interface the generic pinconfig portions of the pinctrl subsystem
+ *
+ * Copyright (C) 2011 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ * This interface is used in the core to keep track of pins.
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+#ifndef __LINUX_PINCTRL_PINCONF_GENERIC_H
+#define __LINUX_PINCTRL_PINCONF_GENERIC_H
+
+/*
+ * You shouldn't even be able to compile with these enums etc unless you're
+ * using generic pin config. That is why this is defined out.
+ */
+#ifdef CONFIG_GENERIC_PINCONF
+
+/**
+ * enum pin_config_param - possible pin configuration parameters
+ * @PIN_CONFIG_BIAS_DISABLE: disable any pin bias on the pin, a
+ *	transition from say pull-up to pull-down implies that you disable
+ *	pull-up in the process, this setting disables all biasing.
+ * @PIN_CONFIG_BIAS_HIGH_IMPEDANCE: the pin will be set to a high impedance
+ *	mode, also know as "third-state" (tristate) or "high-Z" or "floating".
+ *	On output pins this effectively disconnects the pin, which is useful
+ *	if for example some other pin is going to drive the signal connected
+ *	to it for a while. Pins used for input are usually always high
+ *	impedance.
+ * @PIN_CONFIG_BIAS_PULL_UP: the pin will be pulled up (usually with high
+ *	impedance to VDD), if the controller supports specifying a certain
+ *	pull-up resistance, this is given as an argument (in Ohms) when
+ *	setting this parameter.
+ * @PIN_CONFIG_BIAS_PULL_DOWN: the pin will be pulled down (usually with high
+ *	impedance to GROUND), if the controller supports specifying a certain
+ *	pull-down resistance, this is given as an argument (in Ohms) when
+ *	setting this parameter.
+ * @PIN_CONFIG_BIAS_HIGH: the pin will be wired high, connected to VDD
+ * @PIN_CONFIG_BIAS_GROUND: the pin will be grounded, connected to GROUND
+ * @PIN_CONFIG_DRIVE_PUSH_PULL: the pin will be driven actively high and
+ *	low, this is the most typical case and is typically achieved with two
+ *	active transistors on the output. If the pin can support different
+ *	drive strengths for push/pull, the strength is given in the argument
+ *	as the number of driving stages vs nominal load impedance, so say
+ *	quadruple driving stages (usually 8 transistors rather than two) will
+ *	be configured with the 8 passed as argument.
+ * @PIN_CONFIG_DRIVE_OPEN_DRAIN: the pin will be driven with open drain (open
+ *	collector) which means it is usually wired with other output ports
+ *	which are then pulled up with an external resistor. If the pin can
+ *	support different drive strengths for the open drain pin, the format
+ *	is the same as for PIN_CONFIG_DRIVE_PUSH_PULL.
+ * @PIN_CONFIG_DRIVE_OPEN_SOURCE: the pin will be driven with open drain
+ *	(open emitter) which is the same as open drain but pulled to ground.
+ *	If the pin can support different drive strengths for the open drain
+ *	pin, the format is the same as for PIN_CONFIG_DRIVE_PUSH_PULL.
+ * @PIN_CONFIG_DRIVE_OFF: the pin is set to inactive drive mode, off.
+ * @PIN_CONFIG_INPUT_SCHMITT: this will configure an input pin to run in
+ *	schmitt-trigger mode. If the schmitt-trigger has adjustable hysteresis,
+ *	the threshold value is given on a custom format as argument when
+ *	setting pins to this mode. The argument zero turns the schmitt trigger
+ *	off.
+ * @PIN_CONFIG_INPUT_DEBOUNCE: this will configure the pin to debounce mode,
+ *	which means it will wait for signals to settle when reading inputs. The
+ *	argument gives the debounce time on a custom format. Setting the
+ *	argument to zero turns debouncing off.
+ * @PIN_CONFIG_SLEW_RATE_RISING: this will configure the slew rate for rising
+ *	signals on the pin. The argument gives the rise time in fractions
+ *	compared to maximum rise time, 0 means nominal rise time. If you can
+ *	control slew rate in 4 steps these will likely be equidistant like
+ *	1/4, 1/2, 3/4 or full nominal slew rate, which means argument 4 gives
+ *	you 1/4 of nominal slew rate and the argument 4 has the same meaning
+ *	as 0 - nominal slew rate (fastest possible, steep edges). You may want
+ *	to adjust slew rates so that signal edges don't get too steep, causing
+ *	disturbances in surrounding electronics known as electromagnetic
+ *	interference (EMI) for example.
+ * @PIN_CONFIG_SLEW_RATE_FALLING: this will configure the slew rate for falling
+ *	signals on the pin. The argument gives the fall time in fractions
+ *	compared to nominal fall time.
+ * @PIN_CONFIG_POWER_SOURCE: if the pin can select between different power
+ *	supplies, the argument to this parameter (on a custom format) tells
+ *	the driver which alternative power source to use.
+ * @PIN_CONFIG_LOW_POWER_MODE: this will configure the pin for low power
+ *	operation, if several modes of operation are supported these can be
+ *	passed in the argument on a custom form, else just use argument 1
+ *	to indicate low power mode, argument 0 turns low power mode off.
+ * @PIN_CONFIG_WAKEUP: this will configure an input pin such that if a
+ *	signal transition arrives at the pin when the pin controller/system
+ *	is sleeping, it will wake up the system if argument 1 is passed along.
+ *	Pass argument 0 to turn wakeup enablement off.
+ * @PIN_CONFIG_END: this is the last enumerator for pin configurations, if
+ *	you need to pass in custom configurations to the pin controller, use
+ *	PIN_CONFIG_END+1 as the base offset.
+ */
+enum pin_config_param {
+	PIN_CONFIG_BIAS_DISABLE,
+	PIN_CONFIG_BIAS_HIGH_IMPEDANCE,
+	PIN_CONFIG_BIAS_PULL_UP,
+	PIN_CONFIG_BIAS_PULL_DOWN,
+	PIN_CONFIG_BIAS_HIGH,
+	PIN_CONFIG_BIAS_GROUND,
+	PIN_CONFIG_DRIVE_PUSH_PULL,
+	PIN_CONFIG_DRIVE_OPEN_DRAIN,
+	PIN_CONFIG_DRIVE_OPEN_SOURCE,
+	PIN_CONFIG_DRIVE_OFF,
+	PIN_CONFIG_INPUT_SCHMITT,
+	PIN_CONFIG_INPUT_DEBOUNCE,
+	PIN_CONFIG_SLEW_RATE_RISING,
+	PIN_CONFIG_SLEW_RATE_FALLING,
+	PIN_CONFIG_POWER_SOURCE,
+	PIN_CONFIG_LOW_POWER_MODE,
+	PIN_CONFIG_WAKEUP,
+	PIN_CONFIG_END,
+};
+
+/*
+ * The following inlines stuffs a configuration parameter and data value
+ * into and out of an unsigned long argument, as used by the generic pin config
+ * system. We put the parameter in the lower 16 bits and the argument in the
+ * upper 16 bits.
+ */
+
+static inline enum pin_config_param to_config_param(unsigned long config)
+{
+	return (enum pin_config_param) (config & 0xffffUL);
+}
+
+static inline u16 to_config_argument(unsigned long config)
+{
+	return (enum pin_config_param) ((config >> 16) & 0xffffUL);
+}
+
+static inline unsigned long to_config_packed(enum pin_config_param param,
+					     u16 argument)
+{
+	return (argument << 16) | ((unsigned long) param & 0xffffUL);
+}
+
+/*
+ * Helpful configuration macro to be used in tables etc.
+ */
+#define PIN_CONF_PACKED(p, a) ((a << 16) | ((unsigned long) p & 0xffffUL))
+
+#endif /* CONFIG_GENERIC_PINCONF */
+
+#endif /* __LINUX_PINCTRL_PINCONF_GENERIC_H */
diff --git a/include/linux/pinctrl/pinconf.h b/include/linux/pinctrl/pinconf.h
index f8cf156..ec431f0 100644
--- a/include/linux/pinctrl/pinconf.h
+++ b/include/linux/pinctrl/pinconf.h
@@ -20,6 +20,8 @@ struct seq_file;
 /**
  * struct pinconf_ops - pin config operations, to be implemented by
  * pin configuration capable drivers.
+ * @is_generic: for pin controllers that want to use the generic interface,
+ *	this flag tells the framework that it's generic.
  * @pin_config_get: get the config of a certain pin, if the requested config
  *	is not available on this controller this should return -ENOTSUPP
  *	and if it is available but disabled it should return -EINVAL
@@ -33,6 +35,9 @@ struct seq_file;
  *	per-device info for a certain group in debugfs
  */
 struct pinconf_ops {
+#ifdef CONFIG_GENERIC_PINCONF
+	bool is_generic;
+#endif
 	int (*pin_config_get) (struct pinctrl_dev *pctldev,
 			       unsigned pin,
 			       unsigned long *config);
-- 
1.7.8

