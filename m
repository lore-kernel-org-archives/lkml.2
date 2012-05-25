Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab2EYNeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:34:03 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:48770
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754516Ab2EYNd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:33:59 -0400
X-SpamScore: -2
X-BigFish: VS-2(zz154dMzz1202h1082kzz8275dhz2dh2a8h668h839hd24he5bhf0ah)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>, <devicetree-discuss@lists.ozlabs.org>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <b29396@freescale.com>
Subject: [PATCH v4 6/6] pinctrl: add pinctrl gpio binding support
Date: Fri, 25 May 2012 21:36:20 +0800
Message-ID: <1337952980-14621-6-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337952980-14621-1-git-send-email-b29396@freescale.com>
References: <1337952980-14621-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

This patch implements a standard common binding for pinctrl gpio ranges.
Each SoC can add gpio ranges through device tree by adding a gpio-maps property
under their pinctrl devices node with the format:
<&gpio $gpio-specifier $pin_offset $count>
while the gpio phandle and gpio-specifier are the standard approach
to represent a gpio in device tree.
Then we can cooperate it with the gpio xlate function to get the gpio number
from device tree to set up the gpio ranges map.

Then the pinctrl driver can call pinctrl_dt_add_gpio_ranges(pctldev, node)
to parse and register the gpio ranges from device tree.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
Personally i'm not very satisfied with current solution due to a few reasons:
1) i can not user standard gpio api to get gpio number
2) i need to reinvent a new api of_parse_phandles_with_args_ext which i'm not
sure if it can be accepted by DT maintainer.
If i did not invent that API, i need to rewrite a lot of duplicated code
with slight differences with the exist functions like of_get_named_gpio_flags
and of_parse_phandle_with_args for the special pinctrl gpio maps format.

So i just sent it out first to see people's comment and if any better solution.

One alternative solution is that that the gpio-maps into two parts:
pinctrl-gpios = <&gpio_phandle gpio-specifier ..>
pinctrl-gpio-maps = <pin_id count ..>
Then we can reuse the standard gpio api altough it's not better than the
original one.

Comments are welcome!

ChangeLog v3->v4:
* using standard gpio parsing approach to get the gpio number from device
  tree. The gpio-maps becomes a little slightly different as before:
  <&gpio $gpio_specifier $pin_offset $npin>.
  The $gpio_specifier length is controller dependent which is specified by
  '#gpio-cells' in in gpio controller node.

ChangeLog v2->v3:
* standardise the gpio ranges node name to 'gpio-maps'. Each SoC should use this
node name to define gpio ranges.
* defer probe if can not get gpiochip from node in case gpio driver is still
not loaded.
* some other minor fixes suggested by Stephen Warren.

ChangeLog v1->v2:
* introduce standard binding for gpio range.
---
 .../bindings/pinctrl/pinctrl-bindings.txt          |   22 +++++
 drivers/pinctrl/devicetree.c                       |   95 ++++++++++++++++++++
 include/linux/pinctrl/pinctrl.h                    |   11 +++
 3 files changed, 128 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
index c95ea82..e999be5 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
@@ -126,3 +126,25 @@ device; they may be grandchildren, for example. Whether this is legal, and
 whether there is any interaction between the child and intermediate parent
 nodes, is again defined entirely by the binding for the individual pin
 controller device.
+
+=== pinctrl gpio ranges ===
+Some pins in pinctrl device can also be multiplexed as gpio. With a gpio range
+map, user can know which pin in the range can be used as gpio.
+
+Required properties:
+gpio-maps: integers array, each entry in the array represents a gpio range
+with the format: <&gpio $gpio-specifier $pin_offset $count>
+- gpio: phandle pointing at gpio device node
+- gpio-specifier: array of #gpio-cells specifying specific gpio, the length is
+  controller specific. Usually it may be two cells for simple gpio.
+- pin_offset: integer, the pin offset or pin id
+- npins: integer, the gpio ranges starting from pin_offset
+
+For example:
+pincontroller {
+	/* gpio-specifier is two cells */
+	gpio-maps = <&gpio1 0 0 0 32
+		     &gpio2 0 0 0 30
+		     &gpio3 1 0 100 1
+		     ....>;
+};
diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
index fcb1de4..bc5f0f8 100644
--- a/drivers/pinctrl/devicetree.c
+++ b/drivers/pinctrl/devicetree.c
@@ -17,7 +17,9 @@
  */
 
 #include <linux/device.h>
