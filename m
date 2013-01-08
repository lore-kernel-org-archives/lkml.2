Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab3AHLGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 06:06:15 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:57787 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754918Ab3AHLGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 06:06:14 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v2] pinctrl: nomadik: Add "ste,config" property etc
Date: Tue, 8 Jan 2013 12:05:50 +0100
Message-ID: <1357643150-20250-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel Fernandez <gabriel.fernandez@stericsson.com>

The "ste,config" property will contain the pin config node.
It will be easier to define a pin configuration and use it by
reference without duplicating lines tedious.

Other cleanups to the initial DT patch. This will all be
squashed into the original DT submission.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Moved bias definition into the pin controller in the
  documentation.
---
 .../devicetree/bindings/pinctrl/ste,nomadik.txt    | 47 ++++++++++++++--------
 drivers/pinctrl/pinctrl-nomadik.c                  | 40 ++++++++++++------
 2 files changed, 58 insertions(+), 29 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt b/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
index 8639234..9a2f3f4 100644
--- a/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
+++ b/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
@@ -26,11 +26,12 @@ Optional subnode-properties:
 - ste,function: A string containing the name of the function to mux to the
   pin or group.
 
-- ste,input : <0/1/2/3>
+- ste,config: Handle of pin configuration node (e.g. ste,config = <&slpm_in_wkup_pdis>)
+
+- ste,input : <0/1/2>
 	0: input with no pull
 	1: input with pull up,
 	2: input with pull down,
-	3: input and keep last input configuration (no pull, pull up or pull down).
 
 - ste,output: <0/1/2>
 	0: output low,
@@ -41,10 +42,11 @@ Optional subnode-properties:
 	0: sleep mode disable,
 	1: sleep mode enable.
 
-- ste,sleep-input: <0/1/2>
+- ste,sleep-input: <0/1/2/3>
 	0: sleep input with no pull,
 	1: sleep input with pull up,
 	2: sleep input with pull down.
+	3: sleep input and keep last input configuration (no pull, pull up or pull down).
 
 - ste,sleep-output: <0/1/2>
 	0: sleep output low,
@@ -70,14 +72,34 @@ Example board file extract:
 		reg = <0x80157000 0x2000>;
 
 		pinctrl-names = "default";
-		pinctrl-0 = <&uart0_default_mode>;
+
+		slpm_in_wkup_pdis: slpm_in_wkup_pdis {
+			ste,sleep = <1>;
+			ste,sleep-input = <3>;
+			ste,sleep-wakeup = <1>;
+			ste,sleep-pull-disable = <0>;
+		};
+
+		slpm_out_hi_wkup_pdis: slpm_out_hi_wkup_pdis {
+			ste,sleep = <1>;
+			ste,sleep-output = <1>;
+			ste,sleep-wakeup = <1>;
+			ste,sleep-pull-disable = <0>;
+		};
+
+		slpm_out_wkup_pdis: slpm_out_wkup_pdis {
+			ste,sleep = <1>;
+			ste,sleep-output = <2>;
+			ste,sleep-wakeup = <1>;
+			ste,sleep-pull-disable = <0>;
+		};
 
 		uart0 {
 			uart0_default_mux: uart0_mux {
 				u0_default_mux {
 					ste,function = "u0";
 					ste,pins = "u0_a_1";
-					};
+				};
 			};
 			uart0_default_mode: uart0_default {
 				uart0_default_cfg1 {
@@ -93,24 +115,15 @@ Example board file extract:
 			uart0_sleep_mode: uart0_sleep {
 				uart0_sleep_cfg1 {
 					ste,pins = "GPIO0", "GPIO2";
-					ste,sleep = <0>;
-					ste,sleep-input = <0>;
-					ste,sleep-wakeup = <1>;
-					ste,sleep-pull-disable = <0>;
+					ste,config = <&slpm_in_wkup_pdis>;
 				};
 				uart0_sleep_cfg2 {
 					ste,pins = "GPIO1";
-					ste,sleep = <0>;
-					ste,sleep-output = <1>;
-					ste,sleep-wakeup = <1>;
-					ste,sleep-pull-disable = <0>;
+					ste,config = <&slpm_out_hi_wkup_pdis>;
 				};
 				uart0_sleep_cfg3 {
 					ste,pins = "GPIO3";
-					ste,sleep = <0>;
-					ste,sleep-output = <2>;
-					ste,sleep-wakeup = <1>;
-					ste,sleep-pull-disable = <0>;
+					ste,config = <&slpm_out_wkup_pdis>;
 				};
 			};
 		};
diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 451c1ab..314bcbe 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1659,36 +1659,52 @@ static const char *nmk_find_pin_name(struct pinctrl_dev *pctldev, const char *pi
 	return NULL;
 }
 
+static bool nmk_pinctrl_dt_get_config(struct device_node *np,
+		unsigned long *configs)
+{
+	bool has_config = 0;
+	unsigned long cfg = 0;
+	int i, val, ret;
+
+	for (i = 0; i < ARRAY_SIZE(nmk_cfg_params); i++) {
+		ret = of_property_read_u32(np,
+				nmk_cfg_params[i].property, &val);
+		if (ret != -EINVAL) {
+			if (nmk_dt_pin_config(i, val, &cfg) == 0) {
+				*configs |= cfg;
+				has_config = 1;
+			}
+		}
+	}
+
+	return has_config;
+}
+
 int nmk_pinctrl_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		struct device_node *np,
 		struct pinctrl_map **map,
 		unsigned *reserved_maps,
 		unsigned *num_maps)
 {
-	int ret, i;
+	int ret;
 	const char *function = NULL;
 	unsigned long configs = 0;
 	bool has_config = 0;
 	unsigned reserve = 0;
 	struct property *prop;
 	const char *group, *gpio_name;
+	struct device_node *np_config;
 
 	ret = of_property_read_string(np, "ste,function", &function);
 	if (ret >= 0)
 		reserve = 1;
 
-	for (i = 0; i < ARRAY_SIZE(nmk_cfg_params); i++) {
-		unsigned long cfg = 0;
-		int val;
+	has_config = nmk_pinctrl_dt_get_config(np, &configs);
+
+	np_config = of_parse_phandle(np, "ste,config", 0);
+	if (np_config)
+		has_config |= nmk_pinctrl_dt_get_config(np_config, &configs);
 
-		ret = of_property_read_u32(np, nmk_cfg_params[i].property, &val);
-		if (ret != -EINVAL) {
-			if (nmk_dt_pin_config(i, val, &cfg) == 0) {
-				configs |= cfg;
-				has_config = 1;
-			}
-		}
-	}
 	ret = of_property_count_strings(np, "ste,pins");
 	if (ret < 0)
 		goto exit;
-- 
1.7.11.3

