Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab1AYBmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:42:35 -0500
Received: from claw.goop.org ([74.207.240.146]:50038 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab1AYBmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 20:42:33 -0500
Message-ID: <4D3E2A87.8010409@goop.org>
Date: Mon, 24 Jan 2011 17:42:31 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Nick Piggin <npiggin@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 3/6] x86/ticketlock: Use C for __ticket_spin_unlock
References: <cover.1295909908.git.jeremy.fitzhardinge@citrix.com>	<8cc17932f623d3e65efb0b5e223537a28cc566e7.1295909909.git.jeremy.fitzhardinge@citrix.com> <AANLkTi=ZdDCYiUoZJHkxRsKyBjtTUmtWqzJOusZGwafO@mail.gmail.com>
In-Reply-To: <AANLkTi=ZdDCYiUoZJHkxRsKyBjtTUmtWqzJOusZGwafO@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2011 05:13 PM, Nick Piggin wrote:
> On Tue, Jan 25, 2011 at 10:41 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> If we don't need to use a locked inc for unlock, then implement it in C.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>> ---
>>  arch/x86/include/asm/spinlock.h |   32 +++++++++++++++++---------------
>>  1 files changed, 17 insertions(+), 15 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
>> index f48a6e3..0170ba9 100644
>> --- a/arch/x86/include/asm/spinlock.h
>> +++ b/arch/x86/include/asm/spinlock.h
>> @@ -33,9 +33,21 @@
>>  * On PPro SMP or if we are using OOSTORE, we use a locked operation to unlock
>>  * (PPro errata 66, 92)
>>  */
>> -# define UNLOCK_LOCK_PREFIX LOCK_PREFIX
>> +static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
>> +{
>> +       if (sizeof(lock->tickets.head) == sizeof(u8))
>> +               asm (LOCK_PREFIX "incb %0"
>> +                    : "+m" (lock->tickets.head) : : "memory");
>> +       else
>> +               asm (LOCK_PREFIX "incw %0"
>> +                    : "+m" (lock->tickets.head) : : "memory");
>> +
>> +}
>>  #else
>> -# define UNLOCK_LOCK_PREFIX
>> +static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
>> +{
>> +       lock->tickets.head++;
>> +}
>>  #endif
>>
>>  /*
>> @@ -93,14 +105,6 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
>>
>>        return tmp;
>>  }
>> -
>> -static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
>> -{
>> -       asm volatile(UNLOCK_LOCK_PREFIX "incb %0"
>> -                    : "+m" (lock->slock)
>> -                    :
>> -                    : "memory", "cc");
>> -}
>>  #else
>>  static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
>>  {
>> @@ -144,15 +148,13 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
>>
>>        return tmp;
>>  }
>> +#endif
>>
>>  static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
>>  {
>> -       asm volatile(UNLOCK_LOCK_PREFIX "incw %0"
>> -                    : "+m" (lock->slock)
>> -                    :
>> -                    : "memory", "cc");
>> +       __ticket_unlock_release(lock);
>> +       barrier();              /* prevent reordering into locked region */
>>  }
>> -#endif
> The barrier is wrong.

In what way?  Do you think it should be on the other side?

> What makes me a tiny bit uneasy is that gcc is allowed to implement
> this any way it wishes. OK there may be a NULL intersection of possible
> valid assembly which is a buggy unlock... but relying on gcc to implement
> lock primitives is scary. Does this really help in a way that can't be done
> with the assembly versions?

We rely on C/gcc for plenty of other subtle ordering things.  Spinlocks
aren't particularly special in this regard.

    J

