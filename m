Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab1AXV47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:56:59 -0500
Received: from claw.goop.org ([74.207.240.146]:43760 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab1AXV46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:56:58 -0500
Message-ID: <4D3DF5A5.7070301@goop.org>
Date: Mon, 24 Jan 2011 13:56:53 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Eric Dumazet <dada1@cosmosbay.com>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        suzuki@in.ibm.com
Subject: Re: [PATCH 13/14] x86/ticketlock: add slowpath logic
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com> <97ed99ae9160bdb6477284b333bd6708fb7a19cb.1289940821.git.jeremy.fitzhardinge@citrix.com> <20110117152222.GA19233@linux.vnet.ibm.com> <20110119162348.GA29900@linux.vnet.ibm.com>
In-Reply-To: <20110119162348.GA29900@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2011 08:23 AM, Srivatsa Vaddagiri wrote:
> On Mon, Jan 17, 2011 at 08:52:22PM +0530, Srivatsa Vaddagiri wrote:
>> I think this is still racy ..
>>
>> Unlocker				Locker
>>
>> 				
>> test slowpath
>> 	-> false
>> 		
>> 				set slowpath flag
>> 				test for lock pickup
>> 					-> fail
>> 				block
>>
>>
>> unlock
>>
>> unlock needs to happen first before testing slowpath? I have made that change
>> for my KVM guest and it seems to be working well with that change .. Will
>> cleanup and post my patches shortly
> Patch below fixes the race described above. You can fold this to your patch
> 13/14 if you agree this is in right direction.
>
>
> Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
>
> ---
>  arch/x86/include/asm/spinlock.h      |    7 +++----
>  arch/x86/kernel/paravirt-spinlocks.c |   22 +++++-----------------
>  2 files changed, 8 insertions(+), 21 deletions(-)
>
> Index: linux-2.6.37/arch/x86/include/asm/spinlock.h
> ===================================================================
> --- linux-2.6.37.orig/arch/x86/include/asm/spinlock.h
> +++ linux-2.6.37/arch/x86/include/asm/spinlock.h
> @@ -55,7 +55,7 @@ static __always_inline void __ticket_unl
>  
>  /* Only defined when CONFIG_PARAVIRT_SPINLOCKS defined, but may as
>   * well leave the prototype always visible.  */
> -extern void __ticket_unlock_release_slowpath(struct arch_spinlock *lock);
> +extern void __ticket_unlock_slowpath(struct arch_spinlock *lock);
>  
>  #ifdef CONFIG_PARAVIRT_SPINLOCKS
>  
> @@ -166,10 +166,9 @@ static __always_inline int arch_spin_try
>  static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
>  {
>  	barrier();		/* prevent reordering out of locked region */
> +	__ticket_unlock_release(lock);
>  	if (unlikely(__ticket_in_slowpath(lock)))
> -		__ticket_unlock_release_slowpath(lock);
> -	else
> -		__ticket_unlock_release(lock);
> +		__ticket_unlock_slowpath(lock);
>  	barrier();		/* prevent reordering into locked region */
>  }
>  
> Index: linux-2.6.37/arch/x86/kernel/paravirt-spinlocks.c
> ===================================================================
> --- linux-2.6.37.orig/arch/x86/kernel/paravirt-spinlocks.c
> +++ linux-2.6.37/arch/x86/kernel/paravirt-spinlocks.c
> @@ -22,33 +22,21 @@ EXPORT_SYMBOL(pv_lock_ops);
>   * bits.  However, we need to be careful about this because someone
>   * may just be entering as we leave, and enter the slowpath.
>   */
> -void __ticket_unlock_release_slowpath(struct arch_spinlock *lock)
> +void __ticket_unlock_slowpath(struct arch_spinlock *lock)
>  {
>  	struct arch_spinlock old, new;
>  
>  	BUILD_BUG_ON(((__ticket_t)NR_CPUS) != NR_CPUS);
>  
>  	old = ACCESS_ONCE(*lock);
> -
>  	new = old;
> -	new.tickets.head += TICKET_LOCK_INC;
>  
>  	/* Clear the slowpath flag */
>  	new.tickets.tail &= ~TICKET_SLOWPATH_FLAG;
> +	if (new.tickets.head == new.tickets.tail)
> +		cmpxchg(&lock->head_tail, old.head_tail, new.head_tail);
>  
> -	/*
> -	 * If there's currently people waiting or someone snuck in
> -	 * since we read the lock above, then do a normal unlock and
> -	 * kick.  If we managed to unlock with no queued waiters, then
> -	 * we can clear the slowpath flag.
> -	 */
> -	if (new.tickets.head != new.tickets.tail ||
> -	    cmpxchg(&lock->head_tail,
> -		    old.head_tail, new.head_tail) != old.head_tail) {
> -		/* still people waiting */
> -		__ticket_unlock_release(lock);
> -	}
> -
> +	/* Wake up an appropriate waiter */
>  	__ticket_unlock_kick(lock, new.tickets.head);

Does the __ticket_unlock_kick need to be unconditional?  If the
cmpxchg() fails, then it means someone else has come in and changed the
lock under our feet, and presumably they'll do the kick as needed?

Or is there the possibility that the kick will get lost?

There's certainly no harm in doing a redundant kick, and I'd expect that
case to be pretty rare...

    J
