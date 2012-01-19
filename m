Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab2ASQVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:21:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45459 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932526Ab2ASQVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:21:02 -0500
Date: Thu, 19 Jan 2012 16:20:57 +0000
From: Mel Gorman <mgorman@suse.de>
To: Milton Miller <miltonm@bga.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/2] mm: page allocator: Do not drain per-cpu lists via
 IPI from page allocator context
Message-ID: <20120119162057.GD3143@suse.de>
References: <1326276668-19932-1-git-send-email-mgorman@suse.de>
 <1326276668-19932-3-git-send-email-mgorman@suse.de>
 <1326381492.2442.188.camel@twins>
 <20120112153712.GL4118@suse.de>
 <1326383551.2442.203.camel@twins>
 <20120112171847.GN4118@suse.de>
 <no-drain-reply@mdm.bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <no-drain-reply@mdm.bga.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 02:58:39PM -0600, Milton Miller wrote:
> > > > The stack trace clearly was while sending IPIs in on_each_cpu() and
> > > > always when under memory pressure and stuck in direct reclaim. This was
> > > > on !PREEMPT kernels where preempt_disable() is a no-op. That is why I
> > > > thought get_online_cpu() would be necessary.
> 
> Well, stop_machine has to be selected by the scheduler, so we have to
> get back and call schedule() at some point to switch to that thread.
> .. unless it is the one allocating memory.
> 
> > >
> > > For non-preempt the required scheduling of stop_machine() will have to
> > > wait even longer. Still there might be something funny, some of the
> > > hotplug notifiers are ran before the stop_machine thing does its thing
> > > so there might be some fun interaction.
> > 
> > Ok, how about this as a replacement patch?
> > 
> > ---8<---
> > From: Mel Gorman <mgorman@xxxxxxx>
> > Subject: [PATCH] mm: page allocator: Do not drain per-cpu lists via IPI from page allocator context
> > 
> > While running a CPU hotplug stress test under memory pressure, it
> > was observed that the machine would halt with no messages logged
> > to console. This is difficult to trigger and required a machine
> > with 8 cores and plenty of memory. In at least one case on ppc64,
> > the warning in include/linux/cpumask.h:107 triggered implying that
> > IPIs are being sent to offline CPUs in some cases.
> 
> That is
>         WARN_ON_ONCE(cpu >= nr_cpumask_bits);
> 
> That has nothing to do with cpus going offline!
> 

You're right. This particular warning was caused by xmon starting
up while it was handling another exception. There was not enough
information in the bug to tell exactly what caused the original
exception. A CPU was being offlined at the time and the system was
under memory pressure but they are not necessarily related. I'll drop
this from the changelog.

> nr_cpumask_bits is set during boot based on cpu_possible_mask.  If you
> see that triggered its a direct bug in the caller.  Either its looking
> at random memory in a NR_CPUS loop or its assuming that there is
> another cpu in a mask and not checking for a cpu_mask_next returning
> nr_cpumask_bits.
> 
> Again it has nothing to do with hotplug (unless its assuming there are
> n online cpus in a loop instead of looking at the return value of
> the function).
> 

xmon does some funny things around num_online_cpus() but tracking
down the internals of xmon is not useful. A more serious problem had
already triggered if xmon was starting at all.

> > A suspicious part of the problem is that the page allocator is sending
> > IPIs using on_each_cpu() without calling get_online_cpus() to prevent
> > changes to the online cpumask. It is depending on preemption being
> > disabled to protect it which is a no-op on !PREEMPT kernels. This means
> > that a thread can be reading the mask in smp_call_function_many() when
> > an attempt is made to take a CPU offline. The expectation is that this
> > is not a problem as the stop_machine() used during CPU hotplug should
> > be able to prevent any problems as the reader of the online mask will
> > prevent stop_machine making forward progress but it's unhelpful.
> 
> And without CONFIG_PREEMPT, we won't be able to schedule away from the
> current task over to the stop_machine (migration/NN) thread.
> 

On a different x86-64 machines with an intel-specific MCE, I have
also noted that the value of num_online_cpus() can change while
stop_machine() is running. This is sensitive to timing and part of
the problem seems to be due to cmci_rediscover() running without the
CPU hotplug mutex held. This is not related to the IPI mess and is
unrelated to memory pressure but is just to note that CPU hotplug in
general can be fragile in parts.

> > On the other side, the mask can also be read while the CPU is being
> > brought online. In this case it is the responsibility of the
> > architecture that the CPU is able to receive and handle interrupts
> > before being marked active but that does not mean they always get it
> > right.
> 
> yes.  See my other reply for some things we can to to help find bugs
> with smp_call_function_many (and on_each_cpu).
> 

Thanks for that.

> > Sending excessive IPIs from the page allocator is a bad idea. In low
> > memory situations, a large number of processes can drain the per-cpu
> > lists at the same time, in quick succession and on many CPUs which is
> > pointless. In light of this and the unspecific CPU hotplug concerns,
> > this patch removes the call drain_all_pages() after failing direct
> > reclaim. To avoid impacting high-order allocation success rates,
> > it still drains the local per-cpu lists for high-order allocations
> > that failed.
> 
> "There is some bug somewhere.  This seems like a big slow pain I
> don't think this is likely to have much impact but if I am wrong we
> will just OOM early."  vs Gilad's "Lets reduce the pain of this slow
> path by doing just the required work".
> 
> Lets find the real bug.
> 

When the underlying bug related to IPIs is isolated and fixed,
the patch still made sense. As noted in the changelog of the latest
version, high-order allocations are still draining the local list to
minimise impact. For order-0 allocations failing in this situation,
we must be already on the min watermark obviously. For an IPI to
help avoid an OOM for an order-0 allocation, we would need enough
pages on the per-cpu lists to meet the watermark with no other
allocation/freeing activity on those CPUs and that the process trying
to allocate memory never gets scheduled on another CPU. This is a
very improbable combination of events which is why I don't think the
patch makes any difference to going OOM early.

-- 
Mel Gorman
SUSE Labs
