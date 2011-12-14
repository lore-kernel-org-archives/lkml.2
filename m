Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123Ab1LNVCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 16:02:17 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:47470 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756570Ab1LNVCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 16:02:12 -0500
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
Subject: [PATCH] pinctrl: add support for group and pinmux states
Date: Wed, 14 Dec 2011 22:01:46 +0100
Message-ID: <1323896506-20746-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This makes it possible for pin groups and pin muxes to go into
different states, which is especially useful for power management,
both runtime and across suspend/resume.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/pinctrl.txt       |   71 +++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/core.c          |   22 ++++++++++++
 drivers/pinctrl/pinmux.c        |   34 ++++++++++++++++++
 include/linux/pinctrl/pinctrl.h |   32 +++++++++++++++++
 include/linux/pinctrl/pinmux.h  |    7 ++++
 5 files changed, 166 insertions(+), 0 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index 93ac6e1..3456d07 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -194,6 +194,53 @@ just a simple example - in practice you may need more entries in your group
 structure, for example specific register ranges associated with each group
 and so on.
 
+Pin group states
+================
+
+To simplify handling of specific group states, such as when a group of
+pins need to be deactivated or put in a specific sleep state, the pin controller
+may implement a .pin_group_set_state() callback. This will for example be
+called automatically to set a certain pin group in active state when the groups
+are selected for use in a certain pin multiplexing configuration (see below).
+This is a good opportunity to set up any default pin configuration (see below)
+for the pins in a group.
+
+While the driver will have to maintain states for it's pin groups internally
+or in the hardware registers, as well as for setting up the pins on boot,
+it will know through these calls if some special action is needed on behalf
+of the users.
+
+For example, a board file may issue:
+
+pinctrl_set_group_state(dev, "i2c7-group", PIN_GROUP_STATE_DISABLED);
+
+In this case it could be that I2C7 is not used at all in this board, and
+whereas the driver would normally set the I2C pins to pull-up (this happens to
+be required for I2C), in this case since they are not even used on this board,
+it may just as well ground the pins instead and save some power.
+
+The driver will know what to do through this specific callback:
+
+static int foo_set_group_state(struct pinctrl_dev *pctldev,
+				unsigned selector,
+				enum pin_group_state state)
+{
+	switch(state) {
+	...
+	}
+}
+
+static struct pinctrl_ops foo_pctrl_ops = {
+	...
+	.set_group_state = foo_set_group_state,
+};
+
+
+static struct pinctrl_desc foo_desc = {
+	...
+	.pctlops = &foo_pctrl_ops,
+};
+
 
 Pin configuration
 =================
@@ -1066,3 +1113,27 @@ foo_switch()
 }
 
 The above has to be done from process context.
+
+
+Pinmux states
+=============
+
+Pinmuxes can have states just like groups, and in fact setting the state of
+a certain pinmux to a certain enumerator will in practice loop over the pin
+groups used by the pinmux and set the state for each of these groups. Any calls
+to set the pinmux state will be silently ignored if the pin controller does not
+implement handling of group states.
+
+For example a driver, or centralized power management code for the platform
+(wherever the struct pinmux *pmx pointer is handled) can do power saving calls
+like this:
+
+pinmux_set_state(pmx, PIN_GROUP_STATE_ACTIVE);
+pinmux_set_state(pmx, PIN_GROUP_STATE_IDLE);
+pinmux_set_state(pmx, PIN_GROUP_STATE_SLEEP);
+
+Each call may or may not result in the corresponding pin control driver setting
+pins in special low-power modes, disabling pull-ups or anything else (likely
+pin configuration related). It may also just ignore the call, which is useful
+when the same driver is used with different pin controllers, some of which can
+do something meaningful with this information, some which can't.
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 9e32ea3..0d8f6a7 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -344,6 +344,28 @@ int pinctrl_get_group_selector(struct pinctrl_dev *pctldev,
 	return -EINVAL;
 }
 
+/**
+ * pinctrl_set_group_state() - set pin group state
+ * @pctldev: the pin controller holding the group to change state for
+ * @name: the name of the pin group to change the state of
+ * @state: the new state for the pin group
+ */
+int pinctrl_set_group_state(struct pinctrl_dev *pctldev,
+			    const char *name,
+			    enum pin_group_state state)
+{
+	const struct pinctrl_ops *ops = pctldev->desc->pctlops;
+	int selector;
+
+	selector = pinctrl_get_group_selector(pctldev, name);
+	if (selector < 0)
+		return selector;
+	if (!ops->set_group_state)
+		return 0;
+	return ops->set_group_state(pctldev, selector, state);
+}
+EXPORT_SYMBOL_GPL(pinctrl_set_group_state);
+
 #ifdef CONFIG_DEBUG_FS
 
 static int pinctrl_pins_show(struct seq_file *s, void *what)
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 3bcc641..0a0b05f 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -817,6 +817,9 @@ struct pinmux *pinmux_get(struct device *dev, const char *name)
 	list_add(&pmx->node, &pinmux_list);
 	mutex_unlock(&pinmux_list_mutex);
 
