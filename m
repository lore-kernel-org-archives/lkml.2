Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab0GZRTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 13:19:03 -0400
Received: from claw.goop.org ([74.207.240.146]:49498 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065Ab0GZRS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 13:18:59 -0400
Message-ID: <4C4DC382.5010004@goop.org>
Date: Mon, 26 Jul 2010 10:18:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: avi@redhat.com, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        npiggin@suse.de, kvm@vger.kernel.org, bharata@in.ibm.com,
        Balbir Singh <balbir@in.ibm.com>, Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH RFC 0/4] Paravirt-spinlock implementation for KVM guests
 (Version 0)
References: <20100726061150.GB21699@linux.vnet.ibm.com>
In-Reply-To: <20100726061150.GB21699@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/25/2010 11:11 PM, Srivatsa Vaddagiri wrote:
> This patch-series implements paravirt-spinlock implementation for KVM guests,
> based heavily on Xen's implementation.

Excellent!  I think this problem has been ignored for too long.

> I tried to refactor Xen's spinlock
> implementation to make it common for both Xen and KVM - but found that
> few differences between Xen and KVM (Xen has the ability to block on a
> particular event/irq for example) _and_ the fact that the guest kernel
> can be compiled to support both Xen and KVM hypervisors (CONFIG_XEN and
> CONFIG_KVM_GUEST can both be turned on) makes the "common" code a eye-sore.
> There will have to be:
>
> 	if (xen) {
> 		...
> 	} else if (kvm) {
> 		..
> 	}
>
> or possibly:
>
> 	alternative(NOP, some_xen_specific_call, ....)
>
> type of code in the common implementation.

No, that doesn't look like a good approach.  It suggests the apparently 
commonality isn't really there.

> For the time-being, I have made this KVM-specific only. At somepoint in future,
> I hope this can be made common between Xen/KVM.

Did you see the patch series I posted a couple of weeks ago to revamp pv 
spinlocks?  Specifically, I dropped the notion of pv spinlocks in which 
the entire spinlock implementation is replaced, and added pv ticketlocks 
where the ticketlock algorithm is always used for the fastpath, but it 
calls out to pvop calls for the slowpath (a long spin, or unlocking a 
lock with waiters).  It significantly reduces the amount of 
hypervisor-specific code.

You can see the current patches in

    git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git
    xen/pvticketlock-git



> More background and results for this patch below:
>
> What is the Problem being solved?
> =================================
>
> Guest operating system can be preempted by hypervisor at any arbitrary point.
> There is no mechanism (that I know of) where guest OS can disable preemption for
> certain periods of time. One noticeable effect of this is with regard to
> locking. Lets say one virtual-cpu of a guest (VCPUA) grabs a spinlock and before
> it could relinquish the lock is preempted by hypervisor. The time-of-preemption
> (when the virtual cpu is off the cpu) can be quite large. In that period, if
> another of guest OS's virtual cpu (VCPUB) tries grabbing the same lock, it could
> end up spin-waiting a _long_ time, burning cycles unnecessarily. To add to the
> woes, VCPUB may actually be waiting for VCPUA to yield before it can run on
> the same (physical) cpu. This is termed as the "lock-holder preemption" (LHP)
> problem. The effect of it can be quite serious. For ex:
> http://lkml.org/lkml/2010/4/11/108 reported 80% performance degradation because
> of an issue attributed to LHP problem.

That's not actually the real problem.  It's *a* problem, but 
insignificant compared to the ticketlock-specific "next-in-line vcpu 
scheduler bunfight" problem - lock holder preemption is a misnomer.  
Fortunately the solutions to both are (nearly) the same.

See Thomas Friebel's talk "Prevent Guests from Spinning Around 
(http://www.xen.org/files/xensummitboston08/LHP.pdf).

> Solutions
> =========
>
> There are several solutions to this problem.
>
> a. Realize that a lock-holder could have been preempted, and avoid spin-waiting
>     too long. Instead, yield cycles (to the lock-holder perhaps). This is a
>     common solution adopted by most paravirtualized-guests (Xen, s390, powerpc).
>
> b. Avoid preempting a lock-holder while its holding a (spin-) lock.
>
>     In this scheme, guest OS can hint (set some flag in memory shared with
>     hypervisor) whenever its holding a lock and hypervisor could defer preempting
>     the guest vcpu when its holding a lock.  With this scheme, we should never
>     have a lock-acquiring vcpu spin on a preempted vcpu to release its lock. If
>     ever it spins, its because somebody *currently running* is holding the lock -
>     and hence it won't have to spin-wait too long. IOW we are pro-actively
>     trying to prevent the LHP problem from occuring in the first place. This
>     should improve job turnaround time for some workloads. [1] has some
>     results based on this approach.

This doesn't actually help the problem mentioned above, because it's not 
a problem with the lock holder getting preempted, but what happens once 
the lock has been released.

> c. Share run-status of vcpu with guests. This could be used to optimize
>     routines like mutex_spin_on_owner().
>
>     Hypervisor could share run-status of vcpus in guest kernel memory. This would
>     allow us to optimize routines like mutex_spin_on_owner() - we don't spin-wait
>     if we relaize that the target vcpu has been preempted.
>
> a) and c) are about dealing with the LHP problem, while b) is about preventing
> the problem from happening.
>
> Scenario A:
>
> 	W/o patch		W/ Patch		Difference
> 	Avg  (std-dev)		Avg. (std-dev)
>
> 1:	273.270  (1.051)	251.613 (1.155)		7.9%
> 2:	541.343  (57.317)	443.400 (2.832)		18.1%
> 3:	819.160  (9.218)	642.393 (2.646)		21.6%
> 4:	1020.493 (34.743)	839.327	(0.658)		17.8%
>
>
> Scenario B:					
>
> 1:	276.947 (0.644) 	248.397 (1.563)		10.3%
> 2:	500.723	(5.694) 	438.957 (6.112)		12.33%
> 3:	725.687	(5.267) 	641.317 (3.902)		11.62%
> 4:	973.910	(21.712)	836.853	(2.754)		14.07%
>
> Scenario C:
>
> 1:	564.610  (12.055)    	420.510 (2.598)		25.52%
> 2:	750.867  (5.139)	618.570 (2.914)		17.61%
> 3:	950.150  (13.496)      	813.803 (1.872)		14.35%
> 4:	1125.027 (5.337)      	1007.63 (5.707)		10.43%
>
>
> IMO this is good improvement with the patchset applied.

Those are consistent with the results I get too.

     J
