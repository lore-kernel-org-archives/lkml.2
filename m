Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab2FNWRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 18:17:13 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39167 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab2FNWRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 18:17:12 -0400
Date: Thu, 14 Jun 2012 15:13:31 -0700
From: Silas Boyd-Wickizer <sbw@mit.edu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 1/5] kthread: Implement park/unpark facility
Message-ID: <20120614221308.GA31815@mit.edu>
References: <20120613102823.373180763@linutronix.de>
 <20120613105815.132283147@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613105815.132283147@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Attached is a rough patch that uses park/unpark for workqueue idle
threads.  The patch is a hack, it probably has bugs, and it certainly
doesn't simplify the workqueue code.  Perhaps, however, the patch
might be useful in guiding future changes to smp_boot_threads or
workqueues.

A difficulty in applying park/unpark (or smp_boot_threads
potentially), it that there is no single per-CPU thread for each CPU.
That is, the thread that starts out as the initial worker/idle thread
could be different from any thread that is idling when a CPU goes
offline.  An additional complication is that a per-cpu worker that is
idle may have initially been unbound (e.g. worker creation in the
trustee_thread can cause this).

Silas

Signed-off-by: Silas Boyd-Wickizer <sbw@mit.edu>
---
 kernel/workqueue.c |  114 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 87 insertions(+), 27 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9a3128d..fb5e18d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -61,6 +61,7 @@ enum {
 	WORKER_REBIND		= 1 << 5,	/* mom is home, come back */
 	WORKER_CPU_INTENSIVE	= 1 << 6,	/* cpu intensive */
 	WORKER_UNBOUND		= 1 << 7,	/* worker is unbound */
+	WORKER_PARK		= 1 << 8,
 
 	WORKER_NOT_RUNNING	= WORKER_PREP | WORKER_ROGUE | WORKER_REBIND |
 				  WORKER_CPU_INTENSIVE | WORKER_UNBOUND,
@@ -1412,6 +1413,13 @@ fail:
 	return NULL;
 }
 
+static void __start_worker(struct worker *worker)
+{
+	worker->flags |= WORKER_STARTED;
+	worker->gcwq->nr_workers++;
+	worker_enter_idle(worker);
+}
+
 /**
  * start_worker - start a newly created worker
  * @worker: worker to start
@@ -1423,12 +1431,29 @@ fail:
  */
 static void start_worker(struct worker *worker)
 {
-	worker->flags |= WORKER_STARTED;
-	worker->gcwq->nr_workers++;
-	worker_enter_idle(worker);
+	__start_worker(worker);
 	wake_up_process(worker->task);
 }
 
+static void unpark_worker(struct worker *worker)
+{
+	worker->flags &= ~WORKER_PARK;
+	__start_worker(worker);
+	kthread_unpark(worker->task);
+}
+
+static void __disconnect_worker(struct worker *worker)
+{
+	struct global_cwq *gcwq = worker->gcwq;
+
+	if (worker->flags & WORKER_STARTED)
+		gcwq->nr_workers--;
+	if (worker->flags & WORKER_IDLE)
+		gcwq->nr_idle--;
+
+	list_del_init(&worker->entry);
+}
+
 /**
  * destroy_worker - destroy a workqueue worker
  * @worker: worker to be destroyed
@@ -1447,12 +1472,7 @@ static void destroy_worker(struct worker *worker)
 	BUG_ON(worker->current_work);
 	BUG_ON(!list_empty(&worker->scheduled));
 
-	if (worker->flags & WORKER_STARTED)
-		gcwq->nr_workers--;
-	if (worker->flags & WORKER_IDLE)
-		gcwq->nr_idle--;
-
-	list_del_init(&worker->entry);
+	__disconnect_worker(worker);
 	worker->flags |= WORKER_DIE;
 
 	spin_unlock_irq(&gcwq->lock);
@@ -1464,6 +1484,23 @@ static void destroy_worker(struct worker *worker)
 	ida_remove(&gcwq->worker_ida, id);
 }
 
+static void park_idle_worker(struct worker *worker)
+{
+	struct global_cwq *gcwq = worker->gcwq;
+
+	BUG_ON(worker->current_work);
+	BUG_ON(!list_empty(&worker->scheduled));
+	BUG_ON(gcwq->first_idle);
+
+	__disconnect_worker(worker);
+	worker->flags = WORKER_PARK | WORKER_PREP;
+
+	spin_unlock_irq(&gcwq->lock);
+	kthread_park(worker->task);
+	spin_lock_irq(&gcwq->lock);
+	gcwq->first_idle = worker;
+}
+
 static void idle_worker_timeout(unsigned long __gcwq)
 {
 	struct global_cwq *gcwq = (void *)__gcwq;
@@ -1953,6 +1990,12 @@ woke_up:
 		return 0;
 	}
 
+	if (worker->flags & WORKER_PARK) {
+		spin_unlock_irq(&gcwq->lock);
+		kthread_parkme();
+		WARN_ON(!worker_maybe_bind_and_lock(worker));
+	}
+
 	worker_leave_idle(worker);
 recheck:
 	/* no more worker necessary? */
