Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab2LVDrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 22:47:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab2LVDrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 22:47:08 -0500
Message-ID: <50D52E0C.6000103@redhat.com>
Date: Fri, 21 Dec 2012 22:50:36 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/3 -v2] x86,smp: auto tune spinlock backoff delay
 factor
References: <20121221184940.103c31ad@annuminas.surriel.com> <20121221185147.4ae48ab5@annuminas.surriel.com> <20121221185613.1f4c9523@annuminas.surriel.com> <20121222033339.GF27621@home.goodmis.org>
In-Reply-To: <20121222033339.GF27621@home.goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2012 10:33 PM, Steven Rostedt wrote:
> On Fri, Dec 21, 2012 at 06:56:13PM -0500, Rik van Riel wrote:
>> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
>> index 4e44840..e44c56f 100644
>> --- a/arch/x86/kernel/smp.c
>> +++ b/arch/x86/kernel/smp.c
>> @@ -113,19 +113,62 @@ static atomic_t stopping_cpu = ATOMIC_INIT(-1);
>>   static bool smp_no_nmi_ipi = false;
>>
>>   /*
>> - * Wait on a congested ticket spinlock.
>> + * Wait on a congested ticket spinlock. Many spinlocks are embedded in
>> + * data structures; having many CPUs pounce on the cache line with the
>> + * spinlock simultaneously can slow down the lock holder, and the system
>> + * as a whole.
>> + *
>> + * To prevent total performance collapse in case of bad spinlock contention,
>> + * perform proportional backoff. The per-cpu value of delay is automatically
>> + * tuned to limit the number of times spinning CPUs poll the lock before
>> + * obtaining it. This limits the amount of cross-CPU traffic required to obtain
>> + * a spinlock, and keeps system performance from dropping off a cliff.
>> + *
>> + * There is a tradeoff. If we poll too often, the whole system is slowed
>> + * down. If we sleep too long, the lock will go unused for a period of
>> + * time. Adjusting "delay" to poll, on average, 2.7 times before the
>> + * lock is obtained seems to result in low bus traffic. The combination
>> + * of aiming for a non-integer amount of average polls, and scaling the
>> + * sleep period proportionally to how many CPUs are ahead of us in the
>> + * queue for this ticket lock seems to reduce the amount of time spent
>> + * "oversleeping" the release of the lock.
>>    */
>> +#define MIN_SPINLOCK_DELAY 1
>> +#define MAX_SPINLOCK_DELAY 1000
>> +DEFINE_PER_CPU(int, spinlock_delay) = { MIN_SPINLOCK_DELAY };
>>   void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
>>   {
>> +	/*
>> +	 * Use the raw per-cpu pointer; preemption is disabled in the
>> +	 * spinlock code. This avoids put_cpu_var once we have the lock.
>> +	 */
>> +	int *delay_ptr = &per_cpu(spinlock_delay, smp_processor_id());
>> +	int delay = *delay_ptr;
>
> I'm confused by the above comment. Why not just:
>
> 	int delay = this_cpu_read(spinlock_delay);
> ?

Eric Dumazet pointed out the same thing.  My code now
uses __this_cpu_read and __this_cpu_write.

> Too bad you posted this just before break. I currently have access to a
> 40 core box, and I would have loved to test this. But right now I have
> it testing other things, and hopefully I'll still have access to it
> after the break.

I will try to run this test on a really large SMP system
in the lab during the break.

Ideally, the auto-tuning will keep the delay value large
enough that performance will stay flat even when there are
100 CPUs contending over the same lock.

Maybe it turns out that the maximum allowed delay value
needs to be larger.  Only one way to find out...

