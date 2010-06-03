Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab0FCMFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:05:11 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53316 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab0FCMFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:05:09 -0400
Date: Thu, 3 Jun 2010 17:34:50 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Avi Kivity <avi@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
       mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
Message-ID: <20100603120450.GH4035@linux.vnet.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <87sk56ycka.fsf@basil.nowhere.org>
 <20100601162414.GA6191@redhat.com>
 <20100601163807.GA11880@basil.fritz.box>
 <4C053ACC.5020708@redhat.com>
 <20100601172730.GB11880@basil.fritz.box>
 <4C05C722.1010804@redhat.com>
 <20100602085055.GA14221@basil.fritz.box>
 <4C061DAB.6000804@redhat.com>
 <20100603042051.GA5953@linux.vnet.ibm.com>
 <20100603103855.GG6822@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603103855.GG6822@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 08:38:55PM +1000, Nick Piggin wrote:
> > Guest side:
> > 
> > static inline void spin_lock(spinlock_t *lock)
> > {
> > 	raw_spin_lock(&lock->rlock);
> > +       __get_cpu_var(gh_vcpu_ptr)->defer_preempt++;
> > }
> > 
> > static inline void spin_unlock(spinlock_t *lock)
> > {
> > +	__get_cpu_var(gh_vcpu_ptr)->defer_preempt--;
> >         raw_spin_unlock(&lock->rlock);
> > }
> > 
> > [similar changes to other spinlock variants]
> 
> Great, this is a nice way to improve it.
> 
> You might want to consider playing with first taking a ticket, and
> then if we fail to acquire the lock immediately, then increment
> defer_preempt before we start spinning.
>
> The downside of this would be if we waste all our slice on spinning
> and then preempted in the critical section. But with ticket locks
> you can easily see how many entries in the queue in front of you.
> So you could experiment with starting to defer preempt when we
> notice we are getting toward the head of the queue.

Mm - my goal is to avoid long spin times in the first place (because the 
owning vcpu was descheduled at an unfortunate time i.e while it was holding a
lock). From that sense, I am targetting preemption-defer of lock *holder*
rather than of lock acquirer. So ideally whenever somebody tries to grab a lock,
it should be free most of the time, it can be held only if the owner is
currently running - which means we won't have to spin too long for the lock.

> Have you also looked at how s390 checks if the owning vcpu is running
> and if so it spins, if not yields to the hypervisor. Something like
> turning it into an adaptive lock. This could be applicable as well.

I don't think even s390 does adaptive spinlocks. Also afaik s390 zVM does gang
scheduling of vcpus, which reduces the severity of this problem very much -
essentially lock acquirer/holder are run simultaneously on different cpus all
the time. Gang scheduling is on my list of things to look at much later
(although I have been warned that its a scalablility nightmare!).

- vatsa
