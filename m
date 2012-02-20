Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab2BTGrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:47:23 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19483 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab2BTGrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:47:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 19 Feb 2012 22:46:09 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: B29396@freescale.com, s.hauer@pengutronix.de, dongas86@gmail.com,
        shawn.guo@linaro.org, thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 04/20] pinctrl: Record a pin owner, not mux function, when requesting pins
Date: Sun, 19 Feb 2012 23:45:44 -0700
Message-Id: <1329720360-23227-5-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When pins are requested/acquired/got, some device becomes the owner of
their mux setting. At this point, it isn't certain which mux function
will be selected for the pin, since this may vary between each of the
device's states in the pinctrl mapping table. As such, we should record
the owning device, not what we think the initial mux setting will be,
when requesting pins.

This doesn't make a lot of difference right now since pinctrl_get gets
only one single device/state combination, but this will make a difference
when pinctrl_get gets all states, and pinctrl_select_state can switch
between states.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/core.h   |    2 +-
 drivers/pinctrl/pinmux.c |   71 ++++++++++++++++++++--------------------------
 2 files changed, 32 insertions(+), 41 deletions(-)

diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index a50cdb0..de4c3ed 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -94,7 +94,7 @@ struct pin_desc {
 	spinlock_t lock;
 	/* These fields only added when supporting pinmux drivers */
 #ifdef CONFIG_PINMUX
-	const char *mux_function;
+	const char *owner;
 #endif
 };
 
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 5a09cd2..24c4de1 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -43,21 +43,20 @@ struct pinmux_group {
 /**
  * pin_request() - request a single pin to be muxed in, typically for GPIO
  * @pin: the pin number in the global pin space
- * @function: a functional name to give to this pin, passed to the driver
- *	so it knows what function to mux in, e.g. the string "gpioNN"
- *	means that you want to mux in the pin for use as GPIO number NN
+ * @owner: a representation of the owner of this pin; typically the device
+ *	name that controls its mux function, or the requested GPIO name
  * @gpio_range: the range matching the GPIO pin if this is a request for a
  *	single GPIO pin
  */
 static int pin_request(struct pinctrl_dev *pctldev,
-		       int pin, const char *function,
+		       int pin, const char *owner,
 		       struct pinctrl_gpio_range *gpio_range)
 {
 	struct pin_desc *desc;
 	const struct pinmux_ops *ops = pctldev->desc->pmxops;
 	int status = -EINVAL;
 
-	dev_dbg(pctldev->dev, "request pin %d for %s\n", pin, function);
+	dev_dbg(pctldev->dev, "request pin %d for %s\n", pin, owner);
 
 	desc = pin_desc_get(pctldev, pin);
 	if (desc == NULL) {
@@ -66,19 +65,14 @@ static int pin_request(struct pinctrl_dev *pctldev,
 		goto out;
 	}
 
-	if (!function) {
-		dev_err(pctldev->dev, "no function name given\n");
-		return -EINVAL;
-	}
-
 	spin_lock(&desc->lock);
-	if (desc->mux_function) {
+	if (desc->owner && strcmp(desc->owner, owner)) {
 		spin_unlock(&desc->lock);
 		dev_err(pctldev->dev,
 			"pin already requested\n");
 		goto out;
 	}
-	desc->mux_function = function;
+	desc->owner = owner;
 	spin_unlock(&desc->lock);
 
 	/* Let each pin increase references to this module */
@@ -108,13 +102,13 @@ static int pin_request(struct pinctrl_dev *pctldev,
 out_free_pin:
 	if (status) {
 		spin_lock(&desc->lock);
-		desc->mux_function = NULL;
+		desc->owner = NULL;
 		spin_unlock(&desc->lock);
 	}
 out:
 	if (status)
 		dev_err(pctldev->dev, "pin-%d (%s) status %d\n",
-		       pin, function ? : "?", status);
+		       pin, owner, status);
 
 	return status;
 }
@@ -126,8 +120,8 @@ out:
  * @gpio_range: the range matching the GPIO pin if this is a request for a
  *	single GPIO pin
  *
- * This function returns a pointer to the function name in use. This is used
- * for callers that dynamically allocate a function name so it can be freed
+ * This function returns a pointer to the previous owner. This is used
+ * for callers that dynamically allocate an owner name so it can be freed
  * once the pin is free. This is done for GPIO request functions.
  */
 static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
@@ -135,7 +129,7 @@ static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
 {
 	const struct pinmux_ops *ops = pctldev->desc->pmxops;
 	struct pin_desc *desc;
-	const char *func;
+	const char *owner;
 
 	desc = pin_desc_get(pctldev, pin);
 	if (desc == NULL) {
@@ -154,12 +148,12 @@ static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
 		ops->free(pctldev, pin);
 
 	spin_lock(&desc->lock);
-	func = desc->mux_function;
-	desc->mux_function = NULL;
+	owner = desc->owner;
+	desc->owner = NULL;
 	spin_unlock(&desc->lock);
 	module_put(pctldev->owner);
 
-	return func;
+	return owner;
 }
 
 /**
@@ -173,19 +167,19 @@ int pinmux_request_gpio(struct pinctrl_dev *pctldev,
 			unsigned pin, unsigned gpio)
 {
 	char gpiostr[16];
-	const char *function;
+	const char *owner;
 	int ret;
 
 	/* Conjure some name stating what chip and pin this is taken by */
 	snprintf(gpiostr, 15, "%s:%d", range->name, gpio);
 
-	function = kstrdup(gpiostr, GFP_KERNEL);
-	if (!function)
+	owner = kstrdup(gpiostr, GFP_KERNEL);
+	if (!owner)
 		return -EINVAL;
 
-	ret = pin_request(pctldev, pin, function, range);
+	ret = pin_request(pctldev, pin, owner, range);
 	if (ret < 0)
-		kfree(function);
+		kfree(owner);
 
 	return ret;
 }
@@ -199,10 +193,10 @@ int pinmux_request_gpio(struct pinctrl_dev *pctldev,
 void pinmux_free_gpio(struct pinctrl_dev *pctldev, unsigned pin,
 		      struct pinctrl_gpio_range *range)
 {
-	const char *func;
+	const char *owner;
 
-	func = pin_free(pctldev, pin, range);
-	kfree(func);
+	owner = pin_free(pctldev, pin, range);
+	kfree(owner);
 }
 
 /**
@@ -232,17 +226,15 @@ int pinmux_gpio_direction(struct pinctrl_dev *pctldev,
 /**
  * acquire_pins() - acquire all the pins for a certain function on a pinmux
  * @pctldev: the device to take the pins on
- * @func_selector: the function selector to acquire the pins for
+ * @owner: a representation of the owner of this pin; typically the device
+ *	name that controls its mux function
  * @group_selector: the group selector containing the pins to acquire
  */
 static int acquire_pins(struct pinctrl_dev *pctldev,
-			unsigned func_selector,
+			const char *owner,
 			unsigned group_selector)
 {
 	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
-	const struct pinmux_ops *pmxops = pctldev->desc->pmxops;
-	const char *func = pmxops->get_function_name(pctldev,
-						     func_selector);
 	const unsigned *pins;
 	unsigned num_pins;
 	int ret;
@@ -258,11 +250,11 @@ static int acquire_pins(struct pinctrl_dev *pctldev,
 
 	/* Try to allocate all pins in this group, one by one */
 	for (i = 0; i < num_pins; i++) {
-		ret = pin_request(pctldev, pins[i], func, NULL);
+		ret = pin_request(pctldev, pins[i], owner, NULL);
 		if (ret) {
 			dev_err(pctldev->dev,
-				"could not get pin %d for function %s on device %s - conflicting mux mappings?\n",
-				pins[i], func ? : "(undefined)",
+				"could not get request pin %d on device %s - conflicting mux mappings?\n",
+				pins[i],
 				pinctrl_dev_get_name(pctldev));
 			/* On error release all taken pins */
 			i--; /* this pin just failed */
@@ -475,7 +467,7 @@ static int pinmux_enable_muxmap(struct pinctrl_dev *pctldev,
 	if (!grp)
 		return -ENOMEM;
 	grp->group_selector = group_selector;
-	ret = acquire_pins(pctldev, func_selector, group_selector);
+	ret = acquire_pins(pctldev, devname, group_selector);
 	if (ret) {
 		kfree(grp);
 		return ret;
@@ -630,7 +622,7 @@ static int pinmux_pins_show(struct seq_file *s, void *what)
 	unsigned i, pin;
 
 	seq_puts(s, "Pinmux settings per pin\n");
-	seq_puts(s, "Format: pin (name): pinmuxfunction\n");
+	seq_puts(s, "Format: pin (name): owner\n");
 
 	/* The pin number can be retrived from the pin controller descriptor */
 	for (i = 0; i < pctldev->desc->npins; i++) {
@@ -645,8 +637,7 @@ static int pinmux_pins_show(struct seq_file *s, void *what)
 
 		seq_printf(s, "pin %d (%s): %s\n", pin,
 			   desc->name ? desc->name : "unnamed",
-			   desc->mux_function ? desc->mux_function
-					      : "UNCLAIMED");
+			   desc->owner ? desc->owner : "UNCLAIMED");
 	}
 
 	return 0;
-- 
1.7.5.4

