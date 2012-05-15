Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966250Ab2EOSbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:31:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54360 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932894Ab2EOSbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:31:23 -0400
Date: Tue, 15 May 2012 11:31:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org, rjw@sisk.pl,
        nacc@us.ibm.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 5/5] cpusets, suspend: Save and restore cpusets during
 suspend/resume
In-Reply-To: <20120515044539.GA25256@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1205151106490.24304@chino.kir.corp.google.com>
References: <20120513231325.3566.37740.stgit@srivatsabhat> <20120513231710.3566.45349.stgit@srivatsabhat> <alpine.DEB.2.00.1205141735050.25235@chino.kir.corp.google.com> <20120515014042.GA9774@linux.vnet.ibm.com> <alpine.DEB.2.00.1205142055160.10906@chino.kir.corp.google.com>
 <20120515044539.GA25256@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012, Nishanth Aravamudan wrote:

> > If you do set_mempolicy(MPOL_BIND, 2-3) to bind a thread to nodes 2-3
> > that is attached to a cpuset whereas cpuset.mems == 2-3, and then
> > cpuset.mems changes to 0-1, what is the expected behavior?  Do we
> > immediately oom on the next allocation?  If cpuset.mems is set again
> > to 2-3, what's the desired behavior?
> 
> "expected [or desired] behavior" always makes me cringe. It's usually
> some insane user-level expectations that don't really make sense :).

Yeah, and I think we should be moving in a direction where this behavior 
is defined so that nobody can expert anything else.

> 	Cpusets  are integrated with the sched_setaffinity(2) scheduling
> 	affinity mechanism and the mbind(2) and set_mempolicy(2)
> 	memory-placement mechanisms in the kernel.  Neither of these
> 	mechanisms let a process make use of a CPU or memory node that
> 	is not allowed by that process's cpuset.  If changes to a
> 	process's cpuset placement conflict with these other mechanisms,
> 	then cpuset placement is enforced even if it means overriding
> 	these other mechanisms.

This makes perfect sense because an admin wants to be able to move the 
cpuset placement of a thread regardless of whether that thread did 
sched_setaffinity() or mbind() itself so that it is running on a set of 
isolated nodes that have affinity to its cpus.  I agree that cpusets 
should always take precedent.

However, if a thread did set_mempolicy(MPOL_BIND, 2-3) where cpuset.mems 
== node_online_map, cpuset.mems changes to 0-1, then cpuset.mems changes 
back to node_online_map, then I believe (and implemented in the mempolicy 
code and added the specification in the man page) that the thread should 
be bound to nodes 2-3.

> > I fixed this problem by introducing MPOL_F_* flags in set_mempolicy(2)
> > by saving the user intended nodemask passed by set_mempolicy() and
> > respecting it whenever allowed by cpusets.
> 
> So, if you read that thread, this is what (in essence) Srivatsa proposed
> in v2. We store the user-defined cpumask and keep it regardless of
> kernel decisions. We intersect the user-defined cpumask with the kernel
> (which is really reflecting the administrator's hotplug decisions)
> topology and run tasks in constrained cpusets on the result. We reflect
> this decision in a new read-only file in each cpuset that indicates the
> "actual" cpus that a task in a given cpuset may be scheduled on.
> 

I don't think we need a new read-only file that exposes the stored 
cpumask, I think it should be stored and respected when possible and the 
set of allowed cpus be exported in the way it always has been, through 
cpuset.cpus.

> But PeterZ nack-ed it and his reasoning was sound -- CPU (and memory, I
> would think) hotplug is a necessarily destructive behavior.
> 

>From a thread perspective, how is hot-removing a node different from 
clearing the node's bit in cpuset.mems?

How is hot-adding a node different from setting the node's bit in 
cpuset.mems?

> > Right now, the behavior of what happens for a cpuset where cpuset.cpus == 
> > 2-3 and then cpus 2-3 go offline and then are brought back online is 
> > undefined.
> 
> Erm, no it's rather clearly defined by what actually happens. It may not
> be "specified" in a formal document, but behavior is a heckuva thing.
> 

"Undefined" in the sense that there's no formal specification for what the 
behavior is; of course it has a current behavior just like gcc compiles 
1-bit int fields to be signed although its behavior is undefined.  You'll 
be defining the behavior with this patchset.

> What happens is that the offlining process pushes the tasks in that
> constrained cpuset up into the parent cpuset (actually moves them). In a
> suspend case, since we're offlining all CPUs, this results in all task
> being pushed up to the root cpuset.
> 
> I would also quote `man cpuset` here to actually say the behavior is
> "specified", technically:
> 
> 	If hot-plug functionality is used to remove all the CPUs that
> 	are currently assigned to a cpuset, then the kernel will
> 	automatically update the cpus_allowed of all processes attached
> 	to CPUs in that cpuset to allow all CPUs.
> 

Right, and that's consistent because the root cpuset requires all cpus.

> > The same is true of cpuset.cpus during resume.  So if you're going to
> > add a cpumask to struct cpuset, then why not respect it for all
> > offline events and get rid of all this specialized suspend-only stuff?
> > It's very simple to make this consistent across all cpu hotplug events
> > and build suspend on top of it from a cpuset perspective.
> 
> "simple" -- sure. Read v2 of the patchset, as I said. But then read all
> the discussion that follows and I think you will see that this has been
> hashed out before with similar reasoning on both sides, and that the
> policy side of things is not obviously simply. The resulting decision
> was to special-case suspend, but not "remember" state across other
> hotplug actions, which is more of an "unintentional hotplug" (and from
> what Paul McKenney mentions in that thread, sounds like tglx is working
> on patches to remove the full hotplug usage from s/r).
> 

We're talking about two very different things.  The suspend case is 
special in this regard _only_ because it moves all threads to the root 
cpuset and obviously you can't have a user-specified cpumask for the root 
cpuset.  That's irrelevant to my question about why we aren't storing the 
user-specified cpumask in all non-root cpusets, which certainly remains 
consistent even with suspend since these non-root cpusets cease to exist.

If a cpuset is defined to have cpuset.cpus == 2-3, cpu 3 is offlined, and 
then cpu 3 is onlined, the behavior is currently undefined.  You could 
make the argument that cpusets is purely about NUMA and that cpu 3 may no 
longer have affinity to cpuset.mems in which case I would agree that we 
should not reset cpuset.cpus to 2-3 in this case.  But that doesn't seem 
to be the motivation here because we keep talking about suspend.
