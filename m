Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068Ab0FQXQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:16:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754568Ab0FQXQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:16:19 -0400
Date: Thu, 17 Jun 2010 16:14:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com, johannes@sipsolutions.net,
       oleg@redhat.com, axboe@kernel.dk, Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: Overview of concurrency managed workqueue
Message-Id: <20100617161412.08337bc6.akpm@linux-foundation.org>
In-Reply-To: <4C17C598.7070303@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	<4C17C598.7070303@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010 20:25:28 +0200
Tejun Heo <tj@kernel.org> wrote:

> Hello, all.

Thanks for doing this.  It helps.  And look at all the interest and
helpful suggestions!

> So, here's the overview I wrote up today.  If anything needs more
> clarification, just ask.  Thanks.
> 
> == Overview
> 
> There are many cases where an execution context is needed and there
> already are several mechanisms for them.  The most commonly used one
> is workqueue and there are slow_work, async and a few other.  Although
> workqueue has been serving the kernel for quite some time now, it has
> some limitations.
> 
> There are two types of workqueues, single and multi threaded.  MT wq
> keeps a bound thread for each online CPU, while ST wq uses single
> unbound thread.  With the quickly rising number of CPU cores, there
> already are systems in which just booting up saturates the default 32k
> PID space.
> 
> Frustratingly, although MT wqs end up spending a lot of resources, the
> level of concurrency provided is unsatisfactory.  The concurrency
> limitation is common to both ST and MT wqs although it's less severe
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

Does this approach actually *solve* the deadlocks due to work
dependencies?  Or does it just make the deadlocks harder to hit by
throwing more threads at the problem?

ah, from reading on I see it's the make-them-harder-to-hit approach.

Deos lockdep still tell us that we're in a potentially deadlockable
situation?

> The tension between the provided level of concurrency and resource
> usage force its users to make unnecessary tradeoffs like libata
> choosing to use ST wq for polling PIOs and accepting a silly
> limitation that no two polling PIOs can be in progress at the same
> time.  As MT wqs don't provide much better concurrency, users which
> require higher level of concurrency, like async or fscache, end up
> having to implement their own worker pool.
> 
> cmwq extends workqueue with focus on the following goals.
> 
> * Workqueue is already very widely used.  Maintain compatibility with
>   the current API while removing limitations of the current
>   implementation.
> 
> * Provide single unified worker pool per cpu which can be shared by
>   all users.  The worker pool and level of concurrency should be
>   regulated automatically so that the API users don't need to worry
>   about that.
> 
> * Use what's necessary and allocate resources lazily on demand while
>   still maintaining forward progress guarantee where necessary.

There are places where code creates workqueue threads and then fiddles
with those threads' scheduling priority or scheduling policy or
whatever.  I'll address that in a different email.

> 
> == Unified worklist
> 
> There's a single global cwq, or gcwq, per each possible cpu which
> actually serves out the execution contexts.  cpu_workqueues or cwqs of
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
> non-reentrant and single-cpu, where single-cpu can be used to achieve
> single-threadedness and full ordering combined with in-flight work
> limit of 1.  The default mode is basically the same as the original
> implementation.  The distinction between non-reentrancy and single-cpu
> were made because some ST wq users didn't really need single
> threadedness but just non-reentrancy.
> 
> Another area where things get more involved is workqueue flushing as
> for flushing to which wq a work is queued matters.  cmwq tracks this
> using colors.  When a work is queued to a cwq, it's assigned a color
> and each cwq maintains counters for each work color.  The color
> assignment changes on each wq flush attempt.  A cwq can tell that all
> works queued before a certain wq flush attempt have finished by
> waiting for all the colors upto that point to drain.  This maintains
> the original workqueue flush semantics without adding unscalable
> overhead.

flush_workqueue() sucks.  It's a stupid, accidental,
internal-implementation-dependent interface.  We should deprecate it
and try to get rid of it, migrating to the eminently more sensible
flush_work().

I guess the first step is to add a dont-do-that checkpatch warning when
people try to add new flush_workqueue() calls.

165 instances tree-wide, sigh.

> 
> == Automatically regulated shared worker pool
> 
> For any worker pool, managing the concurrency level (how many workers
> are executing simultaneously) is an important issue.

Why?  What are we trying to avoid here?

>  cmwq tries to
> keep the concurrency at minimum but sufficient level.

I don't have a hope of remembering what all the new three-letter and
four-letter acronyms mean :(

> Concurrency management is implemented by hooking into the scheduler.
> gcwq is notified whenever a busy worker wakes up or sleeps and thus

<tries to work out what gcwq means, and not just "what it expands to">

> can keep track of the current level of concurrency.  Works aren't
> supposed to be cpu cycle hogs and maintaining just enough concurrency
> to prevent work processing from stalling due to lack of processing
> context should be optimal.  gcwq keeps the number of concurrent active
> workers to minimum but no less.

Is that "the number of concurrent active workers per cpu"?

> As long as there's one or more
> running workers on the cpu, no new worker is scheduled so that works
> can be processed in batch as much as possible but when the last
> running worker blocks, gcwq immediately schedules new worker so that
> the cpu doesn't sit idle while there are works to be processed.

"immediately schedules": I assume that this means that the thread is
made runnable, but isn't necessarily immediately executed?

If it _is_ immediately given the CPU then it sounds locky uppy?

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

ah, there we go.

hm.

> Such forward progress guarantee relies on that workers can be created
> when more execution contexts are necessary.  This is guaranteed by
> using emergency workers.  All wqs which can be used in allocation path

allocation of what?

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
> 
> 
> == Numbers (this is with the third take but nothing which could affect
>    performance has changed since then.  Eh well, very little has
>    changed since then in fact.)

yes, it's hard to see how any of these changes could affect CPU
consumption in any way.  Perhaps something like padata might care.  Did
you look at padata much?



