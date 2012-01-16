Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab2APARZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 19:17:25 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:39616 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751407Ab2APARX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 19:17:23 -0500
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
Subject: [PATCH v3] pinctrl: add support for group and pinmux states
Date: Mon, 16 Jan 2012 01:16:55 +0100
Message-ID: <1326673015-963-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This makes it possible for pin groups and pin muxes to go into
different states, which is especially useful for power management,
both runtime and across suspend/resume.

ChangeLog v2->v3:
- Let the pin controller enumerate the available states for a
  group with string names just like it enumerates the groups
  themselves.
- Do not mandate any states (these are full-custom) but supply
  a bunch of clever presets in <linux/pinctrl/pinctrl.h> that
  can be used when applicable.
- Consequental changes to the pinmux interface - muxes use the
  named group states.
ChangeLog v1->v2:
- Use a pin controller name instead of the device itself as
  parameter to the state set function, as indicated by Stephens
  similar patch to config this is more helpful.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/pinctrl.txt       |  114 +++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/core.c          |   86 +++++++++++++++++++++++++++++
 drivers/pinctrl/core.h          |    3 +
 drivers/pinctrl/pinmux.c        |   32 +++++++++++
 include/linux/pinctrl/pinctrl.h |   44 +++++++++++++++
 include/linux/pinctrl/pinmux.h  |    7 +++
 6 files changed, 286 insertions(+), 0 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index 1851f1d..bf50192 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -194,6 +194,96 @@ just a simple example - in practice you may need more entries in your group
 structure, for example specific register ranges associated with each group
 and so on.
 
