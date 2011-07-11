Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab1GKJVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 05:21:21 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22333 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab1GKJVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 05:21:20 -0400
Date: Mon, 11 Jul 2011 11:21:18 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>, Andiry Xu <andiry.xu@amd.com>,
        Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH] USB: Avoid NULL pointer dereference in usb_disconnect()
Message-ID: <alpine.LNX.2.00.1107111119080.4462@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If, in drivers/usb/core/hub.c::usb_disconnect(), 'udev' is NULL, then
we'll never get to the printing of a debug message and returning from
the function since we'll have already dereferenced the NULL pointer in
the bus_to_hcd(udev->bus) call.
This patch moves the dereference to after the test for NULL, thus
avoiding that potential crash.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/usb/core/hub.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

 disclaimer: compile tested only.

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index a428aa0..0a98c76 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1634,13 +1634,15 @@ void usb_disconnect(struct usb_device **pdev)
 {
 	struct usb_device	*udev = *pdev;
 	int			i;
-	struct usb_hcd		*hcd = bus_to_hcd(udev->bus);
+	struct usb_hcd		*hcd;
 
 	if (!udev) {
 		pr_debug ("%s nodev\n", __func__);
 		return;
 	}
 
+	hcd = bus_to_hcd(udev->bus);
+
 	/* mark the device as inactive, so any further urb submissions for
 	 * this device (and any of its children) will fail immediately.
 	 * this quiesces everything except pending urbs.
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

