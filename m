Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945997Ab2ERNIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:08:19 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:11867
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945979Ab2ERNIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:08:16 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz154dMzz1202h1082kzz8275dhz2dh2a8h668h839hd24he5bhf0ah)
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>
Subject: [PATCH RFC v2 2/2] pinctrl: add pinctrl gpio binding support
Date: Fri, 18 May 2012 21:12:35 +0800
Message-ID: <1337346755-8761-2-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337346755-8761-1-git-send-email-b29396@freescale.com>
References: <1337346755-8761-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

The gpio ranges standard dt binding format is
<&gpio $gpio_offset $pin_offset $npin>

The core will parse and register the pinctrl gpio ranges
from device tree.

TODO: add binding doc.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

---
ChangeLog v1->v2:
* introduce standard binding for gpio range.
---
 drivers/pinctrl/devicetree.c    |   95 +++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/devicetree.h    |    3 -
 include/linux/pinctrl/pinctrl.h |   22 +++++++++
 3 files changed, 117 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
index fcb1de4..c1b87e6 100644
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
+ * @np: the device node contains the property @propname
+ * @propname: a list of phandles of gpios and corresponding data.
+ *  The format is: <&gpio0 $gpio_offset $pin_offset $count>
+ */
+int pinctrl_dt_add_gpio_ranges(struct pinctrl_dev *pctldev,
+				struct device_node *np,
+				const char *propname)
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
+	if (!np || !propname) {
+		dev_err(pctldev->dev, "no device node or gpios propname\n");
+		return -EINVAL;
+	}
+
+	prop = of_find_property(np, propname, &size);
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
+	nranges = size /4;
+	ranges = devm_kzalloc(pctldev->dev, nranges * sizeof(*ranges),
+				GFP_KERNEL);
+	for (i = 0; i < nranges; i++) {
+			phandle = be32_to_cpup(list++);
+			np_gpio = of_find_node_by_phandle(phandle);
+			if (!np_gpio) {
+				dev_err(pctldev->dev,
+					"failed to find gpio node(%s)\n",
+					np_gpio->name);
+				return -ENODEV;
+			}
+
+			ranges[i].gc = of_node_to_gpiochip(np_gpio);
+			if (!ranges[i].gc) {
+				dev_err(pctldev->dev,
+					"can not find gpio chip of node(%s)\n",
+					np->name);
+				of_node_put(np_gpio);
+				return -ENODEV;
+			}
+
+			gpio_offset = be32_to_cpu(*list++);
+			pin_offset = be32_to_cpu(*list++);
+			npins = be32_to_cpu(*list++);
+
+			if (gpio_offset < 0 ||
+			    gpio_offset > ranges[i].gc->ngpio ||
+			    pin_offset < 0 || npins < 0) {
+				dev_err(pctldev->dev,
+					"wrong data in the gpio range table\n");
+				of_node_put(np_gpio);
+				return -ENODEV;
+			}
+
+			ranges[i].name = dev_name(pctldev->dev);
+			ranges[i].base = ranges[i].gc->base + gpio_offset;
+			ranges[i].pin_base = pin_offset;
+			ranges[i].npins = npins;
+			of_node_put(np_gpio);
+	}
+
+	pinctrl_add_gpio_ranges(pctldev, ranges, nranges);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pinctrl_dt_add_gpio_ranges);
+
+void pinctrl_dt_remove_gpio_ranges(struct pinctrl_dev *pctldev,
+				   struct pinctrl_gpio_range *ranges,
+				   unsigned nranges)
+{
+	pinctrl_remove_gpio_ranges(pctldev, ranges, nranges);
+}
+EXPORT_SYMBOL_GPL(pinctrl_dt_remove_gpio_ranges);
diff --git a/drivers/pinctrl/devicetree.h b/drivers/pinctrl/devicetree.h
index 760bc49..9f79657 100644
--- a/drivers/pinctrl/devicetree.h
+++ b/drivers/pinctrl/devicetree.h
@@ -20,9 +20,7 @@
 
 void pinctrl_dt_free_maps(struct pinctrl *p);
 int pinctrl_dt_to_map(struct pinctrl *p);
-
 #else
-
 static inline int pinctrl_dt_to_map(struct pinctrl *p)
 {
 	return 0;
@@ -31,5 +29,4 @@ static inline int pinctrl_dt_to_map(struct pinctrl *p)
 static inline void pinctrl_dt_free_maps(struct pinctrl *p)
 {
 }
-
 #endif
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 6a29965..98d77b4 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -141,6 +141,28 @@ extern void pinctrl_remove_gpio_ranges(struct pinctrl_dev *pctldev,
 				unsigned nranges);
 extern const char *pinctrl_dev_get_name(struct pinctrl_dev *pctldev);
 extern void *pinctrl_dev_get_drvdata(struct pinctrl_dev *pctldev);
+
+#ifdef CONFIG_OF
+extern int pinctrl_dt_add_gpio_ranges(struct pinctrl_dev *pctldev,
+				struct device_node *np,
+				const char *propname);
+extern void pinctrl_dt_remove_gpio_ranges(struct pinctrl_dev *pctldev,
+				   struct pinctrl_gpio_range *ranges,
+				   unsigned nranges);
+#else
+static inline int pinctrl_dt_add_gpio_ranges(struct pinctrl_dev *pctldev,
+				struct device_node *np,
+				const char *propname)
+{
+	return 0;
+}
+static void pinctrl_dt_remove_gpio_ranges(struct pinctrl_dev *pctldev,
+				   struct pinctrl_gpio_range *ranges,
+				   unsigned nranges)
+{
+}
+#endif	/* !CONFIG_OF */
+
 #else
 
 struct pinctrl_dev;
-- 
1.7.0.4


