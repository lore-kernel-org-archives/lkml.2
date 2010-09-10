Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386Ab0IJK1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:27:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:35391 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab0IJK1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:27:01 -0400
Message-ID: <4C8A07B3.1050603@kernel.org>
Date: Fri, 10 Sep 2010 12:25:55 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Christoph Lameter <cl@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH UPDATED] workqueue: add documentation
References: <4C87AE52.70401@kernel.org>	<4C87B101.2080608@kernel.org>	<20100909100229.250900f0@schatten.dmk.lab>	<4C88B55E.90203@kernel.org> <20100909205056.1ac7989a@schatten.dmk.lab>
In-Reply-To: <20100909205056.1ac7989a@schatten.dmk.lab>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Sep 2010 10:25:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/09/2010 08:50 PM, Florian Mickler wrote:
>> The backend mechanism is called Global CPU Workqueue (gcwq).  There is
> 
> I tried to avoid that name. It somehow is confusing to me . Global/Local
> in context of CPU is somehow associated with CPU locality in my mind.
> Also the name doesn't fit for the unbound gcwq.

Hmm... yeah, it makes sense from the implementation POV as they're
global to a CPU and the unbound gcwq is bound to pseudo unbound CPU.
I just dropped the expanded version and just used gcwq as you
suggested.

>> Yeah, that would be nice but a slightly larger task that I would like
>> to postpone at this point.  :-)
> 
> Ah well, I may just give it a go then... 

That would be great.

>> Yeah, queue_work() queues works on the gcwq of the local CPU.  It can
>> be overridden by queue_work_on().  The unbound is special case where
>> the workqueue always sends works to the unbound gcwq which is served
>> by unbound workers.  Did the update in the design section explain
>> enough or do you think there needs to be more explanation?
> 
> I'm looking forward to reading the new version en
> bloc, but if I can trust my gut feeling, I'm ok with it now. :)
> 
> Let's see if someone else with more kernel-experience has something to
> add, but here you've got my
> 
> Reviewed-By: Florian Mickler <florian@mickler.org>

Here's the current version.  If it looks good to you, I'll push it
upstream.

Thanks.

Subject: workqueue: add documentation

Update copyright notice and add Documentation/workqueue.txt.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-By: Florian Mickler <florian@mickler.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 Documentation/workqueue.txt |  380 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/workqueue.h   |    4
 kernel/workqueue.c          |   27 +--
 3 files changed, 401 insertions(+), 10 deletions(-)

Index: work/kernel/workqueue.c
===================================================================
--- work.orig/kernel/workqueue.c
+++ work/kernel/workqueue.c
@@ -1,19 +1,26 @@
 /*
- * linux/kernel/workqueue.c
+ * kernel/workqueue.c - generic async execution with shared worker pool
  *
- * Generic mechanism for defining kernel helper threads for running
- * arbitrary tasks in process context.
+ * Copyright (C) 2002		Ingo Molnar
  *
- * Started by Ingo Molnar, Copyright (C) 2002
+ *   Derived from the taskqueue/keventd code by:
+ *     David Woodhouse <dwmw2@infradead.org>
+ *     Andrew Morton
+ *     Kai Petzke <wpp@marie.physik.tu-berlin.de>
+ *     Theodore Ts'o <tytso@mit.edu>
  *
- * Derived from the taskqueue/keventd code by:
+ * Made to use alloc_percpu by Christoph Lameter.
  *
- *   David Woodhouse <dwmw2@infradead.org>
- *   Andrew Morton
- *   Kai Petzke <wpp@marie.physik.tu-berlin.de>
- *   Theodore Ts'o <tytso@mit.edu>
+ * Copyright (C) 2010		SUSE Linux Products GmbH
+ * Copyright (C) 2010		Tejun Heo <tj@kernel.org>
  *
- * Made to use alloc_percpu by Christoph Lameter.
+ * This is the generic async execution mechanism.  Work items as are
+ * executed in process context.  The worker pool is shared and
+ * automatically managed.  There is one worker pool for each CPU and
+ * one extra for works which are better served by workers which are
+ * not bound to any specific CPU.
+ *
+ * Please read Documentation/workqueue.txt for details.
  */

 #include <linux/module.h>
