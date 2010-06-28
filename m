Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab0F1VGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 17:06:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:42884 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755364Ab0F1VG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 17:06:27 -0400
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Subject: [PATCHSET] workqueue: concurrency managed workqueue, take#6
Date: Mon, 28 Jun 2010 23:03:48 +0200
Message-Id: <1277759063-24607-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 28 Jun 2010 21:05:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This is the sixth take of cmwq (concurrency managed workqueue)
patchset.  It's on top of v2.6.35-rc3 + sched/core branch.  Git tree
is available at

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-cmwq

Linus, please read the merge plan section.

Thanks.


Table of contents
=================

A. This take
A-1. Merge plan
A-2. Changes from the last take[L]
A-3. TODOs
A-4. Patches and diffstat

B. General documentation of Concurrency Managed Workqueue (cmwq)
B-1. Why?
B-2. Overview
B-3. Unified worklist
B-4. Concurrency managed shared worker pool
B-5. Performance test results


A. This take
============

== A-1. Merge plan

Until now, cmwq patches haven't been fixed into permanent commits
mainly because sched patches which they are dependent upon made into
sched/core tree only recently.  After review, I'll put this take into
permanent commits.  Further developments or fixes will be done on top.

I believe that expected users of cmwq are generally in favor of the
flexibility added by cmwq.  In the last take, the following issues
were raised.

* Andi Kleen wanted to use high priority dispatching for memory fault
  handlers.  WQ_HIGHPRI is implemented to deal with this and padata
  integration.

* Andrew Morton raised two issues - workqueue users which use RT
  priority setting (ivtv) and padata integration.  kthread_worker
  which provides simple work based interface on top of kthread is
  added for cases where fixed association with a specific kthread is
  required for priority setting, cpuset and other task attributes
  adjustments.  This will also be used by virtnet.

  WQ_CPU_INTENSIVE is added to address padata integration.  When
  combined with WQ_HIGHPRI, all concurrency management logic is
  bypassed and cmwq works as a (conceptually) simple context provider
  and padata should operate without any noticeable difference.

* Daniel Walker objected on the ground that cmwq would make it
  impossible to adjust priorities of workqueue threads which can be
  useful as an ad-hoc optimization.  I don't plan to address this
  concern (suggested solution is to add userland visible knobs to
  adjust workqueue priorities) at this point because it is an
  implementation detail that userspace shouldn't diddle with in the
  first place.  If anyone is interested in the details of the
  dicussion, please read the dicussion thread on the last take[L].

Unless there are fundamental objections, I'll push the patchset out to
linux-next and proceed with the followings.

* integrating with other subsystems

* auditing all the workqueue users to better suit cmwq

* implementing features which will depend on cmwq (in-kernel media
  presence polling is the first target)

I expect there to be some, hopefully not too many, cross tree pulls in
the process and it will be a bit messy to back out later, so if you
have any fundamental concerns, please speak sooner than later.

Linus, it would be great if you let me know whether you agree with the
merge plan.


== A-2. Changes from the last take

* kthread_worker is added.  kthread_worker is a minimal work execution
  wrapper around kthread.  This is to ease using kthread for users
  which require control over thread attributes like priority, cpuset
  or whatever.

  kthreads can be created with kthread_worker_fn() directly or
  kthread_worker_fn() can be called after running any code the kthread
  needs to run for initialization.  The kthread can be treated the
  same way as any other kthread.

  - ivtv which used single threaded workqueue and bumped the priority
    of the worker to RT is converted to use kthread_worker.

