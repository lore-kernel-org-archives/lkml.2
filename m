Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993182Ab2K3TDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:03:34 -0500
Received: from mail.kernel.org ([198.145.19.201]:59992 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993140Ab2K3TDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:03:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tilman Schmidt <tilman@imap.cc>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 37/54] bas_gigaset: fix pre_reset handling
Date: Fri, 30 Nov 2012 10:56:08 -0800
Message-Id: <20121130185211.673898011@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/isdn/gigaset/bas-gigaset.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/isdn/gigaset/bas-gigaset.c
+++ b/drivers/isdn/gigaset/bas-gigaset.c
@@ -617,7 +617,13 @@ static void int_in_work(struct work_stru
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
@@ -2442,7 +2448,9 @@ static void gigaset_disconnect(struct us
 }
 
 /* gigaset_suspend
- * This function is called before the USB connection is suspended.
+ * This function is called before the USB connection is suspended
+ * or before the USB device is reset.
+ * In the latter case, message == PMSG_ON.
  */
 static int gigaset_suspend(struct usb_interface *intf, pm_message_t message)
 {
@@ -2498,7 +2506,12 @@ static int gigaset_suspend(struct usb_in
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


