Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab1BKB4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 20:56:32 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:56692 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231Ab1BKB4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 20:56:31 -0500
Date: Thu, 10 Feb 2011 17:56:27 -0800
From: Andres Salomon <dilinger@queued.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, jon.nettleton@gmail.com,
        devel@driverdev.osuosl.org
Subject: [PATCH 09/10] olpc_dcon: clean up backlight handling
Message-ID: <20110210175627.4cda6ab4@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 - Move bl_val and bl_dev into dcon_priv struct....
 - The only time we ever read the backlight val from the dcon is
   at probe time.  Rather than calling dcon_get_backlight for that, just
   read from the register.
 - Drop dcon_get_backlight; it's just returning dcon->bl_val.
 - Rename dcon_set_backlight_hw to dcon_set_backlight, and drop the
   old dcon_set_backlight function.  Move contents of old dcon_set_backlight
   function into dconbl_set.
 - Shuffle backlight_ops callbacks around to be closer to struct, and
   rename them.
 - Make use of new backlight_properties arg to backlight_device_register,
   drop old code that set this manually.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |  113 +++++++++++++--------------------
 drivers/staging/olpc_dcon/olpc_dcon.h |    4 +
 2 files changed, 47 insertions(+), 70 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 07abdfa..b90c2cf 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -50,9 +50,6 @@ static struct dcon_platform_data *pdata;
 /* Platform devices */
 static struct platform_device *dcon_device;
 
-/* Backlight device */
-static struct backlight_device *dcon_bl_dev;
-
 static DECLARE_WAIT_QUEUE_HEAD(dcon_wait_queue);
 
 static unsigned short normal_i2c[] = { 0x0d, I2C_CLIENT_END };
@@ -67,9 +64,6 @@ static s32 dcon_read(struct dcon_priv *dcon, u8 reg)
 	return i2c_smbus_read_word_data(dcon->client, reg);
 }
 
-/* The current backlight value - this saves us some smbus traffic */
-static int bl_val = -1;
-
 /* ===== API functions - these are called by a variety of users ==== */
 
 static int dcon_hw_init(struct dcon_priv *dcon, int is_init)
@@ -185,25 +179,13 @@ power_up:
 	return 0;
 }
 
-static int dcon_get_backlight(struct dcon_priv *dcon)
+static void dcon_set_backlight(struct dcon_priv *dcon, u8 level)
 {
-	if (!dcon || !dcon->client)
-		return 0;
-
-	if (bl_val == -1)
-		bl_val = dcon_read(dcon, DCON_REG_BRIGHT) & 0x0F;
-
-	return bl_val;
-}
-
-
-static void dcon_set_backlight_hw(struct dcon_priv *dcon, int level)
-{
-	bl_val = level & 0x0F;
-	dcon_write(dcon, DCON_REG_BRIGHT, bl_val);
+	dcon->bl_val = level;
+	dcon_write(dcon, DCON_REG_BRIGHT, dcon->bl_val);
 
 	/* Purposely turn off the backlight when we go to level 0 */
-	if (bl_val == 0) {
+	if (dcon->bl_val == 0) {
 		dcon->disp_mode &= ~MODE_BL_ENABLE;
 		dcon_write(dcon, DCON_REG_MODE, dcon->disp_mode);
 	} else if (!(dcon->disp_mode & MODE_BL_ENABLE)) {
@@ -212,17 +194,6 @@ static void dcon_set_backlight_hw(struct dcon_priv *dcon, int level)
 	}
 }
 
-static void dcon_set_backlight(struct dcon_priv *dcon, int level)
-{
-	if (!dcon || !dcon->client)
-		return;
-
-	if (bl_val == (level & 0x0F))
-		return;
-
-	dcon_set_backlight_hw(dcon, level);
-}
-
 /* Set the output type to either color or mono */
 static int dcon_set_mono_mode(struct dcon_priv *dcon, bool enable_mono)
 {
@@ -271,7 +242,7 @@ static void dcon_sleep(struct dcon_priv *dcon, bool sleep)
 			dcon->asleep = sleep;
 	} else {
 		/* Only re-enable the backlight if the backlight value is set */
-		if (bl_val != 0)
+		if (dcon->bl_val != 0)
 			dcon->disp_mode |= MODE_BL_ENABLE;
 		x = dcon_bus_stabilize(dcon, 1);
 		if (x)
@@ -281,7 +252,7 @@ static void dcon_sleep(struct dcon_priv *dcon, bool sleep)
 			dcon->asleep = sleep;
 
 		/* Restore backlight */
-		dcon_set_backlight_hw(dcon, bl_val);
+		dcon_set_backlight(dcon, dcon->bl_val);
 	}
 
 	/* We should turn off some stuff in the framebuffer - but what? */
@@ -458,24 +429,6 @@ static void dcon_set_source_sync(struct dcon_priv *dcon, int arg)
 	flush_scheduled_work();
 }
 
