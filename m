Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754Ab0FPG4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 02:56:23 -0400
Received: from ist.d-labs.de ([213.239.218.44]:47300 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038Ab0FPG4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 02:56:22 -0400
Date: Wed, 16 Jun 2010 08:55:47 +0200
From: Florian Mickler <florian@mickler.org>
To: Tejun Heo <tj@kernel.org>
Newsgroups: gmane.linux.kernel
Cc: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
Message-ID: <20100616085547.77f9169e@schatten.dmk.lab>
In-Reply-To: <4C17C598.7070303@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	<4C17C598.7070303@kernel.org>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Tue, 15 Jun 2010 20:25:28 +0200 Tejun Heo <tj@kernel.org> wrote:

> Hello, all.
> 
> So, here's the overview I wrote up today.  If anything needs more
> clarification, just ask.  Thanks.

Nice writeup! I think it is sufficient already and I probably wouldn't
bother, but here are a little comments if you want to polish it up...

Also, feel free to ignore :)

As a genereal rule, every abbreviation should be written out at least
once and if you are going to abbreviate it from then on, the
abbreviation goes in parenthesis after that. That helps the reader a
lot.

For example:

> 
> == Overview
> 
> There are many cases where an execution context is needed and there
> already are several mechanisms for them.  The most commonly used one
> is workqueue and there are slow_work, async and a few other.  Although

The most commonly used one is workqueue (wq) and there are ...

> workqueue has been serving the kernel for quite some time now, it has
> some limitations.

here you can then already use "wq". That makes it shorter, and if you
use it consistently the reader doesn't wonder if wq and worqueue are
different things. 

> 
> There are two types of workqueues, single and multi threaded.  MT wq

... multi threaded (MT). MT wq keeps a bound ...

> keeps a bound thread for each online CPU, while ST wq uses single

... while single threaded (ST) wq uses single ...


> unbound thread.  With the quickly rising number of CPU cores, there
> already are systems in which just booting up saturates the default 32k
> PID space.

CPU and PID are well defined in the kernel, so no need to explain these.

> 
> Frustratingly, although MT wqs end up spending a lot of resources, the
> level of concurrency provided is unsatisfactory.  The concurrency
> limitation is common to both ST and MT wqs although it's less severe

I don't know what the english rules for plural of abbreviated word. But
I would probably just drop the plural s and let the reader add it when
he decodes the abbreviation. (ie replace wqs with wq) Or introduce it
properly: "... workqueues (wqs) ... ", Or don't abbreviate it in the
plural.

> on MT ones.  Worker pools of wqs are completely separate from each
> other.  A MT wq provides one execution context per CPU while a ST wq
> one for the whole system.  This leads to various problems.
> 
> One such problem is possible deadlock through dependency on the same
> execution resource.  These can be detected quite reliably with lockdep
> these days but in most cases the only solution is to create a
> dedicated wq for one of the parties involved in the deadlock, which
> feeds back into the waste of resources.  Also, when creating such
> dedicated wq to avoid deadlock, to avoid wasting large number of
> threads just for that work, ST wqs are often used but in most cases ST
> wqs are suboptimal compared to MT wqs.
> 
> The tension between the provided level of concurrency and resource
> usage force its users to make unnecessary tradeoffs like libata
> choosing to use ST wq for polling PIOs and accepting a silly
> limitation that no two polling PIOs can be in progress at the same
> time.  As MT wqs don't provide much better concurrency, users which
> require higher level of concurrency, like async or fscache, end up
> having to implement their own worker pool.
> 
> cmwq extends workqueue with focus on the following goals.

first mentioning of cmwq as an abbreviation is not nice for the reader. 
Better: 
	Concurrency managed wq (cmwq) ... goals:
	Concurrency managed workqueue (cmwq) ... goals:



> 
> * Workqueue is already very widely used.  Maintain compatibility with
>   the current API while removing limitations of the current
>   implementation.

* Because the current wq implementation is already very widely used we
  maintain compatibility with the API while removing above
  mentioned limitations.

> 
> * Provide single unified worker pool per cpu which can be shared by
>   all users.  The worker pool and level of concurrency should be
>   regulated automatically so that the API users don't need to worry
>   about that.
> 
> * Use what's necessary and allocate resources lazily on demand while
>   still maintaining forward progress guarantee where necessary.
> 
> 
> == Unified worklist
> 
> There's a single global cwq, or gcwq, per each possible cpu which

 ... global cwq (gcwq) per each possible cpu

