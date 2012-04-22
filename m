Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab2DVOEa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 10:04:30 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62398 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab2DVOE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 10:04:29 -0400
Message-ID: <4F940FE5.9000800@gmail.com>
Date: Sun, 22 Apr 2012 16:04:21 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Subject: Re: [PATCH 13/16] sched: drafted deadline inheritance logic.
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>  <1333696481-3433-14-git-send-email-juri.lelli@gmail.com> <1334198553.23924.329.camel@gandalf.stny.rr.com>
In-Reply-To: <1334198553.23924.329.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 04:42 AM, Steven Rostedt wrote:
> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
>> From: Dario Faggioli<raistlin@linux.it>
>>
>> Some method to deal with rt-mutexes and make sched_dl interact with
>> the current PI-coded is needed, raising all but trivial issues, that
>> needs (according to us) to be solved with some restructuring of
>> the pi-code (i.e., going toward a proxy execution-ish implementation).
>
> I also would like to point out that this is probably only for -rt? Or is
> this for PI futexes as well?
>

Well, this directly affects rtmutex.c only. But, as soon as a PI-enabled
user-space mutex fails the fastpath all returns to rtmutex machinery, right?
So, I would say that this apply to PI futexes as well :-|.

> Note, non-proxy version of this code may be an issue. Could a process
> force more bandwidth than was allowed by rlimit if the process used PI
> futexes forced a behavior that PI waiters were waiting on another
> process while it held the PI futex? The process that held the futex may
> get more bandwidth if it never lets go of the futex, right?
>

Yes, I would remark that this is a needed _temporary_ solution (just to not
delay further the release post). I tried to remain simple as to not prevent
any fast shift in the way we want to resolve this problem. Anyway, it would
be great if some discussion on this point could re-start :-).

>>
>> This is under development, in the meanwhile, as a temporary solution,
>> what this commits does is:
>>   - ensure a pi-lock owner with waiters is never throttled down. Instead,
>>     when it runs out of runtime, it immediately gets replenished and it's
>>     deadline is postponed;
>>   - the scheduling parameters (relative deadline and default runtime)
>>     used for that replenishments --during the whole period it holds the
>>     pi-lock-- are the ones of the waiting task with earliest deadline.
>
> This sounds similar to what I implemented for a company back in 2005.
>
>>
>> Acting this way, we provide some kind of boosting to the lock-owner,
>> still by using the existing (actually, slightly modified by the previous
>> commit) pi-architecture.
>>
>> We would stress the fact that this is only a surely needed, all but
>> clean solution to the problem. In the end it's only a way to re-start
>> discussion within the community. So, as always, comments, ideas, rants,
>> etc.. are welcome! :-)
>>
>> Signed-off-by: Dario Faggioli<raistlin@linux.it>
>> Signed-off-by: Juri Lelli<juri.lelli@gmail.com>
>> ---
>>   include/linux/sched.h |    9 +++++-
>>   kernel/fork.c         |    1 +
>>   kernel/rtmutex.c      |   13 +++++++-
>>   kernel/sched.c        |   34 ++++++++++++++++++---
>>   kernel/sched_dl.c     |   77 +++++++++++++++++++++++++++++++++---------------
>>   5 files changed, 102 insertions(+), 32 deletions(-)
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 5ef7bb6..ca45db4 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1309,8 +1309,12 @@ struct sched_dl_entity {
>>   	 * @dl_new tells if a new instance arrived. If so we must
>>   	 * start executing it with full runtime and reset its absolute
>>   	 * deadline;
>> +	 *
>> +	 * @dl_boosted tells if we are boosted due to DI. If so we are
>
>   DI?
>

DI = Deadline Inheritance. Even if not strictly correct in the definition,
when you're boosted you inherit highest priority waiter's parameters, among
which deadline. In fact you inherit its budget.

>> +	 * outside bandwidth enforcement mechanism (but only until we
>> +	 * exit the critical section).
>>   	 */
>> -	int dl_throttled, dl_new;
>> +	int dl_throttled, dl_new, dl_boosted;
>>
>>   	/*
>>   	 * Bandwidth enforcement timer. Each -deadline task has its
>> @@ -1556,6 +1560,8 @@ struct task_struct {
>>   	struct rb_node *pi_waiters_leftmost;
>>   	/* Deadlock detection and priority inheritance handling */
>>   	struct rt_mutex_waiter *pi_blocked_on;
>> +	/* Top pi_waiters task */
>> +	struct task_struct *pi_top_task;
>>   #endif
>>

Sorry for the delayed reply, I was really busy for the last two
weeks :-\.

Thanks and Regards,

- Juri
