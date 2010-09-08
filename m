Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab0IHPke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:40:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:39750 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab0IHPkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:40:31 -0400
Message-ID: <4C87AE52.70401@kernel.org>
Date: Wed, 08 Sep 2010 17:40:02 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Christoph Lameter <cl@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Florian Mickler <florian@mickler.org>
Subject: [PATCH] workqueue: add documentation
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Sep 2010 15:40:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update copyright notice and add Documentation/workqueue.txt.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
Florian, I took good part from the previous overview document and tried
put them in a more compact form.  It would be great if you can review
this one too.  Thanks.

 Documentation/workqueue.txt |  336 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/workqueue.h   |    4
 kernel/workqueue.c          |   27 ++-
 3 files changed, 357 insertions(+), 10 deletions(-)

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
@@ -0,0 +1,336 @@
+
+Concurrency Managed Workqueue (cmwq)
+
+September, 2010		Tejun Heo <tj@kernel.org>
+
+CONTENTS
+
+1. Why cmwq?
+2. The Design
+3. Workqueue Attributes
+4. Example Execution Scenarios
+5. Guidelines
+
+
+1. Why cmwq?
+
+There are many cases where an asynchronous process execution context
+is needed and the workqueue (wq) is the most commonly used mechanism
+for such cases.  A work item describing which function to execute is
+queued on a workqueue which executes the work item in a process
+context asynchronously.
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
+MT wq albeit less severe on MT.  Each wq maintained its own seprate
+worker pool.  A MT wq could provid only one execution context per CPU
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
+2. The Design
+
+There's a single global cwq (gcwq) for each possible CPU and a pseudo
+CPU for unbound wq.  A gcwq manages and serves out all the execution
+contexts on the associated CPU.  cpu_workqueue's (cwq) of each wq are
+mostly simple frontends to the associated gcwq.  When a work item is
+queued, it's queued to the unified worklist of the target gcwq.  Each
+gcwq maintains pool of workers used to process the worklist.
+
+For any worker pool implmentation, managing the concurrency level (how
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
+through the use of rescue workers.  All wq which might be used in
+memory reclamation path are required to have a rescuer reserved for
+execution of the wq under memory pressure so that memory reclamation
+for worker creation doesn't deadlock waiting for execution contexts to
+free up.
+
+
+3. Workqueue Attributes
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
+	All wq which might be used in the memory reclamation paths
+	_MUST_ have this flag set.  This reserves one worker
+	exclusively for the execution of this wq under memory
+	pressure.
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
+4. Example Execution Scenarios
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
+5. Guidelines
+
+* Do not forget to use WQ_RESCUER if a wq may process work items which
+  are used during memory reclamation.  Each wq with WQ_RESCUER set has
+  one rescuer thread reserved for it.  If there is dependency among
+  multiple work items used during memory reclamation, they should be
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
+  in memory reclamation and don't need to be flushed as a part of a
+  group of work items, and don't require any special attribute, can
+  use one of the system wq.  There is no difference in execution
+  characteristics between using a dedicated wq and a system wq.
+
+* Unless work items are expected to consume huge amount of CPU cycles,
+  using bound wq is usually beneficial due to increased level of
+  locality in wq operations and work item execution.
