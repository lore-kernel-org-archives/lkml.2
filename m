Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab1D0JvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 05:51:15 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:52793 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991Ab1D0Jto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 05:49:44 -0400
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Apr 2011 05:49:43 EDT
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, balbi@ti.com, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH 1/4] MFD: TWL6025: add phoenix lite support to twl6030
Date: Wed, 27 Apr 2011 10:39:48 +0100
Message-Id: <1303897191-14792-2-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303897191-14792-1-git-send-email-gg@slimlogic.co.uk>
References: <1303897191-14792-1-git-send-email-gg@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phoenix Lite is based on the twl6030 family of PMICs. It has mostly the
same feature set of twl6030 but with small changes. The codec block has
also been removed. It also has a new charger block and new features in
its ADC block. VUSB handling also differs.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
---
 drivers/mfd/twl-core.c  |  103 ++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/i2c/twl.h |   38 +++++++++++++++++-
 2 files changed, 130 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 960b5be..6b9562a 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -198,6 +198,7 @@
 #define TWL6030_BASEADD_GASGAUGE	0x00C0
 #define TWL6030_BASEADD_PIH		0x00D0
 #define TWL6030_BASEADD_CHARGER		0x00E0
+#define TWL6025_BASEADD_CHARGER		0x00DA
 
 /* subchip/slave 2 0x4A - DFT */
 #define TWL6030_BASEADD_DIEID		0x00C0
@@ -236,6 +237,17 @@ unsigned int twl_rev(void)
 }
 EXPORT_SYMBOL(twl_rev);
 
+/* Export a function so child drivers of this mfd can tell which subclass
+ * of the chip is being used. eg regulator needs to know that it is a
+ * 6025 variant.
+ */
+static unsigned int twl_feat;
+unsigned int twl_features(void)
+{
+	return twl_feat;
+}
+EXPORT_SYMBOL(twl_features);
+
 /* Structure for each TWL4030/TWL6030 Slave */
 struct twl_client {
 	struct i2c_client *client;
@@ -328,6 +340,7 @@ static struct twl_mapping twl6030_map[] = {
 
 	{ SUB_CHIP_ID0, TWL6030_BASEADD_RTC },
 	{ SUB_CHIP_ID0, TWL6030_BASEADD_MEM },
+	{ SUB_CHIP_ID1, TWL6025_BASEADD_CHARGER },
 };
 
 /*----------------------------------------------------------------------*/
@@ -685,9 +698,8 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 	}
 	if (twl_has_usb() && pdata->usb && twl_class_is_6030()) {
 
-		static struct regulator_consumer_supply usb3v3 = {
-			.supply =	"vusb",
-		};
+		static struct regulator_consumer_supply usb3v3;
+		int regulator;
 
 		if (twl_has_regulator()) {
 			/* this is a template that gets copied */
@@ -700,8 +712,15 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
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
+							&usb3v3, 1);
 			if (IS_ERR(child))
 				return PTR_ERR(child);
 		}
@@ -718,7 +737,15 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 		/* we need to connect regulators to this transceiver */
 		if (twl_has_regulator() && child)
 			usb3v3.dev = child;
+	} else if (twl_has_regulator() && twl_class_is_6030()) {
+		if (features & TWL6025_SUBCLASS)
+			child = add_regulator(TWL6025_REG_LDOUSB,
+						pdata->ldousb);
+		else
+			child = add_regulator(TWL6030_REG_VUSB, pdata->vusb);
 
+			if (IS_ERR(child))
+					return PTR_ERR(child);
 	}
 
 	if (twl_has_watchdog() && twl_class_is_4030()) {
@@ -828,7 +855,8 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 	}
 
 	/* twl6030 regulators */
-	if (twl_has_regulator() && twl_class_is_6030()) {
+	if (twl_has_regulator() && twl_class_is_6030() &&
+			!(features & TWL6025_SUBCLASS)) {
 		child = add_regulator(TWL6030_REG_VMMC, pdata->vmmc);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
@@ -841,10 +869,6 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
-		child = add_regulator(TWL6030_REG_VANA, pdata->vana);
-		if (IS_ERR(child))
-			return PTR_ERR(child);
-
 		child = add_regulator(TWL6030_REG_VCXIO, pdata->vcxio);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
@@ -870,6 +894,62 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 			return PTR_ERR(child);
 	}
 
+	/* 6030 and 6025 share this regulator */
+	if (twl_has_regulator() && twl_class_is_6030()) {
+		child = add_regulator(TWL6030_REG_VANA, pdata->vana);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+	}
+
+	/* twl6025 regulators */
+	if (twl_has_regulator() && twl_class_is_6030() &&
+			(features & TWL6025_SUBCLASS)) {
+		child = add_regulator(TWL6025_REG_LDO5, pdata->ldo5);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6025_REG_LDO1, pdata->ldo1);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6025_REG_LDO7, pdata->ldo7);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6025_REG_LDO6, pdata->ldo6);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6025_REG_LDOLN, pdata->ldoln);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6025_REG_LDO2, pdata->ldo2);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6025_REG_LDO4, pdata->ldo4);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6025_REG_LDO3, pdata->ldo3);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6025_REG_SMPS3, pdata->smps3);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6025_REG_SMPS4, pdata->smps4);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL6025_REG_VIO, pdata->vio6025);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+	}
+
 	if (twl_has_bci() && pdata->bci &&
 			!(features & (TPS_SUBSET | TWL5031))) {
 		child = add_child(3, "twl4030_bci",
@@ -1093,6 +1173,8 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		twl_i2c_write_u8(TWL4030_MODULE_INTBR, temp, REG_GPPUPDCTR1);
 	}
 
+	twl_feat = id->driver_data;
+
 	status = add_children(pdata, id->driver_data);
 fail:
 	if (status < 0)
@@ -1108,6 +1190,7 @@ static const struct i2c_device_id twl_ids[] = {
 	{ "tps65930", TPS_SUBSET },	/* fewer LDOs and DACs; no charger */
 	{ "tps65920", TPS_SUBSET },	/* fewer LDOs; no codec or charger */
 	{ "twl6030", TWL6030_CLASS },	/* "Phoenix power chip" */
+	{ "twl6025", TWL6030_CLASS | TWL6025_SUBCLASS }, /* "Phoenix lite" */
 	{ /* end of list */ },
 };
 MODULE_DEVICE_TABLE(i2c, twl_ids);
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 0c0d1ae..f85f0ed 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -165,6 +165,11 @@ static inline int twl_class_is_ ##class(void)	\
 TWL_CLASS_IS(4030, TWL4030_CLASS_ID)
 TWL_CLASS_IS(6030, TWL6030_CLASS_ID)
 
+#define TWL6025_SUBCLASS	BIT(4)  /* TWL6025 has changed registers */
+
+/* So we can recover the features in other parts of twl stack */
+unsigned int twl_features(void);
+
 /*
  * Read and write single 8-bit registers
  */
@@ -698,7 +703,21 @@ struct twl4030_platform_data {
 	struct regulator_init_data              *vana;
 	struct regulator_init_data              *vcxio;
 	struct regulator_init_data              *vusb;
-	struct regulator_init_data		*clk32kg;
+	struct regulator_init_data              *clk32kg;
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
@@ -780,4 +799,21 @@ static inline int twl4030charger_usb_en(int enable) { return 0; }
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

