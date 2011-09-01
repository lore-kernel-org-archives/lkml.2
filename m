Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab1IADCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 23:02:48 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:43235 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379Ab1IADCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 23:02:46 -0400
Message-ID: <4E5EF5D8.3080907@gmail.com>
Date: Thu, 01 Sep 2011 11:02:48 +0800
From: Shan Hai <haishan.bai@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: akpm@linux-foundation.org, eric.dumazet@gmail.com, vapier@gentoo.org,
        asharma@fb.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1 -rt] lib:atomic64 using raw_spin_lock_irq[save|resotre]
 for atomicity
References: <1314840480-25182-1-git-send-email-haishan.bai@gmail.com> <1314840480-25182-2-git-send-email-haishan.bai@gmail.com> <20110901023744.GB9096@zhy>
In-Reply-To: <20110901023744.GB9096@zhy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2011 10:37 AM, Yong Zhang wrote:
> On Thu, Sep 01, 2011 at 09:28:00AM +0800, Shan Hai wrote:
>> The spin_lock_irq[save|restore] could break the atomicity of the
>> atomic64_* operations in the PREEMPT-RT configuration, because
>> the spin_lock_irq[save|restore] themselves are preemptable in the
>> PREEMPT-RT, using raw variant of the spin lock could provide the
>> atomicity that atomic64_* need.
>>
>> Signed-off-by: Shan Hai<haishan.bai@gmail.com>
> I think you could show your panic info also in the header.
>
> And this should be routed to tglx(Cc'ing), and also to
> linux-rt-users.
>

Got it.

comments below:
>> ---
>>   lib/atomic64.c |   40 ++++++++++++++++++++--------------------
>>   1 files changed, 20 insertions(+), 20 deletions(-)
>>
>> diff --git a/lib/atomic64.c b/lib/atomic64.c
>> index e12ae0d..26f524a 100644
>> --- a/lib/atomic64.c
>> +++ b/lib/atomic64.c
>> @@ -48,9 +48,9 @@ long long atomic64_read(const atomic64_t *v)
>>   	spinlock_t *lock = lock_addr(v);
>>   	long long val;
>>
>> -	spin_lock_irqsave(lock, flags);
>> +	raw_spin_lock_irqsave(lock, flags);
>>   	val = v->counter;
>> -	spin_unlock_irqrestore(lock, flags);
>> +	raw_spin_unlock_irqrestore(lock, flags);
> I think this is indeed a problem;
> but I don't see you touch the declaration and initialising of the lock,
> why?
>

My fault, should replace the lock type too, thanks for the suggestion.

Best regards
Shan Hai

> Thanks,
> Yong
>
>>   	return val;
>>   }
>>   EXPORT_SYMBOL(atomic64_read);
>> @@ -60,9 +60,9 @@ void atomic64_set(atomic64_t *v, long long i)
>>   	unsigned long flags;
>>   	spinlock_t *lock = lock_addr(v);
>>
>> -	spin_lock_irqsave(lock, flags);
>> +	raw_spin_lock_irqsave(lock, flags);
>>   	v->counter = i;
>> -	spin_unlock_irqrestore(lock, flags);
>> +	raw_spin_unlock_irqrestore(lock, flags);
>>   }
>>   EXPORT_SYMBOL(atomic64_set);
>>
>> @@ -71,9 +71,9 @@ void atomic64_add(long long a, atomic64_t *v)
>>   	unsigned long flags;
>>   	spinlock_t *lock = lock_addr(v);
>>
>> -	spin_lock_irqsave(lock, flags);
>> +	raw_spin_lock_irqsave(lock, flags);
>>   	v->counter += a;
>> -	spin_unlock_irqrestore(lock, flags);
>> +	raw_spin_unlock_irqrestore(lock, flags);
>>   }
>>   EXPORT_SYMBOL(atomic64_add);
>>
>> @@ -83,9 +83,9 @@ long long atomic64_add_return(long long a, atomic64_t *v)
>>   	spinlock_t *lock = lock_addr(v);
>>   	long long val;
>>
>> -	spin_lock_irqsave(lock, flags);
>> +	raw_spin_lock_irqsave(lock, flags);
>>   	val = v->counter += a;
>> -	spin_unlock_irqrestore(lock, flags);
>> +	raw_spin_unlock_irqrestore(lock, flags);
>>   	return val;
>>   }
>>   EXPORT_SYMBOL(atomic64_add_return);
>> @@ -95,9 +95,9 @@ void atomic64_sub(long long a, atomic64_t *v)
>>   	unsigned long flags;
>>   	spinlock_t *lock = lock_addr(v);
>>
>> -	spin_lock_irqsave(lock, flags);
>> +	raw_spin_lock_irqsave(lock, flags);
>>   	v->counter -= a;
>> -	spin_unlock_irqrestore(lock, flags);
>> +	raw_spin_unlock_irqrestore(lock, flags);
>>   }
>>   EXPORT_SYMBOL(atomic64_sub);
>>
>> @@ -107,9 +107,9 @@ long long atomic64_sub_return(long long a, atomic64_t *v)
>>   	spinlock_t *lock = lock_addr(v);
>>   	long long val;
>>
>> -	spin_lock_irqsave(lock, flags);
>> +	raw_spin_lock_irqsave(lock, flags);
>>   	val = v->counter -= a;
>> -	spin_unlock_irqrestore(lock, flags);
>> +	raw_spin_unlock_irqrestore(lock, flags);
>>   	return val;
>>   }
>>   EXPORT_SYMBOL(atomic64_sub_return);
>> @@ -120,11 +120,11 @@ long long atomic64_dec_if_positive(atomic64_t *v)
>>   	spinlock_t *lock = lock_addr(v);
>>   	long long val;
>>
>> -	spin_lock_irqsave(lock, flags);
>> +	raw_spin_lock_irqsave(lock, flags);
>>   	val = v->counter - 1;
>>   	if (val>= 0)
>>   		v->counter = val;
>> -	spin_unlock_irqrestore(lock, flags);
>> +	raw_spin_unlock_irqrestore(lock, flags);
>>   	return val;
>>   }
>>   EXPORT_SYMBOL(atomic64_dec_if_positive);
>> @@ -135,11 +135,11 @@ long long atomic64_cmpxchg(atomic64_t *v, long long o, long long n)
>>   	spinlock_t *lock = lock_addr(v);
>>   	long long val;
>>
>> -	spin_lock_irqsave(lock, flags);
>> +	raw_spin_lock_irqsave(lock, flags);
>>   	val = v->counter;
>>   	if (val == o)
>>   		v->counter = n;
>> -	spin_unlock_irqrestore(lock, flags);
>> +	raw_spin_unlock_irqrestore(lock, flags);
>>   	return val;
>>   }
>>   EXPORT_SYMBOL(atomic64_cmpxchg);
>> @@ -150,10 +150,10 @@ long long atomic64_xchg(atomic64_t *v, long long new)
>>   	spinlock_t *lock = lock_addr(v);
>>   	long long val;
>>
>> -	spin_lock_irqsave(lock, flags);
>> +	raw_spin_lock_irqsave(lock, flags);
>>   	val = v->counter;
>>   	v->counter = new;
>> -	spin_unlock_irqrestore(lock, flags);
>> +	raw_spin_unlock_irqrestore(lock, flags);
>>   	return val;
>>   }
>>   EXPORT_SYMBOL(atomic64_xchg);
>> @@ -164,12 +164,12 @@ int atomic64_add_unless(atomic64_t *v, long long a, long long u)
>>   	spinlock_t *lock = lock_addr(v);
>>   	int ret = 0;
>>
>> -	spin_lock_irqsave(lock, flags);
>> +	raw_spin_lock_irqsave(lock, flags);
>>   	if (v->counter != u) {
>>   		v->counter += a;
>>   		ret = 1;
>>   	}
>> -	spin_unlock_irqrestore(lock, flags);
>> +	raw_spin_unlock_irqrestore(lock, flags);
>>   	return ret;
>>   }
>>   EXPORT_SYMBOL(atomic64_add_unless);
>> -- 
>> 1.7.4.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

