Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844Ab2LFDPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 22:15:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:62931 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964830Ab2LFDPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 22:15:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,227,1355126400"; 
   d="scan'208";a="257949564"
Message-ID: <50C00D41.1010800@intel.com>
Date: Thu, 06 Dec 2012 11:13:05 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Alex Shi <lkml.alex@gmail.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>, lkml <linux-kernel@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>, Tejun Heo <tj@kernel.org>,
        Alex Shi <alex.shi@intel.com>
Subject: Re: weakness of runnable load tracking?
References: <CAGjg+kFZ2+tzxOS4SVo3PTzEDJJ=B0gZJ0aEOhNHvTycFuVT6Q@mail.gmail.com>
In-Reply-To: <CAGjg+kFZ2+tzxOS4SVo3PTzEDJJ=B0gZJ0aEOhNHvTycFuVT6Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2012 11:19 PM, Alex Shi wrote:
> Hi Paul&Ingo:
> 
> Runnable load tracking patch set introduce a good way to tracking each
> entity/rq's running time.
> But when I try to enable it in load balance, I found burst forking
> many new tasks will make just few cpu heavy while other cpu has no
> much task assigned. That is due to the new forked task's
> load_avg_contrib is zero after just created. then no matter how many
> tasks assigned to a CPU can not increase the cfs_rq->runnable_load_avg
> or rq->avg.load_avg_contrib if this cpu idle.
> Actually, if just for new task issue, we can set new task's initial
> load_avg same as load_weight. but if we want to burst wake up many
> long time sleeping tasks, it has the same issue here since their were
> decayed to zero. So what solution I can thought is recording the se's
> load_avg_contrib just before dequeue, and don't decay the value, when
> it was waken up, add this value to new cfs_rq. but if so, the runnable
> load tracking is total meaningless.
> So do you have some idea of burst wakeup balancing with runnable load tracking?

Hi Paul & Ingo:

In a short word of this issue: burst forking/waking tasks have no time
accumulate the load contribute, their runnable load are taken as zero.
that make select_task_rq do a wrong decision on which group is idlest.

There is still 3 kinds of solution is helpful for this issue.

a, set a unzero minimum value for the long time sleeping task. but it
seems unfair for other tasks these just sleep a short while.

b, just use runnable load contrib in load balance. Still using
nr_running to judge idlest group in select_task_rq_fair. but that may
cause a bit more migrations in future load balance.

c, consider both runnable load and nr_running in the group: like in the
searching domain, the nr_running number increased a certain number, like
double of the domain span, in a certain time. we will think it's a burst
forking/waking happened, then just count the nr_running as the idlest
group criteria.

IMHO, I like the 3rd one a bit more. as to the certain time to judge if
a burst happened, since we will calculate the runnable avg at very tick,
so if increased nr_running is beyond sd->span_weight in 2 ticks, means
burst happening. What's your opinion of this?

Any comments are appreciated!

Regards!
Alex
> 
> 

