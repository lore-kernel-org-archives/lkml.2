Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab1BPBtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:49:41 -0500
Received: from kroah.org ([198.145.64.141]:48784 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479Ab1BPBta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:49:30 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:46:56 2011
Message-Id: <20110216014656.696621915@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:44:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [024/115] USB: prevent buggy hubs from crashing the USB stack
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit d199c96d41d80a567493e12b8e96ea056a1350c1 upstream.

If anyone comes across a high-speed hub that (by mistake or by design)
claims to have no Transaction Translators, plugging a full- or
low-speed device into it will cause the USB stack to crash.  This
patch (as1446) prevents the problem by ignoring such devices, since
the kernel has no way to communicate with them.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Perry Neben <neben@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hub.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2683,6 +2683,11 @@ hub_port_init (struct usb_hub *hub, stru
 		udev->ttport = hdev->ttport;
 	} else if (udev->speed != USB_SPEED_HIGH
 			&& hdev->speed == USB_SPEED_HIGH) {
+		if (!hub->tt.hub) {
+			dev_err(&udev->dev, "parent hub has no TT\n");
+			retval = -EINVAL;
+			goto fail;
+		}
 		udev->tt = &hub->tt;
 		udev->ttport = port1;
 	}


