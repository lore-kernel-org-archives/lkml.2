Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab2BTGrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:47:03 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19378 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab2BTGqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:46:52 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 19 Feb 2012 22:46:11 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: B29396@freescale.com, s.hauer@pengutronix.de, dongas86@gmail.com,
        shawn.guo@linaro.org, thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 06/20] pinctrl: Re-order pinconf.[ch] to match each-other
Date: Sun, 19 Feb 2012 23:45:46 -0700
Message-Id: <1329720360-23227-7-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify the two files so that the order of function prototypes in the
header matches the order of implementations in the .c file.

Don't prototype a couple of internal functions.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/pinconf.c |   31 +++++++++++++++----------------
 drivers/pinctrl/pinconf.h |    5 +----
 2 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index b74f64a..0c9d08d 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -23,7 +23,20 @@
 #include "core.h"
 #include "pinconf.h"
 
-int pin_config_get_for_pin(struct pinctrl_dev *pctldev, unsigned pin,
+int pinconf_check_ops(struct pinctrl_dev *pctldev)
+{
+	const struct pinconf_ops *ops = pctldev->desc->confops;
+
+	/* We must be able to read out pin status */
+	if (!ops->pin_config_get && !ops->pin_config_group_get)
+		return -EINVAL;
+	/* We have to be able to config the pins in SOME way */
+	if (!ops->pin_config_set && !ops->pin_config_group_set)
+		return -EINVAL;
+	return 0;
+}
+
+static int pin_config_get_for_pin(struct pinctrl_dev *pctldev, unsigned pin,
 			   unsigned long *config)
 {
 	const struct pinconf_ops *ops = pctldev->desc->confops;
@@ -63,7 +76,7 @@ int pin_config_get(const char *dev_name, const char *name,
 }
 EXPORT_SYMBOL(pin_config_get);
 
-int pin_config_set_for_pin(struct pinctrl_dev *pctldev, unsigned pin,
+static int pin_config_set_for_pin(struct pinctrl_dev *pctldev, unsigned pin,
 			   unsigned long config)
 {
 	const struct pinconf_ops *ops = pctldev->desc->confops;
@@ -138,7 +151,6 @@ int pin_config_group_get(const char *dev_name, const char *pin_group,
 }
 EXPORT_SYMBOL(pin_config_group_get);
 
-
 int pin_config_group_set(const char *dev_name, const char *pin_group,
 			 unsigned long config)
 {
@@ -205,19 +217,6 @@ int pin_config_group_set(const char *dev_name, const char *pin_group,
 }
 EXPORT_SYMBOL(pin_config_group_set);
 
-int pinconf_check_ops(struct pinctrl_dev *pctldev)
-{
-	const struct pinconf_ops *ops = pctldev->desc->confops;
-
-	/* We must be able to read out pin status */
-	if (!ops->pin_config_get && !ops->pin_config_group_get)
-		return -EINVAL;
-	/* We have to be able to config the pins in SOME way */
-	if (!ops->pin_config_set && !ops->pin_config_group_set)
-		return -EINVAL;
-	return 0;
-}
-
 #ifdef CONFIG_DEBUG_FS
 
 static void pinconf_dump_pin(struct pinctrl_dev *pctldev,
diff --git a/drivers/pinctrl/pinconf.h b/drivers/pinctrl/pinconf.h
index 006b77f..1d6ea9d 100644
--- a/drivers/pinctrl/pinconf.h
+++ b/drivers/pinctrl/pinconf.h
@@ -14,12 +14,9 @@
 #ifdef CONFIG_PINCONF
 
 int pinconf_check_ops(struct pinctrl_dev *pctldev);
+
 void pinconf_init_device_debugfs(struct dentry *devroot,
 				 struct pinctrl_dev *pctldev);
-int pin_config_get_for_pin(struct pinctrl_dev *pctldev, unsigned pin,
-			   unsigned long *config);
-int pin_config_set_for_pin(struct pinctrl_dev *pctldev, unsigned pin,
-			   unsigned long config);
 
 #else
 
-- 
1.7.5.4

