Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab0JPUFU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 16:05:20 -0400
Received: from netrider.rowland.org ([192.131.102.5]:57216 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754627Ab0JPUFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 16:05:17 -0400
Date: Sat, 16 Oct 2010 16:05:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: David Brownell <david-b@pacbell.net>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.36-rc7: NULL pointer dereference in ehci_clear_tt_buffer_complete
In-Reply-To: <4CBA0089.2060700@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.44L0.1010161600240.21391-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Oct 2010, Stefan Richter wrote:

> Alan Stern wrote:
> > On Thu, 14 Oct 2010, Stefan Richter wrote:
> > 
> >> Alan Stern wrote:
> >>> Stefan, is it possible for you to tell whether this really does work?
> >> That will be hard.  So far I was unable to reproduce the oops; still running
> >> unmodified 2.6.36-rc7.
> > 
> > Was this on an SMP machine?
> 
> Yes.
> 
> > If yes, the untested patch below may help
> > trigger the oops.  To use it, insert (but don't mount) a memory card
> > into the card reader, and use dd to copy a large amount of data from
> > the card to /dev/null.  While that's running, unplug either the monitor
> > or the card reader.  You may want to do this at a VT console so you can
> > see directly when the delay occurs.
> > 
> > Alan Stern
> > 
> > 
> > 
> > Index: usb-2.6/drivers/usb/core/message.c
> > ===================================================================
> > --- usb-2.6.orig/drivers/usb/core/message.c
> > +++ usb-2.6/drivers/usb/core/message.c
> > @@ -323,8 +323,13 @@ static void sg_complete(struct urb *urb)
> >  	/* on the last completion, signal usb_sg_wait() */
> >  	io->bytes += urb->actual_length;
> >  	io->count--;
> > -	if (!io->count)
> > +	if (!io->count) {
> > +		if (status == -ECONNRESET) {
> > +			printk(KERN_ERR "Delaying for test\n");
> > +			mdelay(600);
> > +		}
> >  		complete(&io->complete);
> > +	}
> >  
> >  	spin_unlock(&io->lock);
> >  }
> > 
> 
> I did so today on 2.6.36-rc8, without your other patch.  I was still unable to
> reproduce the bug.  Forget the whole thing as unreproducible?

What I said above wasn't quite right.  This won't help trigger the 
oops, but it should trigger the line saying something like

	ehci_hcd 0000:00:12.2: qh ffff880208f07af0 (#00) state 5

That's the real bug.

Alan Stern