+Pin group states
+================
+
+To simplify handling of specific group states, such as when a group of
+pins need to be deactivated or put in a specific sleep state, the pin controller
+may implement callbacks to enumerate a number of states and select one of
+them. This will for example be called automatically to set a certain pin group
+in active state when the groups are selected for use in a certain pin
+multiplexing configuration (see below). This is a good opportunity to set up
+any default pin configuration (see below) for the pins in a group.
+
+While the driver will have to maintain states for its pin groups internally
+or in the hardware registers, as well as for setting up the pins on boot,
+it will know through these calls if some special action is needed on behalf
+of the users.
+
+For example, a board file may issue:
+
+pinctrl_set_group_state("foo-dev", "i2c7-group", "disabled");
+
+In this case it could be that I2C7 is not used at all in this board, and
+whereas the driver would normally set the I2C pins to pull-up (this happens to
+be required for I2C), in this case since they are not even used on this board,
+it may just as well ground the pins instead and save some power.
+
+The driver will know what to do through this set of callbacks, for example
+if group 3 supports two states "active" and "idle" like this:
+
+static const char *activestate = "active";
+static const char *idlestate = "idle";
+
+static int foo_list_group_states(struct pinctrl_dev *pctldev,
+				unsigned selector,
+				unsigned state)
+{
+	/* Only group three has states */
+	if (selector != 3)
+		return -EINVAL;
+	/* Only two states, 0 and 1 */
+	if (state > 1)
+		return -EINVAL;
+}
+
+static const char foo_get_group_state_name(struct pinctrl_dev *pctldev,
+				unsigned selector,
+				unsigned state)
+{
+
+	if (selector != 3)
+		return -EINVAL;
+	if (state == 0)
+		return activestate;
+	if (state == 1)
+		return idlestate;
+	return -EINVAL;
+}
+
+static int foo_set_group_state(struct pinctrl_dev *pctldev,
+				unsigned selector,
+				unsigned state)
+{
+	if (selector != 3)
+		return -EINVAL;
+	switch(state) {
+	case 0:
+		...
+	case 1:
+		...
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static struct pinctrl_ops foo_pctrl_ops = {
+	...
+	.list_group_states = foo_list_group_states,
+	.get_group_state_name = foo_get_group_state_name,
+	.set_group_state = foo_set_group_state,
+};
+
+
+static struct pinctrl_desc foo_desc = {
+	...
+	.pctlops = &foo_pctrl_ops,
+};
+
+So the core will call .list_group_states() iteratively to get the available
+state names for a group, get names for comparison from .get_group_state_name()
+and then finally set a state using the .set_group_state().
 
 Pin configuration
 =================
@@ -1066,3 +1156,27 @@ foo_switch()
 }
 
 The above has to be done from process context.
+
+
+Pinmux states
+=============
+
+Pinmuxes can have states just like groups, and in fact setting the state of
+a certain pinmux to a certain named state will in practice loop over the pin
+groups used by the pinmux and set the state for each of these groups. Any calls
+to set the pinmux state will be silently ignored if the pin controller does not
+implement handling of group states.
+
+For example a driver, or centralized power management code for the platform
+(wherever the struct pinmux *pmx pointer is handled) can do power saving calls
+like this:
+
+pinmux_set_state(pmx, "active");
+pinmux_set_state(pmx, "idle");
+pinmux_set_state(pmx, "sleep");
+
+Each call may or may not result in the corresponding pin control driver setting
+pins in special low-power modes, disabling pull-ups or anything else (likely
+pin configuration related). It may also just ignore the call, which is useful
+when the same driver is used with different pin controllers, some of which can
+do something meaningful with this information, some which can't.
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 569bdb3..132bbce 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -345,6 +345,92 @@ int pinctrl_get_group_selector(struct pinctrl_dev *pctldev,
 	return -EINVAL;
 }
 
+/**
+ * pinctrl_get_group_state_selector() - locate a certain group state selector
+ * @pctldev: name of the pin controller to find the group state for
+ * @groupsel: the previously located group selector
+ * @state: the name of the state to locate
+ */
+static int pinctrl_get_group_state_selector(struct pinctrl_dev *pctldev,
+					    unsigned groupsel,
+					    const char *state)
+{
+	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
+	unsigned statesel = 0;
+
+	while (pctlops->list_group_states(pctldev, groupsel, statesel) >= 0) {
+		const char *sname = pctlops->get_group_state_name(pctldev,
+								  groupsel,
+								  statesel);
+		if (!strcmp(sname, state)) {
+			dev_dbg(pctldev->dev,
+				"found group state selector %u for %s\n",
+				statesel,
+				state);
+			return statesel;
+		}
+
+		statesel++;
+	}
+
+	dev_err(pctldev->dev, "does not have state %s\n", state);
+
+	return -EINVAL;
+}
+
+/**
+ * pinctrl_set_group_state_for_selector() - knowing a groups selector, set its
+ * state
+ * @pctldev: name of the pin controller to find the group state for
+ * @groupsel: the previously located group selector
+ * @state: the name of the state to set
+ */
+int pinctrl_set_group_state_for_selector(struct pinctrl_dev *pctldev,
+					 unsigned groupsel,
+					 const char *state)
+{
+	const struct pinctrl_ops *ops;
+	int statesel;
+
+	ops = pctldev->desc->pctlops;
+	statesel = pinctrl_get_group_state_selector(pctldev, groupsel, state);
+	if (statesel < 0)
+		return statesel;
+
+	return ops->set_group_state(pctldev, groupsel, statesel);
+}
+
+/**
+ * pinctrl_set_group_state() - set pin group state
+ * @dev_name: name of the pin controller holding the group to change state for
+ * @name: the name of the pin group to change the state of
+ * @state: the new state for the pin group
+ */
+int pinctrl_set_group_state(const char *dev_name,
+			    const char *name,
+			    const char *state)
+{
+	struct pinctrl_dev *pctldev;
+	const struct pinctrl_ops *ops;
+	int groupsel;
+
+	pctldev = get_pinctrl_dev_from_dev(NULL, dev_name);
+	if (!pctldev)
+		return -EINVAL;
+	ops = pctldev->desc->pctlops;
+
+	if (!ops->list_group_states || !ops->get_group_state_name ||
+	    !ops->set_group_state)
+		return 0;
+
+	groupsel = pinctrl_get_group_selector(pctldev, name);
+	if (groupsel < 0)
+		return groupsel;
+
+	return pinctrl_set_group_state_for_selector(pctldev, groupsel, state);
+}
+EXPORT_SYMBOL_GPL(pinctrl_set_group_state);
+
 #ifdef CONFIG_DEBUG_FS
 
 static int pinctrl_pins_show(struct seq_file *s, void *what)
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 177a331..cbdccb8 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -78,3 +78,6 @@ int pinctrl_get_device_gpio_range(unsigned gpio,
 				  struct pinctrl_gpio_range **outrange);
 int pinctrl_get_group_selector(struct pinctrl_dev *pctldev,
 			       const char *pin_group);
+int pinctrl_set_group_state_for_selector(struct pinctrl_dev *pctldev,
+					 unsigned groupsel,
+					 const char *state);
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index a76a348..31c9e1d 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -904,6 +904,38 @@ void pinmux_disable(struct pinmux *pmx)
 }
 EXPORT_SYMBOL_GPL(pinmux_disable);
 
