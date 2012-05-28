Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab2E1DdX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:33:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52165 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754008Ab2E1D3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:49 -0400
Message-Id: <20120528031211.022861536@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:01 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [ 059/117] workqueue: skip nr_running sanity check in worker_enter_idle() if
 trustee is active
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 544ecf310f0e7f51fa057ac2a295fc1b3b35a9d3 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/workqueue.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

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
 


