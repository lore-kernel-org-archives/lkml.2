Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab1ACORl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 09:17:41 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51687 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab1ACORk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 09:17:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Nv4Vh7IrbQFU3hdG65/51Dwzm6iD0I8SLUzDoHpUmuahR+T7cvuuG4rqfh/AYf0SjD
         0Ih2J0+P2Gd3h4umRRuWgKNKfYvTqBIv/9CcmQfVHUF23Kxpyg9Vg3dHVw9zOmhLFyRC
         hzuJg5M2gCOHaFZL6Gu73NhouDTxxbHjgMglA=
Date: Mon, 3 Jan 2011 15:17:35 +0100
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org
Subject: [PATCH UPDATED] workqueue: relax lockdep annotation on flush_work()
Message-ID: <20110103141735.GQ18831@htj.dyndns.org>
References: <20101229125711.GL488@htj.dyndns.org>
 <1294047091.2016.38.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294047091.2016.38.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Peter Zijlstra <peterz@infradead.org>
---
Ah... good point.  How does this one look then?

Thanks.

 include/linux/lockdep.h |    3 +++
 kernel/workqueue.c      |   14 ++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 71c09b2..9f19430 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -522,12 +522,15 @@ static inline void print_irqtrace_events(struct task_struct *curr)
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
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 8ee6ec8..930c239 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1840,7 +1840,7 @@ __acquires(&gcwq->lock)
 	spin_unlock_irq(&gcwq->lock);
 
 	work_clear_pending(work);
-	lock_map_acquire(&cwq->wq->lockdep_map);
+	lock_map_acquire_read(&cwq->wq->lockdep_map);
 	lock_map_acquire(&lockdep_map);
 	trace_workqueue_execute_start(work);
 	f(work);
@@ -2384,8 +2384,18 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
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
