Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab0FCM6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:58:51 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45813 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0FCM6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:58:49 -0400
Date: Thu, 3 Jun 2010 18:28:21 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Avi Kivity <avi@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
       mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
Message-ID: <20100603125821.GJ4035@linux.vnet.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20100601163807.GA11880@basil.fritz.box>
 <4C053ACC.5020708@redhat.com>
 <20100601172730.GB11880@basil.fritz.box>
 <4C05C722.1010804@redhat.com>
 <20100602085055.GA14221@basil.fritz.box>
 <4C061DAB.6000804@redhat.com>
 <20100603042051.GA5953@linux.vnet.ibm.com>
 <20100603103855.GG6822@laptop>
 <20100603120450.GH4035@linux.vnet.ibm.com>
 <20100603123832.GL6822@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603123832.GL6822@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 10:38:32PM +1000, Nick Piggin wrote:
> Holding a ticket in the queue is effectively the same as holding the
> lock, from the pov of processes waiting behind.
> 
> The difference of course is that CPU cycles do not directly reduce
> latency of ticket holders (only the owner). Spinlock critical sections
> should tend to be several orders of magnitude shorter than context
> switch times. So if you preempt the guy waiting at the head of the
> queue, then it's almost as bad as preempting the lock holder.

Ok got it - although that approach is not advisable in some cases for ex: when
the lock holder vcpu and lock acquired vcpu are scheduled on the same pcpu by
the hypervisor (which was experimented with in [1] where they foud a huge hit in
perf).

I agree that in general we should look at deferring preemption of lock 
acquirer esp when its at "head" as you suggest - I will consider that approach
as the next step (want to incrementally progress basically!).

> > > Have you also looked at how s390 checks if the owning vcpu is running
> > > and if so it spins, if not yields to the hypervisor. Something like
> > > turning it into an adaptive lock. This could be applicable as well.
> > 
> > I don't think even s390 does adaptive spinlocks. Also afaik s390 zVM does gang
> > scheduling of vcpus, which reduces the severity of this problem very much -
> > essentially lock acquirer/holder are run simultaneously on different cpus all
> > the time. Gang scheduling is on my list of things to look at much later
> > (although I have been warned that its a scalablility nightmare!).
> 
> It effectively is pretty well an adaptive lock. The spinlock itself
> doesn't sleep of course, but it yields to the hypervisor if the owner
> has been preempted. This is pretty close to analogous with Linux adaptive mutexes.

Oops you are right - sorry should have checked more closely earlier. Given that
we may not be able to always guarantee that locked critical sections will not be
preempted (ex: when a real-time task takes over), we will need a combination of 
both approaches (i.e request preemption defer on lock hold path + yield on lock 
acquire path if owner !scheduled). The advantage of former approach is that it
could reduce job turnaround times in most cases (as lock is available when we 
want or we don't have to wait too long for it).

> s390 also has the diag9c instruction which I suppose somehow boosts
> priority of a preempted contended lock holder. In spite of any other
> possible optimizations in their hypervisor like gang scheduling,
> diag9c apparently provides quite a large improvement in some cases.

Ok - thx for that pointer - will have a look at diag9c.

> So I think these things are fairly important to look at.

I agree ..

- vatsa
