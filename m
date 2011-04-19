Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab1DSUof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:44:35 -0400
Received: from kroah.org ([198.145.64.141]:58995 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926Ab1DSUmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:42:50 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:41:19 2011
Message-Id: <20110419204119.169954731@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:31:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Torokhov <dtor@vmware.com>
Subject: [23/28] USB: fix formatting of SuperSpeed endpoints in /proc/bus/usb/devices
In-Reply-To: <20110419204122.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Torokhov <dtor@vmware.com>

commit 2868a2b1ba8f9c7f6c4170519ebb6c62934df70e upstream.

Isochronous and interrupt SuperSpeed endpoints use the same mechanisms
for decoding bInterval values as HighSpeed ones so adjust the code
accordingly.

Also bandwidth reservation for SuperSpeed matches highspeed, not
low/full speed.

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/devices.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/usb/core/devices.c
+++ b/drivers/usb/core/devices.c
@@ -211,7 +211,7 @@ static char *usb_dump_endpoint_descripto
 		break;
 	case USB_ENDPOINT_XFER_INT:
 		type = "Int.";
-		if (speed == USB_SPEED_HIGH)
+		if (speed == USB_SPEED_HIGH || speed == USB_SPEED_SUPER)
 			interval = 1 << (desc->bInterval - 1);
 		else
 			interval = desc->bInterval;
@@ -219,7 +219,8 @@ static char *usb_dump_endpoint_descripto
 	default:	/* "can't happen" */
 		return start;
 	}
-	interval *= (speed == USB_SPEED_HIGH) ? 125 : 1000;
+	interval *= (speed == USB_SPEED_HIGH ||
+		     speed == USB_SPEED_SUPER) ? 125 : 1000;
 	if (interval % 1000)
 		unit = 'u';
 	else {
@@ -529,8 +530,9 @@ static ssize_t usb_device_dump(char __us
 	if (level == 0) {
 		int	max;
 
-		/* high speed reserves 80%, full/low reserves 90% */
-		if (usbdev->speed == USB_SPEED_HIGH)
+		/* super/high speed reserves 80%, full/low reserves 90% */
+		if (usbdev->speed == USB_SPEED_HIGH ||
+		    usbdev->speed == USB_SPEED_SUPER)
 			max = 800;
 		else
 			max = FRAME_TIME_MAX_USECS_ALLOC;


