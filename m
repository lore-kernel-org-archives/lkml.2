Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab0KCPLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:11:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35647 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab0KCPLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:11:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ljeUQwPyT3fPwKBeSCrlpD077jCtWiTUWQwNGj0H1fGWFrbhpbWCaAPCTDD59L++KH
         hFhDUFhFIeNNcpq2KoflIJ4Cw7fki2apHisfeFY/J/jy8XG5c8WL1ufWYjqTxF8Seznm
         OmkrcZahBtT+iUkrQsAO1PgdbRVR3SYhYxjYg=
Subject: Re: [PATCH 02/20] x86/ticketlock: convert spin loop to C
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <3d9083892c28a7d3ed5a0191b0b4cd013022a186.1288794124.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
	 <3d9083892c28a7d3ed5a0191b0b4cd013022a186.1288794124.git.jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 16:11:32 +0100
Message-ID: <1288797092.2511.141.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 03 novembre 2010 à 10:59 -0400, Jeremy Fitzhardinge a
écrit :
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> The inner loop of __ticket_spin_lock isn't doing anything very special,
> so reimplement it in C.
> 
> For the 8 bit ticket lock variant, we use a register union to get direct
> access to the lower and upper bytes in the tickets, but unfortunately gcc
> won't generate a direct comparison between the two halves of the register,
> so the generated asm isn't quite as pretty as the hand-coded version.
> However benchmarking shows that this is actually a small improvement in
> runtime performance on some benchmarks, and never a slowdown.
> 
> We also need to make sure there's a barrier at the end of the lock loop
> to make sure that the compiler doesn't move any instructions from within
> the locked region into the region where we don't yet own the lock.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  arch/x86/include/asm/spinlock.h |   58 +++++++++++++++++++-------------------
>  1 files changed, 29 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
> index d6d5784..6711d36 100644
> --- a/arch/x86/include/asm/spinlock.h
> +++ b/arch/x86/include/asm/spinlock.h
> @@ -58,21 +58,21 @@
>  #if (NR_CPUS < 256)
>  static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
>  {
> -	unsigned short inc = 1 << TICKET_SHIFT;
> -
> -	asm volatile (
> -		LOCK_PREFIX "xaddw %w0, %1\n"
> -		"1:\t"
> -		"cmpb %h0, %b0\n\t"
> -		"je 2f\n\t"
> -		"rep ; nop\n\t"
> -		"movb %1, %b0\n\t"
> -		/* don't need lfence here, because loads are in-order */
> -		"jmp 1b\n"
> -		"2:"
> -		: "+Q" (inc), "+m" (lock->slock)
> -		:
> -		: "memory", "cc");
> +	register union {
> +		struct __raw_tickets tickets;
> +		unsigned short slock;
> +	} inc = { .slock = 1 << TICKET_SHIFT };
> +
> +	asm volatile (LOCK_PREFIX "xaddw %w0, %1\n"
> +		      : "+Q" (inc), "+m" (lock->slock) : : "memory", "cc");
> +
> +	for (;;) {
> +		if (inc.tickets.head == inc.tickets.tail)
> +			return;
> +		cpu_relax();
> +		inc.tickets.head = ACCESS_ONCE(lock->tickets.head);
> +	}
> +	barrier();		/* make sure nothing creeps before the lock is taken */

Isnt this barrier() never reached ?


>  }
>  
>  static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
> @@ -105,22 +105,22 @@ static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
>  static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
>  {
>  	unsigned inc = 1 << TICKET_SHIFT;
> -	unsigned tmp;
> +	__ticket_t tmp;
>  
> -	asm volatile(LOCK_PREFIX "xaddl %0, %1\n"
> -		     "movzwl %w0, %2\n\t"
> -		     "shrl $16, %0\n\t"
> -		     "1:\t"
> -		     "cmpl %0, %2\n\t"
> -		     "je 2f\n\t"
> -		     "rep ; nop\n\t"
> -		     "movzwl %1, %2\n\t"
> -		     /* don't need lfence here, because loads are in-order */
> -		     "jmp 1b\n"
> -		     "2:"
> -		     : "+r" (inc), "+m" (lock->slock), "=&r" (tmp)
> -		     :
> -		     : "memory", "cc");
> +	asm volatile(LOCK_PREFIX "xaddl %0, %1\n\t"
> +		     : "+r" (inc), "+m" (lock->slock)
> +		     : : "memory", "cc");
> +
> +	tmp = inc;
> +	inc >>= TICKET_SHIFT;
> +
> +	for (;;) {
> +		if ((__ticket_t)inc == tmp)
> +			return;
> +		cpu_relax();
> +		tmp = ACCESS_ONCE(lock->tickets.head);
> +	}
> +	barrier();		/* make sure nothing creeps before the lock is taken */

same here

>  }
>  
>  static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)


