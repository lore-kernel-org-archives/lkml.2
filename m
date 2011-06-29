Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab1F2SFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 14:05:06 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:34701 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755987Ab1F2SFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 14:05:03 -0400
Date: Wed, 29 Jun 2011 22:03:59 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: matt mooney <mfm@muteddisk.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] USB: EHCI: Move sysfs related bits into
	ehci-sysfs.c
Message-ID: <20110629180359.GA12511@tugrik.mns.mnsspb.ru>
References: <20110629164027.GA8552@tugrik.mns.mnsspb.ru> <Pine.LNX.4.44L0.1106291333440.2064-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1106291333440.2064-100000@iolanthe.rowland.org>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 01:35:04PM -0400, Alan Stern wrote:
> On Wed, 29 Jun 2011, Kirill Smelkov wrote:
> 
> > > Also, when decreasing the schedule limit, do you think it is really 
> > > necessary to check that the current allocation doesn't exceed the new 
> > > limit?  I think it would be sufficient to apply the new limit just to 
> > > new bandwidth allocation requests.  After all, this API is meant for 
> > > experts only.
> > 
> > I think yes, it is needed. E.g. because there is this check in
> > periodic_usecs():
> > 
> > #ifdef  DEBUG
> >         if (usecs > ehci->uframe_periodic_max)
> >                 ehci_err (ehci, "uframe %d sched overrun: %d usecs\n",
> >                         frame * 8 + uframe, usecs);
> > #endif
> >         return usecs;
> > }
> > 
> > and periodic_usecs() is called in e.g. this chain:
> > 
> >     itd_submit
> >     iso_stream_schedule
> >     itd_slot_ok
> >     periodic_usecs
> > 
> > and others.
> 
> That won't matter unless DEBUG is defined.

Yes, but still it would be good to always keep the invariant

    allocated <= uframe_periodic_max

and that debug is there to catch when this breaks.


> > I'd leave this check as is - to me it would be useful in debug mode to
> > verify that we've not overallocated a period.
> > 
> > Also, even if this knob would be useful only to experts, it would be
> > better to put feedback onto the knob so that people could know whether
> > thir request could be served or not.
> > 
> > What do you think?
> 
> Can you make that check conditional on DEBUG being set?

Yes I can, but it seems to me we are starting to complicate the code.

What's the problem with returning error on setting uframe_periodic_max <
already allocated usb bandwith?


Kirill


P.S.

The checking is not a priority for me here, so if you think it's better not
to check or do it under #ifdef - let's do it. Though of course we all
have our preferences :)