-static int dconbl_set(struct backlight_device *dev)
-{
-	struct dcon_priv *dcon = bl_get_data(dev);
-	int level = dev->props.brightness;
-
-	if (dev->props.power != FB_BLANK_UNBLANK)
-		level = 0;
-
-	dcon_set_backlight(dcon, level);
-	return 0;
-}
-
-static int dconbl_get(struct backlight_device *dev)
-{
-	struct dcon_priv *dcon = bl_get_data(dev);
-	return dcon_get_backlight(dcon);
-}
-
 static ssize_t dcon_mode_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
@@ -594,11 +547,35 @@ static struct device_attribute dcon_device_files[] = {
 	__ATTR(resumeline, 0644, dcon_resumeline_show, dcon_resumeline_store),
 };
 
+static int dcon_bl_update(struct backlight_device *dev)
+{
+	struct dcon_priv *dcon = bl_get_data(dev);
+	u8 level = dev->props.brightness & 0x0F;
+
+	if (dev->props.power != FB_BLANK_UNBLANK)
+		level = 0;
+
+	if (level != dcon->bl_val)
+		dcon_set_backlight(dcon, level);
+
+	return 0;
+}
+
+static int dcon_bl_get(struct backlight_device *dev)
+{
+	struct dcon_priv *dcon = bl_get_data(dev);
+	return dcon->bl_val;
+}
+
 static const struct backlight_ops dcon_bl_ops = {
-	.get_brightness = dconbl_get,
-	.update_status = dconbl_set
+	.update_status = dcon_bl_update,
+	.get_brightness = dcon_bl_get,
 };
 
+static struct backlight_properties dcon_bl_props = {
+	.max_brightness = 15,
+	.power = FB_BLANK_UNBLANK,
+};
 
 static int dcon_reboot_notify(struct notifier_block *nb,
 			      unsigned long foo, void *bar)
@@ -707,20 +684,16 @@ static int dcon_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		}
 	}
 
-	/* Add the backlight device for the DCON */
-	dcon_bl_dev = backlight_device_register("dcon-bl", &dcon_device->dev,
-		dcon, &dcon_bl_ops, NULL);
-
-	if (IS_ERR(dcon_bl_dev)) {
-		printk(KERN_ERR "Cannot register the backlight device (%ld)\n",
-		       PTR_ERR(dcon_bl_dev));
-		dcon_bl_dev = NULL;
-	} else {
-		dcon_bl_dev->props.max_brightness = 15;
-		dcon_bl_dev->props.power = FB_BLANK_UNBLANK;
-		dcon_bl_dev->props.brightness = dcon_get_backlight(dcon);
+	dcon->bl_val = dcon_read(dcon, DCON_REG_BRIGHT) & 0x0F;
 
-		backlight_update_status(dcon_bl_dev);
+	/* Add the backlight device for the DCON */
+	dcon_bl_props.brightness = dcon->bl_val;
+	dcon->bl_dev = backlight_device_register("dcon-bl", &dcon_device->dev,
+		dcon, &dcon_bl_ops, &dcon_bl_props);
+	if (IS_ERR(dcon->bl_dev)) {
+		dev_err(&client->dev, "cannot register backlight dev (%ld)\n",
+				PTR_ERR(dcon->bl_dev));
+		dcon->bl_dev = NULL;
 	}
 
 	register_reboot_notifier(&dcon->reboot_nb);
@@ -755,8 +728,8 @@ static int dcon_remove(struct i2c_client *client)
 
 	free_irq(DCON_IRQ, dcon);
 
-	if (dcon_bl_dev != NULL)
-		backlight_device_unregister(dcon_bl_dev);
+	if (dcon->bl_dev)
+		backlight_device_unregister(dcon->bl_dev);
 
 	if (dcon_device != NULL)
 		platform_device_unregister(dcon_device);
diff --git a/drivers/staging/olpc_dcon/olpc_dcon.h b/drivers/staging/olpc_dcon/olpc_dcon.h
index 62bed46..0264c94 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.h
+++ b/drivers/staging/olpc_dcon/olpc_dcon.h
@@ -50,6 +50,7 @@
 struct dcon_priv {
 	struct i2c_client *client;
 	struct fb_info *fbinfo;
+	struct backlight_device *bl_dev;
 
 	struct work_struct switch_source;
 	struct notifier_block reboot_nb;
@@ -58,6 +59,9 @@ struct dcon_priv {
 	/* Shadow register for the DCON_REG_MODE register */
 	u8 disp_mode;
 
+	/* The current backlight value - this saves us some smbus traffic */
+	u8 bl_val;
+
 	/* Current source, initialized at probe time */
 	int curr_src;
 
-- 
1.7.2.3

