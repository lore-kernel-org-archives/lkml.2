Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab2DKWqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 18:46:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41914 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374Ab2DKWpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 18:45:53 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 2/2] pinctrl: allow pctldevs to decode pin config in debugfs
Date: Wed, 11 Apr 2012 16:45:46 -0600
Message-Id: <1334184346-16377-2-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1334184346-16377-1-git-send-email-swarren@wwwdotorg.org>
References: <1334184346-16377-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Add a pinconf op so that pin controller drivers can decode their pin
config settings for debugfs.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/pinconf.c       |   31 +++++++++++++++++++++++++++----
 include/linux/pinctrl/pinconf.h |    3 +++
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index eb3a14f..b54e025 100644
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
index ec431f0..5e37de2 100644
--- a/include/linux/pinctrl/pinconf.h
+++ b/include/linux/pinctrl/pinconf.h
@@ -56,6 +56,9 @@ struct pinconf_ops {
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

