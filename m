Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab2DWOnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 10:43:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48139 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab2DWOnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 10:43:39 -0400
Message-ID: <4F956A95.5030304@gmail.com>
Date: Mon, 23 Apr 2012 16:43:33 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
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
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>  <1333696481-3433-6-git-send-email-juri.lelli@gmail.com> <1335182113.28150.132.camel@twins>
In-Reply-To: <1335182113.28150.132.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 01:55 PM, Peter Zijlstra wrote:
> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
>> +/*
>> + * Here we check if --at time t-- an entity (which is probably being
>> + * [re]activated or, in general, enqueued) can use its remaining runtime
>> + * and its current deadline _without_ exceeding the bandwidth it is
>> + * assigned (function returns true if it can).
>> + *
>> + * For this to hold, we must check if:
>> + *   runtime / (deadline - t)<  dl_runtime / dl_deadline .
>
> It might be good to put a few words in as to why that is.. I know I
> always forget (but know where to find it by now), also might be good to
> refer those papers Tommaso listed when Steven asked this a while back.
>

Ok, I'll fix the comment, extend it and add T.'s references in the
Documentation.

>> + */
>> +static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
>> +{
>> +       u64 left, right;
>> +
>> +       /*
>> +        * left and right are the two sides of the equation above,
>> +        * after a bit of shuffling to use multiplications instead
>> +        * of divisions.
>> +        *
>> +        * Note that none of the time values involved in the two
>> +        * multiplications are absolute: dl_deadline and dl_runtime
>> +        * are the relative deadline and the maximum runtime of each
>> +        * instance, runtime is the runtime left for the last instance
>> +        * and (deadline - t), since t is rq->clock, is the time left
>> +        * to the (absolute) deadline. Therefore, overflowing the u64
>> +        * type is very unlikely to occur in both cases.
>> +        */
>> +       left = dl_se->dl_deadline * dl_se->runtime;
>> +       right = (dl_se->deadline - t) * dl_se->dl_runtime;
>
>
>  From what I can see there are no constraints on the values in
> __setparam_dl() so the above left term can be constructed to be an
> overflow.
>

Yes, could happen :-\.

> Ideally we'd use u128 here, but I don't think people will let us :/
>

Do we need to do something about that? If we cannot go for bigger space
probably limit dl_deadline (or warn the user)..

>> +       return dl_time_before(right, left);
>> +}
