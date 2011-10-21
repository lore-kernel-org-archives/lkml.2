Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab1JUS0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 14:26:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36031 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab1JUS0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 14:26:11 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rongjun Ying <Rongjun.Ying@csr.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] pinctrl: Add explicit gpio_disable_free pinmux_op
Date: Fri, 21 Oct 2011 12:25:53 -0600
Message-Id: <1319221553-15128-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some pinctrl drivers (Tegra at least) program a pin to be a GPIO in a
completely different manner than they select which function to mux out of
that pin. In order to support a single "free" pinmux_op, the driver would
need to maintain a per-pin state of requested-for-gpio vs. requested-for-
function. However, that's a lot of work when the core already has explicit
separate paths for gpio request/free and function request/free.

So, add a gpio_disable_free op to struct pinmux_ops, and make pin_free()
call it when appropriate.

When doing this, I noticed that when calling pin_request():

    !!gpio == (gpio_range != NULL)

... and so I collapsed those two parameters in both pin_request(), and
when adding writing the new code in pin_free().

Also, for pin_free():

    !!free_func == (gpio_range != NULL)

However, I didn't want pin_free() to know about the GPIO function naming
special case, so instead, I reworked pin_free() to always return the pin's
previously requested function, and now pinmux_free_gpio() calls
kfree(function). This is much more balanced with the allocation having
been performed in pinmux_request_gpio().

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/pinmux.c       |   39 +++++++++++++++++++++++++--------------
 include/linux/pinctrl/pinmux.h |    3 +++
 2 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index a5467f8..8a95e45 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -98,12 +98,11 @@ struct pinmux_hog {
  * @function: a functional name to give to this pin, passed to the driver
  *	so it knows what function to mux in, e.g. the string "gpioNN"
  *	means that you want to mux in the pin for use as GPIO number NN
- * @gpio: if this request concerns a single GPIO pin
  * @gpio_range: the range matching the GPIO pin if this is a request for a
  *	single GPIO pin
  */
 static int pin_request(struct pinctrl_dev *pctldev,
-		       int pin, const char *function, bool gpio,
+		       int pin, const char *function,
 		       struct pinctrl_gpio_range *gpio_range)
 {
 	struct pin_desc *desc;
@@ -152,7 +151,7 @@ static int pin_request(struct pinctrl_dev *pctldev,
 	 * If there is no kind of request function for the pin we just assume
 	 * we got it by default and proceed.
 	 */
-	if (gpio && ops->gpio_request_enable)
+	if (gpio_range && ops->gpio_request_enable)
 		/* This requests and enables a single GPIO pin */
 		status = ops->gpio_request_enable(pctldev, gpio_range, pin);
 	else if (ops->request)
@@ -182,29 +181,39 @@ out:
  * pin_free() - release a single muxed in pin so something else can be muxed
  * @pctldev: pin controller device handling this pin
  * @pin: the pin to free
- * @free_func: whether to free the pin's assigned function name string
+ * @gpio_range: the range matching the GPIO pin if this is a request for a
+ *	single GPIO pin
  */
-static void pin_free(struct pinctrl_dev *pctldev, int pin, int free_func)
+static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
+			    struct pinctrl_gpio_range *gpio_range)
 {
 	const struct pinmux_ops *ops = pctldev->desc->pmxops;
 	struct pin_desc *desc;
+	const char *func;
 
 	desc = pin_desc_get(pctldev, pin);
 	if (desc == NULL) {
 		dev_err(&pctldev->dev,
 			"pin is not registered so it cannot be freed\n");
-		return;
+		return NULL;
 	}
 
-	if (ops->free)
+	/*
+	 * If there is no kind of request function for the pin we just assume
+	 * we got it by default and proceed.
+	 */
+	if (gpio_range && ops->gpio_disable_free)
+		ops->gpio_disable_free(pctldev, gpio_range, pin);
+	else if (ops->free)
 		ops->free(pctldev, pin);
 
 	spin_lock(&desc->lock);
-	if (free_func)
-		kfree(desc->mux_function);
+	func = desc->mux_function;
 	desc->mux_function = NULL;
 	spin_unlock(&desc->lock);
 	module_put(pctldev->owner);
+
+	return func;
 }
 
 /**
@@ -234,7 +243,7 @@ int pinmux_request_gpio(unsigned gpio)
 	if (!function)
 		return -EINVAL;
 
-	ret = pin_request(pctldev, pin, function, true, range);
+	ret = pin_request(pctldev, pin, function, range);
 	if (ret < 0)
 		kfree(function);
 
@@ -252,6 +261,7 @@ void pinmux_free_gpio(unsigned gpio)
 	struct pinctrl_gpio_range *range;
 	int ret;
 	int pin;
+	const char *func;
 
 	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
 	if (ret)
@@ -260,7 +270,8 @@ void pinmux_free_gpio(unsigned gpio)
 	/* Convert to the pin controllers number space */
 	pin = gpio - range->base;
 
-	pin_free(pctldev, pin, true);
+	func = pin_free(pctldev, pin, range);
+	kfree(func);
 }
 EXPORT_SYMBOL_GPL(pinmux_free_gpio);
 
@@ -350,7 +361,7 @@ static int acquire_pins(struct pinctrl_dev *pctldev,
 
 	/* Try to allocate all pins in this group, one by one */
 	for (i = 0; i < num_pins; i++) {
-		ret = pin_request(pctldev, pins[i], func, false, NULL);
+		ret = pin_request(pctldev, pins[i], func, NULL);
 		if (ret) {
 			dev_err(&pctldev->dev,
 				"could not get pin %d for function %s "
@@ -360,7 +371,7 @@ static int acquire_pins(struct pinctrl_dev *pctldev,
 			/* On error release all taken pins */
 			i--; /* this pin just failed */
 			for (; i >= 0; i--)
-				pin_free(pctldev, pins[i], false);
+				pin_free(pctldev, pins[i], NULL);
 			return -ENODEV;
 		}
 	}
@@ -390,7 +401,7 @@ static void release_pins(struct pinctrl_dev *pctldev,
 		return;
 	}
 	for (i = 0; i < num_pins; i++)
-		pin_free(pctldev, pins[i], false);
+		pin_free(pctldev, pins[i], NULL);
 }
 
 /**
diff --git a/include/linux/pinctrl/pinmux.h b/include/linux/pinctrl/pinmux.h
index 3c430e7..350e32a 100644
--- a/include/linux/pinctrl/pinmux.h
+++ b/include/linux/pinctrl/pinmux.h
@@ -73,6 +73,9 @@ struct pinmux_ops {
 	int (*gpio_request_enable) (struct pinctrl_dev *pctldev,
 				    struct pinctrl_gpio_range *range,
 				    unsigned offset);
+	void (*gpio_disable_free) (struct pinctrl_dev *pctldev,
+				   struct pinctrl_gpio_range *range,
+				   unsigned offset);
 };
 
 /* External interface to pinmux */
-- 
1.7.0.4

