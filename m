Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966724Ab2EOULP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 16:11:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56206 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966091Ab2EOULN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 16:11:13 -0400
Message-ID: <1337112653.27694.110.camel@twins>
Subject: Re: [PATCH v3 5/5] cpusets, suspend: Save and restore cpusets
 during suspend/resume
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Rientjes <rientjes@google.com>
Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        mingo@kernel.org, pjt@google.com, paul@paulmenage.org,
        akpm@linux-foundation.org, rjw@sisk.pl, nacc@us.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Date: Tue, 15 May 2012 22:10:53 +0200
In-Reply-To: <alpine.DEB.2.00.1205151106490.24304@chino.kir.corp.google.com>
References: <20120513231325.3566.37740.stgit@srivatsabhat>
	 <20120513231710.3566.45349.stgit@srivatsabhat>
	 <alpine.DEB.2.00.1205141735050.25235@chino.kir.corp.google.com>
	 <20120515014042.GA9774@linux.vnet.ibm.com>
	 <alpine.DEB.2.00.1205142055160.10906@chino.kir.corp.google.com>
	 <20120515044539.GA25256@linux.vnet.ibm.com>
	 <alpine.DEB.2.00.1205151106490.24304@chino.kir.corp.google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 11:31 -0700, David Rientjes wrote:

> However, if a thread did set_mempolicy(MPOL_BIND, 2-3) where cpuset.mems 
> == node_online_map, cpuset.mems changes to 0-1, then cpuset.mems changes 
> back to node_online_map, then I believe (and implemented in the mempolicy 
> code and added the specification in the man page) that the thread should 
> be bound to nodes 2-3.

I disagree, but alas that is done :-(

But what happens if you unplug nodes 2-3?

> > > I fixed this problem by introducing MPOL_F_* flags in set_mempolicy(2)
> > > by saving the user intended nodemask passed by set_mempolicy() and
> > > respecting it whenever allowed by cpusets.
> > 
> > So, if you read that thread, this is what (in essence) Srivatsa proposed
> > in v2. We store the user-defined cpumask and keep it regardless of
> > kernel decisions. We intersect the user-defined cpumask with the kernel
> > (which is really reflecting the administrator's hotplug decisions)
> > topology and run tasks in constrained cpusets on the result. We reflect
> > this decision in a new read-only file in each cpuset that indicates the
> > "actual" cpus that a task in a given cpuset may be scheduled on.
> > 
> 
> I don't think we need a new read-only file that exposes the stored 
> cpumask, I think it should be stored and respected when possible and the 
> set of allowed cpus be exported in the way it always has been, through 
> cpuset.cpus.

I agree we don't want the new file, I'm not sure what you mean with the
rest though.

> If a cpuset is defined to have cpuset.cpus == 2-3, cpu 3 is offlined, and 
> then cpu 3 is onlined, the behavior is currently undefined.  

Uhm, its documented to not restore 3. And changing this at this point
seems pointless, it doesn't solve Srivatsa's problem and is otherwise
pointless churn.

> You could 
> make the argument that cpusets is purely about NUMA and that cpu 3 may no 
> longer have affinity to cpuset.mems in which case I would agree that we 
> should not reset cpuset.cpus to 2-3 in this case.  But that doesn't seem 
> to be the motivation here because we keep talking about suspend.

The problem is that if you have some cpusets configuration and then do a
s/r cycle the entire configuration is wrecked because suspend
hot-unplugs all but cpu0 and resume re-plugs the cpus.

This destroys all masks and migrates all tasks in sets not including
cpu0 to the root set.

Srivatsa proposed to 'fix' this by remembering state of regular hotplug,
to which I strongly oppose, hotplug is destructive and should be,
there's no point in remembering state that might never be used again.
Worse you temporarily 'break' your cpuset 'promise' to then silently
restore it.

The s/r resume case is special in that userspace isn't actually around
to observe the cpus going away and coming back, also it has the
guarantee the cpus will be coming back.

So s/r is special and should not destroy state, hotplug should.
