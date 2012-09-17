Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589Ab2IQXAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 19:00:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42649 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab2IQXAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 19:00:17 -0400
Date: Mon, 17 Sep 2012 16:00:11 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [GIT PULL] workqueue fixes for v3.6-rc6
Message-ID: <20120917230011.GP18677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Unfortunately, yet another late fix.  This too is discovered and fixed
by Lai.  This bug was introduced during v3.6-rc1 by 25511a477
"workqueue: reimplement CPU online rebinding to handle idle workers"
which started using WORKER_REBIND flag for idle rebind too.

The bug is relatively easy to trigger if the CPU rapidly goes through
off, on and then off (and stay off).  The fix is on the safer side.
This hasn't been on linux-next yet but I'm pushing early so that it
can get more exposure before v3.6 release.

If too late, please ignore the pull request.  I'll route it through
-stable afterwards.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.6-fixes

Thanks.

Lai Jiangshan (1):
      workqueue: always clear WORKER_REBIND in busy_worker_rebind_fn()

 kernel/workqueue.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)
---
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1e1373b..b80065a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1349,8 +1349,16 @@ static void busy_worker_rebind_fn(struct work_struct *work)
 	struct worker *worker = container_of(work, struct worker, rebind_work);
 	struct global_cwq *gcwq = worker->pool->gcwq;
 
-	if (worker_maybe_bind_and_lock(worker))
-		worker_clr_flags(worker, WORKER_REBIND);
+	worker_maybe_bind_and_lock(worker);
+
+	/*
+	 * %WORKER_REBIND must be cleared even if the above binding failed;
+	 * otherwise, we may confuse the next CPU_UP cycle or oops / get
+	 * stuck by calling idle_worker_rebind() prematurely.  If CPU went
+	 * down again inbetween, %WORKER_UNBOUND would be set, so clearing
+	 * %WORKER_REBIND is always safe.
+	 */
+	worker_clr_flags(worker, WORKER_REBIND);
 
 	spin_unlock_irq(&gcwq->lock);
 }
