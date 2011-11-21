Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab1KUNAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 08:00:25 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:33269 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752855Ab1KUNAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 08:00:24 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Igor Grinberg <grinberg@compulab.co.il>
Subject: [PATCH] pinctrl: GPIO direction support for muxing
Date: Mon, 21 Nov 2011 13:59:58 +0100
Message-ID: <1321880398-12605-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

When requesting a single GPIO pin to be muxed in, some controllers
will need to poke a different value into the control register
depending on whether the pin will be used for GPIO output or GPIO
input. So create pinmux counterparts to gpio_direction_[input|output]
in the pinctrl framework.

ChangeLog v1->v2:
- This also amends the documentation to make it clear the this
  function and associated machinery is *ONLY* intended as a backend
  to gpiolib machinery, not for everyone and his dog to start playing
  around with pins.
ChangeLog v2->v3:
- Don't pass an argument to the common request function, instead
  provide pinmux_* counterparts to the gpio_direction_[input|output]
  calls, simpler and anyone can understand it.

Cc: Igor Grinberg <grinberg@compulab.co.il>
Suggested-by: Thomas Abraham <thomas.abraham@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/pinctrl.txt      |   34 ++++++++++++++++-----
 drivers/pinctrl/pinmux.c       |   63 +++++++++++++++++++++++++++++++++++++++-
 include/linux/pinctrl/pinmux.h |   24 ++++++++++++++-
 3 files changed, 111 insertions(+), 10 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index 214b961..4a946ba 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -645,6 +645,17 @@ All the above functions are mandatory to implement for a pinmux driver.
 Pinmux interaction with the GPIO subsystem
 ==========================================
 
+The public pinmux API contains two functions named pinmux_request_gpio()
+and pinmux_free_gpio(). These two functions shall *ONLY* be called from
+gpiolib-based drivers as part of their gpio_request() and
+gpio_free() semantics. Likewise the pinmux_gpio_direction_[input|output]
+shall only be called from within respective gpio_direction_[input|output]
+gpiolib implementation.
+
+NOTE that platforms and individual driver shall *NOT* request GPIO pins to be
+muxed in. Instead, implement a proper gpiolib driver hand have that driver
+request proper muxing for its pins.
+
 The function list could become long, especially if you can convert every
 individual pin into a GPIO pin independent of any other pins, and then try
 the approach to define every pin as a function.
@@ -652,19 +663,26 @@ the approach to define every pin as a function.
 In this case, the function array would become 64 entries for each GPIO
 setting and then the device functions.
 
-For this reason there is an additional function a pinmux driver can implement
-to enable only GPIO on an individual pin: .gpio_request_enable(). The same
-.free() function as for other functions is assumed to be usable also for
-GPIO pins.
+For this reason there are two functions a pinmux driver can implement
+to enable only GPIO on an individual pin: .gpio_request_enable() and
+.gpio_disable_free().
 
 This function will pass in the affected GPIO range identified by the pin
 controller core, so you know which GPIO pins are being affected by the request
 operation.
 
