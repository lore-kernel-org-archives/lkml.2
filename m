Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab1I1Whr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:37:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53460 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354Ab1I1Whp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:37:45 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:27 2011
Message-Id: <20110928220127.654820372@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andiry Xu <andiry.xu@amd.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [023/244] xHCI: report USB2 port in resuming as suspend
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andiry Xu <andiry.xu@amd.com>

commit 8a8ff2f9399b23b968901f585ccb5a70a537c5ae upstream.

When a USB2 port initiate a remote wakeup, software shall ensure that
resume is signaled for at least 20ms, and then write '0' to the PLS field.
According to this, xhci driver do the following things:

1. When receive a remote wakeup event in irq_handler, set the resume_done
   value as jiffies + 20ms, and modify rh_timer to poll root hub status at
   that time;
2. When receive a GetPortStatus request, if the jiffies is after the
   resume_done value, clear the resume signal and resume_done.

However, if usb_port_resume() is called before the rh_timer triggered, it
will indicate the port as Suspend Cleared and skip the clear resume signal
part. The device will fail the usb_get_status request in finish_port_resume(),
and usbcore will try a reset-resume instead. Device will work OK after
reset-resume, but resume_done value is not cleared in this case, and
xhci_bus_suspend() will fail because when it finds a non-zero resume_done
value, it will regard the port as resuming and return -EBUSY.

This causes issue on some platforms that the system fail to suspend
after remote wakeup from suspend by USB2 devices connected to xHCI port.

To fix this issue, report the port status as suspend if the resume is
signaling less that 20ms, and usb_port_resume() will wait 25ms and check
port status again, so xHCI driver can clear the resume signaling and
resume_done value.

This should be backported to kernels as old as 2.6.37.

Signed-off-by: Andiry Xu <andiry.xu@amd.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-hub.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -463,11 +463,12 @@ int xhci_hub_control(struct usb_hcd *hcd
 					&& (temp & PORT_POWER))
 				status |= USB_PORT_STAT_SUSPEND;
 		}
-		if ((temp & PORT_PLS_MASK) == XDEV_RESUME) {
+		if ((temp & PORT_PLS_MASK) == XDEV_RESUME &&
+				!DEV_SUPERSPEED(temp)) {
 			if ((temp & PORT_RESET) || !(temp & PORT_PE))
 				goto error;
-			if (!DEV_SUPERSPEED(temp) && time_after_eq(jiffies,
-						bus_state->resume_done[wIndex])) {
+			if (time_after_eq(jiffies,
+					bus_state->resume_done[wIndex])) {
 				xhci_dbg(xhci, "Resume USB2 port %d\n",
 					wIndex + 1);
 				bus_state->resume_done[wIndex] = 0;
@@ -487,6 +488,14 @@ int xhci_hub_control(struct usb_hcd *hcd
 				xhci_ring_device(xhci, slot_id);
 				bus_state->port_c_suspend |= 1 << wIndex;
 				bus_state->suspended_ports &= ~(1 << wIndex);
+			} else {
+				/*
+				 * The resume has been signaling for less than
+				 * 20ms. Report the port status as SUSPEND,
+				 * let the usbcore check port status again
+				 * and clear resume signaling later.
+				 */
+				status |= USB_PORT_STAT_SUSPEND;
 			}
 		}
 		if ((temp & PORT_PLS_MASK) == XDEV_U0


