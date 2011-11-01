Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab1KAJ0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 05:26:50 -0400
Received: from smtp-out.google.com ([74.125.121.67]:62273 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab1KAJ0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:26:47 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: jkosina@suse.cz, oneukum@suse.de, bleung@chromium.org
Cc: stern@rowland.harvard.edu, olofj@chromium.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 2/3] HID: usbhid: hid-core: submit queued urbs before suspend
Date: Tue,  1 Nov 2011 17:25:46 +0800
Message-Id: <1320139547-7921-3-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1320139547-7921-1-git-send-email-djkurtz@chromium.org>
References: <1320139547-7921-1-git-send-email-djkurtz@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If any userspace program has opened a keyboard device, the input core
de-activates the keyboard's LEDs upon suspend().  It does this by sending
individual EV_LED[LED_X]=0 events to the underlying device driver by directly
calling the driver's registered event() handler.

The usb-hid driver event() handler processes each request by immediately
attempting to submit a CTRL URB to turn off the LED.  USB URB submission
is asynchronous.  First the URB is added to the head of the ctrl queue.
Then, if the CTRL_RUNNING flag is false, the URB is submitted immediately
(and CTRL_RUNNING is set).  If the CTRL_RUNNING flag was already true,
then the newly queued URB is submitted in the ctrl completion handler when
all previously submitted URBs have completed.  When all queued URBs have
been submitted, the completion handler clears the CTRL_RUNNING flag.

In the 2-LED suspend case, at input suspend(), 2 LED event CTRL URBs get
queued, with only the first actually submitted.  Soon after input
suspend() handler finishes, the usb-hid suspend() handler gets called.
Since this is NOT a PM_EVENT_AUTO suspend, the handler sets
REPORTED_IDLE, then waits for io to complete.

Unfortunately, this usually happens while the first LED request is
actually still being processed.  Thus when the completion handler tries
to submit the second LED request it fails, since REPORTED_IDLE is
already set!  This REPORTED_IDLE check failure causes the completion
handler to complete, however without clearing the CTRL_RUNNING flag.
This, in turn, means that the suspend() handler's wait_io() condition
is never satisfied, and instead it times out after 10 seconds, aborting
the original system suspend.

This patch changes the behavior to the following:
  (1) allow completion handler to finish submitting all queued URBs, even if
      REPORTED_IDLE is set.  This guarantees that all URBs queued before the
      hid-core suspend() call will be submitted before the system is
      suspended.
  (2) if REPORTED_IDLE is set and the URB queue is empty, queue, but
      don't submit, new URB submission requests.  These queued requests get
      submitted when the resume() handler flushes the URB queue.  This is
      similar to the existing behavior, however, any requests that arrive
      while the queue is not yet empty will get submitted before suspend.
  (3) set the RUNNING flag when flushing the URB queue in the resume()
      path.  This keeps the URBs from (2) from colliding with any new
      URBs that are being submitted during the resume process.  URBs
      submission requests upon resume will get properly queued behind
      the ones being flushed instead of the current situation where they
      collide, causing memory corruption and oopses.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/hid/usbhid/hid-core.c |  184 +++++++++++++++++++++++------------------
 1 files changed, 105 insertions(+), 79 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 1101961..7f67cfa 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -197,16 +197,24 @@ static int usbhid_restart_out_queue(struct usbhid_device *usbhid)
 {
 	struct hid_device *hid = usb_get_intfdata(usbhid->intf);
 	int kicked;
+	int r;
 
 	if (!hid)
 		return 0;
 
 	if ((kicked = (usbhid->outhead != usbhid->outtail))) {
 		dbg("Kicking head %d tail %d", usbhid->outhead, usbhid->outtail);
+
+		r = usb_autopm_get_interface_async(usbhid->intf);
+		if (r < 0)
+			return r;
+		/* Asynchronously flush queue. */
+		set_bit(HID_OUT_RUNNING, &usbhid->iofl);
 		if (hid_submit_out(hid)) {
 			clear_bit(HID_OUT_RUNNING, &usbhid->iofl);
-			wake_up(&usbhid->wait);
+			usb_autopm_put_interface_async(usbhid->intf);
 		}
+		wake_up(&usbhid->wait);
 	}
 	return kicked;
 }
