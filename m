Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352Ab2DXWxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:53:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49279 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576Ab2DXWfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:35:55 -0400
Message-Id: <20120424223245.328130919@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        Peter Chen <B29397@freescale.com>
Subject: [ 39/62] EHCI: fix criterion for resuming the root hub
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit dc75ce9d929aabeb0843a6b1a4ab320e58ba1597 upstream.

This patch (as1542) changes the criterion ehci-hcd uses to tell when
it needs to resume the controller's root hub.  A resume is needed when
a port status change is detected, obviously, but only if the root hub
is currently suspended.

Right now the driver tests whether the root hub is running, and that
is not the correct test.  In particular, if the controller has died
then the root hub should not be restarted.  In addition, some buggy
hardware occasionally requires the root hub to be running and
sending out SOF packets even while it is nominally supposed to be
suspended.

In the end, the test needs to be changed.  Rather than checking whether
the root hub is currently running, the driver will now check whether
the root hub is currently suspended.  This will yield the correct
behavior in all cases.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Peter Chen <B29397@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -909,7 +909,7 @@ static irqreturn_t ehci_irq (struct usb_
 		pcd_status = status;
 
 		/* resume root hub? */
-		if (!(cmd & CMD_RUN))
+		if (ehci->rh_state == EHCI_RH_SUSPENDED)
 			usb_hcd_resume_root_hub(hcd);
 
 		/* get per-port change detect bits */


