Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab2KMI3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:29:10 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:60101 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979Ab2KMI3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:29:04 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Tero Kristo <t-kristo@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 03/13] MFD: twl-core: Convert to use regmap for I/O
Date: Tue, 13 Nov 2012 09:28:44 +0100
Message-ID: <1352795334-7406-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352795334-7406-1-git-send-email-peter.ujfalusi@ti.com>
References: <1352795334-7406-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the custom code to do I/O and replace it with standard regmap calls.

CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl-core.c | 147 +++++++++++++++++++++++++++----------------------
 1 file changed, 80 insertions(+), 67 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 1dfd583..5043f505a 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -32,6 +32,7 @@
 #include <linux/mutex.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/device.h>
@@ -171,13 +172,7 @@ EXPORT_SYMBOL(twl_rev);
 /* Structure for each TWL4030/TWL6030 Slave */
 struct twl_client {
 	struct i2c_client *client;
-	u8 address;
-
-	/* max numb of i2c_msg required is for read =2 */
-	struct i2c_msg xfer_msg[2];
-
-	/* To lock access to xfer_msg */
-	struct mutex xfer_lock;
+	struct regmap *regmap;
 };
 
 static struct twl_client twl_modules[TWL_NUM_SLAVES];
@@ -225,6 +220,33 @@ static struct twl_mapping twl4030_map[TWL4030_MODULE_LAST + 1] = {
 	{ 3, TWL4030_BASEADD_SECURED_REG },
 };
 
+static struct regmap_config twl4030_regmap_config[4] = {
+	{
+		/* Address 0x48 */
+		.reg_bits = 8,
+		.val_bits = 8,
+		.max_register = 0xff,
+	},
+	{
+		/* Address 0x49 */
+		.reg_bits = 8,
+		.val_bits = 8,
+		.max_register = 0xff,
+	},
+	{
+		/* Address 0x4a */
+		.reg_bits = 8,
+		.val_bits = 8,
+		.max_register = 0xff,
+	},
+	{
+		/* Address 0x4b */
+		.reg_bits = 8,
+		.val_bits = 8,
+		.max_register = 0xff,
+	},
+};
+
 static struct twl_mapping twl6030_map[] = {
 	/*
 	 * NOTE:  don't change this table without updating the
@@ -262,6 +284,27 @@ static struct twl_mapping twl6030_map[] = {
 	{ SUB_CHIP_ID1, TWL6025_BASEADD_CHARGER },
 };
 
+static struct regmap_config twl6030_regmap_config[3] = {
+	{
+		/* Address 0x48 */
+		.reg_bits = 8,
+		.val_bits = 8,
+		.max_register = 0xff,
+	},
+	{
+		/* Address 0x49 */
+		.reg_bits = 8,
+		.val_bits = 8,
+		.max_register = 0xff,
+	},
+	{
+		/* Address 0x4a */
+		.reg_bits = 8,
+		.val_bits = 8,
+		.max_register = 0xff,
+	},
+};
+
 /*----------------------------------------------------------------------*/
 
 /* Exported Functions */
@@ -283,7 +326,6 @@ int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 	int ret;
 	int sid;
 	struct twl_client *twl;
-	struct i2c_msg *msg;
 
 	if (unlikely(mod_no > TWL_MODULE_LAST)) {
 		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
@@ -301,32 +343,14 @@ int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 	}
 	twl = &twl_modules[sid];
 
-	mutex_lock(&twl->xfer_lock);
-	/*
-	 * [MSG1]: fill the register address data
-	 * fill the data Tx buffer
-	 */
-	msg = &twl->xfer_msg[0];
-	msg->addr = twl->address;
-	msg->len = num_bytes + 1;
-	msg->flags = 0;
-	msg->buf = value;
-	/* over write the first byte of buffer with the register address */
-	*value = twl_map[mod_no].base + reg;
-	ret = i2c_transfer(twl->client->adapter, twl->xfer_msg, 1);
-	mutex_unlock(&twl->xfer_lock);
-
-	/* i2c_transfer returns number of messages transferred */
-	if (ret != 1) {
-		pr_err("%s: i2c_write failed to transfer all messages\n",
-			DRIVER_NAME);
-		if (ret < 0)
-			return ret;
-		else
-			return -EIO;
-	} else {
-		return 0;
-	}
+	ret = regmap_bulk_write(twl->regmap, twl_map[mod_no].base + reg,
+				&value[1], num_bytes);
+
+	if (ret)
+		pr_err("%s: Write failed (mod %d, reg 0x%02x count %d)\n",
+		       DRIVER_NAME, mod_no, reg, num_bytes);
+
+	return ret;
 }
 EXPORT_SYMBOL(twl_i2c_write);
 