* WQ_HIGHPRI and WQ_CPU_INTENSIVE are implemented.

  Works queued to a high priority workqueues are queued at the head of
  the global worklist and don't get blocked by other works.  They're
  dispatched to a worker as soon as possible.

  Works queued to a CPU intensive workqueue don't participate in
  concurrency management and thus don't block other works from
  executing.  This is to be used by works which are expected to burn
  considerable amount of CPU cycles.

  Workqueues w/ both WQ_HIGHPRI and WQ_CPU_INTENSIVE set don't get
  affected by or participate in concurrency management.  Works queued
  on such workqueues are dispatched immediately and don't affect other
  works.

  - pcrypt which creates workqueues and uses them for padata is
    converted to use high priority cpu intensive workqueues with
    max_active of 1, which should behave about the same as the
    original implementation.  Going forward, as workqueues themselves
    don't cost to have around anymore, it would be better to make
    padata to directly create workqueues for its users.

* To implement HIGHPRI and CPU_INTENSIVE, handling of worker flags
  which affect the running state for concurrency management has been
  updated.  worker_{set|clr}_flags() are added which manage the
  nr_running count according to worker state transitions.  This also
  makes nr_running counting easier to follow and verify.

* __create_workqueue() is renamed to alloc_workqueue() and is now a
  public interface.  It now interprets 0 max_active as the default
  max_active.  In the long run, all create*_workqueue() calls will be
  replaced with alloc_workqueue().

* Custom workqueue instrumentation via debugfs is removed.  The plan
  is to implement proper tracing API based instrumentation as
  suggested by Frederic Weisbecker.

* The original workqueue tracer code removed as suggested by Frederic
  Weisbecker.

* Comments updated/added.


== A-3. TODOs

* fscache/slow-work conversion is not in this series.  It needs to be
  performance tested and acked by David Howells.

* Audit each workqueue users and
  - make them use system workqueue instead if possible.
  - drop emergency worker if possible.
  - make them use alloc_workqueue() instead.

* Improve lockdep annotations.

* Implement workqueue tracer.


== A-4. Patches and diffstat

 0001-kthread-implement-kthread_worker.patch
 0002-ivtv-use-kthread_worker-instead-of-workqueue.patch
 0003-kthread-implement-kthread_data.patch
 0004-acpi-use-queue_work_on-instead-of-binding-workqueue-.patch
 0005-workqueue-kill-RT-workqueue.patch
 0006-workqueue-misc-cosmetic-updates.patch
 0007-workqueue-merge-feature-parameters-into-flags.patch
 0008-workqueue-define-masks-for-work-flags-and-conditiona.patch
 0009-workqueue-separate-out-process_one_work.patch
 0010-workqueue-temporarily-remove-workqueue-tracing.patch
 0011-workqueue-kill-cpu_populated_map.patch
 0012-workqueue-update-cwq-alignement.patch
 0013-workqueue-reimplement-workqueue-flushing-using-color.patch
 0014-workqueue-introduce-worker.patch
 0015-workqueue-reimplement-work-flushing-using-linked-wor.patch
 0016-workqueue-implement-per-cwq-active-work-limit.patch
 0017-workqueue-reimplement-workqueue-freeze-using-max_act.patch
 0018-workqueue-introduce-global-cwq-and-unify-cwq-locks.patch
 0019-workqueue-implement-worker-states.patch
 0020-workqueue-reimplement-CPU-hotplugging-support-using-.patch
 0021-workqueue-make-single-thread-workqueue-shared-worker.patch
 0022-workqueue-add-find_worker_executing_work-and-track-c.patch
 0023-workqueue-carry-cpu-number-in-work-data-once-executi.patch
 0024-workqueue-implement-WQ_NON_REENTRANT.patch
 0025-workqueue-use-shared-worklist-and-pool-all-workers-p.patch
 0026-workqueue-implement-worker_-set-clr-_flags.patch
 0027-workqueue-implement-concurrency-managed-dynamic-work.patch
 0028-workqueue-increase-max_active-of-keventd-and-kill-cu.patch
 0029-workqueue-s-__create_workqueue-alloc_workqueue-and-a.patch
 0030-workqueue-implement-several-utility-APIs.patch
 0031-workqueue-implement-high-priority-workqueue.patch
 0032-workqueue-implement-cpu-intensive-workqueue.patch
 0033-libata-take-advantage-of-cmwq-and-remove-concurrency.patch
 0034-async-use-workqueue-for-worker-pool.patch
 0035-pcrypt-use-HIGHPRI-and-CPU_INTENSIVE-workqueues-for-.patch

 arch/ia64/kernel/smpboot.c             |    2 
 arch/x86/kernel/smpboot.c              |    2 
 crypto/pcrypt.c                        |    4 
 drivers/acpi/osl.c                     |   40 
 drivers/ata/libata-core.c              |   20 
 drivers/ata/libata-eh.c                |    4 
 drivers/ata/libata-scsi.c              |   10 
 drivers/ata/libata-sff.c               |    9 
 drivers/ata/libata.h                   |    1 
 drivers/media/video/ivtv/ivtv-driver.c |   26 
 drivers/media/video/ivtv/ivtv-driver.h |    8 
 drivers/media/video/ivtv/ivtv-irq.c    |   15 
 drivers/media/video/ivtv/ivtv-irq.h    |    2 
 include/linux/cpu.h                    |    2 
 include/linux/kthread.h                |   65 
 include/linux/libata.h                 |    1 
 include/linux/workqueue.h              |  135 +
 include/trace/events/workqueue.h       |   92 
 kernel/async.c                         |  140 -
 kernel/kthread.c                       |  164 +
 kernel/power/process.c                 |   21 
 kernel/trace/Kconfig                   |   11 
 kernel/workqueue.c                     | 3260 +++++++++++++++++++++++++++------
 kernel/workqueue_sched.h               |   13 
 24 files changed, 3202 insertions(+), 845 deletions(-)


