Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029Ab0KSWaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:30:04 -0500
Received: from kroah.org ([198.145.64.141]:45078 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757378Ab0KSV6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:37 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:41 2010
Message-Id: <20101119215641.226004305@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:55:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roger Quadros <roger.quadros@nokia.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Robert Lukassen <robert.lukassen@tomtom.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [30/82] usb gadget: composite: prevent OOPS for non-standard control request
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roger Quadros <roger.quadros@nokia.com>

commit 5c836e4d583701a5eecb288b5f131da39115f5ec upstream.

The composite gadget will OOPS if the host sends a control request
targetted to an interface of an un-configured composite device. This patch
prevents this.

The OOPS was observed during WHQL USB CV tests. With this patch, the device
STALLs as per requirement.

Failing test case: From host do the following. I used libusb-1.0

1) Set configuration to zero.
	libusb_control_transfer(device_handle,
		0, /* standard OUT */
		0x9, /* setConfiguration */
		0, 0, NULL, 0, 0);

2) Query current configuratioan.
	libusb_control_transfer(device_handle,
		0x80, /* standard IN*/
		0x8, /* getConfiguration */
		0, 0, data, 1, 0);

3) Send the non-standard ctrl transfer targetted to interface
	libusb_control_transfer(device_handle,
		0x81, /* standard IN to interface*/
		0x6, /* getDescriptor */
		0x2300, 0, data, 0x12, 0);

Signed-off-by: Roger Quadros <roger.quadros@nokia.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Robert Lukassen <robert.lukassen@tomtom.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/composite.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -838,7 +838,8 @@ unknown:
 		 */
 		switch (ctrl->bRequestType & USB_RECIP_MASK) {
 		case USB_RECIP_INTERFACE:
-			f = cdev->config->interface[intf];
+			if (cdev->config)
+				f = cdev->config->interface[intf];
 			break;
 
 		case USB_RECIP_ENDPOINT:


