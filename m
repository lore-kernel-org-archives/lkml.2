Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab1C3VxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:53:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:26254 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964820Ab1C3VHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447452"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: srostedt@redhat.com, ak@linux.intel.com, rostedt@goodmis.org,
        a.p.zijlstra@chello.nl, ghaskins@novell.com, mingo@elte.hu,
        efault@gmx.de, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [90/275] sched: Try not to migrate higher priority RT tasks
Message-Id: <20110330210528.6FD313E1A06@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Commit: 43fa5460fe60dea5c610490a1d263415419c60f6 upstream

When first working on the RT scheduler design, we concentrated on
keeping all CPUs running RT tasks instead of having multiple RT
tasks on a single CPU waiting for the migration thread to move
them. Instead we take a more proactive stance and push or pull RT
tasks from one CPU to another on wakeup or scheduling.

When an RT task wakes up on a CPU that is running another RT task,
instead of preempting it and killing the cache of the running RT
task, we look to see if we can migrate the RT task that is waking
up, even if the RT task waking up is of higher priority.

This may sound a bit odd, but RT tasks should be limited in
migration by the user anyway. But in practice, people do not do
this, which causes high prio RT tasks to bounce around the CPUs.
This becomes even worse when we have priority inheritance, because
a high prio task can block on a lower prio task and boost its
priority. When the lower prio task wakes up the high prio task, if
it happens to be on the same CPU it will migrate off of it.

But in reality, the above does not happen much either, because the
wake up of the lower prio task, which has already been boosted, if
it was on the same CPU as the higher prio task, it would then
migrate off of it. But anyway, we do not want to migrate them
either.

To examine the scheduling, I created a test program and examined it
under kernelshark. The test program created CPU * 2 threads, where
each thread had a different priority. The program takes different
options. The options used in this change log was to have priority
inheritance mutexes or not.

All threads did the following loop:

static void grab_lock(long id, int iter, int l)
{
	ftrace_write("thread %ld iter %d, taking lock %d\n",
		     id, iter, l);
	pthread_mutex_lock(&locks[l]);
	ftrace_write("thread %ld iter %d, took lock %d\n",
		     id, iter, l);
	busy_loop(nr_tasks - id);
	ftrace_write("thread %ld iter %d, unlock lock %d\n",
		     id, iter, l);
	pthread_mutex_unlock(&locks[l]);
}

void *start_task(void *id)
{
	[...]
	while (!done) {
		for (l = 0; l < nr_locks; l++) {
			grab_lock(id, i, l);
			ftrace_write("thread %ld iter %d sleeping\n",
				     id, i);
			ms_sleep(id);
		}
		i++;
	}
	[...]
}

The busy_loop(ms) keeps the CPU spinning for ms milliseconds. The
ms_sleep(ms) sleeps for ms milliseconds. The ftrace_write() writes
to the ftrace buffer to help analyze via ftrace.

The higher the id, the higher the prio, the shorter it does the
busy loop, but the longer it spins. This is usually the case with
RT tasks, the lower priority tasks usually run longer than higher
priority tasks.

At the end of the test, it records the number of loops each thread
took, as well as the number of voluntary preemptions, non-voluntary
preemptions, and number of migrations each thread took, taking the
information from /proc/$$/sched and /proc/$$/status.

Running this on a 4 CPU processor, the results without changes to
the kernel looked like this:

Task        vol    nonvol   migrated     iterations
Signed-off-by: Andi Kleen <ak@linux.intel.com>

----        ---    ------   --------     ----------
  0:         53      3220       1470             98
  1:        562       773        724             98
  2:        752       933       1375             98
  3:        749        39        697             98
  4:        758         5        515             98
  5:        764         2        679             99
  6:        761         2        535             99
  7:        757         3        346             99

total:     5156       4977      6341            787

Each thread regardless of priority migrated a few hundred times.
The higher priority tasks, were a little better but still took
quite an impact.

By letting higher priority tasks bump the lower prio task from the
CPU, things changed a bit:

Task        vol    nonvol   migrated     iterations
----        ---    ------   --------     ----------
  0:         37      2835       1937             98
  1:        666      1821       1865             98
  2:        654      1003       1385             98
  3:        664       635        973             99
  4:        698       197        352             99
  5:        703       101        159             99
  6:        708         1         75             99
  7:        713         1          2             99

