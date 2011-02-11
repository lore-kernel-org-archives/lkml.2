Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab1BKBsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 20:48:43 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:34856 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231Ab1BKBsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 20:48:42 -0500
Date: Thu, 10 Feb 2011 17:48:38 -0800
From: Andres Salomon <dilinger@queued.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, jon.nettleton@gmail.com,
        devel@driverdev.osuosl.org
Subject: [PATCH 03/10] olpc_dcon: move fb stuff info dcon_priv, and clean up
 fb handling
Message-ID: <20110210174838.7a6e46f1@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 - move fbinfo and ignore_fb_events into dcon_priv
 - add calls to {un,}lock_fb_info before calling fb_blank
 - fail to load the driver if there are no registered framebuffers

That last one fixes a potential oops, where if the dcon driver loads
without a framebuffer registered, fb_blank will end up being passed a
NULL (and will attempt to dereference it).

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |   60 ++++++++++++++++++++------------
 1 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 710d880..d3c2800 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -55,6 +55,7 @@ static struct dcon_platform_data *pdata;
 
 struct dcon_priv {
 	struct i2c_client *client;
+	struct fb_info *fbinfo;
 
 	struct work_struct switch_source;
 	struct notifier_block reboot_nb;
@@ -66,6 +67,8 @@ struct dcon_priv {
 	/* Current output type; true == mono, false == color */
 	bool mono;
 	bool asleep;
+	/* This get set while controlling fb blank state from the driver */
+	bool ignore_fb_events;
 };
 
 /* I2C structures */
@@ -78,11 +81,6 @@ static struct platform_device *dcon_device;
 /* Backlight device */
 static struct backlight_device *dcon_bl_dev;
 
-static struct fb_info *fbinfo;
-
-/* set this to 1 while controlling fb blank state from this driver */
-static int ignore_fb_events = 0;
-
 /* Current source, initialized at probe time */
 static int dcon_source;
 
@@ -346,8 +344,32 @@ void dcon_load_holdoff(void)
 		mdelay(4);
 	}
 }
-/* Set the source of the display (CPU or DCON) */
 
+static bool dcon_blank_fb(struct dcon_priv *dcon, bool blank)
+{
+	int err;
+
+	if (!lock_fb_info(dcon->fbinfo)) {
+		dev_err(&dcon->client->dev, "unable to lock framebuffer\n");
+		return false;
+	}
+	console_lock();
+	dcon->ignore_fb_events = true;
+	err = fb_blank(dcon->fbinfo,
+			blank ? FB_BLANK_POWERDOWN : FB_BLANK_UNBLANK);
+	dcon->ignore_fb_events = false;
+	console_unlock();
+	unlock_fb_info(dcon->fbinfo);
+
+	if (err) {
+		dev_err(&dcon->client->dev, "couldn't %sblank framebuffer\n",
+				blank ? "" : "un");
+		return false;
+	}
+	return true;
+}
+
+/* Set the source of the display (CPU or DCON) */
 static void dcon_source_switch(struct work_struct *work)
 {
 	struct dcon_priv *dcon = container_of(work, struct dcon_priv,
@@ -391,17 +413,11 @@ static void dcon_source_switch(struct work_struct *work)
 		 *
 		 * For now, we just hope..
 		 */
-		console_lock();
-		ignore_fb_events = 1;
-		if (fb_blank(fbinfo, FB_BLANK_UNBLANK)) {
-			ignore_fb_events = 0;
-			console_unlock();
+		if (!dcon_blank_fb(dcon, false)) {
 			printk(KERN_ERR "olpc-dcon:  Failed to enter CPU mode\n");
 			dcon_pending = DCON_SOURCE_DCON;
 			return;
 		}
-		ignore_fb_events = 0;
-		console_unlock();
 
 		/* And turn off the DCON */
 		pdata->set_dconload(1);
@@ -453,13 +469,7 @@ static void dcon_source_switch(struct work_struct *work)
 			}
 		}
 
-		console_lock();
-		ignore_fb_events = 1;
-		if (fb_blank(fbinfo, FB_BLANK_POWERDOWN))
-			printk(KERN_ERR "olpc-dcon:  couldn't blank fb!\n");
-		ignore_fb_events = 0;
-		console_unlock();
-
+		dcon_blank_fb(dcon, true);
 		printk(KERN_INFO "olpc-dcon: The DCON has control\n");
 		break;
 	}
@@ -678,7 +688,7 @@ static int dcon_fb_notifier(struct notifier_block *self,
 			fbevent_nb);
 	int *blank = (int *) evdata->data;
 	if (((event != FB_EVENT_BLANK) && (event != FB_EVENT_CONBLANK)) ||
-			ignore_fb_events)
+			dcon->ignore_fb_events)
 		return 0;
 	dcon_sleep(dcon, *blank ? true : false);
 	return 0;
@@ -708,8 +718,12 @@ static int dcon_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	i2c_set_clientdata(client, dcon);
 
-	if (num_registered_fb >= 1)
-		fbinfo = registered_fb[0];
+	if (num_registered_fb < 1) {
+		dev_err(&client->dev, "DCON driver requires a registered fb\n");
+		rc = -EIO;
+		goto einit;
+	}
+	dcon->fbinfo = registered_fb[0];
 
 	rc = dcon_hw_init(dcon, 1);
 	if (rc)
-- 
1.7.2.3

