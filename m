Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab2CFAWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 19:22:32 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14618 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758070Ab2CFAW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 19:22:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 05 Mar 2012 16:22:23 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Olof Johansson <olof@lixom.net>, Colin Cross <ccross@android.com>
CC: Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 2/3] pinctrl: allow concurrent gpio and mux function ownership of pins
Date: Mon, 5 Mar 2012 17:22:15 -0700
Message-ID: <1330993336-9538-2-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330993336-9538-1-git-send-email-swarren@nvidia.com>
References: <1330993336-9538-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per recent updates to Documentation/gpio.txt, gpiolib drivers should
inform pinctrl when a GPIO is requested. pinctrl then marks that pin as
in-use for that GPIO function.

When an SoC muxes pins in a group, it's quite possible for the group to
contain e.g. 6 pins, but only 4 of them actually be needed by the HW
module that's mux'd to them. In this case, the other 2 pins could be
used as GPIOs. However, pinctrl marks all the pins within the group as
in-use by the selected mux function. To allow the expected gpiolib
interaction, separate the concepts of pin ownership into two parts: One
for the mux function and one for GPIO usage. Finally, allow those two
ownerships to exist in parallel.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: New patch.
---
 drivers/pinctrl/core.h   |   13 ++++----
 drivers/pinctrl/pinmux.c |   72 +++++++++++++++++++++++++++++++--------------
 2 files changed, 56 insertions(+), 29 deletions(-)

diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 5b3ff13..2d365a3 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -118,15 +118,15 @@ struct pinctrl_setting {
  * @name: a name for the pin, e.g. the name of the pin/pad/finger on a
  *	datasheet or such
  * @dynamic_name: if the name of this pin was dynamically allocated
- * @usecount: If zero, the pin is not claimed, and @owner should be NULL.
+ * @mux_usecount: If zero, the pin is not claimed, and @owner should be NULL.
  *	If non-zero, this pin is claimed by @owner. This field is an integer
  *	rather than a boolean, since pinctrl_get() might process multiple
  *	mapping table entries that refer to, and hence claim, the same group
  *	or pin, and each of these will increment the @usecount.
- * @owner: The name of the entity owning the pin. Typically, this is the name
- *	of the device that called pinctrl_get(). Alternatively, it may be the
- *	name of the GPIO passed to pinctrl_request_gpio().
+ * @mux_owner: The name of device that called pinctrl_get().
  * @mux_setting: The most recent selected mux setting for this pin, if any.
+ * @gpio_owner: If pinctrl_request_gpio() was called for this pin, this is
+ *	the name of the GPIO that "owns" this pin.
  */
 struct pin_desc {
 	struct pinctrl_dev *pctldev;
@@ -134,9 +134,10 @@ struct pin_desc {
 	bool dynamic_name;
 	/* These fields only added when supporting pinmux drivers */
 #ifdef CONFIG_PINMUX
-	unsigned usecount;
-	const char *owner;
+	unsigned mux_usecount;
+	const char *mux_owner;
 	const struct pinctrl_setting_mux *mux_setting;
+	const char *gpio_owner;
 #endif
 };
 
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 86e4017..4e62783 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -94,17 +94,28 @@ static int pin_request(struct pinctrl_dev *pctldev,
 		goto out;
 	}
 
-	if (desc->usecount && strcmp(desc->owner, owner)) {
-		dev_err(pctldev->dev,
-			"pin already requested\n");
-		goto out;
-	}
+	if (gpio_range) {
+		/* There's no need to support multiple GPIO requests */
+		if (desc->gpio_owner) {
+			dev_err(pctldev->dev,
+				"pin already requested\n");
+			goto out;
+		}
 
-	desc->usecount++;
-	if (desc->usecount > 1)
-		return 0;
+		desc->gpio_owner = owner;
+	} else {
+		if (desc->mux_usecount && strcmp(desc->mux_owner, owner)) {
+			dev_err(pctldev->dev,
+				"pin already requested\n");
+			goto out;
+		}
 
-	desc->owner = owner;
+		desc->mux_usecount++;
+		if (desc->mux_usecount > 1)
+			return 0;
+
+		desc->mux_owner = owner;
+	}
 
 	/* Let each pin increase references to this module */
 	if (!try_module_get(pctldev->owner)) {
@@ -135,9 +146,13 @@ static int pin_request(struct pinctrl_dev *pctldev,
 
 out_free_pin:
 	if (status) {
-		desc->usecount--;
-		if (!desc->usecount)
-			desc->owner = NULL;
+		if (gpio_range) {
+			desc->gpio_owner = NULL;
+		} else {
+			desc->mux_usecount--;
+			if (!desc->mux_usecount)
+				desc->mux_owner = NULL;
+		}
 	}
 out:
 	if (status)
@@ -172,9 +187,11 @@ static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
 		return NULL;
 	}
 
-	desc->usecount--;
-	if (desc->usecount)
-		return NULL;
+	if (!gpio_range) {
+		desc->mux_usecount--;
+		if (desc->mux_usecount)
+			return NULL;
+	}
 
 	/*
 	 * If there is no kind of request function for the pin we just assume
@@ -185,9 +202,15 @@ static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
 	else if (ops->free)
 		ops->free(pctldev, pin);
 
-	owner = desc->owner;
-	desc->owner = NULL;
-	desc->mux_setting = NULL;
+	if (gpio_range) {
+		owner = desc->gpio_owner;
+		desc->gpio_owner = NULL;
+	} else {
+		owner = desc->mux_owner;
+		desc->mux_owner = NULL;
+		desc->mux_setting = NULL;
+	}
+
 	module_put(pctldev->owner);
 
 	return owner;
@@ -493,7 +516,7 @@ static int pinmux_pins_show(struct seq_file *s, void *what)
 	unsigned i, pin;
 
 	seq_puts(s, "Pinmux settings per pin\n");
-	seq_puts(s, "Format: pin (name): owner\n");
+	seq_puts(s, "Format: pin (name): mux_owner gpio_owner hog?\n");
 
 	mutex_lock(&pinctrl_mutex);
 
@@ -508,13 +531,16 @@ static int pinmux_pins_show(struct seq_file *s, void *what)
 		if (desc == NULL)
 			continue;
 
-		if (desc->owner &&
-		    !strcmp(desc->owner, pinctrl_dev_get_name(pctldev)))
+		if (desc->mux_owner &&
+		    !strcmp(desc->mux_owner, pinctrl_dev_get_name(pctldev)))
 			is_hog = true;
 
-		seq_printf(s, "pin %d (%s): %s%s", pin,
+		seq_printf(s, "pin %d (%s): %s %s%s", pin,
 			   desc->name ? desc->name : "unnamed",
-			   desc->owner ? desc->owner : "UNCLAIMED",
+			   desc->mux_owner ? desc->mux_owner
+				: "(MUX UNCLAIMED)",
+			   desc->gpio_owner ? desc->gpio_owner
+				: "(GPIO UNCLAIMED)",
 			   is_hog ? " (HOG)" : "");
 
 		if (desc->mux_setting)
-- 
1.7.0.4

