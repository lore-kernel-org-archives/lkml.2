Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab0C3XM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:12:28 -0400
Received: from kroah.org ([198.145.64.141]:48892 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756421Ab0C3XMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:18 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:26 2010
Message-Id: <20100330225826.431264706@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       Rickard Bellini <rickard.bellini@ericsson.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [29/89] USB: add missing delay during remote wakeup
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 49d0f078f494b9d81e820a13dd8093a9bfb0b6b1 upstream.

This patch (as1330) fixes a bug in khbud's handling of remote
wakeups.  When a device sends a remote-wakeup request, the parent hub
(or the host controller driver, for directly attached devices) begins
the resume sequence and notifies khubd when the sequence finishes.  At
this point the port's SUSPEND feature is automatically turned off.

However the device needs an additional 10-ms resume-recovery time
(TRSMRCY in the USB spec).  Khubd does not wait for this delay if the
SUSPEND feature is off, and as a result some devices fail to behave
properly following a remote wakeup.  This patch adds the missing
delay to the remote-wakeup path.

It also extends the resume-signalling delay used by ehci-hcd and
uhci-hcd from 20 ms (the value in the spec) to 25 ms (the value we use
for non-remote-wakeup resumes).  The extra time appears to help some
devices.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Rickard Bellini <rickard.bellini@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hub.c      |    3 +++
 drivers/usb/host/ehci-hcd.c |    5 +++--
 drivers/usb/host/uhci-hub.c |    2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3188,6 +3188,9 @@ static void hub_events(void)
 					USB_PORT_FEAT_C_SUSPEND);
 				udev = hdev->children[i-1];
 				if (udev) {
+					/* TRSMRCY = 10 msec */
+					msleep(10);
+
 					usb_lock_device(udev);
 					ret = remote_wakeup(hdev->
 							children[i-1]);
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -764,9 +764,10 @@ static irqreturn_t ehci_irq (struct usb_
 
 			/* start 20 msec resume signaling from this port,
 			 * and make khubd collect PORT_STAT_C_SUSPEND to
-			 * stop that signaling.
+			 * stop that signaling.  Use 5 ms extra for safety,
+			 * like usb_port_resume() does.
 			 */
-			ehci->reset_done [i] = jiffies + msecs_to_jiffies (20);
+			ehci->reset_done[i] = jiffies + msecs_to_jiffies(25);
 			ehci_dbg (ehci, "port %d remote wakeup\n", i + 1);
 			mod_timer(&hcd->rh_timer, ehci->reset_done[i]);
 		}
--- a/drivers/usb/host/uhci-hub.c
+++ b/drivers/usb/host/uhci-hub.c
@@ -167,7 +167,7 @@ static void uhci_check_ports(struct uhci
 				/* Port received a wakeup request */
 				set_bit(port, &uhci->resuming_ports);
 				uhci->ports_timeout = jiffies +
-						msecs_to_jiffies(20);
+						msecs_to_jiffies(25);
 
 				/* Make sure we see the port again
 				 * after the resuming period is over. */


