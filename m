Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab2DHSJn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 14:09:43 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45571 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab2DHSJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 14:09:42 -0400
Message-ID: <4F81D45D.80509@gmail.com>
Date: Sun, 08 Apr 2012 20:09:33 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, cfriesen@nortel.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Subject: Re: [PATCH 01/16] sched: add sched_class->task_dead.
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com> <1333696481-3433-2-git-send-email-juri.lelli@gmail.com> <20120408174919.GA28428@redhat.com>
In-Reply-To: <20120408174919.GA28428@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2012 07:49 PM, Oleg Nesterov wrote:
> On 04/06, Juri Lelli wrote:
>>
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -3219,6 +3219,9 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
>>   	if (mm)
>>   		mmdrop_delayed(mm);
>>   	if (unlikely(prev_state == TASK_DEAD)) {
>> +		if (prev->sched_class->task_dead)
>> +			prev->sched_class->task_dead(prev);
>> +
>
> And 5/16 adds
>
> 	+static void task_dead_dl(struct task_struct *p)
> 	+{
> 	+       struct hrtimer *timer =&p->dl.dl_timer;
> 	+
> 	+	if (hrtimer_active(timer))
> 	+               hrtimer_try_to_cancel(timer);
> 	+}
>
> This looks suspicious. finish_task_switch() does put_task_struct()
> after that, it is quite possible this actually frees the memory.
>
> What if hrtimer_try_to_cancel() fails because the timer is running?
> In this case __run_hrtimer() can play with the freed timer. Say, to
> clear HRTIMER_STATE_CALLBACK. Not to mention dl_task_timer() itself.
>
> Oleg.
>

Right, hrtimer_cancel(timer) looks way better.

Thanks!

- Juri
