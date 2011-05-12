Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab1ELN2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 09:28:05 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:37864 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756792Ab1ELN2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 09:28:01 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, balbi@ti.com, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH v2 1/4] MFD: TWL6025: add phoenix lite support to twl6030
Date: Thu, 12 May 2011 14:27:55 +0100
Message-Id: <1305206878-18094-2-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305206878-18094-1-git-send-email-gg@slimlogic.co.uk>
References: <1305206878-18094-1-git-send-email-gg@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phoenix Lite is based on the twl6030 family of PMICs. It has mostly the
same feature set of twl6030 but with small changes. The codec block has
also been removed. It also has a new charger block and new features in
its ADC block. VUSB handling also differs.

Since V1

Pass the twl features variable to other drivers via platform data instead
of exporting a get function from a global variable.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
---
 drivers/mfd/twl-core.c  |  190 +++++++++++++++++++++++++++++++++++++---------
 include/linux/i2c/twl.h |   34 +++++++++
 2 files changed, 187 insertions(+), 37 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 2bd9e06..b8f2a4e 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -198,6 +198,7 @@
 #define TWL6030_BASEADD_GASGAUGE	0x00C0
 #define TWL6030_BASEADD_PIH		0x00D0
 #define TWL6030_BASEADD_CHARGER		0x00E0
+#define TWL6025_BASEADD_CHARGER		0x00DA
 
 /* subchip/slave 2 0x4A - DFT */
 #define TWL6030_BASEADD_DIEID		0x00C0
@@ -331,6 +332,7 @@ static struct twl_mapping twl6030_map[] = {
 
 	{ SUB_CHIP_ID0, TWL6030_BASEADD_RTC },
 	{ SUB_CHIP_ID0, TWL6030_BASEADD_MEM },
+	{ SUB_CHIP_ID1, TWL6025_BASEADD_CHARGER },
 };
 
 /*----------------------------------------------------------------------*/
@@ -604,7 +606,7 @@ static inline struct device *add_child(unsigned chip, const char *name,
 static struct device *
 add_regulator_linked(int num, struct regulator_init_data *pdata,
 		struct regulator_consumer_supply *consumers,
-		unsigned num_consumers)
+		unsigned num_consumers, unsigned long features)
 {
 	unsigned sub_chip_id;
 	/* regulator framework demands init_data ... */
@@ -616,6 +618,8 @@ add_regulator_linked(int num, struct regulator_init_data *pdata,
 		pdata->num_consumer_supplies = num_consumers;
 	}
 
+	pdata->driver_data = (void *)features;
+
 	/* NOTE:  we currently ignore regulator IRQs, e.g. for short circuits */
 	sub_chip_id = twl_map[TWL_MODULE_PM_MASTER].sid;
 	return add_numbered_child(sub_chip_id, "twl_reg", num,
@@ -623,9 +627,10 @@ add_regulator_linked(int num, struct regulator_init_data *pdata,
 }
 
 static struct device *
-add_regulator(int num, struct regulator_init_data *pdata)
+add_regulator(int num, struct regulator_init_data *pdata,
+		unsigned long features)
 {
-	return add_regulator_linked(num, pdata, NULL, 0);
+	return add_regulator_linked(num, pdata, NULL, 0, features);
 }
 
 /*
@@ -705,17 +710,20 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 			};
 
 			child = add_regulator_linked(TWL4030_REG_VUSB1V5,
-						      &usb_fixed, &usb1v5, 1);
+						      &usb_fixed, &usb1v5, 1,
+						      features);
 			if (IS_ERR(child))
 				return PTR_ERR(child);
 
 			child = add_regulator_linked(TWL4030_REG_VUSB1V8,
-						      &usb_fixed, &usb1v8, 1);
+						      &usb_fixed, &usb1v8, 1,
+						      features);
 			if (IS_ERR(child))
 				return PTR_ERR(child);
 
 			child = add_regulator_linked(TWL4030_REG_VUSB3V1,
-						      &usb_fixed, &usb3v1, 1);
+						      &usb_fixed, &usb3v1, 1,
+						      features);
 			if (IS_ERR(child))
 				return PTR_ERR(child);
 
@@ -740,9 +748,8 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 	}
 	if (twl_has_usb() && pdata->usb && twl_class_is_6030()) {
 
-		static struct regulator_consumer_supply usb3v3 = {
-			.supply =	"vusb",
-		};
+		static struct regulator_consumer_supply usb3v3;
+		int regulator;
 
 		if (twl_has_regulator()) {
 			/* this is a template that gets copied */
@@ -755,12 +762,22 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 					| REGULATOR_CHANGE_STATUS,
 			};
 
-			child = add_regulator_linked(TWL6030_REG_VUSB,
-						      &usb_fixed, &usb3v3, 1);
+			if (features & TWL6025_SUBCLASS) {
+				usb3v3.supply =	"ldousb";
+				regulator = TWL6025_REG_LDOUSB;
+			} else {
+				usb3v3.supply = "vusb";
+				regulator = TWL6030_REG_VUSB;
+			}
+			child = add_regulator_linked(regulator, &usb_fixed,
+							&usb3v3, 1,
+							features);
 			if (IS_ERR(child))
 				return PTR_ERR(child);
 		}
 
