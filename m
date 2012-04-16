Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab2DPOOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:14:23 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:35473
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754085Ab2DPOOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:14:21 -0400
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839hd24h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>
Subject: [PATCH 1/1] pinctrl: handle dummy state in core
Date: Mon, 16 Apr 2012 22:24:49 +0800
Message-ID: <1334586289-13078-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Remove dummy state user interface and handle it totally in core.
This can make it more easy to use by platforms which has neither pinctrl
driver support nor dt support.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 drivers/pinctrl/Kconfig         |    5 +++++
 drivers/pinctrl/core.c          |   25 +++++++++++++------------
 drivers/pinctrl/core.h          |    3 +--
 drivers/pinctrl/devicetree.c    |   26 --------------------------
 include/linux/pinctrl/machine.h |   11 +----------
 5 files changed, 20 insertions(+), 50 deletions(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 01557e7..9316c97 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -26,6 +26,11 @@ config DEBUG_PINCTRL
 	help
 	  Say Y here to add some extra checks and diagnostics to PINCTRL calls.
 
+config PINCTRL_DUMMY
+	bool "pinctrl dummy state support"
+	help
+	  Say Y here to allow the driver to run well without pinctrl support
+
 config PINCTRL_IMX
 	bool "Freescale IMX core pinctrl driver"
 	depends on ARCH_MXC
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 74a7843..d0313a9 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -523,9 +523,6 @@ static int add_setting(struct pinctrl *p, struct pinctrl_map const *map)
 	if (IS_ERR(state))
 		return PTR_ERR(state);
 
-	if (map->type == PIN_MAP_TYPE_DUMMY_STATE)
-		return 0;
-
 	setting = kzalloc(sizeof(*setting), GFP_KERNEL);
 	if (setting == NULL) {
 		dev_err(p->dev,
@@ -718,8 +715,17 @@ static struct pinctrl_state *pinctrl_lookup_state_locked(struct pinctrl *p,
 	struct pinctrl_state *state;
 
 	state = find_state(p, name);
-	if (!state)
+	if (!state) {
+#ifdef CONFIG_PINCTRL_DUMMY
+		/* create dummy state */
+		dev_dbg(p->dev, "using dummy pinctrl state (%s)\n", name);
+		state = create_state(p, name);
+		if (IS_ERR(state))
+			return state;
+#else
 		return ERR_PTR(-ENODEV);
+#endif
+	}
 
 	return state;
 }
@@ -842,16 +848,13 @@ int pinctrl_register_map(struct pinctrl_map const *maps, unsigned num_maps,
 			return -EINVAL;
 		}
 
-		if (maps[i].type != PIN_MAP_TYPE_DUMMY_STATE &&
-				!maps[i].ctrl_dev_name) {
+		if (!maps[i].ctrl_dev_name) {
 			pr_err("failed to register map %s (%d): no pin control device given\n",
 			       maps[i].name, i);
 			return -EINVAL;
 		}
 
 		switch (maps[i].type) {
-		case PIN_MAP_TYPE_DUMMY_STATE:
-			break;
 		case PIN_MAP_TYPE_MUX_GROUP:
 			ret = pinmux_validate_map(&maps[i], i);
 			if (ret < 0)
@@ -1054,7 +1057,6 @@ static inline const char *map_type(enum pinctrl_map_type type)
 {
 	static const char * const names[] = {
 		"INVALID",
-		"DUMMY_STATE",
 		"MUX_GROUP",
 		"CONFIGS_PIN",
 		"CONFIGS_GROUP",
@@ -1081,9 +1083,8 @@ static int pinctrl_maps_show(struct seq_file *s, void *what)
 			   map->dev_name, map->name, map_type(map->type),
 			   map->type);
 
-		if (map->type != PIN_MAP_TYPE_DUMMY_STATE)
-			seq_printf(s, "controlling device %s\n",
-				   map->ctrl_dev_name);
+		seq_printf(s, "controlling device %s\n",
+			   map->ctrl_dev_name);
 
 		switch (map->type) {
 		case PIN_MAP_TYPE_MUX_GROUP:
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 1f40ff6..4c23f19 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -103,8 +103,7 @@ struct pinctrl_setting_configs {
  * struct pinctrl_setting - an individual mux or config setting
  * @node: list node for struct pinctrl_settings's @settings field
  * @type: the type of setting
- * @pctldev: pin control device handling to be programmed. Not used for
- *   PIN_MAP_TYPE_DUMMY_STATE.
+ * @pctldev: pin control device handling to be programmed.
  * @data: Data specific to the setting type
  */
 struct pinctrl_setting {
diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
index fcb1de4..3ac360f 100644
--- a/drivers/pinctrl/devicetree.c
+++ b/drivers/pinctrl/devicetree.c
@@ -43,9 +43,6 @@ static void dt_free_map(struct pinctrl_dev *pctldev,
 	if (pctldev) {
 		struct pinctrl_ops *ops = pctldev->desc->pctlops;
 		ops->dt_free_map(pctldev, map, num_maps);
-	} else {
-		/* There is no pctldev for PIN_MAP_TYPE_DUMMY_STATE */
-		kfree(map);
 	}
 }
 
@@ -151,22 +148,6 @@ static int dt_to_map_one_config(struct pinctrl *p, const char *statename,
 	return dt_remember_or_free_map(p, statename, pctldev, map, num_maps);
 }
 
-static int dt_remember_dummy_state(struct pinctrl *p, const char *statename)
-{
-	struct pinctrl_map *map;
-
-	map = kzalloc(sizeof(*map), GFP_KERNEL);
-	if (!map) {
-		dev_err(p->dev, "failed to alloc struct pinctrl_map\n");
-		return -ENOMEM;
-	}
-
-	/* There is no pctldev for PIN_MAP_TYPE_DUMMY_STATE */
-	map->type = PIN_MAP_TYPE_DUMMY_STATE;
-
-	return dt_remember_or_free_map(p, statename, NULL, map, 1);
-}
-
 int pinctrl_dt_to_map(struct pinctrl *p)
 {
 	struct device_node *np = p->dev->of_node;
@@ -232,13 +213,6 @@ int pinctrl_dt_to_map(struct pinctrl *p)
 			if (ret < 0)
 				goto err;
 		}
-
-		/* No entries in DT? Generate a dummy state table entry */
-		if (!size) {
-			ret = dt_remember_dummy_state(p, statename);
-			if (ret < 0)
-				goto err;
-		}
 	}
 
 	return 0;
diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
index e4d1de7..7383946 100644
--- a/include/linux/pinctrl/machine.h
+++ b/include/linux/pinctrl/machine.h
@@ -18,7 +18,6 @@
 
 enum pinctrl_map_type {
 	PIN_MAP_TYPE_INVALID,
-	PIN_MAP_TYPE_DUMMY_STATE,
 	PIN_MAP_TYPE_MUX_GROUP,
 	PIN_MAP_TYPE_CONFIGS_PIN,
 	PIN_MAP_TYPE_CONFIGS_GROUP,
@@ -61,8 +60,7 @@ struct pinctrl_map_configs {
  *	This is the parameter passed to pinmux_lookup_state()
  * @type: the type of mapping table entry
  * @ctrl_dev_name: the name of the device controlling this specific mapping,
- *	the name must be the same as in your struct device*. This field is not
- *	used for PIN_MAP_TYPE_DUMMY_STATE
+ *	the name must be the same as in your struct device*.
  * @data: Data specific to the mapping type
  */
 struct pinctrl_map {
@@ -78,13 +76,6 @@ struct pinctrl_map {
 
 /* Convenience macros to create mapping table entries */
 
-#define PIN_MAP_DUMMY_STATE(dev, state) \
-	{								\
-		.dev_name = dev,					\
-		.name = state,						\
-		.type = PIN_MAP_TYPE_DUMMY_STATE,			\
-	}
-
 #define PIN_MAP_MUX_GROUP(dev, state, pinctrl, grp, func)		\
 	{								\
 		.dev_name = dev,					\
-- 
1.7.0.4


