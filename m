Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab2JVIQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:16:01 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:58379 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848Ab2JVIP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:15:58 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Loic Pallardy <loic.pallardy@st.com>
Subject: [PATCH] pinctrl: reserve pins when states are activated
Date: Mon, 22 Oct 2012 10:15:18 +0200
Message-ID: <1350893718-12336-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This switches the way that pins are reserved for multiplexing:

We used to do this when the map was parsed, at the creation of
the settings inside the pinctrl handle, in pinmux_map_to_setting().

However this does not work for us, because we want to use the
same set of pins with different devices at different times: the
current code assumes that the pin groups in a pinmux state will
only be used with one single device, albeit different groups can
be active at different times. For example if a single I2C driver
block is used to drive two different busses located on two
pin groups A and B, then the pins for all possible states of a
function are reserved when fetching the pinctrl handle: the
I2C bus can choose either set A or set B by a mux state at
runtime, but all pins in both group A and B (the superset) are
effectively reserved for that I2C function and mapped to the
device. Another device can never get in and use the pins in
group A, even if the device/function is using group B at the
moment.

Instead: let use reserve the pins when the state is activated
and drop them when the state is disabled, i.e. when we move to
another state. This way different devices/functions can use the
same pins at different times.

We know that this is an odd way of doing things, but we really
need to switch e.g. an SD-card slot to become a tracing output
sink at runtime: we plug in a special "tracing card" then mux
the pins that used to be an SD slot around to the tracing
unit and push out tracing data there instead of SD-card
traffic.

As a side effect pinmux_free_setting() is unused but the stubs
are kept for future additions of code.

Cc: Patrice Chotard <patrice.chotard@st.com>
Cc: Loic Pallardy <loic.pallardy@st.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Jean Nicolas Graux <jean-nicolas.graux@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- Keep pinmux_free_setting() stubs
---
 Documentation/pinctrl.txt |  4 ++-
 drivers/pinctrl/core.c    |  2 ++
 drivers/pinctrl/core.h    |  2 ++
 drivers/pinctrl/pinmux.c  | 67 ++++++++++++++++-------------------------------
 4 files changed, 29 insertions(+), 46 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index 3b4ee53..a1cd2f9 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -1193,4 +1193,6 @@ foo_switch()
 	...
 }
 
-The above has to be done from process context.
+The above has to be done from process context. The reservation of the pins
+will be done when the state is activated, so in effect one specific pin
+can be used by different functions at different times on a running system.
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 0f1ec9e..5c6dff2 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -563,6 +563,8 @@ static int add_setting(struct pinctrl *p, struct pinctrl_map const *map)
 		return -EPROBE_DEFER;
 	}
 
