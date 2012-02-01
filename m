Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab2BATfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:35:14 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:36609 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752958Ab2BATfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:35:12 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v2] pinctrl: pin configuration states
Date: Wed, 1 Feb 2012 20:34:49 +0100
Message-ID: <1328124889-9780-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This introduce a pin configuration state structure and activation
functions similar to the pinmux map. It basically names a few
states and define the custom configuration values to be applied to
groups and pins alike when switching to a certain state.

ChangeLog v1->v2:
- Remove the struct device * pointer in the configuration state
  table, since we killed that off from the mux maps as well.
- Add a few standard pin states for active, idle etc.
- Support for activating states on individual devices and not just
  across the entire pin controller, which seems to be a
  much-requested feature.
- Fixed some review comments from Dong Aisheng and Stephen Warren.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/pinctrl.txt       |   92 ++++++++++++
 drivers/pinctrl/core.c          |    3 +
 drivers/pinctrl/pinconf.c       |  304 ++++++++++++++++++++++++++++++++++++++-
 drivers/pinctrl/pinconf.h       |   11 ++
 include/linux/pinctrl/machine.h |   85 +++++++++++
 include/linux/pinctrl/pinconf.h |   31 ++++
 6 files changed, 519 insertions(+), 7 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index 14aecd2..b37cde7 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -277,6 +277,98 @@ case each individual pin will be treated by separate pin_config_set() calls as
 well.
 
 
+Pin configuration states
+========================
+
+To help platforms to set up initial pin configuration and transit the entire
+set of pins on a pin controller between different states, pin controller
+states are supported by creating named states per controller. A board/machine
+can define a pin configuration like this:
+
+#include <linux/pinctrl/machine.h>
+#include <linux/pinctrl/pinconf.h>
+
+static const struct pin_config foo_pin_config_active[] = {
+	PIN_CONFIG("GPIO0", PLATFORM_X_PULL_UP),
+	PIN_CONFIG("GPIO1", PLATFORM_X_PULL_DOWN),
+};
+
+static const struct pin_config foo_pin_config_idle[] = {
+	PIN_CONFIG("GPIO0", PLATFORM_X_GROUND),
+	PIN_CONFIG("GPIO1", PLATFORM_X_GROUND),
+};
+
+static const struct pin_config foo_pin_config_off[] = {
+	PIN_CONFIG("GPIO0", PLATFORM_X_OFF),
+	PIN_CONFIG("GPIO1", PLATFORM_X_OFF),
+};
+
+static struct pin_config_state __initdata foo_pinconf_states[] = {
+	{
+		.name = "active",
+		.ctrl_dev_name = "pinctrl-foo",
+		.pin_configs = foo_pin_config_active,
+		.nr_pin_configs = ARRAY_SIZE(foo_pin_config_active),
+		.apply_on_init = true,
+	},
+	{
+		.name = "idle",
+		.ctrl_dev_name = "pinctrl-foo",
+		.pin_configs = foo_pin_config_idle,
+		.nr_pin_configs = ARRAY_SIZE(foo_pin_config_idle),
+	},
+	{
+		.name = "off",
+		.ctrl_dev_name = "pinctrl-foo",
+		.pin_configs = foo_pin_config_off,
+		.nr_pin_configs = ARRAY_SIZE(foo_pin_config_off),
+		.apply_on_exit = true,
+	},
+};
+
+The first three arrays of configurations are simply the names of some pins
+and the custom configuration that is associated with each.
+
+So there are three states for the pin controller, and the "active" state will
+pull two GPIO pins, whereas "idle" will ground them and "off" will deactivate
+them completely. In this case "active" will be auto-applied when your pin
+controller registers, and "off" will be auto-applied when the controller is
+removed.
+
+For simple systems that just configure the pins on boot and then forget about
+them, the first configuration table may be sufficient. However some systems
+may need to switch configuration states at runtime, and in that case the
+system may want to ground both pins by simply calling:
+
+ret = pinconf_activate_state("pinctrl-foo", "idle");
+
+Which will apply the "idle" configuration. It is strongly recommended not to
+use open-coded strings like this unless the states are very system-specific.
+The header <linux/pinctrl/pinconf.h> provides a number of standardized state
+names like this:
+
+#define PIN_STATE_DISABLED	"disabled"
+#define PIN_STATE_ACTIVE	"active"
+#define PIN_STATE_IDLE		"idle"
+#define PIN_STATE_SLEEP		"sleeping"
+(...)
+
+It is strongly encouraged that you use these defines for your states wherever
+applicable, and add new defines if you think you have state names that are
+generally useful.
+
+
+Pin configuration states for devices
+====================================
+
+While the aforementioned states are for an entire pin controller, you can
+also define per-device configuration states across *all* pin controllers.
+By setting .dev_name = "bar" in the above example, a device driver for the
+device named "bar" can activate that setting by just issueing:
+
+ret = pinconf_activate_device_state(dev, PIN_STATE_IDLE);
+
+
 Interaction with the GPIO subsystem
 ===================================
 
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 4f10476..c3bb0c8 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -540,6 +540,7 @@ static void pinctrl_init_debugfs(void)
 	debugfs_create_file("pinctrl-devices", S_IFREG | S_IRUGO,
 			    debugfs_root, NULL, &pinctrl_devices_ops);
 	pinmux_init_debugfs(debugfs_root);