> actually serves out the execution contexts.  cpu_workqueues or cwqs of
	
	cpu_workqueues (cwqs) 

> each wq are mostly simple frontends to the associated gcwq.  Under
> normal operation, when a work is queued, it's queued to the gcwq on
> the same cpu.  Each gcwq has its own pool of workers bound to the gcwq
> which will be used to process all the works queued on the cpu.  For
> the most part, works don't care to which wqs they're queued to and
> using a unified worklist is pretty straight forward.  There are a
> couple of areas where things are a bit more complicated.
> 
> First, when queueing works from different wqs on the same queue,
> ordering of works needs special care.  Originally, a MT wq allows a
> work to be executed simultaneously on multiple cpus although it
> doesn't allow the same one to execute simultaneously on the same cpu
> (reentrant).  A ST wq allows only single work to be executed on any
> cpu which guarantees both non-reentrancy and single-threadedness.
> 
> cmwq provides three different ordering modes - reentrant (default),

... (default mode)...

> non-reentrant and single-cpu, where single-cpu can be used to achieve
> single-threadedness and full ordering combined with in-flight work
> limit of 1.  The default mode is basically the same as the original

The default mode (reentrant) is basically...

> implementation.  The distinction between non-reentrancy and single-cpu
> were made because some ST wq users didn't really need single
> threadedness but just non-reentrancy.

 
> Another area where things get more involved is workqueue flushing as
> for flushing to which wq a work is queued matters.  cmwq tracks this
> using colors.  When a work is queued to a cwq, it's assigned a color
> and each cwq maintains counters for each work color.  The color
> assignment changes on each wq flush attempt.  A cwq can tell that all
> works queued before a certain wq flush attempt have finished by
> waiting for all the colors upto that point to drain.  This maintains
> the original workqueue flush semantics without adding unscalable
> overhead.

[nice solution, btw]

> 
> 
> == Automatically regulated shared worker pool
> 
> For any worker pool, managing the concurrency level (how many workers
> are executing simultaneously) is an important issue.  cmwq tries to
> keep the concurrency at minimum but sufficient level.
> 
> Concurrency management is implemented by hooking into the scheduler.
> gcwq is notified whenever a busy worker wakes up or sleeps and thus

There is only one gcwq? 
Then maybe better:

_The_ gcwq is notified...

> can keep track of the current level of concurrency.  Works aren't
> supposed to be cpu cycle hogs and maintaining just enough concurrency
> to prevent work processing from stalling due to lack of processing
> context should be optimal.  gcwq keeps the number of concurrent active
> workers to minimum but no less. 

also: 
... The gcwq keeps the number of concurrent ...

> As long as there's one or more
> running workers on the cpu, no new worker is scheduled so that works
> can be processed in batch as much as possible but when the last
> running worker blocks, gcwq immediately schedules new worker so that
> the cpu doesn't sit idle while there are works to be processed.

here too: ..., the gcwq immediately schedules ...

> This allows using minimal number of workers without losing execution
> bandwidth.  Keeping idle workers around doesn't cost much other than
> the memory space, so cmwq holds onto idle ones for a while before
> killing them.
> 
> As multiple execution contexts are available for each wq, deadlocks
> around execution contexts is much harder to create.  The default
> workqueue, system_wq, has maximum concurrency level of 256 and unless
> there is a use case which can result in a dependency loop involving
> more than 254 workers, it won't deadlock.
> 
> Such forward progress guarantee relies on that workers can be created
> when more execution contexts are necessary.  This is guaranteed by
> using emergency workers.  All wqs which can be used in allocation path
> are required to have emergency workers which are reserved for
> execution of that specific workqueue so that allocation needed for
> worker creation doesn't deadlock on workers.
> 
> 

> == Benefits
> 
> * Less to worry about causing deadlocks around execution resources.
> 
> * Far fewer number of kthreads.
> 
> * More flexibility without runtime overhead.
> 
> * As concurrency is no longer a problem, workloads which needed
>   separate mechanisms can now use generic workqueue instead.  This
>   easy access to concurrency also allows stuff which wasn't worth
>   implementing a dedicated mechanism for but still needed flexible
>   concurrency.

