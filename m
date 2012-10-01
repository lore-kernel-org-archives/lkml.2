Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab2JAVwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 17:52:46 -0400
Received: from lunge.queued.net ([173.255.254.236]:58892 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab2JAVwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 17:52:43 -0400
Date: Mon, 1 Oct 2012 14:46:01 -0700
From: Andres Salomon <dilinger@queued.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jon Nettleton <jon.nettleton@gmail.com>, Chris Ball <cjb@laptop.org>
Subject: [PATCH 3/5] staging/olpc_dcon: drop fb_notifier code
Message-ID: <20121001144601.7d5557ba@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Previously we registered a notifier block to inform us of any framebuffer
device changes; if the screen was blanked or unblanked, we'd put the DCON
to sleep or wake it up.

Turns out that the backlight code registers a notifier block as well
and calls the update_status hook, so we can just use that to put the DCON
to sleep.  For those status updates where the blanking isn't changed,
dcon_sleep will do nothing.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |   25 ++++---------------------
 drivers/staging/olpc_dcon/olpc_dcon.h |    1 -
 2 files changed, 4 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 38f988b..2b0bbac 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -520,6 +520,10 @@ static int dcon_bl_update(struct backlight_device *dev)
 	if (level != dcon->bl_val)
 		dcon_set_backlight(dcon, level);
 
+	/* power down the DCON when the screen is blanked */
+	if (!dcon->ignore_fb_events)
+		dcon_sleep(dcon, !!(dev->props.state & BL_CORE_FBBLANK));
+
 	return 0;
 }
 
@@ -565,24 +569,6 @@ static struct notifier_block dcon_panic_nb = {
 	.notifier_call = unfreeze_on_panic,
 };
 
-/*
- * When the framebuffer sleeps due to external sources (e.g. user idle), power
- * down the DCON as well.  Power it back up when the fb comes back to life.
- */
-static int dcon_fb_notifier(struct notifier_block *self,
-				unsigned long event, void *data)
-{
-	struct fb_event *evdata = data;
-	struct dcon_priv *dcon = container_of(self, struct dcon_priv,
-			fbevent_nb);
-	int *blank = (int *)evdata->data;
-	if (((event != FB_EVENT_BLANK) && (event != FB_EVENT_CONBLANK)) ||
-			dcon->ignore_fb_events)
-		return 0;
-	dcon_sleep(dcon, *blank ? true : false);
-	return 0;
-}
-
 static int dcon_detect(struct i2c_client *client, struct i2c_board_info *info)
 {
 	strlcpy(info->type, "olpc_dcon", I2C_NAME_SIZE);
@@ -607,7 +593,6 @@ static int dcon_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	INIT_WORK(&dcon->switch_source, dcon_source_switch);
 	dcon->reboot_nb.notifier_call = dcon_reboot_notify;
 	dcon->reboot_nb.priority = -1;
-	dcon->fbevent_nb.notifier_call = dcon_fb_notifier;
 
 	i2c_set_clientdata(client, dcon);
 
@@ -662,7 +647,6 @@ static int dcon_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	register_reboot_notifier(&dcon->reboot_nb);
 	atomic_notifier_chain_register(&panic_notifier_list, &dcon_panic_nb);
-	fb_register_client(&dcon->fbevent_nb);
 
 	return 0;
 
@@ -683,7 +667,6 @@ static int dcon_remove(struct i2c_client *client)
 {
 	struct dcon_priv *dcon = i2c_get_clientdata(client);
 
-	fb_unregister_client(&dcon->fbevent_nb);
 	unregister_reboot_notifier(&dcon->reboot_nb);
 	atomic_notifier_chain_unregister(&panic_notifier_list, &dcon_panic_nb);
 
diff --git a/drivers/staging/olpc_dcon/olpc_dcon.h b/drivers/staging/olpc_dcon/olpc_dcon.h
index e3f8437..997bded 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.h
+++ b/drivers/staging/olpc_dcon/olpc_dcon.h
@@ -55,7 +55,6 @@ struct dcon_priv {
 	wait_queue_head_t waitq;
 	struct work_struct switch_source;
 	struct notifier_block reboot_nb;
-	struct notifier_block fbevent_nb;
 
 	/* Shadow register for the DCON_REG_MODE register */
 	u8 disp_mode;
-- 
1.7.10.4

