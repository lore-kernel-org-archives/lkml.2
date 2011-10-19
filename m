Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab1JSQVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 12:21:33 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:37964 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932156Ab1JSQVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 12:21:31 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, Stephen Warren <swarren@nvidia.com>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>
Cc: Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/2] pinctrl: move group lookup to core
Date: Wed, 19 Oct 2011 18:21:06 +0200
Message-ID: <1319041266-18690-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Now also the core needs to look up pin groups so move the lookup
function there and expose it in the internal header.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/core.c   |   31 +++++++++++++++++++++++++++++++
 drivers/pinctrl/core.h   |    2 ++
 drivers/pinctrl/pinmux.c |   35 ++---------------------------------
 3 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index b2eaf8d..478a002 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -284,6 +284,37 @@ void pinctrl_remove_gpio_range(struct pinctrl_dev *pctldev,
 	mutex_unlock(&pctldev->gpio_ranges_lock);
 }
 
+/**
+ * pinctrl_get_group_selector() - returns the group selector for a group
+ * @pctldev: the pin controller handling the group
+ * @pin_group: the pin group to look up
+ */
+int pinctrl_get_group_selector(struct pinctrl_dev *pctldev,
+			       const char *pin_group)
+{
+	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
+	unsigned group_selector = 0;
+
+	while (pctlops->list_groups(pctldev, group_selector) >= 0) {
+		const char *gname = pctlops->get_group_name(pctldev,
+							    group_selector);
+		if (!strcmp(gname, pin_group)) {
+			dev_dbg(&pctldev->dev,
+				"found group selector %u for %s\n",
+				group_selector,
+				pin_group);
+			return group_selector;
+		}
+
+		group_selector++;
+	}
+
+	dev_err(&pctldev->dev, "does not have pin group %s\n",
+		pin_group);
+
+	return -EINVAL;
+}
+
 #ifdef CONFIG_DEBUG_FS
 
 static int pinctrl_pins_show(struct seq_file *s, void *what)
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 17e0777..318f7a8 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -70,3 +70,5 @@ struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev, int pin);
 int pinctrl_get_device_gpio_range(unsigned gpio,
 				  struct pinctrl_dev **outdev,
 				  struct pinctrl_gpio_range **outrange);
+int pinctrl_get_group_selector(struct pinctrl_dev *pctldev,
+			       const char *pin_group);
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 6544d98..64e1cdf 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -385,37 +385,6 @@ static void release_pins(struct pinctrl_dev *pctldev,
 }
 
 /**
- * pinmux_get_group_selector() - returns the group selector for a group
- * @pctldev: the pin controller handling the group
- * @pin_group: the pin group to look up
- */
-static int pinmux_get_group_selector(struct pinctrl_dev *pctldev,
-				     const char *pin_group)
-{
-	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
-	unsigned group_selector = 0;
-
-	while (pctlops->list_groups(pctldev, group_selector) >= 0) {
-		const char *gname = pctlops->get_group_name(pctldev,
-							    group_selector);
-		if (!strcmp(gname, pin_group)) {
-			dev_dbg(&pctldev->dev,
-				"found group selector %u for %s\n",
-				group_selector,
-				pin_group);
-			return group_selector;
-		}
-
-		group_selector++;
-	}
-
-	dev_err(&pctldev->dev, "does not have pin group %s\n",
-		pin_group);
-
-	return -EINVAL;
-}
-
-/**
  * pinmux_check_pin_group() - check function and pin group combo
  * @pctldev: device to check the pin group vs function for
  * @func_selector: the function selector to check the pin group for, we have
@@ -456,7 +425,7 @@ static int pinmux_check_pin_group(struct pinctrl_dev *pctldev,
 			return ret;
 		if (num_groups < 1)
 			return -EINVAL;
-		ret = pinmux_get_group_selector(pctldev, groups[0]);
+		ret = pinctrl_get_group_selector(pctldev, groups[0]);
 		if (ret < 0) {
 			dev_err(&pctldev->dev,
 				"function %s wants group %s but the pin "
@@ -481,7 +450,7 @@ static int pinmux_check_pin_group(struct pinctrl_dev *pctldev,
 		"check if we have pin group %s on controller %s\n",
 		pin_group, pinctrl_dev_get_name(pctldev));
 
-	ret = pinmux_get_group_selector(pctldev, pin_group);
+	ret = pinctrl_get_group_selector(pctldev, pin_group);
 	if (ret < 0) {
 		dev_dbg(&pctldev->dev,
 			"%s does not support pin group %s with function %s\n",
-- 
1.7.3.2

