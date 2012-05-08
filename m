Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab2EHQQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:16:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60215 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab2EHQQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:16:39 -0400
Message-ID: <1336493768.8226.29.camel@twins>
Subject: Re: [PATCH 07/41] cpuset: Set up interface for nohz flag
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 08 May 2012 18:16:08 +0200
In-Reply-To: <alpine.DEB.2.00.1205081054310.27713@router.home>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
	 <1335830115-14335-8-git-send-email-fweisbec@gmail.com>
	 <alpine.DEB.2.00.1205071053070.1060@router.home>
	 <CAFTL4hymuHZOGssX2UShg0kL-XkCKQYtG6X=Vt9PmKj4EwtAgA@mail.gmail.com>
	 <1336488626.16236.41.camel@twins>
	 <alpine.DEB.2.00.1205081016370.27713@router.home>
	 <1336490832.8226.5.camel@twins>
	 <alpine.DEB.2.00.1205081035550.27713@router.home>
	 <1336492081.8226.13.camel@twins>
	 <alpine.DEB.2.00.1205081054310.27713@router.home>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 10:57 -0500, Christoph Lameter wrote:
> On Tue, 8 May 2012, Peter Zijlstra wrote:
> 
> > > For some reason this seems to work here. What is broken with isolcpus?
> >
> > It mostly still works I think, but iirc there were a few places that
> > ignored the cpuisol mask.
> 
> Yes there is still superfluous stuff going on on isolated processors.

Aside from that..

> > But really the moment we get proper means of flushing cpu state
> > (currently achievable by unplug-replug) isolcpu gets depricated and
> > eventually removed.
> 
> Not sure what that means and how that is relevant. Scheduler?

Things like stray timers, an unplug-replug cycle will push all timers
away. So if you create a partition with cpus that have ran other tasks
but in the future will be dedicated to this 'special' task, you need to
flush all these things.

This is currently only possible through the unplug-replug hack.

For isolcpus this usually isn't a problem since the cpus will be idle
until you start something on them. But if you were to change workloads
you could run into this.

> > cpusets can do what isolcpu can and more (provided this flush thing).
> 
> cpusets is a pretty heavy handed thing and causes inefficiencies in the
> allocators if compiled into the kernel because checks will have to be done
> in hot allocation paths.

Should we then re-implement those bits using mpols? Thereby avoiding
duplicate mask operations?

> > > > Furthermore there is no other partitioning scheme, cpusets is it.
> > >
> > > One can partition the system anyway one wants by setting cpu affinities
> > > and memory policies etc. No need for cpusets/cgroups.
> >
> > Not so, the load-balancer will still try to move the tasks and
> > subsequently fail. Partitioning means it won't even try to move tasks
> > across the partition boundary.
> 
> Ok so the scheduler is inefficient on this. Maybe that can be improved?

No, it simply doesn't (and cannot) know this.. well it could but I think
its an NP-hard problem. The way its been solved is by means of explicit
configuration using cpusets.

> Setting affinities should not cause overhead in the scheduler.

To the contrary, it must. It makes the placement problem harder. It adds
constraints to an otherwise uniform problem.

> > By proper partitioning you can split load balance domains (or completely
> > disable the load-balancer by giving it a single cpu domain).
> 
> I thought that was the point of isolcpus?

I have the same problem with isolcpus that you seem to have with the
cpuset stuff on the allocator paths.

isolcpus is a very limited hack that adds more pain that its worth. Its
yet another mask to check and its functionality is completely available
through cpusets.

You cannot create multi-cpu partitions using isolcpus, you cannot
dynamically reconfigure it.

And on the scheduler side cpusets doesn't add runtime overhead to normal
things, only sched_setaffinity() and a few other rare operations get
slightly more expensive. And it allows to reduce runtime overhead by
making the load-balancer domains smaller.

All wins in my book.