@@ -3340,6 +3383,12 @@ static int __cpuinit trustee_thread(void *__gcwq)
 
 	gcwq->flags |= GCWQ_MANAGING_WORKERS;
 
+	if (!gcwq->first_idle && !list_empty(&gcwq->idle_list)) {
+		worker = list_first_entry(&gcwq->idle_list,
+					struct worker, entry);
+		park_idle_worker(worker);
+	}
+
 	list_for_each_entry(worker, &gcwq->idle_list, entry)
 		worker->flags |= WORKER_ROGUE;
 
@@ -3516,15 +3565,7 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 		if (IS_ERR(new_trustee))
 			return notifier_from_errno(PTR_ERR(new_trustee));
 		kthread_bind(new_trustee, cpu);
-		/* fall through */
-	case CPU_UP_PREPARE:
-		BUG_ON(gcwq->first_idle);
-		new_worker = create_worker(gcwq, false);
-		if (!new_worker) {
-			if (new_trustee)
-				kthread_stop(new_trustee);
-			return NOTIFY_BAD;
-		}
+		break;
 	}
 
 	/* some are called w/ irq disabled, don't disturb irq status */
@@ -3540,8 +3581,18 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 		wait_trustee_state(gcwq, TRUSTEE_IN_CHARGE);
 		/* fall through */
 	case CPU_UP_PREPARE:
-		BUG_ON(gcwq->first_idle);
-		gcwq->first_idle = new_worker;
+		if (!gcwq->first_idle) {
+			spin_unlock_irq(&gcwq->lock);
+			new_worker = create_worker(gcwq, false);
+			if (!new_worker) {
+				if (new_trustee)
+					kthread_stop(new_trustee);
+				return NOTIFY_BAD;
+			}
+			spin_lock_irq(&gcwq->lock);
+			BUG_ON(gcwq->first_idle);
+			gcwq->first_idle = new_worker;
+		}
 		break;
 
 	case CPU_DYING:
@@ -3556,10 +3607,14 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 
 	case CPU_POST_DEAD:
 		gcwq->trustee_state = TRUSTEE_BUTCHER;
-		/* fall through */
+		break;
+
 	case CPU_UP_CANCELED:
-		destroy_worker(gcwq->first_idle);
-		gcwq->first_idle = NULL;
+		/* If worker is parked, leave it parked for later */
+		if (!(gcwq->first_idle->flags & WORKER_PARK)) {
+			destroy_worker(gcwq->first_idle);
+			gcwq->first_idle = NULL;
+		}
 		break;
 
 	case CPU_DOWN_FAILED:
@@ -3570,17 +3625,22 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 			wake_up_process(gcwq->trustee);
 			wait_trustee_state(gcwq, TRUSTEE_DONE);
 		}
+		BUG_ON(!gcwq->first_idle);
 
 		/*
 		 * Trustee is done and there might be no worker left.
 		 * Put the first_idle in and request a real manager to
 		 * take a look.
 		 */
-		spin_unlock_irq(&gcwq->lock);
-		kthread_bind(gcwq->first_idle->task, cpu);
-		spin_lock_irq(&gcwq->lock);
 		gcwq->flags |= GCWQ_MANAGE_WORKERS;
-		start_worker(gcwq->first_idle);
+		if (!(gcwq->first_idle->flags & WORKER_PARK)) {
+			spin_unlock_irq(&gcwq->lock);
+			kthread_bind(gcwq->first_idle->task, cpu);
+			spin_lock_irq(&gcwq->lock);
+			start_worker(gcwq->first_idle);
+		} else {
+			unpark_worker(gcwq->first_idle);
+		}
 		gcwq->first_idle = NULL;
 		break;
 	}
