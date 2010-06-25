Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab0FYTnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 15:43:15 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36429 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab0FYTnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 15:43:13 -0400
Message-ID: <4C2506C3.2000301@us.ibm.com>
Date: Fri, 25 Jun 2010 12:42:59 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andreas Schwab <schwab@redhat.com>, Danny Feng <dfeng@redhat.com>,
       Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: Q: sys_futex() && timespec_valid()
References: <20100625192008.GA25337@redhat.com>
In-Reply-To: <20100625192008.GA25337@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2010 12:20 PM, Oleg Nesterov wrote:
> Hello.
>

Hi Oleg,

> Another stupid question about the trivial problem I am going to ask,
> just to report the authoritative answer back to bugzilla. The problem
> is, personally I am not sure we should/can add the user-visible change
> required by glibc maintainers, and I am in no position to suggest them
> to fix the user-space code instead.
>
> In short, glibc developers believe that sys_futex(ts) is buggy and
> needs the fix to return -ETIMEDOUT instead of -EINVAL in case when
> ts->tv_sec<  0 and the timeout is absolute.
>

Just a question of semantics I guess. Seems reasonable to me to call a 
negative timeout invalid. However, I certainly don't feel strongly 
enough about it to fight for it. Glibc is the principle user of 
sys_futex(). While there are certainly other users out there (Mathieu 
Desnoyers' Userspace RCU comes to mind), I doubt any of them depend on 
-EINVAL for negative timeouts to function properly.

Unless there is some good reason to object to breaking the API that I am 
missing, I don't mind changing it to -ETIMEDOUT (although -EINVAL seems 
more intuitive to me).

--
Darren "Little Fish" Hart

> Ignoring the possible cleanups/microoptimizations, something like this:
>
> --- x/kernel/futex.c
> +++ x/kernel/futex.c
> @@ -2625,6 +2625,16 @@ SYSCALL_DEFINE6(futex, u32 __user *, uad
>   		      cmd == FUTEX_WAIT_REQUEUE_PI)) {
>   		if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
>   			return -EFAULT;
> +
> +		// absolute timeout
> +		if (cmd != FUTEX_WAIT) {
> +			if (ts->tv_nsec>= NSEC_PER_SEC)
> +				return -EINVAL;
> +			if (ts->tv_sec<  0)
> +				return -ETIMEDOUT;
> +		}
> +
> +
>   		if (!timespec_valid(&ts))
>   			return -EINVAL;
>
> ------------------------------------------------------------------------
>
> Otherwise, pthread_rwlock_timedwrlock(ts) hangs spinning in user-space
> forever if ts->tv_sec<  0.
>
> To clarify: this depends on libc version and arch.
>
> This happens because pthread_rwlock_timedwrlock(rwlock, ts) on x86_64
> roughly does:
>
> 	for (;;) {
> 		if (fast_path_succeeds(rwlock))
> 			return 0;
>
> 		if (ts->tv_nsec>= NSEC_PER_SEC)
> 			return EINVAL;
>
> 		errcode = sys_futex(FUTEX_WAIT_BITSET_PRIVATE, ts);
> 		if (errcode == ETIMEDOUT)
> 			return ETIMEDOUT;
> 	}
>
> and since the kernel return EINVAL due to !timespec_valid(ts), the
> code above loops forever.
>
> (btw, we have same problem with EFAULT, and this is considered as
>   a caller's problem).
>
> IOW, pthread_rwlock_timedwrlock() assumes that in this case
> sys_futex() can return nothing interesting except 0 or ETIMEDOUT.
> I guess pthread_rwlock_timedwrlock() is not alone, but I didn't check.
>
>
>
> So, the question: do you think we can change sys_futex() to make
> glibc happy?
>
> Or, do you think it is user-space who should check tv_sec<  0 if
> it wants ETIMEDOUT with the negative timeout ?
>
> Thanks,
>
> Oleg.
>


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