-Alternatively it is fully allowed to use named functions for each GPIO
-pin, the pinmux_request_gpio() will attempt to obtain the function "gpioN"
-where "N" is the global GPIO pin number if no special GPIO-handler is
-registered.
+If you driver needs to have an indication from the framework of whether the
+GPIO pin shall be used for input or output you can implement the
+.gpio_set_direction() function. As described this shall be called from the
+gpiolib driver and the affected GPIO range, pin offset and desired direction
+will be passed along to this function.
+
+Alternatively to using these special functions, it is fully allowed to use
+named functions for each GPIO pin, the pinmux_request_gpio() will attempt to
+obtain the function "gpioN" where "N" is the global GPIO pin number if no
+special GPIO-handler is registered.
+
+The public functions to enable a certain GPIO pin
 
 
 Pinmux board/machine configuration
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index d27b77d..33d24b8 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -218,6 +218,10 @@ static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
 /**
  * pinmux_request_gpio() - request a single pin to be muxed in as GPIO
  * @gpio: the GPIO pin number from the GPIO subsystem number space
+ *
+ * This function should *ONLY* be used from gpiolib-based GPIO drivers,
+ * as part of their gpio_request() semantics, platforms and individual drivers
+ * shall *NOT* request GPIO pins to be muxed in.
  */
 int pinmux_request_gpio(unsigned gpio)
 {
@@ -253,6 +257,10 @@ EXPORT_SYMBOL_GPL(pinmux_request_gpio);
 /**
  * pinmux_free_gpio() - free a single pin, currently used as GPIO
  * @gpio: the GPIO pin number from the GPIO subsystem number space
+ *
+ * This function should *ONLY* be used from gpiolib-based GPIO drivers,
+ * as part of their gpio_free() semantics, platforms and individual drivers
+ * shall *NOT* request GPIO pins to be muxed out.
  */
 void pinmux_free_gpio(unsigned gpio)
 {
@@ -274,6 +282,59 @@ void pinmux_free_gpio(unsigned gpio)
 }
 EXPORT_SYMBOL_GPL(pinmux_free_gpio);
 
+static int pinmux_gpio_direction(unsigned gpio, bool input)
+{
+	struct pinctrl_dev *pctldev;
+	struct pinctrl_gpio_range *range;
+	const struct pinmux_ops *ops;
+	int ret;
+	int pin;
+
+	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
+	if (ret)
+		return ret;
+
+	ops = pctldev->desc->pmxops;
+
+	/* Convert to the pin controllers number space */
+	pin = gpio - range->base + range->pin_base;
+
+	if (ops->gpio_set_direction)
+		ret = ops->gpio_set_direction(pctldev, range, pin, input);
+	else
+		ret = 0;
+
+	return ret;
+}
+
+/**
+ * pinmux_gpio_direction_input() - request a GPIO pin to go into input mode
+ * @gpio: the GPIO pin number from the GPIO subsystem number space
+ *
+ * This function should *ONLY* be used from gpiolib-based GPIO drivers,
+ * as part of their gpio_direction_input() semantics, platforms and individual
+ * drivers shall *NOT* touch pinmux GPIO calls.
+ */
+int pinmux_gpio_direction_input(unsigned gpio)
+{
+	return pinmux_gpio_direction(gpio, true);
+}
+EXPORT_SYMBOL_GPL(pinmux_gpio_direction_input);
+
+/**
+ * pinmux_gpio_direction_output() - request a GPIO pin to go into output mode
+ * @gpio: the GPIO pin number from the GPIO subsystem number space
+ *
+ * This function should *ONLY* be used from gpiolib-based GPIO drivers,
+ * as part of their gpio_direction_output() semantics, platforms and individual
+ * drivers shall *NOT* touch pinmux GPIO calls.
+ */
+int pinmux_gpio_direction_output(unsigned gpio)
+{
+	return pinmux_gpio_direction(gpio, false);
+}
+EXPORT_SYMBOL_GPL(pinmux_gpio_direction_output);
+
 /**
  * pinmux_register_mappings() - register a set of pinmux mappings
  * @maps: the pinmux mappings table to register
@@ -360,7 +421,7 @@ static int acquire_pins(struct pinctrl_dev *pctldev,
 
 	/* Try to allocate all pins in this group, one by one */
 	for (i = 0; i < num_pins; i++) {
-		ret = pin_request(pctldev, pins[i], func, NULL);
+	  ret = pin_request(pctldev, pins[i], func, NULL);
 		if (ret) {
 			dev_err(&pctldev->dev,
 				"could not get pin %d for function %s "
diff --git a/include/linux/pinctrl/pinmux.h b/include/linux/pinctrl/pinmux.h
index bb7a979..604cb48 100644
--- a/include/linux/pinctrl/pinmux.h
+++ b/include/linux/pinctrl/pinmux.h
@@ -54,7 +54,13 @@ struct pinctrl_dev;
  *	Implement this only if you can mux every pin individually as GPIO. The
  *	affected GPIO range is passed along with an offset(pin number) into that
  *	specific GPIO range - function selectors and pin groups are orthogonal
- *	to this, the core will however make sure the pins do not collide
+ *	to this, the core will however make sure the pins do not collide.
+ * @gpio_disable_free: free up GPIO muxing on a certain pin, the reverse of
+ *	@gpio_request_enable
+ * @gpio_set_direction: Since controllers may be needing different
+ *	configurations depending on whether the GPIO is configured as input or
+ *	output, a direction selector function may be implemented as a backing
+ *	to the GPIO controllers that need pin muxing
  */
 struct pinmux_ops {
 	int (*request) (struct pinctrl_dev *pctldev, unsigned offset);
@@ -76,11 +82,17 @@ struct pinmux_ops {
 	void (*gpio_disable_free) (struct pinctrl_dev *pctldev,
 				   struct pinctrl_gpio_range *range,
 				   unsigned offset);
+	int (*gpio_set_direction) (struct pinctrl_dev *pctldev,
+				   struct pinctrl_gpio_range *range,
+				   unsigned offset,
+				   bool input);
 };
 
 /* External interface to pinmux */
 extern int pinmux_request_gpio(unsigned gpio);
 extern void pinmux_free_gpio(unsigned gpio);
+extern int pinmux_gpio_direction_input(unsigned gpio);
+extern int pinmux_gpio_direction_output(unsigned gpio);
 extern struct pinmux * __must_check pinmux_get(struct device *dev, const char *name);
 extern void pinmux_put(struct pinmux *pmx);
 extern int pinmux_enable(struct pinmux *pmx);
@@ -97,6 +109,16 @@ static inline void pinmux_free_gpio(unsigned gpio)
 {
 }
 
+static inline int pinmux_gpio_direction_input(unsigned gpio)
+{
+	return 0;
+}
+
+static inline int pinmux_gpio_direction_output(unsigned gpio)
+{
+	return 0;
+}
+
 static inline struct pinmux * __must_check pinmux_get(struct device *dev, const char *name)
 {
 	return NULL;
-- 
1.7.3.2

