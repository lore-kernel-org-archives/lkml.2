Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759909Ab1LOX50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 18:57:26 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53589 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759860Ab1LOX5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 18:57:24 -0500
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 2/2] pinctrl: Pass name instead of device to pin_config_*
Date: Thu, 15 Dec 2011 16:57:17 -0700
Message-Id: <1323993437-15149-2-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323993437-15149-1-git-send-email-swarren@nvidia.com>
References: <1323993437-15149-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Obtaining a "struct pinctrl_dev *" is difficult for code not directly
related to the pinctrl subsystem. However, the device name of the pinctrl
device is fairly well known. So, modify pin_config_*() to take the device
name instead of the "struct pinctrl_dev *".

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/pinconf.c       |   43 ++++++++++++++++++++++++++++++--------
 include/linux/pinctrl/pinconf.h |   16 +++++++-------
 2 files changed, 42 insertions(+), 17 deletions(-)

diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index 3ddd4e9..38c5b41 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -31,12 +31,18 @@
  *	current pin state, it can be used directly by drivers as a numeral, or
  *	it can be dereferenced to any struct.
  */
-int pin_config_get(struct pinctrl_dev *pctldev, const char *name,
+int pin_config_get(const char *dev_name, const char *name,
 			  unsigned long *config)
 {
-	const struct pinconf_ops *ops = pctldev->desc->confops;
+	struct pinctrl_dev *pctldev;
+	const struct pinconf_ops *ops;
 	int pin;
 
+	pctldev = get_pinctrl_dev_from_dev(NULL, dev_name);
+	if (!pctldev)
+		return -EINVAL;
+	ops = pctldev->desc->confops;
+
 	pin = pin_get_from_name(pctldev, name);
 	if (pin < 0)
 		return pin;
@@ -59,13 +65,19 @@ EXPORT_SYMBOL(pin_config_get);
  *	can be used directly by drivers as a numeral, or it can be dereferenced
  *	to any struct.
  */
-int pin_config_set(struct pinctrl_dev *pctldev, const char *name,
+int pin_config_set(const char *dev_name, const char *name,
 		   unsigned long config)
 {
-	const struct pinconf_ops *ops = pctldev->desc->confops;
+	struct pinctrl_dev *pctldev;
+	const struct pinconf_ops *ops;
 	int pin;
 	int ret;
 
+	pctldev = get_pinctrl_dev_from_dev(NULL, dev_name);
+	if (!pctldev)
+		return -EINVAL;
+	ops = pctldev->desc->confops;
+
 	pin = pin_get_from_name(pctldev, name);
 	if (pin < 0)
 		return pin;
@@ -87,12 +99,18 @@ int pin_config_set(struct pinctrl_dev *pctldev, const char *name,
 }
 EXPORT_SYMBOL(pin_config_set);
 
-int pin_config_group_get(struct pinctrl_dev *pctldev, const char *pin_group,
+int pin_config_group_get(const char *dev_name, const char *pin_group,
 			 unsigned long *config)
 {
-	const struct pinconf_ops *ops = pctldev->desc->confops;
+	struct pinctrl_dev *pctldev;
+	const struct pinconf_ops *ops;
 	int selector;
 
+	pctldev = get_pinctrl_dev_from_dev(NULL, dev_name);
+	if (!pctldev)
+		return -EINVAL;
+	ops = pctldev->desc->confops;
+
 	if (!ops || !ops->pin_config_group_get) {
 		dev_err(pctldev->dev, "cannot get configuration for pin "
 			"group, missing group config get function in "
@@ -109,17 +127,24 @@ int pin_config_group_get(struct pinctrl_dev *pctldev, const char *pin_group,
 EXPORT_SYMBOL(pin_config_group_get);
 
 
-int pin_config_group_set(struct pinctrl_dev *pctldev, const char *pin_group,
+int pin_config_group_set(const char *dev_name, const char *pin_group,
 			 unsigned long config)
 {
-	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
-	const struct pinconf_ops *ops = pctldev->desc->confops;
+	struct pinctrl_dev *pctldev;
+	const struct pinconf_ops *ops;
+	const struct pinctrl_ops *pctlops;
 	int selector;
 	const unsigned *pins;
 	unsigned num_pins;
 	int ret;
 	int i;
 
+	pctldev = get_pinctrl_dev_from_dev(NULL, dev_name);
+	if (!pctldev)
+		return -EINVAL;
+	ops = pctldev->desc->confops;
+	pctlops = pctldev->desc->pctlops;
+
 	if (!ops || (!ops->pin_config_group_set && !ops->pin_config_set)) {
 		dev_err(pctldev->dev, "cannot configure pin group, missing "
 			"config function in driver\n");
diff --git a/include/linux/pinctrl/pinconf.h b/include/linux/pinctrl/pinconf.h
index 8c2c88e..477922c 100644
--- a/include/linux/pinctrl/pinconf.h
+++ b/include/linux/pinctrl/pinconf.h
@@ -53,39 +53,39 @@ struct pinconf_ops {
 					   unsigned selector);
 };
 
-extern int pin_config_get(struct pinctrl_dev *pctldev, const char *name,
+extern int pin_config_get(const char *dev_name, const char *name,
 			  unsigned long *config);
-extern int pin_config_set(struct pinctrl_dev *pctldev, const char *name,
+extern int pin_config_set(const char *dev_name, const char *name,
 			  unsigned long config);
-extern int pin_config_group_get(struct pinctrl_dev *pctldev,
+extern int pin_config_group_get(const char *dev_name,
 				const char *pin_group,
 				unsigned long *config);
-extern int pin_config_group_set(struct pinctrl_dev *pctldev,
+extern int pin_config_group_set(const char *dev_name,
 				const char *pin_group,
 				unsigned long config);
 
 #else
 
-static inline int pin_config_get(struct pinctrl_dev *pctldev, const char *name,
+static inline int pin_config_get(const char *dev_name, const char *name,
 				 unsigned long *config)
 {
 	return 0;
 }
 
-static inline int pin_config_set(struct pinctrl_dev *pctldev, const char *name,
+static inline int pin_config_set(const char *dev_name, const char *name,
 				 unsigned long config)
 {
 	return 0;
 }
 
-static inline int pin_config_group_get(struct pinctrl_dev *pctldev,
+static inline int pin_config_group_get(const char *dev_name,
 				       const char *pin_group,
 				       unsigned long *config)
 {
 	return 0;
 }
 
-static inline int pin_config_group_set(struct pinctrl_dev *pctldev,
+static inline int pin_config_group_set(const char *dev_name,
 				       const char *pin_group,
 				       unsigned long config)
 {
-- 
1.7.0.4

