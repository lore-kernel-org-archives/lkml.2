Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab1DNUpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:45:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:39194 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab1DNUpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:45:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,213,1301900400"; 
   d="scan'208";a="419421336"
Message-ID: <4DA75CEC.70802@linux.intel.com>
Date: Thu, 14 Apr 2011 13:45:32 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH V2] futex: set FLAGS_HAS_TIMEOUT during demux for FUTEX_WAIT
References: <1302800949.3248.42.camel@edumazet-laptop>	 <6aed1a53d080a90672bd44b773079dd81ac90b50.1302806742.git.dvhart@linux.intel.com>	 <1302807391.2744.6.camel@edumazet-laptop>	 <4DA746C5.1080804@linux.intel.com> <1302810514.2744.39.camel@edumazet-laptop>
In-Reply-To: <1302810514.2744.39.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2011 12:48 PM, Eric Dumazet wrote:
> Le jeudi 14 avril 2011 à 12:11 -0700, Darren Hart a écrit :
> 
>> I would say anything calling SYS_FUTEX is the futex slow path. The fast
>> path is cmpxchg in user space.
>>
> 
> Thats not a good reason to make it slower than necessary...
> 
>> It was. My thinking was that it was inconsistent to have the
>> FLAGS_HAS_TIMEOUT only available if a signal was received and a restart
>> was required. This is the only place it is currently needed, but the
>> inconsistency concerns me.
>>
> 
> I dont call this inconsistency, but right place for the code.
> 
>> How about the following, it reuses an existing if block and ensure the
>> FLAGS_HAS_TIMEOUT is always set if a timeout is used. It means the
>> FLAG_HAS_TIMEOUT is not available in the other futex_* routines with
>> timeouts (futex_lock_pi and futex_wait_requeue_pi), but they use absolute
>> timeouts and don't need it for restart - I can agree to that, although
>> I'm not keen on FLAG_HAS_TIMEOUT not being set whenever timeout is. That
>> could be added in the same way to the other functions if needed in the
>> future.
> 
> I dont understand why you insist setting in fast path a flag that is
> useless, unless we hit restart logic [ What I call the slow path in
> futex syscall ]

I'm not particularly attached to this approach, I just felt it made more
sense. Your initial objection was to the test in the do_futex(), so I
avoided the test by moving it into futex_wait().

The addition of an |= to an existing test block didn't seem significant
to me in this path. But, it isn't important enough to me to argue the point.

> 
> It seems more natural and efficient to me to go back to previous code.
> 
> Maybe rename FLAG_HAS_TIMEOUT to FLAG_HAS_TIMEOUT_ON_RESTART if you
> want, to make clear what is the meaning of this flag.
> 
> Now if you have plans to use this flag in futex code, outside of restart
> logic, please share them with us :)

Nope, no plans, and there is value in simply restoring the original
behavior, especially as this should go to stable as well. I've
resubmitted the patch with the "restart-block only approach" and
included "stable".

Thanks for the feedback,

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
