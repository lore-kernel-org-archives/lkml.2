Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab0LGVde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 16:33:34 -0500
Received: from kroah.org ([198.145.64.141]:52781 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676Ab0LGVdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 16:33:32 -0500
Date: Tue, 7 Dec 2010 13:32:41 -0800
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Frank Blaschka <frank.blaschka@de.ibm.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Christof Schmitt <christof.schmitt@de.ibm.com>,
        Horst Hartmann <horsth@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [stable] [patch 2/3] nohz: fix printk_needs_cpu() return value
 on offline cpus
Message-ID: <20101207213241.GL14849@kroah.com>
References: <20101126120057.879397696@de.ibm.com>
 <20101126120235.406766476@de.ibm.com>
 <1290773512.2145.139.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290773512.2145.139.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 01:11:52PM +0100, Peter Zijlstra wrote:
> On Fri, 2010-11-26 at 13:00 +0100, Heiko Carstens wrote:
> > plain text document attachment (002_printk_needs_cpu.diff)
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > 
> > This patch fixes a hang observed with 2.6.32 kernels where timers got
> > enqueued on offline cpus.
> > 
> > printk_needs_cpu() may return 1 if called on offline cpus. When a cpu gets
> > offlined it schedules the idle process which, before killing its own cpu,
> > will call tick_nohz_stop_sched_tick().
> > That function in turn will call printk_needs_cpu() in order to check if the
> > local tick can be disabled. On offline cpus this function should naturally
> > return 0 since regardless if the tick gets disabled or not the cpu will be
> > dead short after. That is besides the fact that __cpu_disable() should already
> > have made sure that no interrupts on the offlined cpu will be delivered anyway.
> > 
> > In this case it prevents tick_nohz_stop_sched_tick() to call
> > select_nohz_load_balancer(). No idea if that really is a problem. However what
> > made me debug this is that on 2.6.32 the function get_nohz_load_balancer() is
> > used within __mod_timer() to select a cpu on which a timer gets enqueued.
> > If printk_needs_cpu() returns 1 then the nohz_load_balancer cpu doesn't get
> > updated when a cpu gets offlined. It may contain the cpu number of an offline
> > cpu. In turn timers get enqueued on an offline cpu and not very surprisingly
> > they never expire and cause system hangs.
> > 
> > This has been observed 2.6.32 kernels. On current kernels __mod_timer() uses
> > get_nohz_timer_target() which doesn't have that problem. However there might
> > be other problems because of the too early exit tick_nohz_stop_sched_tick()
> > in case a cpu goes offline.
> > 
> > Easiest way to fix this is just to test if the current cpu is offline and
> > call printk_tick() directly which clears the condition.
> > 
> > Alternatively I tried a cpu hotplug notifier which would clear the condition,
> > however between calling the notifier function and printk_needs_cpu() something
> > could have called printk() again and the problem is back again. This seems to
> > be the safest fix.
> > 
> > Cc: stable@kernel.org
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> > ---
> >  kernel/printk.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > --- a/kernel/printk.c
> > +++ b/kernel/printk.c
> > @@ -1082,6 +1082,8 @@ void printk_tick(void)
> >  
> >  int printk_needs_cpu(int cpu)
> >  {
> > +	if (unlikely(cpu_is_offline(cpu)))
> > +		printk_tick();
> >  	return per_cpu(printk_pending, cpu);
> >  }
> >  
> 
> Nice,.. applied.

Is this going to make it into .37, or is it going to wait until .38?

thanks,

greg k-h
