Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab0IKT5L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 15:57:11 -0400
Received: from mail.openrapids.net ([64.15.138.104]:58572 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751379Ab0IKT5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 15:57:10 -0400
Date: Sat, 11 Sep 2010 15:57:08 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
	nr_running
Message-ID: <20100911195708.GA9273@Krystal>
References: <20100911173732.551632040@efficios.com> <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284231470.2251.52.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:44:16 up 231 days, 22:21,  5 users,  load average: 0.00, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Sat, 2010-09-11 at 13:37 -0400, Mathieu Desnoyers wrote:
> 
> Its not at all clear what or why you're doing what exactly.
> 
> What we used to have is:
> 
>   period -- time in which each task gets scheduled once
> 
> This period was adaptive in that we had an ideal period
> (sysctl_sched_latency), but since keeping to this means that each task
> gets latency/nr_running time. This is undesired in that it means busy
> systems will over-schedule due to tiny slices. Hence we also had a
> minimum slice (sysctl_sched_min_granularity).
> 
> This yields:
> 
>   period := max(sched_latency, nr_running * sched_min_granularity)
> 
> [ where we introduce the intermediate: 
> 	nr_latency := sched_latency / sched_min_granularity
>   in order to avoid the multiplication where possible ]
> 
> Now you introduce a separate preemption measure, sched_gran as:
> 
> 		  sched_std_granularity; nr_running <= 8
>   sched_gran := {
> 		  max(sched_min_granularity, sched_latency / nr_running)
> 
> Which doesn't make any sense at all, because it will either be larger or
> as large as the current sched_min_granularity.
> 
> And you break the above definition of period by replacing nr_latency by
> 8.
> 
> Not at all charmed, this look like random changes without conceptual
> integrity.

Err.. I think the preemption measure you are describing does not match my code,
so let's try to figure this one out. Here is what I am doing:

nr_latency is still 3.
I introduce nr_latency_max (8).

sched_min_granularity is now sched_latency / nr_latency_max
sched_std_granularity is sched_latency / nr_latency

sched_std_granularity is the granularity effective when there are 3 tasks or
less running. This is the exact same behavior as the current kernel.

For more than 8 tasks, the behavior is the same as the current kernel (we
increase the scheduling period, ergo the latency); we are using the new
"sched_min_granularity" (which is now sched_latency / 8 rather than
sched_latency /3).

The interesting part is in the range from 4 to 8 tasks. I diminish the scheduler
granularity as the number of tasks increases rather than increasing latency.
This leads to more scheduler preemptions than usual, but only in the 4-8 running
tasks range.

We could possibly fine-tune nr_latency_max to a value that would keep an
appropriate sched_min_granularity (that would not cause an insane rate of
scheduler events).

The major interest in the approach I propose (rather than just increasing
nr_latency and decreasing sched_min_granularity) is that I don't have to change
the scheduler granularity when there are only few tasks running. So the extra
scheduler overhead is only taken when we are running more tasks.

I hope my explanation clarifies things a bit,

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
