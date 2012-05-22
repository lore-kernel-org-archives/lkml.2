Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759157Ab2EVWYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:24:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50042 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab2EVWYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:24:01 -0400
Date: Wed, 23 May 2012 00:23:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Linus Walleij <linus.walleij@linaro.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] pinctrl: add a pinctrl_mux_group_selected() function
Message-ID: <Pine.LNX.4.64.1205230020210.11851@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:0EMfp7fHLtbh5znQI5ViXBo7EAuTRHlU+Mo7ZkFeYK9
 tPalXUpIUMVb8Tx+GyWJiQkZ8tIvF8pVqSp8ZuqG58vfUv/3Ze
 bYxhs8W7VoREhEfdH8UTAUAF8GD4LoD8iipo5jYBOTE9RvEE23
 7HGmheww140qLs7hNKbV//LWuDKo3uFp3g3YiRyDJUyFMHWjCM
 x86JcqHhXsRpk4yFMtVYOPnsmtkHZbtY5N5/GL9CfVRuUNNpK9
 HKeb1/iUAYhz/CotD5IKhhDJOGA4EDaCzqzQ463fbKGTpFeoSe
 MoItcdkHYpNFDGxYUzTNBX7mYny4gQfGojBjnPQToGuvyQA5Vh
 FlM6AZqzyiZzlMyzgdlN4WojsCMPlZy8WqGfyRiHJpuJ7QCzSV
 sCrwe2CR0MlUA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new function to allow clients to verify, whether a
certain group is selected in the currently active setting or not.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Maybe there is already a way to do this without adding a new function, I 
haven't found one, hence this patch.

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index ec3b8cc18..4e768d4 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -310,6 +310,32 @@ void pinctrl_remove_gpio_range(struct pinctrl_dev *pctldev,
 EXPORT_SYMBOL_GPL(pinctrl_remove_gpio_range);
 
 /**
+ * pinctrl_mux_group_selected() - check, whether a group is currently selected
+ */
+bool pinctrl_mux_group_selected(struct pinctrl *p, const char *group)
+{
+	struct pinctrl_setting *setting;
+
+	list_for_each_entry(setting, &p->state->settings, node) {
+		struct pinctrl_dev *pctldev = setting->pctldev;
+		const struct pinctrl_ops *ops = pctldev->desc->pctlops;
+		const char *gname;
+
+		if (setting->type != PIN_MAP_TYPE_MUX_GROUP)
+			continue;
+
+		gname = ops->get_group_name(pctldev, setting->data.mux.group);
+		if (!strcmp(gname, group)) {
+			dev_dbg(setting->pctldev->dev, "%s(): group %s found\n", __func__, group);
+			return true;
+		}
+	}
+	pr_debug("%s(): group %s not found\n", __func__, group);
+	return false;
+}
+EXPORT_SYMBOL_GPL(pinctrl_mux_group_selected);
+
+/**
  * pinctrl_get_group_selector() - returns the group selector for a group
  * @pctldev: the pin controller handling the group
  * @pin_group: the pin group to look up
diff --git a/include/linux/pinctrl/consumer.h b/include/linux/pinctrl/consumer.h
index 191e726..31d6c6f 100644
--- a/include/linux/pinctrl/consumer.h
+++ b/include/linux/pinctrl/consumer.h
@@ -35,6 +35,7 @@ extern struct pinctrl_state * __must_check pinctrl_lookup_state(
 							struct pinctrl *p,
 							const char *name);
 extern int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *s);
+extern bool pinctrl_mux_group_selected(struct pinctrl *p, const char *group);
 
 extern struct pinctrl * __must_check devm_pinctrl_get(struct device *dev);
 extern void devm_pinctrl_put(struct pinctrl *p);
