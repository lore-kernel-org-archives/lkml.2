Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab0GNWM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:12:27 -0400
Received: from www.tglx.de ([62.245.132.106]:36616 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757603Ab0GNWMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:12:24 -0400
Date: Thu, 15 Jul 2010 00:12:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
cc: john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: 2.6.33.5 rt23: sleeping function called from invalid context
In-Reply-To: <1279145211.3018.0.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1007150008170.3321@localhost.localdomain>
References: <1278561270.5448.2.camel@localhost.localdomain>  <1278610624.3008.2.camel@localhost.localdomain>  <1278639872.3008.36.camel@localhost.localdomain> <1279145211.3018.0.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010, Fernando Lopez-Lezcano wrote:
> On Thu, 2010-07-08 at 18:44 -0700, john stultz wrote:
> > On Thu, 2010-07-08 at 10:37 -0700, john stultz wrote:
> > > On Wed, 2010-07-07 at 20:54 -0700, Fernando Lopez-Lezcano wrote:
> > > > After a suspend/wake up cycle, just after upgrading to fc12 (I did not
> > > > see this with the same basic kernel - that is, compiled from the same
> > > > source + patches - under fc11). 
> > > > 
> > > > BUG: sleeping function called from invalid context at
> > > > kernel/rtmutex.c:684
> > > > pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 10582, name:
> > > > pm-suspend
> > > > Pid: 10582, comm: pm-suspend Not tainted
> > > > 2.6.33.5-120.rt23.1.fc11.ccrma.i686.rtPAE #1
> > > > Call Trace:
> > > > [<c042eced>] __might_sleep+0xcc/0xd4
> > > > [<c0464f57>] rt_spin_lock_fastlock.clone.1+0x26/0x5f
> > > > [<c0792862>] rt_spin_lock+0x8/0xa
> > > > [<c040dddc>] read_persistent_clock+0x11/0x30
> > > > [<c045d1de>] timekeeping_suspend+0xe/0x4e
> > > > [<c0640c9e>] sysdev_suspend+0x15c/0x356
> > > > [<c0792906>] ? _mutex_unlock+0x8/0xa
> > > > [<c046afc1>] suspend_devices_and_enter+0xea/0x17f
> > > 
> > > Huh. Looks like the lock protecting the RTC/CMOS might need to be
> > > converted to a raw spinlock, since suspend/resume is probably done with
> > > irqs off.
> > 
> > Oof. The rtc_lock is used all over the place. Not sure if we really want
> > to convert it to a raw_spinlock. 
> > 
> > However, sysdev_suspend() wants interrupts off on all the .suspend
> > calls. I'm surprised we haven't hit this issue with more drivers. Maybe
> > no one is testing suspend w/ -rt? Or am I just missing an obvious
> > solution?
> >
> > Thomas, any thoughts on this? 

Yep, it's basically the same scenario which we have during bootup
where we know that we cannot run into lock contention, so we can apply
the same rules. Still working on a sane solution for this.
 
> (BTW, this is still happening in rt26...)

See announce mail :)

> There are some pending issues:
> - rtc_lock suspend/resume (working on a patch)
> ...

Thanks,

	tglx
