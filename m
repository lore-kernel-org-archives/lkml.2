Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030636Ab2CFMmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:42:07 -0500
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:48715 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030440Ab2CFMmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:42:04 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of peter.ujfalusi@ti.com designates 10.152.135.198 as permitted sender) smtp.mail=peter.ujfalusi@ti.com
MIME-Version: 1.0
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Tony Lindgren <tony@atomide.com>, Liam Girdwood <lrg@ti.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-next@vger.kernel.org, paul.gortmaker@windriver.com
Subject: [PATCH 5/5] Revert "mfd: Detach twl6040 from the pmic mfd driver"
Date: Tue,  6 Mar 2012 14:35:16 +0200
Message-Id: <1331037316-7375-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1331037316-7375-1-git-send-email-peter.ujfalusi@ti.com>
References: <1331037316-7375-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 49976f5f8ec350ee0e1191237bb06325840ae5d9.

Reverting changes regarding to twl6040 in MFD tree since the patches will go
via the audio tree.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl-core.c |   58 ++++++++++++++++++++---------------------------
 1 files changed, 25 insertions(+), 33 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 6c236d0..c1e4f1a 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -115,8 +115,8 @@
 #define twl_has_watchdog()        false
 #endif
 
-#if defined(CONFIG_MFD_TWL4030_AUDIO) || \
-	defined(CONFIG_MFD_TWL4030_AUDIO_MODULE)
+#if defined(CONFIG_MFD_TWL4030_AUDIO) || defined(CONFIG_MFD_TWL4030_AUDIO_MODULE) ||\
+	defined(CONFIG_TWL6040_CORE) || defined(CONFIG_TWL6040_CORE_MODULE)
 #define twl_has_codec()	true
 #else
 #define twl_has_codec()	false
@@ -146,7 +146,6 @@
 #define SUB_CHIP_ID1 1
 #define SUB_CHIP_ID2 2
 #define SUB_CHIP_ID3 3
-#define SUB_CHIP_ID_INVAL 0xff
 
 #define TWL_MODULE_LAST TWL4030_MODULE_LAST
 
@@ -318,7 +317,7 @@ static struct twl_mapping twl6030_map[] = {
 	 * so they continue to match the order in this table.
 	 */
 	{ SUB_CHIP_ID1, TWL6030_BASEADD_USB },
-	{ SUB_CHIP_ID_INVAL, TWL6030_BASEADD_AUDIO },
+	{ SUB_CHIP_ID3, TWL6030_BASEADD_AUDIO },
 	{ SUB_CHIP_ID2, TWL6030_BASEADD_DIEID },
 	{ SUB_CHIP_ID2, TWL6030_BASEADD_RSV },
 	{ SUB_CHIP_ID1, TWL6030_BASEADD_PIH },
@@ -380,11 +379,6 @@ int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 		return -EPERM;
 	}
 	sid = twl_map[mod_no].sid;
-	if (unlikely(sid == SUB_CHIP_ID_INVAL)) {
-		pr_err("%s: module %d is not part of the pmic\n",
-		       DRIVER_NAME, mod_no);
-		return -EINVAL;
-	}
 	twl = &twl_modules[sid];
 
 	mutex_lock(&twl->xfer_lock);
@@ -442,11 +436,6 @@ int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 		return -EPERM;
 	}
 	sid = twl_map[mod_no].sid;
-	if (unlikely(sid == SUB_CHIP_ID_INVAL)) {
-		pr_err("%s: module %d is not part of the pmic\n",
-		       DRIVER_NAME, mod_no);
-		return -EINVAL;
-	}
 	twl = &twl_modules[sid];
 
 	mutex_lock(&twl->xfer_lock);
@@ -847,6 +836,15 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 			return PTR_ERR(child);
 	}
 
+	if (twl_has_codec() && pdata->audio && twl_class_is_6030()) {
+		sub_chip_id = twl_map[TWL_MODULE_AUDIO_VOICE].sid;
+		child = add_child(sub_chip_id, "twl6040",
+				pdata->audio, sizeof(*pdata->audio),
+				false, 0, 0);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+	}
+
 	/* twl4030 regulators */
 	if (twl_has_regulator() && twl_class_is_4030()) {
 		child = add_regulator(TWL4030_REG_VPLL1, pdata->vpll1,
@@ -1167,21 +1165,18 @@ int twl6030_exit_irq(void);
 
 static int twl_remove(struct i2c_client *client)
 {
-	unsigned i, num_slaves;
+	unsigned i;
 	int status;
 
-	if (twl_class_is_4030()) {
+	if (twl_class_is_4030())
 		status = twl4030_exit_irq();
-		num_slaves = TWL_NUM_SLAVES;
-	} else {
+	else
 		status = twl6030_exit_irq();
-		num_slaves = TWL_NUM_SLAVES - 1;
-	}
 
 	if (status < 0)
 		return status;
 
-	for (i = 0; i < num_slaves; i++) {
+	for (i = 0; i < TWL_NUM_SLAVES; i++) {
 		struct twl_client	*twl = &twl_modules[i];
 
 		if (twl->client && twl->client != client)
@@ -1197,7 +1192,7 @@ static int __devinit
 twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	int				status;
-	unsigned			i, num_slaves;
+	unsigned			i;
 	struct twl4030_platform_data	*pdata = client->dev.platform_data;
 	struct device_node		*node = client->dev.of_node;
 	u8 temp;
@@ -1251,17 +1246,7 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		return -EBUSY;
 	}
 
-	if ((id->driver_data) & TWL6030_CLASS) {
-		twl_id = TWL6030_CLASS_ID;
-		twl_map = &twl6030_map[0];
-		num_slaves = TWL_NUM_SLAVES - 1;
-	} else {
-		twl_id = TWL4030_CLASS_ID;
-		twl_map = &twl4030_map[0];
-		num_slaves = TWL_NUM_SLAVES;
-	}
-
-	for (i = 0; i < num_slaves; i++) {
+	for (i = 0; i < TWL_NUM_SLAVES; i++) {
 		struct twl_client	*twl = &twl_modules[i];
 
 		twl->address = client->addr + i;
@@ -1280,6 +1265,13 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		mutex_init(&twl->xfer_lock);
 	}
 	inuse = true;
+	if ((id->driver_data) & TWL6030_CLASS) {
+		twl_id = TWL6030_CLASS_ID;
+		twl_map = &twl6030_map[0];
+	} else {
+		twl_id = TWL4030_CLASS_ID;
+		twl_map = &twl4030_map[0];
+	}
 
 	/* setup clock framework */
 	clocks_init(&client->dev, pdata->clock);
-- 
1.7.8.5

