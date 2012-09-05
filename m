Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab2IEGQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 02:16:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49109 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab2IEGQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 02:16:37 -0400
Date: Tue, 4 Sep 2012 23:16:32 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] workqueue: fix possible deadlock in idle worker
 rebinding
Message-ID: <20120905061632.GB3195@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120905061233.GA3195@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120905061233.GA3195@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, rebind_workers() and idle_worker_rebind() are two-way
interlocked.  rebind_workers() waits for idle workers to finish
rebinding and rebound idle workers wait for rebind_workers() to finish
rebinding busy workers before proceeding.

Unfortunately, this isn't enough.  The second wait from idle workers
is implemented as follows.

	wait_event(gcwq->rebind_hold, !(worker->flags & WORKER_REBIND));

rebind_workers() clears WORKER_REBIND, wakes up the idle workers and
then returns.  If CPU hotplug cycle happens again before one of the
idle workers finishes the above wait_event(), rebind_workers() will
repeat the first part of the handshake - set WORKER_REBIND again and
wait for the idle worker to finish rebinding - and this leads to
deadlock because the idle worker would be waiting for WORKER_REBIND to
clear.

This is fixed by adding another interlocking step at the end -
rebind_workers() now waits for all the idle workers to finish the
above WORKER_REBIND wait before returning.  This ensures that all
rebinding steps are complete on all idle workers before the next
hotplug cycle can happen.

This problem was diagnosed by Lai Jiangshan who also posted a patch to
fix the issue, upon which this patch is based.

Note that this enables further simplification - we now can use
completion for the second handshake and WORKER_REBIND can be cleared
from idle workers themselves.  Further patches will follow.

Signed-off-by: Tejun Heo <tj@kernel.org>
Original-patch-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <1346516916-1991-3-git-send-email-laijs@cn.fujitsu.com>
---
Lai, you deserve full credit for this and, if you're okay with it, I'd
like to mark you as the author with footnote explaining the
reimplementation.  Would that be okay?  Or do you prefer the above
Original-patch-by?

Thanks.

 kernel/workqueue.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
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
@@ -1448,12 +1457,28 @@ retry:
 	 * be cleared inside idle_worker_rebind().  Clear and release.
 	 * Clearing %WORKER_REBIND from this foreign context is safe
 	 * because these workers are still guaranteed to be idle.
+	 *
+	 * We need to make sure all idle workers passed WORKER_REBIND wait
+	 * in idle_worker_rebind() before returning; otherwise, workers can
+	 * get stuck at the wait if hotplug cycle repeats.
 	 */
-	for_each_worker_pool(pool, gcwq)
-		list_for_each_entry(worker, &pool->idle_list, entry)
+	idle_rebind.cnt = 1;
+	INIT_COMPLETION(idle_rebind.done);
+
+	for_each_worker_pool(pool, gcwq) {
+		list_for_each_entry(worker, &pool->idle_list, entry) {
 			worker->flags &= ~WORKER_REBIND;
+			idle_rebind.cnt++;
+		}
+	}
 
 	wake_up_all(&gcwq->rebind_hold);
+
+	if (--idle_rebind.cnt) {
+		spin_unlock_irq(&gcwq->lock);
+		wait_for_completion(&idle_rebind.done);
+		spin_lock_irq(&gcwq->lock);
+	}
 }
 
 static struct worker *alloc_worker(void)
