Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab1BFX2v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:28:51 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:54839 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab1BFX2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:28:49 -0500
Date: Sun, 6 Feb 2011 15:28:46 -0800
From: Andres Salomon <dilinger@queued.net>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, cjb@laptop.org,
        jon.nettleton@gmail.com
Subject: [PATCH 3/4] olpc_dcon: move more variables into dcon_priv
Message-ID: <20110206152846.68f14482@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Global variables for display mode and the current sleep state
can go into dcon_priv as well.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |   69 +++++++++++++++++----------------
 drivers/staging/olpc_dcon/olpc_dcon.h |    4 --
 2 files changed, 35 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index a81e325..5d85d77 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -59,8 +59,12 @@ struct dcon_priv {
 	struct work_struct switch_source;
 	struct notifier_block reboot_nb;
 
+	/* Shadow register for the DCON_REG_MODE register */
+	u8 disp_mode;
+
 	/* Current output type; true == mono, false == color */
 	bool mono:1;
+	bool asleep:1;
 };
 
 /* I2C structures */
@@ -84,12 +88,6 @@ static int dcon_source;
 /* Desired source */
 static int dcon_pending;
 
-/* Current sleep status (not yet implemented) */
-static int dcon_sleep_val = DCON_ACTIVE;
-
-/* Shadow register for the DCON_REG_MODE register */
-static unsigned short dcon_disp_mode;
-
 /* Variables used during switches */
 static int dcon_switched;
 static struct timespec dcon_irq_time;
@@ -164,11 +162,12 @@ static int dcon_hw_init(struct dcon_priv *dcon, int is_init)
 
 	/* Colour swizzle, AA, no passthrough, backlight */
 	if (is_init) {
-		dcon_disp_mode = MODE_PASSTHRU | MODE_BL_ENABLE | MODE_CSWIZZLE;
+		dcon->disp_mode = MODE_PASSTHRU | MODE_BL_ENABLE |
+				MODE_CSWIZZLE;
 		if (useaa)
-			dcon_disp_mode |= MODE_COL_AA;
+			dcon->disp_mode |= MODE_COL_AA;
 	}
-	i2c_smbus_write_word_data(client, DCON_REG_MODE, dcon_disp_mode);
+	i2c_smbus_write_word_data(client, DCON_REG_MODE, dcon->disp_mode);
 
 
 	/* Set the scanline to interrupt on during resume */
@@ -245,11 +244,11 @@ static void dcon_set_backlight_hw(struct dcon_priv *dcon, int level)
 
 	/* Purposely turn off the backlight when we go to level 0 */
 	if (bl_val == 0) {
-		dcon_disp_mode &= ~MODE_BL_ENABLE;
-		dcon_write(dcon, DCON_REG_MODE, dcon_disp_mode);
-	} else if (!(dcon_disp_mode & MODE_BL_ENABLE)) {
-		dcon_disp_mode |= MODE_BL_ENABLE;
-		dcon_write(dcon, DCON_REG_MODE, dcon_disp_mode);
+		dcon->disp_mode &= ~MODE_BL_ENABLE;
+		dcon_write(dcon, DCON_REG_MODE, dcon->disp_mode);
+	} else if (!(dcon->disp_mode & MODE_BL_ENABLE)) {
+		dcon->disp_mode |= MODE_BL_ENABLE;
+		dcon_write(dcon, DCON_REG_MODE, dcon->disp_mode);
 	}
 }
 
@@ -273,16 +272,16 @@ static int dcon_set_mono_mode(struct dcon_priv *dcon, bool enable_mono)
 	dcon->mono = enable_mono;
 
 	if (enable_mono) {
-		dcon_disp_mode &= ~(MODE_CSWIZZLE | MODE_COL_AA);
-		dcon_disp_mode |= MODE_MONO_LUMA;
+		dcon->disp_mode &= ~(MODE_CSWIZZLE | MODE_COL_AA);
+		dcon->disp_mode |= MODE_MONO_LUMA;
 	} else {
-		dcon_disp_mode &= ~(MODE_MONO_LUMA);
-		dcon_disp_mode |= MODE_CSWIZZLE;
+		dcon->disp_mode &= ~(MODE_MONO_LUMA);
+		dcon->disp_mode |= MODE_CSWIZZLE;
 		if (useaa)
-			dcon_disp_mode |= MODE_COL_AA;
+			dcon->disp_mode |= MODE_COL_AA;
 	}
 
-	dcon_write(dcon, DCON_REG_MODE, dcon_disp_mode);
+	dcon_write(dcon, DCON_REG_MODE, dcon->disp_mode);
 	return 0;
 }
 
@@ -290,36 +289,36 @@ static int dcon_set_mono_mode(struct dcon_priv *dcon, bool enable_mono)
  * DCONLOAD works in a sleep and account for it accordingly
  */
 
