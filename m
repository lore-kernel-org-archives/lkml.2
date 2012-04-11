Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760813Ab2DKRsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 13:48:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37597 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760774Ab2DKRsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 13:48:10 -0400
Message-ID: <4F85C3D4.4040804@gmail.com>
Date: Wed, 11 Apr 2012 19:48:04 +0200
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
        liming.wang@windriver.com, Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH 06/16] sched: SCHED_DEADLINE push and pull logic
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>  <1333696481-3433-7-git-send-email-juri.lelli@gmail.com> <1334165108.23924.275.camel@gandalf.stny.rr.com>
In-Reply-To: <1334165108.23924.275.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 07:25 PM, Steven Rostedt wrote:
> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
>>
>>   static void set_cpus_allowed_dl(struct task_struct *p,
>> @@ -622,10 +1346,145 @@ static void set_cpus_allowed_dl(struct task_struct *p,
>>
>>   	BUG_ON(!dl_task(p));
>>
>> +	/*
>> +	 * Update only if the task is actually running (i.e.,
>> +	 * it is on the rq AND it is not throttled).
>> +	 */
>> +	if (on_dl_rq(&p->dl)&&  (weight != p->dl.nr_cpus_allowed)) {
>> +		struct rq *rq = task_rq(p);
>> +
>> +		if (!task_current(rq, p)) {
>> +			/*
>> +			 * If the task was on the pushable list,
>> +			 * make sure it stays there only if the new
>> +			 * mask allows that.
>> +			 */
>> +			if (p->dl.nr_cpus_allowed>  1)
>> +				dequeue_pushable_dl_task(rq, p);
>> +
>> +			if (weight>  1)
>> +				enqueue_pushable_dl_task(rq, p);
>> +		}
>> +
>> +		if ((p->dl.nr_cpus_allowed<= 1)&&  (weight>  1)) {
>> +			rq->dl.dl_nr_migratory++;
>> +		} else if ((p->dl.nr_cpus_allowed>  1)&&  (weight<= 1)) {
>> +			BUG_ON(!rq->dl.dl_nr_migratory);
>> +			rq->dl.dl_nr_migratory--;
>> +		}
>> +
>> +		update_dl_migration(&rq->dl);
>
> Note, I'm in the process of testing this patch:
>
>   https://lkml.org/lkml/2012/4/11/7
>
> Just giving you a heads up, as this looks like you can benefit from this
> change as well.
>

Sure! I noticed it just today and started wondering how it would apply in
my case.
  
>
>> +	}
>> +
>>   	cpumask_copy(&p->cpus_allowed, new_mask);
>>   	p->dl.nr_cpus_allowed = weight;
>>   }
>> +
>
>

Thanks,

- Juri
