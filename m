Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab2DSNoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 09:44:30 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65390 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab2DSNo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 09:44:29 -0400
Message-ID: <4F9016B0.5060508@gmail.com>
Date: Thu, 19 Apr 2012 15:44:16 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Subject: Re: [PATCH 06/16] sched: SCHED_DEADLINE push and pull logic
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>  <1333696481-3433-7-git-send-email-juri.lelli@gmail.com> <1334160884.23924.260.camel@gandalf.stny.rr.com>
In-Reply-To: <1334160884.23924.260.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 06:14 PM, Steven Rostedt wrote:
> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
>
>> +static int latest_cpu_find(struct cpumask *span,
>> +			   struct task_struct *task,
>> +			   struct cpumask *later_mask)
>>   {
>> +	const struct sched_dl_entity *dl_se =&task->dl;
>> +	int cpu, found = -1, best = 0;
>> +	u64 max_dl = 0;
>> +
>> +	for_each_cpu(cpu, span) {
>> +		struct rq *rq = cpu_rq(cpu);
>> +		struct dl_rq *dl_rq =&rq->dl;
>> +
>> +		if (cpumask_test_cpu(cpu,&task->cpus_allowed)&&
>> +		    (!dl_rq->dl_nr_running || dl_time_before(dl_se->deadline,
>> +		     dl_rq->earliest_dl.curr))) {
>> +			if (later_mask)
>> +				cpumask_set_cpu(cpu, later_mask);
>> +			if (!best&&  !dl_rq->dl_nr_running) {
>
> I hate to say this (and I also have yet to look at the patches after
> this) but we should really take into account the RT tasks. It would suck
> to preempt a normal RT task when a non RT task is running on another
> CPU.

Well, this changes in 15/16, but your point remains, and I see it :-).
We are currently reworking the push/pull mechanism (15/16 will most probably
change as well) to speed it up. I agree that it would be nice to take into
accont RT tasks as well, so we'll surely think about it.
   
>> +				best = 1;
>> +				found = cpu;
>> +			} else if (!best&&
>> +				   dl_time_before(max_dl,
>> +						  dl_rq->earliest_dl.curr)) {
>> +				max_dl = dl_rq->earliest_dl.curr;
>> +				found = cpu;
>> +			}
>> +		} else if (later_mask)
>> +			cpumask_clear_cpu(cpu, later_mask);
>> +	}
>> +
>> +	return found;
>> +}
>
>

Thanks,

- Juri
