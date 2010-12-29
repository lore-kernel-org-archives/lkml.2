Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab0L2M5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 07:57:17 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40441 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab0L2M5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 07:57:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=o/uNOpBh+d24a2cUSM1VqXmnw+SLQE2hByxBouxi0CqjpeogjD9I8NWl68MGXdu1Jb
         9Cid5rAV+2QLUNRMKtsm5n4oAHod+ZPEVQ8Pq5wO2u68yv5sBwRZeCmDgemfbaTC2o/2
         DVHKOfnF/wWchPDBbzld/uV2PeJcng89b+WSI=
Date: Wed, 29 Dec 2010 13:57:11 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] workqueue: relax lockdep annotation on flush_work()
Message-ID: <20101229125711.GL488@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
and read access if higher.

This better represents what's going on and removes spurious lockdep
warnings which are triggered by fake dependency chain created through
flush_work().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: "Rafael J. Wysocki" <rjw@sisk.pl>
---
How should this one be routed?  The lockdep part can be split, merged
back into workqueue tree and so on but that seems a bit too much.  If
it's okay, I'll route this through the workqueue tree.  Going through
the lockdep tree is fine too.

Thanks.

 include/linux/lockdep.h |    3 +++
 kernel/workqueue.c      |    8 ++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

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
index 8ee6ec8..85f8f7b 100644
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
@@ -2384,8 +2384,12 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
 	insert_wq_barrier(cwq, barr, work, worker);
 	spin_unlock_irq(&gcwq->lock);
 
-	lock_map_acquire(&cwq->wq->lockdep_map);
+	if (cwq->wq->saved_max_active > 1)
+		lock_map_acquire_read(&cwq->wq->lockdep_map);
+	else
+		lock_map_acquire(&cwq->wq->lockdep_map);
 	lock_map_release(&cwq->wq->lockdep_map);
+
 	return true;
 already_gone:
 	spin_unlock_irq(&gcwq->lock);
