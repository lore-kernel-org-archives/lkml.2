Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425Ab1CEBAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:00:24 -0500
Received: from kroah.org ([198.145.64.141]:50263 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760384Ab1CEBAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:37 2011
Message-Id: <20110305005637.819425422@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Luben Tuikov <ltuikov@yahoo.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [33/73] USB: Reset USB 3.0 devices on (re)discovery
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luben Tuikov <ltuikov@yahoo.com>

commit 07194ab7be63a972096309ab0ea747df455c6a20 upstream.

If the device isn't reset, the XHCI HCD sends
SET ADDRESS to address 0 while the device is
already in Addressed state, and the request is
dropped on the floor as it is addressed to the
default address. This sequence of events, which this
patch fixes looks like this:

usb_reset_and_verify_device()
	hub_port_init()
		hub_set_address()
			SET_ADDRESS to 0 with 1
		usb_get_device_descriptor(udev, 8)
		usb_get_device_descriptor(udev, 18)
	descriptors_changed() --> goto re_enumerate:
		hub_port_logical_disconnect()
			kick_khubd()

And then:

hub_events()
	hub_port_connect_change()
		usb_disconnect()
			usb_disable_device()
		new device struct
		sets device state to Powered
		choose_address()
		hub_port_init() <-- no reset, but SET ADDRESS to 0 with 1, timeout!

The solution is to always reset the device in
hub_port_init() to put it in a known state.

Note from Sarah Sharp:

This patch should be queued for stable trees all the way back to 2.6.34,
since that was the first kernel that supported configured device reset.
The code this patch touches has been there since 2.6.32, but the bug
would never be hit before 2.6.34 because the xHCI driver would
completely reject an attempt to reset a configured device under xHCI.

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hub.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2672,17 +2672,13 @@ hub_port_init (struct usb_hub *hub, stru
 
 	mutex_lock(&usb_address0_mutex);
 
-	if (!udev->config && oldspeed == USB_SPEED_SUPER) {
-		/* Don't reset USB 3.0 devices during an initial setup */
-		usb_set_device_state(udev, USB_STATE_DEFAULT);
-	} else {
-		/* Reset the device; full speed may morph to high speed */
-		/* FIXME a USB 2.0 device may morph into SuperSpeed on reset. */
-		retval = hub_port_reset(hub, port1, udev, delay);
-		if (retval < 0)		/* error or disconnect */
-			goto fail;
-		/* success, speed is known */
-	}
+	/* Reset the device; full speed may morph to high speed */
+	/* FIXME a USB 2.0 device may morph into SuperSpeed on reset. */
+	retval = hub_port_reset(hub, port1, udev, delay);
+	if (retval < 0)		/* error or disconnect */
+		goto fail;
+	/* success, speed is known */
+
 	retval = -ENODEV;
 
 	if (oldspeed != USB_SPEED_UNKNOWN && oldspeed != udev->speed) {


