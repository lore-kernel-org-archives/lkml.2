Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab1GKJr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 05:47:56 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22427 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab1GKJrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 05:47:55 -0400
Date: Mon, 11 Jul 2011 11:47:53 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: wangyanqing <udknight@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: Avoid NULL pointer dereference in
 usb_disconnect()
In-Reply-To: <20110711093651.GA10217@udknight>
Message-ID: <alpine.LNX.2.00.1107111144060.4462@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107111119080.4462@swampdragon.chaosbits.net> <20110711093651.GA10217@udknight>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011, wangyanqing wrote:

> On Mon, Jul 11, 2011 at 11:21:18AM +0200, Jesper Juhl wrote:
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
> > -- 
> > 1.7.6
> > 
> > 
> Hello,All.Just a question,should we add the NULL checker code at everywhere that 
> dereference pointer in kernel? If so,it will scare me.
> 
Of course not.

But here there is already an explicit test for NULL which implies that 
this pointer can in fact be NULL, which is why it seems unsafe to 
dereference it before that check. Thus I moved the dereference.

If someone can prove that the pointer will never be NULL, then I'd be fine 
with just removing the NULL test and debug print instead.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

