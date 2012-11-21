Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab2KVTCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:02:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:54021 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908Ab2KVTCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:02:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,295,1352102400"; 
   d="scan'208";a="252615567"
Message-ID: <50AD6543.1050501@linux.intel.com>
Date: Wed, 21 Nov 2012 15:35:31 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Kacur <jkacur@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] futex: Avoid wake_futex for a PI futex_q
References: <3b25c8ba053760892871713ff6e81660433f6734.1353483196.git.dvhart@linux.intel.com> <20121121143454.d72866e8.akpm@linux-foundation.org>
In-Reply-To: <20121121143454.d72866e8.akpm@linux-foundation.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/21/2012 02:34 PM, Andrew Morton wrote:
> On Tue, 20 Nov 2012 23:36:45 -0800
> Darren Hart <dvhart@linux.intel.com> wrote:
> 
>> Dave Jones reported a bug with futex_lock_pi() that his trinity test
>> exposed. Sometime between queue_me() and taking the q.lock_ptr, the
>> lock_ptr became NULL, resulting in a crash.
>>
>> While futex_wake() is careful to not call wake_futex() on futex_q's with
>> a pi_state or an rt_waiter (which are either waiting for a
>> futex_unlock_pi() or a PI futex_requeue()), futex_wake_op() and
>> futex_requeue() do not perform the same test.
>>
>> Update futex_wake_op() and futex_requeue() to test for q.pi_state and
>> q.rt_waiter and abort with -EINVAL if detected. To ensure any future
>> breakage is caught, add a WARN() to wake_futex() if the same condition
>> is true.
>>
>> This fix has seen 3 hours of testing with "trinity -c futex" on an
>> x86_64 VM with 4 CPUS.
>>
>> ...
>>
>> --- a/kernel/futex.c
>> +++ b/kernel/futex.c
>> @@ -840,6 +840,11 @@ static void wake_futex(struct futex_q *q)
>>  {
>>  	struct task_struct *p = q->task;
>>  
>> +	if (q->pi_state || q->rt_waiter) {
>> +		WARN(1, "%s: refusing to wake PI futex\n", __FUNCTION__);
>> +		return;
>> +	}
> 
> There's no need to display __FUNCTION__ because WARN() gives a
> backtrace, and we can more neatly use the WARN() return value:
> 
> --- a/kernel/futex.c~futex-avoid-wake_futex-for-a-pi-futex_q-fix
> +++ a/kernel/futex.c
> @@ -843,10 +843,8 @@ static void wake_futex(struct futex_q *q
>  {
>  	struct task_struct *p = q->task;
>  
> -	if (q->pi_state || q->rt_waiter) {
> -		WARN(1, "%s: refusing to wake PI futex\n", __FUNCTION__);
> +	if (WARN(q->pi_state || q->rt_waiter, "refusing to wake PI futex\n"))
>  		return;
> -	}

Thanks, that's better. Duh. That block of code used to be a lot more
complex during my debug sessions, I should have caught that and boiled
it down one step further.

--
Darren


>  
>  	/*
>  	 * We set q->lock_ptr = NULL _before_ we wake up the task. If
> _
> 
>>
>> ...
>>

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
