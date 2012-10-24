Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935263Ab2JXTn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:43:26 -0400
Received: from mail.pxnet.com ([89.1.7.7]:46484 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934141Ab2JXTnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:43:23 -0400
X-Greylist: delayed 2178 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2012 15:43:22 EDT
From: Tilman Schmidt <tilman@imap.cc>
Date: Wed, 24 Oct 2012 20:44:32 +0200
Subject: [PATCH] bas_gigaset: fix pre_reset handling
To: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>
Cc: Oliver Neukum <oneukum@suse.de>, Hansjoerg Lipp <hjlipp@web.de>,
        gigaset307x-common@lists.sourceforge.net, linux-usb@vger.kernel.org,
        i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20121024-patch-gigaset-01.tilman@imap.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The delayed work function int_in_work() may call usb_reset_device()
and thus, indirectly, the driver's pre_reset method. Trying to
cancel the work synchronously in that situation would deadlock.
Fix by avoiding cancel_work_sync() in the pre_reset method.

If the reset was NOT initiated by int_in_work() this might cause
int_in_work() to run after the post_reset method, with urb_int_in
already resubmitted, so handle that case gracefully.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/gigaset/bas-gigaset.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/gigaset/bas-gigaset.c b/drivers/isdn/gigaset/bas-gigaset.c
index 5275887..c44950d 100644
--- a/drivers/isdn/gigaset/bas-gigaset.c
+++ b/drivers/isdn/gigaset/bas-gigaset.c
@@ -617,7 +617,13 @@ static void int_in_work(struct work_struct *work)
 	if (rc == 0)
 		/* success, resubmit interrupt read URB */
 		rc = usb_submit_urb(urb, GFP_ATOMIC);
-	if (rc != 0 && rc != -ENODEV) {
+
+	switch (rc) {
+	case 0:		/* success */
+	case -ENODEV:	/* device gone */
+	case -EINVAL:	/* URB already resubmitted, or terminal badness */
+		break;
+	default:	/* failure: try to recover by resetting the device */
 		dev_err(cs->dev, "clear halt failed: %s\n", get_usb_rcmsg(rc));
 		rc = usb_lock_device_for_reset(ucs->udev, ucs->interface);
 		if (rc == 0) {
@@ -2442,7 +2448,9 @@ static void gigaset_disconnect(struct usb_interface *interface)
 }
 
 /* gigaset_suspend
- * This function is called before the USB connection is suspended.
+ * This function is called before the USB connection is suspended
+ * or before the USB device is reset.
+ * In the latter case, message == PMSG_ON.
  */
 static int gigaset_suspend(struct usb_interface *intf, pm_message_t message)
 {
@@ -2498,7 +2506,12 @@ static int gigaset_suspend(struct usb_interface *intf, pm_message_t message)
 	del_timer_sync(&ucs->timer_atrdy);
 	del_timer_sync(&ucs->timer_cmd_in);
 	del_timer_sync(&ucs->timer_int_in);
-	cancel_work_sync(&ucs->int_in_wq);
+
+	/* don't try to cancel int_in_wq from within reset as it
+	 * might be the one requesting the reset
+	 */
+	if (message.event != PM_EVENT_ON)
+		cancel_work_sync(&ucs->int_in_wq);
 
 	gig_dbg(DEBUG_SUSPEND, "suspend complete");
 	return 0;
-- 
1.7.3.4

