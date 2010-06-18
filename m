Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab0FRHcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 03:32:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:54948 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121Ab0FRHce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 03:32:34 -0400
Message-ID: <4C1B20E8.2000004@kernel.org>
Date: Fri, 18 Jun 2010 09:31:52 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com, johannes@sipsolutions.net,
       oleg@redhat.com, axboe@kernel.dk, Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	<4C17C598.7070303@kernel.org> <20100617161412.08337bc6.akpm@linux-foundation.org>
In-Reply-To: <20100617161412.08337bc6.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Jun 2010 07:31:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/18/2010 01:14 AM, Andrew Morton wrote:
> Thanks for doing this.  It helps.  And look at all the interest and
> helpful suggestions!

Yay!

>> One such problem is possible deadlock through dependency on the same
>> execution resource.  These can be detected quite reliably with lockdep
>> these days but in most cases the only solution is to create a
>> dedicated wq for one of the parties involved in the deadlock, which
>> feeds back into the waste of resources.  Also, when creating such
>> dedicated wq to avoid deadlock, to avoid wasting large number of
>> threads just for that work, ST wqs are often used but in most cases ST
>> wqs are suboptimal compared to MT wqs.
> 
> Does this approach actually *solve* the deadlocks due to work
> dependencies?  Or does it just make the deadlocks harder to hit by
> throwing more threads at the problem?
> 
> ah, from reading on I see it's the make-them-harder-to-hit approach.

Yeah, the latter, much harder.

> Deos lockdep still tell us that we're in a potentially deadlockable
> situation?

Lockdep wouldn't apply as-is.  I _think_ it's possible to calculate
the possibility of simultaneous works hitting the limit by extending
lockdep but given the use cases we currently have (all are very
shallow dependency chains, most of them being 2), I don't think it's
urgent.

> There are places where code creates workqueue threads and then fiddles
> with those threads' scheduling priority or scheduling policy or
> whatever.  I'll address that in a different email.

Alright.

> flush_workqueue() sucks.  It's a stupid, accidental,
> internal-implementation-dependent interface.  We should deprecate it
> and try to get rid of it, migrating to the eminently more sensible
> flush_work().
> 
> I guess the first step is to add a dont-do-that checkpatch warning when
> people try to add new flush_workqueue() calls.
> 
> 165 instances tree-wide, sigh.

I would prefer sweeping fix followed by deprecation of the function.
Gradual changes sound nice but in most cases they just result in
postponing what needs to be done anyway.

>> == Automatically regulated shared worker pool
>>
>> For any worker pool, managing the concurrency level (how many workers
>> are executing simultaneously) is an important issue.
> 
> Why?  What are we trying to avoid here?

Unnecessary heuristics which may sometimes schedule too many wasting
resources and polluting cachelines while other times schedules too
few introducing unnecessary latencies.

>>  cmwq tries to
>> keep the concurrency at minimum but sufficient level.
> 
> I don't have a hope of remembering what all the new three-letter and
> four-letter acronyms mean :(

It stands for Concurrency Managed WorkQueue.  Eh well, as long as it
works as an identifier.

>> Concurrency management is implemented by hooking into the scheduler.
>> gcwq is notified whenever a busy worker wakes up or sleeps and thus
> 
> <tries to work out what gcwq means, and not just "what it expands to">

Global cpu workqueue.  It's the actual percpu workqueue which does all
the hard work.  Workqueues and their associated cpu workqueues works
as frontends to gcwqs.

>> can keep track of the current level of concurrency.  Works aren't
>> supposed to be cpu cycle hogs and maintaining just enough concurrency
>> to prevent work processing from stalling due to lack of processing
>> context should be optimal.  gcwq keeps the number of concurrent active
>> workers to minimum but no less.
> 
> Is that "the number of concurrent active workers per cpu"?

I don't really understand your question.

>> As long as there's one or more
>> running workers on the cpu, no new worker is scheduled so that works
>> can be processed in batch as much as possible but when the last
>> running worker blocks, gcwq immediately schedules new worker so that
>> the cpu doesn't sit idle while there are works to be processed.
> 
> "immediately schedules": I assume that this means that the thread is
> made runnable, but isn't necessarily immediately executed?
> 
> If it _is_ immediately given the CPU then it sounds locky uppy?

It's made runnable.

>> This allows using minimal number of workers without losing execution
>> bandwidth.  Keeping idle workers around doesn't cost much other than
>> the memory space, so cmwq holds onto idle ones for a while before
>> killing them.
>>
>> As multiple execution contexts are available for each wq, deadlocks
>> around execution contexts is much harder to create.  The default
>> workqueue, system_wq, has maximum concurrency level of 256 and unless
>> there is a use case which can result in a dependency loop involving
>> more than 254 workers, it won't deadlock.
> 
> ah, there we go.
> 
> hm.
> 
>> Such forward progress guarantee relies on that workers can be created
>> when more execution contexts are necessary.  This is guaranteed by
>> using emergency workers.  All wqs which can be used in allocation path
> 
> allocation of what?

Memory to create new kthreads.

>> == Numbers (this is with the third take but nothing which could affect
>>    performance has changed since then.  Eh well, very little has
>>    changed since then in fact.)
> 
> yes, it's hard to see how any of these changes could affect CPU
> consumption in any way.  Perhaps something like padata might care.  Did
> you look at padata much?

I've read about it.  Haven't read the code yet tho.  Accomodating it
isn't difficult.  We just need an interface which works used by padata
can call which tell wq not to track concurrency for the worker as it's
serving cpu intensive job.

Thanks.

-- 
tejun
