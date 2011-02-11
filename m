Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab1BKBzD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 20:55:03 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:57295 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932256Ab1BKBzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 20:55:01 -0500
Date: Thu, 10 Feb 2011 17:54:58 -0800
From: Andres Salomon <dilinger@queued.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, jon.nettleton@gmail.com,
        devel@driverdev.osuosl.org
Subject: [PATCH 08/10] olpc_dcon: move more global variables into dcon_priv
Message-ID: <20110210175458.78a57508@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Global variables dcon_switched, dcon_irq_time, and dcon_load_time can all be moved
into the dcon_priv struct now that dcon_interrupt has access to dcon_priv.
---
 drivers/staging/olpc_dcon/olpc_dcon.c |   39 ++++++++++++++------------------
 drivers/staging/olpc_dcon/olpc_dcon.h |    5 ++++
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index cdd8718..07abdfa 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -53,11 +53,6 @@ static struct platform_device *dcon_device;
 /* Backlight device */
 static struct backlight_device *dcon_bl_dev;
 
-/* Variables used during switches */
-static int dcon_switched;
-static struct timespec dcon_irq_time;
-static struct timespec dcon_load_time;
-
 static DECLARE_WAIT_QUEUE_HEAD(dcon_wait_queue);
 
 static unsigned short normal_i2c[] = { 0x0d, I2C_CLIENT_END };
@@ -297,12 +292,12 @@ static void dcon_sleep(struct dcon_priv *dcon, bool sleep)
  * normally we don't change it this fast, so in general we won't
  * delay here.
  */
-void dcon_load_holdoff(void)
+static void dcon_load_holdoff(struct dcon_priv *dcon)
 {
 	struct timespec delta_t, now;
 	while (1) {
 		getnstimeofday(&now);
-		delta_t = timespec_sub(now, dcon_load_time);
+		delta_t = timespec_sub(now, dcon->load_time);
 		if (delta_t.tv_sec != 0 ||
 			delta_t.tv_nsec > NSEC_PER_MSEC * 20) {
 			break;
@@ -346,9 +341,9 @@ static void dcon_source_switch(struct work_struct *work)
 	if (dcon->curr_src == source)
 		return;
 
-	dcon_load_holdoff();
+	dcon_load_holdoff(dcon);
 
-	dcon_switched = 0;
+	dcon->switched = false;
 
 	switch (source) {
 	case DCON_SOURCE_CPU:
@@ -361,10 +356,10 @@ static void dcon_source_switch(struct work_struct *work)
 		else {
 			/* Wait up to one second for the scanline interrupt */
 			wait_event_timeout(dcon_wait_queue,
-					   dcon_switched == 1, HZ);
+					   dcon->switched == true, HZ);
 		}
 
-		if (!dcon_switched)
+		if (!dcon->switched)
 			printk(KERN_ERR "olpc-dcon:  Timeout entering CPU mode; expect a screen glitch.\n");
 
 		/* Turn off the scanline interrupt */
@@ -387,7 +382,7 @@ static void dcon_source_switch(struct work_struct *work)
 
 		/* And turn off the DCON */
 		pdata->set_dconload(1);
-		getnstimeofday(&dcon_load_time);
+		getnstimeofday(&dcon->load_time);
 
 		printk(KERN_INFO "olpc-dcon: The CPU has control\n");
 		break;
@@ -403,13 +398,13 @@ static void dcon_source_switch(struct work_struct *work)
 
 		/* Clear DCONLOAD - this implies that the DCON is in control */
 		pdata->set_dconload(0);
-		getnstimeofday(&dcon_load_time);
+		getnstimeofday(&dcon->load_time);
 
 		t = schedule_timeout(HZ/2);
 		remove_wait_queue(&dcon_wait_queue, &wait);
 		set_current_state(TASK_RUNNING);
 
-		if (!dcon_switched) {
+		if (!dcon->switched) {
 			printk(KERN_ERR "olpc-dcon: Timeout entering DCON mode; expect a screen glitch.\n");
 		} else {
 			/* sometimes the DCON doesn't follow its own rules,
@@ -423,14 +418,14 @@ static void dcon_source_switch(struct work_struct *work)
 			 * deassert and reassert, and hope for the best.
 			 * see http://dev.laptop.org/ticket/9664
 			 */
-			delta_t = timespec_sub(dcon_irq_time, dcon_load_time);
-			if (dcon_switched && delta_t.tv_sec == 0 &&
+			delta_t = timespec_sub(dcon->irq_time, dcon->load_time);
+			if (dcon->switched && delta_t.tv_sec == 0 &&
 					delta_t.tv_nsec < NSEC_PER_MSEC * 20) {
 				printk(KERN_ERR "olpc-dcon: missed loading, retrying\n");
 				pdata->set_dconload(1);
 				mdelay(41);
 				pdata->set_dconload(0);
-				getnstimeofday(&dcon_load_time);
+				getnstimeofday(&dcon->load_time);
 				mdelay(41);
 			}
 		}
@@ -815,8 +810,8 @@ irqreturn_t dcon_interrupt(int irq, void *id)
 
 	case 2:	/* switch to DCON mode */
 	case 1: /* switch to CPU mode */
-		dcon_switched = 1;
-		getnstimeofday(&dcon_irq_time);
+		dcon->switched = true;
+		getnstimeofday(&dcon->irq_time);
 		wake_up(&dcon_wait_queue);
 		break;
 
@@ -828,9 +823,9 @@ irqreturn_t dcon_interrupt(int irq, void *id)
 		 * of the DCON happened long before this point.
 		 * see http://dev.laptop.org/ticket/9869
 		 */
-		if (dcon->curr_src != dcon->pending_src && !dcon_switched) {
-			dcon_switched = 1;
-			getnstimeofday(&dcon_irq_time);
+		if (dcon->curr_src != dcon->pending_src && !dcon->switched) {
+			dcon->switched = true;
+			getnstimeofday(&dcon->irq_time);
 			wake_up(&dcon_wait_queue);
 			printk(KERN_DEBUG "olpc-dcon: switching w/ status 0/0\n");
 		} else {
diff --git a/drivers/staging/olpc_dcon/olpc_dcon.h b/drivers/staging/olpc_dcon/olpc_dcon.h
index 2c06e19..62bed46 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.h
+++ b/drivers/staging/olpc_dcon/olpc_dcon.h
@@ -64,6 +64,11 @@ struct dcon_priv {
 	/* Desired source */
 	int pending_src;
 
+	/* Variables used during switches */
+	bool switched;
+	struct timespec irq_time;
+	struct timespec load_time;
+
 	/* Current output type; true == mono, false == color */
 	bool mono;
 	bool asleep;
-- 
1.7.2.3

