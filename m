Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab2JAVxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 17:53:23 -0400
Received: from lunge.queued.net ([173.255.254.236]:58894 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796Ab2JAVwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 17:52:43 -0400
Date: Mon, 1 Oct 2012 14:45:50 -0700
From: Andres Salomon <dilinger@queued.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jon Nettleton <jon.nettleton@gmail.com>, Chris Ball <cjb@laptop.org>
Subject: [PATCH 2/5] staging/olpc_dcon: move wait queue into dcon_priv
 struct
Message-ID: <20121001144550.168d13a5@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Another global variable (dcon_wait_queue) moved into the dcon_priv struct.
In the process, replace an instance of a manually implemented
wait_event_timeout.  This code came from Jordan's original gxfb_dcon.c
driver waaaay back in 2006; well past time for a replacement.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |   22 ++++++----------------
 drivers/staging/olpc_dcon/olpc_dcon.h |    1 +
 2 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 7dcd060..38f988b 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -46,8 +46,6 @@ static struct dcon_platform_data *pdata;
 /* Platform devices */
 static struct platform_device *dcon_device;
 
-static DECLARE_WAIT_QUEUE_HEAD(dcon_wait_queue);
-
 static unsigned short normal_i2c[] = { 0x0d, I2C_CLIENT_END };
 
 static s32 dcon_write(struct dcon_priv *dcon, u8 reg, u16 val)
@@ -280,7 +278,6 @@ static void dcon_source_switch(struct work_struct *work)
 {
 	struct dcon_priv *dcon = container_of(work, struct dcon_priv,
 			switch_source);
-	DECLARE_WAITQUEUE(wait, current);
 	int source = dcon->pending_src;
 
 	if (dcon->curr_src == source)
@@ -297,11 +294,9 @@ static void dcon_source_switch(struct work_struct *work)
 		if (dcon_write(dcon, DCON_REG_MODE,
 				dcon->disp_mode | MODE_SCAN_INT))
 			pr_err("couldn't enable scanline interrupt!\n");
-		else {
+		else
 			/* Wait up to one second for the scanline interrupt */
-			wait_event_timeout(dcon_wait_queue,
-					   dcon->switched == true, HZ);
-		}
+			wait_event_timeout(dcon->waitq, dcon->switched, HZ);
 
 		if (!dcon->switched)
 			pr_err("Timeout entering CPU mode; expect a screen glitch.\n");
@@ -332,21 +327,15 @@ static void dcon_source_switch(struct work_struct *work)
 		break;
 	case DCON_SOURCE_DCON:
 	{
-		int t;
 		struct timespec delta_t;
 
 		pr_info("dcon_source_switch to DCON\n");
 
-		add_wait_queue(&dcon_wait_queue, &wait);
-		set_current_state(TASK_UNINTERRUPTIBLE);
-
 		/* Clear DCONLOAD - this implies that the DCON is in control */
 		pdata->set_dconload(0);
 		getnstimeofday(&dcon->load_time);
 
-		t = schedule_timeout(HZ/2);
-		remove_wait_queue(&dcon_wait_queue, &wait);
-		set_current_state(TASK_RUNNING);
+		wait_event_timeout(dcon->waitq, dcon->switched, HZ/2);
 
 		if (!dcon->switched) {
 			pr_err("Timeout entering DCON mode; expect a screen glitch.\n");
@@ -614,6 +603,7 @@ static int dcon_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		return -ENOMEM;
 
 	dcon->client = client;
+	init_waitqueue_head(&dcon->waitq);
 	INIT_WORK(&dcon->switch_source, dcon_source_switch);
 	dcon->reboot_nb.notifier_call = dcon_reboot_notify;
 	dcon->reboot_nb.priority = -1;
@@ -756,7 +746,7 @@ irqreturn_t dcon_interrupt(int irq, void *id)
 	case 1: /* switch to CPU mode */
 		dcon->switched = true;
 		getnstimeofday(&dcon->irq_time);
-		wake_up(&dcon_wait_queue);
+		wake_up(&dcon->waitq);
 		break;
 
 	case 0:
@@ -770,7 +760,7 @@ irqreturn_t dcon_interrupt(int irq, void *id)
 		if (dcon->curr_src != dcon->pending_src && !dcon->switched) {
 			dcon->switched = true;
 			getnstimeofday(&dcon->irq_time);
-			wake_up(&dcon_wait_queue);
+			wake_up(&dcon->waitq);
 			pr_debug("switching w/ status 0/0\n");
 		} else {
 			pr_debug("scanline interrupt w/CPU\n");
diff --git a/drivers/staging/olpc_dcon/olpc_dcon.h b/drivers/staging/olpc_dcon/olpc_dcon.h
index 167a417..e3f8437 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.h
+++ b/drivers/staging/olpc_dcon/olpc_dcon.h
@@ -52,6 +52,7 @@ struct dcon_priv {
 	struct fb_info *fbinfo;
 	struct backlight_device *bl_dev;
 
+	wait_queue_head_t waitq;
 	struct work_struct switch_source;
 	struct notifier_block reboot_nb;
 	struct notifier_block fbevent_nb;
-- 
1.7.10.4

