Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab0IIICm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 04:02:42 -0400
Received: from ist.d-labs.de ([213.239.218.44]:32784 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab0IIICf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 04:02:35 -0400
Date: Thu, 9 Sep 2010 10:02:29 +0200
From: Florian Mickler <florian@mickler.org>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Christoph Lameter <cl@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH UPDATED] workqueue: add documentation
Message-ID: <20100909100229.250900f0@schatten.dmk.lab>
In-Reply-To: <4C87B101.2080608@kernel.org>
References: <4C87AE52.70401@kernel.org>
	<4C87B101.2080608@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun!
Perfect timing. Just enough for the details to get a little foggy, 
while still knowing a little bit what you want to talk about. 
:-)

On Wed, 08 Sep 2010 17:40:02 +0200 Tejun Heo <tj@kernel.org> wrote:

> +
> +1. Why cmwq?

Perhaps better to begin with an introduction:

1. Introduction

> +
> +There are many cases where an asynchronous process execution context
> +is needed and the workqueue (wq)  is the most commonly used mechanism
> +for such cases.  

There are many cases where an asynchronous process execution context is
needed and the workqueue (wq) API is the most commonly used mechanism
for such cases. 

> A work item describing which function to execute is
> +queued on a workqueue which executes the work item in a process
> +context asynchronously.

When such an asynchronous execution context is needed, a work item
describing which function to execute is put on a queue. An independent
thread serves as the asynchronous execution context. The queue is
called workqueue and the thread is called worker. 

While there are work items on the workqueue the worker executes
the functions associated with the work items one after the other. 
When there is no work item left on the workqueue the worker
becomes idle. When a new work item gets queued, the worker begins
executing again.

2. Why cmwq?

> +
> +In the original wq implementation, a multi threaded (MT) wq had one
> +worker thread per CPU and a single threaded (ST) wq had one worker
> +thread system-wide.  A single MT wq needed to keep around the same
> +number of workers as the number of CPUs.  The kernel grew a lot of MT
> +wq users over the years and with the number of CPU cores continuously
> +rising, some systems saturated the default 32k PID space just booting
> +up.
> +
> +Although MT wq wasted a lot of resource, the level of concurrency
> +provided was unsatisfactory.  The limitation was common to both ST and
> +MT wq albeit less severe on MT.  Each wq maintained its own separate
> +worker pool.  A MT wq could provide only one execution context per CPU
> +while a ST wq one for the whole system.  Work items had to compete for
> +those very limited execution contexts leading to various problems
> +including proneness to deadlocks around the single execution context.
> +
> +The tension between the provided level of concurrency and resource
> +usage also forced its users to make unnecessary tradeoffs like libata
> +choosing to use ST wq for polling PIOs and accepting an unnecessary
> +limitation that no two polling PIOs can progress at the same time.  As
> +MT wq don't provide much better concurrency, users which require
> +higher level of concurrency, like async or fscache, had to implement
> +their own thread pool.
> +
> +Concurrency Managed Workqueue (cmwq) is a reimplementation of wq with
> +focus on the following goals.
> +
> +* Maintain compatibility with the original workqueue API.
> +
> +* Use per-CPU unified worker pools shared by all wq to provide
> +  flexible level of concurrency on demand without wasting a lot of
> +  resource.
> +
> +* Automatically regulate worker pool and level of concurrency so that
> +  the API users don't need to worry about such details.
> +
> +



> +2. The Design

Now it get's a little bit rougher:

> +
> +There's a single global cwq (gcwq) for each possible CPU and a pseudo
> +CPU for unbound wq.  A gcwq manages and serves out all the execution
> +contexts on the associated CPU.  cpu_workqueue's (cwq) of each wq are
> +mostly simple frontends to the associated gcwq.  When a work item is
> +queued, it's queued to the unified worklist of the target gcwq.  Each
> +gcwq maintains pool of workers used to process the worklist.

Hm. That hurt my brain a little. :) 
What about smth along the lines:

In order to ease the asynchronous execution of functions a new
abstraction, the work item, is introduced.

A work item is a simple struct that holds a pointer to the
function that is to be executed asynchronously. Whenever a driver or
subsystem wants a function to be executed asynchronously it has to set
up a work item pointing to that function and queue that work item on a
workqueue.

Special purpose threads, called worker threads,  execute the functions
off of the queue, one after the other. If no work is queued, the worker
threads become idle.

These worker threads are managed in so called thread-pools.

The cmwq design differentiates between the user-facing workqueues that
subsystems and drivers queue work items on and what queues the 
thread-pools actually work on.

There are worker-thread-pools for each possible CPU and one
worker-thread-pool whose threads are not bound to any specific CPU. Each
worker-thread-pool has it's own queue (called gcwq) from which it
executes work-items.  

When a driver or subsystem creates a workqueue it is
automatically associated with one of the gcwq's. For CPU-bound
workqueues they are associated to that specific CPU's gcwq. For
unbound workqueues, they are queued to the gcwq of the global
thread-pool. 