-static void dcon_sleep(struct dcon_priv *dcon, int state)
+static void dcon_sleep(struct dcon_priv *dcon, bool sleep)
 {
 	int x;
 
 	/* Turn off the backlight and put the DCON to sleep */
 
-	if (state == dcon_sleep_val)
+	if (dcon->asleep == sleep)
 		return;
 
 	if (!olpc_board_at_least(olpc_board(0xc2)))
 		return;
 
-	if (state == DCON_SLEEP) {
+	if (sleep) {
 		x = 0;
 		x = olpc_ec_cmd(0x26, (unsigned char *) &x, 1, NULL, 0);
 		if (x)
 			printk(KERN_WARNING "olpc-dcon:  unable to force dcon "
 					"to power down: %d!\n", x);
 		else
-			dcon_sleep_val = state;
+			dcon->asleep = sleep;
 	} else {
 		/* Only re-enable the backlight if the backlight value is set */
 		if (bl_val != 0)
-			dcon_disp_mode |= MODE_BL_ENABLE;
+			dcon->disp_mode |= MODE_BL_ENABLE;
 		x = dcon_bus_stabilize(dcon, 1);
 		if (x)
 			printk(KERN_WARNING "olpc-dcon:  unable to reinit dcon"
 					" hardware: %d!\n", x);
 		else
-			dcon_sleep_val = state;
+			dcon->asleep = sleep;
 
 		/* Restore backlight */
 		dcon_set_backlight_hw(dcon, bl_val);
@@ -367,7 +366,7 @@ static void dcon_source_switch(struct work_struct *work)
 		printk("dcon_source_switch to CPU\n");
 		/* Enable the scanline interrupt bit */
 		if (dcon_write(dcon, DCON_REG_MODE,
-				dcon_disp_mode | MODE_SCAN_INT))
+				dcon->disp_mode | MODE_SCAN_INT))
 			printk(KERN_ERR
 			       "olpc-dcon:  couldn't enable scanline interrupt!\n");
 		else {
@@ -380,7 +379,7 @@ static void dcon_source_switch(struct work_struct *work)
 			printk(KERN_ERR "olpc-dcon:  Timeout entering CPU mode; expect a screen glitch.\n");
 
 		/* Turn off the scanline interrupt */
-		if (dcon_write(dcon, DCON_REG_MODE, dcon_disp_mode))
+		if (dcon_write(dcon, DCON_REG_MODE, dcon->disp_mode))
 			printk(KERN_ERR "olpc-dcon:  couldn't disable scanline interrupt!\n");
 
 		/*
@@ -508,14 +507,16 @@ static int dconbl_get(struct backlight_device *dev)
 static ssize_t dcon_mode_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%4.4X\n", dcon_disp_mode);
+	struct dcon_priv *dcon = dev_get_drvdata(dev);
+	return sprintf(buf, "%4.4X\n", dcon->disp_mode);
 }
 
 static ssize_t dcon_sleep_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
 
-	return sprintf(buf, "%d\n", dcon_sleep_val);
+	struct dcon_priv *dcon = dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", dcon->asleep ? 1 : 0);
 }
 
 static ssize_t dcon_freeze_show(struct device *dev,
@@ -621,7 +622,7 @@ static ssize_t dcon_sleep_store(struct device *dev,
 	if (_strtoul(buf, count, &output))
 		return -EINVAL;
 
-	dcon_sleep(dev_get_drvdata(dev), output ? DCON_SLEEP : DCON_ACTIVE);
+	dcon_sleep(dev_get_drvdata(dev), output ? true : false);
 	return count;
 }
 
@@ -679,7 +680,7 @@ static int fb_notifier_callback(struct notifier_block *self,
 	if (((event != FB_EVENT_BLANK) && (event != FB_EVENT_CONBLANK)) ||
 			ignore_fb_events)
 		return 0;
-	dcon_sleep(dcon, (*blank) ? DCON_SLEEP : DCON_ACTIVE);
+	dcon_sleep(dcon, *blank ? true : false);
 	return 0;
 }
 
@@ -808,7 +809,7 @@ static int dcon_suspend(struct i2c_client *client, pm_message_t state)
 {
 	struct dcon_priv *dcon = i2c_get_clientdata(client);
 
-	if (dcon_sleep_val == DCON_ACTIVE) {
+	if (!dcon->asleep) {
 		/* Set up the DCON to have the source */
 		dcon_set_source_sync(dcon, DCON_SOURCE_DCON);
 	}
@@ -820,7 +821,7 @@ static int dcon_resume(struct i2c_client *client)
 {
 	struct dcon_priv *dcon = i2c_get_clientdata(client);
 
-	if (dcon_sleep_val == DCON_ACTIVE) {
+	if (!dcon->asleep) {
 		dcon_bus_stabilize(dcon, 0);
 		dcon_set_source(dcon, DCON_SOURCE_CPU);
 	}
diff --git a/drivers/staging/olpc_dcon/olpc_dcon.h b/drivers/staging/olpc_dcon/olpc_dcon.h
index 77dcbd1..cef2473 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.h
+++ b/drivers/staging/olpc_dcon/olpc_dcon.h
@@ -41,10 +41,6 @@
 #define DCON_SOURCE_DCON        0
 #define DCON_SOURCE_CPU         1
 
-/* Sleep values */
-#define DCON_ACTIVE             0
-#define DCON_SLEEP              1
-
 /* Interrupt */
 #define DCON_IRQ                6
 
-- 
1.7.2.3

