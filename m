Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab1LIL5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 06:57:55 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:45880 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751837Ab1LIL5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 06:57:54 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v6] pinctrl: add a pin config interface
Date: Fri, 9 Dec 2011 12:57:37 +0100
Message-ID: <1323431857-8828-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This add per-pin and per-group pin config interfaces for biasing,
driving and other such electronic properties. The details of passed
configurations are passed in an opaque unsigned long which may be
dereferences to integer types, structs or lists on either side
of the configuration interface.

ChangeLog v1->v2:
- Clear split of terminology: we now have pin controllers, and
  those may support two interfaces using vtables: pin
  multiplexing and pin configuration.
- Break out pin configuration to its own C file, controllers may
  implement only config without mux, and vice versa, so keep each
  sub-functionality of pin controllers separate. Introduce
  CONFIG_PINCONF in Kconfig.
- Implement some core logic around pin configuration in the
  pinconf.c file.
- Remove UNKNOWN config states, these were just surplus baggage.
- Remove FLOAT config state - HIGH_IMPEDANCE should be enough for
  everyone.
- PIN_CONFIG_POWER_SOURCE added to handle switching the power
  supply for the pin logic between different sources
- Explicit DISABLE config enums to turn schmitt-trigger,
  wakeup etc OFF.
- Update documentation to reflect all the recent reasoning.
ChangeLog v2->v3:
- Twist API around to pass around arrays of config tuples instead
  of (param, value) pairs everywhere.
- Explicit drive strength semantics for push/pull and similar
  drive modes, this shall be the number of drive stages vs
  nominal load impedance, which should match the actual
  electronics used in push/pull CMOS or TTY totempoles.
- Drop load capacitance configuration - I probably don't know
  what I'm doing here so leave it out.
- Drop PIN_CONFIG_INPUT_SCHMITT_OFF, instead the argument zero to
  PIN_CONFIG_INPUT_SCHMITT turns schmitt trigger off.
- Drop PIN_CONFIG_NORMAL_POWER_MODE and have a well defined
  argument to PIN_CONFIG_LOW_POWER_MODE to get out of it instead.
- Drop PIN_CONFIG_WAKEUP_ENABLE/DISABLE and just use
  PIN_CONFIG_WAKEUP with defined value zero to turn wakeup off.
- Add PIN_CONFIG_INPUT_DEBOUNCE for configuring debounce time
  on input lines.
- Fix a bug when we tried to configure pins for pin controllers
  without pinconf support.
- Initialized debugfs properly so it works.
- Initialize the mutex properly and lock around config tampering
  sections.
- Check the return value from get_initial_config() properly.
ChangeLog v3->v4:
- Export the pin_config_get(), pin_config_set() and
  pin_config_group() functions.
- Drop the entire concept of just getting initial config and
  keeping track of pin states internally, instead ask the pins
  what state they are in. Previous idea was plain wrong, if the
  device cannot keep track of its state, the driver should do
  it.
- Drop the generic configuration layout, it seems this impose
  too much restriction on some pin controllers, so let them do
  things the way they want and split off support for generic
  config as an optional add-on.
ChangeLog v4->v5:
- Introduce two symmetric driver calls for group configuration,
  .pin_config_group_[get|set] and corresponding external calls.
- Remove generic semantic meanings of return values from config
  calls, these belong in the generic config patch. Just pass the
  return value through instead.
- Add a debugfs entry "pinconf-groups" to read status from group
  configuration only, also slam in a per-group debug callback in
  the pinconf_ops so custom drivers can display something
  meaningful for their pins.
- Fix some dangling newline.
- Drop dangling #else clause.
- Update documentation to match the above.
ChangeLog v5->v6:
- Change to using a pin name as parameter for the
  [get|set]_config() functions, as suggested by Stephen Warren.
  This is more natural as names will be what a developer has
  access to in written documentation etc.