total:     4843       6594      6748            789

The total # of migrations did not change (several runs showed the
difference all within the noise). But we now see a dramatic
improvement to the higher priority tasks. (kernelshark showed that
the watchdog timer bumped the highest priority task to give it the
2 count. This was actually consistent with every run).

Notice that the # of iterations did not change either.

The above was with priority inheritance mutexes. That is, when the
higher prority task blocked on a lower priority task, the lower
priority task would inherit the higher priority task (which shows
why task 6 was bumped so many times). When not using priority
inheritance mutexes, the current kernel shows this:

Task        vol    nonvol   migrated     iterations
----        ---    ------   --------     ----------
  0:         56      3101       1892             95
  1:        594       713        937             95
  2:        625       188        618             95
  3:        628         4        491             96
  4:        640         7        468             96
  5:        631         2        501             96
  6:        641         1        466             96
  7:        643         2        497             96

total:     4458       4018      5870            765

Not much changed with or without priority inheritance mutexes. But
if we let the high priority task bump lower priority tasks on
wakeup we see:

Task        vol    nonvol   migrated     iterations
----        ---    ------   --------     ----------
  0:        115      3439       2782             98
  1:        633      1354       1583             99
  2:        652       919       1218             99
  3:        645       713        934             99
  4:        690         3          3             99
  5:        694         1          4             99
  6:        720         3          4             99
  7:        747         0          1            100

Which shows a even bigger change. The big difference between task 3
and task 4 is because we have only 4 CPUs on the machine, causing
the 4 highest prio tasks to always have preference.

Although I did not measure cache misses, and I'm sure there would
be little to measure since the test was not data intensive, I could
imagine large improvements for higher priority tasks when dealing
with lower priority tasks. Thus, I'm satisfied with making the
change and agreeing with what Gregory Haskins argued a few years
ago when we first had this discussion.

One final note. All tasks in the above tests were RT tasks. Any RT
task will always preempt a non RT task that is running on the CPU
the RT task wants to run on.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gregory Haskins <ghaskins@novell.com>
LKML-Reference: <20100921024138.605460343@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched_rt.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

Index: linux-2.6.35.y/kernel/sched_rt.c
===================================================================
--- linux-2.6.35.y.orig/kernel/sched_rt.c	2011-03-29 22:51:34.149849359 -0700
+++ linux-2.6.35.y/kernel/sched_rt.c	2011-03-29 23:55:05.138335699 -0700
@@ -960,18 +960,18 @@
 	 * runqueue. Otherwise simply start this RT task
 	 * on its current runqueue.
 	 *
-	 * We want to avoid overloading runqueues. Even if
-	 * the RT task is of higher priority than the current RT task.
-	 * RT tasks behave differently than other tasks. If
-	 * one gets preempted, we try to push it off to another queue.
-	 * So trying to keep a preempting RT task on the same
-	 * cache hot CPU will force the running RT task to
-	 * a cold CPU. So we waste all the cache for the lower
-	 * RT task in hopes of saving some of a RT task
-	 * that is just being woken and probably will have
-	 * cold cache anyway.
+	 * We want to avoid overloading runqueues. If the woken
+	 * task is a higher priority, then it will stay on this CPU
+	 * and the lower prio task should be moved to another CPU.
+	 * Even though this will probably make the lower prio task
+	 * lose its cache, we do not want to bounce a higher task
+	 * around just because it gave up its CPU, perhaps for a
+	 * lock?
+	 *
+	 * For equal prio tasks, we just let the scheduler sort it out.
 	 */
 	if (unlikely(rt_task(rq->curr)) &&
+	    rq->curr->prio < p->prio &&
 	    (p->rt.nr_cpus_allowed > 1)) {
 		int cpu = find_lowest_rq(p);
 
@@ -1491,6 +1491,8 @@
 	if (!task_running(rq, p) &&
 	    !test_tsk_need_resched(rq->curr) &&
 	    has_pushable_tasks(rq) &&
+	    rt_task(rq->curr) &&
+	    rq->curr->prio < p->prio &&
 	    p->rt.nr_cpus_allowed > 1)
 		push_rt_tasks(rq);
 }
