Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab2JSESI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 00:18:08 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:53538 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758164Ab2JSESF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 00:18:05 -0400
Message-ID: <5080D451.5090409@linux.vnet.ibm.com>
Date: Fri, 19 Oct 2012 09:47:21 +0530
From: preeti <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Morten Rasmussen <Morten.Rasmussen@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        paul.mckenney@linaro.org, linaro-dev@lists.linaro.org,
        paulmck@linux.vnet.ibm.com, venki@google.com, mingo@redhat.com,
        arjan@linux.intel.com, "peterz@infradead.org" <peterz@infradead.org>,
        suresh.b.siddha@intel.com, viresh.kumar@linaro.org,
        linaro-sched-sig@lists.linaro.org, Arvind.Chauhan@arm.com,
        robin.randhawa@arm.com, amit.kucheria@linaro.org,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
        akpm@linux-foundation.org, vincent.guittot@linaro.org,
        tglx@linutronix.de, mjg59@srcf.ucam.org,
        linux-arm-kernel@lists.infradead.org, preeti@linux.vnet.ibm.com,
        "pjt@google.com" <pjt@google.com>, deepthi@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/2] sched: Load Balancing using Per-entity-Load-tracking
References: <20121012044618.18271.88332.stgit@preeti.in.ibm.com> <20121018172609.GA14473@e103034-lin>
In-Reply-To: <20121018172609.GA14473@e103034-lin>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
x-cbid: 12101904-3864-0000-0000-000005226F27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Morten,
Thank you very much for your review.

>> 1.Consider a scenario,where there are two 10% tasks running on a cpu.The
>>   present code will consider the load on this queue to be 2048,while
>>   using PJT's metric the load is calculated to be <1000,rarely exceeding this
>>   limit.Although the tasks are not contributing much to the cpu load,they are
>>   decided to be moved by the scheduler.
> 
> I guess that you assume, for now, that all tasks have default (nice 0)
> priority? Both the old load and the PJT metric (tracked load) depends on
> priority.
Thats right.I have assumed default priority of the tasks.
> 
>>
>>   But one could argue that 'not moving one of these tasks could throttle
>>   them.If there was an idle cpu,perhaps we could have moved them'.While the
>>   power save mode would have been fine with not moving the task,the
>>   performance mode would prefer not to throttle the tasks.We could strive
>>   to strike a balance by making this decision tunable with certain parameters.
>>   This patchset includes such tunables.This issue is addressed in Patch[1/2].
>>
> 
> One could also argue that long as there are spare cpu cycles in each
> schedule period then all tasks have received the cpu time they needed.
> So from that point of view performance isn't affected by not balancing
> the tasks as long as the cpu is not fully utilized. If we look at the
> problem from a latency point of view then packing tasks on a single cpu
> will increase latency but the increase will be bounded by the schedule
> period.
> 
Assume that at the end of one scheduling period,there are a few spare
cycles on the cpu.this is fine from both the performance and latency
point of view at *this* point.nobody is waiting for the cpu.

The issue arises if it is detected that these spare cycles are due to
*sleeping tasks* and not due to no tasks.

At this point a decision needs to be made as to: if a scenario arises
where all these tasks wake up at the same time in the future,and wait on
the cpu,then are we ok with them waiting.Both performance and latency
views could be against this,as this also means less throughput.But
performance view could go slightly easy on this to argue,that its ok if
2-3 tasks wait,if more,then there is a need to move them.
>>   This patchset therefore has two primary aims.
>>          Patch[1/2]: This patch aims at detecting short running tasks and
>> 	 prevent their movement.In update_sg_lb_stats,dismiss a sched group
>> 	 as a candidate for load balancing,if load calculated by PJT's metric
>> 	 says that the average load on the sched_group <= 1024+(.15*1024).
>> 	 This is a tunable,which can be varied after sufficient experiments.
> 
> Your current threshold implies that there must be at least two (nice 0)
> tasks running breach the threshold and they need to be quite busy. This
> makes sense to me. When you have more tasks they are more likely to be
> waiting on the runqueue even if it is only 10% tasks. Let's say you have
> five 10% tasks and they all become runnable at the same instant. In that
> case some of the tasks would have a tracked load which is much higher
> than if we only had two 10% tasks running. So if I'm not mistaken, it
> would be possible to breach the threshold even though the overall cpu
> utilization is only 50% and it would have been safe not to load-balance
> that cpu.
> 
> Do you think it would make sense to let the threshold depend on the
> number of task on the cpu somehow? 

You are right,Morten.In fact I have included this viewpoint in both my
first and second patch enclosed by this. So lets take up the above
scenario.if there are 5 10% tasks running,they will surely cross the
threshold,but the cpu might have spare cycles at the end of a scheduling
period.Now that is your concern.

Again we have two different viewpoints.This threshold is like a tuning
knob.we could increase it if we feel that this threshold gets reached
very quickly with as few tasks as 5, although the cpu utilization is
poor.we prefer not to wake up another cpu unless the present cpu is
aptly loaded.we could call this the power saving view.

Else we could say that,we are not intending to affect the throughput of
tasks,so we prefer the knob be at this value,so that we qualify such a
load as a candidate for load balancing.we could call this the
performance view.
> 
> Alternative, the decision could be based on the cpu idle time over the
> last schedule period. A cpu with no or very few spare cycles in the last
> schedule period would be a good candidate for load-balancing. Latency
> would be affected as mentioned earlier.
> 
Exactly.idle_time == spare_cpu_cycles == less cpu_utilization.I hope i
am not wrong in drawing this equivalence.if thats the case then the same
explanation as above holds good here too.
> 
> Morten

Thank you

Regards
Preeti

