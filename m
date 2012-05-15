Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab2EOEpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 00:45:52 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:46456 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab2EOEpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 00:45:50 -0400
Date: Mon, 14 May 2012 21:45:39 -0700
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org, rjw@sisk.pl,
        nacc@us.ibm.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 5/5] cpusets, suspend: Save and restore cpusets during
 suspend/resume
Message-ID: <20120515044539.GA25256@linux.vnet.ibm.com>
References: <20120513231325.3566.37740.stgit@srivatsabhat>
 <20120513231710.3566.45349.stgit@srivatsabhat>
 <alpine.DEB.2.00.1205141735050.25235@chino.kir.corp.google.com>
 <20120515014042.GA9774@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1205142055160.10906@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205142055160.10906@chino.kir.corp.google.com>
X-Operating-System: Linux 3.2.0-24-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051504-3270-0000-0000-00000657E4A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.05.2012 [21:04:16 -0700], David Rientjes wrote:
> On Mon, 14 May 2012, Nishanth Aravamudan wrote:
> 
> > > I see what you're doing with this and think it will fix the problem that 
> > > you're trying to address, but I think it could become much more general 
> > > to just the suspend case: if an admin sets a cpuset to have cpus 4-6, for 
> > > example, and cpu 5 goes offline, then I believe the cpuset should once 
> > > again become 4-6 if cpu 5 comes back online.  So I think this should be 
> > > implemented like mempolicies are which save the user intended nodemask 
> > > that may become restricted by cpuset placement but will be rebound if the 
> > > cpuset includes the intended nodes.
> > 
> > Heh, please read the thread at
> > http://marc.info/?l=linux-kernel&m=133615922717112&w=2 ... subject is
> > "[PATCH v2 0/7] CPU hotplug, cpusets: Fix issues with cpusets handling
> > upon CPU hotplug". That was effectively the same solution Srivatsa
> > originally posted. But after lengthy discussions with PeterZ and others,
> > it was decided that suspend/resume is a special case where it makes
> > sense to save "policy" but that generally cpu/memory hotplug is a
> > destructive operation and nothing is required to be retained (that
> > certain policies are retained is unfortunately now expected, but isn't
> > guaranteed for cpusets, at least).
> > 
> 
> If you do set_mempolicy(MPOL_BIND, 2-3) to bind a thread to nodes 2-3
> that is attached to a cpuset whereas cpuset.mems == 2-3, and then
> cpuset.mems changes to 0-1, what is the expected behavior?  Do we
> immediately oom on the next allocation?  If cpuset.mems is set again
> to 2-3, what's the desired behavior?

"expected [or desired] behavior" always makes me cringe. It's usually
some insane user-level expectations that don't really make sense :).
But I don't honestly know the answer here as I've not polled any
customers on it. `man cpuset` does provide some insight into the
implementation, though:

	Cpusets  are integrated with the sched_setaffinity(2) scheduling
	affinity mechanism and the mbind(2) and set_mempolicy(2)
	memory-placement mechanisms in the kernel.  Neither of these
	mechanisms let a process make use of a CPU or memory node that
	is not allowed by that process's cpuset.  If changes to a
	process's cpuset placement conflict with these other mechanisms,
	then cpuset placement is enforced even if it means overriding
	these other mechanisms.  The kernel accomplishes this overriding
	by silently restricting the CPUs and memory nodes requested by
	these other mechanisms to those  allowed  by the invoking
	process's cpuset.  This can result in these other calls
	returning an error, if for example, such a call ends up
	requesting an empty set of CPUs or memory nodes, after that
	request is restricted to the invoking process's cpuset.

So no, it should not OOM, but instead the mempolicy is ignored.

> I fixed this problem by introducing MPOL_F_* flags in set_mempolicy(2)
> by saving the user intended nodemask passed by set_mempolicy() and
> respecting it whenever allowed by cpusets.

So, if you read that thread, this is what (in essence) Srivatsa proposed
in v2. We store the user-defined cpumask and keep it regardless of
kernel decisions. We intersect the user-defined cpumask with the kernel
(which is really reflecting the administrator's hotplug decisions)
topology and run tasks in constrained cpusets on the result. We reflect
this decision in a new read-only file in each cpuset that indicates the
"actual" cpus that a task in a given cpuset may be scheduled on.

But PeterZ nack-ed it and his reasoning was sound -- CPU (and memory, I
would think) hotplug is a necessarily destructive behavior.

> Right now, the behavior of what happens for a cpuset where cpuset.cpus == 
> 2-3 and then cpus 2-3 go offline and then are brought back online is 
> undefined.

Erm, no it's rather clearly defined by what actually happens. It may not
be "specified" in a formal document, but behavior is a heckuva thing.

What happens is that the offlining process pushes the tasks in that
constrained cpuset up into the parent cpuset (actually moves them). In a
suspend case, since we're offlining all CPUs, this results in all task
being pushed up to the root cpuset.

I would also quote `man cpuset` here to actually say the behavior is
"specified", technically:

	If hot-plug functionality is used to remove all the CPUs that
	are currently assigned to a cpuset, then the kernel will
	automatically update the cpus_allowed of all processes attached
	to CPUs in that cpuset to allow all CPUs.

The fact that those CPUs are eventually (or immediately) brought back
online is not considered in the decision of how to handle tasks in the
constrained cpuset when the CPUs are taken offline. That seems to make
sense, since there isn't any guarantee that an offlined CPU will ever
return to online status in the future.

> The same is true of cpuset.cpus during resume.  So if you're going to
> add a cpumask to struct cpuset, then why not respect it for all
> offline events and get rid of all this specialized suspend-only stuff?
> It's very simple to make this consistent across all cpu hotplug events
> and build suspend on top of it from a cpuset perspective.

"simple" -- sure. Read v2 of the patchset, as I said. But then read all
the discussion that follows and I think you will see that this has been
hashed out before with similar reasoning on both sides, and that the
policy side of things is not obviously simply. The resulting decision
was to special-case suspend, but not "remember" state across other
hotplug actions, which is more of an "unintentional hotplug" (and from
what Paul McKenney mentions in that thread, sounds like tglx is working
on patches to remove the full hotplug usage from s/r).

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center

