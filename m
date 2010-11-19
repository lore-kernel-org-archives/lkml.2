Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab0KSV6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:58:51 -0500
Received: from kroah.org ([198.145.64.141]:45163 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757460Ab0KSV6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:47 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:42 2010
Message-Id: <20101119215642.539817880@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [46/82] USB: disable endpoints after unbinding interfaces, not before
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 80f0cf3947889014d3a3dc0ad60fb87cfda4b12a upstream.

This patch (as1430) fixes a bug in usbcore.  When a device
configuration change occurs or a device is removed, the endpoints for
the old config should be completely disabled.  However it turns out
they aren't; this is because usb_unbind_interface() calls
usb_enable_interface() or usb_set_interface() to put interfaces back
in altsetting 0, which re-enables the interfaces' endpoints.

As a result, when a device goes through a config change or is
unconfigured, the ep_in[] and ep_out[] arrays may be left holding old
pointers to usb_host_endpoint structures.  If the device is
deauthorized these structures get freed, and the stale pointers cause
errors when the the device is eventually unplugged.

The solution is to disable the endpoints after unbinding the
interfaces instead of before.  This isn't as large a change as it
sounds, since usb_unbind_interface() disables all the interface's
endpoints anyway before calling the driver's disconnect routine,
unless the driver claims to support "soft" unbind.

This fixes Bugzilla #19192.  Thanks to "Tom" Lei Ming for diagnosing
the underlying cause of the problem.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Carsten Sommer <carsten_sommer@ymail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/message.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1140,13 +1140,6 @@ void usb_disable_device(struct usb_devic
 {
 	int i;
 
-	dev_dbg(&dev->dev, "%s nuking %s URBs\n", __func__,
-		skip_ep0 ? "non-ep0" : "all");
-	for (i = skip_ep0; i < 16; ++i) {
-		usb_disable_endpoint(dev, i, true);
-		usb_disable_endpoint(dev, i + USB_DIR_IN, true);
-	}
-
 	/* getting rid of interfaces will disconnect
 	 * any drivers bound to them (a key side effect)
 	 */
@@ -1176,6 +1169,13 @@ void usb_disable_device(struct usb_devic
 		if (dev->state == USB_STATE_CONFIGURED)
 			usb_set_device_state(dev, USB_STATE_ADDRESS);
 	}
+
+	dev_dbg(&dev->dev, "%s nuking %s URBs\n", __func__,
+		skip_ep0 ? "non-ep0" : "all");
+	for (i = skip_ep0; i < 16; ++i) {
+		usb_disable_endpoint(dev, i, true);
+		usb_disable_endpoint(dev, i + USB_DIR_IN, true);
+	}
 }
 
 /**


