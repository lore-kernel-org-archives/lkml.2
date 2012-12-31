Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab2LaLLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 06:11:08 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48382 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab2LaLJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 06:09:44 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 08/10] mfd: twl-core: Collect global variables behind one private structure (global)
Date: Mon, 31 Dec 2012 12:09:29 +0100
Message-ID: <1356952171-6109-9-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356952171-6109-1-git-send-email-peter.ujfalusi@ti.com>
References: <1356952171-6109-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gather the global variables under a single structure and allocate it with
devm_kzalloc(). It is easier to see them and if in the future we try to add
support for multiple instance of twl in the system it is going to be much
simpler.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl-core.c | 104 +++++++++++++++++++++++++++----------------------
 1 file changed, 57 insertions(+), 47 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 1827088..e2895a4 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -141,33 +141,28 @@
 
 /*----------------------------------------------------------------------*/
 
-/* is driver active, bound to a chip? */
-static bool inuse;
-
-/* TWL IDCODE Register value */
-static u32 twl_idcode;
-
-static unsigned int twl_id;
-unsigned int twl_rev(void)
-{
-	return twl_id;
-}
-EXPORT_SYMBOL(twl_rev);
-
 /* Structure for each TWL4030/TWL6030 Slave */
 struct twl_client {
 	struct i2c_client *client;
 	struct regmap *regmap;
 };
 
-static struct twl_client *twl_modules;
-
 /* mapping the module id to slave id and base address */
 struct twl_mapping {
 	unsigned char sid;	/* Slave ID */
 	unsigned char base;	/* base address */
 };
-static struct twl_mapping *twl_map;
+
+struct twl_private {
+	bool ready; /* The core driver is ready to be used */
+	u32 twl_idcode; /* TWL IDCODE Register value */
+	unsigned int twl_id;
+
+	struct twl_mapping *twl_map;
+	struct twl_client *twl_modules;
+};
+
+static struct twl_private *twl_priv;
 
 static struct twl_mapping twl4030_map[] = {
 	/*
@@ -300,6 +295,12 @@ static inline int twl_get_last_module(void)
 
 /* Exported Functions */
 
+unsigned int twl_rev(void)
+{
+	return twl_priv ? twl_priv->twl_id : 0;
+}
+EXPORT_SYMBOL(twl_rev);
+
 /**
  * twl_i2c_write - Writes a n bit register in TWL4030/TWL5030/TWL60X0
  * @mod_no: module number
@@ -322,16 +323,17 @@ int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
 		return -EPERM;
 	}
-	if (unlikely(!inuse)) {
+	if (unlikely(!twl_priv->ready)) {
 		pr_err("%s: not initialized\n", DRIVER_NAME);
 		return -EPERM;
 	}
 
-	sid = twl_map[mod_no].sid;
-	twl = &twl_modules[sid];
+	sid = twl_priv->twl_map[mod_no].sid;
+	twl = &twl_priv->twl_modules[sid];
 
-	ret = regmap_bulk_write(twl->regmap, twl_map[mod_no].base + reg,
-				value, num_bytes);
+	ret = regmap_bulk_write(twl->regmap,
+				twl_priv->twl_map[mod_no].base + reg, value,
+				num_bytes);
 
 	if (ret)
 		pr_err("%s: Write failed (mod %d, reg 0x%02x count %d)\n",
@@ -360,16 +362,17 @@ int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
 		return -EPERM;
 	}
-	if (unlikely(!inuse)) {
+	if (unlikely(!twl_priv->ready)) {
 		pr_err("%s: not initialized\n", DRIVER_NAME);
 		return -EPERM;
 	}
 
-	sid = twl_map[mod_no].sid;
-	twl = &twl_modules[sid];
+	sid = twl_priv->twl_map[mod_no].sid;
+	twl = &twl_priv->twl_modules[sid];
 
-	ret = regmap_bulk_read(twl->regmap, twl_map[mod_no].base + reg,
-			       value, num_bytes);
+	ret = regmap_bulk_read(twl->regmap,
+			       twl_priv->twl_map[mod_no].base + reg, value,
+			       num_bytes);
 
 	if (ret)
 		pr_err("%s: Read failed (mod %d, reg 0x%02x count %d)\n",
@@ -425,7 +428,7 @@ static int twl_read_idcode_register(void)
 		goto fail;
 	}
 
-	err = twl_i2c_read(TWL4030_MODULE_INTBR, (u8 *)(&twl_idcode),
+	err = twl_i2c_read(TWL4030_MODULE_INTBR, (u8 *)(&twl_priv->twl_idcode),
 						REG_IDCODE_7_0, 4);
 	if (err) {
 		pr_err("TWL4030: unable to read IDCODE -%d\n", err);
@@ -446,7 +449,7 @@ fail:
  */
 int twl_get_type(void)
 {
-	return TWL_SIL_TYPE(twl_idcode);
+	return TWL_SIL_TYPE(twl_priv->twl_idcode);
 }
 EXPORT_SYMBOL_GPL(twl_get_type);
 
@@ -457,7 +460,7 @@ EXPORT_SYMBOL_GPL(twl_get_type);
  */
 int twl_get_version(void)
 {
-	return TWL_SIL_REV(twl_idcode);
+	return TWL_SIL_REV(twl_priv->twl_idcode);
 }
 EXPORT_SYMBOL_GPL(twl_get_version);
 
@@ -506,8 +509,8 @@ add_numbered_child(unsigned mod_no, const char *name, int num,
 		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
 		return ERR_PTR(-EPERM);
 	}
-	sid = twl_map[mod_no].sid;
-	twl = &twl_modules[sid];
+	sid = twl_priv->twl_map[mod_no].sid;
+	twl = &twl_priv->twl_modules[sid];
 
 	pdev = platform_device_alloc(name, num);
 	if (!pdev) {
@@ -1143,13 +1146,13 @@ static int twl_remove(struct i2c_client *client)
 
 	num_slaves = twl_get_num_slaves();
 	for (i = 0; i < num_slaves; i++) {
-		struct twl_client	*twl = &twl_modules[i];
+		struct twl_client	*twl = &twl_priv->twl_modules[i];
 
 		if (twl->client && twl->client != client)
 			i2c_unregister_device(twl->client);
-		twl_modules[i].client = NULL;
+		twl->client = NULL;
 	}
-	inuse = false;
+	twl_priv->ready = false;
 	return 0;
 }
 
@@ -1170,7 +1173,7 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		return -EINVAL;
 	}
 
