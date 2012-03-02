Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab2CBRB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:01:56 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:46269 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753981Ab2CBRBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:01:54 -0500
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
Subject: [PATCH] pinctrl: resurrect verbose pinmux-pins
Date: Fri, 2 Mar 2012 17:31:13 +0100
Message-ID: <1330705873-10798-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This reintroduces the verbosity in the pinmux-pins file, now this
file will list all pins, their names, owning device (and if it's
a hog) and also in applicable cases the function and group making
use of that pin right now.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/core.h   |    4 ++++
 drivers/pinctrl/pinmux.c |   34 +++++++++++++++++++++++++++++-----
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index e1dfdb3..0a52e39 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -12,6 +12,7 @@
 #include <linux/pinctrl/pinconf.h>
 
 struct pinctrl_gpio_range;
+struct pinmux_group;
 
 /**
  * struct pinctrl_dev - pin control class device
@@ -77,6 +78,8 @@ struct pinctrl {
  * @dynamic_name: if the name of this pin was dynamically allocated
  * @lock: a lock to protect the descriptor structure
  * @owner: the device holding this pin or NULL of no device has claimed it
+ * @grp: the pinmux group used for this pin if it is used by a pin group
+ *	or NULL
  */
 struct pin_desc {
 	struct pinctrl_dev *pctldev;
@@ -86,6 +89,7 @@ struct pin_desc {
 	/* These fields only added when supporting pinmux drivers */
 #ifdef CONFIG_PINMUX
 	const char *owner;
+	struct pinmux_group *grp;
 #endif
 };
 
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index f409f16..5785b09 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -76,11 +76,14 @@ int pinmux_check_ops(struct pinctrl_dev *pctldev)
  * @pin: the pin number in the global pin space
  * @owner: a representation of the owner of this pin; typically the device
  *	name that controls its mux function, or the requested GPIO name
+ * @grp: the pinmux group used for this pin or NULL of it is requested as
+ *	a GPIO pin
  * @gpio_range: the range matching the GPIO pin if this is a request for a
  *	single GPIO pin
  */
 static int pin_request(struct pinctrl_dev *pctldev,
 		       int pin, const char *owner,
+		       struct pinmux_group *grp,
 		       struct pinctrl_gpio_range *gpio_range)
 {
 	struct pin_desc *desc;
@@ -104,6 +107,7 @@ static int pin_request(struct pinctrl_dev *pctldev,
 		goto out;
 	}
 	desc->owner = owner;
+	desc->grp = grp;
 	spin_unlock(&desc->lock);
 
 	/* Let each pin increase references to this module */
@@ -181,6 +185,7 @@ static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
 	spin_lock(&desc->lock);
 	owner = desc->owner;
 	desc->owner = NULL;
+	desc->grp = NULL;
 	spin_unlock(&desc->lock);
 	module_put(pctldev->owner);
 
@@ -208,7 +213,7 @@ int pinmux_request_gpio(struct pinctrl_dev *pctldev,
 	if (!owner)
 		return -EINVAL;
 
-	ret = pin_request(pctldev, pin, owner, range);
+	ret = pin_request(pctldev, pin, owner, NULL, range);
 	if (ret < 0)
 		kfree(owner);
 
@@ -259,10 +264,12 @@ int pinmux_gpio_direction(struct pinctrl_dev *pctldev,
  * @pctldev: the device to take the pins on
  * @owner: a representation of the owner of this pin; typically the device
  *	name that controls its mux function
+ * @grp: the pinmux group that will use the pins
  * @group_selector: the group selector containing the pins to acquire
  */
 static int acquire_pins(struct pinctrl_dev *pctldev,
 			const char *owner,
+			struct pinmux_group *grp,
 			unsigned group_selector)
 {
 	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
@@ -281,7 +288,7 @@ static int acquire_pins(struct pinctrl_dev *pctldev,
 
 	/* Try to allocate all pins in this group, one by one */
 	for (i = 0; i < num_pins; i++) {
-		ret = pin_request(pctldev, pins[i], owner, NULL);
+		ret = pin_request(pctldev, pins[i], owner, grp, NULL);
 		if (ret) {
 			dev_err(pctldev->dev,
 				"could not get request pin %d on device %s - conflicting mux mappings?\n",
@@ -485,7 +492,7 @@ static int pinmux_enable_muxmap(struct pinctrl_dev *pctldev,
 		return -ENOMEM;
 	grp->func_selector = func_selector;
 	grp->group_selector = group_selector;
-	ret = acquire_pins(pctldev, devname, group_selector);
+	ret = acquire_pins(pctldev, devname, grp, group_selector);
 	if (ret) {
 		kfree(grp);
 		return ret;
@@ -606,13 +613,25 @@ static int pinmux_functions_show(struct seq_file *s, void *what)
 	return 0;
 }
 
+static void pinmux_pins_show_groupinfo(struct seq_file *s,
+				       struct pinctrl_dev *pctldev,
+				       struct pinmux_group *grp)
+{
+	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
+	const struct pinmux_ops *pmxops = pctldev->desc->pmxops;
+
+	seq_printf(s, " function: \"%s\" group: \"%s\"\n",
+		   pmxops->get_function_name(pctldev, grp->func_selector),
+		   pctlops->get_group_name(pctldev, grp->group_selector));
+}
+
 static int pinmux_pins_show(struct seq_file *s, void *what)
 {
 	struct pinctrl_dev *pctldev = s->private;
 	unsigned i, pin;
 
 	seq_puts(s, "Pinmux settings per pin\n");
-	seq_puts(s, "Format: pin (name): owner\n");
+	seq_puts(s, "Format: pin (name): owner [function]\n");
 
 	/* The pin number can be retrived from the pin controller descriptor */
 	for (i = 0; i < pctldev->desc->npins; i++) {
@@ -629,10 +648,15 @@ static int pinmux_pins_show(struct seq_file *s, void *what)
 		    !strcmp(desc->owner, pinctrl_dev_get_name(pctldev)))
 			is_hog = true;
 
-		seq_printf(s, "pin %d (%s): %s%s\n", pin,
+		seq_printf(s, "pin %d (%s): %s%s", pin,
 			   desc->name ? desc->name : "unnamed",
 			   desc->owner ? desc->owner : "UNCLAIMED",
 			   is_hog ? " (HOG)" : "");
+
+		if (desc->grp)
+			pinmux_pins_show_groupinfo(s, pctldev, desc->grp);
+		else
+			seq_printf(s, "\n");
 	}
 
 	return 0;
-- 
1.7.8

