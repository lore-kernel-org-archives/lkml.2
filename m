Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab2DYGRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 02:17:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57981 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758426Ab2DYGRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 02:17:52 -0400
Date: Wed, 25 Apr 2012 01:17:42 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        Peter Chen <B29397@freescale.com>
Subject: Re: [ 39/62] EHCI: fix criterion for resuming the root hub
Message-ID: <20120425061741.GA14971@burratino>
References: <20120424223305.GA7748@kroah.com>
 <20120424223245.328130919@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424223245.328130919@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Greg KH wrote:

> 3.3-stable review patch.  If anyone has any objections, please let me know.
[...]
> commit dc75ce9d929aabeb0843a6b1a4ab320e58ba1597 upstream.
>
> This patch (as1542) changes the criterion ehci-hcd uses to tell when
> it needs to resume the controller's root hub.  A resume is needed when
> a port status change is detected, obviously, but only if the root hub
> is currently suspended.

Here's a blind backport to 3.0-stable (for next week, perhaps) that
accounts for the lack of v3.2-rc1~183^2~179^2~19 ("USB: EHCI: remove
usages of hcd->state", 2011-08-18).

Thanks,
Jonathan

-- >8 --
From: Alan Stern <stern@rowland.harvard.edu>
Date: Tue, 17 Apr 2012 15:24:15 -0400

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
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/usb/host/ehci-hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index b27ceab17743..6144c804cf10 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -860,7 +860,7 @@ static irqreturn_t ehci_irq (struct usb_hcd *hcd)
 		pcd_status = status;
 
 		/* resume root hub? */
-		if (!(cmd & CMD_RUN))
+		if (hcd->state == HC_STATE_SUSPENDED)
 			usb_hcd_resume_root_hub(hcd);
 
 		/* get per-port change detect bits */
-- 
1.7.10

