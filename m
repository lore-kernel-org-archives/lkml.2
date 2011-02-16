Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab1BPBTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:19:49 -0500
Received: from kroah.org ([198.145.64.141]:45273 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932877Ab1BPAsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:48:11 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:02 2011
Message-Id: <20110216002102.533477669@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:20:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 034/176] USB: fix race between root-hub resume and wakeup requests
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit bf3d7d40e42a85ca73a34e1385ff34f092a384eb upstream.

The USB core keeps track of pending resume requests for root hubs, in
order to resolve races between wakeup requests and suspends.  However
the code that does this is subject to another race (between wakeup
requests and resumes) because the WAKEUP_PENDING flag is cleared
before the resume occurs, leaving a window in which another wakeup
request might arrive.

This patch (as1447) fixes the problem by clearing the WAKEUP_PENDING
flag after the resume instead of before it.

This fixes Bugzilla #24952.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Paul Bender <pebender@san.rr.com>
Tested-by: warpme <warpme@o2.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1945,7 +1945,6 @@ int hcd_bus_resume(struct usb_device *rh
 
 	dev_dbg(&rhdev->dev, "usb %s%s\n",
 			(msg.event & PM_EVENT_AUTO ? "auto-" : ""), "resume");
-	clear_bit(HCD_FLAG_WAKEUP_PENDING, &hcd->flags);
 	if (!hcd->driver->bus_resume)
 		return -ENOENT;
 	if (hcd->state == HC_STATE_RUNNING)
@@ -1953,6 +1952,7 @@ int hcd_bus_resume(struct usb_device *rh
 
 	hcd->state = HC_STATE_RESUMING;
 	status = hcd->driver->bus_resume(hcd);
+	clear_bit(HCD_FLAG_WAKEUP_PENDING, &hcd->flags);
 	if (status == 0) {
 		/* TRSMRCY = 10 msec */
 		msleep(10);


