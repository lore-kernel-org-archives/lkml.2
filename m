Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab1AMD0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 22:26:17 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:43185 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932641Ab1AMD0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 22:26:16 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+3S1JOeFq360Ve/IEKtHYjGN7STn0U4qAXM/fAvg
	aTEBecAt16wM2H
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
From: Mike Galbraith <efault@gmx.de>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <4D2E6B62.2000802@redhat.com>
References: <20110103162637.29f23c40@annuminas.surriel.com>
	 <20110103162918.577a9620@annuminas.surriel.com>
	 <1294164289.2016.186.camel@laptop>
	 <1294246647.8369.52.camel@marge.simson.net>
	 <1294247065.2016.267.camel@laptop>
	 <1294378146.8823.27.camel@marge.simson.net>  <4D2E6B62.2000802@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 04:26:09 +0100
Message-ID: <1294889169.8089.10.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-12 at 22:02 -0500, Rik van Riel wrote:

> Cgroups only makes the matter worse - libvirt places
> each KVM guest into its own cgroup, so a VCPU will
> generally always be alone on its own per-cgroup, per-cpu
> runqueue!  That can lead to pulling a VCPU onto our local
> CPU because we think we are alone, when in reality we
> share the CPU with others...

How can that happen?  If the task you're trying to accelerate isn't in
your task group, the whole attempt should be a noop.

> Removing the pulling code allows me to use all 4
> CPUs with a 4-VCPU KVM guest in an uncontended situation.
> 
> > +	/* Tell the scheduler that we'd really like pse to run next. */
> > +	p_cfs_rq->next = pse;
> 
> Using set_next_buddy propagates this up to the root,
> allowing the scheduler to actually know who we want to
> run next when cgroups is involved.
> 
> > +	/* We know whether we want to preempt or not, but are we allowed? */
> > +	if (preempt&&  same_thread_group(p, task_of(p_cfs_rq->curr)))
> > +		resched_task(task_of(p_cfs_rq->curr));
> 
> With this in place, we can get into the situation where
> we will gladly give up CPU time, but not actually give
> any to the other VCPUs in our guest.
> 
> I believe we can get rid of that test, because pick_next_entity
> already makes sure it ignores ->next if picking ->next would
> lead to unfairness.

Preempting everybody who is in your way isn't playing nice neighbor, so
I think at least the same_thread_group() test needs to stay.  But that's
Peter's call.  Starting a zillion threads to play wakeup preempt and
lets hog the cpu isn't nice either, but it's allowed.

> Removing this test (and simplifying yield_to_task_fair) seems
> to lead to more predictable test results.

Less is more :)

	-Mike

