Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab2LKOAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 09:00:25 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:56553 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753057Ab2LKOAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 09:00:23 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Julien Delacou <julien.delacou@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/2] pinctrl: add sleep mode management for hogs
Date: Tue, 11 Dec 2012 14:59:53 +0100
Message-ID: <1355234393-17368-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julien Delacou <julien.delacou@stericsson.com>

This fix allows handling sleep mode for hogged
pins in pinctrl. It provides functions to set pins
to sleep/default configurations according to their
current state from the individual pinctrl drivers.

Signed-off-by: Julien Delacou <julien.delacou@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/core.c          | 35 ++++++++++++++++++++++++++++++++---
 drivers/pinctrl/core.h          |  4 ++++
 include/linux/pinctrl/pinctrl.h |  2 ++
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 5cdee86..f9c50bb 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1055,6 +1055,28 @@ void pinctrl_unregister_map(struct pinctrl_map const *map)
 	}
 }
 
+/**
+ * pinctrl_force_sleep() - turn a given controller device into sleep state
+ * @pctldev: pin controller device
+ */
+int pinctrl_force_sleep(struct pinctrl_dev *pctldev)
+{
+	if (!IS_ERR(pctldev->p) && !IS_ERR(pctldev->hog_sleep))
+		return pinctrl_select_state(pctldev->p, pctldev->hog_sleep);
+	return 0;
+}
+
+/**
+ * pinctrl_force_default() - turn a given controller device into default state
+ * @pctldev: pin controller device
+ */
+int pinctrl_force_default(struct pinctrl_dev *pctldev)
+{
+	if (!IS_ERR(pctldev->p) && !IS_ERR(pctldev->hog_default))
+		return pinctrl_select_state(pctldev->p, pctldev->hog_default);
+	return 0;
+}
+
 #ifdef CONFIG_DEBUG_FS
 
 static int pinctrl_pins_show(struct seq_file *s, void *what)
@@ -1500,16 +1522,23 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 
 	pctldev->p = pinctrl_get_locked(pctldev->dev);
 	if (!IS_ERR(pctldev->p)) {
-		struct pinctrl_state *s =
+		pctldev->hog_default =
 			pinctrl_lookup_state_locked(pctldev->p,
 						    PINCTRL_STATE_DEFAULT);
-		if (IS_ERR(s)) {
+		if (IS_ERR(pctldev->hog_default)) {
 			dev_dbg(dev, "failed to lookup the default state\n");
 		} else {
-			if (pinctrl_select_state_locked(pctldev->p, s))
+			if (pinctrl_select_state_locked(pctldev->p,
+						pctldev->hog_default))
 				dev_err(dev,
 					"failed to select default state\n");
 		}
+
+		pctldev->hog_sleep =
+			pinctrl_lookup_state_locked(pctldev->p,
+						    PINCTRL_STATE_SLEEP);
+		if (IS_ERR(pctldev->hog_sleep))
+			dev_dbg(dev, "failed to lookup the sleep state\n");
 	}
 
 	mutex_unlock(&pinctrl_mutex);
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 12f5694..b5bbb09 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -30,6 +30,8 @@ struct pinctrl_gpio_range;
  * @driver_data: driver data for drivers registering to the pin controller
  *	subsystem
  * @p: result of pinctrl_get() for this device
+ * @hog_default: default state for pins hogged by this device
+ * @hog_sleep: sleep state for pins hogged by this device
  * @device_root: debugfs root for this device
  */
 struct pinctrl_dev {
@@ -41,6 +43,8 @@ struct pinctrl_dev {
 	struct module *owner;
 	void *driver_data;
 	struct pinctrl *p;
+	struct pinctrl_state *hog_default;
+	struct pinctrl_state *hog_sleep;
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *device_root;
 #endif
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 04d6700..814cb56 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -155,6 +155,8 @@ struct pinctrl_dev *of_pinctrl_get(struct device_node *np)
 
 extern const char *pinctrl_dev_get_name(struct pinctrl_dev *pctldev);
 extern void *pinctrl_dev_get_drvdata(struct pinctrl_dev *pctldev);
+extern int pinctrl_force_sleep(struct pinctrl_dev *pctldev);
+extern int pinctrl_force_default(struct pinctrl_dev *pctldev);
 #else
 
 struct pinctrl_dev;
-- 
1.7.11.3