Acked-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/pinctrl.txt       |   96 ++++++++++++-
 drivers/pinctrl/Kconfig         |    5 +-
 drivers/pinctrl/Makefile        |    1 +
 drivers/pinctrl/core.c          |   37 +++++
 drivers/pinctrl/core.h          |    5 +
 drivers/pinctrl/pinconf.c       |  288 +++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinconf.h       |   32 +++++
 include/linux/pinctrl/pinconf.h |   96 +++++++++++++
 include/linux/pinctrl/pinctrl.h |   10 +-
 9 files changed, 559 insertions(+), 11 deletions(-)
 create mode 100644 drivers/pinctrl/pinconf.c
 create mode 100644 drivers/pinctrl/pinconf.h
 create mode 100644 include/linux/pinctrl/pinconf.h

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index c8fd136..6d23fa8 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -7,12 +7,9 @@ This subsystem deals with:
 
 - Multiplexing of pins, pads, fingers (etc) see below for details
 
-The intention is to also deal with:
-
-- Software-controlled biasing and driving mode specific pins, such as
-  pull-up/down, open drain etc, load capacitance configuration when controlled
-  by software, etc.
-
+- Configuration of pins, pads, fingers (etc), such as software-controlled
+  biasing and driving mode specific pins, such as pull-up/down, open drain,
+  load capacitance etc.
 
 Top-level interface
 ===================
@@ -88,6 +85,11 @@ int __init foo_probe(void)
 		pr_err("could not register foo pin driver\n");
 }
 
+To enable the pinctrl subsystem and the subgroups for PINMUX and PINCONF and
+selected drivers, you need to select them from your machine's Kconfig entry,
+since these are so tightly integrated with the machines they are used on.
+See for example arch/arm/mach-u300/Kconfig for an example.
+
 Pins usually have fancier names than this. You can find these in the dataheet
 for your chip. Notice that the core pinctrl.h file provides a fancy macro
 called PINCTRL_PIN() to create the struct entries. As you can see I enumerated
@@ -193,6 +195,88 @@ structure, for example specific register ranges associated with each group
 and so on.
 
 
+Pin configuration
+=================
+
+Pins can sometimes be software-configured in an various ways, mostly related
+to their electronic properties when used as inputs or outputs. For example you
+may be able to make an output pin high impedance, or "tristate" meaning it is
+effectively disconnected. You may be able to connect an input pin to VDD or GND
+using a certain resistor value - pull up and pull down - so that the pin has a
+stable value when nothing is driving the rail it is connected to, or when it's
+unconnected.
+
+For example, a platform may do this:
+
+ret = pin_config_set(dev, "FOO_GPIO_PIN", PLATFORM_X_PULL_UP);
+
+To pull up a pin to VDD. The pin configuration driver implements callbacks for
+changing pin configuration in the pin controller ops like this:
+
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinconf.h>
+#include "platform_x_pindefs.h"
+
+int foo_pin_config_get(struct pinctrl_dev *pctldev,
+		    unsigned offset,
+		    unsigned long *config)
+{
+	struct my_conftype conf;
+
+	... Find setting for pin @ offset ...
+
+	*config = (unsigned long) conf;
+}
+
+int foo_pin_config_set(struct pinctrl_dev *pctldev,
+		    unsigned offset,
+		    unsigned long config)
+{
+	struct my_conftype *conf = (struct my_conftype *) config;
+
+	switch (conf) {
+		case PLATFORM_X_PULL_UP:
+		...
+		}
+	}
+}
+
+int foo_pin_config_group_get (struct pinctrl_dev *pctldev,
+		    unsigned selector,
+		    unsigned long *config)
+{
+	...
+}
+
+int foo_pin_config_group_set (struct pinctrl_dev *pctldev,
+		    unsigned selector,
+		    unsigned long config)
+{
+	...
+}
+
+static struct pinconf_ops foo_pconf_ops = {
+	.pin_config_get = foo_pin_config_get,
+	.pin_config_set = foo_pin_config_set,
+	.pin_config_group_get = foo_pin_config_group_get,
+	.pin_config_group_set = foo_pin_config_group_set,
+};
+
+/* Pin config operations are handled by some pin controller */
+static struct pinctrl_desc foo_desc = {
+	...
+	.confops = &foo_pconf_ops,
+};
+
+Since some controllers have special logic for handling entire groups of pins
+they can exploit the special whole-group pin control function. The
+pin_config_group_set() callback is allowed to return the error code -EAGAIN,
+for groups it does not want to handle, or if it just wants to do some
+group-level handling and then fall through to iterate over all pins, in which
+case each individual pin will be treated by separate pin_config_set() calls as
+well.
+
+
 Interaction with the GPIO subsystem
 ===================================
 
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index e963da4..c63c721 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -12,7 +12,10 @@ menu "Pin controllers"
 	depends on PINCTRL
 
 config PINMUX