@@ -215,6 +223,7 @@ static int usbhid_restart_ctrl_queue(struct usbhid_device *usbhid)
 {
 	struct hid_device *hid = usb_get_intfdata(usbhid->intf);
 	int kicked;
+	int r;
 
 	WARN_ON(hid == NULL);
 	if (!hid)
@@ -222,10 +231,17 @@ static int usbhid_restart_ctrl_queue(struct usbhid_device *usbhid)
 
 	if ((kicked = (usbhid->ctrlhead != usbhid->ctrltail))) {
 		dbg("Kicking head %d tail %d", usbhid->ctrlhead, usbhid->ctrltail);
+
+		r = usb_autopm_get_interface_async(usbhid->intf);
+		if (r < 0)
+			return r;
+		/* Asynchronously flush queue. */
+		set_bit(HID_CTRL_RUNNING, &usbhid->iofl);
 		if (hid_submit_ctrl(hid)) {
 			clear_bit(HID_CTRL_RUNNING, &usbhid->iofl);
-			wake_up(&usbhid->wait);
+			usb_autopm_put_interface_async(usbhid->intf);
 		}
+		wake_up(&usbhid->wait);
 	}
 	return kicked;
 }
@@ -304,30 +320,21 @@ static int hid_submit_out(struct hid_device *hid)
 	report = usbhid->out[usbhid->outtail].report;
 	raw_report = usbhid->out[usbhid->outtail].raw_report;
 
-	r = usb_autopm_get_interface_async(usbhid->intf);
-	if (r < 0)
-		return -1;
+	usbhid->urbout->transfer_buffer_length = ((report->size - 1) >> 3) +
+						 1 + (report->id > 0);
+	usbhid->urbout->dev = hid_to_usb_dev(hid);
+	memcpy(usbhid->outbuf, raw_report,
+	       usbhid->urbout->transfer_buffer_length);
+	kfree(raw_report);
 
-	/*
-	 * if the device hasn't been woken, we leave the output
-	 * to resume()
-	 */
-	if (!test_bit(HID_REPORTED_IDLE, &usbhid->iofl)) {
-		usbhid->urbout->transfer_buffer_length = ((report->size - 1) >> 3) + 1 + (report->id > 0);
-		usbhid->urbout->dev = hid_to_usb_dev(hid);
-		memcpy(usbhid->outbuf, raw_report, usbhid->urbout->transfer_buffer_length);
-		kfree(raw_report);
-
-		dbg_hid("submitting out urb\n");
+	dbg_hid("submitting out urb\n");
 
-		if (usb_submit_urb(usbhid->urbout, GFP_ATOMIC)) {
-			hid_err(hid, "usb_submit_urb(out) failed\n");
-			usb_autopm_put_interface_async(usbhid->intf);
-			return -1;
-		}
-		usbhid->last_out = jiffies;
+	r = usb_submit_urb(usbhid->urbout, GFP_ATOMIC);
+	if (r < 0) {
+		hid_err(hid, "usb_submit_urb(out) failed: %d\n", r);
+		return r;
 	}
-
+	usbhid->last_out = jiffies;
 	return 0;
 }
 
@@ -343,50 +350,48 @@ static int hid_submit_ctrl(struct hid_device *hid)
 	raw_report = usbhid->ctrl[usbhid->ctrltail].raw_report;
 	dir = usbhid->ctrl[usbhid->ctrltail].dir;
 
