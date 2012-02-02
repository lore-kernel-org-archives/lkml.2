Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab2BBMRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:17:20 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:52217 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755948Ab2BBMRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:17:16 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dtor@mail.ru>
Cc: Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC 1/7] MFD: twl-core: Detach twl6040 from the pmic mfd driver
Date: Thu,  2 Feb 2012 14:16:53 +0200
Message-Id: <1328185019-29575-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1328185019-29575-1-git-send-email-peter.ujfalusi@ti.com>
References: <1328185019-29575-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On OMAP4 platform audio has separate IC, it is no longer part
of the pmic chip.
Prevent twl-core to claim the 0x4b address, which belongs to
the twl6040 audio IC.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl-core.c |   58 +++++++++++++++++++++++++++--------------------
 1 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index e04e04d..ac6fdd93 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -115,8 +115,8 @@
 #define twl_has_watchdog()        false
 #endif
 
-#if defined(CONFIG_MFD_TWL4030_AUDIO) || defined(CONFIG_MFD_TWL4030_AUDIO_MODULE) ||\
-	defined(CONFIG_TWL6040_CORE) || defined(CONFIG_TWL6040_CORE_MODULE)
+#if defined(CONFIG_MFD_TWL4030_AUDIO) || \
+	defined(CONFIG_MFD_TWL4030_AUDIO_MODULE)
 #define twl_has_codec()	true
 #else
 #define twl_has_codec()	false
@@ -146,6 +146,7 @@
 #define SUB_CHIP_ID1 1
 #define SUB_CHIP_ID2 2
 #define SUB_CHIP_ID3 3
+#define SUB_CHIP_ID_INVAL 0xff
 
 #define TWL_MODULE_LAST TWL4030_MODULE_LAST
 
@@ -315,7 +316,7 @@ static struct twl_mapping twl6030_map[] = {
 	 * so they continue to match the order in this table.
 	 */
 	{ SUB_CHIP_ID1, TWL6030_BASEADD_USB },
-	{ SUB_CHIP_ID3, TWL6030_BASEADD_AUDIO },
+	{ SUB_CHIP_ID_INVAL, TWL6030_BASEADD_AUDIO },
 	{ SUB_CHIP_ID2, TWL6030_BASEADD_DIEID },
 	{ SUB_CHIP_ID2, TWL6030_BASEADD_RSV },
 	{ SUB_CHIP_ID1, TWL6030_BASEADD_PIH },
@@ -377,6 +378,11 @@ int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 		return -EPERM;
 	}
 	sid = twl_map[mod_no].sid;
+	if (unlikely(sid == SUB_CHIP_ID_INVAL)) {
+		pr_err("%s: module %d is not part of the pmic\n",
+		       DRIVER_NAME, mod_no);
+		return -EINVAL;
+	}
 	twl = &twl_modules[sid];
 
 	mutex_lock(&twl->xfer_lock);
@@ -434,6 +440,11 @@ int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 		return -EPERM;
 	}
 	sid = twl_map[mod_no].sid;
+	if (unlikely(sid == SUB_CHIP_ID_INVAL)) {
+		pr_err("%s: module %d is not part of the pmic\n",
+		       DRIVER_NAME, mod_no);
+		return -EINVAL;
+	}
 	twl = &twl_modules[sid];
 
 	mutex_lock(&twl->xfer_lock);
@@ -834,15 +845,6 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 			return PTR_ERR(child);
 	}
 
-	if (twl_has_codec() && pdata->audio && twl_class_is_6030()) {
-		sub_chip_id = twl_map[TWL_MODULE_AUDIO_VOICE].sid;
-		child = add_child(sub_chip_id, "twl6040",
-				pdata->audio, sizeof(*pdata->audio),
-				false, 0, 0);
-		if (IS_ERR(child))
-			return PTR_ERR(child);
-	}
-
 	/* twl4030 regulators */
 	if (twl_has_regulator() && twl_class_is_4030()) {
 		child = add_regulator(TWL4030_REG_VPLL1, pdata->vpll1,
@@ -1163,18 +1165,21 @@ int twl6030_exit_irq(void);
 
 static int twl_remove(struct i2c_client *client)
 {
-	unsigned i;
+	unsigned i, num_slaves;
 	int status;
 
-	if (twl_class_is_4030())
+	if (twl_class_is_4030()) {
 		status = twl4030_exit_irq();
-	else
+		num_slaves = TWL_NUM_SLAVES;
+	} else {
 		status = twl6030_exit_irq();
+		num_slaves = TWL_NUM_SLAVES - 1;
+	}
 
 	if (status < 0)
 		return status;
 
-	for (i = 0; i < TWL_NUM_SLAVES; i++) {
+	for (i = 0; i < num_slaves; i++) {
 		struct twl_client	*twl = &twl_modules[i];
 
 		if (twl->client && twl->client != client)
@@ -1190,7 +1195,7 @@ static int __devinit
 twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	int				status;
-	unsigned			i;
+	unsigned			i, num_slaves;
 	struct twl4030_platform_data	*pdata = client->dev.platform_data;
 	struct device_node		*node = client->dev.of_node;
 	u8 temp;
@@ -1244,7 +1249,17 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		return -EBUSY;
 	}
 
-	for (i = 0; i < TWL_NUM_SLAVES; i++) {
+	if ((id->driver_data) & TWL6030_CLASS) {
+		twl_id = TWL6030_CLASS_ID;
+		twl_map = &twl6030_map[0];
+		num_slaves = TWL_NUM_SLAVES - 1;
+	} else {
+		twl_id = TWL4030_CLASS_ID;
+		twl_map = &twl4030_map[0];
+		num_slaves = TWL_NUM_SLAVES;
+	}
+
+	for (i = 0; i < num_slaves; i++) {
 		struct twl_client	*twl = &twl_modules[i];
 
 		twl->address = client->addr + i;
@@ -1263,13 +1278,6 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		mutex_init(&twl->xfer_lock);
 	}
 	inuse = true;
-	if ((id->driver_data) & TWL6030_CLASS) {
-		twl_id = TWL6030_CLASS_ID;
-		twl_map = &twl6030_map[0];
-	} else {
-		twl_id = TWL4030_CLASS_ID;
-		twl_map = &twl4030_map[0];
-	}
 
 	/* setup clock framework */
 	clocks_init(&client->dev, pdata->clock);
-- 
1.7.8.4

