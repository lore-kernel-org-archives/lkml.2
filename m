Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087Ab0JUCb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 22:31:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756926Ab0JUCb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 22:31:56 -0400
Date: Wed, 20 Oct 2010 22:31:35 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        "peterz@infradead.org" <peterz@infradead.org>
Subject: Re: [PATCH -v3 5/6] x86, NMI, treat unknown NMI as hardware error
Message-ID: <20101021023135.GA12086@redhat.com>
References: <1286606987-19879-1-git-send-email-ying.huang@intel.com>
 <1286606987-19879-5-git-send-email-ying.huang@intel.com>
 <20101011212006.GB23882@redhat.com>
 <1287555157.3026.21.camel@yhuang-dev>
 <20101020141558.GB19090@redhat.com>
 <1287623643.19320.40.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287623643.19320.40.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 09:14:03AM +0800, Huang Ying wrote:
> > > DIE_NMI_IPI case. I think the code added is for general unknown NMI
> > > processing instead of a device driver. What we do is not to add special
> > > processing for some devices, but treat unknown NMI as hardware error
> > > notification in general and use a white list to deal with broken
> > > hardware and stone age machine. Do you agree?
> > > 
> > > If so, it should not be turned into a notifier block unless you want to
> > > turn all general unknown NMI processing code into a notifier block.
> > 
> > Well, yes I actually do, mainly to keep the code simpler.  But also, after
> > having a conversation with someone yesterday, realized that unknown NMIs
> > are dealt with on a platform level and not a chipset level.
> 
> But there is some general rules for unknown NMI. We think unknown NMI is
> hardware error notification on all systems except systems with broken
> hardware or software bugs, stone age machines. Do you agree with that?

Nope.  In my experiences, most of our customers are still running
pre-Nehalem boxes, therefore most unknown NMIs are from broken hardware or
bad firmware (at least in the bugzillas I deal with).

I would be excited if I was getting some sort of hardware error
notification, because then I would know where the NMI might be coming
from.  Instead, I have customers pull out cards out of their machine or
instrument their kernel to see which device is causing the problem.  Slow
and painful.

> 
> > The reason I say that is some companies, like HP, have a special driver
> > hpwdt that they want to run in the case of an unknown NMI.  They don't
> > care about HEST or the other stuff, they want their BIOS call to take care
> > of it.  So now that hack has to be put into notifier somewhere.
> 
> Yes. I found that during NMI handler development. It sits in a notifier
> chain and in a driver. hpwdt uses unknown NMI for watchdog timeout
> notification, it is a platform feature and should be implemented in a

Actually no it doesn't, the name HP watchdog is deceiving.  The intent HP
has with that handler is any unknown NMI needs to be trapped by that
driver so it can do an SMI call, which tries to source the NMI and save
its result in NVRAM.  Then it jumps back to the kernel for a reboot.

I have been dealing with HP for 3 years with that driver, I have gotten
quite familiar with the NMI part of it. :-)

> driver. But we want to implement a general default unknown NMI
> processing logic, not do that for some specific platform or chipset.
> 
> > I can only imagine Dell trying to do something similar as a value add.
> > 
> > To me it just makes sense to setup all the HEST stuff as default notifier
> > blocks and then have platform specific drivers register on top of them
> > (using the priority scheme).  This to me gives everyone flexibility on how
> > to handle the unknown NMIs.
> 
> Yes. HEST code will be in a driver and will register a notifier block to
> do its work.
> 
> > Thoughts?
> 
> But the code in this patch is not for HEST. (HEST is only used to
> implement the white list). I think the code is for a general standard
> feature. I don't want to add HEST processing here.
> 
> Do you think it should be a general rule to treat all unknown NMI as
> hardware error notification except some broken hardware and stone age
> machines?

I guess my impression of what unknown NMIs should do might be a little
different than yours (not saying my view is a correct one, just the view I
have when I answer your questions).

(after spending more time thinking about this while looking at nmi
priorities)

I thought anything that registers with a notifier and cases off of
DIE_NMI, should be a driver/subsystem that expects and _can properly
handle_ an NMI.  The expectation is that it can successfully detect the
NMI is its own and return a NOTIFY_STOP if it is (after processing it).
[I excluded DIE_NMI_IPI because of PeterZ's comments]

Whereas DIE_NMIUNKNOWN would be for drivers/subsystem that can probably
detect the NMI is its own but can't do anything but panic or drivers that
don't know but want to handle the panic in their own special way (ie
hpwdt, or sgi's x2apic_uv_x.c where they like to use nmi_buttons to debug
stalls or hangs but don't want to panic).

And if noone wants to attempt to handle it after that, then call
unknown_nmi_error() (minus the notify_die(DIE_NMIUNKNOWN)).

So to me hardware error notification, would just detect what chipset it is
on and if it is something that matches its whitelist, register and use
DIE_NMIUNKNOWN.  unknown_nmi_error() would just continue to be this
general and vague thing that on more modern systems will likely never be
called.

Anyway that is how I viewed everything or how I wouldn't mind seeing it
implemented.  Then again, my view could be completely wrong.  :-)

I'll just rely on majority concensus on somebody's view.

Cheers,
Don

