Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab0FCMio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:38:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:42485 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499Ab0FCMim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:38:42 -0400
Date: Thu, 3 Jun 2010 22:38:32 +1000
From: Nick Piggin <npiggin@suse.de>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
       mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
Message-ID: <20100603123832.GL6822@laptop>
References: <20100601162414.GA6191@redhat.com>
 <20100601163807.GA11880@basil.fritz.box>
 <4C053ACC.5020708@redhat.com>
 <20100601172730.GB11880@basil.fritz.box>
 <4C05C722.1010804@redhat.com>
 <20100602085055.GA14221@basil.fritz.box>
 <4C061DAB.6000804@redhat.com>
 <20100603042051.GA5953@linux.vnet.ibm.com>
 <20100603103855.GG6822@laptop>
 <20100603120450.GH4035@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603120450.GH4035@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 05:34:50PM +0530, Srivatsa Vaddagiri wrote:
> On Thu, Jun 03, 2010 at 08:38:55PM +1000, Nick Piggin wrote:
> > > Guest side:
> > > 
> > > static inline void spin_lock(spinlock_t *lock)
> > > {
> > > 	raw_spin_lock(&lock->rlock);
> > > +       __get_cpu_var(gh_vcpu_ptr)->defer_preempt++;
> > > }
> > > 
> > > static inline void spin_unlock(spinlock_t *lock)
> > > {
> > > +	__get_cpu_var(gh_vcpu_ptr)->defer_preempt--;
> > >         raw_spin_unlock(&lock->rlock);
> > > }
> > > 
> > > [similar changes to other spinlock variants]
> > 
> > Great, this is a nice way to improve it.
> > 
> > You might want to consider playing with first taking a ticket, and
> > then if we fail to acquire the lock immediately, then increment
> > defer_preempt before we start spinning.
> >
> > The downside of this would be if we waste all our slice on spinning
> > and then preempted in the critical section. But with ticket locks
> > you can easily see how many entries in the queue in front of you.
> > So you could experiment with starting to defer preempt when we
> > notice we are getting toward the head of the queue.
> 
> Mm - my goal is to avoid long spin times in the first place (because the 
> owning vcpu was descheduled at an unfortunate time i.e while it was holding a
> lock). From that sense, I am targetting preemption-defer of lock *holder*
> rather than of lock acquirer. So ideally whenever somebody tries to grab a lock,
> it should be free most of the time, it can be held only if the owner is
> currently running - which means we won't have to spin too long for the lock.

Holding a ticket in the queue is effectively the same as holding the
lock, from the pov of processes waiting behind.

The difference of course is that CPU cycles do not directly reduce
latency of ticket holders (only the owner). Spinlock critical sections
should tend to be several orders of magnitude shorter than context
switch times. So if you preempt the guy waiting at the head of the
queue, then it's almost as bad as preempting the lock holder.

 
> > Have you also looked at how s390 checks if the owning vcpu is running
> > and if so it spins, if not yields to the hypervisor. Something like
> > turning it into an adaptive lock. This could be applicable as well.
> 
> I don't think even s390 does adaptive spinlocks. Also afaik s390 zVM does gang
> scheduling of vcpus, which reduces the severity of this problem very much -
> essentially lock acquirer/holder are run simultaneously on different cpus all
> the time. Gang scheduling is on my list of things to look at much later
> (although I have been warned that its a scalablility nightmare!).

It effectively is pretty well an adaptive lock. The spinlock itself
doesn't sleep of course, but it yields to the hypervisor if the owner
has been preempted. This is pretty close to analogous with Linux
adaptive mutexes.

s390 also has the diag9c instruction which I suppose somehow boosts
priority of a preempted contended lock holder. In spite of any other
possible optimizations in their hypervisor like gang scheduling,
diag9c apparently provides quite a large improvement in some cases.

And they aren't even using ticket spinlocks!!

So I think these things are fairly important to look at.