-	bool "Support pinmux controllers"
+	bool "Support pin multiplexing controllers"
+
+config PINCONF
+	bool "Support pin configuration controllers"
 
 config DEBUG_PINCTRL
 	bool "Debug PINCTRL calls"
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 5f3e4d6..c046f78 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -4,6 +4,7 @@ ccflags-$(CONFIG_DEBUG_PINCTRL)	+= -DDEBUG
 
 obj-$(CONFIG_PINCTRL)		+= core.o
 obj-$(CONFIG_PINMUX)		+= pinmux.o
+obj-$(CONFIG_PINCONF)		+= pinconf.o
 obj-$(CONFIG_PINMUX_SIRF)	+= pinmux-sirf.o
 obj-$(CONFIG_PINMUX_U300)	+= pinmux-u300.o
 obj-$(CONFIG_PINCTRL_COH901)	+= pinctrl-coh901.o
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 4955a68..e368583 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -28,6 +28,7 @@
 #include <linux/pinctrl/machine.h>
 #include "core.h"
 #include "pinmux.h"
+#include "pinconf.h"
 
 /* Global list of pin control devices */
 static DEFINE_MUTEX(pinctrldev_list_mutex);
@@ -101,6 +102,30 @@ struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev, unsigned int pin)
 }
 
 /**
+ * pin_get_from_name() - look up a pin number from a name
+ * @pctldev: the pin control device to lookup the pin on
+ * @name: the name of the pin to look up
+ */
+int pin_get_from_name(struct pinctrl_dev *pctldev, const char *name)
+{
+	unsigned pin;
+
+	/* The highest pin number need to be included in the loop, thus <= */
+	for (pin = 0; pin <= pctldev->desc->maxpin; pin++) {
+		struct pin_desc *desc;
+
+		desc = pin_desc_get(pctldev, pin);
+		/* Pin space may be sparse */
+		if (desc == NULL)
+			continue;
+		if (desc->name && !strcmp(name, desc->name))
+			return pin;
+	}
+
+	return -EINVAL;
+}
+
+/**
  * pin_is_valid() - check if pin exists on controller
  * @pctldev: the pin control device to check the pin on
  * @pin: pin to check, use the local pin controller index number
@@ -160,6 +185,7 @@ static int pinctrl_register_one_pin(struct pinctrl_dev *pctldev,
 	pindesc = kzalloc(sizeof(*pindesc), GFP_KERNEL);
 	if (pindesc == NULL)
 		return -ENOMEM;
+
 	spin_lock_init(&pindesc->lock);
 
 	/* Set owner */
@@ -492,6 +518,7 @@ static void pinctrl_init_device_debugfs(struct pinctrl_dev *pctldev)
 	debugfs_create_file("gpio-ranges", S_IFREG | S_IRUGO,
 			    device_root, pctldev, &pinctrl_gpioranges_ops);
 	pinmux_init_device_debugfs(device_root, pctldev);
+	pinconf_init_device_debugfs(device_root, pctldev);
 }
 
 static void pinctrl_init_debugfs(void)
@@ -548,6 +575,16 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 		}
 	}
 
