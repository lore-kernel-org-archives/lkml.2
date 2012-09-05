Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab2IEGMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 02:12:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab2IEGMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 02:12:38 -0400
Date: Tue, 4 Sep 2012 23:12:33 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] workqueue: move WORKER_REBIND clearing in
 rebind_workers() to the end of the function
Message-ID: <20120905061233.GA3195@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This doesn't make any functional difference and is purely to help the
next patch to be simpler.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
Here are the split patches.  Will push these through wq/for-3.6-fixes.

Thanks.

 kernel/workqueue.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1422,19 +1422,7 @@ retry:
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
@@ -1454,6 +1442,18 @@ retry:
 			    worker->scheduled.next,
 			    work_color_to_flags(WORK_NO_COLOR));
 	}
+
+	/*
+	 * All idle workers are rebound and waiting for %WORKER_REBIND to
+	 * be cleared inside idle_worker_rebind().  Clear and release.
+	 * Clearing %WORKER_REBIND from this foreign context is safe
+	 * because these workers are still guaranteed to be idle.
+	 */
+	for_each_worker_pool(pool, gcwq)
+		list_for_each_entry(worker, &pool->idle_list, entry)
+			worker->flags &= ~WORKER_REBIND;
+
+	wake_up_all(&gcwq->rebind_hold);
 }
 
 static struct worker *alloc_worker(void)
