Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459Ab0JUOKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:10:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757441Ab0JUOK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:10:29 -0400
Date: Thu, 21 Oct 2010 10:10:02 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        "peterz@infradead.org" <peterz@infradead.org>
Subject: Re: [PATCH -v3 5/6] x86, NMI, treat unknown NMI as hardware error
Message-ID: <20101021141002.GI19090@redhat.com>
References: <1286606987-19879-1-git-send-email-ying.huang@intel.com>
 <1286606987-19879-5-git-send-email-ying.huang@intel.com>
 <20101011212006.GB23882@redhat.com>
 <1287555157.3026.21.camel@yhuang-dev>
 <20101020141558.GB19090@redhat.com>
 <1287623643.19320.40.camel@yhuang-dev>
 <20101021023135.GA12086@redhat.com>
 <1287638251.19320.190.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287638251.19320.190.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 01:17:31PM +0800, Huang Ying wrote:
> > > But there is some general rules for unknown NMI. We think unknown NMI is
> > > hardware error notification on all systems except systems with broken
> > > hardware or software bugs, stone age machines. Do you agree with that?
> > 
> > Nope.  In my experiences, most of our customers are still running
> > pre-Nehalem boxes, therefore most unknown NMIs are from broken hardware or
> > bad firmware (at least in the bugzillas I deal with).
> 
> It seems that we have different point of view for reason of unknown NMI.
> Should broken hardware be seen as hardware error?

Well, do you have an alternative way to handle broken hardware?  Broken
hardware has generated NMIs, sometimes if I am lucky SERRs.  The ones that
generate SERRs can be filtered through a different path, but what about
the ones that don't?

I understand you are trying to make a distinction between the two, but I
don't understand how you plan on handling the different scenarios.  That's
probably part of my confusion.

> 
> As far as I know, Windows treat unknown NMI as hardware errors. Although
> we are programming for Linux not Windows. Many hardware are built for
> Windows.

I was told Windows treats _any_ NMI as hardware errors, not just unknown
ones. :-)

> 
> > I would be excited if I was getting some sort of hardware error
> > notification, because then I would know where the NMI might be coming
> > from.  Instead, I have customers pull out cards out of their machine or
> > instrument their kernel to see which device is causing the problem.  Slow
> > and painful.
> 
> Hope new machine will have better hardware error reporting. :)

Me too.

<snip>

> > > 
> > > But the code in this patch is not for HEST. (HEST is only used to
> > > implement the white list). I think the code is for a general standard
> > > feature. I don't want to add HEST processing here.
> > > 
> > > Do you think it should be a general rule to treat all unknown NMI as
> > > hardware error notification except some broken hardware and stone age
> > > machines?
> > 
> > I guess my impression of what unknown NMIs should do might be a little
> > different than yours (not saying my view is a correct one, just the view I
> > have when I answer your questions).
> 
> Yes. I think so too. The reply following is my understanding for that.
> My understanding may be not correct too. :)
> 
> > (after spending more time thinking about this while looking at nmi
> > priorities)
> > 
> > I thought anything that registers with a notifier and cases off of
> > DIE_NMI, should be a driver/subsystem that expects and _can properly
> > handle_ an NMI.  The expectation is that it can successfully detect the
> > NMI is its own and return a NOTIFY_STOP if it is (after processing it).
> > [I excluded DIE_NMI_IPI because of PeterZ's comments]
> 
> I think notifier registered on DIE_NMI can panic too. Why prevent it?

True, I guess as long as the handler can determine the NMI is its own, I
can't see why not (/me realizes that is what the nmi watchdog does :-) ).

> 
> > Whereas DIE_NMIUNKNOWN would be for drivers/subsystem that can probably
> > detect the NMI is its own but can't do anything but panic or drivers that
> > don't know but want to handle the panic in their own special way (ie
> > hpwdt, or sgi's x2apic_uv_x.c where they like to use nmi_buttons to debug
> > stalls or hangs but don't want to panic).
> 
> I think drivers want to handle the unknown NMI in their own special way
> are the expected users of DIE_NMIUNKNOWN. While drivers that can detect
> the NMI is its own and will go panic should be registered on DIE_NMI.

Ok.  I can agree with this.

> 
> > And if noone wants to attempt to handle it after that, then call
> > unknown_nmi_error() (minus the notify_die(DIE_NMIUNKNOWN)).
> 
> I think unknown_nmi_error() (minus the notify_die(DIE_NMIUNKNOWN) is the
> general default operation for unknown NMI. DIE_NMIUNKNOWN is for drivers
> processing after determining the NMI is unknown and before the general
> default operation.

Yes.

> 
> > So to me hardware error notification, would just detect what chipset it is
> > on and if it is something that matches its whitelist, register and use
> > DIE_NMIUNKNOWN.  unknown_nmi_error() would just continue to be this
> > general and vague thing that on more modern systems will likely never be
> > called.
> 
> The difference between us is that I think it should be a general rule to
> treat unknown NMI as hardware error notification, while you think it
> should be in a driver for some special hardware. That is, it is general
> or special?

Probably.  I guess I don't fully understand your definition of hardware
error notification so I can't tell if we are arguing or agreeing (but
using different words).

How do you envision the code looking like with hardware error
notification?

I just wanted to keep the code in traps.c simple and clean and not
constantly add new #ifdefs every time Intel came up with an interesting
way to determine a hardware error condition.

For example, I am not the biggest fan of seeing stuff like edac or mce
inside the code and would prefer them to use notifiers.  But that is just
my opinion.

If you have a framework that you wanted to propose that could encapsulate
an ever growing class of hardware error notifications, I would be
interested.

Anyway, perhaps providing some examples about what you had in mind and how
it would scale going forward might help me understand what you are looking
to do.

Cheers,
Don