B. General documentation of Concurrency Managed Workqueue (cmwq)
================================================================

== B-1. Why?

cmwq brings the following benefits.

* By using a shared pool of workers for each cpu, cmwq uses resources
  more efficiently and the system no longer ends up with a lot of
  kernel threads which sit mostly idle.

  The separate dedicated per-cpu workers of the current workqueue
  implementation are already becoming an actual scalability issue and
  with increasing number of cpus it will only get worse.

* cmwq can provide flexible level of concurrency on demand.  While the
  current workqueue implementation keeps a lot of worker threads
  around, it still can only provide very limited level of concurrency.

* cmwq makes obtaining and using execution contexts easy, which
  results in less complexities and awkward compromises in its users.
  IOW, it transfers complexity from its users to core code.

  This will also allow implementation of things which need a flexible
  async mechanism but aren't important enough to have dedicated worker
  pools for.

* Work execution latencies are shorter and more predictable.  They are
  no longer affected by how long random previous works might take to
  finish but, in the most part, regulated only by processing cycle
  availability.

* Much less to worry about causing deadlocks around execution
  resources.

* All the above while maintaining behavior compatibility with the
  original workqueue and without any noticeable run time overhead.


== B-2. Overview

There are many cases where an execution context is needed and there
already are several mechanisms for them.  The most commonly used one
is workqueue (wq) and there also are slow_work, async and some other.
Although wq has been serving the kernel well for quite some time, it
has certain limitations which are becoming more apparent.

There are two types of wq, single and multi threaded.  Multi threaded
(MT) wq keeps a bound thread for each online CPU, while single
threaded (ST) wq uses single unbound thread.  The number of CPU cores
is continuously rising and there already are systems which saturate
the default 32k PID space during boot up.

Frustratingly, although MT wq end up spending a lot of resources, the
level of concurrency provided is unsatisfactory.  The limitation is
common to both ST and MT wq although it's less severe on MT ones.
Worker pools of wq are separate from each other.  A MT wq provides one
execution context per CPU while a ST wq one for the whole system,
which leads to various problems.

