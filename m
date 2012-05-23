Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759820Ab2EWNU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 09:20:27 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:3077 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866Ab2EWNUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 09:20:23 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz154dMzz1202h1082kzz8275dhz2dh2a8h668h839hd24he5bhf0ah)
X-FB-SS: 0,
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>
Subject: [PATCH RFC v3 3/3] pinctrl: add pinctrl gpio binding support
Date: Wed, 23 May 2012 21:22:42 +0800
Message-ID: <1337779362-31259-3-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337779362-31259-1-git-send-email-b29396@freescale.com>
References: <1337779362-31259-1-git-send-email-b29396@freescale.com>
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
<&gpio $gpio_offset $pin_offset $npin>.

Then the pinctrl driver can call pinctrl_dt_add_gpio_ranges(pctldev, node)
to parse and register the gpio ranges from device tree.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
ChangeLog v2->v3:
* standardise the gpio ranges node name to 'gpio-maps'. Each SoC should use this
  node name to define gpio ranges.
* defer probe if can not get gpiochip from node in case gpio driver is still
  not loaded.
* some other minor fixes suggested by Stephen Warren.

ChangeLog v1->v2:
* introduce standard binding for gpio range.
---
 .../bindings/pinctrl/pinctrl-bindings.txt          |   20 +++++
 drivers/pinctrl/devicetree.c                       |   83 ++++++++++++++++++++
 include/linux/pinctrl/pinctrl.h                    |   11 +++
 3 files changed, 114 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
index c95ea82..113c11e 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
@@ -126,3 +126,23 @@ device; they may be grandchildren, for example. Whether this is legal, and
 whether there is any interaction between the child and intermediate parent
 nodes, is again defined entirely by the binding for the individual pin
 controller device.
+
+=== pinctrl gpio ranges ===
+Some pins in pinctrl device can also be multiplexed as gpio. With a gpio range
+map, user can know which pin in the range can be used as gpio.
+
+Required properties:
+gpio-maps: 4 integers array, each entry in the array represents a gpio
+range with the format: <&gpio $gpio_offset $pin_offset $count>
+- gpio: phandle pointing at gpio device node
+- gpio_offset: integer, the local offset of $gpio
+- pin_offset: integer, the pin offset or pin id
+- npins: integer, the gpio ranges starting from pin_offset
+
+For example:
+pincontroller {
+	gpio-maps = <&gpio1 0 0 32
+		     &gpio2 0 0 30
+		     &gpio3 1 100 1
+		     ....>;
+};
diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
index fcb1de4..7979ec1 100644
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
 
@@ -247,3 +249,84 @@ err:
 	pinctrl_dt_free_maps(p);
 	return ret;
 }
+
+/*
+ * pinctrl_dt_add_gpio_range() - parse and register GPIO ranges from device tree
+ * @pctldev: pin controller device to add the range to
+ * @np: the device node contains the gpio-maps node
+ *  The format of gpio-maps should be:
+ *  <&gpio0 $gpio_offset $pin_offset $count>
+ */
+int pinctrl_dt_add_gpio_ranges(struct pinctrl_dev *pctldev,
+				struct device_node *np)
+{
+	struct pinctrl_gpio_range *ranges;
+	unsigned int gpio_offset, pin_offset, npins;
+	struct device_node *np_gpio;
+	struct property *prop;
+	const __be32 *list;
+	phandle phandle;
+	int nranges;
+	int size;
+	int i;
+
+	if (!np) {
+		dev_err(pctldev->dev, "no device node\n");
+		return -EINVAL;
+	}
+
+	prop = of_find_property(np, "gpio-maps", &size);
+	if (!prop)
+		return -ENODEV;
+
+	list = prop->value;
+	size /= sizeof(*list);
+	if (size % 4) {
+		dev_err(pctldev->dev, "wrong gpio range table format\n");
+		return -EINVAL;
+	}
+
+	nranges = size / 4;
+	ranges = devm_kzalloc(pctldev->dev, nranges * sizeof(*ranges),
+				GFP_KERNEL);
+	for (i = 0; i < nranges; i++) {
+		phandle = be32_to_cpup(list++);
+		np_gpio = of_find_node_by_phandle(phandle);
+		if (!np_gpio) {
+			dev_err(pctldev->dev,
+				"failed to find gpio node(%s)\n",
+				np_gpio->name);
+			return -ENODEV;
+		}
+
+		ranges[i].gc = of_node_to_gpiochip(np_gpio);
+		if (!ranges[i].gc) {
+			dev_err(pctldev->dev,
+				"can not find gpio chip of node(%s)\n",
+				np_gpio->name);
+			of_node_put(np_gpio);
+			return -EPROBE_DEFER;
+		}
+
+		of_node_put(np_gpio);
+
+		gpio_offset = be32_to_cpu(*list++);
+		pin_offset = be32_to_cpu(*list++);
+		npins = be32_to_cpu(*list++);
+
+		if (gpio_offset + npins > ranges[i].gc->ngpio) {
+			dev_err(pctldev->dev, "exceed the gpio range\n");
+			return -ENODEV;
+		}
+
+		ranges[i].name = dev_name(pctldev->dev);
+		ranges[i].base = ranges[i].gc->base + gpio_offset;
+		ranges[i].pin_base = pin_offset;
+		ranges[i].npins = npins;
+	}
+
+	pinctrl_add_gpio_ranges(pctldev, ranges, nranges);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pinctrl_dt_add_gpio_ranges);
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 69393a6..07c7763 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -136,6 +136,17 @@ extern void pinctrl_add_gpio_ranges(struct pinctrl_dev *pctldev,
 				unsigned nranges);
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


