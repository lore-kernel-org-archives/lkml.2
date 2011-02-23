Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab1BWV2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:28:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:26979 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab1BWV2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:28:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,214,1297065600"; 
   d="scan'208";a="393124784"
Message-ID: <4D657BEE.4040608@linux.intel.com>
Date: Wed, 23 Feb 2011 13:28:14 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        richard.purdie@linuxfoundation.org
Subject: Re: [PATCH 2/2] sched: allow users with rtprio rlimit to change from
 SCHED_IDLE policy
References: <1298408674-3130-1-git-send-email-dvhart@linux.intel.com>	 <1298408674-3130-3-git-send-email-dvhart@linux.intel.com>	 <1298458989.2217.361.camel@twins>  <20110223111354.GB7448@elte.hu>	 <1298459826.2217.363.camel@twins>  <4D652D42.4040801@linux.intel.com> <1298476805.2217.791.camel@twins>
In-Reply-To: <1298476805.2217.791.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2011 08:00 AM, Peter Zijlstra wrote:
> On Wed, 2011-02-23 at 07:52 -0800, Darren Hart wrote:
>> On 02/23/2011 03:17 AM, Peter Zijlstra wrote:
>>> On Wed, 2011-02-23 at 12:13 +0100, Ingo Molnar wrote:
>>>> * Peter Zijlstra<peterz@infradead.org>   wrote:
>>>>
>>>>> On Tue, 2011-02-22 at 13:04 -0800, Darren Hart wrote:
>>>>>> As it stands, users with rtprio rlimit permissions can change their policy from
>>>>>> SCHED_OTHER to SCHED_FIFO and back. They can change to SCHED_IDLE, but not back
>>>>>> to SCHED_FIFO. If they have the rtprio permission, they should be able to. Once
>>>>>> in SCHED_FIFO, they could go back to SCHED_OTHER. This patch allows users with
>>>>>> rtprio permission to change out of SCHED_IDLE.
>>>>>>
>>>>>
>>>>> Ingo, can you remember the rationale for this?
>>>>>
>>>>> The fact is that SCHED_IDLE is very near nice-20, and we can do:
>>>>>
>>>>> peterz@twins:~$ renice 5 -p $$
>>>>> 1867: old priority 0, new priority 5
>>>>> peterz@twins:~$ renice 0 -p $$
>>>>> 1867: old priority 5, new priority 0
>>>>>
>>>>> Which would suggest that we should be able to return to SCHED_OTHER
>>>>> RLIMIT_NICE-20.
>>>>
>>>> I dont remember anything subtle there - most likely we just forgot about that spot
>>>> when adding RLIMIT_RTPRIO support.
>>>
>>> Ah, I was arguing we should allow it regardless of RLIMIT_RTPRIO, based
>>> on RLIMIT_NICE, it is after all a change to SCHED_OTHER, not
>>> SCHED_FIFO/RR.
>>
>> So we need an OR test of RLIMIT_NICE | RLIMIT_RTPRIO ?
> 
> Just RLIMIT_NICE I think.

Agreed.

> 
>> The reason I keep
>> coming back to RTPRIO is it allows the user to change to
>> SCHED_(FIFO|RR), and from there they can change to anything they want -
> 
> Hmm,. is that so? I would think that even if you're SCHED_FIFO changing
> back to SCHED_OTHER ought to make you respect RLIMIT_NICE.

You are correct, no gaps here.

> 
> That is, even if you're a SCHED_FIFO-1 task due to RLIMIT_RTPRIO, when
> you switch back to SCHED_OTHER I would expect you not to be able to
> switch to a lower nice than RLIMIT_NICE-20.
> 
> Now, if this isn't actually so I think we ought to make it so.
> 
>> so why force two steps? Perhaps the argument is to keep the meaning of
>> the RLIMITs precise, and if you want to go from IDLE->OTHER you had
>> better properly set RLIMIT_NICE - maybe I just convinced myself.
> 
> Right
> 
>> Shall I respin the patch to reflect that?
> 
> Please.

How about this:


>From b66e1a5b1e61476c1af0095f16c666b94664f7f0 Mon Sep 17 00:00:00 2001
From: Darren Hart <dvhart@linux.intel.com>
Date: Thu, 17 Feb 2011 15:37:07 -0800
Subject: [PATCH] sched: allow users with sufficient RLIMIT_NICE to change from SCHED_IDLE policy

The current scheduler implementation returns -EPERM when trying to change from
SCHED_IDLE to SCHED_OTHER or SCHED_BATCH. Since SCHED_IDLE is considered to be
equivalent to a nice 20, changing to another policy should be allowed provided
the RLIMIT_NICE is accounted for.

This patch allows the following test-case to pass with RLIMIT_NICE=40, but still
fail with RLIMIT_NICE=10 when the calling process is run from a typical shell
(nice 0, or 20 in rlimit terms).

int main()
{
	int ret;
	struct sched_param sp;
	sp.sched_priority = 0;

	/* switch to SCHED_IDLE */
	ret = sched_setscheduler(0, SCHED_IDLE, &sp);
	printf("setscheduler IDLE: %d\n", ret);
	if (ret) return ret;

	/* switch back to SCHED_OTHER */
	ret = sched_setscheduler(0, SCHED_OTHER, &sp);
	printf("setscheduler OTHER: %d\n", ret);

	return ret;
}

$ ulimit -e
40
$ ./test
setscheduler IDLE: 0
setscheduler OTHER: 0

$ ulimit -e 10
$ ulimit -e
10
$ ./test
setscheduler IDLE: 0
setscheduler OTHER: -1

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Richard Purdie <richard.purdie@linuxfoundation.org>
---
 kernel/sched.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 18d38e4..9bf6284 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4822,12 +4822,15 @@ recheck:
 			    param->sched_priority > rlim_rtprio)
 				return -EPERM;
 		}
+
 		/*
-		 * Like positive nice levels, dont allow tasks to
-		 * move out of SCHED_IDLE either:
+		 * Treat SCHED_IDLE as nice 20. Only allow a switch to
+		 * SCHED_NORMAL if the RLIMIT_NICE would normally permit it.
 		 */
-		if (p->policy == SCHED_IDLE && policy != SCHED_IDLE)
-			return -EPERM;
+		if (p->policy == SCHED_IDLE && policy != SCHED_IDLE) {
+			if (!can_nice(p, TASK_NICE(p)))
+				return -EPERM;
+		}
 
 		/* can't change other user's priorities */
 		if (!check_same_owner(p))
-- 
1.7.1


-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
