Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694Ab1GKU7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 16:59:39 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:28156 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab1GKU7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 16:59:38 -0400
Date: Mon, 11 Jul 2011 22:59:36 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Alan Stern <stern@rowland.harvard.edu>
cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andiry Xu <andiry.xu@amd.com>, Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] USB: Avoid NULL pointer dereference in
 usb_disconnect()
In-Reply-To: <Pine.LNX.4.44L0.1107111100230.2236-100000@iolanthe.rowland.org>
Message-ID: <alpine.LNX.2.00.1107112246220.10944@swampdragon.chaosbits.net>
References: <Pine.LNX.4.44L0.1107111100230.2236-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011, Alan Stern wrote:

> On Mon, 11 Jul 2011, Jesper Juhl wrote:
> 
> > If, in drivers/usb/core/hub.c::usb_disconnect(), 'udev' is NULL, then
> > we'll never get to the printing of a debug message and returning from
> > the function since we'll have already dereferenced the NULL pointer in
> > the bus_to_hcd(udev->bus) call.
> > This patch moves the dereference to after the test for NULL, thus
> > avoiding that potential crash.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  drivers/usb/core/hub.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> >  disclaimer: compile tested only.
> > 
> > diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> > index a428aa0..0a98c76 100644
> > --- a/drivers/usb/core/hub.c
> > +++ b/drivers/usb/core/hub.c
> > @@ -1634,13 +1634,15 @@ void usb_disconnect(struct usb_device **pdev)
> >  {
> >  	struct usb_device	*udev = *pdev;
> >  	int			i;
> > -	struct usb_hcd		*hcd = bus_to_hcd(udev->bus);
> > +	struct usb_hcd		*hcd;
> >  
> >  	if (!udev) {
> >  		pr_debug ("%s nodev\n", __func__);
> >  		return;
> >  	}
> >  
> > +	hcd = bus_to_hcd(udev->bus);
> > +
> >  	/* mark the device as inactive, so any further urb submissions for
> >  	 * this device (and any of its children) will fail immediately.
> >  	 * this quiesces everything except pending urbs.
> 
> This is okay, but it might be better just to remove the NULL test 
> entirely.  Code inspection easily shows that it can never be triggered.
> 
I must admit I don't care much one way or the other. Moving the 
dereference seemed like the best thing to do to me - defensive in the 
face of future changes + anything that I possibly overlooked that could 
cause the pointer to actually be NULL. 
But I'm just as fine with just removing the NULL test and associated debug 
print if that seems the best solution to others.

Here's a patch to remove the test. Now you have both, pick whichever you 
prefer :-)


From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] USB: Remove test for NULL that'll never happen in usb_disconnect()

In drivers/usb/core/hub.c::usb_disconnect(), 'udev' will never be
NULL, so remove the test and printing of debug message.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/usb/core/hub.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index a428aa0..99fff6b 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1636,11 +1636,6 @@ void usb_disconnect(struct usb_device **pdev)
 	int			i;
 	struct usb_hcd		*hcd = bus_to_hcd(udev->bus);
 
-	if (!udev) {
-		pr_debug ("%s nodev\n", __func__);
-		return;
-	}
-
 	/* mark the device as inactive, so any further urb submissions for
 	 * this device (and any of its children) will fail immediately.
 	 * this quiesces everything except pending urbs.
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

