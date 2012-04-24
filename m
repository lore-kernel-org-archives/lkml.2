Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab2DXJXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 05:23:41 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:12220
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755632Ab2DXJXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 05:23:37 -0400
X-SpamScore: -2
X-BigFish: VS-2(zz154dMzz1202h1082kzz8275bh8275dhz2dh2a8h668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>, <s.hauer@pengutronix.de>
Subject: [PATCH v2 2/2] pinctrl: remove the old pinctrl dt dummy state interfaces
Date: Tue, 24 Apr 2012 17:33:43 +0800
Message-ID: <1335260023-15859-2-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335260023-15859-1-git-send-email-b29396@freescale.com>
References: <1335260023-15859-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

We already have pinctrl_provide_dummies, so remove the old
one to avoid diversity.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
ChangeLog v1->v2:
* No changes except reformed to a separate patch.

Hi Stephen,
I removed the old dt pinctrl dummy sate interface.
The purpose is to get a unified way to handle pinctrl dummy state.
One disadvantage is that we may not meet the requirement
that for platform which only want to use dummy state for some specific
devices while not affect others. For this case, it may reply on users
to refer to the pinctrl debug message to see which devices are using
dummy state while which are not.
However, if keep it we may have two type of user interface to handle
dummy state which i'm not sure is a good thing. And as regulator also
does not provide per device dummies, so i removed it first.

What's your suggestion on it?
I reform this clean up into a separate patch, if you do not like it,
we can drop it later.
---
 Documentation/pinctrl.txt       |   15 ++++-----------
 drivers/pinctrl/core.c          |   14 +++-----------
 drivers/pinctrl/core.h          |    3 +--
 drivers/pinctrl/devicetree.c    |   26 --------------------------
 include/linux/pinctrl/machine.h |   11 +----------
 5 files changed, 9 insertions(+), 60 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index e40f4b4..261c41a 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -845,17 +845,10 @@ static struct pinctrl_map __initdata mapping[] = {
 	PIN_MAP_MUX_CONFIGS_PIN("foo-i2c.0", PINCTRL_STATE_DEFAULT, "pinctrl-foo", "i2c0sda", i2c_pin_configs),
 };
 
-Finally, some devices expect the mapping table to contain certain specific
-named states. When running on hardware that doesn't need any pin controller
-configuration, the mapping table must still contain those named states, in
-order to explicitly indicate that the states were provided and intended to
-be empty. Table entry macro PIN_MAP_DUMMY_STATE serves the purpose of defining
-a named state without causing any pin controller to be programmed:
-
-static struct pinctrl_map __initdata mapping[] = {
-	PIN_MAP_DUMMY_STATE("foo-i2c.0", PINCTRL_STATE_DEFAULT),
-};
-
+Finally, for platforms without pinctrl driver support but run with the shared
+drivers using pinctrl, user can call pinctrl_provide_dummies in board file
+to tell the core if these platforms want the core to provide dummies rather
+than return an error.
 
 Complex mappings
 ================
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index c6d0fdb..4c739d4 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -543,9 +543,6 @@ static int add_setting(struct pinctrl *p, struct pinctrl_map const *map)
 	if (IS_ERR(state))
 		return PTR_ERR(state);
 
-	if (map->type == PIN_MAP_TYPE_DUMMY_STATE)
-		return 0;
-
 	setting = kzalloc(sizeof(*setting), GFP_KERNEL);
 	if (setting == NULL) {
 		dev_err(p->dev,
@@ -927,16 +924,13 @@ int pinctrl_register_map(struct pinctrl_map const *maps, unsigned num_maps,
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
@@ -1139,7 +1133,6 @@ static inline const char *map_type(enum pinctrl_map_type type)
 {
 	static const char * const names[] = {
 		"INVALID",
-		"DUMMY_STATE",
 		"MUX_GROUP",
 		"CONFIGS_PIN",
 		"CONFIGS_GROUP",
@@ -1166,9 +1159,8 @@ static int pinctrl_maps_show(struct seq_file *s, void *what)
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
index 849a844..0f72cb7 100644
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


