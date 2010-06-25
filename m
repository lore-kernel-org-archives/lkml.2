Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab0FYT45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 15:56:57 -0400
Received: from mail.openrapids.net ([64.15.138.104]:45472 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751461Ab0FYT44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 15:56:56 -0400
Date: Fri, 25 Jun 2010 15:56:51 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andreas Schwab <schwab@redhat.com>, Danny Feng <dfeng@redhat.com>,
       Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Q: sys_futex() && timespec_valid()
Message-ID: <20100625195651.GA12537@Krystal>
References: <20100625192008.GA25337@redhat.com> <4C2506C3.2000301@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2506C3.2000301@us.ibm.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:55:52 up 153 days, 22:33,  7 users,  load average: 0.25, 0.25,
	0.21
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Darren Hart (dvhltc@us.ibm.com) wrote:
> On 06/25/2010 12:20 PM, Oleg Nesterov wrote:
>> Hello.
>>
>
> Hi Oleg,
>
>> Another stupid question about the trivial problem I am going to ask,
>> just to report the authoritative answer back to bugzilla. The problem
>> is, personally I am not sure we should/can add the user-visible change
>> required by glibc maintainers, and I am in no position to suggest them
>> to fix the user-space code instead.
>>
>> In short, glibc developers believe that sys_futex(ts) is buggy and
>> needs the fix to return -ETIMEDOUT instead of -EINVAL in case when
>> ts->tv_sec<  0 and the timeout is absolute.
>>
>
> Just a question of semantics I guess. Seems reasonable to me to call a  
> negative timeout invalid. However, I certainly don't feel strongly  
> enough about it to fight for it. Glibc is the principle user of  
> sys_futex(). While there are certainly other users out there (Mathieu  
> Desnoyers' Userspace RCU comes to mind), I doubt any of them depend on  
> -EINVAL for negative timeouts to function properly.

Userspace RCU does not use futex timeouts (the parameter is always NULL). So
this change/fix won't have any effect as far as urcu is concerned.

Thanks,

Mathieu

>
> Unless there is some good reason to object to breaking the API that I am  
> missing, I don't mind changing it to -ETIMEDOUT (although -EINVAL seems  
> more intuitive to me).
>
> --
> Darren "Little Fish" Hart
>
>> Ignoring the possible cleanups/microoptimizations, something like this:
>>
>> --- x/kernel/futex.c
>> +++ x/kernel/futex.c
>> @@ -2625,6 +2625,16 @@ SYSCALL_DEFINE6(futex, u32 __user *, uad
>>   		      cmd == FUTEX_WAIT_REQUEUE_PI)) {
>>   		if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
>>   			return -EFAULT;
>> +
>> +		// absolute timeout
>> +		if (cmd != FUTEX_WAIT) {
>> +			if (ts->tv_nsec>= NSEC_PER_SEC)
>> +				return -EINVAL;
>> +			if (ts->tv_sec<  0)
>> +				return -ETIMEDOUT;
>> +		}
>> +
>> +
>>   		if (!timespec_valid(&ts))
>>   			return -EINVAL;
>>
>> ------------------------------------------------------------------------
>>
>> Otherwise, pthread_rwlock_timedwrlock(ts) hangs spinning in user-space
>> forever if ts->tv_sec<  0.
>>
>> To clarify: this depends on libc version and arch.
>>
>> This happens because pthread_rwlock_timedwrlock(rwlock, ts) on x86_64
>> roughly does:
>>
>> 	for (;;) {
>> 		if (fast_path_succeeds(rwlock))
>> 			return 0;
>>
>> 		if (ts->tv_nsec>= NSEC_PER_SEC)
>> 			return EINVAL;
>>
>> 		errcode = sys_futex(FUTEX_WAIT_BITSET_PRIVATE, ts);
>> 		if (errcode == ETIMEDOUT)
>> 			return ETIMEDOUT;
>> 	}
>>
>> and since the kernel return EINVAL due to !timespec_valid(ts), the
>> code above loops forever.
>>
>> (btw, we have same problem with EFAULT, and this is considered as
>>   a caller's problem).
>>
>> IOW, pthread_rwlock_timedwrlock() assumes that in this case
>> sys_futex() can return nothing interesting except 0 or ETIMEDOUT.
>> I guess pthread_rwlock_timedwrlock() is not alone, but I didn't check.
>>
>>
>>
>> So, the question: do you think we can change sys_futex() to make
>> glibc happy?
>>
>> Or, do you think it is user-space who should check tv_sec<  0 if
>> it wants ETIMEDOUT with the negative timeout ?
>>
>> Thanks,
>>
>> Oleg.
>>
>
>
> -- 
> Darren Hart
> IBM Linux Technology Center
> Real-Time Linux Team

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
