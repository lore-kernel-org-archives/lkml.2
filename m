Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933462Ab2LMOOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:14:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45122 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323Ab2LMOOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:14:47 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tilman Schmidt <tilman@imap.cc>, "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 226/241] bas_gigaset: fix pre_reset handling
Date: Thu, 13 Dec 2012 11:59:51 -0200
Message-Id: <1355407206-17100-227-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

commit c6fdd8e5d0c65bb8821dc6da26ee1a2ddd58b3cc upstream.

The delayed work function int_in_work() may call usb_reset_device()
and thus, indirectly, the driver's pre_reset method. Trying to
cancel the work synchronously in that situation would deadlock.
Fix by avoiding cancel_work_sync() in the pre_reset method.

If the reset was NOT initiated by int_in_work() this might cause
int_in_work() to run after the post_reset method, with urb_int_in
already resubmitted, so handle that case gracefully.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/isdn/gigaset/bas-gigaset.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

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
1.7.9.5