+	/* If we're implementing pinconfig, check the ops for sanity */
+	if (pctldesc->confops) {
+		ret = pinconf_check_ops(pctldesc->confops);
+		if (ret) {
+			pr_err("%s pin config ops lacks necessary functions\n",
+			       pctldesc->name);
+			return NULL;
+		}
+	}
+
 	pctldev = kzalloc(sizeof(struct pinctrl_dev), GFP_KERNEL);
 	if (pctldev == NULL)
 		return NULL;
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 74dee43..3f5b911 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -9,6 +9,10 @@
  * License terms: GNU General Public License (GPL) version 2
  */
 
+#include <linux/pinctrl/pinconf.h>
+
+struct pinctrl_gpio_range;
+
 /**
  * struct pinctrl_dev - pin control class device
  * @node: node to include this pin controller in the global pin controller list
@@ -66,6 +70,7 @@ struct pin_desc {
 struct pinctrl_dev *get_pinctrl_dev_from_dev(struct device *dev,
 					     const char *dev_name);
 struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev, unsigned int pin);
+int pin_get_from_name(struct pinctrl_dev *pctldev, const char *name);
 int pinctrl_get_device_gpio_range(unsigned gpio,
 				  struct pinctrl_dev **outdev,
 				  struct pinctrl_gpio_range **outrange);
diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
new file mode 100644
index 0000000..b55de71
--- /dev/null
+++ b/drivers/pinctrl/pinconf.c
@@ -0,0 +1,288 @@
+/*
+ * Core driver for the pin config portions of the pin control subsystem
+ *
+ * Copyright (C) 2011 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+#define pr_fmt(fmt) "pinconfig core: " fmt
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/pinctrl/machine.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinconf.h>
+#include "core.h"
+#include "pinconf.h"
+
+/**
+ * pin_config_get() - get the configuration of a single pin parameter
+ * @pctldev: pin controller device for this pin
+ * @name: name of the pin to get the config for
+ * @config: the config pointed to by this argument will be filled in with the
+ *	current pin state, it can be used directly by drivers as a numeral, or
+ *	it can be dereferenced to any struct.
+ */
+int pin_config_get(struct pinctrl_dev *pctldev, const char *name,
+			  unsigned long *config)
+{
+	const struct pinconf_ops *ops = pctldev->desc->confops;
+	int pin;
+
+	pin = pin_get_from_name(pctldev, name);
+	if (pin < 0)
+		return pin;
+
+	if (!ops || !ops->pin_config_get) {
+		dev_err(&pctldev->dev, "cannot get pin configuration, missing "
+			"pin_config_get() function in driver\n");
+		return -EINVAL;
+	}
+
+	return ops->pin_config_get(pctldev, pin, config);
+}
+EXPORT_SYMBOL(pin_config_get);
+
+/**
+ * pin_config_set() - set the configuration of a single pin parameter
+ * @pctldev: pin controller device for this pin
+ * @name: name of the pin to set the config for
+ * @config: the config in this argument will contain the desired pin state, it
+ *	can be used directly by drivers as a numeral, or it can be dereferenced
+ *	to any struct.
+ */
+int pin_config_set(struct pinctrl_dev *pctldev, const char *name,
+		   unsigned long config)
+{
+	const struct pinconf_ops *ops = pctldev->desc->confops;
+	int pin;
+	int ret;
+
+	pin = pin_get_from_name(pctldev, name);
+	if (pin < 0)
+		return pin;
+
+	if (!ops || !ops->pin_config_set) {
+		dev_err(&pctldev->dev, "cannot configure pin, missing "
+			"config function in driver\n");
+		return -EINVAL;
+	}
+
+	ret = ops->pin_config_set(pctldev, pin, config);
+	if (ret) {
+		dev_err(&pctldev->dev,
+			"unable to set pin configuration on pin %d\n", pin);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(pin_config_set);
+
+int pin_config_group_get(struct pinctrl_dev *pctldev, const char *pin_group,
+			 unsigned long *config)
+{
+	const struct pinconf_ops *ops = pctldev->desc->confops;
+	int selector;
+
+	if (!ops || !ops->pin_config_group_get) {
+		dev_err(&pctldev->dev, "cannot get configuration for pin "
+			"group, missing group config get function in "
+			"driver\n");
+		return -EINVAL;
+	}
+
+	selector = pinctrl_get_group_selector(pctldev, pin_group);
+	if (selector < 0)
+		return selector;
+
+	return ops->pin_config_group_get(pctldev, selector, config);
+}
+EXPORT_SYMBOL(pin_config_group_get);
+
+
+int pin_config_group_set(struct pinctrl_dev *pctldev, const char *pin_group,
+			 unsigned long config)
+{
+	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
+	const struct pinconf_ops *ops = pctldev->desc->confops;
+	int selector;
+	const unsigned *pins;
+	unsigned num_pins;
+	int ret;
+	int i;
+
+	if (!ops || (!ops->pin_config_group_set && !ops->pin_config_set)) {
+		dev_err(&pctldev->dev, "cannot configure pin group, missing "
+			"config function in driver\n");
+		return -EINVAL;
+	}
+
+	selector = pinctrl_get_group_selector(pctldev, pin_group);
+	if (selector < 0)
+		return selector;
+
+	ret = pctlops->get_group_pins(pctldev, selector, &pins, &num_pins);
+	if (ret) {
+		dev_err(&pctldev->dev, "cannot configure pin group, error "
+			"getting pins\n");
+		return ret;
+	}
+
+	/*
+	 * If the pin controller supports handling entire groups we use that
+	 * capability.
+	 */
+	if (ops->pin_config_group_set) {
+		ret = ops->pin_config_group_set(pctldev, selector, config);
+		/*
+		 * If the pin controller prefer that a certain group be handled
+		 * pin-by-pin as well, it returns -EAGAIN.
+		 */
+		if (ret != -EAGAIN)
+			return ret;
+	}
+
+	/*
+	 * If the controller cannot handle entire groups, we configure each pin
+	 * individually.
+	 */
+	if (!ops->pin_config_set)
+		return 0;
+
+	for (i = 0; i < num_pins; i++) {
+		ret = ops->pin_config_set(pctldev, pins[i], config);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(pin_config_group_set);
+
+int pinconf_check_ops(const struct pinconf_ops *ops)
+{
+	/* We must be able to read out pin status */
+	if (!ops->pin_config_get && !ops->pin_config_group_get)
+		return -EINVAL;
+	/* We have to be able to config the pins in SOME way */
+	if (!ops->pin_config_set && !ops->pin_config_group_set)
+		return -EINVAL;
+	return 0;
+}
+
+#ifdef CONFIG_DEBUG_FS
+
+static void pinconf_dump_pin(struct pinctrl_dev *pctldev,
+			     struct seq_file *s, int pin)
+{
+	const struct pinconf_ops *ops = pctldev->desc->confops;
+
+	if (ops && ops->pin_config_dbg_show)
+		ops->pin_config_dbg_show(pctldev, s, pin);
+}
+
+static int pinconf_pins_show(struct seq_file *s, void *what)
+{
+	struct pinctrl_dev *pctldev = s->private;
+	unsigned pin;
+
+	seq_puts(s, "Pin config settings per pin\n");
+	seq_puts(s, "Format: pin (name): pinmux setting array\n");
+
+	/* The highest pin number need to be included in the loop, thus <= */
+	for (pin = 0; pin <= pctldev->desc->maxpin; pin++) {
+		struct pin_desc *desc;
+
+		desc = pin_desc_get(pctldev, pin);
+		/* Pin space may be sparse */
+		if (desc == NULL)
+			continue;
+
+		seq_printf(s, "pin %d (%s):", pin,
+			   desc->name ? desc->name : "unnamed");
+
+		pinconf_dump_pin(pctldev, s, pin);
+
+		seq_printf(s, "\n");
+	}
+
+	return 0;
+}
+
+static void pinconf_dump_group(struct pinctrl_dev *pctldev,
+			       struct seq_file *s, unsigned selector,
+			       const char *gname)
+{
+	const struct pinconf_ops *ops = pctldev->desc->confops;
+
+	if (ops && ops->pin_config_group_dbg_show)
+		ops->pin_config_group_dbg_show(pctldev, s, selector);
+}
+
+static int pinconf_groups_show(struct seq_file *s, void *what)
+{
+	struct pinctrl_dev *pctldev = s->private;
+	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
+	const struct pinconf_ops *ops = pctldev->desc->confops;
+	unsigned selector = 0;
+
+	if (!ops || !ops->pin_config_group_get)
+		return 0;
+
+	seq_puts(s, "Pin config settings per pin group\n");
+	seq_puts(s, "Format: group (name): pinmux setting array\n");
+
+	while (pctlops->list_groups(pctldev, selector) >= 0) {
+		const char *gname = pctlops->get_group_name(pctldev, selector);
+
+		seq_printf(s, "%u (%s):", selector, gname);
+		pinconf_dump_group(pctldev, s, selector, gname);
+		selector++;
+	}
+
+	return 0;
+}
+
+static int pinconf_pins_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pinconf_pins_show, inode->i_private);
+}
+
+static int pinconf_groups_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pinconf_groups_show, inode->i_private);
+}
+
+static const struct file_operations pinconf_pins_ops = {
+	.open		= pinconf_pins_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct file_operations pinconf_groups_ops = {
+	.open		= pinconf_groups_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+void pinconf_init_device_debugfs(struct dentry *devroot,
+			 struct pinctrl_dev *pctldev)
+{
+	debugfs_create_file("pinconf-pins", S_IFREG | S_IRUGO,
+			    devroot, pctldev, &pinconf_groups_ops);
+	debugfs_create_file("pinconf-groups", S_IFREG | S_IRUGO,
+			    devroot, pctldev, &pinconf_groups_ops);
+}
+
+#endif
diff --git a/drivers/pinctrl/pinconf.h b/drivers/pinctrl/pinconf.h
new file mode 100644
index 0000000..eb1657a
--- /dev/null
+++ b/drivers/pinctrl/pinconf.h
@@ -0,0 +1,32 @@
+/*
+ * Internal interface between the core pin control system and the
+ * pin config portions
+ *
+ * Copyright (C) 2011 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ * Based on bits of regulator core, gpio core and clk core
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#ifdef CONFIG_PINCONF
+
+int pinconf_check_ops(const struct pinconf_ops *ops);
+void pinconf_init_device_debugfs(struct dentry *devroot,
+				 struct pinctrl_dev *pctldev);
+
+#else
+
+static inline int pinconf_check_ops(const struct pinconf_ops *ops)
+{
+	return 0;
+}
+
+static inline void pinconf_init_device_debugfs(struct dentry *devroot,
+					       struct pinctrl_dev *pctldev)
+{
+}
+
+#endif
diff --git a/include/linux/pinctrl/pinconf.h b/include/linux/pinctrl/pinconf.h
new file mode 100644
index 0000000..d5b72e6
--- /dev/null
+++ b/include/linux/pinctrl/pinconf.h
@@ -0,0 +1,96 @@
+/*
+ * Interface the pinconfig portions of the pinctrl subsystem
+ *
+ * Copyright (C) 2011 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ * This interface is used in the core to keep track of pins.
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+#ifndef __LINUX_PINCTRL_PINCONF_H
+#define __LINUX_PINCTRL_PINCONF_H
+
+#ifdef CONFIG_PINCONF
+
+struct pinctrl_dev;
+
+/**
+ * struct pinconf_ops - pin config operations, to be implemented by
+ * pin configuration capable drivers.
+ * @pin_config_get: get the config of a certain pin, if the requested config
+ *	is not available on this controller this should return -ENOTSUPP
+ *	and if it is available but disabled it should return -EINVAL
+ * @pin_config_get: get the config of a certain pin
+ * @pin_config_set: configure an individual pin
+ * @pin_config_group_get: get configurations for an entire pin group
+ * @pin_config_group_set: configure all pins in a group
+ * @pin_config_dbg_show: optional debugfs display hook that will provide
+ *	per-device info for a certain pin in debugfs
+ * @pin_config_group_dbg_show: optional debugfs display hook that will provide
+ *	per-device info for a certain group in debugfs
+ */
+struct pinconf_ops {
+	int (*pin_config_get) (struct pinctrl_dev *pctldev,
+			       unsigned pin,
+			       unsigned long *config);
+	int (*pin_config_set) (struct pinctrl_dev *pctldev,
+			       unsigned pin,
+			       unsigned long config);
+	int (*pin_config_group_get) (struct pinctrl_dev *pctldev,
+				     unsigned selector,
+				     unsigned long *config);
+	int (*pin_config_group_set) (struct pinctrl_dev *pctldev,
+				     unsigned selector,
+				     unsigned long config);
+	void (*pin_config_dbg_show) (struct pinctrl_dev *pctldev,
+				     struct seq_file *s,
+				     unsigned offset);
+	void (*pin_config_group_dbg_show) (struct pinctrl_dev *pctldev,
+					   struct seq_file *s,
+					   unsigned selector);
+};
+
+extern int pin_config_get(struct pinctrl_dev *pctldev, const char *name,
+			  unsigned long *config);
+extern int pin_config_set(struct pinctrl_dev *pctldev, const char *name,
+			  unsigned long config);
+extern int pin_config_group_get(struct pinctrl_dev *pctldev,
+				const char *pin_group,
+				unsigned long *config);
+extern int pin_config_group_set(struct pinctrl_dev *pctldev,
+				const char *pin_group,
+				unsigned long config);
+
+#else
+
+static inline int pin_config_get(struct pinctrl_dev *pctldev, const char *name,
+				 unsigned long *config)
+{
+	return 0;
+}
+
+static inline int pin_config_set(struct pinctrl_dev *pctldev, const char *name,
+				 unsigned long config)
+{
+	return 0;
+}
+
+static inline int pin_config_group_get(struct pinctrl_dev *pctldev,
+				       const char *pin_group,
+				       unsigned long *config)
+{
+	return 0;
+}
+
+static inline int pin_config_group_set(struct pinctrl_dev *pctldev,
+				       const char *pin_group,
+				       unsigned long config)
+{
+	return 0;
+}
+
+#endif
+
+#endif /* __LINUX_PINCTRL_PINCONF_H */
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index f17fac4..4ad5043 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -21,6 +21,7 @@
 
 struct pinctrl_dev;
 struct pinmux_ops;
+struct pinconf_ops;
 struct gpio_chip;
 
 /**
@@ -97,7 +98,9 @@ struct pinctrl_ops {
  *	but may be equal to npins if you have no holes in the pin range.
  * @pctlops: pin control operation vtable, to support global concepts like
  *	grouping of pins, this is optional.
- * @pmxops: pinmux operation vtable, if you support pinmuxing in your driver
+ * @pmxops: pinmux operations vtable, if you support pinmuxing in your driver
+ * @confops: pin config operations vtable, if you support pin configuration in
+ *	your driver
  * @owner: module providing the pin controller, used for refcounting
  */
 struct pinctrl_desc {
@@ -107,6 +110,7 @@ struct pinctrl_desc {
 	unsigned int maxpin;
 	struct pinctrl_ops *pctlops;
 	struct pinmux_ops *pmxops;
+	struct pinconf_ops *confops;
 	struct module *owner;
 };
 
@@ -123,9 +127,7 @@ extern const char *pinctrl_dev_get_name(struct pinctrl_dev *pctldev);
 extern void *pinctrl_dev_get_drvdata(struct pinctrl_dev *pctldev);
 #else
 
-struct pinctrl_dev;
-
-/* Sufficiently stupid default function when pinctrl is not in use */
+/* Sufficiently stupid default functions when pinctrl is not in use */
 static inline bool pin_is_valid(struct pinctrl_dev *pctldev, int pin)
 {
 	return pin >= 0;
-- 
1.7.3.2