* improved latency for current schedule_work() users, i.e. the work
  get's executed in a more timely fashion?

 

 
> == Numbers (this is with the third take but nothing which could affect
>    performance has changed since then.  Eh well, very little has
>    changed since then in fact.)
> 
> wq workload is generated by perf-wq.c module which is a very simple
> synthetic wq load generator (I'll attach it to this message).  A work
> is described by five parameters - burn_usecs, mean_sleep_msecs,
> mean_resched_msecs and factor.  It randomly splits burn_usecs into
> two, burns the first part, sleeps for 0 - 2 * mean_sleep_msecs, burns
> what's left of burn_usecs and then reschedules itself in 0 - 2 *
> mean_resched_msecs.  factor is used to tune the number of cycles to
> match execution duration.
> 
> It issues three types of works - short, medium and long, each with two
> burn durations L and S.
> 
> 	burn/L(us)	burn/S(us)	mean_sleep(ms)	mean_resched(ms) cycles
>  short	50		1		1		10		 454
>  medium	50		2		10		50		 125
>  long	50		4		100		250		 42
> 
> And then these works are put into the following workloads.  The lower
> numbered workloads have more short/medium works.
> 
>  workload 0
>  * 12 wqs with 4 short works
>  *  2 wqs with 2 short  and 2 medium works
>  *  4 wqs with 2 medium and 1 long works
>  *  8 wqs with 1 long work
> 
>  workload 1
>  *  8 wqs with 4 short works
>  *  2 wqs with 2 short  and 2 medium works
>  *  4 wqs with 2 medium and 1 long works
>  *  8 wqs with 1 long work
> 
>  workload 2
>  *  4 wqs with 4 short works
>  *  2 wqs with 2 short  and 2 medium works
>  *  4 wqs with 2 medium and 1 long works
>  *  8 wqs with 1 long work
> 
>  workload 3
>  *  2 wqs with 4 short works
>  *  2 wqs with 2 short  and 2 medium works
>  *  4 wqs with 2 medium and 1 long works
>  *  8 wqs with 1 long work
> 
>  workload 4
>  *  2 wqs with 4 short works
>  *  2 wqs with 2 medium works
>  *  4 wqs with 2 medium and 1 long works
>  *  8 wqs with 1 long work
> 
>  workload 5
>  *  2 wqs with 2 medium works
>  *  4 wqs with 2 medium and 1 long works
>  *  8 wqs with 1 long work
> 
> The above wq loads are run in parallel with mencoder converting 76M
> mjpeg file into mpeg4 which takes 25.59 seconds with standard
> deviation of 0.19 without wq loading.  The CPU was intel netburst
> celeron running at 2.66GHz (chosen for its small cache size and
> slowness).  wl0 and 1 are only tested for burn/S.  Each test case was
> run 11 times and the first run was discarded.
> 
> 	 vanilla/L	cmwq/L		vanilla/S	cmwq/S
>  wl0					26.18 d0.24	26.27 d0.29
>  wl1					26.50 d0.45	26.52 d0.23
>  wl2	26.62 d0.35	26.53 d0.23	26.14 d0.22	26.12 d0.32
>  wl3	26.30 d0.25	26.29 d0.26	25.94 d0.25	26.17 d0.30
>  wl4	26.26 d0.23	25.93 d0.24	25.90 d0.23	25.91 d0.29
>  wl5	25.81 d0.33	25.88 d0.25	25.63 d0.27	25.59 d0.26
> 
> There is no significant difference between the two.  Maybe the code
> overhead and benefits coming from context sharing are canceling each
> other nicely.  With longer burns, cmwq looks better but it's nothing
> significant.  With shorter burns, other than wl3 spiking up for
> vanilla which probably would go away if the test is repeated, the two
> are performing virtually identically.
> 
> The above is exaggerated synthetic test result and the performance
> difference will be even less noticeable in either direction under
> realistic workloads.
> 
> cmwq extends workqueue such that it can serve as robust async
> mechanism which can be used (mostly) universally without introducing
> any noticeable performance degradation.
> 
> Thanks.
> 
> --
> tejun
> 
Cheers,
Flo
