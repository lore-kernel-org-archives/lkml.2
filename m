Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab1GIFyk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 01:54:40 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:47318 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752619Ab1GIFyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 01:54:17 -0400
X-Sasl-enc: Fnxgnjq6dokAbOkWcs/o2ctHylK80DGyUeNaptbIYU3f 1310190856
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 15:51:21 2011
Message-Id: <20110708225120.924136559@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 15:50:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [22/35] USB: dont let the hub driver prevent system sleep
In-Reply-To: <20110708225343.GA14402@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit cbb330045e5df8f665ac60227ff898421fc8fb92 upstream.

This patch (as1465) continues implementation of the policy that errors
during suspend or hibernation should not prevent the system from going
to sleep.

In this case, failure to turn on the Suspend feature for a hub port
shouldn't be reported as an error.  There are situations where this
does actually occur (such as when the device plugged into that port
was disconnected in the recent past), and it turns out to be harmless.
There's no reason for it to prevent a system sleep.

Also, don't allow the hub driver to fail a system suspend if the
downstream ports aren't all suspended.  This is also harmless (and
should never happen, given the change mentioned above); printing a
warning message in the kernel log is all we really need to do.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hub.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2188,6 +2188,10 @@ int usb_port_suspend(struct usb_device *
 				USB_DEVICE_REMOTE_WAKEUP, 0,
 				NULL, 0,
 				USB_CTRL_SET_TIMEOUT);
+
+		/* System sleep transitions should never fail */
+		if (!(msg.event & PM_EVENT_AUTO))
+			status = 0;
 	} else {
 		/* device has up to 10 msec to fully suspend */
 		dev_dbg(&udev->dev, "usb %ssuspend\n",
@@ -2427,16 +2431,15 @@ static int hub_suspend(struct usb_interf
 	struct usb_device	*hdev = hub->hdev;
 	unsigned		port1;
 
-	/* fail if children aren't already suspended */
+	/* Warn if children aren't already suspended */
 	for (port1 = 1; port1 <= hdev->maxchild; port1++) {
 		struct usb_device	*udev;
 
 		udev = hdev->children [port1-1];
 		if (udev && udev->can_submit) {
-			if (!(msg.event & PM_EVENT_AUTO))
-				dev_dbg(&intf->dev, "port %d nyet suspended\n",
-						port1);
-			return -EBUSY;
+			dev_warn(&intf->dev, "port %d nyet suspended\n", port1);
+			if (msg.event & PM_EVENT_AUTO)
+				return -EBUSY;
 		}
 	}
 


