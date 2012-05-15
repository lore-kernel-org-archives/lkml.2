Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab2EOOCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:02:19 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:23654 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753705Ab2EOOCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:02:17 -0400
X-SpamScore: -3
X-BigFish: VS-3(zzea8Nzz1202h1082kzz8275dhz2dh2a8h668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>, <shawn.guo@freescale.com>,
        <b29396@freescale.com>
Subject: [PATCH RFC 1/1] pinctrl: improve gpio support for dt
Date: Tue, 15 May 2012 22:07:19 +0800
Message-ID: <1337090839-21224-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

For dt, the gpio base may be dynamically allocated, thus the original
implementation of gpio support based on static gpio number and pin id
map may not be easy to use for dt.

One solution is a) use alias id for gpio node and refer to it in gpio
range, then we can get the fixed the gpio devices for this range and
b) get gpio chip from node which is specified in gpio range structure,
then get the dynamically allocated gpio chip base and c) using the chip
gpio base and offset to map to a physical pin id for dt.

To implement that, we need add two members in pinctrl_gpio_range structure,
'np' the gpio node for this range and 'off' the offset in this gpio range
of the gpio chip.

For devicetree, user can use this two member instead of range->base
to create the map, the core will dynamically set the correct range->base
based on the gpio base plus gpio offset.

For example:
static struct pinctrl_gpio_range imx28_gpio_ranges[] = {
	{ .name = "gpio", .id = 0, .pin_base = 0,   .npins = 8,	 .np = np_gpio0	.off = 0,},
	{ .name = "gpio", .id = 0, .pin_base = 16,  .npins = 13, .np = np_gpio0 .off = 16,},
	{ .name = "gpio", .id = 1, .pin_base = 32,  .npins = 32, .np = np_gpio1 .off = 16},
...

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
This is a proposal to start the discussion on whether we can find some common way
to ease adding pinctrl gpio support for dt.
Comments are wellcome.
---
 drivers/pinctrl/core.c          |   11 ++++++++-
 drivers/pinctrl/devicetree.c    |   47 +++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/devicetree.h    |    7 +++++
 include/linux/pinctrl/pinctrl.h |    7 +++++-
 4 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index c3b331b..8b882ad 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -323,12 +323,21 @@ static int pinctrl_get_device_gpio_range(unsigned gpio,
  * This adds a range of GPIOs to be handled by a certain pin controller. Call
  * this to register handled ranges after registering your pin controller.
  */
-void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
+int pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
 			    struct pinctrl_gpio_range *range)
 {
+	int ret;
+
+	/* first recalculate the gpio base for dt if need */
+	ret = pinctrl_recalculate_gpio_base(pctldev, range);
+	if (ret)
+		return ret;
+
 	mutex_lock(&pinctrl_mutex);
 	list_add_tail(&range->node, &pctldev->gpio_ranges);
 	mutex_unlock(&pinctrl_mutex);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(pinctrl_add_gpio_range);
 
diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
index fcb1de4..00015c7 100644
--- a/drivers/pinctrl/devicetree.c
+++ b/drivers/pinctrl/devicetree.c
@@ -18,6 +18,7 @@
 
 #include <linux/device.h>
 #include <linux/of.h>
+#include <linux/of_gpio.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/slab.h>
 
@@ -247,3 +248,49 @@ err:
 	pinctrl_dt_free_maps(p);
 	return ret;
 }
+
+int pinctrl_recalculate_gpio_base(struct pinctrl_dev *pctldev,
+				struct pinctrl_gpio_range *range)
+{
+	struct device_node *np,
+	int ret = 0;
+
+	if (!range->np || range->off < 0) {
+		dev_err(&pdev->dev, "no gpio node or invalid offset");
+		return -EINVAL;
+	}
+
+	np = range->np;
+	of_node_get(np);
+
+	id = of_alias_get_id(np, "gpio");
+	if (id < 0) {
+		dev_err(&pdev->dev,
+			"can not find alias id for node %s\n", np->name);
+		ret = id;
+		goto out;
+	}
+
+	if (range->id != id) {
+		dev_err(&pdev->dev,
+			"the range id(%d) does not match gpio(%s) alias id(%d)\n",
+			range->id, np->name, id);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	range->gc = of_node_to_gpiochip(np);
+	if (!range->gc) {
+		dev_err(pctldev->dev,
+			"can not find gpio chip of node(%s)\n",
+			np->name);
+		ret = -ENODEV;
+		goto out;
+	}
+	range->base = range->gc->base + range->off;
+
+out:
+	of_node_put(np);
+
+	return ret;
+}
diff --git a/drivers/pinctrl/devicetree.h b/drivers/pinctrl/devicetree.h
index 760bc49..d97ad43 100644
--- a/drivers/pinctrl/devicetree.h
+++ b/drivers/pinctrl/devicetree.h
@@ -21,6 +21,8 @@
 void pinctrl_dt_free_maps(struct pinctrl *p);
 int pinctrl_dt_to_map(struct pinctrl *p);
 
+int pinctrl_recalculate_gpio_base(struct pinctrl_dev *pctldev,
+				struct pinctrl_gpio_range *range);
 #else
 
 static inline int pinctrl_dt_to_map(struct pinctrl *p)
@@ -32,4 +34,9 @@ static inline void pinctrl_dt_free_maps(struct pinctrl *p)
 {
 }
 
+static inline int pinctrl_recalculate_gpio_base(struct pinctrl_dev *pctldev,
+				struct pinctrl_gpio_range *range)
+{
+	return 0;
+}
 #endif
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 3b894a6..29b01b5 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -52,6 +52,9 @@ struct pinctrl_pin_desc {
  * @pin_base: base pin number of the GPIO range
  * @npins: number of pins in the GPIO range, including the base number
  * @gc: an optional pointer to a gpio_chip
+ * @np: the gpio device node for this range, used to find the gpio chip for dt.
+ * @off: offset in the gpio range of the gpio_chip. Used for dynamically binding
+ *  the gpio base from devicetree. Then @base is set as gc->base + off.
  */
 struct pinctrl_gpio_range {
 	struct list_head node;
@@ -61,6 +64,8 @@ struct pinctrl_gpio_range {
 	unsigned int pin_base;
 	unsigned int npins;
 	struct gpio_chip *gc;
+	struct device_node *np;
+	unsigned int off;
 };
 
 /**
@@ -129,7 +134,7 @@ extern struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 				struct device *dev, void *driver_data);
 extern void pinctrl_unregister(struct pinctrl_dev *pctldev);
 extern bool pin_is_valid(struct pinctrl_dev *pctldev, int pin);
-extern void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
+extern int pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
 				struct pinctrl_gpio_range *range);
 extern void pinctrl_remove_gpio_range(struct pinctrl_dev *pctldev,
 				struct pinctrl_gpio_range *range);
-- 
1.7.0.4


