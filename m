Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab1AYBtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:49:19 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37221 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1AYBtS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 20:49:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vokKlVAkVUWaVVp4pQWD9Pu0CDuy8cFZLMt2i+6ce/ahO1xvpv2m2QGaa/WO/JXveC
         UE9QXLP+kKKDYOiWOcs3P1BwfjSzHV2fS4I7hWPGjGEGZFN93R2gYMq6Lxg3O1I1Fcau
         9qaTRaSVNDt5pxrjPhDZQ+U64nAFR88xEwIVA=
MIME-Version: 1.0
In-Reply-To: <4D3E2A87.8010409@goop.org>
References: <cover.1295909908.git.jeremy.fitzhardinge@citrix.com>
	<8cc17932f623d3e65efb0b5e223537a28cc566e7.1295909909.git.jeremy.fitzhardinge@citrix.com>
	<AANLkTi=ZdDCYiUoZJHkxRsKyBjtTUmtWqzJOusZGwafO@mail.gmail.com>
	<4D3E2A87.8010409@goop.org>
Date: Tue, 25 Jan 2011 12:49:16 +1100
Message-ID: <AANLkTikWu2B512Sge7w=5T6LsOdedadfGHEC_Wi6YPZo@mail.gmail.com>
Subject: Re: [PATCH 3/6] x86/ticketlock: Use C for __ticket_spin_unlock
From: Nick Piggin <npiggin@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 12:42 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> On 01/24/2011 05:13 PM, Nick Piggin wrote:
>> On Tue, Jan 25, 2011 at 10:41 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>>
>>> If we don't need to use a locked inc for unlock, then implement it in C.
>>>
>>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>> ---
>>>  arch/x86/include/asm/spinlock.h |   32 +++++++++++++++++---------------
>>>  1 files changed, 17 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
>>> index f48a6e3..0170ba9 100644
>>> --- a/arch/x86/include/asm/spinlock.h
>>> +++ b/arch/x86/include/asm/spinlock.h
>>> @@ -33,9 +33,21 @@
>>>  * On PPro SMP or if we are using OOSTORE, we use a locked operation to unlock
>>>  * (PPro errata 66, 92)
>>>  */
>>> -# define UNLOCK_LOCK_PREFIX LOCK_PREFIX
>>> +static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
>>> +{
>>> +       if (sizeof(lock->tickets.head) == sizeof(u8))
>>> +               asm (LOCK_PREFIX "incb %0"
>>> +                    : "+m" (lock->tickets.head) : : "memory");
>>> +       else
>>> +               asm (LOCK_PREFIX "incw %0"
>>> +                    : "+m" (lock->tickets.head) : : "memory");
>>> +
>>> +}
>>>  #else
>>> -# define UNLOCK_LOCK_PREFIX
>>> +static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
>>> +{
>>> +       lock->tickets.head++;
>>> +}
>>>  #endif
>>>
>>>  /*
>>> @@ -93,14 +105,6 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
>>>
>>>        return tmp;
>>>  }
>>> -
>>> -static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
>>> -{
>>> -       asm volatile(UNLOCK_LOCK_PREFIX "incb %0"
>>> -                    : "+m" (lock->slock)
>>> -                    :
>>> -                    : "memory", "cc");
>>> -}
>>>  #else
>>>  static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
>>>  {
>>> @@ -144,15 +148,13 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
>>>
>>>        return tmp;
>>>  }
>>> +#endif
>>>
>>>  static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
>>>  {
>>> -       asm volatile(UNLOCK_LOCK_PREFIX "incw %0"
>>> -                    : "+m" (lock->slock)
>>> -                    :
>>> -                    : "memory", "cc");
>>> +       __ticket_unlock_release(lock);
>>> +       barrier();              /* prevent reordering into locked region */
>>>  }
>>> -#endif
>> The barrier is wrong.
>
> In what way?  Do you think it should be on the other side?

Well the other side is where the locked region is :)


>> What makes me a tiny bit uneasy is that gcc is allowed to implement
>> this any way it wishes. OK there may be a NULL intersection of possible
>> valid assembly which is a buggy unlock... but relying on gcc to implement
>> lock primitives is scary. Does this really help in a way that can't be done
>> with the assembly versions?
>
> We rely on C/gcc for plenty of other subtle ordering things.  Spinlocks
> aren't particularly special in this regard.

Well probably not orderings, but we do rely on it to do atomic
stores and loads to <= sizeof(long) data types, unfortunately.
We also rely on it not to speculatively store into data on not taken
side of branches and things like that.

I guess it's OK, but it makes me cringe a little bit to see unlock just
do head++
