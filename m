Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab1GUQVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:21:21 -0400
Received: from wega.rz.tu-ilmenau.de ([141.24.4.159]:52640 "EHLO
	wega.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab1GUQVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:21:19 -0400
Message-ID: <4E28557A.7040704@tu-ilmenau.de>
Date: Thu, 21 Jul 2011 18:36:10 +0200
From: =?UTF-8?B?U3RlcGhhbiBCw6Ryd29sZg==?= 
	<stephan.baerwolf@tu-ilmenau.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110711 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: sched: fix/optimise some issues
References: <4E26DB41.9070002@tu-ilmenau.de> <1311260895.29152.153.camel@twins>
In-Reply-To: <1311260895.29152.153.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your fast response and your detailed comments.

On 07/21/11 17:08, Peter Zijlstra wrote:
> On Wed, 2011-07-20 at 15:42 +0200, Stephan Bärwolf wrote:
>> I also implemented an 128bit vruntime support:
>> Majorly on systems with many tasks and (for example) deep cgroups
>> (or increased NICE0_LOAD/ SCHED_LOAD_SCALE as in commit
>> c8b281161dfa4bb5d5be63fb036ce19347b88c63), a weighted timeslice
>> (unsigned long) can become very large (on x86_64) and consumes a
>> large part of the u64 vruntimes (per tick) when added.
>> This might lead to missscheduling because of overflows. 
> Right, so I've often wanted a [us]128 type, and gcc has some (broken?)
> support for that, but overhead has always kept me from it.
128bit sched_vruntime_t support seems to be running fine, when compiled with
gcc (Gentoo 4.4.5 p1.2, pie-0.4.5) 4.4.5.
Of course overhead is a problem (but there is also overhead using u64 on
x86),
that is why it should be Kconfig selectable (for servers with many
processes,
deep cgroups and many different priorities?).

But I think also abstracting the whole vruntime-stuff into a seperate
collection
simplifies further evaluations and adpations. (Think of central
statistics collection
for example maximum timeslice seen or happened overflows - without changing
all the lines of code with the risk of missing sth.)
> There's also the non-atomicy thing to consider, see min_vruntime_copy
> etc.
I think atomicy is not an (great) issue, because of two reasons:
    a) on x86 the u64 wouldn't be atomic, too (vruntime is u64 not
atomic64_t)
    b) every operation on cfs_rq->min_vruntime should happen, when
        holding the runqueue-lock?.
> How horrid is the current vruntime situation?
This is a point, which needs further discussion/observation.

When for example NICE0_LOAD is increased by 6 Bit (and I think
"c8b281161dfa4bb5d5be63fb036ce19347b88c63" did it by 10bits
on x86_64) the maximum timeslice (I am not quite sure if it was on
HZ=1000) with a PRE kernel will be around 2**38.
Adding this every ms (lets say 1024 times per sec) to min_vruntime
might cause overflows too fast (after 2**(63-38-10)sec = 2**15sec ~ 9h).
Having a great heterogenity of priorities may intensify this situation...

Long story short: on x86_64 an unsigned long (timeslice) could be
as large as the whole u64 for min_vruntime and this is dangerous.

Of course limiting the maximum timeslice in "calc_delta_mine()" would
help, too - but without the comfort using the whole x86_64 capabilties.
(and mostly therefore finer priority-resolutions)
> As to your true-idle, there's a very good reason the current SCHED_IDLE
> isnt' a true idle scheduler; it would create horrid priority inversion
> problems, imagine the true idle task holding a mutex or is required to
> complete something.
Of course, I fully agree! This is one reason why it was marked as
"experimental". When having a few backgroundjobs (for example
a boinc or a bitcoin-crunsher ;-) ) it works ok because there seems
not to many process-spanned lockings.
But in general it is a bad idea...

I also remember weak Linus had sth. against "priority inheritance"
(don't ask me what or why - I don't know),
but it would be an honour to me working with you guys to implement
this feature in future kernels. (On the base of rb-trees saving the
priorities of each "se" holding the lock, to solve prio.inv. ? or in
non-schedulable contextes maybe setting an "super-priority" while locking)

I think real idle-scheduling (maybe based in more than one idle-levels)
would
be a very great feature to future kernels.
(For example utilizing expensive systems without feelable affects on
interactivity)
Even because SMP gains more and
more importance (plus increasing cpus/cores) and the "load-balancing"
often leads to short
but great idle-phases on sparse (because of interactivity) processed
systems.

>

Thanks,
regards Stephan

-- 
Dipl.-Inf. Stephan Bärwolf
Ilmenau University of Technology, Integrated Communication Systems Group
Phone: +49 (0)3677 69 4130
Email: stephan.baerwolf@tu-ilmenau.de,  
Web: http://www.tu-ilmenau.de/iks

