Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab1FXQz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 12:55:26 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:34834 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab1FXQzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 12:55:23 -0400
Date: Fri, 24 Jun 2011 20:54:32 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-uvc-devel@lists.berlios.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH] USB: EHCI: Allow users to override 80% max
	periodic bandwidth
Message-ID: <20110624165432.GA6415@tugrik.mns.mnsspb.ru>
References: <20110623140539.GA4403@tugrik.mns.mnsspb.ru> <Pine.LNX.4.44L0.1106231312270.2033-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1106231312270.2033-100000@iolanthe.rowland.org>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 01:14:04PM -0400, Alan Stern wrote:
> On Thu, 23 Jun 2011, Kirill Smelkov wrote:
> 
> > > At 480 Mb/s, each microframe holds 7500 bytes (less if you count 
> > > bit-stuffing).  4% of that is 300 bytes, which is not enough for a 
> > > 512-byte bulk packet.  I think you'd run into trouble trying to do any 
> > > serious bulk transfers on such a tight schedule.
> > 
> > Yes, you seem to be right.
> > 
> > I still think 4% is maybe enough for control traffic.
> 
> It should be.

Ok then.

At least devices could be start/stopped, and frankly if someone loads
the bus with two high-bandwidth isoc streams, there is no reason to
expect any bulk transfer to happen at all.

> > > > @@ -571,6 +579,14 @@ static int ehci_init(struct usb_hcd *hcd)
> > > >  	hcc_params = ehci_readl(ehci, &ehci->caps->hcc_params);
> > > >  
> > > >  	/*
> > > > +	 * tell user, if using non-standard (80% == 100 usec/uframe) bandwidth
> > > > +	 */
> > > > +	if (uframe_periodic_max != 100)
> > > > +		ehci_info(ehci, "using non-standard max periodic bandwith "
> > > > +				"(%u%% == %u usec/uframe)",
> > > > +				100*uframe_periodic_max/125, uframe_periodic_max);
> > > > +
> > > > +	/*
> > > 
> > > Check for invalid values.  This should never be less than 100 or 
> > > greater than 125.
> > 
> > Ok. By the way, why should we limit it to be not less than 100?
> > Likewise, a user who knows exactly what he/she is doing could limit
> > periodic bandwidth to be less than 80% required by USB specification.
> 
> What's the point?  If you want to use less than 80% of your bandwidth 
> for periodic transfers, go ahead and do so.  You don't need to change 
> the limit.

I though it would be good for generality -- i.e. if someone wants to
limit maximum isoc bandwidth to say 50% so that would never be
overallocated by that limit that would be handy.

But I agree - it's a bit artificial, so in updated patch I've left what
you originally suggested to be 100 <= uframe_periodic_max < 125 (ommitting =125).


Thanks,
Kirill
