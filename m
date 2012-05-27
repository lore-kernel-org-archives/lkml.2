Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964913Ab2E0BJS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:09:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933381Ab2E0BJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:09:02 -0400
Message-Id: <20120527010429.385247653@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:05:03 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [ 40/94] workqueue: skip nr_running sanity check in worker_enter_idle() if trustee is active
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/workqueue.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1215,8 +1215,13 @@ static void worker_enter_idle(struct wor
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
 


