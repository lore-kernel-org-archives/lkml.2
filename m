Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab1G0Vtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:49:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:16747 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755746Ab1G0VtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32826583"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: stern@rowland.harvard.edu, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [85/99] USB: don't let the hub driver prevent system sleep
Message-Id: <20110727214924.CEB252403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/core/hub.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

Index: linux-2.6.35.y/drivers/usb/core/hub.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/core/hub.c
+++ linux-2.6.35.y/drivers/usb/core/hub.c
@@ -2233,6 +2233,10 @@ int usb_port_suspend(struct usb_device *
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
@@ -2470,16 +2474,15 @@ static int hub_suspend(struct usb_interf
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
 
