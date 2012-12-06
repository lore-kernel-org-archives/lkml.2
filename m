Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965059Ab2LFKq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 05:46:26 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:44736 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965047Ab2LFKqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 05:46:24 -0500
MIME-Version: 1.0
In-Reply-To: <50C00D41.1010800@intel.com>
References: <CAGjg+kFZ2+tzxOS4SVo3PTzEDJJ=B0gZJ0aEOhNHvTycFuVT6Q@mail.gmail.com>
 <50C00D41.1010800@intel.com>
From: Paul Turner <pjt@google.com>
Date: Thu, 6 Dec 2012 02:45:54 -0800
Message-ID: <CAPM31RKV-2arH6Jd+6XE0PyeicPJzWkuJ__A9XBj0VHaYCesDQ@mail.gmail.com>
Subject: Re: weakness of runnable load tracking?
To: Alex Shi <alex.shi@intel.com>
Cc: Alex Shi <lkml.alex@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 5, 2012 at 7:13 PM, Alex Shi <alex.shi@intel.com> wrote:
> On 12/05/2012 11:19 PM, Alex Shi wrote:
>> Hi Paul&Ingo:
>>
>> Runnable load tracking patch set introduce a good way to tracking each
>> entity/rq's running time.
>> But when I try to enable it in load balance, I found burst forking
>> many new tasks will make just few cpu heavy while other cpu has no
>> much task assigned. That is due to the new forked task's
>> load_avg_contrib is zero after just created. then no matter how many
>> tasks assigned to a CPU can not increase the cfs_rq->runnable_load_avg
>> or rq->avg.load_avg_contrib if this cpu idle.
>> Actually, if just for new task issue, we can set new task's initial
>> load_avg same as load_weight. but if we want to burst wake up many
>> long time sleeping tasks, it has the same issue here since their were
>> decayed to zero. So what solution I can thought is recording the se's
>> load_avg_contrib just before dequeue, and don't decay the value, when
>> it was waken up, add this value to new cfs_rq. but if so, the runnable
>> load tracking is total meaningless.
>> So do you have some idea of burst wakeup balancing with runnable load tracking?
>
> Hi Paul & Ingo:
>
> In a short word of this issue: burst forking/waking tasks have no time
> accumulate the load contribute, their runnable load are taken as zero.
> that make select_task_rq do a wrong decision on which group is idlest.

So these aren't strictly comparable; bursting and forking tasks have
fairly different characteristics here.

When we fork a task we intentionally reset the previous history.  This
means that a forked task that immediately runs is going to show up as
100% runnable and then converge to it's true value.  This was fairly
intentionally chosen so that tasks would "start" fast rather than
having to worry about ramp up.

The treatment of a burst wake-up however is a little more interesting.
 There are two reasonable trains of thought one can follow, the first
is that:
- If it IS truly bursty you don't really want it factoring into long
term averages since steady state is not going to include that task;
hence a low average is ok.  Anything that's more frequent then this is
going to show up by definition of being within the periods.
- The other is that if it truly is idle for _enormous_ amounts of time
we want to give some cognizance to the fact that it might be more
bursty when it wakes up.

It is my intuition that the greatest carnage here is actually caused
by wake-up load-balancing getting in the way of periodic in
establishing a steady state.  That these entities happen to not be
runnable very often is just a red herring; they don't contribute
enough load average to matter in the periodic case.  Increasing their
load isn't going to really help this -- stronger, you don't want them
affecting the steady state.  I suspect more mileage would result from
reducing the interference wake-up load-balancing has with steady
state.

e.g. One thing you can think about is considering tasks moved by
wake-up load balance as "stolen", and allow periodic load-balance to
re-settle things as if select_idle_sibling had not ignored it :-)

>
> There is still 3 kinds of solution is helpful for this issue.
>
> a, set a unzero minimum value for the long time sleeping task. but it
> seems unfair for other tasks these just sleep a short while.
>

I think this is  reasonable to do regardless, we set such a cap in the
cgroup case already.  Although you still obviously want this
threshhold to be fairly low.  I suspect this is a weak improvement.

> b, just use runnable load contrib in load balance. Still using
> nr_running to judge idlest group in select_task_rq_fair. but that may
> cause a bit more migrations in future load balance.

I don't think this is a good approach.  The whole point of using
blocked load is so that you can converge on a steady state where you
don't NEED to move tasks.  What disrupts this is we naturally prefer
idle cpus on wake-up balance to reduce wake-up latency.  As above, I
think the better answer is making these two processes more
co-operative.

>
> c, consider both runnable load and nr_running in the group: like in the
> searching domain, the nr_running number increased a certain number, like
> double of the domain span, in a certain time. we will think it's a burst
> forking/waking happened, then just count the nr_running as the idlest
> group criteria.

This feels like a bit of a hack.  I suspect this is more binary:

If there's already something running on all the cpus then we should
let the periodic load balancer do placement taking averages into
account.

Otherwise, we're in wake-idle and we throw the cat in the bathwater.

>
> IMHO, I like the 3rd one a bit more. as to the certain time to judge if
> a burst happened, since we will calculate the runnable avg at very tick,
> so if increased nr_running is beyond sd->span_weight in 2 ticks, means
> burst happening. What's your opinion of this?
>

What are you defining as the "right" behavior for a group of tasks
waking up that want to use only a short burst?

This seems to suggest you think spreading them is the best answer?
What's the motivation for that?  Also: What does your topology look
like that's preventing select_idle_sibling from pushing tasks (and
then new-idle subsequently continuing to pull)?

Certainly putting a lower bound on a tasks weight would help new-idle
find the right cpu to pull these from.

> Any comments are appreciated!
>
> Regards!
> Alex
>>
>>
>
