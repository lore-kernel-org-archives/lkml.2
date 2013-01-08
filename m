Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab3AHWyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 17:54:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754952Ab3AHWys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 17:54:48 -0500
Message-ID: <50ECA3AA.7000101@redhat.com>
Date: Tue, 08 Jan 2013 17:54:34 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>, knoel@redhat.com,
        chegu_vinod@hp.com, raghavendra.kt@linux.vnet.ibm.com,
        mingo@redhat.com
Subject: Re: [PATCH 2/5] x86,smp: proportional backoff for ticket spinlocks
References: <20130108172632.1126898a@annuminas.surriel.com>  <20130108173241.3e1b1d2d@annuminas.surriel.com> <1357685430.18156.776.camel@edumazet-glaptop>
In-Reply-To: <1357685430.18156.776.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 05:50 PM, Eric Dumazet wrote:
> On Tue, 2013-01-08 at 17:32 -0500, Rik van Riel wrote:
>> Subject: x86,smp: proportional backoff for ticket spinlocks
>>
>> Simple fixed value proportional backoff for ticket spinlocks.
>> By pounding on the cacheline with the spin lock less often,
>> bus traffic is reduced. In cases of a data structure with
>> embedded spinlock, the lock holder has a better chance of
>> making progress.
>>
>> If we are next in line behind the current holder of the
>> lock, we do a fast spin, so as not to waste any time when
>> the lock is released.
>>
>> The number 50 is likely to be wrong for many setups, and
>> this patch is mostly to illustrate the concept of proportional
>> backup. The next patch automatically tunes the delay value.
>>
>> Signed-off-by: Rik van Riel <riel@redhat.com>
>> Signed-off-by: Michel Lespinasse <walken@google.com>
>> ---
>>   arch/x86/kernel/smp.c |   23 ++++++++++++++++++++---
>>   1 files changed, 20 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
>> index 20da354..aa743e9 100644
>> --- a/arch/x86/kernel/smp.c
>> +++ b/arch/x86/kernel/smp.c
>> @@ -117,11 +117,28 @@ static bool smp_no_nmi_ipi = false;
>>    */
>>   void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
>>   {
>> +	__ticket_t head = inc.head, ticket = inc.tail;
>> +	__ticket_t waiters_ahead;
>> +	unsigned loops;
>> +
>>   	for (;;) {
>> -		cpu_relax();
>> -		inc.head = ACCESS_ONCE(lock->tickets.head);
>> +		waiters_ahead = ticket - head - 1;
>> +		/*
>> +		 * We are next after the current lock holder. Check often
>> +		 * to avoid wasting time when the lock is released.
>> +		 */
>> +		if (!waiters_ahead) {
>> +			do {
>> +				cpu_relax();
>> +			} while (ACCESS_ONCE(lock->tickets.head) != ticket);
>> +			break;
>> +		}
>> +		loops = 50 * waiters_ahead;
>> +		while (loops--)
>> +			cpu_relax();
>>
>> -		if (inc.head == inc.tail)
>> +		head = ACCESS_ONCE(lock->tickets.head);
>> +		if (head == ticket)
>>   			break;
>>   	}
>>   }
>>
>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
>
> In my tests, I used the following formula :
>
> loops = 50 * ((ticket - head) - 1/2);
>
> or :
>
> delta = ticket - head;
> loops = delay * delta - (delay >> 1);

I suppose that rounding down the delta might result
in more stable results, due to undersleeping less
often.

> (And I didnt use the special :
>
> 	if (!waiters_ahead) {
> 		do {
> 			cpu_relax();
> 		} while (ACCESS_ONCE(lock->tickets.head) != ticket);
> 		break;
> 	}
>
> Because it means this wont help machines with 2 cpus.
>
> (or more generally if there _is_ contention, but with
> one lock holder and one lock waiter)

Machines with 2 CPUs should not need help, because the
cpu_relax() alone gives enough of a pause that the lock
holder can make progress.

It may be interesting to try out your rounding-down of
delta, to see if that makes things better.

-- 
All rights reversed
