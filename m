Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab1F2Qld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 12:41:33 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:33514 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147Ab1F2Qlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 12:41:31 -0400
Date: Wed, 29 Jun 2011 20:40:27 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: matt mooney <mfm@muteddisk.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] USB: EHCI: Move sysfs related bits into
	ehci-sysfs.c
Message-ID: <20110629164027.GA8552@tugrik.mns.mnsspb.ru>
References: <20110629092001.GC10219@tugrik.mns.mnsspb.ru> <Pine.LNX.4.44L0.1106291100360.2064-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1106291100360.2064-100000@iolanthe.rowland.org>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 11:23:11AM -0400, Alan Stern wrote:
> On Wed, 29 Jun 2011, Kirill Smelkov wrote:
> 
> > > Apart from that one issue,
> > > 
> > > Acked-off-by: Alan Stern <stern@rowland.harvard.edu>
> > 
> > Thanks.
> > 
> > What should we do with this patch now? Should I put
> > 
> > 
> >     Copyright (C) 2007 by Alan Stern
> > 
> > there? Or something else?
> 
> Yes, put that in.
> 
> > Or maybe drop that copyright notice altogether becase usually it gets
> > outdated very quickly, and who made what is visible through git
> > log/blame?
> 
> Copyright information is important, and it must be present in the 
> actual file -- not somewhere else (such as a changelog).

Ok, I've put that in.

> > I'm ok with any case, please just tell me how to proceed.
> > 
> > 
> > And what about main "[PATCH v2 2/2] USB: EHCI: Allow users to override
> > 80% max periodic bandwidth"?
> > 
> > Was it Acked together with this one, or not and review is pending?
> > Curious because I'm new here...
> 
> I haven't taken the time to review it yet, sorry...

Nevermind, I've just pinged.


> Mostly it looks okay.  In store_uframe_periodic_max(), you can use 
> kstrtouint() instead of sscanf() -- that seems to be the trend these 
> days.

Thanks for the advice - changed to kstrtouint (which as it turned out,
with base=0 can read oct/hex/dec data as specified by user).


> Also, when decreasing the schedule limit, do you think it is really 
> necessary to check that the current allocation doesn't exceed the new 
> limit?  I think it would be sufficient to apply the new limit just to 
> new bandwidth allocation requests.  After all, this API is meant for 
> experts only.

I think yes, it is needed. E.g. because there is this check in
periodic_usecs():

#ifdef  DEBUG
        if (usecs > ehci->uframe_periodic_max)
                ehci_err (ehci, "uframe %d sched overrun: %d usecs\n",
                        frame * 8 + uframe, usecs);
#endif
        return usecs;
}

and periodic_usecs() is called in e.g. this chain:

    itd_submit
    iso_stream_schedule
    itd_slot_ok
    periodic_usecs

and others.


I'd leave this check as is - to me it would be useful in debug mode to
verify that we've not overallocated a period.

Also, even if this knob would be useful only to experts, it would be
better to put feedback onto the knob so that people could know whether
thir request could be served or not.

What do you think?


Kirill
