Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab1BPAkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:40:53 -0500
Received: from kroah.org ([198.145.64.141]:49459 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757673Ab1BPAXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:38 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:44 2011
Message-Id: <20110216001444.631722849@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: [195/272] workqueue: relax lockdep annotation on flush_work()
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit e159489baa717dbae70f9903770a6a4990865887 upstream.

Currently, the lockdep annotation in flush_work() requires exclusive
access on the workqueue the target work is queued on and triggers
warning if a work is trying to flush another work on the same
workqueue; however, this is no longer true as workqueues can now
execute multiple works concurrently.

This patch adds lock_map_acquire_read() and make process_one_work()
hold read access to the workqueue while executing a work and
start_flush_work() check for write access if concurrnecy level is one
or the workqueue has a rescuer (as only one execution resource - the
rescuer - is guaranteed to be available under memory pressure), and
read access if higher.

This better represents what's going on and removes spurious lockdep
warnings which are triggered by fake dependency chain created through
flush_work().

* Peter pointed out that flushing another work from a WQ_MEM_RECLAIM
  wq breaks forward progress guarantee under memory pressure.
  Condition check accordingly updated.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Tested-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/lockdep.h |    3 +++
 kernel/workqueue.c      |   14 ++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -522,12 +522,15 @@ static inline void print_irqtrace_events
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
 #  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 2, NULL, _THIS_IP_)
+#  define lock_map_acquire_read(l)	lock_acquire(l, 0, 0, 2, 2, NULL, _THIS_IP_)
 # else
 #  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 1, NULL, _THIS_IP_)
+#  define lock_map_acquire_read(l)	lock_acquire(l, 0, 0, 2, 1, NULL, _THIS_IP_)
 # endif
 # define lock_map_release(l)			lock_release(l, 1, _THIS_IP_)
 #else
 # define lock_map_acquire(l)			do { } while (0)
+# define lock_map_acquire_read(l)		do { } while (0)
 # define lock_map_release(l)			do { } while (0)
 #endif
 
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1806,7 +1806,7 @@ __acquires(&gcwq->lock)
 	spin_unlock_irq(&gcwq->lock);
 
 	work_clear_pending(work);
-	lock_map_acquire(&cwq->wq->lockdep_map);
+	lock_map_acquire_read(&cwq->wq->lockdep_map);
 	lock_map_acquire(&lockdep_map);
 	trace_workqueue_execute_start(work);
 	f(work);
@@ -2350,8 +2350,18 @@ static bool start_flush_work(struct work
 	insert_wq_barrier(cwq, barr, work, worker);
 	spin_unlock_irq(&gcwq->lock);
 
-	lock_map_acquire(&cwq->wq->lockdep_map);
+	/*
+	 * If @max_active is 1 or rescuer is in use, flushing another work
+	 * item on the same workqueue may lead to deadlock.  Make sure the
+	 * flusher is not running on the same workqueue by verifying write
+	 * access.
+	 */
+	if (cwq->wq->saved_max_active == 1 || cwq->wq->flags & WQ_RESCUER)
+		lock_map_acquire(&cwq->wq->lockdep_map);
+	else
+		lock_map_acquire_read(&cwq->wq->lockdep_map);
 	lock_map_release(&cwq->wq->lockdep_map);
+
 	return true;
 already_gone:
 	spin_unlock_irq(&gcwq->lock);


