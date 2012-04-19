Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543Ab2DSVPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:15:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34108 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491Ab2DSVPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:15:36 -0400
Message-Id: <20120419210307.646387464@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:03:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Elric Fu <elricfu1@gmail.com>,
        Andiry Xu <Andiry.Xu@amd.com>, Sergei Shtylyov <sshtylyov@mvista.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 53/75] USB: fix bug of device descriptor got from superspeed device
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Elric Fu <elricfu1@gmail.com>

commit d8aec3dbdfd02627e198e7956ab4aaeba2a349fa upstream.

When the Seagate Goflex USB3.0 device is attached to VIA xHCI
host, sometimes the device will downgrade mode to high speed.
By the USB analyzer, I found the device finished the link
training process and worked at superspeed mode. But the device
descriptor got from the device shows the device works at 2.1.
It is very strange and seems like the device controller of
Seagate Goflex has a little confusion.

The first 8 bytes of device descriptor should be:
12 01 00 03 00 00 00 09

But the first 8 bytes of wrong device descriptor are:
12 01 10 02 00 00 00 40

The wrong device descriptor caused the initialization of mass
storage failed. After a while, the device would be recognized
as a high speed device and works fine.

This patch will warm reset the device to fix the issue after
finding the bcdUSB field of device descriptor isn't 0x0300
but the speed mode of device is superspeed.

This patch should be backported to kernels as old as 3.2, or ones that
contain the commit 75d7cf72ab9fa01dc70877aa5c68e8ef477229dc "usbcore:
refine warm reset logic".

Signed-off-by: Elric Fu <elricfu1@gmail.com>
Acked-by: Andiry Xu <Andiry.Xu@amd.com>
Acked-by: Sergei Shtylyov <sshtylyov@mvista.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3071,6 +3071,22 @@ hub_port_init (struct usb_hub *hub, stru
 	if (retval)
 		goto fail;
 
+	/*
+	 * Some superspeed devices have finished the link training process
+	 * and attached to a superspeed hub port, but the device descriptor
+	 * got from those devices show they aren't superspeed devices. Warm
+	 * reset the port attached by the devices can fix them.
+	 */
+	if ((udev->speed == USB_SPEED_SUPER) &&
+			(le16_to_cpu(udev->descriptor.bcdUSB) < 0x0300)) {
+		dev_err(&udev->dev, "got a wrong device descriptor, "
+				"warm reset device\n");
+		hub_port_reset(hub, port1, udev,
+				HUB_BH_RESET_TIME, true);
+		retval = -EINVAL;
+		goto fail;
+	}
+
 	if (udev->descriptor.bMaxPacketSize0 == 0xff ||
 			udev->speed == USB_SPEED_SUPER)
 		i = 512;


