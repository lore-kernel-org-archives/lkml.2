Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab0DPPEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 11:04:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901Ab0DPPEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 11:04:22 -0400
Date: Fri, 16 Apr 2010 11:04:07 -0400
From: Don Zickus <dzickus@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100416150407.GH15159@redhat.com>
References: <1271366710-17468-1-git-send-email-dzickus@redhat.com>
 <20100416014712.GC15570@nowhere>
 <20100416141213.GC15159@redhat.com>
 <20100416144302.GB5162@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100416144302.GB5162@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 04:43:04PM +0200, Frederic Weisbecker wrote:
> On Fri, Apr 16, 2010 at 10:12:13AM -0400, Don Zickus wrote:
> > On Fri, Apr 16, 2010 at 03:47:14AM +0200, Frederic Weisbecker wrote:
> > > >  config PERF_EVENTS_NMI
> > > >  	bool
> > > > +	depends on PERF_EVENTS
> > > >  	help
> > > >  	  Arch has support for nmi_watchdog
> > > 
> > > 
> > > 
> > > That looks too general. It's more about the fact the arch supports
> > > cpu cycle events and generates NMIs on overflow.
> > 
> > I was trying to figure out a way to add the PERF_EVENTS dependency as I
> > didn't want to impose it on the CONFIG_NMI_WATCHDOG if that config
> > supported softlockup (which doesn't need the PERF_EVENTS).
> 
> 
> 
> Yeah and this is fine. I was talking about the help description.

Oh. heh.  ok, will expand that.

> 
> 
>  
> > > I'm confused, do we have two versions of the softlockup
> > > detector now? You should drop the older one.
> > 
> > Originally Ingo talked about a migration path, so I was going to support
> > the older one in case the new one was having issues, sort of like what he
> > suggested about moving the nmi code from arch/x86/kernel/apic/nmi.c to
> > kernel/watchdog.c.  But I can probably drop the softlockup case as the
> > migration isn't as tricky as the nmi case.
> 
> 
> 
> Ok.
> 
> > > > +		return;
> > > > +	}
> > > > +
> > > > +	cpumask_clear_cpu(this_cpu, to_cpumask(hardlockup_mask));
> > > 
> > > 
> > > 
> > > Hmm...this is probably not necessary.
> > 
> > I was just thinking of the case where dispite the WARN above, the cpu
> > actually recovered and then failed again separately.  But I probably won't
> > spend anymore time defending it. :-)
> 
> 
> 
> This is really just a corner case, I guess you don't need to
> bother with that. It is actually racy against other cpus and adding
> a spinlock here (in the everything is fine path) would be an overkill.
> 
> In fact, having two per cpu vars named hardlockup_warned and
> softlockup_warned would be better than cpumasks. I'm sorry I
> suggested you the cpumask, but such per cpu vars will avoid
> you dealing with these synchonization issues. And one of the primary
> rules is usually to never take a lock from NMIs if we can :)

Yeah, I guess per cpu is better.  I agree that locks in NMI are frowned
upon but I wasn't sure of it was dealt with.

I'll try to implement this.  Any objections if I combined hardlockup and
softlockup with per cpu watchdog_warn and have bit masks for HARDLOCKUP
and SOFTLOCKUP?  I hate to just waste per cpu space for this.

> 
> 
>  
> > > You probably want a backtrace cpu mask here as well
> > > (but better don't use the same than the hardlockup thing)
> > 
> > yup.
> 
> 
> So actually, per_cpu softlockup_warned would be better :)
> 
> 
> > > Also you should half-drop the DETECT_SOFTLOCKUP thing:
> > > keep it's definition but drop the ability to choose it from
> > > the prompt:
> > > 
> > > config DETECT_SOFTLOCKUP
> > > 	bool
> > > 	depends on DEBUG_KERNEL && !S390
> > > 	default y
> > > 
> > > This way we keep it for compatibility with def_configs, it will
> > > enable the WATCHDOG by default if it is "y", we can schedule
> > > its removal later.
>  
> > I understand the general idea but not quite the implementation idea.  I will work
> > on it and see what I come up with.
> 
> 
> We current have:
> 
> config DETECT_SOFTLOCKUP
>      bool "Blah"
>      depends on DEBUG_KERNEL && !S390
>      default y
>      help
>        .......
> 
> The idea is to remove the "Blah" so that the user can't select it
> anymore from make menuconfig, and to remove the help too as it's useless
> too.
> 
> So that config WATCHDOG can be default y if DETECT_SOFTLOCKUP.
> Then if someone comes with a config that has DETECT_SOFTLOCKUP,
> it's new implementation (WATCHDOG) will enabled by default.

Ah, I missed the bool part.  I got it.  Thanks for the clarification.

Cheers,
Don

> 
