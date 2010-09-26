Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab0IZCBm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 22:01:42 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:34431 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755956Ab0IZCBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 22:01:41 -0400
Date: Sat, 25 Sep 2010 19:06:30 -0700
From: Andres Salomon <dilinger@queued.net>
To: Greg KH <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, cjb@laptop.org, jon.nettleton@gmail.com,
        dsd@laptop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] staging: olpc_dcon: drop old VT switch code, watch for
 CONBLANK event
Message-ID: <20100925190630.27d42de1@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Eons ago, in a galaxy far far away, Jordan committed code to work around
the fact that X might have put the DCON to sleep and then crashed (in that
galaxy, X crashed a lot; crazy, right?)

This code was based on a custom API.  These days, we have code which watches
for FB unblanks, and should perform the same function.. Therefore, the older
code can be dropped.  We should probably be watching for CONBLANK events to,
so allow those to turn the DCON back on.

Dropping the old code is necessary for building the driver.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |   26 ++++++--------------------
 1 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 287085f..75aa7a3 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -19,7 +19,6 @@
 #include <linux/platform_device.h>
 #include <linux/i2c-id.h>
 #include <linux/pci.h>
-#include <linux/vt_kern.h>
 #include <linux/pci_ids.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
@@ -634,25 +633,11 @@ static int dcon_reboot_notify(struct notifier_block *nb, unsigned long foo, void
 	return 0;
 }
 
-static int dcon_conswitch_notify(struct notifier_block *nb,
-				 unsigned long mode, void *dummy)
-{
-	if (mode == CONSOLE_EVENT_SWITCH_TEXT)
-		dcon_sleep(DCON_ACTIVE);
-
-	return 0;
-}
-
 static struct notifier_block dcon_nb = {
 	.notifier_call = dcon_reboot_notify,
 	.priority = -1,
 };
 
-static struct notifier_block dcon_console_nb = {
-	.notifier_call = dcon_conswitch_notify,
-	.priority = -1,
-};
-
 static int unfreeze_on_panic(struct notifier_block *nb, unsigned long e, void *p)
 {
 	pdata->set_dconload(1);
@@ -663,13 +648,16 @@ static struct notifier_block dcon_panic_nb = {
 	.notifier_call = unfreeze_on_panic,
 };
 
-/* when framebuffer sleeps due to external source (e.g. user idle), power down
- * the DCON. also power up when the framebuffer comes back to life. */
+/*
+ * When the framebuffer sleeps due to external sources (e.g. user idle), power
+ * down the DCON as well.  Power it back up when the fb comes back to life.
+ */
 static int fb_notifier_callback(struct notifier_block *self, unsigned long event, void *data)
 {
 	struct fb_event *evdata = data;
 	int *blank = (int *) evdata->data;
-	if (event != FB_EVENT_BLANK || ignore_fb_events)
+	if (((event != FB_EVENT_BLANK) && (event != FB_EVENT_CONBLANK)) ||
+			ignore_fb_events)
 		return 0;
 	dcon_sleep((*blank) ? DCON_SLEEP : DCON_ACTIVE);
 	return 0;
@@ -737,7 +725,6 @@ static int dcon_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 
 	register_reboot_notifier(&dcon_nb);
-	console_event_register(&dcon_console_nb);
 	atomic_notifier_chain_register(&panic_notifier_list, &dcon_panic_nb);
 	fb_register_client(&fb_nb);
 
@@ -759,7 +746,6 @@ static int dcon_remove(struct i2c_client *client)
 
 	fb_unregister_client(&fb_nb);
 	unregister_reboot_notifier(&dcon_nb);
-	console_event_unregister(&dcon_console_nb);
 	atomic_notifier_chain_unregister(&panic_notifier_list, &dcon_panic_nb);
 
 	free_irq(DCON_IRQ, &dcon_driver);
-- 
1.5.6.5

