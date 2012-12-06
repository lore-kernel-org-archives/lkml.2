Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964973Ab2LFIIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 03:08:40 -0500
Received: from mga14.intel.com ([143.182.124.37]:38826 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab2LFIIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 03:08:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,228,1355126400"; 
   d="scan'208";a="176857499"
Message-ID: <50C05201.7090900@intel.com>
Date: Thu, 06 Dec 2012 16:06:25 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: Alex Shi <lkml.alex@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Tejun Heo <tj@kernel.org>
Subject: Re: weakness of runnable load tracking?
References: <CAGjg+kFZ2+tzxOS4SVo3PTzEDJJ=B0gZJ0aEOhNHvTycFuVT6Q@mail.gmail.com>  <50C00D41.1010800@intel.com> <1354773465.4593.61.camel@marge.simpson.net>
In-Reply-To: <1354773465.4593.61.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> Hi Paul & Ingo:
>>
>> In a short word of this issue: burst forking/waking tasks have no time
>> accumulate the load contribute, their runnable load are taken as zero.
>> that make select_task_rq do a wrong decision on which group is idlest.
> 
> As you pointed out above, new tasks can (and imho should) be born with
> full weight.  Tasks _may_ become thin, but they're all born hungry.

Thanks for comments. I think so. :)
> 
>> There is still 3 kinds of solution is helpful for this issue.
>>
>> a, set a unzero minimum value for the long time sleeping task. but it
>> seems unfair for other tasks these just sleep a short while.
>>
>> b, just use runnable load contrib in load balance. Still using
>> nr_running to judge idlest group in select_task_rq_fair. but that may
>> cause a bit more migrations in future load balance.
>>
>> c, consider both runnable load and nr_running in the group: like in the
>> searching domain, the nr_running number increased a certain number, like
>> double of the domain span, in a certain time. we will think it's a burst
>> forking/waking happened, then just count the nr_running as the idlest
>> group criteria.
>>
>> IMHO, I like the 3rd one a bit more. as to the certain time to judge if
>> a burst happened, since we will calculate the runnable avg at very tick,
>> so if increased nr_running is beyond sd->span_weight in 2 ticks, means
>> burst happening. What's your opinion of this?
>>
>> Any comments are appreciated!
> 
> IMHO, for fork and bursty wake balancing, the only thing meaningful is
> the here and now state of runqueues tasks are being dumped into.
> 
> Just because tasks are historically short running, you don't necessarily
> want to take a gaggle and wedge them into a too small group just to even
> out load averages.  If there was a hole available that you passed up by
> using average load, you lose utilization.  I can see how this load
> tracking stuff can average out to a win on a ~heavily loaded box, but
> bursty stuff I don't see how it can do anything but harm, so imho, the
> user should choose which is best for his box, instantaneous or history.

Do you mean the system administrator need to do this choice?
It's may a hard decision.  :)
Any suggestions of decision basis?
> 
> WRT burst detection: any window you define can be longer than the burst.

Maybe we can define 2 waking on same cpu in 1 tick is a burst happened,
and if the cpu had taken a waking task. we'd better skip this cpu. :)
Anyway, the hard point is we can not predict future.


> 
> $.02
> 
> -Mike
> 

