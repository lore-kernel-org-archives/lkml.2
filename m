Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761328Ab0GTQRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 12:17:09 -0400
Received: from claw.goop.org ([74.207.240.146]:59368 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758478Ab0GTQRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 12:17:08 -0400
Message-ID: <4C45CC02.7030603@goop.org>
Date: Tue, 20 Jul 2010 09:17:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Xen-devel <xen-devel@lists.xensource.com>, Avi Kivity <avi@redhat.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [Xen-devel] [PATCH RFC 03/12] x86/ticketlock: Use C for __ticket_spin_unlock
References: <cover.1279328276.git.jeremy.fitzhardinge@citrix.com> <f3622d39ae72573c586405ea6f1597eb39fc28d4.1279328276.git.jeremy.fitzhardinge@citrix.com> <20100720153845.GA9122@phenom.dumpdata.com>
In-Reply-To: <20100720153845.GA9122@phenom.dumpdata.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2010 08:38 AM, Konrad Rzeszutek Wilk wrote:
>> --- a/arch/x86/include/asm/spinlock.h
>> +++ b/arch/x86/include/asm/spinlock.h
>> @@ -33,9 +33,23 @@
>>   * On PPro SMP or if we are using OOSTORE, we use a locked operation to unlock
>>   * (PPro errata 66, 92)
>>   */
>> -# define UNLOCK_LOCK_PREFIX LOCK_PREFIX
>> +static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
>> +{
>> +	if (sizeof(lock->tickets.head) == sizeof(u8))
>> +		asm (LOCK_PREFIX "incb %0"
>> +		     : "+m" (lock->tickets.head) : : "memory");
>> +	else
>> +		asm (LOCK_PREFIX "incw %0"
>> +		     : "+m" (lock->tickets.head) : : "memory");
>>     
> Should those be 'asm volatile' to make them barriers as well? Or do we
> not have to worry about that on a Pentium Pro SMP?
>   

"volatile" would be a compiler barrier, but it has no direct effect on,
or relevence to, the CPU.  It just cares about the LOCK_PREFIX.  The
"memory" clobber is probably unnecessary as well, since the constraints
already tell the compiler the most important information.  We can add
barriers separately as needed.

>> +
>> +}
>>  #else
>> -# define UNLOCK_LOCK_PREFIX
>> +static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
>> +{
>> +	barrier();
>> +	lock->tickets.head++;
>> +	barrier();
>> +}
>>     
> Got a question:
> This extra barrier() (which I see gets removed in git tree) was
> done b/c the function is inlined and hence the second barrier() inhibits
> gcc from re-ordering __ticket_spin_unlock instructions? Which is a big
> pre-requisite in patch 7 where this function expands to:
>   

Yes, I removed the barriers here so that the compiler can combine the
unlocking "inc" with getting "next" for unlock_kick.  There's no
constraint on what instructions the compiler can use to do the unlock so
long as it ends up writing a byte value to the right location.

>  static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
>  {
>        __ticket_t next = lock->tickets.head + 1; // This code
> is executed before the lock->tickets.head++ b/c of the 1st barrier?
> Or would it be done irregardless b/c gcc sees the data dependency here?
>
>         __ticket_unlock_release(lock); <- expands to
> "barrier();lock->tickets.head++;barrier()" 
>
> +       __ticket_unlock_kick(lock, next);   <- so now the second barrier()
> affects this code, so it won't re-order the lock->tickets.head++ to be called
> after this function?
>
>
> This barrier ("asm volatile("" : : : "memory")); from what I've been reading
> says : "Don't re-order the instructions within this scope and starting
> right below me." ? Or is it is just within the full scope of the
> function/code logic irregardless of the 'inline' defined in one of them?
>   

The barrier effects the entire instruction stream, regardless of the
source from which it was generated.  So inlining will bring the
function's instructions into the caller's stream, and the compiler will
freely reorder them as it sees fit - and the barrier adds a restraint to
that.

    J