-	r = usb_autopm_get_interface_async(usbhid->intf);
-	if (r < 0)
-		return -1;
-	if (!test_bit(HID_REPORTED_IDLE, &usbhid->iofl)) {
-		len = ((report->size - 1) >> 3) + 1 + (report->id > 0);
-		if (dir == USB_DIR_OUT) {
-			usbhid->urbctrl->pipe = usb_sndctrlpipe(hid_to_usb_dev(hid), 0);
-			usbhid->urbctrl->transfer_buffer_length = len;
-			memcpy(usbhid->ctrlbuf, raw_report, len);
-			kfree(raw_report);
-		} else {
-			int maxpacket, padlen;
-
-			usbhid->urbctrl->pipe = usb_rcvctrlpipe(hid_to_usb_dev(hid), 0);
-			maxpacket = usb_maxpacket(hid_to_usb_dev(hid), usbhid->urbctrl->pipe, 0);
-			if (maxpacket > 0) {
-				padlen = DIV_ROUND_UP(len, maxpacket);
-				padlen *= maxpacket;
-				if (padlen > usbhid->bufsize)
-					padlen = usbhid->bufsize;
-			} else
-				padlen = 0;
-			usbhid->urbctrl->transfer_buffer_length = padlen;
-		}
-		usbhid->urbctrl->dev = hid_to_usb_dev(hid);
-
-		usbhid->cr->bRequestType = USB_TYPE_CLASS | USB_RECIP_INTERFACE | dir;
-		usbhid->cr->bRequest = (dir == USB_DIR_OUT) ? HID_REQ_SET_REPORT : HID_REQ_GET_REPORT;
-		usbhid->cr->wValue = cpu_to_le16(((report->type + 1) << 8) | report->id);
-		usbhid->cr->wIndex = cpu_to_le16(usbhid->ifnum);
-		usbhid->cr->wLength = cpu_to_le16(len);
-
-		dbg_hid("submitting ctrl urb: %s wValue=0x%04x wIndex=0x%04x wLength=%u\n",
-			usbhid->cr->bRequest == HID_REQ_SET_REPORT ? "Set_Report" : "Get_Report",
-			usbhid->cr->wValue, usbhid->cr->wIndex, usbhid->cr->wLength);
-
-		if (usb_submit_urb(usbhid->urbctrl, GFP_ATOMIC)) {
-			usb_autopm_put_interface_async(usbhid->intf);
-			hid_err(hid, "usb_submit_urb(ctrl) failed\n");
-			return -1;
-		}
-		usbhid->last_ctrl = jiffies;
+	len = ((report->size - 1) >> 3) + 1 + (report->id > 0);
+	if (dir == USB_DIR_OUT) {
+		usbhid->urbctrl->pipe = usb_sndctrlpipe(hid_to_usb_dev(hid), 0);
+		usbhid->urbctrl->transfer_buffer_length = len;
+		memcpy(usbhid->ctrlbuf, raw_report, len);
+		kfree(raw_report);
+	} else {
+		int maxpacket, padlen;
+
+		usbhid->urbctrl->pipe = usb_rcvctrlpipe(hid_to_usb_dev(hid), 0);
+		maxpacket = usb_maxpacket(hid_to_usb_dev(hid),
+					  usbhid->urbctrl->pipe, 0);
+		if (maxpacket > 0) {
+			padlen = DIV_ROUND_UP(len, maxpacket);
+			padlen *= maxpacket;
+			if (padlen > usbhid->bufsize)
+				padlen = usbhid->bufsize;
+		} else
+			padlen = 0;
+		usbhid->urbctrl->transfer_buffer_length = padlen;
 	}
-
+	usbhid->urbctrl->dev = hid_to_usb_dev(hid);
+
+	usbhid->cr->bRequestType = USB_TYPE_CLASS | USB_RECIP_INTERFACE | dir;
+	usbhid->cr->bRequest = (dir == USB_DIR_OUT) ? HID_REQ_SET_REPORT :
+						      HID_REQ_GET_REPORT;
+	usbhid->cr->wValue = cpu_to_le16(((report->type + 1) << 8) |
+					 report->id);
+	usbhid->cr->wIndex = cpu_to_le16(usbhid->ifnum);
+	usbhid->cr->wLength = cpu_to_le16(len);
+
+	dbg_hid("submitting ctrl urb: %s wValue=0x%04x wIndex=0x%04x wLength=%u\n",
+		usbhid->cr->bRequest == HID_REQ_SET_REPORT ? "Set_Report" :
+							     "Get_Report",
+		usbhid->cr->wValue, usbhid->cr->wIndex, usbhid->cr->wLength);
+
+	r = usb_submit_urb(usbhid->urbctrl, GFP_ATOMIC);
+	if (r < 0) {
+		hid_err(hid, "usb_submit_urb(ctrl) failed: %d\n", r);
+		return r;
+	}
+	usbhid->last_ctrl = jiffies;
 	return 0;
 }
 