Index: work/include/linux/workqueue.h
===================================================================
--- work.orig/include/linux/workqueue.h
+++ work/include/linux/workqueue.h
@@ -235,6 +235,10 @@ static inline unsigned int work_static(s
 #define work_clear_pending(work) \
 	clear_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))

+/*
+ * Workqueue flags and constants.  For details, please refer to
+ * Documentation/workqueue.txt.
+ */
 enum {
 	WQ_NON_REENTRANT	= 1 << 0, /* guarantee non-reentrance */
 	WQ_UNBOUND		= 1 << 1, /* not bound to any cpu */
Index: work/Documentation/workqueue.txt
===================================================================
--- /dev/null
+++ work/Documentation/workqueue.txt
@@ -0,0 +1,380 @@
+
+Concurrency Managed Workqueue (cmwq)
+
+September, 2010		Tejun Heo <tj@kernel.org>
+			Florian Mickler <florian@mickler.org>
+
+CONTENTS
+
+1. Introduction
+2. Why cmwq?
+3. The Design
+4. Application Programming Interface (API)
+5. Example Execution Scenarios
+6. Guidelines
+
+
+1. Introduction
+
+There are many cases where an asynchronous process execution context
+is needed and the workqueue (wq) API is the most commonly used
+mechanism for such cases.
+
+When such an asynchronous execution context is needed, a work item
+describing which function to execute is put on a queue.  An
+independent thread serves as the asynchronous execution context.  The
+queue is called workqueue and the thread is called worker.
+
+While there are work items on the workqueue the worker executes the
+functions associated with the work items one after the other.  When
+there is no work item left on the workqueue the worker becomes idle.
+When a new work item gets queued, the worker begins executing again.
+
+
+2. Why cmwq?
+
+In the original wq implementation, a multi threaded (MT) wq had one
+worker thread per CPU and a single threaded (ST) wq had one worker
+thread system-wide.  A single MT wq needed to keep around the same
+number of workers as the number of CPUs.  The kernel grew a lot of MT
+wq users over the years and with the number of CPU cores continuously
+rising, some systems saturated the default 32k PID space just booting
+up.
+
+Although MT wq wasted a lot of resource, the level of concurrency
+provided was unsatisfactory.  The limitation was common to both ST and
+MT wq albeit less severe on MT.  Each wq maintained its own separate
+worker pool.  A MT wq could provide only one execution context per CPU
+while a ST wq one for the whole system.  Work items had to compete for
+those very limited execution contexts leading to various problems
+including proneness to deadlocks around the single execution context.
+
+The tension between the provided level of concurrency and resource
+usage also forced its users to make unnecessary tradeoffs like libata
+choosing to use ST wq for polling PIOs and accepting an unnecessary
+limitation that no two polling PIOs can progress at the same time.  As
+MT wq don't provide much better concurrency, users which require
+higher level of concurrency, like async or fscache, had to implement
+their own thread pool.
+
+Concurrency Managed Workqueue (cmwq) is a reimplementation of wq with
+focus on the following goals.
+
+* Maintain compatibility with the original workqueue API.
+
+* Use per-CPU unified worker pools shared by all wq to provide
+  flexible level of concurrency on demand without wasting a lot of
+  resource.
+
+* Automatically regulate worker pool and level of concurrency so that
+  the API users don't need to worry about such details.
+
+
+3. The Design
+
+In order to ease the asynchronous execution of functions a new
+abstraction, the work item, is introduced.
+
+A work item is a simple struct that holds a pointer to the function
+that is to be executed asynchronously.  Whenever a driver or subsystem
+wants a function to be executed asynchronously it has to set up a work
+item pointing to that function and queue that work item on a
+workqueue.
+
+Special purpose threads, called worker threads, execute the functions
+off of the queue, one after the other.  If no work is queued, the
+worker threads become idle.  These worker threads are managed in so
+called thread-pools.
+
+Subsystems and drivers can create and queue work items on workqueues
+as they see fit.
+
+By default, workqueues are per-cpu.  Work items are queued and
+executed on the same CPU as the issuer.  These workqueues and work
+items are said to be "bound".  A workqueue can be specifically
+configured to be "unbound" in which case work items queued on the
+workqueue are executed by worker threads not bound to any specific
+CPU.
+
+The cmwq design differentiates between the user-facing workqueues that
+subsystems and drivers queue work items on and the backend mechanism
+which manages thread-pool and processes the queued work items.
+
+The backend mechanism is called gcwq.  There is one gcwq for each
+possible CPU and one gcwq to serve work items queued on unbound
+workqueues.
+
+When a work item is queued to a workqueue, the target gcwq is
+determined according to the queue parameters and workqueue attributes
+and queued on the shared worklist of the gcwq.  For example, unless
+specifically overridden, a work item of a bound workqueue will be
+queued on the worklist of the gcwq of the CPU the issuer is running
+on.
+
+For any worker pool implementation, managing the concurrency level (how
+many execution contexts are active) is an important issue.  cmwq tries
+to keep the concurrency at minimal but sufficient level.
+
+Each gcwq bound to an actual CPU implements concurrency management by
+hooking into the scheduler.  The gcwq is notified whenever an active
+worker wakes up or sleeps and keeps track of the number of the
+currently runnable workers.  Generally, work items are not expected to
+hog CPU cycle and maintaining just enough concurrency to prevent work
+processing from stalling should be optimal.  As long as there is one
+or more runnable workers on the CPU, the gcwq doesn't start execution
+of a new work, but, when the last running worker goes to sleep, it
+immediately schedules a new worker so that the CPU doesn't sit idle
+while there are pending work items.  This allows using minimal number
+of workers without losing execution bandwidth.
+
+Keeping idle workers around doesn't cost other than the memory space
+for kthreads, so cmwq holds onto idle ones for a while before killing
+them.
+
+For an unbound wq, the above concurrency management doesn't apply and
+the gcwq for the pseudo unbound CPU tries to start executing all work
+items as soon as possible.  The responsibility of regulating
+concurrency level is on the users.  There is also a flag to mark a
+bound wq to ignore the concurrency management.  Please refer to the
+Workqueue Attributes section for details.
+
+Forward progress guarantee relies on that workers can be created when
+more execution contexts are necessary, which in turn is guaranteed
+through the use of rescue workers.  All work items which might be used
+on code paths that handle memory reclaim are required to be queued on
+wq's that have a rescue-worker reserved for execution under memory
+pressure.  Else it is possible that the thread-pool deadlocks waiting
+for execution contexts to free up.
+
+
+4. Application Programming Interface (API)
+
+alloc_workqueue() allocates a wq.  The original create_*workqueue()
+functions are deprecated and scheduled for removal.  alloc_workqueue()
+takes three arguments - @name, @flags and @max_active.  @name is the
+name of the wq and also used as the name of the rescuer thread if
+there is one.
+
+A wq no longer manages execution resources but serves as a domain for
+forward progress guarantee, flush and work item attributes.  @flags
+and @max_active control how work items are assigned execution
+resources, scheduled and executed.
+
+@flags:
+
+  WQ_NON_REENTRANT
+
+	By default, a wq guarantees non-reentrance only on the same
+	CPU.  A work may not be executed concurrently on the same CPU
+	by multiple workers but is allowed to be executed concurrently
+	on multiple CPUs.  This flag makes sure non-reentrance is
+	enforced across all CPUs.  Work items queued to a
+	non-reentrant wq are guaranteed to be executed by at most one
+	worker system-wide at any given time.
+
+  WQ_UNBOUND
+
+	Work items queued to an unbound wq are served by a special
+	gcwq which hosts workers which are not bound to any specific
+	CPU.  This makes the wq behave as a simple execution context
+	provider without concurrency management.  The unbound gcwq
+	tries to start execution of work items as soon as possible.
+	Unbound wq sacrifices locality but is useful for the following
+	cases.
+
+	* Wide fluctuation in the concurrency level requirement is
+	  expected and using bound wq may end up creating large number
+	  of mostly unused workers across different CPUs as the issuer
+	  hops through different CPUs.
+
+	* Long running CPU intensive workloads which can be better
+	  managed by the system scheduler.
+
+  WQ_FREEZEABLE
+
+	A freezeable wq participates in the freeze phase of the system
+	suspend operations.  Work items on the wq are drained and no
+	new work item starts execution until thawed.
+
+  WQ_RESCUER
+
+	All wq which might be used in the memory reclaim paths _MUST_
+	have this flag set.  This reserves one worker exclusively for
+	the execution of this wq under memory pressure.
+
+  WQ_HIGHPRI
+
+	Work items of a highpri wq are queued at the head of the
+	worklist of the target gcwq and start execution regardless of
+	the current concurrency level.  In other words, highpri work
+	items will always start execution as soon as execution
+	resource is available.
+
+	Ordering among highpri work items is preserved - a highpri
+	work item queued after another highpri work item will start
+	execution after the earlier highpri work item starts.
+
+	Although highpri work items are not held back by other
+	runnable work items, they still contribute to the concurrency
+	level.  Highpri work items in runnable state will prevent
+	non-highpri work items from starting execution.
+
+	This flag is meaningless for unbound wq.
+
+  WQ_CPU_INTENSIVE
+
+	Work items of a CPU intensive wq do not contribute to the
+	concurrency level.  In other words, Runnable CPU intensive
+	work items will not prevent other work items from starting
+	execution.  This is useful for bound work items which are
+	expected to hog CPU cycles so that their execution is
+	regulated by the system scheduler.
+
+	Although CPU intensive work items don't contribute to the
+	concurrency level, start of their executions is still
+	regulated by the concurrency management and runnable
+	non-CPU-intensive work items can delay execution of CPU
+	intensive work items.
+
+	This flag is meaningless for unbound wq.
+
+  WQ_HIGHPRI | WQ_CPU_INTENSIVE
+
+	This combination makes the wq avoid interaction with
+	concurrency management completely and behave as a simple
+	per-CPU execution context provider.  Work items queued on a
+	highpri CPU-intensive wq start execution as soon as resources
+	are available and don't affect execution of other work items.
+
+@max_active:
+
+@max_active determines the maximum number of execution contexts per
+CPU which can be assigned to the work items of a wq.  For example,
+with @max_active of 16, at most 16 work items of the wq can be
+executing at the same time per CPU.
+
+Currently, for a bound wq, the maximum limit for @max_active is 512
+and the default value used when 0 is specified is 256.  For an unbound
+wq, the limit is higher of 512 and 4 * num_possible_cpus().  These
+values are chosen sufficiently high such that they are not the
+limiting factor while providing protection in runaway cases.
+
+The number of active work items of a wq is usually regulated by the
+users of the wq, more specifically, by how many work items the users
+may queue at the same time.  Unless there is a specific need for
+throttling the number of active work items, specifying '0' is
+recommended.
+
+Some users depend on the strict execution ordering of ST wq.  The
+combination of @max_active of 1 and WQ_UNBOUND is used to achieve this
+behavior.  Work items on such wq are always queued to the unbound gcwq
+and only one work item can be active at any given time thus achieving
+the same ordering property as ST wq.
+
+
+5. Example Execution Scenarios
+
+The following example execution scenarios try to illustrate how cmwq
+behave under different configurations.
+
+ Work items w0, w1, w2 are queued to a bound wq q0 on the same CPU.
+ w0 burns CPU for 5ms then sleeps for 10ms then burns CPU for 5ms
+ again before finishing.  w1 and w2 burn CPU for 5ms then sleep for
+ 10ms.
+
+Ignoring all other tasks, works and processing overhead, and assuming
+simple FIFO scheduling, the following is one highly simplified version
+of possible sequences of events with the original wq.
+
+ TIME IN MSECS	EVENT
+ 0		w0 starts and burns CPU
+ 5		w0 sleeps
+ 15		w0 wakes up and burns CPU
+ 20		w0 finishes
+ 20		w1 starts and burns CPU
+ 25		w1 sleeps
+ 35		w1 wakes up and finishes
+ 35		w2 starts and burns CPU
+ 40		w2 sleeps
+ 50		w2 wakes up and finishes
+
+And with cmwq with @max_active >= 3,
+
+ TIME IN MSECS	EVENT
+ 0		w0 starts and burns CPU
+ 5		w0 sleeps
+ 5		w1 starts and burns CPU
+ 10		w1 sleeps
+ 10		w2 starts and burns CPU
+ 15		w2 sleeps
+ 15		w0 wakes up and burns CPU
+ 20		w0 finishes
+ 20		w1 wakes up and finishes
+ 25		w2 wakes up and finishes
+
+If @max_active == 2,
+
+ TIME IN MSECS	EVENT
+ 0		w0 starts and burns CPU
+ 5		w0 sleeps
+ 5		w1 starts and burns CPU
+ 10		w1 sleeps
+ 15		w0 wakes up and burns CPU
+ 20		w0 finishes
+ 20		w1 wakes up and finishes
+ 20		w2 starts and burns CPU
+ 25		w2 sleeps
+ 35		w2 wakes up and finishes
+
+Now, let's assume w1 and w2 are queued to a different wq q1 which has
+WQ_HIGHPRI set,
+
+ TIME IN MSECS	EVENT
+ 0		w1 and w2 start and burn CPU
+ 5		w1 sleeps
+ 10		w2 sleeps
+ 10		w0 starts and burns CPU
+ 15		w0 sleeps
+ 15		w1 wakes up and finishes
+ 20		w2 wakes up and finishes
+ 25		w0 wakes up and burns CPU
+ 30		w0 finishes
+
+If q1 has WQ_CPU_INTENSIVE set,
+
+ TIME IN MSECS	EVENT
+ 0		w0 starts and burns CPU
+ 5		w0 sleeps
+ 5		w1 and w2 start and burn CPU
+ 10		w1 sleeps
+ 15		w2 sleeps
+ 15		w0 wakes up and burns CPU
+ 20		w0 finishes
+ 20		w1 wakes up and finishes
+ 25		w2 wakes up and finishes
+
+
+6. Guidelines
+
+* Do not forget to use WQ_RESCUER if a wq may process work items which
+  are used during memory reclaim.  Each wq with WQ_RESCUER set has one
+  rescuer thread reserved for it.  If there is dependency among
+  multiple work items used during memory reclaim, they should be
+  queued to separate wq each with WQ_RESCUER.
+
+* Unless strict ordering is required, there is no need to use ST wq.
+
+* Unless there is a specific need, using 0 for @nr_active is
+  recommended.  In most use cases, concurrency level usually stays
+  well under the default limit.
+
+* A wq serves as a domain for forward progress guarantee (WQ_RESCUER),
+  flush and work item attributes.  Work items which are not involved
+  in memory reclaim and don't need to be flushed as a part of a group
+  of work items, and don't require any special attribute, can use one
+  of the system wq.  There is no difference in execution
+  characteristics between using a dedicated wq and a system wq.
+
+* Unless work items are expected to consume a huge amount of CPU
+  cycles, using a bound wq is usually beneficial due to the increased
+  level of locality in wq operations and work item execution.
