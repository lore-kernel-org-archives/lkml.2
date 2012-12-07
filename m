Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423541Ab2LGCQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 21:16:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:9487 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964801Ab2LGCQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 21:16:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,234,1355126400"; 
   d="scan'208";a="227789994"
Message-ID: <50C150F7.5010808@intel.com>
Date: Fri, 07 Dec 2012 10:14:15 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Alex Shi <lkml.alex@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>, Tejun Heo <tj@kernel.org>
Subject: Re: weakness of runnable load tracking?
References: <CAGjg+kFZ2+tzxOS4SVo3PTzEDJJ=B0gZJ0aEOhNHvTycFuVT6Q@mail.gmail.com> <50C00D41.1010800@intel.com> <CAPM31RKV-2arH6Jd+6XE0PyeicPJzWkuJ__A9XBj0VHaYCesDQ@mail.gmail.com>
In-Reply-To: <CAPM31RKV-2arH6Jd+6XE0PyeicPJzWkuJ__A9XBj0VHaYCesDQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The treatment of a burst wake-up however is a little more interesting.
>  There are two reasonable trains of thought one can follow, the first
> is that:
> - If it IS truly bursty you don't really want it factoring into long
> term averages since steady state is not going to include that task;
> hence a low average is ok.  Anything that's more frequent then this is
> going to show up by definition of being within the periods.
> - The other is that if it truly is idle for _enormous_ amounts of time
> we want to give some cognizance to the fact that it might be more
> bursty when it wakes up.
> 
> It is my intuition that the greatest carnage here is actually caused
> by wake-up load-balancing getting in the way of periodic in
> establishing a steady state.  That these entities happen to not be
> runnable very often is just a red herring; they don't contribute
> enough load average to matter in the periodic case.  Increasing their
> load isn't going to really help this -- stronger, you don't want them
> affecting the steady state.  I suspect more mileage would result from
> reducing the interference wake-up load-balancing has with steady
> state.
> 
> e.g. One thing you can think about is considering tasks moved by
> wake-up load balance as "stolen", and allow periodic load-balance to
> re-settle things as if select_idle_sibling had not ignored it :-)

Consider the periodic load balance should spread tasks well, we can
assume the burst waking tasks are spread widely among all cpu before
their sleeping. That will relief the burst waking task imbalance.

And plus the uncertain utils of waking task, guess we can forget the
extra treatment for burst waking. If the waking tasks will keep running
long time. Let periodic LB to handle them again.
> 
>>
>> There is still 3 kinds of solution is helpful for this issue.
>>
>> a, set a unzero minimum value for the long time sleeping task. but it
>> seems unfair for other tasks these just sleep a short while.
>>
> 
> I think this is  reasonable to do regardless, we set such a cap in the
> cgroup case already.  Although you still obviously want this
> threshhold to be fairly low.  I suspect this is a weak improvement.

Agreed.
> 
>> b, just use runnable load contrib in load balance. Still using
>> nr_running to judge idlest group in select_task_rq_fair. but that may
>> cause a bit more migrations in future load balance.
> 
> I don't think this is a good approach.  The whole point of using
> blocked load is so that you can converge on a steady state where you
> don't NEED to move tasks.  What disrupts this is we naturally prefer
> idle cpus on wake-up balance to reduce wake-up latency.  As above, I
> think the better answer is making these two processes more
> co-operative.

Sure, instant load in fork/exec/waking will do interfere the later
periodic LB.
> 
>>
>> c, consider both runnable load and nr_running in the group: like in the
>> searching domain, the nr_running number increased a certain number, like
>> double of the domain span, in a certain time. we will think it's a burst
>> forking/waking happened, then just count the nr_running as the idlest
>> group criteria.
> 
> This feels like a bit of a hack.  I suspect this is more binary:
> 
> If there's already something running on all the cpus then we should
> let the periodic load balancer do placement taking averages into
> account.
> 
> Otherwise, we're in wake-idle and we throw the cat in the bathwater.

As like Mike said simple time is always not enough for 'burst'. So, it
will be approved to be a stupid optimising on some chance. :)
> 
>>
>> IMHO, I like the 3rd one a bit more. as to the certain time to judge if
>> a burst happened, since we will calculate the runnable avg at very tick,
>> so if increased nr_running is beyond sd->span_weight in 2 ticks, means
>> burst happening. What's your opinion of this?
>>
> 
> What are you defining as the "right" behavior for a group of tasks
> waking up that want to use only a short burst?
> 
> This seems to suggest you think spreading them is the best answer?
> What's the motivation for that?  Also: What does your topology look
> like that's preventing select_idle_sibling from pushing tasks (and
> then new-idle subsequently continuing to pull)?

Actually, I have no real story of the burst waking imbalance among cpus.

Considering above excuses, I will give up the optimizing on this. It's
not too late to reconsider this if some case is really triggered.
> 
> Certainly putting a lower bound on a tasks weight would help new-idle
> find the right cpu to pull these from.
> 
>> Any comments are appreciated!
>>
>> Regards!
>> Alex
>>>
>>>
>>