One of the problems is possible deadlock through dependency on the
same execution resource.  These can be detected reliably with lockdep
these days but in most cases the only solution is to create a
dedicated wq for one of the parties involved in the deadlock, which
feeds back into the waste of resources problem.  Also, when creating
such dedicated wq to avoid deadlock, in an attempt to avoid wasting
large number of threads just for that work, ST wq are often used but
in most cases ST wq are suboptimal compared to MT wq.

The tension between the provided level of concurrency and resource
usage forces its users to make unnecessary tradeoffs like libata
choosing to use ST wq for polling PIOs and accepting a silly
limitation that no two polling PIOs can progress at the same time.  As
MT wq don't provide much better concurrency, users which require
higher level of concurrency, like async or fscache, end up having to
implement their own worker pool.

Concurrency managed workqueue (cmwq) extends wq with focus on the
following goals.

* Maintain compatibility with the current workqueue API while removing
  above mentioned limitations.

* Provide single unified worker pool per cpu which can be shared by
  all users.  The worker pool and level of concurrency should be
  regulated automatically so that the API users don't need to worry
  about such details.

* Use what's necessary and allocate resources lazily on demand while
  guaranteeing forward progress where necessary.


== B-3. Unified worklist

There's a single global cwq (gcwq) per each possible cpu which
actually serves out execution contexts.  cpu_workqueue's (cwq) of each
wq are mostly simple frontends to the associated gcwq.  Under normal
operation, when a work is queued, it's queued to the gcwq of the cpu.
Each gcwq has its own pool of workers which is used to process all the
works queued on the cpu.  Works mostly don't care to which wq they're
queued to and using a unified worklist is straight forward but there
are a couple of areas where things become more complicated.

First, when queueing works from different wq on the same worklist,
ordering of works needs some care.  Originally, a MT wq allows a work
to be executed simultaneously on multiple cpus although it doesn't
allow the same one to execute simultaneously on the same cpu
(reentrant).  A ST wq allows only single work to be executed on any
cpu which guarantees both non-reentrancy and single-threadedness.

cmwq provides three different ordering modes - reentrant (default
mode), non-reentrant and single-cpu.  Single-cpu can be used to
achieve single-threadedness and full ordering if combined with
max_active of 1.  The default mode (reentrant) is the same as the
original MT wq.  The distinction between non-reentrancy and single-cpu
is made because some of the current ST wq users dont't need single
threadedness but only non-reentrancy.

Another area where things are more involved is wq flushing because wq
act as flushing domains.  cmwq implements it by coloring works and
tracking how many times each color is used.  When a work is queued to
a cwq, it's assigned a color and each cwq maintains counters for each
work color.  The color assignment changes on each wq flush attempt.  A
cwq can tell that all works queued before a certain wq flush attempt
have finished by waiting for all the colors upto that point to drain.
This maintains the original wq flush semantics without adding
unscalable overhead.


== B-4. Concurrency managed shared worker pool

For any worker pool, managing the concurrency level (how many workers
are executing simultaneously) is an important issue.  cmwq tries to
keep the concurrency at minimal but sufficient level.

Concurrency management is implemented by hooking into the scheduler.
The gcwq is notified whenever a busy worker wakes up or sleeps and
keeps track of the level of concurrency.  Generally, works aren't
supposed to be cpu cycle hogs and maintaining just enough concurrency
to prevent work processing from stalling is optimal.  As long as
there's one or more workers running on the cpu, no new worker is
scheduled, but, when the last running worker blocks, the gcwq
immediately schedules a new worker so that the cpu doesn't sit idle
while there are pending works.

This allows using minimal number of workers without losing execution
bandwidth.  Keeping idle workers around doesn't cost other than the
memory space for kthreads, so cmwq holds onto idle ones for a while
before killing them.

As multiple execution contexts are available for each wq, deadlocks
around execution contexts is much harder to create.  The default wq,
system_wq, has maximum concurrency level of 256 and unless there is a
scenario which can result in a dependency loop involving more than 254
workers, it won't deadlock.

