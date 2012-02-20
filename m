Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab2BTGq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:46:58 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5167 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab2BTGqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:46:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 19 Feb 2012 22:46:09 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: B29396@freescale.com, s.hauer@pengutronix.de, dongas86@gmail.com,
        shawn.guo@linaro.org, thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 05/20] pinctrl: Re-order pinmux.[ch] to match each-other
Date: Sun, 19 Feb 2012 23:45:45 -0700
Message-Id: <1329720360-23227-6-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify the two files so that the order of function prototypes in the
header matches the order of implementations in the .c file.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/pinmux.c |   56 +++++++++++++++++++++++-----------------------
 drivers/pinctrl/pinmux.h |   16 ++++++------
 2 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 24c4de1..2887897 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -40,6 +40,34 @@ struct pinmux_group {
 	unsigned group_selector;
 };
 
+int pinmux_check_ops(struct pinctrl_dev *pctldev)
+{
+	const struct pinmux_ops *ops = pctldev->desc->pmxops;
+	unsigned selector = 0;
+
+	/* Check that we implement required operations */
+	if (!ops->list_functions ||
+	    !ops->get_function_name ||
+	    !ops->get_function_groups ||
+	    !ops->enable ||
+	    !ops->disable)
+		return -EINVAL;
+
+	/* Check that all functions registered have names */
+	while (ops->list_functions(pctldev, selector) >= 0) {
+		const char *fname = ops->get_function_name(pctldev,
+							   selector);
+		if (!fname) {
+			pr_err("pinmux ops has no name for function%u\n",
+				selector);
+			return -EINVAL;
+		}
+		selector++;
+	}
+
+	return 0;
+}
+
 /**
  * pin_request() - request a single pin to be muxed in, typically for GPIO
  * @pin: the pin number in the global pin space
@@ -553,34 +581,6 @@ void pinmux_disable(struct pinctrl *p)
 	}
 }
 
-int pinmux_check_ops(struct pinctrl_dev *pctldev)
-{
-	const struct pinmux_ops *ops = pctldev->desc->pmxops;
-	unsigned selector = 0;
-
-	/* Check that we implement required operations */
-	if (!ops->list_functions ||
-	    !ops->get_function_name ||
-	    !ops->get_function_groups ||
-	    !ops->enable ||
-	    !ops->disable)
-		return -EINVAL;
-
-	/* Check that all functions registered have names */
-	while (ops->list_functions(pctldev, selector) >= 0) {
-		const char *fname = ops->get_function_name(pctldev,
-							   selector);
-		if (!fname) {
-			pr_err("pinmux ops has no name for function%u\n",
-				selector);
-			return -EINVAL;
-		}
-		selector++;
-	}
-
-	return 0;
-}
-
 #ifdef CONFIG_DEBUG_FS
 
 /* Called from pincontrol core */
diff --git a/drivers/pinctrl/pinmux.h b/drivers/pinctrl/pinmux.h
index 7680a17..84b8fe9 100644
--- a/drivers/pinctrl/pinmux.h
+++ b/drivers/pinctrl/pinmux.h
@@ -13,8 +13,6 @@
 #ifdef CONFIG_PINMUX
 
 int pinmux_check_ops(struct pinctrl_dev *pctldev);
-void pinmux_init_device_debugfs(struct dentry *devroot,
-				struct pinctrl_dev *pctldev);
 int pinmux_request_gpio(struct pinctrl_dev *pctldev,
 			struct pinctrl_gpio_range *range,
 			unsigned pin, unsigned gpio);
@@ -36,6 +34,8 @@ int pinmux_apply_muxmap(struct pinctrl_dev *pctldev,
 void pinmux_put(struct pinctrl *p);
 int pinmux_enable(struct pinctrl *p);
 void pinmux_disable(struct pinctrl *p);
+void pinmux_init_device_debugfs(struct dentry *devroot,
+				struct pinctrl_dev *pctldev);
 void pinmux_dbg_show(struct seq_file *s, struct pinctrl *p);
 
 #else
@@ -45,11 +45,6 @@ static inline int pinmux_check_ops(struct pinctrl_dev *pctldev)
 	return 0;
 }
 
-static inline void pinmux_init_device_debugfs(struct dentry *devroot,
-					      struct pinctrl_dev *pctldev)
-{
-}
-
 static inline int pinmux_request_gpio(struct pinctrl_dev *pctldev,
 			struct pinctrl_gpio_range *range,
 			unsigned pin, unsigned gpio)
@@ -95,7 +90,12 @@ static inline void pinmux_disable(struct pinctrl *p)
 {
 }
 
-void pinmux_dbg_show(struct seq_file *s, struct pinctrl *p)
+static inline void pinmux_init_device_debugfs(struct dentry *devroot,
+					      struct pinctrl_dev *pctldev)
+{
+}
+
+static inline void pinmux_dbg_show(struct seq_file *s, struct pinctrl *p)
 {
 }
 
-- 
1.7.5.4

