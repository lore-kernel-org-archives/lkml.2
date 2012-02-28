Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab2B1IfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:35:12 -0500
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:55615 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756196Ab2B1IfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 03:35:10 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of peter.ujfalusi@ti.com designates 10.152.129.69 as permitted sender) smtp.mail=peter.ujfalusi@ti.com
MIME-Version: 1.0
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] MFD: twl-core: Detach twl6040 from the pmic mfd driver
Date: Tue, 28 Feb 2012 10:34:51 +0200
Message-Id: <1330418092-12314-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1330418092-12314-1-git-send-email-peter.ujfalusi@ti.com>
References: <1330418092-12314-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On OMAP4 platform audio has separate IC, it is no longer part
of the pmic chip.
Prevent twl-core to claim the 0x4b address, which belongs to
the twl6040 audio IC.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/twl-core.c |   58 +++++++++++++++++++++++++++--------------------
 1 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 8ce3959..9ac003a 100644
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
 
@@ -317,7 +318,7 @@ static struct twl_mapping twl6030_map[] = {
 	 * so they continue to match the order in this table.
 	 */
 	{ SUB_CHIP_ID1, TWL6030_BASEADD_USB },
-	{ SUB_CHIP_ID3, TWL6030_BASEADD_AUDIO },
+	{ SUB_CHIP_ID_INVAL, TWL6030_BASEADD_AUDIO },
 	{ SUB_CHIP_ID2, TWL6030_BASEADD_DIEID },
 	{ SUB_CHIP_ID2, TWL6030_BASEADD_RSV },
 	{ SUB_CHIP_ID1, TWL6030_BASEADD_PIH },
@@ -379,6 +380,11 @@ int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
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
@@ -436,6 +442,11 @@ int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
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
@@ -836,15 +847,6 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
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
@@ -1165,18 +1167,21 @@ int twl6030_exit_irq(void);
 
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
@@ -1192,7 +1197,7 @@ static int __devinit
 twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	int				status;
-	unsigned			i;
+	unsigned			i, num_slaves;
 	struct twl4030_platform_data	*pdata = client->dev.platform_data;
 	struct device_node		*node = client->dev.of_node;
 	u8 temp;
@@ -1246,7 +1251,17 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
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
@@ -1265,13 +1280,6 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
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