+int pinmux_set_state(struct pinmux *pmx, const char *state)
+{
+	struct pinctrl_dev *pctldev = pmx->pctldev;
+	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
+	struct pinmux_group *grp;
+	int ret;
+
+	/* Does not implement group states, bail out */
+	if (!pctlops->set_group_state)
+		return 0;
+
+	/*
+	 * Loop over the currently used groups for this pinmux and set the
+	 * state for each and every one of them.
+	 */
+	list_for_each_entry(grp, &pmx->groups, node) {
+		ret = pinctrl_set_group_state_for_selector(pctldev,
+							   grp->group_selector,
+							   state);
+		if (ret) {
+			dev_err(pctldev->dev, "unable to set state %s for "
+				"group %u on %s\n",
+				state, grp->group_selector,
+				pinctrl_dev_get_name(pctldev));
+			return ret;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pinmux_set_state);
+
 int pinmux_check_ops(const struct pinmux_ops *ops)
 {
 	/* Check that we implement required operations */
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 8bd22ee..ca33b84 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -12,6 +12,23 @@
 #ifndef __LINUX_PINCTRL_PINCTRL_H
 #define __LINUX_PINCTRL_PINCTRL_H
 
+/**
+ * Standard pin group states. States are defined by the driver, and names can
+ * be all-custom. However, to avoid duplication of common pin group states,
+ * they are provided here.
+ * @PIN_GROUP_STATE_DISABLED: disabled state
+ * @PIN_GROUP_STATE_ACTIVE: active state, pins are in active use for their
+ *	purpose, this should be the default state when pins are muxed in for
+ *	example
+ * @PIN_GROUP_STATE_IDLE: the pin group is not actively used now
+ * @PIN_GROUP_STATE_SLEEPING: the pin group is in low-power mode for a longer
+ *	period of time
+ */
+#define PIN_GROUP_STATE_DISABLED	"disabled"
+#define PIN_GROUP_STATE_ACTIVE		"active"
+#define PIN_GROUP_STATE_IDLE		"idle"
+#define PIN_GROUP_STATE_SLEEP		"sleeping"
+
 #ifdef CONFIG_PINCTRL
 
 #include <linux/radix-tree.h>
@@ -69,6 +86,14 @@ struct pinctrl_gpio_range {
  * @get_group_name: return the group name of the pin group
  * @get_group_pins: return an array of pins corresponding to a certain
  *	group selector @pins, and the size of the array in @num_pins
+ * @list_group_states: optional callback to list the number of selectable
+ *	named group states available for a certain group, the core will begin
+ *	on 0 and call this repeatedly as long as it returns >= 0 to enumerate
+ *	the states
+ * @get_group_state_name: optional callback to return the name of the pin
+ *	group state indicated
+ * @set_group_state: optional callback to set the state of a certain pin
+ *	group. Not defining this will make all calls to set state succeed.
  * @pin_dbg_show: optional debugfs display hook that will provide per-device
  *	info for a certain pin in debugfs
  */
@@ -80,6 +105,15 @@ struct pinctrl_ops {
 			       unsigned selector,
 			       const unsigned **pins,
 			       unsigned *num_pins);
+	int (*list_group_states) (struct pinctrl_dev *pctldev,
+				  unsigned selector,
+				  unsigned state);
+	const char *(*get_group_state_name) (struct pinctrl_dev *pctldev,
+					     unsigned selector,
+					     unsigned state);
+	int (*set_group_state) (struct pinctrl_dev *pctldev,
+				unsigned selector,
+				unsigned state);
 	void (*pin_dbg_show) (struct pinctrl_dev *pctldev, struct seq_file *s,
 			  unsigned offset);
 };
@@ -120,6 +154,9 @@ extern void pinctrl_remove_gpio_range(struct pinctrl_dev *pctldev,
 				struct pinctrl_gpio_range *range);
 extern const char *pinctrl_dev_get_name(struct pinctrl_dev *pctldev);
 extern void *pinctrl_dev_get_drvdata(struct pinctrl_dev *pctldev);
+extern int pinctrl_set_group_state(const char *dev_name,
+				   const char *name,
+				   const char *state);
 #else
 
 struct pinctrl_dev;
@@ -130,6 +167,13 @@ static inline bool pin_is_valid(struct pinctrl_dev *pctldev, int pin)
 	return pin >= 0;
 }
 
+static inline int pinctrl_set_group_state(const char *dev_name,
+					  const char *name,
+					  const char *state)
+{
+	return 0;
+}
+
 #endif /* !CONFIG_PINCTRL */
 
 #endif /* __LINUX_PINCTRL_PINCTRL_H */
diff --git a/include/linux/pinctrl/pinmux.h b/include/linux/pinctrl/pinmux.h
index 937b3e2..a87be46 100644
--- a/include/linux/pinctrl/pinmux.h
+++ b/include/linux/pinctrl/pinmux.h
@@ -97,6 +97,7 @@ extern struct pinmux * __must_check pinmux_get(struct device *dev, const char *n
 extern void pinmux_put(struct pinmux *pmx);
 extern int pinmux_enable(struct pinmux *pmx);
 extern void pinmux_disable(struct pinmux *pmx);
+extern int pinmux_set_state(struct pinmux *pmx, const char *state);
 
 #else /* !CONFIG_PINMUX */
 
@@ -137,6 +138,12 @@ static inline void pinmux_disable(struct pinmux *pmx)
 {
 }
 
+static inline int pinmux_set_state(struct pinmux *pmx,
+				   const char *state)
+{
+	return 0;
+}
+
 #endif /* CONFIG_PINMUX */
 
 #endif /* __LINUX_PINCTRL_PINMUX_H */
-- 
1.7.8

