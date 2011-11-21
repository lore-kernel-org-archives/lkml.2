Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab1KUTsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:48:20 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:55212 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752791Ab1KUTsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:48:16 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/8 v3] pinctrl: add a generic pin config interface
Date: Mon, 21 Nov 2011 20:47:51 +0100
Message-ID: <1321904871-32278-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This add per-pin and per-group pin config interfaces for biasing,
driving and other such electronic properties. The intention is
clearly to enumerate all things you can do with pins, hoping that
these are enumerable.

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

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/pinctrl.txt       |  105 +++++++++++-
 drivers/pinctrl/Kconfig         |    5 +-
 drivers/pinctrl/Makefile        |    1 +
 drivers/pinctrl/core.c          |   19 ++
 drivers/pinctrl/core.h          |   10 +
 drivers/pinctrl/pinconf.c       |  366 +++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinconf.h       |   41 +++++
 include/linux/pinctrl/pinconf.h |  209 ++++++++++++++++++++++
 include/linux/pinctrl/pinctrl.h |   10 +-
 9 files changed, 755 insertions(+), 11 deletions(-)
 create mode 100644 drivers/pinctrl/pinconf.c
 create mode 100644 drivers/pinctrl/pinconf.h
 create mode 100644 include/linux/pinctrl/pinconf.h

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index 745f4dd..9a51043 100644
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
@@ -193,6 +195,97 @@ structure, for example specific register ranges associated with each group
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
+The pin control system supports an interface partly abstracting these
+properties while leaving the details to the pin control driver. We assume that
+the things a controller may want configure are enumerable, and thus the
+parameters such as PIN_CONFIG_BIAS_PULL_UP are defined by the core, whereas
+the arguments to the parameter may need to be on a custom format only
+understandable by the driver. However we strive to use SI-derived entities for
+these where applicable, which means the core may step in and do sematic
+analysis of the passed values in select cases.
+
+For example, a platform may do this:
+
+struct pin_config_tuple myconfig {
+	.param = PIN_CONFIG_BIAS_PULL_UP,
+	.data = 100000,
+};
+
+ret = pin_config(dev, 128, &myconfig, 1);
+
+To pull up a pin to VDD with a 100KOhm resistor. The pin configuration driver
+implements callbacks for changing pin configuration in the pin controller ops
+like this:
+
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinconf.h>
+
+int foo_pin_config (struct pinctrl_dev *pctldev,
+    		    const struct pin_config *conf,
+		    unsigned pin,
+		    const struct pin_config_tuple *configs,
+		    unsigned num_configs)
+{
+	int i;
+
+	for (i = 0; i < num_configs; i++) {
+		const struct pin_config_tuple *config = &configs[i];
+		switch (config->param) {
+		case PIN_CONFIG_BIAS_PULL_UP:
+		...
+		}
+	}
+}
+
+int foo_pin_config_group (struct pinctrl_dev *pctldev,
+		    unsigned selector,
+		    const struct pin_config_tuple *configs,
+		    unsigned num_configs)
+{
+	...
+}
+
+static struct pinconf_ops foo_pconf_ops = {
+	.pin_config = foo_pin_config,
+	.pin_config_group = foo_pin_config_group,
+};
+
+/* Pin config operations are handled by some pin controller */
+static struct pinctrl_desc foo_desc = {
+	...
+	.confops = &foo_pconf_ops,
+};
+
+The pin config core keeps track of the pin state, since not all hardware
+support reading this out in a sane way. The current state is the logical sum
+of all applied configurations and can be inspected in debugfs. There is
+an optional hook in the pinconf_ops, .pin_get_initial_config() which can
+read out the initial state of each pin as it is registered, if there is need
+for this on your system. This way the pin config core can keep track of the
+state of each pin at any time. Notice that the .pin_config() callback pass
+the current state of the pin as an argument to the driver so that it can
+exploit the current state of each pin if need be.
+
+Since some controllers have special logic for handling entire groups of pins
+they can exploit the special whole-group pin control function. The
+pin_config_group() callback is allowed to return the error code -EAGAIN,
+for groups it does not want to handle, or if it just wants to do some
+group-level handling and then fall through to iterate over all pins, in which
+case each individual pin will be treated by separate pin_config() calls as
+well.
+
+
 Interaction with the GPIO subsystem
 ===================================
 
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index e17e2f8..2c9be64 100644
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
index bdc548a..dfc145b 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -4,5 +4,6 @@ ccflags-$(CONFIG_DEBUG_PINMUX)	+= -DDEBUG
 
 obj-$(CONFIG_PINCTRL)		+= core.o
 obj-$(CONFIG_PINMUX)		+= pinmux.o
