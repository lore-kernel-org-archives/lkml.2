Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab2LFGxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 01:53:34 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:54078 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab2LFGxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 01:53:32 -0500
Message-ID: <50C040C3.5000408@linux.vnet.ibm.com>
Date: Thu, 06 Dec 2012 12:22:51 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: Alex Shi <lkml.alex@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>, Tejun Heo <tj@kernel.org>
Subject: Re: weakness of runnable load tracking?
References: <CAGjg+kFZ2+tzxOS4SVo3PTzEDJJ=B0gZJ0aEOhNHvTycFuVT6Q@mail.gmail.com> <50C00D41.1010800@intel.com>
In-Reply-To: <50C00D41.1010800@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120606-3864-0000-0000-000005DFB800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,
> Hi Paul & Ingo:
> 
> In a short word of this issue: burst forking/waking tasks have no time
> accumulate the load contribute, their runnable load are taken as zero.

On performing certain experiments on the way PJT's metric calculates the
load,I observed a few things.Based on these observations let me see if i
can address the issue of why PJT's metric is calculating the load of
bursty tasks as 0.

When we speak about a burst waking task(I will not go into forking
here),we should also speak about its duty cycle-it burst wakes for 1ms
for a 10ms duty cycle or burst wakes 9s out of a 10s duty cycle-both
being 10% tasks wrt their duty cycles.Lets see how load is calculated by
PJT's metric in each of the above cases.
           --
          |  |
          |  |
__________|  |
          A  B
          1ms
          <->
      10ms
<------------>
          Example 1

When the task wakes up at A,it is not yet runnable,and an update of the
task load takes place.Its runtime so far is 0,and its existing time is
10ms.Hence the load is 0/10*1024.Since a scheduler tick happens at B( a
scheduler tick happens for every 1ms,10ms or 4ms.Let us assume 1ms),an
update of the load takes place.PJT's metric divides the time elapsed
into 1ms windows.There is just 1ms window,and hence the runtime is 1ms
and the load is 1ms/10ms*1024.

*If the time elapsed between A and B were to be < 1ms,then PJT's metric
will not capture it*.

And under these circumstances the load remains 0/10ms*1024=0.This is the
situation you are pointing out.Let us assume that these cycle continues
throughout the lifetime of the load,then the load remains at 0.The
question is if such tasks which run for periods<1ms is ok to be termed
as 0 workloads.If it is fine,then what PJT's metric is doing is
right.Maybe we should ignore such workloads because they hardly
contribute to the load.Otherwise we will need to reduce the window of
load update to < 1ms to capture such loads.


Just for some additional info so that we know what happens to different
kinds of loads with PJT's metric,consider the below situation:
                             ------
                            |      |
                            |      |
____________________________|      |
                            A      B
                               1s
                            <------>
<----------------------------------->
      10s
<------------>
                           Example 2

Here at A,the task wakes,just like in Example1 and the load is termed 0.
In between A and B for every scheduler tick if we consider the load to
get updated,then the load slowly increases from 0 to 1024 at B.It is
1024 here,although this is also a 10% task,whereas in Example1 the load
is 102.4 - a 10% task.So what is fishy?

In my opinion,PJT's metric gives the tasks some time to prove their
activeness after they wake up.In Example2 the task has stayed awake too
long-1s; irrespective of what % of the total run time it is.Therefore it
calculates the load to be big enough to balance.

In the example that you have quoted,the tasks may not have run long
enough to consider them as candidates for load balance.

So,essentially what PJT's metric is doing is characterising a task by
the amount it has run so far.


> that make select_task_rq do a wrong decision on which group is idlest.
> 
> There is still 3 kinds of solution is helpful for this issue.
> 
> a, set a unzero minimum value for the long time sleeping task. but it
> seems unfair for other tasks these just sleep a short while.
> 
> b, just use runnable load contrib in load balance. Still using
> nr_running to judge idlest group in select_task_rq_fair. but that may
> cause a bit more migrations in future load balance.
> 
> c, consider both runnable load and nr_running in the group: like in the
> searching domain, the nr_running number increased a certain number, like
> double of the domain span, in a certain time. we will think it's a burst
> forking/waking happened, then just count the nr_running as the idlest
> group criteria.
> 
> IMHO, I like the 3rd one a bit more. as to the certain time to judge if
> a burst happened, since we will calculate the runnable avg at very tick,
> so if increased nr_running is beyond sd->span_weight in 2 ticks, means
> burst happening. What's your opinion of this?
> 
> Any comments are appreciated!


So Pjt's metric rightly seems to be capturing the load of these bursty
tasks but you are right in pointing out that when too many such loads
queue up on the cpu,this metric will consider the load on the cpu as
0,which might not be such a good idea.

It is true that we need to bring in nr_running somewhere.Let me now go
through your suggestions on where to include nr_running and get back on
this.I had planned on including nr_running while selecting the busy
group in update_sd_lb_stats,but select_task_rq_fair is yet another place
to do this, thats right.Good that this issue was brought up :)

> Regards!
> Alex
>>
>>
> 

Regards
Preeti U Murthy

