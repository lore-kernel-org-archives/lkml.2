Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab1JSWTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:19:45 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60082 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab1JSWTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:19:41 -0400
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
Subject: [PATCH 4/4] pinctrl: Don't copy function name when requesting a pin
Date: Wed, 19 Oct 2011 16:19:28 -0600
Message-Id: <1319062768-26391-4-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319062768-26391-1-git-send-email-swarren@nvidia.com>
References: <1319062768-26391-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead, store a pointer to the currently assigned function.

This allows us to delete the mux_requested variable from pin_desc; a pin
is requested if its currently assigned function is non-NULL.

When a pin is requested as a GPIO rather than a regular function, the
assigned function name is dynamically constructed. In this case, we have
to kstrdup() the dynamically constructed name, so that mux_function doesn't
pointed at stack data. This requires pin_free to be told whether to free
the mux_function pointer or not.

This removes the hard-coded maximum function name length.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/core.h   |    3 +--
 drivers/pinctrl/pinmux.c |   36 +++++++++++++++++++++++-------------
 2 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index a493ba6..783c075 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -59,8 +59,7 @@ struct pin_desc {
 	spinlock_t lock;
 	/* These fields only added when supporting pinmux drivers */
 #ifdef CONFIG_PINMUX
-	bool	mux_requested;
-	char	mux_function[16];
+	const char *mux_function;
 #endif
 };
 
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 4679ae6..f139609 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -130,14 +130,13 @@ static int pin_request(struct pinctrl_dev *pctldev,
 	}
 
 	spin_lock(&desc->lock);
-	if (desc->mux_requested) {
+	if (desc->mux_function) {
 		spin_unlock(&desc->lock);
 		dev_err(&pctldev->dev,
 			"pin already requested\n");
 		goto out;
 	}
-	desc->mux_requested = true;
-	strncpy(desc->mux_function, function, sizeof(desc->mux_function));
+	desc->mux_function = function;
 	spin_unlock(&desc->lock);
 
 	/* Let each pin increase references to this module */
@@ -168,8 +167,7 @@ static int pin_request(struct pinctrl_dev *pctldev,
 out_free_pin:
 	if (status) {
 		spin_lock(&desc->lock);
-		desc->mux_requested = false;
-		desc->mux_function[0] = '\0';
+		desc->mux_function = NULL;
 		spin_unlock(&desc->lock);
 	}
 out:
@@ -184,8 +182,9 @@ out:
  * pin_free() - release a single muxed in pin so something else can be muxed
  * @pctldev: pin controller device handling this pin
  * @pin: the pin to free
+ * @free_func: whether to free the pin's assigned function name string
  */
-static void pin_free(struct pinctrl_dev *pctldev, int pin)
+static void pin_free(struct pinctrl_dev *pctldev, int pin, int free_func)
 {
 	const struct pinmux_ops *ops = pctldev->desc->pmxops;
 	struct pin_desc *desc;
@@ -201,8 +200,9 @@ static void pin_free(struct pinctrl_dev *pctldev, int pin)
 		ops->free(pctldev, pin);
 
 	spin_lock(&desc->lock);
-	desc->mux_requested = false;
-	desc->mux_function[0] = '\0';
+	if (free_func)
+		kfree(desc->mux_function);
+	desc->mux_function = NULL;
 	spin_unlock(&desc->lock);
 	module_put(pctldev->owner);
 }
@@ -214,6 +214,7 @@ static void pin_free(struct pinctrl_dev *pctldev, int pin)
 int pinmux_request_gpio(unsigned gpio)
 {
 	char gpiostr[16];
+	const char *function;
 	struct pinctrl_dev *pctldev;
 	struct pinctrl_gpio_range *range;
 	int ret;
@@ -229,7 +230,15 @@ int pinmux_request_gpio(unsigned gpio)
 	/* Conjure some name stating what chip and pin this is taken by */
 	snprintf(gpiostr, 15, "%s:%d", range->name, gpio);
 
-	return pin_request(pctldev, pin, gpiostr, true, range);
+	function = kstrdup(gpiostr, GFP_KERNEL);
+	if (!function)
+		return -EINVAL;
+
+	ret = pin_request(pctldev, pin, function, true, range);
+	if (ret < 0)
+		kfree(function);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(pinmux_request_gpio);
 
@@ -251,7 +260,7 @@ void pinmux_free_gpio(unsigned gpio)
 	/* Convert to the pin controllers number space */
 	pin = gpio - range->base;
 
-	pin_free(pctldev, pin);
+	pin_free(pctldev, pin, true);
 }
 EXPORT_SYMBOL_GPL(pinmux_free_gpio);
 
@@ -351,7 +360,7 @@ static int acquire_pins(struct pinctrl_dev *pctldev,
 			/* On error release all taken pins */
 			i--; /* this pin just failed */
 			for (; i >= 0; i--)
-				pin_free(pctldev, pins[i]);
+				pin_free(pctldev, pins[i], false);
 			return -ENODEV;
 		}
 	}
@@ -381,7 +390,7 @@ static void release_pins(struct pinctrl_dev *pctldev,
 		return;
 	}
 	for (i = 0; i < num_pins; i++)
-		pin_free(pctldev, pins[i]);
+		pin_free(pctldev, pins[i], false);
 }
 
 /**
@@ -1013,7 +1022,8 @@ static int pinmux_pins_show(struct seq_file *s, void *what)
 
 		seq_printf(s, "pin %d (%s): %s\n", pin,
 			   desc->name ? desc->name : "unnamed",
-			   desc->mux_requested ? desc->mux_function : "UNCLAIMED");
+			   desc->mux_function ? desc->mux_function
+					      : "UNCLAIMED");
 	}
 
 	return 0;
-- 
1.7.0.4