+obj-$(CONFIG_PINCONF)		+= pinconf.o
 obj-$(CONFIG_PINMUX_SIRF)	+= pinmux-sirf.o
 obj-$(CONFIG_PINMUX_U300)	+= pinmux-u300.o
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 4955a68..937aa6e 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -28,6 +28,7 @@
 #include <linux/pinctrl/machine.h>
 #include "core.h"
 #include "pinmux.h"
+#include "pinconf.h"
 
 /* Global list of pin control devices */
 static DEFINE_MUTEX(pinctrldev_list_mutex);
@@ -149,6 +150,7 @@ static int pinctrl_register_one_pin(struct pinctrl_dev *pctldev,
 				    unsigned number, const char *name)
 {
 	struct pin_desc *pindesc;
+	int ret;
 
 	pindesc = pin_desc_get(pctldev, number);
 	if (pindesc != NULL) {
@@ -160,6 +162,7 @@ static int pinctrl_register_one_pin(struct pinctrl_dev *pctldev,
 	pindesc = kzalloc(sizeof(*pindesc), GFP_KERNEL);
 	if (pindesc == NULL)
 		return -ENOMEM;
+
 	spin_lock_init(&pindesc->lock);
 
 	/* Set owner */
@@ -168,6 +171,10 @@ static int pinctrl_register_one_pin(struct pinctrl_dev *pctldev,
 	/* Copy basic pin info */
 	pindesc->name = name;
 
+	ret = pinconf_init_config(pctldev, pindesc, number);
+	if (ret)
+		return ret;
+
 	spin_lock(&pctldev->pin_desc_tree_lock);
 	radix_tree_insert(&pctldev->pin_desc_tree, number, pindesc);
 	spin_unlock(&pctldev->pin_desc_tree_lock);
@@ -315,6 +322,7 @@ int pinctrl_get_group_selector(struct pinctrl_dev *pctldev,
 	return -EINVAL;
 }
 
+
 #ifdef CONFIG_DEBUG_FS
 
 static int pinctrl_pins_show(struct seq_file *s, void *what)
@@ -492,6 +500,7 @@ static void pinctrl_init_device_debugfs(struct pinctrl_dev *pctldev)
 	debugfs_create_file("gpio-ranges", S_IFREG | S_IRUGO,
 			    device_root, pctldev, &pinctrl_gpioranges_ops);
 	pinmux_init_device_debugfs(device_root, pctldev);
+	pinconf_init_device_debugfs(device_root, pctldev);
 }
 
 static void pinctrl_init_debugfs(void)
@@ -548,6 +557,16 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
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
index 74dee43..4b30a28 100644
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
@@ -52,6 +56,8 @@ struct pinctrl_dev {
  * @mux_requested: whether the pin is already requested by pinmux or not
  * @mux_function: a named muxing function for the pin that will be passed to
  *	subdrivers and shown in debugfs etc
+ * @config_lock: a lock to protect the pin configuration portions
+ * @pin_configs: a list of configuration settings for this pin
  */
 struct pin_desc {
 	struct pinctrl_dev *pctldev;
@@ -61,6 +67,10 @@ struct pin_desc {
 #ifdef CONFIG_PINMUX
 	const char *mux_function;
 #endif
+#ifdef CONFIG_PINCONF
+	struct mutex config_lock;
+	struct pin_config config;
+#endif
 };
 
 struct pinctrl_dev *get_pinctrl_dev_from_dev(struct device *dev,
diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
new file mode 100644
index 0000000..dc59c04
--- /dev/null
+++ b/drivers/pinctrl/pinconf.c
@@ -0,0 +1,366 @@
+/*
+ * Core driver for the pin config portions of the pin control subsystem
+ *
+ * Copyright (C) 2011 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ * Based on bits of regulator core, gpio core and clk core
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
+#include <linux/err.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/pinctrl/machine.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinconf.h>
+#include "core.h"
+
+static void pinconf_update_state(struct pin_config *conf,
+				 const struct pin_config_tuple *new)
+{
+	switch (new->param) {
+	case PIN_CONFIG_BIAS_DISABLE:
+	case PIN_CONFIG_BIAS_HIGH_IMPEDANCE:
+	case PIN_CONFIG_BIAS_PULL_UP:
+	case PIN_CONFIG_BIAS_PULL_DOWN:
+	case PIN_CONFIG_BIAS_HIGH:
+	case PIN_CONFIG_BIAS_GROUND:
+		/* These are mutually exclusive */
+		conf->bias.param = new->param;
+		conf->bias.data = new->data;
+		break;
+	case PIN_CONFIG_DRIVE_PUSH_PULL:
+	case PIN_CONFIG_DRIVE_OPEN_DRAIN:
+	case PIN_CONFIG_DRIVE_OPEN_SOURCE:
+	case PIN_CONFIG_DRIVE_OFF:
+		conf->drive.param = new->param;
+		conf->drive.data = new->data;
+		break;
+	case PIN_CONFIG_INPUT_SCHMITT:
+		conf->schmitt.param = new->param;
+		conf->schmitt.data = new->data;
+		break;
+	case PIN_CONFIG_INPUT_DEBOUNCE:
+		conf->debounce.param = new->param;
+		conf->debounce.data = new->data;
+		break;
+	case PIN_CONFIG_SLEW_RATE_RISING:
+		conf->slewrate_rising.param = new->param;
+		conf->slewrate_rising.data = new->data;
+		break;
+	case PIN_CONFIG_SLEW_RATE_FALLING:
+		conf->slewrate_falling.param = new->param;
+		conf->slewrate_falling.data = new->data;
+		break;
+	case PIN_CONFIG_POWER_SOURCE:
+		conf->power_source.param = new->param;
+		conf->power_source.data = new->data;
+		break;
+	case PIN_CONFIG_LOW_POWER_MODE:
+		conf->low_power.param = new->param;
+		conf->low_power.data = new->data;
+		break;
+	case PIN_CONFIG_WAKEUP:
+		conf->wakeup.param = new->param;
+		conf->wakeup.data = new->data;
+		break;
+	default:
+		/* TODO: Error? Custom? */
+		break;
+	}
+}
+
+static void pinconf_update_states(struct pin_config *conf,
+				  const struct pin_config_tuple *configs,
+				  unsigned num_configs)
+{
+	int i;
+
+	for (i = 0; i < num_configs; i++)
+		pinconf_update_state(conf, &configs[i]);
+}
+
+int pin_config(struct pinctrl_dev *pctldev, int pin,
+	       const struct pin_config_tuple *configs,
+	       unsigned num_configs)
+{
+	const struct pinconf_ops *ops = pctldev->desc->confops;
+	struct pin_desc *desc;
+	struct pin_config *conf;
+	int ret;
+
+	desc = pin_desc_get(pctldev, pin);
+	if (desc == NULL) {
+		dev_err(&pctldev->dev, "tried to configure unregistered pin\n");
+		return -EINVAL;
+	}
+
+	conf = &desc->config;
+
+	if (!ops || !ops->pin_config) {
+		dev_err(&pctldev->dev, "cannot configure pin, missing "
+			"config function in driver\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&desc->config_lock);
+	ret = ops->pin_config(pctldev, conf, pin, configs, num_configs);
+	if (ret) {
+		dev_err(&pctldev->dev,
+			"unable to set pin configuration on pin %d\n", pin);
+		return ret;
+	}
+	pinconf_update_states(conf, configs, num_configs);
+	mutex_unlock(&desc->config_lock);
+
+	return 0;
+}
+
+int pin_config_group(struct pinctrl_dev *pctldev, const char *pin_group,
+		     const struct pin_config_tuple *configs,
+		     unsigned num_configs)
+{
+	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
+	const struct pinconf_ops *ops = pctldev->desc->confops;
+	int selector;
+	const unsigned *pins;
+	unsigned num_pins;
+	int ret;
+	int i;
+
+	if (!ops || (!ops->pin_config_group && !ops->pin_config)) {
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
+	if (ops->pin_config_group) {
+		ret = ops->pin_config_group(pctldev, selector,
+					    configs, num_configs);
+
+		/* Success, update per-pin state */
+		if (ret == 0) {
+			for (i = 0; i < num_pins; i++) {
+				struct pin_desc *desc;
+
+				desc = pin_desc_get(pctldev, pins[i]);
+				if (desc == NULL) {
+					dev_err(&pctldev->dev, "error updating state\n");
+					return -EINVAL;
+				}
+				mutex_lock(&desc->config_lock);
+				pinconf_update_states(&desc->config,
+						      configs, num_configs);
+				mutex_unlock(&desc->config_lock);
+			}
+		}
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
+	for (i = 0; i < num_pins; i++) {
+		ret = pin_config(pctldev, pins[i], configs, num_configs);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+int pinconf_check_ops(const struct pinconf_ops *ops)
+{
+	/* We have to be able to config the pins in SOME way */
+	if (!ops->pin_config_group && !ops->pin_config)
+		return -EINVAL;
+	return 0;
+}
+
+int pinconf_init_config(struct pinctrl_dev *pctldev, struct pin_desc *desc,
+			unsigned number)
+{
+	const struct pinconf_ops *ops = pctldev->desc->confops;
+	struct pin_config *conf = &desc->config;
+	int ret;
+
+	mutex_init(&desc->config_lock);
+
+	/* This controller does not support pin config */
+	if (!ops)
+		return 0;
+
+	/* Retrieve initial pin config if the driver supports it */
+	if (ops->pin_get_initial_config) {
+		ret = ops->pin_get_initial_config(pctldev, conf, number);
+		if (ret)
+			dev_err(&pctldev->dev, "unable to get initial config "
+				"for pin %d (%s)\n", number, desc->name);
+		return ret;
+	} else {
+		/* Put them all in assumed states then */
+		conf->bias.param = PIN_CONFIG_BIAS_DISABLE;
+		conf->drive.param = PIN_CONFIG_DRIVE_OFF;
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_DEBUG_FS
+
+static void pinconf_dump_pin(struct seq_file *s, struct pin_config *conf)
+{
+	switch (conf->bias.param) {
+	case PIN_CONFIG_BIAS_DISABLE:
+		seq_puts(s, "bias disabled ");
+		break;
+	case PIN_CONFIG_BIAS_HIGH_IMPEDANCE:
+		seq_puts(s, "bias high impedance ");
+		break;
+	case PIN_CONFIG_BIAS_PULL_UP:
+		seq_puts(s, "bias pull up ");
+		if (conf->bias.data > 0)
+			seq_printf(s, "(%lu Ohm) ", conf->bias.data);
+		break;
+	case PIN_CONFIG_BIAS_PULL_DOWN:
+		seq_puts(s, "bias pull down ");
+		if (conf->bias.data > 0)
+			seq_printf(s, "(%lu Ohm) ", conf->bias.data);
+		break;
+	case PIN_CONFIG_BIAS_HIGH:
+		seq_puts(s, "bias high ");
+		break;
+	case PIN_CONFIG_BIAS_GROUND:
+		seq_puts(s, "bias ground ");
+		break;
+	default:
+		break;
+	}
+
+	switch (conf->drive.param) {
+	case PIN_CONFIG_DRIVE_PUSH_PULL:
+		seq_puts(s, "drive push/pull ");
+		break;
+	case PIN_CONFIG_DRIVE_OPEN_DRAIN:
+		seq_puts(s, "drive open drain ");
+		break;
+	case PIN_CONFIG_DRIVE_OPEN_SOURCE:
+		seq_puts(s, "drive open source ");
+		break;
+	case PIN_CONFIG_DRIVE_OFF:
+		seq_puts(s, "drive off ");
+		break;
+	default:
+		break;
+	}
+	/* Print drive strength */
+	if (conf->drive.data != 0 ||
+	    conf->drive.param == PIN_CONFIG_DRIVE_PUSH_PULL ||
+	    conf->drive.param == PIN_CONFIG_DRIVE_OPEN_DRAIN ||
+	    conf->drive.param == PIN_CONFIG_DRIVE_OPEN_SOURCE)
+		seq_printf(s, "(%luX) ", conf->drive.data);
+
+	if (conf->schmitt.data > 0)
+		seq_printf(s, "schmitt trigger (%lu)", conf->schmitt.data);
+	if (conf->debounce.data > 0)
+		seq_printf(s, "debounce (%lu)", conf->debounce.data);
+	if (conf->slewrate_rising.data > 0)
+		seq_printf(s, "slewrate rising (%lu) ",
+			   conf->slewrate_rising.data);
+	if (conf->slewrate_falling.data > 0)
+		seq_printf(s, "slewrate falling (%lu) ",
+			   conf->slewrate_falling.data);
+	if (conf->power_source.data > 0)
+		seq_printf(s, "power source %lu ",
+			   conf->power_source.data);
+	if (conf->low_power.data > 0)
+		seq_printf(s, "low power mode (%lu) ",
+			   conf->low_power.data);
+	if (conf->wakeup.data > 0)
+		seq_puts(s, "wakeup enabled ");
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
+		seq_printf(s, "pin %d (%s): ", pin,
+			   desc->name ? desc->name : "unnamed");
+
+		mutex_lock(&desc->config_lock);
+			pinconf_dump_pin(s, &desc->config);
+		mutex_unlock(&desc->config_lock);
+
+		seq_printf(s, "\n");
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
+static const struct file_operations pinconf_pins_ops = {
+	.open		= pinconf_pins_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+void pinconf_init_device_debugfs(struct dentry *devroot,
+			 struct pinctrl_dev *pctldev)
+{
+	debugfs_create_file("pinconf-pins", S_IFREG | S_IRUGO,
+			    devroot, pctldev, &pinconf_pins_ops);
+}
+
+#else
+
+#endif
diff --git a/drivers/pinctrl/pinconf.h b/drivers/pinctrl/pinconf.h
new file mode 100644
index 0000000..39e843b
--- /dev/null
+++ b/drivers/pinctrl/pinconf.h
@@ -0,0 +1,41 @@
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
+int pinconf_init_config(struct pinctrl_dev *pctldev, struct pin_desc *desc,
+			unsigned number);
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
+static inline int pinconf_init_config(struct pinctrl_dev *pctldev,
+				      struct pin_desc *desc,
+				      unsigned number)
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
index 0000000..45e424b
--- /dev/null
+++ b/include/linux/pinctrl/pinconf.h
@@ -0,0 +1,209 @@
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
+/**
+ * struct pin_config_tuple - a composite parameter and argument config item
+ * @param: the parameter to configure
+ * @data: argument to the parameter, meaning depend on parameter
+ */
+struct pin_config_tuple {
+	enum pin_config_param param;
+	unsigned long data;
+};
+
+/**
+ * struct pin_config - configuration state holder for a single config of a pin
+ * @bias: bias configuration tuple
+ * @drive: drive configuration tuple
+ * @schmitt: schmitt-trigger configuration tuple
+ * @debounce: debounce configuration tuple
+ * @slewrate_rising: rising edge slew rate configuration tuple
+ * @slewrate_falling: falling edge slew rate configuration tuple
+ * @power_source: selected power source tuple for the pin
+ * @low_power: low power mode tuple
+ * @wakeup: wakeup config tuple
+ *
+ * This holds one configuration item for one pin, a pin may have several such
+ * configurations since it may be configured for several non-conflicting modes
+ * simultaneously.
+ */
+struct pin_config {
+	struct pin_config_tuple bias;
+	struct pin_config_tuple drive;
+	struct pin_config_tuple schmitt;
+	struct pin_config_tuple debounce;
+	struct pin_config_tuple slewrate_rising;
+	struct pin_config_tuple slewrate_falling;
+	struct pin_config_tuple power_source;
+	struct pin_config_tuple low_power;
+	struct pin_config_tuple wakeup;
+};
+
+#ifdef CONFIG_PINCONF
+
+struct pinctrl_dev;
+
+/**
+ * struct pinconf_ops - pin config operations, to be implemented by
+ * pin configuration capable drivers.
+ * @pin_get_initial_config: called to get the initial config of each pin
+ *	if you cannot read out the configuration of your pins at startup, just
+ *	leave this as NULL
+ * @pin_config: configure an individual pin
+ * @pin_config_group: configure all pins in a group
+ * @pin_config_dbg_show: optional debugfs display hook that will provide
+ *	per-device info for a certain pin in debugfs
+ */
+struct pinconf_ops {
+	int (*pin_get_initial_config) (struct pinctrl_dev *pctldev,
+				       struct pin_config *conf,
+				       unsigned pin);
+	int (*pin_config) (struct pinctrl_dev *pctldev,
+			   const struct pin_config *conf,
+			   unsigned pin,
+			   const struct pin_config_tuple *configs,
+			   unsigned num_configs);
+	int (*pin_config_group) (struct pinctrl_dev *pctldev,
+				 unsigned selector,
+				 const struct pin_config_tuple *configs,
+				 unsigned num_configs);
+	void (*pin_config_dbg_show) (struct pinctrl_dev *pctldev,
+				     struct seq_file *s,
+				     unsigned offset);
+};
+
+
+extern int pin_config(struct pinctrl_dev *pctldev, int pin,
+		      const struct pin_config_tuple *configs,
+		      unsigned num_configs);
+extern int pin_config_group(struct pinctrl_dev *pctldev, const char *pin_group,
+			    const struct pin_config_tuple *configs,
+			    unsigned num_configs);
+
+#else
+
+static inline int pin_config(struct pinctrl_dev *pctldev, int pin,
+			     const struct pin_config_tuple *configs,
+			     unsigned num_configs)
+{
+	return 0;
+}
+
+static inline int pin_config_group(struct pinctrl_dev *pctldev,
+				   const char *pin_group,
+				   const struct pin_config_tuple *configs,
+				   unsigned num_configs)
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

