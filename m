Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993Ab1DNTLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 15:11:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:22131 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932707Ab1DNTLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 15:11:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,212,1301900400"; 
   d="scan'208";a="909661886"
Message-ID: <4DA746C5.1080804@linux.intel.com>
Date: Thu, 14 Apr 2011 12:11:01 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH V2] futex: set FLAGS_HAS_TIMEOUT during demux for FUTEX_WAIT
References: <1302800949.3248.42.camel@edumazet-laptop>	 <6aed1a53d080a90672bd44b773079dd81ac90b50.1302806742.git.dvhart@linux.intel.com> <1302807391.2744.6.camel@edumazet-laptop>
In-Reply-To: <1302807391.2744.6.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/14/2011 11:56 AM, Eric Dumazet wrote:
> Le jeudi 14 avril 2011 à 11:45 -0700, Darren Hart a écrit :
>> The FLAGS_HAS_TIMEOUT flag was not getting set, causing the restart_block to
>> restart futex_wait() without a timeout after a signal.
>>
>> Commit b41277dc7a18ee332d in 2.6.38 introduced the regression by accidentally
>> removing the the FLAGS_HAS_TIMEOUT assignment from futex_wait() during the setup
>> of the restart block. It makes more sense to set the flag earlier during
>> do_futex() where the other flags are set, although futex_wait is the only user
>> of FLAGS_HAS_TIMEOUT as it is the only op using a relative timeout (an
>> unfortunately preexisting condition).
>>
>> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=32922
>>
>> V2: Added references to commit message.
>>
>> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
>> Reported-by: Tim Smith <tsmith201104@yahoo.com>
>> Reported-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> CC: Eric Dumazet <eric.dumazet@gmail.com>
>> CC: John Kacur <jkacur@redhat.com>
>> ---
>>  kernel/futex.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/futex.c b/kernel/futex.c
>> index bda4157..6eac6b6 100644
>> --- a/kernel/futex.c
>> +++ b/kernel/futex.c
>> @@ -2589,6 +2589,9 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
>>  			return -ENOSYS;
>>  	}
>>  
>> +	if (timeout)
>> +		flags |= FLAGS_HAS_TIMEOUT;
>> +
>>  	switch (cmd) {
>>  	case FUTEX_WAIT:
>>  		val3 = FUTEX_BITSET_MATCH_ANY;
> 
> 
> I dont agree with your fix. You add yet another test in futex fastpath.

I would say anything calling SYS_FUTEX is the futex slow path. The fast
path is cmpxchg in user space.

> 
> Prior commit  b41277dc7a18ee332d, this was done only in case of restart.

It was. My thinking was that it was inconsistent to have the
FLAGS_HAS_TIMEOUT only available if a signal was received and a restart
was required. This is the only place it is currently needed, but the
inconsistency concerns me.

> 
> Could we instead use 
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index dfb924f..fe28dc2 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -1886,7 +1886,7 @@ retry:
>  	restart->futex.val = val;
>  	restart->futex.time = abs_time->tv64;
>  	restart->futex.bitset = bitset;
> -	restart->futex.flags = flags;
> +	restart->futex.flags = flags | FLAGS_HAS_TIMEOUT;
>  
>  	ret = -ERESTART_RESTARTBLOCK;

How about the following, it reuses an existing if block and ensure the
FLAGS_HAS_TIMEOUT is always set if a timeout is used. It means the
FLAG_HAS_TIMEOUT is not available in the other futex_* routines with
timeouts (futex_lock_pi and futex_wait_requeue_pi), but they use absolute
timeouts and don't need it for restart - I can agree to that, although
I'm not keen on FLAG_HAS_TIMEOUT not being set whenever timeout is. That
could be added in the same way to the other functions if needed in the
future.


diff --git a/kernel/futex.c b/kernel/futex.c
index 6eac6b6..0a7eefd 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1846,6 +1846,7 @@ static int futex_wait(u32 __user *uaddr, unsigned int flags, u32 val,
 		hrtimer_init_sleeper(to, current);
 		hrtimer_set_expires_range_ns(&to->timer, *abs_time,
 					     current->timer_slack_ns);
+		flags |= FLAGS_HAS_TIMEOUT;
 	}
 
 retry:



-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
