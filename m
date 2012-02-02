Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab2BBPZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 10:25:19 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:60359 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab2BBPZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 10:25:16 -0500
Date: Thu, 2 Feb 2012 07:23:35 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, arjanvandeven@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: clean up smpboot.c's use of udelay+schedule
Message-ID: <20120202152334.GA2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120130205304.0e10b05e@infradead.org>
 <20120131124341.GC4408@elte.hu>
 <1328014076.2446.210.camel@twins>
 <20120131125331.GE4408@elte.hu>
 <1328014916.2446.217.camel@twins>
 <20120202003357.GP2382@linux.vnet.ibm.com>
 <4F2A4361.2020404@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2A4361.2020404@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020215-6148-0000-0000-0000031A0C61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 01:33:45PM +0530, Srivatsa S. Bhat wrote:
> On 02/02/2012 06:03 AM, Paul E. McKenney wrote:
> > On Tue, Jan 31, 2012 at 02:01:56PM +0100, Peter Zijlstra wrote:
> >> On Tue, 2012-01-31 at 13:53 +0100, Ingo Molnar wrote:
> >>> Wanna give a short TODO list to anyone wanting to work on that?
> >>
> >> I paged out most details again, but it goes something like:
> >>
> >>  - read and understand the current generic code
> >>
> >>  - and all architecture code, at which point you'll probably boggle
> >>    at all the similarities that are all subtly different (there's
> >>    about 3 actually different ways in the arch code).
> >>
> >>  - pick one, preferably one that keeps additional state and doesn't
> >>    fully rely on the online bits and pull it into generic code and
> >>    provide a small vector of arch specific functions.
> >>
> >>  - convert all archs over.
> >>
> >>
> >> Also related:
> >>
> >>  - figure out why cpu_down needs kstopmachine, I'm not sure it does..
> >>    we should be able to tear down a cpu using synchronize_sched() and a
> >>    single stop_one_cpu(). (someday when there's time I might actually
> >>    try to implement this).
> > 
> > Currently, a number of the CPU_DYING notifiers assume that they are
> > running in stop-machine context, including those of RCU.
> > 
> > However, this is not an inherent property of RCU -- DYNIX/ptx's
> > CPU-offline process did not stop the whole machine, after all, and RCU
> > (we called it rclock, but whatever) was happy with this arrangement.
> > In fact, if the outgoing CPU could be made to stop in that context
> > instead of returning to the scheduler and the idle loop, it would make
> > my life a bit easier.
> > 
> > My question is why aren't the notifiers executed in the opposite
> > order going down and coming up, with the coming-up order matching the
> > boot order?  Also, why can't the CPU's exit from this world be driven
> > out of the idle loop?  That way, the CPU wouldn't mark itself offline
> > (thus in theory to be ignored by CPU), and then immediately dive into
> > the scheduler and who knows what all else, using RCU all the time.  ;-)
> > 
> > (RCU handles this by keeping a separate set of books for online CPUs.
> > It considers a CPU online at CPU_UP_PREPARE time, and doesn't consider
> > it offline until CPU_DEAD time.  To handle the grace periods between,
> > force_quiescent_state() allows the grace period to run a few jiffies
> > before checking cpu_online_map, which allows a given CPU to safely use
> > RCU for at least one jiffy before marking itself online and for at least
> > one jiffy after marking itself offline.)
> > 
> > Yet another question is about races between CPU-hotplug events and
> > registering/unregistering cpu notifiers.  I don't believe that the
> > current code does what you would like in all cases.
> 
> I beg to differ here. There is no race between CPU-hotplug and registering
> or unregistering of cpu notifiers. The pair cpu_maps_update_begin() and
> cpu_maps_update_done() is supposed to take care of that right?

Yes, the integrity of the list itself is guaranteed.

Unless I am missing something, cpu_maps_update_begin() does not cover
invocation of all of the notifiers (and for good reason).  One way to
handle this is to register your notifier early at boot time, so that
it cannot race with a group of notifications (which is what RCU does).
If your code is in a module and needs to track the currently online
CPUs, you might be in for a surprise.  ;-)

							Thanx, Paul

> > The only way
> > I can imagine it really working would be to use generation numbers,
> > so that once a CPU-hotplug event started, it would invoke only those
> > notifiers marked with the generation that was in effect when the
> > event started, or with some earlier generation.
> > 
> 
> 
> Regards,
> Srivatsa S. Bhat
> IBM Linux Technology Center