@@ -423,11 +428,8 @@ static void hid_irq_out(struct urb *urb)
 	else
 		usbhid->outtail = (usbhid->outtail + 1) & (HID_OUTPUT_FIFO_SIZE - 1);
 
-	if (usbhid->outhead != usbhid->outtail) {
-		if (hid_submit_out(hid)) {
-			clear_bit(HID_OUT_RUNNING, &usbhid->iofl);
-			wake_up(&usbhid->wait);
-		}
+	if (usbhid->outhead != usbhid->outtail && !hid_submit_out(hid)) {
+		/* Successfully submitted next urb in queue */
 		spin_unlock_irqrestore(&usbhid->lock, flags);
 		return;
 	}
@@ -474,13 +476,9 @@ static void hid_ctrl(struct urb *urb)
 	else
 		usbhid->ctrltail = (usbhid->ctrltail + 1) & (HID_CONTROL_FIFO_SIZE - 1);
 
-	if (usbhid->ctrlhead != usbhid->ctrltail) {
-		if (hid_submit_ctrl(hid)) {
-			clear_bit(HID_CTRL_RUNNING, &usbhid->iofl);
-			wake_up(&usbhid->wait);
-		}
+	if (usbhid->ctrlhead != usbhid->ctrltail && !hid_submit_ctrl(hid)) {
+		/* Successfully submitted next urb in queue */
 		spin_unlock(&usbhid->lock);
-		usb_autopm_put_interface_async(usbhid->intf);
 		return;
 	}
 
@@ -515,9 +513,23 @@ static void __usbhid_submit_report(struct hid_device *hid, struct hid_report *re
 		usbhid->out[usbhid->outhead].report = report;
 		usbhid->outhead = head;
 
+		/* Try to awake from autosuspend... */
+		if (usb_autopm_get_interface_async(usbhid->intf) < 0)
+			return;
+
+		/*
+		 * But if still suspended, leave urb enqueued, don't submit.
+		 * Submission will occur if/when resume() drains the queue.
+		 */
+		if (test_bit(HID_REPORTED_IDLE, &usbhid->iofl))
+			return;
+
 		if (!test_and_set_bit(HID_OUT_RUNNING, &usbhid->iofl)) {
-			if (hid_submit_out(hid))
+			if (hid_submit_out(hid)) {
 				clear_bit(HID_OUT_RUNNING, &usbhid->iofl);
+				usb_autopm_put_interface_async(usbhid->intf);
+			}
+			wake_up(&usbhid->wait);
 		} else {
 			/*
 			 * the queue is known to run
@@ -549,9 +561,23 @@ static void __usbhid_submit_report(struct hid_device *hid, struct hid_report *re
 	usbhid->ctrl[usbhid->ctrlhead].dir = dir;
 	usbhid->ctrlhead = head;
 
+	/* Try to awake from autosuspend... */
+	if (usb_autopm_get_interface_async(usbhid->intf) < 0)
+		return;
+
+	/*
+	 * If already suspended, leave urb enqueued, but don't submit.
+	 * Submission will occur if/when resume() drains the queue.
+	 */
+	if (test_bit(HID_REPORTED_IDLE, &usbhid->iofl))
+		return;
+
 	if (!test_and_set_bit(HID_CTRL_RUNNING, &usbhid->iofl)) {
-		if (hid_submit_ctrl(hid))
+		if (hid_submit_ctrl(hid)) {
 			clear_bit(HID_CTRL_RUNNING, &usbhid->iofl);
+			usb_autopm_put_interface_async(usbhid->intf);
+		}
+		wake_up(&usbhid->wait);
 	} else {
 		/*
 		 * the queue is known to run
-- 
1.7.3.1

