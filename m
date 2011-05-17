Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab1EQOYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 10:24:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697Ab1EQOYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 10:24:47 -0400
Date: Tue, 17 May 2011 10:24:27 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        huang ying <huang.ying.caritas@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
Message-ID: <20110517142427.GL31888@redhat.com>
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com>
 <4DCD4B85.3040702@gmail.com>
 <BANLkTin7LNo0dDLs-Rz6WqCQ9RvS=MLXcw@mail.gmail.com>
 <4DCE3493.4090404@gmail.com>
 <BANLkTin1pvdnXtw53MhwfCsEQpsu0TUUmg@mail.gmail.com>
 <4DCF7413.4070704@gmail.com>
 <4DD07959.4030608@intel.com>
 <20110516190310.GH31888@redhat.com>
 <4DD20A2F.604@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD20A2F.604@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 01:39:59PM +0800, Huang Ying wrote:
> On 05/17/2011 03:03 AM, Don Zickus wrote:
> > On Mon, May 16, 2011 at 09:09:45AM +0800, Huang Ying wrote:
> >>>   Ying, the concern is rather related to the code scheme in general. Since
> >>> we have notifiers I think the better way to be consistent here and use
> >>> hwerr notifier too. But it's IMHO ;)
> >>
> >> As for go notifiers or not.  IMHO, a rule can be:
> >>
> >> - If it is something like a driver, than it should go notifier
> >> - If it is architectural/PC defacto standard, it can sit outside of
> >> notifier.
> > 
> > Hmm, then what do you do about perf?  That is architectural and a defacto
> > standard, but I am not sure hardcoding that would be appropriate.
> 
> Yes.  perf is architectural, so its source is not put into drivers
> directory.  And I think it is a good idea to put perf NMI handler call
> directly into system NMI handler instead of a notifier chain.  Unknown
> NMI as HW error is far more smaller than perf.  So it can be put into
> system NMI handler directly.
> 
> >> I think that seeing unknown NMI as hardware error should be part of PC
> >> defacto standard.  Do you think so?
> > 
> > Well after thinking about it, I would say no.  And my reason is, if
> > vendors are really serious about using NMIs as an indicator for hardware
> > errors, shouldn't they be setting a bit in the memory controller/north
> > bridge or south bridge/IOHC for an NMI handler to read?  I mean hardware
> > devices don't just get wired directly to the NMI pin on the cpu, right?
> > They generally have to go through some hub that acts as a multiplexer.
> > 
> > In those cases, why can't those hubs set a bit saying it detected an error
> > (don't PCIe bridges already do that?) and let the NMI handler read it to
> > confirm.  This way we can leave 'unknown NMIs' as a way to say an
> > unclaimed NMI entered the system and we can have users set policy about
> > what to do, panic, printk, whatever.
> > 
> > But for the HEST stuff, it should be smart enough by now to trap any
> > hardware error, no?  How does a machine that supports HEST let a hardware
> > error get through without detecting it?  Isn't that the point?  Detect a
> > hardware error, grab as much info about it as possible, save the error
> > record and then panic?
> > 
> > Otherwise if you just panic, then you have no idea why the machine errored
> > in the first place.  It might be the safe thing to do in some
> > circumstances, but then you have to wonder why the fancy HEST enabled
> > server didn't catch it.  Isn't that what people are spending extra money
> > for those Intel servers with RAS features?
> 
> All you said is possible in theory.  But as far as I know, Windows
> thinks unknown NMI is for hardware error and displays blue scrren for

Right, because as I was told, Windows don't use NMI for anything else.
Linux uses it for perf, hw breakpoints, kdump, watchdog, etc.

> it.  So some hardware OEMs use unknown NMI to report hardware error.

Yes, I know one of those OEMs and had to restructure the NMI code to
accomodate them.

> Even on machines with HEST, there may be no GHES record (just unknown
> NMI) if Windows does not tell BIOS that it has support for GHES.

Ok, that's fine, but doesn't Linux tell the BIOS it supports GHES?  Also
what would be the point of implementing HEST in your firmware if all it
does is just pass the error along to the NMI?

Ok, so I am naive and am just learning that the ACPI spec is just
'guidelines' for how stuff should work (and people rarely follow it), but
I find it hard to believe that OEMs would implement HEST as just an error
pass-through.  Isn't the point of HEST trying to _determine_ what the error is?
Otherwise why bother.

Can we agree on this, that if an OEM implemented HEST properly such that a
hardware error happens it will generate a GHES record.  The subsequent NMI
that follows will find that GHES record and properly panic.

If the OEM can't implement HEST properly and instead just sends the NMI
with no GHES record, how much should we care?

Cheers,
Don


Cheers,
Don
