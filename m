Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab2EIFxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:53:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38800 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755557Ab2EIFxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:00 -0400
Message-Id: <20120509055033.881015895@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:00 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        Peter Chen <B29397@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 031/167] [PATCH] EHCI: fix criterion for resuming the root hub
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/ehci-hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 806cc95..95ca07a 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -910,7 +910,7 @@ static irqreturn_t ehci_irq (struct usb_hcd *hcd)
 		pcd_status = status;
 
 		/* resume root hub? */
-		if (!(cmd & CMD_RUN))
+		if (ehci->rh_state == EHCI_RH_SUSPENDED)
 			usb_hcd_resume_root_hub(hcd);
 
 		/* get per-port change detect bits */
-- 
1.7.10



