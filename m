Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307Ab2IEJCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:02:20 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:45196 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932472Ab2IEJBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:01:53 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>, Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH 2/2] pinctrl: pinctrl-single: Add pinctrl-single,bits type of mux
Date: Wed,  5 Sep 2012 12:01:58 +0300
Message-Id: <1346835718-21325-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346835718-21325-1-git-send-email-peter.ujfalusi@ti.com>
References: <1346835718-21325-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With pinctrl-single,bits it is possible to update just part of the register
within the pinctrl-single,function-mask area.
This is useful when one register configures mmore than one pin's mux.

pinctrl-single,bits takes three parameters:
<reg offset, value, sub-mask>

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 .../devicetree/bindings/pinctrl/pinctrl-single.txt |  9 +++++
 drivers/pinctrl/pinctrl-single.c                   | 42 ++++++++++++++++------
 2 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
index 5187f0d..287801d 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
@@ -31,6 +31,15 @@ device pinctrl register, and 0x118 contains the desired value of the
 pinctrl register. See the device example and static board pins example
 below for more information.
 
+In case when one register changes more than one pin's mux the
+pinctrl-single,bits can be used which takes three parameters:
+
+	pinctrl-single,bits = <0xdc 0x18, 0xff>;
+
+Where 0xdc is the offset from the pinctrl register base address for the
+device pinctrl register, 0x18 is the desired value, and 0xff is the sub mask to
+be used when applying this change to the register.
+
 Example:
 
 /* SoC common file */
diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 3508631..aec338e 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -26,7 +26,8 @@
 #include "core.h"
 
 #define DRIVER_NAME			"pinctrl-single"
-#define PCS_MUX_NAME			"pinctrl-single,pins"
+#define PCS_MUX_PINS_NAME		"pinctrl-single,pins"
+#define PCS_MUX_BITS_NAME		"pinctrl-single,bits"
 #define PCS_REG_NAME_LEN		((sizeof(unsigned long) * 2) + 1)
 #define PCS_OFF_DISABLED		~0U
 
@@ -54,6 +55,7 @@ struct pcs_pingroup {
 struct pcs_func_vals {
 	void __iomem *reg;
 	unsigned val;
+	unsigned mask;
 };
 
 /**
@@ -332,12 +334,17 @@ static int pcs_enable(struct pinctrl_dev *pctldev, unsigned fselector,
 
 	for (i = 0; i < func->nvals; i++) {
 		struct pcs_func_vals *vals;
-		unsigned val;
+		unsigned val, mask;
 
 		vals = &func->vals[i];
 		val = pcs->read(vals->reg);
-		val &= ~pcs->fmask;
-		val |= (vals->val & pcs->fmask);
+		if (!vals->mask)
+			mask = pcs->fmask;
+		else
+			mask = pcs->fmask & vals->mask;
+
+		val &= ~mask;
+		val |= (vals->val & mask);
 		pcs->write(val, vals->reg);
 	}
 
@@ -657,18 +664,29 @@ static int pcs_parse_one_pinctrl_entry(struct pcs_device *pcs,
 {
 	struct pcs_func_vals *vals;
 	const __be32 *mux;
-	int size, rows, *pins, index = 0, found = 0, res = -ENOMEM;
+	int size, params, rows, *pins, index = 0, found = 0, res = -ENOMEM;
 	struct pcs_function *function;
 
-	mux = of_get_property(np, PCS_MUX_NAME, &size);
-	if ((!mux) || (size < sizeof(*mux) * 2)) {
-		dev_err(pcs->dev, "bad data for mux %s\n",
-			np->name);
+	mux = of_get_property(np, PCS_MUX_PINS_NAME, &size);
+	if (mux) {
+		params = 2;
+	} else {
+		mux = of_get_property(np, PCS_MUX_BITS_NAME, &size);
+		if (!mux) {
+			dev_err(pcs->dev, "no valid property for %s\n",
+				np->name);
+			return -EINVAL;
+		}
+		params = 3;
+	}
+
+	if (size < (sizeof(*mux) * params)) {
+		dev_err(pcs->dev, "bad data for %s\n", np->name);
 		return -EINVAL;
 	}
 
 	size /= sizeof(*mux);	/* Number of elements in array */
-	rows = size / 2;	/* Each row is a key value pair */
+	rows = size / params;	/* Each row is a key value pair */
 
 	vals = devm_kzalloc(pcs->dev, sizeof(*vals) * rows, GFP_KERNEL);
 	if (!vals)
@@ -686,6 +704,10 @@ static int pcs_parse_one_pinctrl_entry(struct pcs_device *pcs,
 		val = be32_to_cpup(mux + index++);
 		vals[found].reg = pcs->base + offset;
 		vals[found].val = val;
+		if (params == 3) {
+			val = be32_to_cpup(mux + index++);
+			vals[found].mask = val;
+		}
 
 		pin = pcs_get_pin_by_offset(pcs, offset);
 		if (pin < 0) {
-- 
1.7.12

