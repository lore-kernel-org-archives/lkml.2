Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab0IIKW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 06:22:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:42246 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab0IIKWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 06:22:45 -0400
Message-ID: <4C88B55E.90203@kernel.org>
Date: Thu, 09 Sep 2010 12:22:22 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Christoph Lameter <cl@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH UPDATED] workqueue: add documentation
References: <4C87AE52.70401@kernel.org>	<4C87B101.2080608@kernel.org> <20100909100229.250900f0@schatten.dmk.lab>
In-Reply-To: <20100909100229.250900f0@schatten.dmk.lab>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 10:22:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/09/2010 10:02 AM, Florian Mickler wrote:
> Perfect timing. Just enough for the details to get a little foggy, 
> while still knowing a little bit what you want to talk about. 
> :-)

:-)

Added Introduction and updated Why cmwq section as suggested.

>> +2. The Design
> 
> Now it get's a little bit rougher:
> 
>> +
>> +There's a single global cwq (gcwq) for each possible CPU and a pseudo
>> +CPU for unbound wq.  A gcwq manages and serves out all the execution
>> +contexts on the associated CPU.  cpu_workqueue's (cwq) of each wq are
>> +mostly simple frontends to the associated gcwq.  When a work item is
>> +queued, it's queued to the unified worklist of the target gcwq.  Each
>> +gcwq maintains pool of workers used to process the worklist.
> 
> Hm. That hurt my brain a little. :) 

Yeap, that's a lot of overly compressed information there.

> What about smth along the lines:
> 
> In order to ease the asynchronous execution of functions a new
> abstraction, the work item, is introduced.
> 
> A work item is a simple struct that holds a pointer to the
> function that is to be executed asynchronously. Whenever a driver or
> subsystem wants a function to be executed asynchronously it has to set
> up a work item pointing to that function and queue that work item on a
> workqueue.
> 
> Special purpose threads, called worker threads,  execute the functions
> off of the queue, one after the other. If no work is queued, the worker
> threads become idle.
> 
> These worker threads are managed in so called thread-pools.
> 
> The cmwq design differentiates between the user-facing workqueues that
> subsystems and drivers queue work items on and what queues the 
> thread-pools actually work on.
> 
> There are worker-thread-pools for each possible CPU and one
> worker-thread-pool whose threads are not bound to any specific CPU. Each
> worker-thread-pool has it's own queue (called gcwq) from which it
> executes work-items.  
> 
> When a driver or subsystem creates a workqueue it is
> automatically associated with one of the gcwq's. For CPU-bound
> workqueues they are associated to that specific CPU's gcwq. For
> unbound workqueues, they are queued to the gcwq of the global
> thread-pool. 
> 
> [Btw, I realized, now that I read the guidelines below, that this last
> paragraph is probably incorrect? Is there an association or does the
> enqueue-API automatically determine the CPU it needs to queue the work
> item on?]

Bound workqueues are per-cpu and by default work items will be queued
and processed on the same cpu as the issuer.  Unbound ones are
system-wide.  How about something like the following?


In order to ease the asynchronous execution of functions a new
abstraction, the work item, is introduced.

A work item is a simple struct that holds a pointer to the function
that is to be executed asynchronously.  Whenever a driver or subsystem
wants a function to be executed asynchronously it has to set up a work
item pointing to that function and queue that work item on a
workqueue.

Special purpose threads, called worker threads, execute the functions
off of the queue, one after the other.  If no work is queued, the
worker threads become idle.  These worker threads are managed in so
called thread-pools.

Subsystems and drivers can create and queue work items on workqueues
as they see fit.

By default, workqueues are per-cpu.  Work items are queued and
executed on the same CPU as the issuer.  These workqueues and work
items are said to be "bound".  A workqueue can be specifically
configured to be "unbound" in which case work items queued on the
workqueue are executed by worker threads not bound to any specific
CPU.

The cmwq design differentiates between the user-facing workqueues that
subsystems and drivers queue work items on and the backend mechanism
which manages thread-pool and processes the queued work items.

The backend mechanism is called Global CPU Workqueue (gcwq).  There is
one gcwq for each possible CPU and one gcwq to serve work items queued
on unbound workqueues.

When a work item is queued to a workqueue, the target gcwq is
determined according to the queue parameters and workqueue attributes
and queued on the shared worklist of the gcwq.  For example, unless
specifically overridden, a work item of a bound workqueue will be
queued on the worklist of the gcwq of the CPU the issuer is running
on.

>> +All wq which might be used in
>> +memory reclamation path are required to have a rescuer reserved for
>> +execution of the wq under memory pressure so that memory reclamation
>> +for worker creation doesn't deadlock waiting for execution contexts to
>> +free up.
> 
> All work items which might be used on code paths that handle memory 
> reclaim are required to be queued on wq's that have a rescue-worker 
> reserved for execution under memory pressure. Else it is possible that 
> the thread-pool deadlocks waiting for execution contexts to free up.

Updated as suggested.

>> +
>> +
>> +3. Workqueue Attributes
>> +
> 
> 3. Application Programming Interface (API)
> 
>> +alloc_workqueue() allocates a wq.  The original create_*workqueue()
>> +functions are deprecated and scheduled for removal.  alloc_workqueue()
>> +takes three arguments - @name, @flags and @max_active.  @name is the
>> +name of the wq and also used as the name of the rescuer thread if
>> +there is one.
>> +
>> +A wq no longer manages execution resources but serves as a domain for
>> +forward progress guarantee, flush and work item attributes.  @flags
>> +and @max_active control how work items are assigned execution
>> +resources, scheduled and executed.
> [snip]
> 
> I think it is worth mentioning all functions that are considered to be
> part of the API here. 

Yeah, that would be nice but a slightly larger task that I would like
to postpone at this point.  :-)

> "Unless work items are expected to consume a huge amount of CPU
> cycles, using a bound wq is usually beneficial due to the increased
> level of locality in wq operations and work item exection. "

So updated.

> Btw, it is not clear to me, what you mean with "wq operations". 

Queueing, dispatching and other book keeping operations.

> Do the enqueuing API functions automatically determine the cpu they are
> executed on and queue the workitem to the corresponding gcwq? Or do you
> need to explicitly queue to a specific CPU?
> 
> Either you mean the operations that lead to the enqueueing of the
> work-item, or you mean the operations done by the thread-pool?
> 
> ... after thinking a bit, the wq implementation should obviously do the
> automatic enqueuing on the nearest gcwq thingy... But that should
> probably be mentioned in the API description. 
> Although I have to admit I only skimmed over the flag description
> above it seems you only mention the UNBOUND case and not the default
> one?

Yeah, queue_work() queues works on the gcwq of the local CPU.  It can
be overridden by queue_work_on().  The unbound is special case where
the workqueue always sends works to the unbound gcwq which is served
by unbound workers.  Did the update in the design section explain
enough or do you think there needs to be more explanation?

Thanks.

-- 
tejun