+	pinconf_init_debugfs(debugfs_root);
 }
 
 #else /* CONFIG_DEBUG_FS */
@@ -625,6 +626,7 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 	list_add(&pctldev->node, &pinctrldev_list);
 	mutex_unlock(&pinctrldev_list_mutex);
 	pinmux_hog_maps(pctldev);
+	pinconf_apply_initexit(pctldev, true);
 	return pctldev;
 
 out_err:
@@ -646,6 +648,7 @@ void pinctrl_unregister(struct pinctrl_dev *pctldev)
 
 	pinctrl_remove_device_debugfs(pctldev);
 	pinmux_unhog_maps(pctldev);
+	pinconf_apply_initexit(pctldev, false);
 	/* TODO: check that no pinmuxes are still active? */
 	mutex_lock(&pinctrldev_list_mutex);
 	list_del(&pctldev->node);
diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index b74f64a..2608e82 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -23,6 +23,10 @@
 #include "core.h"
 #include "pinconf.h"
 
+/* Global pin configuration states */
+static struct pin_config_state *pinconf_states;
+static unsigned pinconf_states_num;
+
 int pin_config_get_for_pin(struct pinctrl_dev *pctldev, unsigned pin,
 			   unsigned long *config)
 {
@@ -138,11 +142,10 @@ int pin_config_group_get(const char *dev_name, const char *pin_group,
 }
 EXPORT_SYMBOL(pin_config_group_get);
 
-
-int pin_config_group_set(const char *dev_name, const char *pin_group,
-			 unsigned long config)
+static int pin_config_group_set_for_group(struct pinctrl_dev *pctldev,
+					  const char *pin_group,
+					  unsigned long config)
 {
-	struct pinctrl_dev *pctldev;
 	const struct pinconf_ops *ops;
 	const struct pinctrl_ops *pctlops;
 	int selector;
@@ -151,9 +154,6 @@ int pin_config_group_set(const char *dev_name, const char *pin_group,
 	int ret;
 	int i;
 
-	pctldev = get_pinctrl_dev_from_devname(dev_name);
-	if (!pctldev)
-		return -EINVAL;
 	ops = pctldev->desc->confops;
 	pctlops = pctldev->desc->pctlops;
 
@@ -203,6 +203,20 @@ int pin_config_group_set(const char *dev_name, const char *pin_group,
 
 	return 0;
 }
+
+int pin_config_group_set(const char *dev_name, const char *pin_group,
+			 unsigned long config)
+{
+	struct pinctrl_dev *pctldev;
+
+	pctldev = get_pinctrl_dev_from_devname(dev_name);
+	if (!pctldev)
+		return -EINVAL;
+
+	return pin_config_group_set_for_group(pctldev,
+					      pin_group,
+					      config);
+}
 EXPORT_SYMBOL(pin_config_group_set);
 
 int pinconf_check_ops(struct pinctrl_dev *pctldev)
@@ -218,6 +232,239 @@ int pinconf_check_ops(struct pinctrl_dev *pctldev)
 	return 0;
 }
 
+int __init pinconf_register_pin_states(struct pin_config_state const *states,
+				       unsigned num_states)
+{
+	void *tmp;
+	int i;
+
+	pr_debug("add %d pin configuration states\n", num_states);
+
+	/* First sanity check the new states */
+	for (i = 0; i < num_states; i++) {
+		if (!states[i].name) {
+			pr_err("failed to register config state %d: "
+			       "no state name given\n", i);
+			return -EINVAL;
+		}
+
+		if (!states[i].ctrl_dev_name) {
+			pr_err("failed to register config state %s (%d): "
+			       "no pin control device given\n",
+			       states[i].name, i);
+			return -EINVAL;
+		}
+
+		if (!states[i].pin_configs && !states[i].pin_group_configs) {
+			pr_err("failed to register config state %s (%d): "
+			       "no pin or group states defined in it\n",
+			       states[i].name, i);
+			return -EINVAL;
+		}
+
+		pr_debug("register pin config state %s\n",
+			 states[i].name);
+	}
+
+	/*
+	 * Make a copy of the config state array - string pointers will end up
+	 * in the kernel const section anyway so these do not need to be deep
+	 * copied. Note that the pointers to the config tuples are *not* being
+	 * copied as of now, these cannot be declared __init_data.
+	 */
+	if (!pinconf_states_num) {
+		/* On first call, just copy them */
+		tmp = kmemdup(states,
+			      sizeof(struct pin_config_state) * num_states,
+			      GFP_KERNEL);
+		if (!tmp)
+			return -ENOMEM;
+	} else {
+		/* Subsequent calls, reallocate array to new size */
+		size_t oldsize = sizeof(struct pin_config_state) *
+			pinconf_states_num;
+		size_t newsize = sizeof(struct pin_config_state) * num_states;
+
+		tmp = krealloc(pinconf_states, oldsize + newsize, GFP_KERNEL);
+		if (!tmp)
+			return -ENOMEM;
+		memcpy((tmp + oldsize), states, newsize);
+	}
+
+	pinconf_states = tmp;
+	pinconf_states_num += num_states;
+	return 0;
+}
+
+/**
+ * pinconf_apply_state() - apply a certain pin configuration state on a certain
+ * pin controller
+ * @pctldev: the pin controller to apply the state to
+ * @pstate: the configuration state to apply on the pin controller
+ */
+static int pinconf_apply_state(struct pinctrl_dev *pctldev,
+			       struct pin_config_state const *pstate)
+{
+	int ret, i;
+
+	/* Apply group configs first */
+	for (i = 0; i < pstate->nr_pin_group_configs; i++) {
+		const struct pin_group_config *groupconf =
+			&pstate->pin_group_configs[i];
+
+		ret = pin_config_group_set_for_group(pctldev,
+						     groupconf->group_name,
+						     groupconf->config);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* Then apply individual pin configs */
+	for (i = 0; i < pstate->nr_pin_configs; i++) {
+		const struct pin_config *pinconf =
+			&pstate->pin_configs[i];
+		int pin;
+
+		pin = pin_get_from_name(pctldev, pinconf->pin_name);
+		if (pin < 0)
+			return pin;
+
+		ret = pin_config_set_for_pin(pctldev, pin, pinconf->config);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * pinconf_activate_state() - sets the controller-wide state for pins and
+ *	groups on a pin controller
+ * @dev_name: the textual name for the pin controller
+ * @state: name of the state to set
+ */
+int pinconf_activate_state(const char *dev_name, const char *state)
+{
+	struct pinctrl_dev *pctldev;
+	int i;
+
+	/* We must have dev_name and state */
+	if (!dev_name || !state)
+		return -EINVAL;
+
+	pr_debug("activate state %s for device %s\n", state,
+		 dev_name);
+
+	pctldev = get_pinctrl_dev_from_devname(dev_name);
+
+	if (!pctldev)
+		return -EINVAL;
+
+	for (i = 0; i < pinconf_states_num; i++) {
+		struct pin_config_state const *pstate = &pinconf_states[i];
+		int ret;
+
+		/*
+		 * States defined for a certain device are by definition not
+		 * global states so skip those.
+		 */
+		if (pstate->dev_name)
+			continue;
+
+		if (!strcmp(pstate->name, state)) {
+			ret = pinconf_apply_state(pctldev, pstate);
+			if (ret)
+				dev_err(pctldev->dev,
+					"failed to apply state %s\n",
+					pstate->name);
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(pinconf_activate_state);
+
+/**
+ * pinconf_activate_device_state() - activate a configuration state for a
+ *	certain device
+ * @dev: the device to activate the state for, this will be matched to an
+ *	entry in the controller config state table
+ * @state: the name of the state to activate
+ */
+int pinconf_activate_device_state(struct device *dev, const char *state)
+{
+	const char *devname = NULL;
+	int i;
+
+	/* We must have dev and state */
+	if (!dev || !state)
+		return -EINVAL;
+
+	devname = dev_name(dev);
+
+	pr_debug("activate state %s for device %s\n", state,
+		 devname);
+
+	for (i = 0; i < pinconf_states_num; i++) {
+		struct pin_config_state const *pstate = &pinconf_states[i];
+		int ret;
+
+		/* States without a device name are global, not for devices */
+		if (!pstate->dev_name)
+			continue;
+
+		/* Apply all the matching states */
+		if (!strcmp(pstate->dev_name, devname) &&
+		    !strcmp(pstate->name, state)) {
+			struct pinctrl_dev *pctldev =
+				get_pinctrl_dev_from_devname(pstate->dev_name);
+
+			if (!pctldev) {
+				dev_err(pctldev->dev,
+					"no device for state %s\n",
+					pstate->name);
+				continue;
+			}
+
+			ret = pinconf_apply_state(pctldev, pstate);
+			if (ret) {
+				dev_err(pctldev->dev,
+					"failed to apply state %s\n",
+					pstate->name);
+				continue;
+			}
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL(pinconf_activate_device_state);
+
+/**
+ * pinconf_apply_initexit() - check for states to be applied on init and exit
+ * @pctldev: pin controller to be checked
+ * @init: true for checking during registration of the pin controller, false
+ *	for checking during removal of the pin controller
+ */
+void pinconf_apply_initexit(struct pinctrl_dev *pctldev, bool init)
+{
+	int i;
+
+	for (i = 0; i < pinconf_states_num; i++) {
+		struct pin_config_state const *pstate = &pinconf_states[i];
+		int ret;
+
+		if ((pstate->apply_on_init && init) ||
+		    (pstate->apply_on_exit && !init)) {
+			ret = pinconf_apply_state(pctldev, pstate);
+			if (ret)
+				dev_err(pctldev->dev,
+					"failed to apply state %s on %s\n",
+					pstate->name,
+					init ? "init" : "exit");
+		}
+	}
+}
+
 #ifdef CONFIG_DEBUG_FS
 
 static void pinconf_dump_pin(struct pinctrl_dev *pctldev,
@@ -292,6 +539,31 @@ static int pinconf_groups_show(struct seq_file *s, void *what)
 	return 0;
 }
 
+static int pinconf_states_show(struct seq_file *s, void *what)
+{
+	int i;
+
+	seq_puts(s, "Pinconfig state table:\n");
+
+	for (i = 0; i < pinconf_states_num; i++) {
+		struct pin_config_state const *pstate = &pinconf_states[i];
+
+		seq_printf(s, "%s:\n", pstate->name);
+		seq_printf(s, "  controlling device %s\n",
+			   pstate->ctrl_dev_name);
+		seq_printf(s, "  %u pin configs, %u pin group configs\n",
+			   pstate->nr_pin_configs,
+			   pstate->nr_pin_group_configs);
+		seq_printf(s, "  target: %s\n", pstate->dev_name ?
+			   pstate->dev_name : "controller-wide");
+		seq_printf(s, "  apply on init: %s\n",
+			   pstate->apply_on_init ? "YES" : "NO");
+		seq_printf(s, "  apply on exit: %s\n",
+			   pstate->apply_on_exit ? "YES" : "NO");
+	}
+	return 0;
+}
+
 static int pinconf_pins_open(struct inode *inode, struct file *file)
 {
 	return single_open(file, pinconf_pins_show, inode->i_private);
@@ -302,6 +574,11 @@ static int pinconf_groups_open(struct inode *inode, struct file *file)
 	return single_open(file, pinconf_groups_show, inode->i_private);
 }
 
+static int pinconf_states_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pinconf_states_show, inode->i_private);
+}
+
 static const struct file_operations pinconf_pins_ops = {
 	.open		= pinconf_pins_open,
 	.read		= seq_read,
@@ -316,6 +593,13 @@ static const struct file_operations pinconf_groups_ops = {
 	.release	= single_release,
 };
 
+static const struct file_operations pinconf_states_ops = {
+	.open		= pinconf_states_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 void pinconf_init_device_debugfs(struct dentry *devroot,
 			 struct pinctrl_dev *pctldev)
 {
@@ -325,4 +609,10 @@ void pinconf_init_device_debugfs(struct dentry *devroot,
 			    devroot, pctldev, &pinconf_groups_ops);
 }
 
+void pinconf_init_debugfs(struct dentry *subsys_root)
+{
+	debugfs_create_file("pinconf-states", S_IFREG | S_IRUGO,
+			    subsys_root, NULL, &pinconf_states_ops);
+}
+
 #endif
diff --git a/drivers/pinctrl/pinconf.h b/drivers/pinctrl/pinconf.h
index 006b77f..b6891d2 100644
--- a/drivers/pinctrl/pinconf.h
+++ b/drivers/pinctrl/pinconf.h
@@ -14,8 +14,10 @@
 #ifdef CONFIG_PINCONF
 
 int pinconf_check_ops(struct pinctrl_dev *pctldev);
+void pinconf_apply_initexit(struct pinctrl_dev *pctldev, bool init);
 void pinconf_init_device_debugfs(struct dentry *devroot,
 				 struct pinctrl_dev *pctldev);
+void pinconf_init_debugfs(struct dentry *subsys_root);
 int pin_config_get_for_pin(struct pinctrl_dev *pctldev, unsigned pin,
 			   unsigned long *config);
 int pin_config_set_for_pin(struct pinctrl_dev *pctldev, unsigned pin,
@@ -28,9 +30,18 @@ static inline int pinconf_check_ops(struct pinctrl_dev *pctldev)
 	return 0;
 }
 
+static inline void pinconf_apply_initexit(struct pinctrl_dev *pctldev,
+					  bool init)
+{
+}
+
 static inline void pinconf_init_device_debugfs(struct dentry *devroot,
 					       struct pinctrl_dev *pctldev)
 {
 }
 
+static inline void pinconf_init_debugfs(struct dentry *subsys_root)
+{
+}
+
 #endif
diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
index f8593fd..52151ad 100644
--- a/include/linux/pinctrl/machine.h
+++ b/include/linux/pinctrl/machine.h
@@ -74,6 +74,73 @@ struct pinmux_map {
 	{ .name = a, .ctrl_dev_name = b, .function = c, .group = d, \
 	  .hog_on_boot = true }
 
+/**
+ * struct pin_config - configuration tuple for a single pin
+ * @pin_name: name of the pin affected by this configuration
+ * @config: configuration of the named pin (custom format)
+ */
+struct pin_config {
+	const char *pin_name;
+	u32 config;
+};
+
+/*
+ * Convenience macro to set up a simple config for a named pin
+ */
+#define PIN_CONFIG(a, b) \
+	{ .pin_name = a, .config = b }
+
+/**
+ * struct pin_group_config - configuration tuple for a group
+ * @group_name: name of the group affected by this configuration
+ * @config: configuration of the named group (custom format)
+ */
+struct pin_group_config {
+	const char *group_name;
+	u32 config;
+};
+
+/*
+ * Convenience macro to set up a simple config for a named pin group
+ */
+#define PIN_GROUP_CONFIG(a, b) \
+	{ .group_name = a, .config = b }
+
+/**
+ * struct pin_config_state - configuration for an array of pins
+ * @name: name of this configuration state. You may supply multiple states
+ *	by the same name both globally (without specified .dev_name) and per-
+ *	device, they will all be activated at the same time
+ * @ctrl_dev_name: the name of the device controlling this specific state,
+ *	the name must be the same as in your struct device*
+ * @dev_name: if this configuration shall be tied to a specific device, the
+ *	device name, same as returned from dev_name() on the device, shall be
+ *	specified here. For system-wide config states, this shall be set to
+ *	NULL. Notice that this property divides every state into either global
+ *	or per-device type.
+ * @pin_configs: array of pin configuration tuples
+ * @nr_pin_configs: number of pin_configuration tuples in the array
+ * @pin_group_configs: array of pin group configuration tuples
+ * @nr_pin_group_configs: number of pin_group_configuration tuples in the array
+ * @apply_on_init: whether this configuration shall be auto-applied when
+ *	the pin controller is registered - also per-device states will be
+ *	applied if they have this property
+ * @apply_on_exit: whether this configuration shall be auto-applied when
+ *	the pin controller is unregistered - also per-device states will be
+ *	applied if they have this property
+ */
+struct pin_config_state {
+	const char *name;
+	const char *ctrl_dev_name;
+	const char *dev_name;
+	const struct pin_config *pin_configs;
+	unsigned nr_pin_configs;
+	const struct pin_group_config *pin_group_configs;
+	unsigned nr_pin_group_configs;
+	bool apply_on_init;
+	bool apply_on_exit;
+};
+
 #ifdef CONFIG_PINMUX
 
 extern int pinmux_register_mappings(struct pinmux_map const *map,
@@ -88,4 +155,22 @@ static inline int pinmux_register_mappings(struct pinmux_map const *map,
 }
 
 #endif /* !CONFIG_PINMUX */
+
+#ifdef CONFIG_PINCONF
+
+extern int pinconf_register_pin_states(struct pin_config_state const
+				       *states,
+				       unsigned num_states);
+
+#else
+
+static inline int pinconf_register_pin_states(struct pin_config_state const
+					*states,
+					unsigned num_states)
+{
+	return 0;
+}
+
+#endif /* !CONFIG_PINCONF */
+
 #endif
diff --git a/include/linux/pinctrl/pinconf.h b/include/linux/pinctrl/pinconf.h
index 477922c..e6d3399 100644
--- a/include/linux/pinctrl/pinconf.h
+++ b/include/linux/pinctrl/pinconf.h
@@ -12,6 +12,23 @@
 #ifndef __LINUX_PINCTRL_PINCONF_H
 #define __LINUX_PINCTRL_PINCONF_H
 
+/**
+ * Standard pin group states. States are defined by the driver, and names can
+ * be all-custom. However, to avoid duplication of common pin states, they are
+ * provided here.
+ * @PIN_CONFIG_STATE_DISABLED: disabled state
+ * @PIN_CONFIG_STATE_ACTIVE: active state, pins are in active use for their
+ *	purpose, this should be the default state when pins are muxed in for
+ *	example
+ * @PIN_CONFIG_STATE_IDLE: the pin group is not actively used now
+ * @PIN_CONFIG_STATE_SLEEPING: the pin group is in low-power mode for a longer
+ *	period of time
+ */
+#define PIN_STATE_DISABLED	"disabled"
+#define PIN_STATE_ACTIVE	"active"
+#define PIN_STATE_IDLE		"idle"
+#define PIN_STATE_SLEEP		"sleeping"
+
 #ifdef CONFIG_PINCONF
 
 struct pinctrl_dev;
@@ -63,6 +80,8 @@ extern int pin_config_group_get(const char *dev_name,
 extern int pin_config_group_set(const char *dev_name,
 				const char *pin_group,
 				unsigned long config);
+int pinconf_activate_state(const char *dev_name, const char *state);
+int pinconf_activate_device_state(struct device *dev, const char *state);
 
 #else
 
@@ -92,6 +111,18 @@ static inline int pin_config_group_set(const char *dev_name,
 	return 0;
 }
 
+static inline int pinconf_activate_state(const char *dev_name,
+					 const char *state)
+{
+	return 0;
+}
+
+static inline int pinconf_activate_device_state(struct device *dev,
+						const char *state)
+{
+	return 0;
+}
+
 #endif
 
 #endif /* __LINUX_PINCTRL_PINCONF_H */
-- 
1.7.8

