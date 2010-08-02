Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab0HBIsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:48:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594Ab0HBIsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:48:51 -0400
Message-ID: <4C568669.40001@redhat.com>
Date: Mon, 02 Aug 2010 11:48:41 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        linux-kernel@vger.kernel.org, npiggin@suse.de,
        Jeremy Fitzhardinge <jeremy@goop.org>, kvm@vger.kernel.org,
        bharata@in.ibm.com, Balbir Singh <balbir@in.ibm.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH RFC 3/4] Paravirtualized spinlock implementation for KVM
 guests
References: <20100726061150.GB21699@linux.vnet.ibm.com> <20100726061537.GC8402@linux.vnet.ibm.com>
In-Reply-To: <20100726061537.GC8402@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/26/2010 09:15 AM, Srivatsa Vaddagiri wrote:
> Paravirtual spinlock implementation for KVM guests, based heavily on Xen guest's
> spinlock implementation.
>
>
> +
> +static struct spinlock_stats
> +{
> +	u64 taken;
> +	u32 taken_slow;
> +
> +	u64 released;
> +
> +#define HISTO_BUCKETS	30
> +	u32 histo_spin_total[HISTO_BUCKETS+1];
> +	u32 histo_spin_spinning[HISTO_BUCKETS+1];
> +	u32 histo_spin_blocked[HISTO_BUCKETS+1];
> +
> +	u64 time_total;
> +	u64 time_spinning;
> +	u64 time_blocked;
> +} spinlock_stats;

Could these be replaced by tracepoints when starting to spin/stopping 
spinning etc?  Then userspace can reconstruct the histogram as well as 
see which locks are involved and what call paths.

> +struct kvm_spinlock {
> +	unsigned char lock;		/* 0 ->  free; 1 ->  locked */
> +	unsigned short spinners;	/* count of waiting cpus */
> +};
> +
> +/*
> + * Mark a cpu as interested in a lock.  Returns the CPU's previous
> + * lock of interest, in case we got preempted by an interrupt.
> + */
> +static inline void spinning_lock(struct kvm_spinlock *pl)
> +{
> +	asm(LOCK_PREFIX " incw %0"
> +	    : "+m" (pl->spinners) : : "memory");
> +}
> +
> +/*
> + * Mark a cpu as no longer interested in a lock.  Restores previous
> + * lock of interest (NULL for none).
> + */
> +static inline void unspinning_lock(struct kvm_spinlock *pl)
> +{
> +	asm(LOCK_PREFIX " decw %0"
> +	    : "+m" (pl->spinners) : : "memory");
> +}
> +
> +static int kvm_spin_is_locked(struct arch_spinlock *lock)
> +{
> +	struct kvm_spinlock *sl = (struct kvm_spinlock *)lock;
> +
> +	return sl->lock != 0;
> +}
> +
> +static int kvm_spin_is_contended(struct arch_spinlock *lock)
> +{
> +	struct kvm_spinlock *sl = (struct kvm_spinlock *)lock;
> +
> +	/* Not strictly true; this is only the count of contended
> +	   lock-takers entering the slow path. */
> +	return sl->spinners != 0;
> +}
> +
> +static int kvm_spin_trylock(struct arch_spinlock *lock)
> +{
> +	struct kvm_spinlock *sl = (struct kvm_spinlock *)lock;
> +	u8 old = 1;
> +
> +	asm("xchgb %b0,%1"
> +	    : "+q" (old), "+m" (sl->lock) : : "memory");
> +
> +	return old == 0;
> +}
> +
> +static noinline int kvm_spin_lock_slow(struct arch_spinlock *lock)
> +{
> +	struct kvm_spinlock *sl = (struct kvm_spinlock *)lock;
> +	u64 start;
> +
> +	ADD_STATS(taken_slow, 1);
> +
> +	/* announce we're spinning */
> +	spinning_lock(sl);
> +
> +	start = spin_time_start();
> +	kvm_hypercall0(KVM_HC_YIELD);

Oh.  This isn't really a yield since we expect to be woken up?  It's 
more of a sleep.

We already have a sleep hypercall, it's called HLT.  If we can use it, 
the thing can work on older hosts.  It's tricky though:

- if interrupts were enabled before we started spinning, sleep with 
interrupts enabled.  This also allows the spinner to switch to another 
process if some completion comes along so it's a good idea anyway.  Wake 
up sends an IPI.
- if not, we need to use NMI to wake up.  This is somewhat icky since 
there's no atomic "enable NMI and sleep" instruction, so we have to 
handle the case of the wake up arriving before HLT (can be done by 
examining RIP and seeing if it's in the critical section).

-- 
error compiling committee.c: too many arguments to function