+		pdata->usb->features = features;
+
 		child = add_child(0, "twl6030_usb",
 			pdata->usb, sizeof(*pdata->usb),
 			true,
@@ -773,7 +790,16 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 		/* we need to connect regulators to this transceiver */
 		if (twl_has_regulator() && child)
 			usb3v3.dev = child;
+	} else if (twl_has_regulator() && twl_class_is_6030()) {
+		if (features & TWL6025_SUBCLASS)
+			child = add_regulator(TWL6025_REG_LDOUSB,
+						pdata->ldousb, features);
+		else
+			child = add_regulator(TWL6030_REG_VUSB,
+						pdata->vusb, features);
 
+			if (IS_ERR(child))
+					return PTR_ERR(child);
 	}
 
 	if (twl_has_watchdog() && twl_class_is_4030()) {
@@ -810,46 +836,55 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 
 	/* twl4030 regulators */
 	if (twl_has_regulator() && twl_class_is_4030()) {
-		child = add_regulator(TWL4030_REG_VPLL1, pdata->vpll1);
+		child = add_regulator(TWL4030_REG_VPLL1, pdata->vpll1,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
-		child = add_regulator(TWL4030_REG_VIO, pdata->vio);
+		child = add_regulator(TWL4030_REG_VIO, pdata->vio,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
-		child = add_regulator(TWL4030_REG_VDD1, pdata->vdd1);
+		child = add_regulator(TWL4030_REG_VDD1, pdata->vdd1,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
-		child = add_regulator(TWL4030_REG_VDD2, pdata->vdd2);
+		child = add_regulator(TWL4030_REG_VDD2, pdata->vdd2,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
-		child = add_regulator(TWL4030_REG_VMMC1, pdata->vmmc1);
+		child = add_regulator(TWL4030_REG_VMMC1, pdata->vmmc1,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
-		child = add_regulator(TWL4030_REG_VDAC, pdata->vdac);
+		child = add_regulator(TWL4030_REG_VDAC, pdata->vdac,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
 		child = add_regulator((features & TWL4030_VAUX2)
 					? TWL4030_REG_VAUX2_4030
 					: TWL4030_REG_VAUX2,
-				pdata->vaux2);
+				pdata->vaux2, features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
-		child = add_regulator(TWL4030_REG_VINTANA1, pdata->vintana1);
+		child = add_regulator(TWL4030_REG_VINTANA1, pdata->vintana1,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
-		child = add_regulator(TWL4030_REG_VINTANA2, pdata->vintana2);
+		child = add_regulator(TWL4030_REG_VINTANA2, pdata->vintana2,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
-		child = add_regulator(TWL4030_REG_VINTDIG, pdata->vintdig);
+		child = add_regulator(TWL4030_REG_VINTDIG, pdata->vintdig,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 	}
@@ -857,72 +892,152 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 	/* maybe add LDOs that are omitted on cost-reduced parts */
 	if (twl_has_regulator() && !(features & TPS_SUBSET)
 	  && twl_class_is_4030()) {
-		child = add_regulator(TWL4030_REG_VPLL2, pdata->vpll2);
+		child = add_regulator(TWL4030_REG_VPLL2, pdata->vpll2,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
-		child = add_regulator(TWL4030_REG_VMMC2, pdata->vmmc2);
+		child = add_regulator(TWL4030_REG_VMMC2, pdata->vmmc2,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
-		child = add_regulator(TWL4030_REG_VSIM, pdata->vsim);
+		child = add_regulator(TWL4030_REG_VSIM, pdata->vsim,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
-		child = add_regulator(TWL4030_REG_VAUX1, pdata->vaux1);
+		child = add_regulator(TWL4030_REG_VAUX1, pdata->vaux1,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
-		child = add_regulator(TWL4030_REG_VAUX3, pdata->vaux3);
+		child = add_regulator(TWL4030_REG_VAUX3, pdata->vaux3,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
-		child = add_regulator(TWL4030_REG_VAUX4, pdata->vaux4);
+		child = add_regulator(TWL4030_REG_VAUX4, pdata->vaux4,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 	}
 
 	/* twl6030 regulators */
+	if (twl_has_regulator() && twl_class_is_6030() &&
+			!(features & TWL6025_SUBCLASS)) {
+		child = add_regulator(TWL6030_REG_VMMC, pdata->vmmc,
+					features);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6030_REG_VPP, pdata->vpp,
+					features);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6030_REG_VUSIM, pdata->vusim,
+					features);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6030_REG_VCXIO, pdata->vcxio,
+					features);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6030_REG_VDAC, pdata->vdac,
+					features);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6030_REG_VAUX1_6030, pdata->vaux1,
+					features);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6030_REG_VAUX2_6030, pdata->vaux2,
+					features);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6030_REG_VAUX3_6030, pdata->vaux3,
+					features);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6030_REG_CLK32KG, pdata->clk32kg,
+					features);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+	}
+
+	/* 6030 and 6025 share this regulator */
 	if (twl_has_regulator() && twl_class_is_6030()) {
-		child = add_regulator(TWL6030_REG_VMMC, pdata->vmmc);
+		child = add_regulator(TWL6030_REG_VANA, pdata->vana,
+					features);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+	}
+
+	/* twl6025 regulators */
+	if (twl_has_regulator() && twl_class_is_6030() &&
+			(features & TWL6025_SUBCLASS)) {
+		child = add_regulator(TWL6025_REG_LDO5, pdata->ldo5,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
-		child = add_regulator(TWL6030_REG_VPP, pdata->vpp);
+		child = add_regulator(TWL6025_REG_LDO1, pdata->ldo1,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
-		child = add_regulator(TWL6030_REG_VUSIM, pdata->vusim);
+		child = add_regulator(TWL6025_REG_LDO7, pdata->ldo7,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
-		child = add_regulator(TWL6030_REG_VANA, pdata->vana);
+		child = add_regulator(TWL6025_REG_LDO6, pdata->ldo6,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
-		child = add_regulator(TWL6030_REG_VCXIO, pdata->vcxio);
+		child = add_regulator(TWL6025_REG_LDOLN, pdata->ldoln,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
-		child = add_regulator(TWL6030_REG_VDAC, pdata->vdac);
+		child = add_regulator(TWL6025_REG_LDO2, pdata->ldo2,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
-		child = add_regulator(TWL6030_REG_VAUX1_6030, pdata->vaux1);
+		child = add_regulator(TWL6025_REG_LDO4, pdata->ldo4,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
-		child = add_regulator(TWL6030_REG_VAUX2_6030, pdata->vaux2);
+		child = add_regulator(TWL6025_REG_LDO3, pdata->ldo3,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
-		child = add_regulator(TWL6030_REG_VAUX3_6030, pdata->vaux3);
+		child = add_regulator(TWL6025_REG_SMPS3, pdata->smps3,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
-		child = add_regulator(TWL6030_REG_CLK32KG, pdata->clk32kg);
+		child = add_regulator(TWL6025_REG_SMPS4, pdata->smps4,
+					features);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
+
+		child = add_regulator(TWL6025_REG_VIO, pdata->vio6025,
+					features);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
 	}
 
 	if (twl_has_bci() && pdata->bci &&
@@ -1170,6 +1285,7 @@ static const struct i2c_device_id twl_ids[] = {
 	{ "tps65930", TPS_SUBSET },	/* fewer LDOs and DACs; no charger */
 	{ "tps65920", TPS_SUBSET },	/* fewer LDOs; no codec or charger */
 	{ "twl6030", TWL6030_CLASS },	/* "Phoenix power chip" */
+	{ "twl6025", TWL6030_CLASS | TWL6025_SUBCLASS }, /* "Phoenix lite" */
 	{ /* end of list */ },
 };
 MODULE_DEVICE_TABLE(i2c, twl_ids);
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 314218e..d70e704 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -170,6 +170,8 @@ static inline int twl_class_is_ ##class(void)	\
 TWL_CLASS_IS(4030, TWL4030_CLASS_ID)
 TWL_CLASS_IS(6030, TWL6030_CLASS_ID)
 
+#define TWL6025_SUBCLASS	BIT(4)  /* TWL6025 has changed registers */
+
 /*
  * Read and write single 8-bit registers
  */
@@ -608,6 +610,7 @@ enum twl4030_usb_mode {
 
 struct twl4030_usb_data {
 	enum twl4030_usb_mode	usb_mode;
+	unsigned long		features;
 
 	int		(*phy_init)(struct device *dev);
 	int		(*phy_exit)(struct device *dev);
@@ -714,6 +717,20 @@ struct twl4030_platform_data {
 	struct regulator_init_data              *vcxio;
 	struct regulator_init_data              *vusb;
 	struct regulator_init_data		*clk32kg;
+	/* TWL6025 LDO regulators */
+	struct regulator_init_data		*ldo1;
+	struct regulator_init_data		*ldo2;
+	struct regulator_init_data		*ldo3;
+	struct regulator_init_data		*ldo4;
+	struct regulator_init_data		*ldo5;
+	struct regulator_init_data		*ldo6;
+	struct regulator_init_data		*ldo7;
+	struct regulator_init_data		*ldoln;
+	struct regulator_init_data		*ldousb;
+	/* TWL6025 DCDC regulators */
+	struct regulator_init_data		*smps3;
+	struct regulator_init_data		*smps4;
+	struct regulator_init_data		*vio6025;
 };
 
 /*----------------------------------------------------------------------*/
@@ -795,4 +812,21 @@ static inline int twl4030charger_usb_en(int enable) { return 0; }
 #define TWL6030_REG_VRTC	47
 #define TWL6030_REG_CLK32KG	48
 
+/* LDOs on 6025 have different names */
+#define TWL6025_REG_LDO2	49
+#define TWL6025_REG_LDO4	50
+#define TWL6025_REG_LDO3	51
+#define TWL6025_REG_LDO5	52
+#define TWL6025_REG_LDO1	53
+#define TWL6025_REG_LDO7	54
+#define TWL6025_REG_LDO6	55
+#define TWL6025_REG_LDOLN	56
+#define TWL6025_REG_LDOUSB	57
+
+/* 6025 DCDC supplies */
+#define TWL6025_REG_SMPS3	58
+#define TWL6025_REG_SMPS4	59
+#define TWL6025_REG_VIO		60
+
+
 #endif /* End of __TWL4030_H */
-- 
1.7.4.1

