Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab2IKIx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 04:53:59 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:45754 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752410Ab2IKIx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 04:53:56 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>, Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] pinctrl: pinctrl-single: Add pinctrl-single,bits type of mux
Date: Tue, 11 Sep 2012 11:54:24 +0300
Message-Id: <1347353664-15906-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
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
Hello Tony, Linus,

Changes since v1:
- Added boolean for the pinctrl-single: pinctrl-single,bit-per-mux
  When this is set the it indicates that the area contains registers which
  changes mux for multible pins.
- Documentation updated reflecting this change (with example for this type)

Regards,
Peter

 .../devicetree/bindings/pinctrl/pinctrl-single.txt | 41 +++++++++++++++++--
 drivers/pinctrl/pinctrl-single.c                   | 46 +++++++++++++++++-----
 2 files changed, 74 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
index 5187f0d..2c81e45 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
@@ -14,10 +14,12 @@ Optional properties:
 - pinctrl-single,function-off : function off mode for disabled state if
   available and same for all registers; if not specified, disabling of
   pin functions is ignored
+- pinctrl-single,bit-per-mux : boolean to indicate that one register controls
+  more than one pin
 
-This driver assumes that there is only one register for each pin,
-and uses the common pinctrl bindings as specified in the pinctrl-bindings.txt
-document in this directory.
+This driver assumes that there is only one register for each pin (unless the
+pinctrl-single,bit-per-mux is set), and uses the common pinctrl bindings as
+specified in the pinctrl-bindings.txt document in this directory.
 
 The pin configuration nodes for pinctrl-single are specified as pinctrl
 register offset and value pairs using pinctrl-single,pins. Only the bits
@@ -31,6 +33,15 @@ device pinctrl register, and 0x118 contains the desired value of the
 pinctrl register. See the device example and static board pins example
 below for more information.
 
+In case when one register changes more than one pin's mux the
+pinctrl-single,bits need to be used which takes three parameters:
+
+	pinctrl-single,bits = <0xdc 0x18, 0xff>;
+
+Where 0xdc is the offset from the pinctrl register base address for the
+device pinctrl register, 0x18 is the desired value, and 0xff is the sub mask to
+be used when applying this change to the register.
+
 Example:
 
 /* SoC common file */
@@ -55,6 +66,15 @@ pmx_wkup: pinmux@4a31e040 {
 	pinctrl-single,function-mask = <0xffff>;
 };
 
+control_devconf0: pinmux@48002274 {
+	compatible = "pinctrl-single";
+	reg = <0x48002274 4>;	/* Single register */
+	#address-cells = <1>;
+	#size-cells = <0>;
+	pinctrl-single,bit-per-mux;
+	pinctrl-single,register-width = <32>;
+	pinctrl-single,function-mask = <0x5F>;
+};
 
 /* board specific .dts file */
 
@@ -87,6 +107,21 @@ pmx_wkup: pinmux@4a31e040 {
 	};
 };
 
+&control_devconf0 {
+	mcbsp1_pins: pinmux_mcbsp1_pins {
+		pinctrl-single,bits = <
+			0x00 0x18 0x18 /* FSR/CLKR signal from FSX/CLKX pin */
+		>;
+	};
+
+	mcbsp2_clks_pins: pinmux_mcbsp2_clks_pins {
+		pinctrl-single,bits = <
+			0x00 0x40 0x40 /* McBSP2 CLKS from McBSP_CLKS pin */
+		>;
+	};
+
+};
+
 &uart2 {
        pinctrl-names = "default";
        pinctrl-0 = <&uart2_pins>;
diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 3508631..759b5a6 100644
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
@@ -139,6 +141,7 @@ struct pcs_device {
 	unsigned fshift;
 	unsigned foff;
 	unsigned fmax;
+	bool bits_per_mux;
 	struct pcs_name *names;
 	struct pcs_data pins;
 	struct radix_tree_root pgtree;
@@ -332,12 +335,17 @@ static int pcs_enable(struct pinctrl_dev *pctldev, unsigned fselector,
 
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
 
@@ -657,18 +665,29 @@ static int pcs_parse_one_pinctrl_entry(struct pcs_device *pcs,
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
+	if (pcs->bits_per_mux) {
+		params = 3;
+		mux = of_get_property(np, PCS_MUX_BITS_NAME, &size);
+	} else {
+		params = 2;
+		mux = of_get_property(np, PCS_MUX_PINS_NAME, &size);
+	}
+
+	if (!mux) {
+		dev_err(pcs->dev, "no valid property for %s\n", np->name);
+		return -EINVAL;
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
@@ -686,6 +705,10 @@ static int pcs_parse_one_pinctrl_entry(struct pcs_device *pcs,
 		val = be32_to_cpup(mux + index++);
 		vals[found].reg = pcs->base + offset;
 		vals[found].val = val;
+		if (params == 3) {
+			val = be32_to_cpup(mux + index++);
+			vals[found].mask = val;
+		}
 
 		pin = pcs_get_pin_by_offset(pcs, offset);
 		if (pin < 0) {
@@ -883,6 +906,9 @@ static int __devinit pcs_probe(struct platform_device *pdev)
 	if (ret)
 		pcs->foff = PCS_OFF_DISABLED;
 
+	pcs->bits_per_mux = of_property_read_bool(np,
+						  "pinctrl-single,bit-per-mux");
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(pcs->dev, "could not get resource\n");
-- 
1.7.12