+#include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_gpio.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/slab.h>
 
@@ -247,3 +249,96 @@ err:
 	pinctrl_dt_free_maps(p);
 	return ret;
 }
+
+/*
+ * pinctrl_dt_add_gpio_range() - parse and register GPIO ranges from device tree
+ * @pctldev: pin controller device to add the range to
+ * @np: the device node contains the gpio-maps node
+ *  The format of gpio-maps should be:
+ *  <&gpio $gpio-specifier $pin_offset $count>
+ *  The gpio-specifier length is controller dependent which is specified by
+ *  #gpio-cells in in gpio controller node.
+ */
+int pinctrl_dt_add_gpio_ranges(struct pinctrl_dev *pctldev,
+				struct device_node *np)
+{
+	struct pinctrl_gpio_range *ranges;
+	unsigned int gpio_offset, pin_offset, npins;
+	struct device_node *np_gpio;
+	struct of_phandle_args gpiospec;
+	struct property *prop;
+	const __be32 *list;
+	phandle phandle;
+	int nranges = 0;
+	int size;
+	int i;
+	int ret;
+
+	if (!np) {
+		dev_err(pctldev->dev, "no device node\n");
+		return -EINVAL;
+	}
+
+	/* count gpio ranges */
+	do {
+		ret = of_parse_phandle_with_args_ext(np, "gpio-maps", "#gpio-cells",
+						 nranges, 2, NULL);
+		if (ret)
+			break;
+	} while (++nranges);
+
+	if (!nranges) {
+		dev_err(pctldev->dev, "no gpio ranges found\n");
+		return -ENODEV;
+	}
+
+	/* setup gpio ranges table */
+	ranges = devm_kzalloc(pctldev->dev, nranges * sizeof(*ranges),
+				GFP_KERNEL);
+	for (i = 0; i < nranges; i++) {
+		ret = of_parse_phandle_with_args_ext(np, "gpio-maps", "#gpio-cells",
+						 i, 2, &gpiospec);
+		if (ret)
+			return ret;
+
+		ranges[i].gc = of_node_to_gpiochip(gpiospec.np);
+		if (!ranges[i].gc) {
+			dev_err(pctldev->dev,
+				"can not find gpio chip of node(%s)\n",
+				gpiospec.np->full_name);
+			ret = -EPROBE_DEFER;
+			goto out;
+		}
+
+		if (!ranges[i].gc->of_xlate) {
+			dev_err(pctldev->dev,
+				"no of_xlate function found for gpio(%s)\n",
+				gpiospec.np->full_name);
+			ret = -EINVAL;
+			goto out;
+		}
+
+		ranges[i].name = dev_name(pctldev->dev);
+		ranges[i].base = ranges[i].gc->of_xlate(ranges[i].gc, &gpiospec, NULL);
+		if (ranges[i].base < 0) {
+			ret = -EINVAL;
+			goto out;
+		}
+		ranges[i].base += ranges[i].gc->base;
+		ranges[i].pin_base = gpiospec.args[gpiospec.args_count - 2];
+		ranges[i].npins = gpiospec.args[gpiospec.args_count - 1];
+
+		gpiochip_put(ranges[i].gc);
+		of_node_put(gpiospec.np);
+	}
+
+	pinctrl_add_gpio_ranges(pctldev, ranges, nranges);
+
+	return 0;
+
+out:
+	of_node_put(gpiospec.np);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pinctrl_dt_add_gpio_ranges);
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 3b894a6..947ab9f 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -135,6 +135,17 @@ extern void pinctrl_remove_gpio_range(struct pinctrl_dev *pctldev,
 				struct pinctrl_gpio_range *range);
 extern const char *pinctrl_dev_get_name(struct pinctrl_dev *pctldev);
 extern void *pinctrl_dev_get_drvdata(struct pinctrl_dev *pctldev);
+#ifdef CONFIG_OF
+extern int pinctrl_dt_add_gpio_ranges(struct pinctrl_dev *pctldev,
+				struct device_node *np);
+#else
+static inline int pinctrl_dt_add_gpio_ranges(struct pinctrl_dev *pctldev,
+				struct device_node *np);
+{
+	return 0;
+}
+#endif	/* !CONFIG_OF */
+
 #else
 
 struct pinctrl_dev;
-- 
1.7.0.4