Such forward progress guarantee relies on that workers can be created
when more execution contexts are necessary.  This is guaranteed by
using emergency workers.  All wq which can be used in memory
allocation path are required to have emergency workers which are
reserved for execution of that specific wq so that memory allocation
for worker creation doesn't deadlock on workers.


== B-5. Performance test results

NOTE: This is with the third take[3] but nothing which could affect
      performance noticeably has changed since then.

wq workload is generated by perf-wq.c module which is a very simple
synthetic wq load generator.  A work is described by five parameters -
burn_usecs, mean_sleep_msecs, mean_resched_msecs and factor.  It
randomly splits burn_usecs into two, burns the first part, sleeps for
0 - 2 * mean_sleep_msecs, burns what's left of burn_usecs and then
reschedules itself in 0 - 2 * mean_resched_msecs.  factor is used to
tune the number of cycles to match execution duration.

It issues three types of works - short, medium and long, each with two
burn durations L and S.

	burn/L(us)	burn/S(us)	mean_sleep(ms)	mean_resched(ms) cycles
 short	50		1		1		10		 454
 medium	50		2		10		50		 125
 long	50		4		100		250		 42

And then these works are put into the following workloads.  The lower
numbered workloads have more short/medium works.

 workload 0
 * 12 wq with 4 short works
 *  2 wq with 2 short  and 2 medium works
 *  4 wq with 2 medium and 1 long works
 *  8 wq with 1 long work

 workload 1
 *  8 wq with 4 short works
 *  2 wq with 2 short  and 2 medium works
 *  4 wq with 2 medium and 1 long works
 *  8 wq with 1 long work

 workload 2
 *  4 wq with 4 short works
 *  2 wq with 2 short  and 2 medium works
 *  4 wq with 2 medium and 1 long works
 *  8 wq with 1 long work

 workload 3
 *  2 wq with 4 short works
 *  2 wq with 2 short  and 2 medium works
 *  4 wq with 2 medium and 1 long works
 *  8 wq with 1 long work

 workload 4
 *  2 wq with 4 short works
 *  2 wq with 2 medium works
 *  4 wq with 2 medium and 1 long works
 *  8 wq with 1 long work

 workload 5
 *  2 wq with 2 medium works
 *  4 wq with 2 medium and 1 long works
 *  8 wq with 1 long work

The above wq loads are run in parallel with mencoder converting 76M
mjpeg file into mpeg4 which takes 25.59 seconds with standard
deviation of 0.19 without wq loading.  The CPU was intel netburst
celeron running at 2.66GHz which was chosen for its small cache size
and slowness.  wl0 and 1 are only tested for burn/S.  Each test case
was run 11 times and the first run was discarded.

	 vanilla/L	cmwq/L		vanilla/S	cmwq/S
 wl0					26.18 d0.24	26.27 d0.29
 wl1					26.50 d0.45	26.52 d0.23
 wl2	26.62 d0.35	26.53 d0.23	26.14 d0.22	26.12 d0.32
 wl3	26.30 d0.25	26.29 d0.26	25.94 d0.25	26.17 d0.30
 wl4	26.26 d0.23	25.93 d0.24	25.90 d0.23	25.91 d0.29
 wl5	25.81 d0.33	25.88 d0.25	25.63 d0.27	25.59 d0.26

There is no significant difference between the two.  Maybe the code
overhead and benefits coming from context sharing are canceling each
other nicely.  With longer burns, cmwq looks better but it's nothing
significant.  With shorter burns, other than wl3 spiking up for
vanilla which probably would go away if the test is repeated, the two
are performing virtually identically.

The above is exaggerated synthetic test result and the performance
difference will be even less noticeable in either direction under
realistic workloads.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/998652
[3] http://thread.gmane.org/gmane.linux.kernel/939353
