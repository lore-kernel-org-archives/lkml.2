Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab2DMQtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 12:49:17 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39319 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab2DMQtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 12:49:12 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2] pinctrl: allow pctldevs to decode pin config in debugfs
Date: Fri, 13 Apr 2012 10:49:06 -0600
Message-Id: <1334335746-3353-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Add a pinconf op so that pin controller drivers can decode their pin
config settings for debugfs.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: Add kerneldoc for pin_config_config_dbg_show op
---
 drivers/pinctrl/pinconf.c       |   31 +++++++++++++++++++++++++++----
 include/linux/pinctrl/pinconf.h |    5 +++++
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index 384dcc1..0133a69 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -379,8 +379,16 @@ int pinconf_apply_setting(struct pinctrl_setting const *setting)
 
 void pinconf_show_map(struct seq_file *s, struct pinctrl_map const *map)
 {
+	struct pinctrl_dev *pctldev;
+	const struct pinconf_ops *confops;
 	int i;
 
+	pctldev = get_pinctrl_dev_from_devname(map->ctrl_dev_name);
+	if (pctldev)
+		confops = pctldev->desc->confops;
+	else
+		confops = NULL;
+
 	switch (map->type) {
 	case PIN_MAP_TYPE_CONFIGS_PIN:
 		seq_printf(s, "pin ");
@@ -394,8 +402,15 @@ void pinconf_show_map(struct seq_file *s, struct pinctrl_map const *map)
 
 	seq_printf(s, "%s\n", map->data.configs.group_or_pin);
 
-	for (i = 0; i < map->data.configs.num_configs; i++)
-		seq_printf(s, "config %08lx\n", map->data.configs.configs[i]);
+	for (i = 0; i < map->data.configs.num_configs; i++) {
+		seq_printf(s, "config ");
+		if (confops && confops->pin_config_config_dbg_show)
+			confops->pin_config_config_dbg_show(pctldev, s,
+						map->data.configs.configs[i]);
+		else
+			seq_printf(s, "%08lx", map->data.configs.configs[i]);
+		seq_printf(s, "\n");
+	}
 }
 
 void pinconf_show_setting(struct seq_file *s,
@@ -403,6 +418,7 @@ void pinconf_show_setting(struct seq_file *s,
 {
 	struct pinctrl_dev *pctldev = setting->pctldev;
 	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
+	const struct pinconf_ops *confops = pctldev->desc->confops;
 	struct pin_desc *desc;
 	int i;
 
@@ -428,8 +444,15 @@ void pinconf_show_setting(struct seq_file *s,
 	 * FIXME: We should really get the pin controler to dump the config
 	 * values, so they can be decoded to something meaningful.
 	 */
-	for (i = 0; i < setting->data.configs.num_configs; i++)
-		seq_printf(s, " %08lx", setting->data.configs.configs[i]);
+	for (i = 0; i < setting->data.configs.num_configs; i++) {
+		seq_printf(s, " ");
+		if (confops && confops->pin_config_config_dbg_show)
+			confops->pin_config_config_dbg_show(pctldev, s,
+				setting->data.configs.configs[i]);
+		else
+			seq_printf(s, "%08lx",
+				   setting->data.configs.configs[i]);
+	}
 
 	seq_printf(s, "\n");
 }
diff --git a/include/linux/pinctrl/pinconf.h b/include/linux/pinctrl/pinconf.h
index ec431f0..7b9d5f0 100644
--- a/include/linux/pinctrl/pinconf.h
+++ b/include/linux/pinctrl/pinconf.h
@@ -33,6 +33,8 @@ struct seq_file;
  *	per-device info for a certain pin in debugfs
  * @pin_config_group_dbg_show: optional debugfs display hook that will provide
  *	per-device info for a certain group in debugfs
+ * @pin_config_config_dbg_show: optional debugfs display hook that will decode
+ *	and display a driver's pin configuration parameter
  */
 struct pinconf_ops {
 #ifdef CONFIG_GENERIC_PINCONF
@@ -56,6 +58,9 @@ struct pinconf_ops {
 	void (*pin_config_group_dbg_show) (struct pinctrl_dev *pctldev,
 					   struct seq_file *s,
 					   unsigned selector);
+	void (*pin_config_config_dbg_show) (struct pinctrl_dev *pctldev,
+					    struct seq_file *s,
+					    unsigned long config);
 };
 
 #endif
-- 
1.7.0.4