@@ -342,10 +366,8 @@ EXPORT_SYMBOL(twl_i2c_write);
 int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 {
 	int ret;
-	u8 val;
 	int sid;
 	struct twl_client *twl;
-	struct i2c_msg *msg;
 
 	if (unlikely(mod_no > TWL_MODULE_LAST)) {
 		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
@@ -363,34 +385,14 @@ int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 	}
 	twl = &twl_modules[sid];
 
-	mutex_lock(&twl->xfer_lock);
-	/* [MSG1] fill the register address data */
-	msg = &twl->xfer_msg[0];
-	msg->addr = twl->address;
-	msg->len = 1;
-	msg->flags = 0;	/* Read the register value */
-	val = twl_map[mod_no].base + reg;
-	msg->buf = &val;
-	/* [MSG2] fill the data rx buffer */
-	msg = &twl->xfer_msg[1];
-	msg->addr = twl->address;
-	msg->flags = I2C_M_RD;	/* Read the register value */
-	msg->len = num_bytes;	/* only n bytes */
-	msg->buf = value;
-	ret = i2c_transfer(twl->client->adapter, twl->xfer_msg, 2);
-	mutex_unlock(&twl->xfer_lock);
-
-	/* i2c_transfer returns number of messages transferred */
-	if (ret != 2) {
-		pr_err("%s: i2c_read failed to transfer all messages\n",
-			DRIVER_NAME);
-		if (ret < 0)
-			return ret;
-		else
-			return -EIO;
-	} else {
-		return 0;
-	}
+	ret = regmap_bulk_read(twl->regmap, twl_map[mod_no].base + reg,
+			       value, num_bytes);
+
+	if (ret)
+		pr_err("%s: Read failed (mod %d, reg 0x%02x count %d)\n",
+		       DRIVER_NAME, mod_no, reg, num_bytes);
+
+	return ret;
 }
 EXPORT_SYMBOL(twl_i2c_read);
 
@@ -1184,6 +1186,7 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	struct twl4030_platform_data	*pdata = client->dev.platform_data;
 	struct device_node		*node = client->dev.of_node;
 	struct platform_device		*pdev;
+	struct regmap_config		*twl_regmap_config;
 	int				irq_base = 0;
 	int				status;
 	unsigned			i, num_slaves;
@@ -1237,22 +1240,23 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if ((id->driver_data) & TWL6030_CLASS) {
 		twl_id = TWL6030_CLASS_ID;
 		twl_map = &twl6030_map[0];
+		twl_regmap_config = twl6030_regmap_config;
 		num_slaves = TWL_NUM_SLAVES - 1;
 	} else {
 		twl_id = TWL4030_CLASS_ID;
 		twl_map = &twl4030_map[0];
+		twl_regmap_config = twl4030_regmap_config;
 		num_slaves = TWL_NUM_SLAVES;
 	}
 
 	for (i = 0; i < num_slaves; i++) {
 		struct twl_client *twl = &twl_modules[i];
 
-		twl->address = client->addr + i;
 		if (i == 0) {
 			twl->client = client;
 		} else {
 			twl->client = i2c_new_dummy(client->adapter,
-					twl->address);
+						    client->addr + i);
 			if (!twl->client) {
 				dev_err(&client->dev,
 					"can't attach client %d\n", i);
@@ -1260,7 +1264,16 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 				goto fail;
 			}
 		}
-		mutex_init(&twl->xfer_lock);
+
+		twl->regmap = devm_regmap_init_i2c(twl->client,
+						   &twl_regmap_config[i]);
+		if (IS_ERR(twl->regmap)) {
+			status = PTR_ERR(twl->regmap);
+			dev_err(&client->dev,
+				"Failed to allocate regmap %d, err: %d\n", i,
+				status);
+			goto fail;
+		}
 	}
 
 	inuse = true;
-- 
1.8.0

