Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab1BFX2f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:28:35 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:54830 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126Ab1BFX2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:28:34 -0500
Date: Sun, 6 Feb 2011 15:28:30 -0800
From: Andres Salomon <dilinger@queued.net>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, cjb@laptop.org,
        jon.nettleton@gmail.com
Cc: devel@driverdev.osuosl.org
Subject: [PATCH 1/4] olpc_dcon: get rid of global i2c_client, create a
 dcon_priv struct
Message-ID: <20110206152830.3f173e22@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rather than using the global i2c_client variable, create a dcon_priv
struct, store in the drvdata portion of the dev, and pass that around.

In order to access dcon struct from various callbacks, include
the reboot notifier and source switching work struct in the dcon struct.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |  163 ++++++++++++++++++++-------------
 1 files changed, 99 insertions(+), 64 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index d6ad5d7..f43c4ec 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -53,10 +53,16 @@ struct dcon_platform_data {
 
 static struct dcon_platform_data *pdata;
 
+struct dcon_priv {
+	struct i2c_client *client;
+
+	struct work_struct switch_source;
+	struct notifier_block reboot_nb;
+};
+
 /* I2C structures */
 
 static struct i2c_driver dcon_driver;
-static struct i2c_client *dcon_client;
 
 /* Platform devices */
 static struct platform_device *dcon_device;
@@ -93,16 +99,24 @@ static DECLARE_WAIT_QUEUE_HEAD(dcon_wait_queue);
 
 static unsigned short normal_i2c[] = { 0x0d, I2C_CLIENT_END };
 
-#define dcon_write(reg, val) i2c_smbus_write_word_data(dcon_client, reg, val)
-#define dcon_read(reg) i2c_smbus_read_word_data(dcon_client, reg)
+static s32 dcon_write(struct dcon_priv *dcon, u8 reg, u16 val)
+{
+	return i2c_smbus_write_word_data(dcon->client, reg, val);
+}
+
+static s32 dcon_read(struct dcon_priv *dcon, u8 reg)
+{
+	return i2c_smbus_read_word_data(dcon->client, reg);
+}
 
 /* The current backlight value - this saves us some smbus traffic */
 static int bl_val = -1;
 
 /* ===== API functions - these are called by a variety of users ==== */
 
-static int dcon_hw_init(struct i2c_client *client, int is_init)
+static int dcon_hw_init(struct dcon_priv *dcon, int is_init)
 {
+	struct i2c_client *client = dcon->client;
 	uint16_t ver;
 	int rc = 0;
 
@@ -173,7 +187,7 @@ err:
  * smbus.  For newer models, we simply BUG(); we want to know if this
  * still happens despite the power fixes that have been made!
  */
-static int dcon_bus_stabilize(struct i2c_client *client, int is_powered_down)
+static int dcon_bus_stabilize(struct dcon_priv *dcon, int is_powered_down)
 {
 	unsigned long timeout;
 	int x;
@@ -194,7 +208,7 @@ power_up:
 
 	for (x = -1, timeout = 50; timeout && x < 0; timeout--) {
 		msleep(1);
-		x = dcon_read(DCON_REG_ID);
+		x = dcon_read(dcon, DCON_REG_ID);
 	}
 	if (x < 0) {
 		printk(KERN_ERR "olpc-dcon:  unable to stabilize dcon's "
@@ -208,51 +222,51 @@ power_up:
 	}
 
 	if (is_powered_down)
-		return dcon_hw_init(client, 0);
+		return dcon_hw_init(dcon, 0);
 	return 0;
 }
 
-static int dcon_get_backlight(void)
+static int dcon_get_backlight(struct dcon_priv *dcon)
 {
-	if (dcon_client == NULL)
+	if (!dcon || !dcon->client)
 		return 0;
 
 	if (bl_val == -1)
-		bl_val = dcon_read(DCON_REG_BRIGHT) & 0x0F;
+		bl_val = dcon_read(dcon, DCON_REG_BRIGHT) & 0x0F;
 
 	return bl_val;
 }
 
 
-static void dcon_set_backlight_hw(int level)
+static void dcon_set_backlight_hw(struct dcon_priv *dcon, int level)
 {
 	bl_val = level & 0x0F;
-	dcon_write(DCON_REG_BRIGHT, bl_val);
+	dcon_write(dcon, DCON_REG_BRIGHT, bl_val);
 
 	/* Purposely turn off the backlight when we go to level 0 */
 	if (bl_val == 0) {
 		dcon_disp_mode &= ~MODE_BL_ENABLE;
-		dcon_write(DCON_REG_MODE, dcon_disp_mode);
+		dcon_write(dcon, DCON_REG_MODE, dcon_disp_mode);
 	} else if (!(dcon_disp_mode & MODE_BL_ENABLE)) {
 		dcon_disp_mode |= MODE_BL_ENABLE;
-		dcon_write(DCON_REG_MODE, dcon_disp_mode);
+		dcon_write(dcon, DCON_REG_MODE, dcon_disp_mode);
 	}
 }
 
-static void dcon_set_backlight(int level)
+static void dcon_set_backlight(struct dcon_priv *dcon, int level)
 {
-	if (dcon_client == NULL)
+	if (!dcon || !dcon->client)
 		return;
 
 	if (bl_val == (level & 0x0F))
 		return;
 
-	dcon_set_backlight_hw(level);
+	dcon_set_backlight_hw(dcon, level);
 }
 
 /* Set the output type to either color or mono */
 
-static int dcon_set_output(int arg)
+static int dcon_set_output(struct dcon_priv *dcon, int arg)
 {
 	if (dcon_output == arg)
 		return 0;
@@ -269,7 +283,7 @@ static int dcon_set_output(int arg)
 			dcon_disp_mode |= MODE_COL_AA;
 	}
 
-	dcon_write(DCON_REG_MODE, dcon_disp_mode);
+	dcon_write(dcon, DCON_REG_MODE, dcon_disp_mode);
 	return 0;
 }
 
@@ -277,7 +291,7 @@ static int dcon_set_output(int arg)
  * DCONLOAD works in a sleep and account for it accordingly
  */
 
-static void dcon_sleep(int state)
+static void dcon_sleep(struct dcon_priv *dcon, int state)
 {
 	int x;
 
@@ -301,7 +315,7 @@ static void dcon_sleep(int state)
 		/* Only re-enable the backlight if the backlight value is set */
 		if (bl_val != 0)
 			dcon_disp_mode |= MODE_BL_ENABLE;
-		x = dcon_bus_stabilize(dcon_client, 1);
+		x = dcon_bus_stabilize(dcon, 1);
 		if (x)
 			printk(KERN_WARNING "olpc-dcon:  unable to reinit dcon"
 					" hardware: %d!\n", x);
@@ -309,7 +323,7 @@ static void dcon_sleep(int state)
 			dcon_sleep_val = state;
 
 		/* Restore backlight */
-		dcon_set_backlight_hw(bl_val);
+		dcon_set_backlight_hw(dcon, bl_val);
 	}
 
 	/* We should turn off some stuff in the framebuffer - but what? */
@@ -337,6 +351,8 @@ void dcon_load_holdoff(void)
 
 static void dcon_source_switch(struct work_struct *work)
 {
+	struct dcon_priv *dcon = container_of(work, struct dcon_priv,
+			switch_source);
 	DECLARE_WAITQUEUE(wait, current);
 	int source = dcon_pending;
 
@@ -351,7 +367,8 @@ static void dcon_source_switch(struct work_struct *work)
 	case DCON_SOURCE_CPU:
 		printk("dcon_source_switch to CPU\n");
 		/* Enable the scanline interrupt bit */
-		if (dcon_write(DCON_REG_MODE, dcon_disp_mode | MODE_SCAN_INT))
+		if (dcon_write(dcon, DCON_REG_MODE,
+				dcon_disp_mode | MODE_SCAN_INT))
 			printk(KERN_ERR
 			       "olpc-dcon:  couldn't enable scanline interrupt!\n");
 		else {
@@ -364,7 +381,7 @@ static void dcon_source_switch(struct work_struct *work)
 			printk(KERN_ERR "olpc-dcon:  Timeout entering CPU mode; expect a screen glitch.\n");
 
 		/* Turn off the scanline interrupt */
-		if (dcon_write(DCON_REG_MODE, dcon_disp_mode))
+		if (dcon_write(dcon, DCON_REG_MODE, dcon_disp_mode))
 			printk(KERN_ERR "olpc-dcon:  couldn't disable scanline interrupt!\n");
 
 		/*
@@ -454,40 +471,39 @@ static void dcon_source_switch(struct work_struct *work)
 	dcon_source = source;
 }
 
-static DECLARE_WORK(dcon_work, dcon_source_switch);
-
-static void dcon_set_source(int arg)
+static void dcon_set_source(struct dcon_priv *dcon, int arg)
 {
 	if (dcon_pending == arg)
 		return;
 
 	dcon_pending = arg;
 
-	if ((dcon_source != arg) && !work_pending(&dcon_work))
-		schedule_work(&dcon_work);
+	if ((dcon_source != arg) && !work_pending(&dcon->switch_source))
+		schedule_work(&dcon->switch_source);
 }
 
-static void dcon_set_source_sync(int arg)
+static void dcon_set_source_sync(struct dcon_priv *dcon, int arg)
 {
-	dcon_set_source(arg);
+	dcon_set_source(dcon, arg);
 	flush_scheduled_work();
 }
 
 static int dconbl_set(struct backlight_device *dev)
 {
-
+	struct dcon_priv *dcon = bl_get_data(dev);
 	int level = dev->props.brightness;
 
 	if (dev->props.power != FB_BLANK_UNBLANK)
 		level = 0;
 
-	dcon_set_backlight(level);
+	dcon_set_backlight(dcon, level);
 	return 0;
 }
 
 static int dconbl_get(struct backlight_device *dev)
 {
-	return dcon_get_backlight();
+	struct dcon_priv *dcon = bl_get_data(dev);
+	return dcon_get_backlight(dcon);
 }
 
 static ssize_t dcon_mode_show(struct device *dev,
@@ -548,7 +564,7 @@ static ssize_t dcon_output_store(struct device *dev,
 		return -EINVAL;
 
 	if (output == DCON_OUTPUT_COLOR || output == DCON_OUTPUT_MONO) {
-		dcon_set_output(output);
+		dcon_set_output(dev_get_drvdata(dev), output);
 		rc = count;
 	}
 
@@ -558,6 +574,7 @@ static ssize_t dcon_output_store(struct device *dev,
 static ssize_t dcon_freeze_store(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
+	struct dcon_priv *dcon = dev_get_drvdata(dev);
 	int output;
 
 	if (_strtoul(buf, count, &output))
@@ -567,13 +584,13 @@ static ssize_t dcon_freeze_store(struct device *dev,
 
 	switch (output) {
 	case 0:
-		dcon_set_source(DCON_SOURCE_CPU);
+		dcon_set_source(dcon, DCON_SOURCE_CPU);
 		break;
 	case 1:
-		dcon_set_source_sync(DCON_SOURCE_DCON);
+		dcon_set_source_sync(dcon, DCON_SOURCE_DCON);
 		break;
 	case 2:  /* normally unused */
-		dcon_set_source(DCON_SOURCE_DCON);
+		dcon_set_source(dcon, DCON_SOURCE_DCON);
 		break;
 	default:
 		return -EINVAL;
@@ -592,7 +609,7 @@ static ssize_t dcon_resumeline_store(struct device *dev,
 		return rc;
 
 	resumeline = rl;
-	dcon_write(DCON_REG_SCAN_INT, resumeline);
+	dcon_write(dev_get_drvdata(dev), DCON_REG_SCAN_INT, resumeline);
 	rc = count;
 
 	return rc;
@@ -606,7 +623,7 @@ static ssize_t dcon_sleep_store(struct device *dev,
 	if (_strtoul(buf, count, &output))
 		return -EINVAL;
 
-	dcon_sleep(output ? DCON_SLEEP : DCON_ACTIVE);
+	dcon_sleep(dev_get_drvdata(dev), output ? DCON_SLEEP : DCON_ACTIVE);
 	return count;
 }
 
@@ -627,20 +644,17 @@ static const struct backlight_ops dcon_bl_ops = {
 static int dcon_reboot_notify(struct notifier_block *nb,
 			      unsigned long foo, void *bar)
 {
-	if (dcon_client == NULL)
+	struct dcon_priv *dcon = container_of(nb, struct dcon_priv, reboot_nb);
+
+	if (!dcon || !dcon->client)
 		return 0;
 
 	/* Turn off the DCON. Entirely. */
-	dcon_write(DCON_REG_MODE, 0x39);
-	dcon_write(DCON_REG_MODE, 0x32);
+	dcon_write(dcon, DCON_REG_MODE, 0x39);
+	dcon_write(dcon, DCON_REG_MODE, 0x32);
 	return 0;
 }
 
-static struct notifier_block dcon_nb = {
-	.notifier_call = dcon_reboot_notify,
-	.priority = -1,
-};
-
 static int unfreeze_on_panic(struct notifier_block *nb,
 			     unsigned long e, void *p)
 {
@@ -660,11 +674,14 @@ static int fb_notifier_callback(struct notifier_block *self,
 				unsigned long event, void *data)
 {
 	struct fb_event *evdata = data;
+	struct backlight_device *bl = container_of(self,
+			struct backlight_device, fb_notif);
+	struct dcon_priv *dcon = bl_get_data(bl);
 	int *blank = (int *) evdata->data;
 	if (((event != FB_EVENT_BLANK) && (event != FB_EVENT_CONBLANK)) ||
 			ignore_fb_events)
 		return 0;
-	dcon_sleep((*blank) ? DCON_SLEEP : DCON_ACTIVE);
+	dcon_sleep(dcon, (*blank) ? DCON_SLEEP : DCON_ACTIVE);
 	return 0;
 }
 
@@ -681,12 +698,24 @@ static int dcon_detect(struct i2c_client *client, struct i2c_board_info *info)
 
 static int dcon_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
+	struct dcon_priv *dcon;
 	int rc, i, j;
 
+	dcon = kzalloc(sizeof(*dcon), GFP_KERNEL);
+	if (!dcon)
+		return -ENOMEM;
+
+	dcon->client = client;
+	INIT_WORK(&dcon->switch_source, dcon_source_switch);
+	dcon->reboot_nb.notifier_call = dcon_reboot_notify;
+	dcon->reboot_nb.priority = -1;
+
+	i2c_set_clientdata(client, dcon);
+
 	if (num_registered_fb >= 1)
 		fbinfo = registered_fb[0];
 
-	rc = dcon_hw_init(client, 1);
+	rc = dcon_hw_init(dcon, 1);
 	if (rc)
 		goto einit;
 
@@ -699,9 +728,8 @@ static int dcon_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		rc = -ENOMEM;
 		goto eirq;
 	}
-	/* Place holder...*/
-	i2c_set_clientdata(client, dcon_device);
 	rc = platform_device_add(dcon_device);
+	platform_set_drvdata(dcon_device, dcon);
 
 	if (rc) {
 		printk(KERN_ERR "dcon:  Unable to add the DCON device\n");
@@ -718,11 +746,8 @@ static int dcon_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 
 	/* Add the backlight device for the DCON */
-
-	dcon_client = client;
-
 	dcon_bl_dev = backlight_device_register("dcon-bl", &dcon_device->dev,
-		NULL, &dcon_bl_ops, NULL);
+		dcon, &dcon_bl_ops, NULL);
 
 	if (IS_ERR(dcon_bl_dev)) {
 		printk(KERN_ERR "Cannot register the backlight device (%ld)\n",
@@ -731,12 +756,12 @@ static int dcon_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	} else {
 		dcon_bl_dev->props.max_brightness = 15;
 		dcon_bl_dev->props.power = FB_BLANK_UNBLANK;
-		dcon_bl_dev->props.brightness = dcon_get_backlight();
+		dcon_bl_dev->props.brightness = dcon_get_backlight(dcon);
 
 		backlight_update_status(dcon_bl_dev);
 	}
 
-	register_reboot_notifier(&dcon_nb);
+	register_reboot_notifier(&dcon->reboot_nb);
 	atomic_notifier_chain_register(&panic_notifier_list, &dcon_panic_nb);
 	fb_register_client(&fb_nb);
 
@@ -751,15 +776,19 @@ static int dcon_probe(struct i2c_client *client, const struct i2c_device_id *id)
  eirq:
 	free_irq(DCON_IRQ, &dcon_driver);
  einit:
+	i2c_set_clientdata(client, NULL);
+	kfree(dcon);
 	return rc;
 }
 
 static int dcon_remove(struct i2c_client *client)
 {
-	dcon_client = NULL;
+	struct dcon_priv *dcon = i2c_get_clientdata(client);
+
+	i2c_set_clientdata(client, NULL);
 
 	fb_unregister_client(&fb_nb);
-	unregister_reboot_notifier(&dcon_nb);
+	unregister_reboot_notifier(&dcon->reboot_nb);
 	atomic_notifier_chain_unregister(&panic_notifier_list, &dcon_panic_nb);
 
 	free_irq(DCON_IRQ, &dcon_driver);
@@ -769,7 +798,9 @@ static int dcon_remove(struct i2c_client *client)
 
 	if (dcon_device != NULL)
 		platform_device_unregister(dcon_device);
-	cancel_work_sync(&dcon_work);
+	cancel_work_sync(&dcon->switch_source);
+
+	kfree(dcon);
 
 	return 0;
 }
@@ -777,9 +808,11 @@ static int dcon_remove(struct i2c_client *client)
 #ifdef CONFIG_PM
 static int dcon_suspend(struct i2c_client *client, pm_message_t state)
 {
+	struct dcon_priv *dcon = i2c_get_clientdata(client);
+
 	if (dcon_sleep_val == DCON_ACTIVE) {
 		/* Set up the DCON to have the source */
-		dcon_set_source_sync(DCON_SOURCE_DCON);
+		dcon_set_source_sync(dcon, DCON_SOURCE_DCON);
 	}
 
 	return 0;
@@ -787,9 +820,11 @@ static int dcon_suspend(struct i2c_client *client, pm_message_t state)
 
 static int dcon_resume(struct i2c_client *client)
 {
+	struct dcon_priv *dcon = i2c_get_clientdata(client);
+
 	if (dcon_sleep_val == DCON_ACTIVE) {
-		dcon_bus_stabilize(client, 0);
-		dcon_set_source(DCON_SOURCE_CPU);
+		dcon_bus_stabilize(dcon, 0);
+		dcon_set_source(dcon, DCON_SOURCE_CPU);
 	}
 
 	return 0;
-- 
1.7.2.3