[Btw, I realized, now that I read the guidelines below, that this last
paragraph is probably incorrect? Is there an association or does the
enqueue-API automatically determine the CPU it needs to queue the work
item on?]

> +For any worker pool implementation, managing the concurrency level (how
> +many execution contexts are active) is an important issue.  cmwq tries
> +to keep the concurrency at minimal but sufficient level.
> +
> +Each gcwq bound to an actual CPU implements concurrency management by
> +hooking into the scheduler.  The gcwq is notified whenever an active
> +worker wakes up or sleeps and keeps track of the number of the
> +currently runnable workers.  Generally, work items are not expected to
> +hog CPU cycle and maintaining just enough concurrency to prevent work
> +processing from stalling should be optimal.  As long as there is one
> +or more runnable workers on the CPU, the gcwq doesn't start execution
> +of a new work, but, when the last running worker goes to sleep, it
> +immediately schedules a new worker so that the CPU doesn't sit idle
> +while there are pending work items.  This allows using minimal number
> +of workers without losing execution bandwidth.
> +
> +Keeping idle workers around doesn't cost other than the memory space
> +for kthreads, so cmwq holds onto idle ones for a while before killing
> +them.
> +
> +For an unbound wq, the above concurrency management doesn't apply and
> +the gcwq for the pseudo unbound CPU tries to start executing all work
> +items as soon as possible.  The responsibility of regulating
> +concurrency level is on the users.  There is also a flag to mark a
> +bound wq to ignore the concurrency management.  Please refer to the
> +Workqueue Attributes section for details.
> +
> +Forward progress guarantee relies on that workers can be created when
> +more execution contexts are necessary, which in turn is guaranteed
> +through the use of rescue workers.  

> +All wq which might be used in
> +memory reclamation path are required to have a rescuer reserved for
> +execution of the wq under memory pressure so that memory reclamation
> +for worker creation doesn't deadlock waiting for execution contexts to
> +free up.

All work items which might be used on code paths that handle memory 
reclaim are required to be queued on wq's that have a rescue-worker 
reserved for execution under memory pressure. Else it is possible that 
the thread-pool deadlocks waiting for execution contexts to free up.


> +
> +
> +3. Workqueue Attributes
> +

3. Application Programming Interface (API)

> +alloc_workqueue() allocates a wq.  The original create_*workqueue()
> +functions are deprecated and scheduled for removal.  alloc_workqueue()
> +takes three arguments - @name, @flags and @max_active.  @name is the
> +name of the wq and also used as the name of the rescuer thread if
> +there is one.
> +
> +A wq no longer manages execution resources but serves as a domain for
> +forward progress guarantee, flush and work item attributes.  @flags
> +and @max_active control how work items are assigned execution
> +resources, scheduled and executed.
[snip]

I think it is worth mentioning all functions that are considered to be
part of the API here. 

[snip]

> +5. Guidelines
> +
> +* Do not forget to use WQ_RESCUER if a wq may process work items which
> +  are used during memory reclamation.  Each wq with WQ_RESCUER set has

hmm.. it's not "reclamation". But I can't say the correct term either. 

I'd say:
".. are used during memory reclaim."

> +  one rescuer thread reserved for it.  If there is dependency among
> +  multiple work items used during memory reclamation, they should be

"during memory reclaim" 

> +  queued to separate wq each with WQ_RESCUER.
> +
> +* Unless strict ordering is required, there is no need to use ST wq.
> +
> +* Unless there is a specific need, using 0 for @nr_active is
> +  recommended.  In most use cases, concurrency level usually stays
> +  well under the default limit.
> +
> +* A wq serves as a domain for forward progress guarantee (WQ_RESCUER),
> +  flush and work item attributes.  Work items which are not involved
> +  in memory reclamation and don't need to be flushed as a part of a

see above (-> memory reclaim)

> +  group of work items, and don't require any special attribute, can
> +  use one of the system wq.  There is no difference in execution
> +  characteristics between using a dedicated wq and a system wq.
> +
> +* Unless work items are expected to consume huge amount of CPU cycles,
> +  using bound wq is usually beneficial due to increased level of
> +  locality in wq operations and work item execution.

"Unless work items are expected to consume a huge amount of CPU
cycles, using a bound wq is usually beneficial due to the increased
level of locality in wq operations and work item exection. "

Btw, it is not clear to me, what you mean with "wq operations". 
Do the enqueuing API functions automatically determine the cpu they are
executed on and queue the workitem to the corresponding gcwq? Or do you
need to explicitly queue to a specific CPU?

Either you mean the operations that lead to the enqueueing of the
work-item, or you mean the operations done by the thread-pool?


... after thinking a bit, the wq implementation should obviously do the
automatic enqueuing on the nearest gcwq thingy... But that should
probably be mentioned in the API description. 
Although I have to admit I only skimmed over the flag description
above it seems you only mention the UNBOUND case and not the default
one?


Cheers,
Flo




