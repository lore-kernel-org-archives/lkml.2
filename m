Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab1JSQVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 12:21:51 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:41435 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756567Ab1JSQVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 12:21:49 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, Stephen Warren <swarren@nvidia.com>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>
Cc: Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/2] pinctrl: add a generic control interface
Date: Wed, 19 Oct 2011 18:21:14 +0200
Message-ID: <1319041274-18723-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This add per-pin and per-group pin control interfaces for biasing,
driving and other such electronic properties. The intention is
clearly to enumerate all things you can do with pins, hoping that
these are enumerable.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/pinctrl.txt       |   55 ++++++++++++++++++-
 drivers/pinctrl/core.c          |   69 ++++++++++++++++++++++++
 include/linux/pinctrl/pinctrl.h |  112 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 232 insertions(+), 4 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index b04cb7d..328adb7 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -7,8 +7,6 @@ This subsystem deals with:
 
 - Multiplexing of pins, pads, fingers (etc) see below for details
 
-The intention is to also deal with:
-
 - Software-controlled biasing and driving mode specific pins, such as
   pull-up/down, open drain etc, load capacitance configuration when controlled
   by software, etc.
@@ -193,6 +191,59 @@ structure, for example specific register ranges associated with each group
 and so on.
 
 
+Pin configuration
+=================
+
+Pins can sometimes be software-configured in an tremendous amount of ways,
+mostly related to their electronic properties when used as inputs or outputs.
+For example you may be able to make an output pin high impedance, or "tristate"
+meaning it is effectively disconnected. You may be able to connect an input pin
+to VDD or GND using a certain resistor value - pull up and pull down - so that
+the pin has a stable value when nothing is driving the rail it is connected
+to, or when it's unconnected.
+
+The pin control system supports an interface partly abstracting these
+properties while leaving the details to the pin control driver.
+
+For example, a driver can do this:
+
+ret = pin_config(128, PIN_CONFIG_BIAS_PULL_UP, 100000);
+
+To pull up a pin to VDD with a 100KOhm resistor. The driver implements
+callbacks for changing pin configuration in the pin controller ops like this:
+
+int foo_pin_config (struct pinctrl_dev *pctldev,
+		    unsigned pin,
+		    enum pin_config_param param,
+		    unsigned long data)
+{
+	switch (param) {
+	case PIN_CONFIG_BIAS_PULL_UP:
+	     ...
+}
+
+int foo_pin_config_group (struct pinctrl_dev *pctldev,
+		    unsigned selector,
+		    enum pin_config_param param,
+		    unsigned long data)
+{
+	...
+}
+
+static struct pinctrl_ops foo_pctrl_ops = {
+       ...
+       pin_config = foo_pin_config,
+       pin_config_group = foo_pin_config_group,
+};
+
+Since some controllers have special logic for handling entire groups of pins
+they can exploit the special whole-group pin control function. The
+pin_config_group() callback is allowed to return the error code -EAGAIN,
+for groups it does not want to handle, or if it just wants to do some
+group-level handling in which case each individual pin will be handled by
+separate pin_config() calls as well.
+
+
 Interaction with the GPIO subsystem
 ===================================
 
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 478a002..913f760 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -315,6 +315,75 @@ int pinctrl_get_group_selector(struct pinctrl_dev *pctldev,
 	return -EINVAL;
 }
 
+int pin_config(struct pinctrl_dev *pctldev, int pin,
+	       enum pin_config_param param, unsigned long data)
+{
+	const struct pinctrl_ops *ops = pctldev->desc->pctlops;
+
+	if (!ops->pin_config) {
+		dev_err(&pctldev->dev, "cannot configure pin, missing "
+			"config function in driver\n");
+		return -EINVAL;
+	}
+
+	return ops->pin_config(pctldev, pin, param, data);
+}
+
+int pin_config_group(struct pinctrl_dev *pctldev, const char *pin_group,
+		     enum pin_config_param param, unsigned long data)
+{
+	const struct pinctrl_ops *ops = pctldev->desc->pctlops;
+	int selector;
+	unsigned *pins;
+	unsigned num_pins;
+	int ret;
+	int i;
+
+	if (!ops->pin_config_group && !ops->pin_config) {
+		dev_err(&pctldev->dev, "cannot configure pin group, missing "
+			"config function in driver\n");
+		return -EINVAL;
+	}
+
+	selector = pinctrl_get_group_selector(pctldev, pin_group);
+	if (selector < 0)
+		return selector;
+
+	/*
+	 * If the pin controller supports handling entire groups we use that
+	 * capability.
+	 */
+	if (ops->pin_config_group) {
+		ret = ops->pin_config_group(pctldev, selector, param, data);
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
+	ret = ops->get_group_pins(pctldev, selector,
+				  &pins, &num_pins);
+	if (ret) {
+		dev_err(&pctldev->dev, "cannot configure pin group, error "
+			"getting pins\n");
+		return ret;
+	}
+
+	for (i = 0; i < num_pins; i++) {
+		ret = pin_config(pctldev, pins[i], param, data);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
 #ifdef CONFIG_DEBUG_FS
 
 static int pinctrl_pins_show(struct seq_file *s, void *what)
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 4f8d208..189c047 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -19,6 +19,87 @@
 #include <linux/list.h>
 #include <linux/seq_file.h>
 
+/**
+ * enum pin_config_param - possible pin configuration parameters
+ * @PIN_CONFIG_BIAS_UNKNOWN: this bias mode is not known to us
+ * @PIN_CONFIG_BIAS_FLOAT: no specific bias, the pin will float or state
+ *	is not controlled by software
+ * @PIN_CONFIG_BIAS_HIGH_IMPEDANCE: the pin will be set to a high impedance
+ *	mode, also know as "third-state" (tristate) or "high-Z" or "floating".
+ *	On output pins this effectively disconnects the pin, which is useful
+ *	if for example some other pin is going to drive the signal connected
+ *	to it for a while. Pins used for input are usually always high
+ *	impedance.
+ * @PIN_CONFIG_BIAS_PULL_UP: the pin will be pulled up (usually with high
+ *	impedance to VDD), if the controller supports specifying a certain
+ *	pull-up resistance, this is given as an argument (in Ohms) when
+ *	setting this parameter
+ * @PIN_CONFIG_BIAS_PULL_DOWN: the pin will be pulled down (usually with high
+ *	impedance to GROUND), if the controller supports specifying a certain
+ *	pull-down resistance, this is given as an argument (in Ohms) when
+ *	setting this parameter
+ * @PIN_CONFIG_BIAS_HIGH: the pin will be wired high, connected to VDD
+ * @PIN_CONFIG_BIAS_GROUND: the pin will be grounded, connected to GROUND
+ * @PIN_CONFIG_DRIVE_UNKNOWN: we don't know the drive mode of this pin, for
+ *	example since it is controlled by hardware or the information is not
+ *	accessible but we need a meaningful enumerator in e.g. initialization
+ *	code
+ * @PIN_CONFIG_DRIVE_PUSH_PULL: the pin will be driven actively high and
+ *	low, this is the most typical case and is typically achieved with two
+ *	active transistors on the output. If the pin can support different
+ *	drive strengths for push/pull, the strength is given on a custom format
+ *	as argument when setting pins to this mode
+ * @PIN_CONFIG_DRIVE_OPEN_DRAIN: the pin will be driven with open drain (open
+ *	collector) which means it is usually wired with other output ports
+ *	which are then pulled up with an external resistor. If the pin can
+ *	support different drive strengths for the open drain pin, the strength
+ *	is given on a custom format as argument when setting pins to this mode
+ * @PIN_CONFIG_DRIVE_OPEN_SOURCE: the pin will be driven with open drain
+ *	(open emitter) which is the same as open drain mutatis mutandis but
+ *	pulled to ground. If the pin can support different drive strengths for
+ *	the open drain pin, the strength is given on a custom format as
+ *	argument when setting pins to this mode
+ * @PIN_CONFIG_DRIVE_OFF: the pin is set to inactive drive mode, off
+ * @PIN_CONFIG_INPUT_SCHMITT: this will configure an input pin to run in
+ *	schmitt-trigger mode. If the schmitt-trigger has adjustable hysteresis,
+ *	the threshold value is given on a custom format as argument when
+ *	setting pins to this mode
+ * @PIN_CONFIG_SLEW_RATE_RISING: this will configure the slew rate for rising
+ *	signals on the pin. The argument gives the rise time in nanoseconds
+ * @PIN_CONFIG_SLEW_RATE_FALLING: this will configure the slew rate for falling
+ *	signals on the pin. The argument gives the fall time in nanoseconds
+ * @PIN_CONFIG_LOAD_CAPACITANCE: some pins have inductive characteristics and
+ *	will deform waveforms when signals are transmitted on them, by
+ *	applying a load capacitance, the waveform can be rectified. The
+ *	argument gives the load capacitance in picofarad (pF)
+ * @PIN_CONFIG_WAKEUP_ENABLE: this will configure an input pin such that if a
+ *	signal transition arrives at the pin when the pin controller/system
+ *	is sleeping, it will wake up the system
+ * @PIN_CONFIG_END: this is the last enumerator for pin configurations, if
+ *	you need to pass in custom configurations to the pin controller, use
+ *	PIN_CONFIG_END+1 as the base offset
+ */
+enum pin_config_param {
+	PIN_CONFIG_BIAS_UNKNOWN,
+	PIN_CONFIG_BIAS_FLOAT,
+	PIN_CONFIG_BIAS_HIGH_IMPEDANCE,
+	PIN_CONFIG_BIAS_PULL_UP,
+	PIN_CONFIG_BIAS_PULL_DOWN,
+	PIN_CONFIG_BIAS_HIGH,
+	PIN_CONFIG_BIAS_GROUND,
+	PIN_CONFIG_DRIVE_UNKNOWN,
+	PIN_CONFIG_DRIVE_PUSH_PULL,
+	PIN_CONFIG_DRIVE_OPEN_DRAIN,
+	PIN_CONFIG_DRIVE_OPEN_SOURCE,
+	PIN_CONFIG_DRIVE_OFF,
+	PIN_CONFIG_INPUT_SCHMITT,
+	PIN_CONFIG_SLEW_RATE_RISING,
+	PIN_CONFIG_SLEW_RATE_FALLING,
+	PIN_CONFIG_LOAD_CAPACITANCE,
+	PIN_CONFIG_WAKEUP_ENABLE,
+	PIN_CONFIG_END,
+};
+
 struct pinctrl_dev;
 struct pinmux_ops;
 struct gpio_chip;
@@ -66,6 +147,8 @@ struct pinctrl_gpio_range {
  * @get_group_name: return the group name of the pin group
  * @get_group_pins: return an array of pins corresponding to a certain
  *	group selector @pins, and the size of the array in @num_pins
+ * @pin_config: configure an individual pin
+ * @pin_config_group: configure all pins in a group
  * @pin_dbg_show: optional debugfs display hook that will provide per-device
  *	info for a certain pin in debugfs
  */
@@ -77,6 +160,14 @@ struct pinctrl_ops {
 			       unsigned selector,
 			       unsigned ** const pins,
 			       unsigned * const num_pins);
+	int (*pin_config) (struct pinctrl_dev *pctldev,
+			   unsigned pin,
+			   enum pin_config_param param,
+			   unsigned long data);
+	int (*pin_config_group) (struct pinctrl_dev *pctldev,
+				 unsigned selector,
+				 enum pin_config_param param,
+				 unsigned long data);
 	void (*pin_dbg_show) (struct pinctrl_dev *pctldev, struct seq_file *s,
 			  unsigned offset);
 };
@@ -113,6 +204,10 @@ extern struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 				struct device *dev, void *driver_data);
 extern void pinctrl_unregister(struct pinctrl_dev *pctldev);
 extern bool pin_is_valid(struct pinctrl_dev *pctldev, int pin);
+extern int pin_config(struct pinctrl_dev *pctldev, int pin,
+		      enum pin_config_param param, unsigned long data);
+extern int pin_config_group(struct pinctrl_dev *pctldev, const char *pin_group,
+			    enum pin_config_param param, unsigned long data);
 extern void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
 				struct pinctrl_gpio_range *range);
 extern void pinctrl_remove_gpio_range(struct pinctrl_dev *pctldev,
@@ -121,13 +216,26 @@ extern const char *pinctrl_dev_get_name(struct pinctrl_dev *pctldev);
 extern void *pinctrl_dev_get_drvdata(struct pinctrl_dev *pctldev);
 #else
 
-
-/* Sufficiently stupid default function when pinctrl is not in use */
+/* Sufficiently stupid default functions when pinctrl is not in use */
 static inline bool pin_is_valid(struct pinctrl_dev *pctldev, int pin)
 {
 	return pin >= 0;
 }
 
+static inline int pin_config(struct pinctrl_dev *pctldev, int pin,
+			     enum pin_config_param param, unsigned long data)
+{
+	return 0;
+}
+
+static inline int pin_config_group(struct pinctrl_dev *pctldev,
+				   const char *pin_group,
+				   enum pin_config_param param,
+				   unsigned long data)
+{
+	return 0;
+}
+
 #endif /* !CONFIG_PINCTRL */
 
 #endif /* __LINUX_PINCTRL_PINCTRL_H */
-- 
1.7.3.2

