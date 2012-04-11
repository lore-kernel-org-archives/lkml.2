Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761348Ab2DKV43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 17:56:29 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51384 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab2DKV42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 17:56:28 -0400
Message-ID: <4F85FE07.2060605@gmail.com>
Date: Wed, 11 Apr 2012 23:56:23 +0200
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
Subject: Re: [PATCH 08/16] sched: add period support for -deadline tasks.
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>  <1333696481-3433-9-git-send-email-juri.lelli@gmail.com> <1334176337.23924.297.camel@gandalf.stny.rr.com>
In-Reply-To: <1334176337.23924.297.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 10:32 PM, Steven Rostedt wrote:
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
>
> First, it seems that the function returns true if:
>
> 	dl_runtime / dl_period<  runtime / (deadline - t)
>

Right, the comment is wrong! Just reverse the inequality as you did.
  
>
> I'm a little confused by this. We are comparing the ratio of runtime
> left and deadline left, to the ratio of total runtime to period.
>
> I'm actually confused by this premise anyway. What's the purpose of
> comparing the ratio? If runtime<  (deadline - t) wouldn't it not be able
> to complete anyway? Or are we thinking that the runtime will be
> interrupted proportionally by other tasks?
>

We are actually applying one of the CBS rules. We want to be able to
"slow down" a deadline task if it is going to exceed its reserved
bandwidth. We are in fact checking here that the bandwidth this task
will consume from t to its deadline is no more than its reserved one.

>
>
>>    */
>>   static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
>>   {
>> @@ -312,7 +316,7 @@ static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
>>   	 * to the (absolute) deadline. Therefore, overflowing the u64
>>   	 * type is very unlikely to occur in both cases.
>>   	 */
>> -	left = dl_se->dl_deadline * dl_se->runtime;
>> +	left = dl_se->dl_period * dl_se->runtime;
>>   	right = (dl_se->deadline - t) * dl_se->dl_runtime;
>>
>>   	return dl_time_before(right, left);
>
>

Thanks,

- Juri
