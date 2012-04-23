Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab2DWVzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 17:55:18 -0400
Received: from ms01.sssup.it ([193.205.80.99]:45594 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754647Ab2DWVzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 17:55:16 -0400
Message-ID: <4F95CFBF.1050000@sssup.it>
Date: Mon, 23 Apr 2012 22:55:11 +0100
From: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, cfriesen@nortel.com, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>  <1333696481-3433-6-git-send-email-juri.lelli@gmail.com> <1335182113.28150.132.camel@twins>
In-Reply-To: <1335182113.28150.132.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 23/04/2012 12:55, Peter Zijlstra ha scritto:
> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
>> +/*
>> + * Here we check if --at time t-- an entity (which is probably being
>> + * [re]activated or, in general, enqueued) can use its remaining runtime
>> + * and its current deadline _without_ exceeding the bandwidth it is
>> + * assigned (function returns true if it can).
>> + *
>> + * For this to hold, we must check if:
>> + *   runtime / (deadline - t)<  dl_runtime / dl_deadline .
> It might be good to put a few words in as to why that is.. I know I
> always forget (but know where to find it by now), also might be good to
> refer those papers Tommaso listed when Steven asked this a while back.
>
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
>  From what I can see there are no constraints on the values in
> __setparam_dl() so the above left term can be constructed to be an
> overflow.
>
> Ideally we'd use u128 here, but I don't think people will let us :/

why not write this straight in asm, i.e., multiply 64*64 then divide by 
64 keeping the intermediate result on 128 bits?
Something straightforward to write in asm, but not that easy to let gcc 
understand that I don't want to multiply 128*128 :-).... a few years ago 
I had a similar issue; perhaps it was a 32/64 version of this problem, 
and gcc was not optimizing properly the C code with -O3, so I had used 
asm segments.
In this case, if avoiding the division is a major requirement, then we 
could multiply twice 64*64 in asm, then compare the two results on 128 
bits ? Again, a few assembly lines on architectures supporting the 64*64 
and 128-bits comparison.

     T.

-- 
Tommaso Cucinotta, Computer Engineering PhD, Researcher
ReTiS Lab, Scuola Superiore Sant'Anna, Pisa, Italy
Tel +39 050 882 024, Fax +39 050 882 003
http://retis.sssup.it/people/tommaso

