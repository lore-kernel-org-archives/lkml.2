Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0G1OsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:48:03 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35983 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab0G1Or7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:47:59 -0400
Date: Wed, 28 Jul 2010 20:17:04 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: avi@redhat.com, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        npiggin@suse.de, kvm@vger.kernel.org, bharata@in.ibm.com,
        Balbir Singh <balbir@in.ibm.com>, Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH RFC 0/4] Paravirt-spinlock implementation for KVM
 guests (Version 0)
Message-ID: <20100728144704.GA27739@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20100726061150.GB21699@linux.vnet.ibm.com>
 <4C4DC382.5010004@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4DC382.5010004@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 10:18:58AM -0700, Jeremy Fitzhardinge wrote:
> >I tried to refactor Xen's spinlock
> >implementation to make it common for both Xen and KVM - but found that
> >few differences between Xen and KVM (Xen has the ability to block on a
> >particular event/irq for example) _and_ the fact that the guest kernel
> >can be compiled to support both Xen and KVM hypervisors (CONFIG_XEN and
> >CONFIG_KVM_GUEST can both be turned on) makes the "common" code a eye-sore.
> >There will have to be:
> >
> >	if (xen) {
> >		...
> >	} else if (kvm) {
> >		..
> >	}
> >
> >or possibly:
> >
> >	alternative(NOP, some_xen_specific_call, ....)
> >
> >type of code in the common implementation.
> 
> No, that doesn't look like a good approach.  It suggests the
> apparently commonality isn't really there.
> 
> >For the time-being, I have made this KVM-specific only. At somepoint in future,
> >I hope this can be made common between Xen/KVM.
> 
> Did you see the patch series I posted a couple of weeks ago to
> revamp pv spinlocks?  Specifically, I dropped the notion of pv
> spinlocks in which the entire spinlock implementation is replaced,
> and added pv ticketlocks where the ticketlock algorithm is always
> used for the fastpath, but it calls out to pvop calls for the
> slowpath (a long spin, or unlocking a lock with waiters).  It
> significantly reduces the amount of hypervisor-specific code.

Hmmm interesting - I will go thr' it in detail.

> You can see the current patches in
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git
>    xen/pvticketlock-git

[snip]

> That's not actually the real problem.  It's *a* problem, but
> insignificant compared to the ticketlock-specific "next-in-line vcpu
> scheduler bunfight" problem - lock holder preemption is a misnomer.
> Fortunately the solutions to both are (nearly) the same.
>
> See Thomas Friebel's talk "Prevent Guests from Spinning Around
> (http://www.xen.org/files/xensummitboston08/LHP.pdf).

Yes I had seen Thomas's slides reporting huge degradation in performance with
tick spinlock.

> >b. Avoid preempting a lock-holder while its holding a (spin-) lock.
> >
> >    In this scheme, guest OS can hint (set some flag in memory shared with
> >    hypervisor) whenever its holding a lock and hypervisor could defer preempting
> >    the guest vcpu when its holding a lock.  With this scheme, we should never
> >    have a lock-acquiring vcpu spin on a preempted vcpu to release its lock. If
> >    ever it spins, its because somebody *currently running* is holding the lock -
> >    and hence it won't have to spin-wait too long. IOW we are pro-actively
> >    trying to prevent the LHP problem from occuring in the first place. This
> >    should improve job turnaround time for some workloads. [1] has some
> >    results based on this approach.
> 
> This doesn't actually help the problem mentioned above, because it's
> not a problem with the lock holder getting preempted, but what
> happens once the lock has been released.

Good point. I agree that the latter problem needs more attention, given a
ticket-type implementation of spinlocks. Have you considered possible solutions
for unmodified guests, which have similar ticket-type lock implementations? 
Not sure if that's important enough to investigate solutions like gang 
scheduling ..

- vatsa

