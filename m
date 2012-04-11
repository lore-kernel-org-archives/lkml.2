Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab2DKQYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:24:12 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56092 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab2DKQYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:24:11 -0400
Message-ID: <4F85B026.2080108@gmail.com>
Date: Wed, 11 Apr 2012 18:24:06 +0200
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
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>  <1333696481-3433-7-git-send-email-juri.lelli@gmail.com> <1334161298.23924.263.camel@gandalf.stny.rr.com>
In-Reply-To: <1334161298.23924.263.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 06:21 PM, Steven Rostedt wrote:
> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
>
>>   /*
>>    * Only called when both the current and waking task are -deadline
>>    * tasks.
>> @@ -487,8 +819,20 @@ static void yield_task_dl(struct rq *rq)
>>   static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p,
>>   				  int flags)
>>   {
>> -	if (dl_time_before(p->dl.deadline, rq->curr->dl.deadline))
>> +	if (dl_time_before(p->dl.deadline, rq->curr->dl.deadline)) {
>>   		resched_task(rq->curr);
>> +		return;
>> +	}
>> +
>> +#ifdef CONFIG_SMP
>> +	/*
>> +	 * In the unlikely case current and p have the same deadline
>> +	 * let us try to decide what's the best thing to do...
>> +	 */
>> +	if ((s64)(p->dl.deadline - rq->curr->dl.deadline) == 0&&
>> +	    !need_resched())
>
> OK, maybe I'm thick. But how is:
>
>    (s64)(p->dl.deadline - rq->curr->dl.deadline) == 0
>
> Better than:
>
>    p->dl.deadline == rq->curr->dl.deadline
>
> ?
>

I agree, will change.

>
>> +		check_preempt_equal_dl(rq, p);
>> +#endif /* CONFIG_SMP */
>>   }
>>
>
>


Thanks,

- Juri
