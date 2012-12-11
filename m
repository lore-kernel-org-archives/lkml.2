Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab2LKORr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 09:17:47 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43834 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab2LKORq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 09:17:46 -0500
Date: Tue, 11 Dec 2012 06:17:40 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] workqueue changes for v3.8
Message-ID: <20121211141740.GC7084@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive workqueue changes for
v3.8.  Nothing exciting.  Just two trivial changes.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.8

Thanks.

----------------------------------------------------------------
Joonsoo Kim (2):
      workqueue: trivial fix for return statement in work_busy()
      workqueue: add WARN_ON_ONCE() on CPU number to wq_worker_waking_up()

 kernel/workqueue.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 084aa47..ae9a056 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -739,8 +739,10 @@ void wq_worker_waking_up(struct task_struct *task, unsigned int cpu)
 {
 	struct worker *worker = kthread_data(task);
 
-	if (!(worker->flags & WORKER_NOT_RUNNING))
+	if (!(worker->flags & WORKER_NOT_RUNNING)) {
+		WARN_ON_ONCE(worker->pool->gcwq->cpu != cpu);
 		atomic_inc(get_pool_nr_running(worker->pool));
+	}
 }
 
 /**
@@ -3485,7 +3487,7 @@ unsigned int work_busy(struct work_struct *work)
 	unsigned int ret = 0;
 
 	if (!gcwq)
-		return false;
+		return 0;
 
 	spin_lock_irqsave(&gcwq->lock, flags);
 