+	/* Set to default state, if any */
+	pinmux_set_state(pmx, PIN_GROUP_STATE_ACTIVE);
+
 	return pmx;
 }
 EXPORT_SYMBOL_GPL(pinmux_get);
@@ -904,6 +907,37 @@ void pinmux_disable(struct pinmux *pmx)
 }
 EXPORT_SYMBOL_GPL(pinmux_disable);
 
+int pinmux_set_state(struct pinmux *pmx, enum pin_group_state state)
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
+		ret = pctlops->set_group_state(pctldev, grp->group_selector,
+					       state);
+		if (ret) {
+			dev_err(pctldev->dev, "unable to set state %d for "
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
index 9809a94..bb8a646 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -12,6 +12,23 @@
 #ifndef __LINUX_PINCTRL_PINCTRL_H
 #define __LINUX_PINCTRL_PINCTRL_H
 
+/**
+ * enum pin_group_state - different pin group states
+ * @PIN_GROUP_STATE_DISABLED: disabled state
+ * @PIN_GROUP_STATE_ACTIVE: active state, pins are in active use for their
+ *	purpose, this should be the default state when pins are muxed in for
+ *	example
+ * @PIN_GROUP_STATE_IDLE: the pin group is not actively used now
+ * @PIN_GROUP_STATE_SLEEP: the pin group is in low-power mode for a longer
+ *	period of time
+ */
+enum pin_group_state {
+	PIN_GROUP_STATE_DISABLED,
+	PIN_GROUP_STATE_ACTIVE,
+	PIN_GROUP_STATE_IDLE,
+	PIN_GROUP_STATE_SLEEP,
+};
+
 #ifdef CONFIG_PINCTRL
 
 #include <linux/radix-tree.h>
@@ -69,6 +86,8 @@ struct pinctrl_gpio_range {
  * @get_group_name: return the group name of the pin group
  * @get_group_pins: return an array of pins corresponding to a certain
  *	group selector @pins, and the size of the array in @num_pins
+ * @set_group_state: optional callback to set the state of a certain pin
+ *	group. Not defining this will make all calls to set state succeed.
  * @pin_dbg_show: optional debugfs display hook that will provide per-device
  *	info for a certain pin in debugfs
  */
@@ -80,6 +99,9 @@ struct pinctrl_ops {
 			       unsigned selector,
 			       const unsigned **pins,
 			       unsigned *num_pins);
+	int (*set_group_state) (struct pinctrl_dev *pctldev,
+				unsigned selector,
+				enum pin_group_state state);
 	void (*pin_dbg_show) (struct pinctrl_dev *pctldev, struct seq_file *s,
 			  unsigned offset);
 };
@@ -125,6 +147,9 @@ extern void pinctrl_remove_gpio_range(struct pinctrl_dev *pctldev,
 				struct pinctrl_gpio_range *range);
 extern const char *pinctrl_dev_get_name(struct pinctrl_dev *pctldev);
 extern void *pinctrl_dev_get_drvdata(struct pinctrl_dev *pctldev);
+extern int pinctrl_set_group_state(struct pinctrl_dev *pctldev,
+				   const char *name,
+				   enum pin_group_state state);
 #else
 
 struct pinctrl_dev;
@@ -135,6 +160,13 @@ static inline bool pin_is_valid(struct pinctrl_dev *pctldev, int pin)
 	return pin >= 0;
 }
 
+static inline int pinctrl_set_group_state(struct pinctrl_dev *pctldev,
+					  const char *name,
+					  enum pin_group_state state)
+{
+	return 0;
+}
+
 #endif /* !CONFIG_PINCTRL */
 
 #endif /* __LINUX_PINCTRL_PINCTRL_H */
diff --git a/include/linux/pinctrl/pinmux.h b/include/linux/pinctrl/pinmux.h
index 937b3e2..8d084ad 100644
--- a/include/linux/pinctrl/pinmux.h
+++ b/include/linux/pinctrl/pinmux.h
@@ -97,6 +97,7 @@ extern struct pinmux * __must_check pinmux_get(struct device *dev, const char *n
 extern void pinmux_put(struct pinmux *pmx);
 extern int pinmux_enable(struct pinmux *pmx);
 extern void pinmux_disable(struct pinmux *pmx);
+extern int pinmux_set_state(struct pinmux *pmx, enum pin_group_state state);
 
 #else /* !CONFIG_PINMUX */
 
@@ -137,6 +138,12 @@ static inline void pinmux_disable(struct pinmux *pmx)
 {
 }
 
+static inline int pinmux_set_state(struct pinmux *pmx,
+				   enum pin_group_state state)
+{
+	return 0;
+}
+
 #endif /* CONFIG_PINMUX */
 
 #endif /* __LINUX_PINCTRL_PINMUX_H */
-- 
1.7.3.2

