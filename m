Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759763Ab2IFUIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:08:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55565 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080Ab2IFUIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:08:07 -0400
Date: Thu, 6 Sep 2012 13:08:02 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH wq/for-3.6-fixes 3/3] workqueue: fix possible idle worker
 depletion during CPU_ONLINE
Message-ID: <20120906200802.GI29092@google.com>
References: <20120906200647.GG29092@google.com>
 <20120906200723.GH29092@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120906200723.GH29092@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 985aafbf530834a9ab16348300adc7cbf35aab76 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 6 Sep 2012 12:50:41 -0700

To simplify both normal and CPU hotplug paths, while CPU hotplug is in
progress, manager_mutex is held to prevent one of the workers from
becoming a manager and creating or destroying workers; unfortunately,
it currently may lead to idle worker depletion which in turn can lead
to deadlock under extreme circumstances.

Idle workers aren't allowed to become busy if there's no other idle
worker left to create more idle workers, but during CPU_ONLINE
gcwq_associate() is holding all managerships and all the idle workers
can proceed to become busy before gcwq_associate() is finished.

This patch fixes the bug by releasing manager_mutexes before letting
the rebound idle workers go.  This ensures that by the time idle
workers check whether management is necessary, CPU_ONLINE already has
released the positions.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index b19170b..74487ef 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1454,10 +1454,19 @@ retry:
 	}
 
 	/*
-	 * All idle workers are rebound and waiting for %WORKER_REBIND to
-	 * be cleared inside idle_worker_rebind().  Clear and release.
-	 * Clearing %WORKER_REBIND from this foreign context is safe
-	 * because these workers are still guaranteed to be idle.
+	 * At this point, each pool is guaranteed to have at least one idle
+	 * worker and all idle workers are waiting for WORKER_REBIND to
+	 * clear.  Release management before releasing idle workers;
+	 * otherwise, they can all go become busy as we're holding the
+	 * manager_mutexes, which can lead to deadlock as we don't actually
+	 * create new workers.
+	 */
+	gcwq_release_management(gcwq);
+
+	/*
+	 * Clear %WORKER_REBIND and release.  Clearing it from this foreign
+	 * context is safe because these workers are still guaranteed to be
+	 * idle.
 	 *
 	 * We need to make sure all idle workers passed WORKER_REBIND wait
 	 * in idle_worker_rebind() before returning; otherwise, workers can
@@ -1467,6 +1476,7 @@ retry:
 	INIT_COMPLETION(idle_rebind.done);
 
 	for_each_worker_pool(pool, gcwq) {
+		WARN_ON_ONCE(list_empty(&pool->idle_list));
 		list_for_each_entry(worker, &pool->idle_list, entry) {
 			worker->flags &= ~WORKER_REBIND;
 			idle_rebind.cnt++;
@@ -1481,8 +1491,6 @@ retry:
 	} else {
 		spin_unlock_irq(&gcwq->lock);
 	}
-
-	gcwq_release_management(gcwq);
 }
 
 static struct worker *alloc_worker(void)
-- 
1.7.7.3

