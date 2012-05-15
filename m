Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab2EOKKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 06:10:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41218 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab2EOKKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 06:10:23 -0400
Message-ID: <4FB22B88.80106@gmail.com>
Date: Tue, 15 May 2012 12:10:16 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>   <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>  <1335191701.28150.155.camel@twins> <4F9577CF.2020400@gmail.com> <1335195826.28150.177.camel@twins>
In-Reply-To: <1335195826.28150.177.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 05:43 PM, Peter Zijlstra wrote:
> On Mon, 2012-04-23 at 17:39 +0200, Juri Lelli wrote:
>> On 04/23/2012 04:35 PM, Peter Zijlstra wrote:
>>> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
>>>> +static void init_dl_task_timer(struct sched_dl_entity *dl_se)
>>>> +{
>>>> +       struct hrtimer *timer =&dl_se->dl_timer;
>>>> +
>>>> +       if (hrtimer_active(timer)) {
>>>> +               hrtimer_try_to_cancel(timer);
>>>> +               return;
>>>> +       }
>>>
>>> Same question I guess, how can it be active here? Also, just letting it
>>> run doesn't seem like the best way out..
>>>
>>
>> Probably s/hrtimer_try_to_cancel/hrtimer_cancel is better.
>
> Yeah, not sure you can do hrtimer_cancel() there though, you're holding
> ->pi_lock and rq->lock and have IRQs disabled. That sounds like asking
> for trouble.
>
> Anyway, if it can't happen, we don't have to fix it.. so lets answer
> that first ;-)

Even if I dropped the bits for allowing !root users, this critical point
still remains.
What if I leave this like it is and instead I do the following?

@@ -488,9 +488,10 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
         /*
          * We need to take care of a possible races here. In fact, the
          * task might have changed its scheduling policy to something
-        * different from SCHED_DEADLINE (through sched_setscheduler()).
+        * different from SCHED_DEADLINE or changed its reservation
+        * parameters (through sched_{setscheduler(),setscheduler2()}).
          */
-       if (!dl_task(p))
+       if (!dl_task(p) || dl_se->dl_new)
                 goto unlock;
  
         dl_se->dl_throttled = 0;

The idea is that hrtimer_try_to_cancel should fail only if the callback routine
is running. If, meanwhile, I set up new parameters, I can try to recognize this
situation through dl_new (set to 1 during __setparam_dl).

BTW, I'd have a new version ready (also rebased on the current tip/master). It
address all the comments excluding your gcc work-around, math128 and
nr_cpus_allowed shift (patches are ready but those changes not yet mainline,
right?). Anyway, do you think would be fine to post it?

Thanks and Regards,

- Juri
