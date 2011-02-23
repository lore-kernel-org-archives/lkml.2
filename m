Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab1BWQHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 11:07:33 -0500
Received: from mga14.intel.com ([143.182.124.37]:4758 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab1BWQHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 11:07:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,212,1297065600"; 
   d="scan'208";a="392952113"
Message-ID: <4D6530BD.6000709@linux.intel.com>
Date: Wed, 23 Feb 2011 08:07:25 -0800
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
Content-Type: text/plain; charset=UTF-8; format=flowed
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
>
>> The reason I keep
>> coming back to RTPRIO is it allows the user to change to
>> SCHED_(FIFO|RR), and from there they can change to anything they want -
>
> Hmm,. is that so? I would think that even if you're SCHED_FIFO changing
> back to SCHED_OTHER ought to make you respect RLIMIT_NICE.
>
> That is, even if you're a SCHED_FIFO-1 task due to RLIMIT_RTPRIO, when
> you switch back to SCHED_OTHER I would expect you not to be able to
> switch to a lower nice than RLIMIT_NICE-20.
>
> Now, if this isn't actually so I think we ought to make it so.

I was just thinking in terms of POLICY, not priority or nice level. I'll 
do some experimenting and see where the limits are.

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

Will do.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
