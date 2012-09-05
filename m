Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab2IEAyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 20:54:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40828 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab2IEAyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 20:54:14 -0400
Date: Tue, 4 Sep 2012 17:54:09 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10 V4] workqueue: fix deadlock in rebind_workers()
Message-ID: <20120905005409.GB2836@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346516916-1991-1-git-send-email-laijs@cn.fujitsu.com>
 <1346516916-1991-3-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346516916-1991-3-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about something like the following?  This is more consistent with
the existing code and as the fixes need to go separately through
for-3.6-fixes, it's best to stay consistent regardless of the end
result after all the restructuring.  It's not tested yet.  If you
don't object, I'll split it into two patches, test and route them
through for-3.6-fixes w/ your Original-patch-by.

Thanks.
---
 kernel/workqueue.c |   51 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 13 deletions(-)

Index: work/kernel/workqueue.c
===================================================================
--- work.orig/kernel/workqueue.c
+++ work/kernel/workqueue.c
@@ -1326,6 +1326,15 @@ static void idle_worker_rebind(struct wo
 
 	/* we did our part, wait for rebind_workers() to finish up */
 	wait_event(gcwq->rebind_hold, !(worker->flags & WORKER_REBIND));
+
+	/*
+	 * rebind_workers() shouldn't finish until all workers passed the
+	 * above WORKER_REBIND wait.  Tell it when done.
+	 */
+	spin_lock_irq(&worker->pool->gcwq->lock);
+	if (!--worker->idle_rebind->cnt)
+		complete(&worker->idle_rebind->done);
+	spin_unlock_irq(&worker->pool->gcwq->lock);
 }
 
 /*
@@ -1422,19 +1431,7 @@ retry:
 		goto retry;
 	}
 
-	/*
-	 * All idle workers are rebound and waiting for %WORKER_REBIND to
-	 * be cleared inside idle_worker_rebind().  Clear and release.
-	 * Clearing %WORKER_REBIND from this foreign context is safe
-	 * because these workers are still guaranteed to be idle.
-	 */
-	for_each_worker_pool(pool, gcwq)
-		list_for_each_entry(worker, &pool->idle_list, entry)
-			worker->flags &= ~WORKER_REBIND;
-
-	wake_up_all(&gcwq->rebind_hold);
-
-	/* rebind busy workers */
+	/* all idle workers are rebound, rebind busy workers */
 	for_each_busy_worker(worker, i, pos, gcwq) {
 		struct work_struct *rebind_work = &worker->rebind_work;
 		unsigned long worker_flags = worker->flags;
@@ -1454,6 +1451,34 @@ retry:
 			    worker->scheduled.next,
 			    work_color_to_flags(WORK_NO_COLOR));
 	}
+
+	/*
+	 * All idle workers are rebound and waiting for %WORKER_REBIND to
+	 * be cleared inside idle_worker_rebind().  Clear and release.
+	 * Clearing %WORKER_REBIND from this foreign context is safe
+	 * because these workers are still guaranteed to be idle.
+	 *
+	 * We need to make sure all idle workers passed WORKER_REBIND wait
+	 * in idle_worker_rebind() before returning; otherwise, workers can
+	 * get stuck at the wait if hotplug cycle repeats.
+	 */
+	idle_rebind.cnt = 1;
+	INIT_COMPLETION(idle_rebind.done);
+
+	for_each_worker_pool(pool, gcwq) {
+		list_for_each_entry(worker, &pool->idle_list, entry) {
+			worker->flags &= ~WORKER_REBIND;
+			idle_rebind.cnt++;
+		}
+	}
+
+	wake_up_all(&gcwq->rebind_hold);
+
+	if (--idle_rebind.cnt) {
+		spin_unlock_irq(&gcwq->lock);
+		wait_for_completion(&idle_rebind.done);
+		spin_lock_irq(&gcwq->lock);
+	}
 }
 
 static struct worker *alloc_worker(void)
