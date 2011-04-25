Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab1DYVBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 17:01:55 -0400
Received: from 1wt.eu ([62.212.114.60]:33736 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548Ab1DYUXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:23:22 -0400
Message-Id: <20110425200233.474646810@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:02:43 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 011/173] USB: prevent buggy hubs from crashing the USB stack
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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


