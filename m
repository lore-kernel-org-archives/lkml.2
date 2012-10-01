Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab2JAXKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:10:48 -0400
Received: from 1wt.eu ([62.212.114.60]:35578 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933180Ab2JAXCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:46 -0400
Message-Id: <20121001225158.634821829@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stuart Hayes <stuart_hayes@dell.com>, Shyam Iyer <shyam_iyer@dell.com>,
        Ben Hutchings <ben@decadent.org.uk>, Willy Tarreau <w@1wt.eu>
Subject: [ 024/180] usb: Fix deadlock in hid_reset when Dell iDRAC is reset
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Stuart Hayes <stuart_hayes@dell.com>

This was fixed upstream by commit e22bee782b3b00bd4534ae9b1c5fb2e8e6573c5c
('workqueue: implement concurrency managed dynamic worker pool'), but
that is far too large a change for stable.

When Dell iDRAC is reset, the iDRAC's USB keyboard/mouse device stops
responding but is not actually disconnected.  This causes usbhid to
hid hid_io_error(), and you get a chain of calls like...

hid_reset()
 usb_reset_device()
  usb_reset_and_verify_device()
   usb_ep0_reinit()
    usb_disble_endpoint()
     usb_hcd_disable_endpoint()
      ehci_endpoint_disable()

Along the way, as a result of an error/timeout with a USB transaction,
ehci_clear_tt_buffer() calls usb_hub_clear_tt_buffer() (to clear a failed
transaction out of the transaction translator in the hub), which schedules
hub_tt_work() to be run (using keventd), and then sets qh->clearing_tt=1 so
that nobody will mess with that qh until the TT is cleared.

But run_workqueue() never happens for the keventd workqueue on that CPU, so
hub_tt_work() never gets run.  And qh->clearing_tt never gets changed back to
0.

This causes ehci_endpoint_disable() to get stuck in a loop waiting for
qh->clearing_tt to go to 0.

Part of the problem is hid_reset() is itself running on keventd.  So
when that thread gets a timeout trying to talk to the HID device, it
schedules clear_work (to run hub_tt_work) to run, and then gets stuck
in ehci_endpoint_disable waiting for it to run.

However, clear_work never gets run because the workqueue for that CPU
is still waiting for hid_reset to finish.

A much less invasive patch for earlier kernels is to just schedule
clear_work on khubd if the usb code needs to clear the TT and it sees
that it is already running on keventd.  Khubd isn't used by default
because it can get blocked by device enumeration sometimes, but I
think it should be ok for a backup for unusual cases like this just to
prevent deadlock.

Signed-off-by: Stuart Hayes <stuart_hayes@dell.com>
Signed-off-by: Shyam Iyer <shyam_iyer@dell.com>
[bwh: Use current_is_keventd() rather than checking current->{flags,comm}]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/usb/core/hub.c |   31 +++++++++++++++++++++++++++----
 kernel/workqueue.c     |    1 +
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 2b428fc..069de19 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -458,10 +458,8 @@ hub_clear_tt_buffer (struct usb_device *hdev, u16 devinfo, u16 tt)
  * talking to TTs must queue control transfers (not just bulk and iso), so
  * both can talk to the same hub concurrently.
  */
-static void hub_tt_work(struct work_struct *work)
+void _hub_tt_work(struct usb_hub *hub)
 {
-	struct usb_hub		*hub =
-		container_of(work, struct usb_hub, tt.clear_work);
 	unsigned long		flags;
 	int			limit = 100;
 
@@ -496,6 +494,14 @@ static void hub_tt_work(struct work_struct *work)
 	spin_unlock_irqrestore (&hub->tt.lock, flags);
 }
 
+void hub_tt_work(struct work_struct *work)
+{
+	struct usb_hub		*hub =
+		container_of(work, struct usb_hub, tt.clear_work);
+
+	_hub_tt_work(hub);
+}
+
 /**
  * usb_hub_clear_tt_buffer - clear control/bulk TT state in high speed hub
  * @urb: an URB associated with the failed or incomplete split transaction
@@ -543,7 +549,20 @@ int usb_hub_clear_tt_buffer(struct urb *urb)
 	/* tell keventd to clear state for this TT */
 	spin_lock_irqsave (&tt->lock, flags);
 	list_add_tail (&clear->clear_list, &tt->clear_list);
-	schedule_work(&tt->clear_work);
+	/* don't schedule on kevent if we're running on keventd (e.g.,
+	 * in hid_reset we can get here on kevent) unless on >=2.6.36
+	 */
+	if (!current_is_keventd())
+		/* put it on keventd */
+		schedule_work(&tt->clear_work);
+	else {
+		/* let khubd do it */
+		struct usb_hub		*hub =
+			container_of(&tt->clear_work, struct usb_hub,
+					tt.clear_work);
+		kick_khubd(hub);
+	}
+
 	spin_unlock_irqrestore (&tt->lock, flags);
 	return 0;
 }
@@ -3274,6 +3293,10 @@ static void hub_events(void)
 		if (hub->quiescing)
 			goto loop_autopm;
 
+		/* _hub_tt_work usually run on keventd */
+		if (!list_empty(&hub->tt.clear_list))
+			_hub_tt_work(hub);
+
 		if (hub->error) {
 			dev_dbg (hub_dev, "resetting for error %d\n",
 				hub->error);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 67e526b..b617e0c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -772,6 +772,7 @@ int current_is_keventd(void)
 	return ret;
 
 }
+EXPORT_SYMBOL_GPL(current_is_keventd);
 
 static struct cpu_workqueue_struct *
 init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
-- 
1.7.2.1.45.g54fbc



