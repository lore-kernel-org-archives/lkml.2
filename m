Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab2ENWM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 18:12:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64506 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757900Ab2ENWMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 18:12:55 -0400
Date: Mon, 14 May 2012 15:12:50 -0700
From: Tejun Heo <tj@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] workqueue: skip nr_running sanity check in
 worker_enter_idle() if trustee is active
Message-ID: <20120514221250.GA8414@google.com>
References: <20120506153814.GA25681@linux.vnet.ibm.com>
 <20120507194042.GG19417@google.com>
 <20120507205516.GD21152@linux.vnet.ibm.com>
 <20120507213449.GM19417@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120507213449.GM19417@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 544ecf310f0e7f51fa057ac2a295fc1b3b35a9d3 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Mon, 14 May 2012 15:04:50 -0700

worker_enter_idle() has WARN_ON_ONCE() which triggers if nr_running
isn't zero when every worker is idle.  This can trigger spuriously
while a cpu is going down due to the way trustee sets %WORKER_ROGUE
and zaps nr_running.

It first sets %WORKER_ROGUE on all workers without updating
nr_running, releases gcwq->lock, schedules, regrabs gcwq->lock and
then zaps nr_running.  If the last running worker enters idle
inbetween, it would see stale nr_running which hasn't been zapped yet
and trigger the WARN_ON_ONCE().

Fix it by performing the sanity check iff the trustee is idle.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
---
Sorry about the delay.  After scratching my head quite a bit, I found
where during cpu-offlining such discrepancy may happen.  I'm fairly
sure this is it but I might be wrong, so please include this patch in
your test setup and let me know how it goes.

Thank you.

 kernel/workqueue.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 211eadb..c36c86c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1213,8 +1213,13 @@ static void worker_enter_idle(struct worker *worker)
 	} else
 		wake_up_all(&gcwq->trustee_wait);
 
-	/* sanity check nr_running */
-	WARN_ON_ONCE(gcwq->nr_workers == gcwq->nr_idle &&
+	/*
+	 * Sanity check nr_running.  Because trustee releases gcwq->lock
+	 * between setting %WORKER_ROGUE and zapping nr_running, the
+	 * warning may trigger spuriously.  Check iff trustee is idle.
+	 */
+	WARN_ON_ONCE(gcwq->trustee_state == TRUSTEE_DONE &&
+		     gcwq->nr_workers == gcwq->nr_idle &&
 		     atomic_read(get_gcwq_nr_running(gcwq->cpu)));
 }
 
-- 
1.7.7.3

