Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932910Ab2AMU6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 15:58:48 -0500
Received: from mail4.comsite.net ([205.238.176.238]:48740 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab2AMU6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 15:58:45 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=70.249.75.62;
From: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH 2/2] mm: page allocator: Do not drain per-cpu lists via
  IPI from page allocator context
To: Mel Gorman <mgorman@suse.de>, Gilad Ben-Yossef <gilad@benyossef.com>
Cc: <linux-kernel@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-Id: <no-drain-reply@mdm.bga.com>
In-Reply-To: <20120112171847.GN4118@suse.de>
References: <1326276668-19932-1-git-send-email-mgorman@suse.de>
	<1326276668-19932-3-git-send-email-mgorman@suse.de>
	<1326381492.2442.188.camel@twins>
	<20120112153712.GL4118@suse.de>
	<1326383551.2442.203.camel@twins>
	<20120112171847.GN4118@suse.de>
Date: Fri, 13 Jan 2012 14:58:39 -0600
X-Originating-IP: 70.249.75.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu Jan 12 2012 about 12:18:59 EST, Mel Gorman wrote:
> On Thu, Jan 12, 2012 at 04:52:31PM +0100, Peter Zijlstra wrote:
> > On Thu, 2012-01-12 at 15:37 +0000, Mel Gorman wrote:
> > > On Thu, Jan 12, 2012 at 04:18:12PM +0100, Peter Zijlstra wrote:
> > > > On Wed, 2012-01-11 at 10:11 +0000, Mel Gorman wrote:
> > > > > At least one bug report has
> > > > > been seen on ppc64 against a 3.0 era kernel that looked like a bug
> > > > > receiving interrupts on a CPU being offlined.
> > > >
> > > > Got details on that Mel? The preempt_disable() in on_each_cpu() should
> > > > serialize against the stop_machine() crap in unplug.
> > >
> > > I might have added 2 and 2 together and got 5.
> > >
> > > The stack trace clearly was while sending IPIs in on_each_cpu() and
> > > always when under memory pressure and stuck in direct reclaim. This was
> > > on !PREEMPT kernels where preempt_disable() is a no-op. That is why I
> > > thought get_online_cpu() would be necessary.

Well, stop_machine has to be selected by the scheduler, so we have to
get back and call schedule() at some point to switch to that thread.
.. unless it is the one allocating memory.

> >
> > For non-preempt the required scheduling of stop_machine() will have to
> > wait even longer. Still there might be something funny, some of the
> > hotplug notifiers are ran before the stop_machine thing does its thing
> > so there might be some fun interaction.
> 
> Ok, how about this as a replacement patch?
> 
> ---8<---
> From: Mel Gorman <mgorman@xxxxxxx>
> Subject: [PATCH] mm: page allocator: Do not drain per-cpu lists via IPI from page allocator context
> 
> While running a CPU hotplug stress test under memory pressure, it
> was observed that the machine would halt with no messages logged
> to console. This is difficult to trigger and required a machine
> with 8 cores and plenty of memory. In at least one case on ppc64,
> the warning in include/linux/cpumask.h:107 triggered implying that
> IPIs are being sent to offline CPUs in some cases.

That is
        WARN_ON_ONCE(cpu >= nr_cpumask_bits);

That has nothing to do with cpus going offline!

nr_cpumask_bits is set during boot based on cpu_possible_mask.  If you
see that triggered its a direct bug in the caller.  Either its looking
at random memory in a NR_CPUS loop or its assuming that there is
another cpu in a mask and not checking for a cpu_mask_next returning
nr_cpumask_bits.

Again it has nothing to do with hotplug (unless its assuming there are
n online cpus in a loop instead of looking at the return value of
the function).


> 
> A suspicious part of the problem is that the page allocator is sending
> IPIs using on_each_cpu() without calling get_online_cpus() to prevent
> changes to the online cpumask. It is depending on preemption being
> disabled to protect it which is a no-op on !PREEMPT kernels. This means
> that a thread can be reading the mask in smp_call_function_many() when
> an attempt is made to take a CPU offline. The expectation is that this
> is not a problem as the stop_machine() used during CPU hotplug should
> be able to prevent any problems as the reader of the online mask will
> prevent stop_machine making forward progress but it's unhelpful.

And without CONFIG_PREEMPT, we won't be able to schedule away from the
current task over to the stop_machine (migration/NN) thread.

> 
> On the other side, the mask can also be read while the CPU is being
> brought online. In this case it is the responsibility of the
> architecture that the CPU is able to receive and handle interrupts
> before being marked active but that does not mean they always get it
> right.

yes.  See my other reply for some things we can to to help find bugs
with smp_call_function_many (and on_each_cpu).

> 
> Sending excessive IPIs from the page allocator is a bad idea. In low
> memory situations, a large number of processes can drain the per-cpu
> lists at the same time, in quick succession and on many CPUs which is
> pointless. In light of this and the unspecific CPU hotplug concerns,
> this patch removes the call drain_all_pages() after failing direct
> reclaim. To avoid impacting high-order allocation success rates,
> it still drains the local per-cpu lists for high-order allocations
> that failed.

"There is some bug somewhere.  This seems like a big slow pain I
don't think this is likely to have much impact but if I am wrong we
will just OOM early."  vs Gilad's "Lets reduce the pain of this slow
path by doing just the required work".

Lets find the real bug.

milton
