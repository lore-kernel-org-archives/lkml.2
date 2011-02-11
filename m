Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab1BKBrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 20:47:20 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:34851 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094Ab1BKBrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 20:47:19 -0500
Date: Thu, 10 Feb 2011 17:47:16 -0800
From: Andres Salomon <dilinger@queued.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, jon.nettleton@gmail.com,
        devel@driverdev.osuosl.org
Subject: [PATCH 02/10] olpc_dcon: move fb event notifier block into
 dcon_priv struct
Message-ID: <20110210174716.4536c18b@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This also fixes a think-o where I was pulling the dcon struct
out of thin air in the fb event callback.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index cc12110..710d880 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -58,6 +58,7 @@ struct dcon_priv {
 
 	struct work_struct switch_source;
 	struct notifier_block reboot_nb;
+	struct notifier_block fbevent_nb;
 
 	/* Shadow register for the DCON_REG_MODE register */
 	u8 disp_mode;
@@ -669,13 +670,12 @@ static struct notifier_block dcon_panic_nb = {
  * When the framebuffer sleeps due to external sources (e.g. user idle), power
  * down the DCON as well.  Power it back up when the fb comes back to life.
  */
-static int fb_notifier_callback(struct notifier_block *self,
+static int dcon_fb_notifier(struct notifier_block *self,
 				unsigned long event, void *data)
 {
 	struct fb_event *evdata = data;
-	struct backlight_device *bl = container_of(self,
-			struct backlight_device, fb_notif);
-	struct dcon_priv *dcon = bl_get_data(bl);
+	struct dcon_priv *dcon = container_of(self, struct dcon_priv,
+			fbevent_nb);
 	int *blank = (int *) evdata->data;
 	if (((event != FB_EVENT_BLANK) && (event != FB_EVENT_CONBLANK)) ||
 			ignore_fb_events)
@@ -684,10 +684,6 @@ static int fb_notifier_callback(struct notifier_block *self,
 	return 0;
 }
 
-static struct notifier_block fb_nb = {
-	.notifier_call = fb_notifier_callback,
-};
-
 static int dcon_detect(struct i2c_client *client, struct i2c_board_info *info)
 {
 	strlcpy(info->type, "olpc_dcon", I2C_NAME_SIZE);
@@ -708,6 +704,7 @@ static int dcon_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	INIT_WORK(&dcon->switch_source, dcon_source_switch);
 	dcon->reboot_nb.notifier_call = dcon_reboot_notify;
 	dcon->reboot_nb.priority = -1;
+	dcon->fbevent_nb.notifier_call = dcon_fb_notifier;
 
 	i2c_set_clientdata(client, dcon);
 
@@ -762,7 +759,7 @@ static int dcon_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	register_reboot_notifier(&dcon->reboot_nb);
 	atomic_notifier_chain_register(&panic_notifier_list, &dcon_panic_nb);
-	fb_register_client(&fb_nb);
+	fb_register_client(&dcon->fbevent_nb);
 
 	return 0;
 
@@ -786,7 +783,7 @@ static int dcon_remove(struct i2c_client *client)
 
 	i2c_set_clientdata(client, NULL);
 
-	fb_unregister_client(&fb_nb);
+	fb_unregister_client(&dcon->fbevent_nb);
 	unregister_reboot_notifier(&dcon->reboot_nb);
 	atomic_notifier_chain_unregister(&panic_notifier_list, &dcon_panic_nb);
 
-- 
1.7.2.3

