Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761446Ab2DKXNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:13:11 -0400
Received: from ms01.sssup.it ([193.205.80.99]:34987 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761176Ab2DKXNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:13:10 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Apr 2012 19:13:09 EDT
Message-ID: <4F8601EE.90905@sssup.it>
Date: Wed, 11 Apr 2012 23:13:02 +0100
From: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Juri Lelli <juri.lelli@gmail.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, cfriesen@nortel.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com
Subject: Re: [PATCH 08/16] sched: add period support for -deadline tasks.
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>  <1333696481-3433-9-git-send-email-juri.lelli@gmail.com> <1334176337.23924.297.camel@gandalf.stny.rr.com>
In-Reply-To: <1334176337.23924.297.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 11/04/2012 21:32, Steven Rostedt ha scritto:
> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
>
>> @@ -293,7 +293,11 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
>>    * assigned (function returns true if it can).
>>    *
>>    * For this to hold, we must check if:
>> - *   runtime / (deadline - t)<  dl_runtime / dl_deadline .
>> + *   runtime / (deadline - t)<  dl_runtime / dl_period .
>> + *
>> + * Notice that the bandwidth check is done against the period. For
>> + * task with deadline equal to period this is the same of using
>> + * dl_deadline instead of dl_period in the equation above.
> First, it seems that the function returns true if:
>
> 	dl_runtime / dl_period<  runtime / (deadline - t)
>
>
> I'm a little confused by this. We are comparing the ratio of runtime
> left and deadline left, to the ratio of total runtime to period.
>
> I'm actually confused by this premise anyway. What's the purpose of
> comparing the ratio? If runtime<  (deadline - t) wouldn't it not be able
> to complete anyway? Or are we thinking that the runtime will be
> interrupted proportionally by other tasks?

That's a well-known property of the CBS scheduling algorithm:
the "unblock rule" says that, when a task wakes up, if the residual
budget over residual deadline fits within the allocated "bandwidth",
then we can keep the current (abs) deadline and residual budget
without disrupting the schedulability of the system (i.e., ability of
other admitted tasks to meet their deadlines).
Otherwise, we should reset the status, i.e., refill budget and set
the deadline a period in the future, because keeping the current
abs deadline of the task would result in breaking guarantees
promised to other tasks.
Imagine a task going to sleep and waking
too close to its deadline: its deadline would be the closest in the
system, and it wouldn't allow anyone else to run. However, if its
residual budget is also big, then this is going to not allow anyone
to run for too much. Now, when doing the classical easy admission
test for single-CPU EDF (sum of budgets over periods <= 1), we
hadn't accounted for such a scenario with tasks blocking (which can
actually be accounted for by using far more complex tests knowing
for how long each task will block etc.). However, using the CBS, we
can keep the easy test and add the simple cut-off rule at task
wake-up which adds "temporal isolation", i.e., the capability
to not disrupt others' guarantees if I sleep for too much.
Said this, I guess/hope the rule is implemented right :-)

For a formal proof, I think you can refer to the Abeni's paper(s):

-) Integrating Multimedia Applications in Hard Real-Time Systems, RTSS '98
     www.cis.upenn.edu/~lee/01cis642/papers/AB98.pdf

which redirects on the Technical Report:
-) Server Mechanisms for Multimedia Applications

Hope this helps,

     T.

-- 
Tommaso Cucinotta, Computer Engineering PhD, Researcher
ReTiS Lab, Scuola Superiore Sant'Anna, Pisa, Italy
Tel +39 050 882 024, Fax +39 050 882 003
http://retis.sssup.it/people/tommaso

