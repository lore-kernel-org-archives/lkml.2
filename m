Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903Ab0FCKjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 06:39:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:39513 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933859Ab0FCKjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 06:39:00 -0400
Date: Thu, 3 Jun 2010 20:38:55 +1000
From: Nick Piggin <npiggin@suse.de>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
       mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
Message-ID: <20100603103855.GG6822@laptop>
References: <20100601093515.GH24302@redhat.com>
 <87sk56ycka.fsf@basil.nowhere.org>
 <20100601162414.GA6191@redhat.com>
 <20100601163807.GA11880@basil.fritz.box>
 <4C053ACC.5020708@redhat.com>
 <20100601172730.GB11880@basil.fritz.box>
 <4C05C722.1010804@redhat.com>
 <20100602085055.GA14221@basil.fritz.box>
 <4C061DAB.6000804@redhat.com>
 <20100603042051.GA5953@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603042051.GA5953@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 09:50:51AM +0530, Srivatsa Vaddagiri wrote:
> On Wed, Jun 02, 2010 at 12:00:27PM +0300, Avi Kivity wrote:
> > 
> > There are two separate problems: the more general problem is that
> > the hypervisor can put a vcpu to sleep while holding a lock, causing
> > other vcpus to spin until the end of their time slice.  This can
> > only be addressed with hypervisor help.
> 
> Fyi - I have a early patch ready to address this issue. Basically I am using
> host-kernel memory (mmap'ed into guest as io-memory via ivshmem driver) to hint 
> host whenever guest is in spin-lock'ed section, which is read by host scheduler 
> to defer preemption.
> 
> Guest side:
> 
> static inline void spin_lock(spinlock_t *lock)
> {
> 	raw_spin_lock(&lock->rlock);
> +       __get_cpu_var(gh_vcpu_ptr)->defer_preempt++;
> }
> 
> static inline void spin_unlock(spinlock_t *lock)
> {
> +	__get_cpu_var(gh_vcpu_ptr)->defer_preempt--;
>         raw_spin_unlock(&lock->rlock);
> }
> 
> [similar changes to other spinlock variants]

Great, this is a nice way to improve it.

You might want to consider playing with first taking a ticket, and
then if we fail to acquire the lock immediately, then increment
defer_preempt before we start spinning.

The downside of this would be if we waste all our slice on spinning
and then preempted in the critical section. But with ticket locks
you can easily see how many entries in the queue in front of you.
So you could experiment with starting to defer preempt when we
notice we are getting toward the head of the queue.

Have you also looked at how s390 checks if the owning vcpu is running
and if so it spins, if not yields to the hypervisor. Something like
turning it into an adaptive lock. This could be applicable as well.

