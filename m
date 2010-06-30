Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0F3KIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 06:08:50 -0400
Received: from claw.goop.org ([74.207.240.146]:57748 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755Ab0F3KIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 06:08:49 -0400
Message-ID: <4C2B17AE.8000002@goop.org>
Date: Wed, 30 Jun 2010 12:08:46 +0200
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>, ksrinivasan <ksrinivasan@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4, v2] x86: enlightenment for ticket spin locks -	 improve
 yield behavior on Xen
References: <4C2A20E30200007800008A17@vpn.id2.novell.com>
In-Reply-To: <4C2A20E30200007800008A17@vpn.id2.novell.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2010 04:35 PM, Jan Beulich wrote:
> This optional patch improves yielding behavior in that the acquire
> function now checks whether the vCPU owning the lock is actually
> running, yielding immediately if it isn't.
>
> The (only) additional overhead this introduces for native execution is
> the writing of the owning CPU in the lock acquire paths. If this is
> considered a problem but the patch otherwise is deemed useful, even
> that code could be eliminated for native execution (by further
> alternative instruction patching).
>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: KY Srinivasan <ksrinivasan@novell.com>
>
> ---
>  arch/x86/include/asm/spinlock.h       |   13 +++++++++++++
>  arch/x86/include/asm/spinlock_types.h |    5 +++++
>  arch/x86/kernel/cpu/xen.c             |    5 ++++-
>  3 files changed, 22 insertions(+), 1 deletion(-)
>
> --- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/include/asm/spinlock.h
> +++ 2.6.35-rc3-virt-spinlocks/arch/x86/include/asm/spinlock.h
> @@ -85,6 +85,15 @@ extern void virt_spin_unlock_stub(void);
>  # define UNLOCK_LOCK_PREFIX
>  #endif
>  
> +static __always_inline void __ticket_spin_set_owner(arch_spinlock_t *lock,
> +                                                    int owned)
> +{
> +#ifdef CONFIG_ENLIGHTEN_SPINLOCKS
> +	if (owned)
> +		lock->owner = percpu_read(cpu_number);
>   

Why not smp_processor_id()?  Is this different in some way?

> +#endif
> +}
> +
>  /*
>   * Ticket locks are conceptually two parts, one indicating the current head of
>   * the queue, and the other indicating the current tail. The lock is acquired
> @@ -124,6 +133,7 @@ static __always_inline void __ticket_spi
>  		ASM_OUTPUT2("+Q" (inc), "+m" (lock->slock)),
>  		[stub] "i" (virt_spin_lock_stub)
>  		: "memory", "cc");
> +	__ticket_spin_set_owner(lock, true);
>  }
>  
>  static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
> @@ -141,6 +151,7 @@ static __always_inline int __ticket_spin
>  		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
>  		     :
>  		     : "memory", "cc");
> +	__ticket_spin_set_owner(lock, tmp);
>  
>  	return tmp;
>  }
> @@ -192,6 +203,7 @@ static __always_inline void __ticket_spi
>  		     ASM_OUTPUT2("+r" (inc), "+m" (lock->slock), "=&r" (tmp)),
>  		     [stub] "i" (virt_spin_lock_stub)
>  		     : "memory", "cc");
> +	__ticket_spin_set_owner(lock, true);
>  }
>  
>  static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
> @@ -212,6 +224,7 @@ static __always_inline int __ticket_spin
>  		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
>  		     :
>  		     : "memory", "cc");
> +	__ticket_spin_set_owner(lock, tmp);
>  
>  	return tmp;
>  }
> --- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/include/asm/spinlock_types.h
> +++ 2.6.35-rc3-virt-spinlocks/arch/x86/include/asm/spinlock_types.h
> @@ -17,6 +17,11 @@ typedef struct arch_spinlock {
>  # else
>  			u16 cur, seq;
>  # endif
> +# if CONFIG_NR_CPUS <= 256
> +			u8 owner;
> +# else
> +			u16 owner;
> +# endif
>  		};
>  #endif
>  	};
> --- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/kernel/cpu/xen.c
> +++ 2.6.35-rc3-virt-spinlocks/arch/x86/kernel/cpu/xen.c
> @@ -79,7 +79,8 @@ static void xen_spin_lock(struct arch_sp
>  
>  	for (count = spin_count; ({ barrier(); lock->cur != token; }); )
>  		if (likely(cpu_online(raw_smp_processor_id()))
> -		    && unlikely(!--count)) {
> +		    && (per_cpu(runstate.state, lock->owner) != RUNSTATE_running
> +			|| unlikely(!--count))) {
>  			struct sched_poll sched_poll;
>  
>  			set_xen_guest_handle(sched_poll.ports,
> @@ -91,6 +92,8 @@ static void xen_spin_lock(struct arch_sp
>  		} else
>  			cpu_relax();
>  
> +	lock->owner = raw_smp_processor_id();
> +
>  	/*
>  	 * If we interrupted another spinlock while it was blocking, make
>  	 * sure it doesn't block (again) without re-checking the lock.
>
>
>
>   

