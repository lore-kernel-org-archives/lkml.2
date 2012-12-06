Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab2LFF6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 00:58:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61815 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab2LFF6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 00:58:07 -0500
Message-ID: <1354773465.4593.61.camel@marge.simpson.net>
Subject: Re: weakness of runnable load tracking?
From: Mike Galbraith <bitbucket@online.de>
To: Alex Shi <alex.shi@intel.com>
Cc: Alex Shi <lkml.alex@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>, Tejun Heo <tj@kernel.org>
Date: Thu, 06 Dec 2012 06:57:45 +0100
In-Reply-To: <50C00D41.1010800@intel.com>
References: <CAGjg+kFZ2+tzxOS4SVo3PTzEDJJ=B0gZJ0aEOhNHvTycFuVT6Q@mail.gmail.com>
	 <50C00D41.1010800@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:83fxapITu2CnZTUg8V+1UPWsThAxabMx33zKRPptvA1
 QdxdGk6xeUeKfcfNUGT6wz98fV082PScF9AvBd3ISfXKQN/kY3
 eaR5Ph10iI0QXR5F+fsOs5rnB6bOheuqmHzPCMm9JyYKXCHjpl
 57wVofC27hC21OJZT1nUuik7ylMBu3tc8V+G262OXX8kCLaD2X
 U0FmXkUn/btM4xGVUyXOh7793Q2+P+qHACGvOwnkvsX8bj1AGf
 ftYCwM7eHff+V8wnTZd5X+0Ty+Xc9cqRwNRpHqc9GwT0R3R+yj
 yuz7QU/CaQ3gg+Po0ErgJJmTUb85bqn0nrs8DaXCMOJeQwwxoE
 ocrbJc9MihBYOvYoEnyErD3T3S1luABZ4AV0GLZINI8GrzyglA
 J7rCd7QrXmvUw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-06 at 11:13 +0800, Alex Shi wrote: 
> On 12/05/2012 11:19 PM, Alex Shi wrote:
> > Hi Paul&Ingo:
> > 
> > Runnable load tracking patch set introduce a good way to tracking each
> > entity/rq's running time.
> > But when I try to enable it in load balance, I found burst forking
> > many new tasks will make just few cpu heavy while other cpu has no
> > much task assigned. That is due to the new forked task's
> > load_avg_contrib is zero after just created. then no matter how many
> > tasks assigned to a CPU can not increase the cfs_rq->runnable_load_avg
> > or rq->avg.load_avg_contrib if this cpu idle.
> > Actually, if just for new task issue, we can set new task's initial
> > load_avg same as load_weight. but if we want to burst wake up many
> > long time sleeping tasks, it has the same issue here since their were
> > decayed to zero. So what solution I can thought is recording the se's
> > load_avg_contrib just before dequeue, and don't decay the value, when
> > it was waken up, add this value to new cfs_rq. but if so, the runnable
> > load tracking is total meaningless.
> > So do you have some idea of burst wakeup balancing with runnable load tracking?
> 
> Hi Paul & Ingo:
> 
> In a short word of this issue: burst forking/waking tasks have no time
> accumulate the load contribute, their runnable load are taken as zero.
> that make select_task_rq do a wrong decision on which group is idlest.

As you pointed out above, new tasks can (and imho should) be born with
full weight.  Tasks _may_ become thin, but they're all born hungry.

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

IMHO, for fork and bursty wake balancing, the only thing meaningful is
the here and now state of runqueues tasks are being dumped into.

Just because tasks are historically short running, you don't necessarily
want to take a gaggle and wedge them into a too small group just to even
out load averages.  If there was a hole available that you passed up by
using average load, you lose utilization.  I can see how this load
tracking stuff can average out to a win on a ~heavily loaded box, but
bursty stuff I don't see how it can do anything but harm, so imho, the
user should choose which is best for his box, instantaneous or history.

WRT burst detection: any window you define can be longer than the burst.

$.02

-Mike