+	setting->dev_name = map->dev_name;
+
 	switch (map->type) {
 	case PIN_MAP_TYPE_MUX_GROUP:
 		ret = pinmux_map_to_setting(map, setting);
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 1f40ff6..12f5694 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -105,12 +105,14 @@ struct pinctrl_setting_configs {
  * @type: the type of setting
  * @pctldev: pin control device handling to be programmed. Not used for
  *   PIN_MAP_TYPE_DUMMY_STATE.
+ * @dev_name: the name of the device using this state
  * @data: Data specific to the setting type
  */
 struct pinctrl_setting {
 	struct list_head node;
 	enum pinctrl_map_type type;
 	struct pinctrl_dev *pctldev;
+	const char *dev_name;
 	union {
 		struct pinctrl_setting_mux mux;
 		struct pinctrl_setting_configs configs;
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 9301a7a..0ef01ee 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -314,14 +314,11 @@ int pinmux_map_to_setting(struct pinctrl_map const *map,
 {
 	struct pinctrl_dev *pctldev = setting->pctldev;
 	const struct pinmux_ops *pmxops = pctldev->desc->pmxops;
-	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
 	char const * const *groups;
 	unsigned num_groups;
 	int ret;
 	const char *group;
 	int i;
-	const unsigned *pins;
-	unsigned num_pins;
 
 	if (!pmxops) {
 		dev_err(pctldev->dev, "does not support mux function\n");
@@ -376,53 +373,12 @@ int pinmux_map_to_setting(struct pinctrl_map const *map,
 	}
 	setting->data.mux.group = ret;
 
-	ret = pctlops->get_group_pins(pctldev, setting->data.mux.group, &pins,
-				      &num_pins);
-	if (ret) {
-		dev_err(pctldev->dev,
-			"could not get pins for device %s group selector %d\n",
-			pinctrl_dev_get_name(pctldev), setting->data.mux.group);
-			return -ENODEV;
-	}
-
-	/* Try to allocate all pins in this group, one by one */
-	for (i = 0; i < num_pins; i++) {
-		ret = pin_request(pctldev, pins[i], map->dev_name, NULL);
-		if (ret) {
-			dev_err(pctldev->dev,
-				"could not request pin %d on device %s\n",
-				pins[i], pinctrl_dev_get_name(pctldev));
-			/* On error release all taken pins */
-			i--; /* this pin just failed */
-			for (; i >= 0; i--)
-				pin_free(pctldev, pins[i], NULL);
-			return -ENODEV;
-		}
-	}
-
 	return 0;
 }
 
 void pinmux_free_setting(struct pinctrl_setting const *setting)
 {
-	struct pinctrl_dev *pctldev = setting->pctldev;
-	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
-	const unsigned *pins;
-	unsigned num_pins;
-	int ret;
-	int i;
-
-	ret = pctlops->get_group_pins(pctldev, setting->data.mux.group,
-				      &pins, &num_pins);
-	if (ret) {
-		dev_err(pctldev->dev,
-			"could not get pins for device %s group selector %d\n",
-			pinctrl_dev_get_name(pctldev), setting->data.mux.group);
-		return;
-	}
-
-	for (i = 0; i < num_pins; i++)
-		pin_free(pctldev, pins[i], NULL);
+	/* This function is currently unused */
 }
 
 int pinmux_enable_setting(struct pinctrl_setting const *setting)
@@ -446,6 +402,22 @@ int pinmux_enable_setting(struct pinctrl_setting const *setting)
 		num_pins = 0;
 	}
 
+	/* Try to allocate all pins in this group, one by one */
+	for (i = 0; i < num_pins; i++) {
+		ret = pin_request(pctldev, pins[i], setting->dev_name, NULL);
+		if (ret) {
+			dev_err(pctldev->dev,
+				"could not request pin %d on device %s\n",
+				pins[i], pinctrl_dev_get_name(pctldev));
+			/* On error release all taken pins */
+			i--; /* this pin just failed */
+			for (; i >= 0; i--)
+				pin_free(pctldev, pins[i], NULL);
+			return -ENODEV;
+		}
+	}
+
+	/* Now that we have acquired the pins, encode the mux setting */
 	for (i = 0; i < num_pins; i++) {
 		desc = pin_desc_get(pctldev, pins[i]);
 		if (desc == NULL) {
@@ -482,6 +454,7 @@ void pinmux_disable_setting(struct pinctrl_setting const *setting)
 		num_pins = 0;
 	}
 
+	/* Flag the descs that no setting is active */
 	for (i = 0; i < num_pins; i++) {
 		desc = pin_desc_get(pctldev, pins[i]);
 		if (desc == NULL) {
@@ -493,6 +466,10 @@ void pinmux_disable_setting(struct pinctrl_setting const *setting)
 		desc->mux_setting = NULL;
 	}
 
+	/* And release the pins */
+	for (i = 0; i < num_pins; i++)
+		pin_free(pctldev, pins[i], NULL);
+
 	if (ops->disable)
 		ops->disable(pctldev, setting->data.mux.func, setting->data.mux.group);
 }
-- 
1.7.11.3

