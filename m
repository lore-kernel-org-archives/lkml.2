Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab1KNJLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 04:11:05 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:51062 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752723Ab1KNJLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 04:11:03 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: indicate GPIO direction on single GPIO request
Date: Mon, 14 Nov 2011 10:10:37 +0100
Message-ID: <1321261837-31320-1-git-send-email-linus.walleij@stericsson.com>
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
input. So pass this info along for the gpio_request_enable()
function, we assume this is not needed for the gpio_free_disable()
function for the time being.

Suggested-by: Thomas Abraham <thomas.abraham@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinmux.c       |   16 +++++++++++-----
 include/linux/pinctrl/pinmux.h |   14 ++++++++++----
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index d27b77d..ef2f812 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -100,10 +100,13 @@ struct pinmux_hog {
  *	means that you want to mux in the pin for use as GPIO number NN
  * @gpio_range: the range matching the GPIO pin if this is a request for a
  *	single GPIO pin
+ * @gpio_direction: if the pin is muxed for GPIO, this provides the direction
+ *	of the GPIO @true means output, @false means input
  */
 static int pin_request(struct pinctrl_dev *pctldev,
 		       int pin, const char *function,
-		       struct pinctrl_gpio_range *gpio_range)
+		       struct pinctrl_gpio_range *gpio_range,
+		       bool gpio_direction)
 {
 	struct pin_desc *desc;
 	const struct pinmux_ops *ops = pctldev->desc->pmxops;
@@ -148,7 +151,8 @@ static int pin_request(struct pinctrl_dev *pctldev,
 	 */
 	if (gpio_range && ops->gpio_request_enable)
 		/* This requests and enables a single GPIO pin */
-		status = ops->gpio_request_enable(pctldev, gpio_range, pin);
+	  status = ops->gpio_request_enable(pctldev, gpio_range, pin,
+					    gpio_direction);
 	else if (ops->request)
 		status = ops->request(pctldev, pin);
 	else
@@ -218,8 +222,10 @@ static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
 /**
  * pinmux_request_gpio() - request a single pin to be muxed in as GPIO
  * @gpio: the GPIO pin number from the GPIO subsystem number space
+ * @direction: the direction of the GPIO, @true means output, @false
+ *	means input
  */
-int pinmux_request_gpio(unsigned gpio)
+int pinmux_request_gpio(unsigned gpio, bool direction)
 {
 	char gpiostr[16];
 	const char *function;
@@ -242,7 +248,7 @@ int pinmux_request_gpio(unsigned gpio)
 	if (!function)
 		return -EINVAL;
 
-	ret = pin_request(pctldev, pin, function, range);
+	ret = pin_request(pctldev, pin, function, range, direction);
 	if (ret < 0)
 		kfree(function);
 
@@ -360,7 +366,7 @@ static int acquire_pins(struct pinctrl_dev *pctldev,
 
 	/* Try to allocate all pins in this group, one by one */
 	for (i = 0; i < num_pins; i++) {
-		ret = pin_request(pctldev, pins[i], func, NULL);
+	  ret = pin_request(pctldev, pins[i], func, NULL, false);
 		if (ret) {
 			dev_err(&pctldev->dev,
 				"could not get pin %d for function %s "
diff --git a/include/linux/pinctrl/pinmux.h b/include/linux/pinctrl/pinmux.h
index bb7a979..7d3841f 100644
--- a/include/linux/pinctrl/pinmux.h
+++ b/include/linux/pinctrl/pinmux.h
@@ -54,7 +54,12 @@ struct pinctrl_dev;
  *	Implement this only if you can mux every pin individually as GPIO. The
  *	affected GPIO range is passed along with an offset(pin number) into that
  *	specific GPIO range - function selectors and pin groups are orthogonal
- *	to this, the core will however make sure the pins do not collide
+ *	to this, the core will however make sure the pins do not collide. Since
+ *	controllers may be needing different configurations depending on
+ *	whether the GPIO is configured as input or output, a direction
+ *	indicator is passed along
+ * @gpio_disable_free: free up GPIO muxing on a certain pin, the reverse of
+ *	@gpio_request_enable
  */
 struct pinmux_ops {
 	int (*request) (struct pinctrl_dev *pctldev, unsigned offset);
@@ -72,14 +77,15 @@ struct pinmux_ops {
 			 unsigned group_selector);
 	int (*gpio_request_enable) (struct pinctrl_dev *pctldev,
 				    struct pinctrl_gpio_range *range,
-				    unsigned offset);
+				    unsigned offset,
+				    bool direction);
 	void (*gpio_disable_free) (struct pinctrl_dev *pctldev,
 				   struct pinctrl_gpio_range *range,
 				   unsigned offset);
 };
 
 /* External interface to pinmux */
-extern int pinmux_request_gpio(unsigned gpio);
+extern int pinmux_request_gpio(unsigned gpio, bool direction);
 extern void pinmux_free_gpio(unsigned gpio);
 extern struct pinmux * __must_check pinmux_get(struct device *dev, const char *name);
 extern void pinmux_put(struct pinmux *pmx);
@@ -88,7 +94,7 @@ extern void pinmux_disable(struct pinmux *pmx);
 
 #else /* !CONFIG_PINMUX */
 
-static inline int pinmux_request_gpio(unsigned gpio)
+static inline int pinmux_request_gpio(unsigned gpio, bool direction)
 {
 	return 0;
 }
-- 
1.7.3.2

