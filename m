Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab1DOOHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 10:07:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:1507 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425Ab1DOOHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 10:07:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,219,1301900400"; 
   d="scan'208";a="910080099"
Message-ID: <4DA85114.3010501@linux.intel.com>
Date: Fri, 15 Apr 2011 07:07:16 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Kacur <jkacur@redhat.com>, stable@kernel.org
Subject: Re: [PATCH V5] futex: set FLAGS_HAS_TIMEOUT during futex_wait restart
 setup
References: <daac0eb3af607f72b9a4d3126b2ba8fb5ed3b883.1302820917.git.dvhart@linux.intel.com> <alpine.LFD.2.00.1104151027260.2744@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1104151027260.2744@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/15/2011 01:33 AM, Thomas Gleixner wrote:
> On Thu, 14 Apr 2011, Darren Hart wrote:
> 
>> The FLAGS_HAS_TIMEOUT flag was not getting set, causing the restart_block to
>> restart futex_wait() without a timeout after a signal.
>>
>> Commit b41277dc7a18ee332d in 2.6.38 introduced the regression by accidentally
>> removing the the FLAGS_HAS_TIMEOUT assignment from futex_wait() during the setup
>> of the restart block. Restore the originaly behavior.
>>
>> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=32922
>>
>> V2: Added references to commit message.
>> V3: Set flag during restart block instead of do_futex()
>> V4: Correct stupid order of assignment mistake pointed out by Eric
>> V5: Correct subject to match implementation, correct stable submission
>>
>> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
>> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
>> Reported-by: Tim Smith <tsmith201104@yahoo.com>
>> Reported-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: John Kacur <jkacur@redhat.com>
>> Cc: stable@kernel.org
>> ---
>>  kernel/futex.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/futex.c b/kernel/futex.c
>> index bda4157..abd5324 100644
>> --- a/kernel/futex.c
>> +++ b/kernel/futex.c
>> @@ -1886,7 +1886,7 @@ retry:
>>  	restart->futex.val = val;
>>  	restart->futex.time = abs_time->tv64;
>>  	restart->futex.bitset = bitset;
>> -	restart->futex.flags = flags;
>> +	restart->futex.flags = flags | FLAGS_HAS_TIMEOUT;
> 
> We only get here when a timeout is pending. So why don't we just do
> the obvious:
> 
> --- linux-2.6.orig/kernel/futex.c
> +++ linux-2.6/kernel/futex.c
> @@ -1902,16 +1902,13 @@ out:
>  static long futex_wait_restart(struct restart_block *restart)
>  {
>  	u32 __user *uaddr = restart->futex.uaddr;
> -	ktime_t t, *tp = NULL;
> +	ktime_t t;
>  
> -	if (restart->futex.flags & FLAGS_HAS_TIMEOUT) {
> -		t.tv64 = restart->futex.time;
> -		tp = &t;
> -	}
> +	t.tv64 = restart->futex.time;
>  	restart->fn = do_no_restart_syscall;
>  
>  	return (long)futex_wait(uaddr, restart->futex.flags,
> -				restart->futex.val, tp, restart->futex.bitset);
> +				restart->futex.val, &t, restart->futex.bitset);
>  }

I believe I asked you the same question when I was adding the
FLAGS_HAS_TIMEOUT. :-) The problem is distinguishing between no timeout
and an expired timer. The above always passes a non-null address for
abs_time to futex_wait(), which will then always schedule a timer.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
