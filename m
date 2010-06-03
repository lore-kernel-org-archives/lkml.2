Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223Ab0FCEVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 00:21:00 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40477 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab0FCEU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 00:20:59 -0400
Date: Thu, 3 Jun 2010 09:50:51 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Gleb Natapov <gleb@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, hpa@zytor.com,
       mingo@elte.hu, npiggin@suse.de, tglx@linutronix.de, mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
Message-ID: <20100603042051.GA5953@linux.vnet.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20100601093515.GH24302@redhat.com>
 <87sk56ycka.fsf@basil.nowhere.org>
 <20100601162414.GA6191@redhat.com>
 <20100601163807.GA11880@basil.fritz.box>
 <4C053ACC.5020708@redhat.com>
 <20100601172730.GB11880@basil.fritz.box>
 <4C05C722.1010804@redhat.com>
 <20100602085055.GA14221@basil.fritz.box>
 <4C061DAB.6000804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C061DAB.6000804@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 12:00:27PM +0300, Avi Kivity wrote:
> 
> There are two separate problems: the more general problem is that
> the hypervisor can put a vcpu to sleep while holding a lock, causing
> other vcpus to spin until the end of their time slice.  This can
> only be addressed with hypervisor help.

Fyi - I have a early patch ready to address this issue. Basically I am using
host-kernel memory (mmap'ed into guest as io-memory via ivshmem driver) to hint 
host whenever guest is in spin-lock'ed section, which is read by host scheduler 
to defer preemption.

Guest side:

static inline void spin_lock(spinlock_t *lock)
{
	raw_spin_lock(&lock->rlock);
+       __get_cpu_var(gh_vcpu_ptr)->defer_preempt++;
}

static inline void spin_unlock(spinlock_t *lock)
{
+	__get_cpu_var(gh_vcpu_ptr)->defer_preempt--;
        raw_spin_unlock(&lock->rlock);
}

[similar changes to other spinlock variants]

Host side:


@@ -860,6 +866,17 @@ check_preempt_tick(struct cfs_rq *cfs_rq
 	ideal_runtime = sched_slice(cfs_rq, curr);
 	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
 	if (delta_exec > ideal_runtime) {
+		if ((sched_feat(DEFER_PREEMPT)) && (rq_of(cfs_rq)->curr->ghptr)) {
+			int defer_preempt =  rq_of(cfs_rq)->curr->ghptr->defer_preempt;
+			if (((defer_preempt & 0xFFFF0000) == 0xfeed0000) && ((defer_preempt & 0x0000FFFF) != 0)) {
+				if  ((rq_of(cfs_rq)->curr->grace_defer++ < sysctl_sched_preempt_defer_count)) {
+					rq_of(cfs_rq)->defer_preempt++;
+					return;
+				} else
+					rq_of(cfs_rq)->force_preempt++;
+			}
+		}
 		resched_task(rq_of(cfs_rq)->curr);
 		/*
 		 * The current task ran long enough, ensure it doesn't get

[similar changes introduced at other preemption points in sched_fair.c]


Note that guest can only request preemption to be deferred (and not disabled via
this mechanism). I have seen good improvement (~15%) in kern compile benchmark 
with sysctl_sched_preempt_defer_count set to a low value of just 2 (i.e we can 
defer preemption by maximum two ticks). I intend to cleanup and post the patches
pretty soon for comments.

One pathological case where this may actually hurt is routines in guest like 
flush_tlb_others_ipi() which take a spinlock and then enter a while() loop
waiting for other cpus to ack something. In this case, deferring preemption just
because guest is in critical section actually hurts! Hopefully the upper bound
for deferring preemtion and the fact that such routines may not be frequently
hit should help alleviate such situations.

- vatsa