-	if (inuse) {
+	if (twl_priv) {
 		dev_dbg(&client->dev, "only one instance of %s allowed\n",
 			DRIVER_NAME);
 		return -EBUSY;
@@ -1194,31 +1197,38 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		goto free;
 	}
 
+	twl_priv = devm_kzalloc(&client->dev, sizeof(struct twl_private),
+				GFP_KERNEL);
+	if (!twl_priv) {
+		status = -ENOMEM;
+		goto free;
+	}
+
 	if ((id->driver_data) & TWL6030_CLASS) {
-		twl_id = TWL6030_CLASS_ID;
-		twl_map = &twl6030_map[0];
+		twl_priv->twl_id = TWL6030_CLASS_ID;
+		twl_priv->twl_map = &twl6030_map[0];
 		/* The charger base address is different in twl6025 */
 		if ((id->driver_data) & TWL6025_SUBCLASS)
-			twl_map[TWL_MODULE_MAIN_CHARGE].base =
+			twl_priv->twl_map[TWL_MODULE_MAIN_CHARGE].base =
 							TWL6025_BASEADD_CHARGER;
 		twl_regmap_config = twl6030_regmap_config;
 	} else {
-		twl_id = TWL4030_CLASS_ID;
-		twl_map = &twl4030_map[0];
+		twl_priv->twl_id = TWL4030_CLASS_ID;
+		twl_priv->twl_map = &twl4030_map[0];
 		twl_regmap_config = twl4030_regmap_config;
 	}
 
 	num_slaves = twl_get_num_slaves();
-	twl_modules = devm_kzalloc(&client->dev,
-				   sizeof(struct twl_client) * num_slaves,
-				   GFP_KERNEL);
-	if (!twl_modules) {
+	twl_priv->twl_modules = devm_kzalloc(&client->dev,
+					 sizeof(struct twl_client) * num_slaves,
+					 GFP_KERNEL);
+	if (!twl_priv->twl_modules) {
 		status = -ENOMEM;
 		goto free;
 	}
 
 	for (i = 0; i < num_slaves; i++) {
-		struct twl_client *twl = &twl_modules[i];
+		struct twl_client *twl = &twl_priv->twl_modules[i];
 
 		if (i == 0) {
 			twl->client = client;
@@ -1244,13 +1254,13 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		}
 	}
 
-	inuse = true;
+	twl_priv->ready = true;
 
 	/* setup clock framework */
 	clocks_init(&pdev->dev, pdata ? pdata->clock : NULL);
 
 	/* read TWL IDCODE Register */
-	if (twl_id == TWL4030_CLASS_ID) {
+	if (twl_class_is_4030()) {
 		status = twl_read_idcode_register();
 		WARN(status < 0, "Error: reading twl_idcode register value\n");
 	}
-- 
1.8.0.2

