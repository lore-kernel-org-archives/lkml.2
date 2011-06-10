Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab1FJUO2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 16:14:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:21809 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758006Ab1FJUO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 16:14:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,348,1304319600"; 
   d="scan'208";a="12148031"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: eric.dumazet@gmail.com, tglx@linutronix.de,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/3] posix-timers: remove idr_lock
Date: Fri, 10 Jun 2011 13:13:06 -0700
Message-Id: <1307736788-25457-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

idr_lock is only used to protect the global posix_timers idr,
but idr does its own locking (or RCUing) anyways and doesn't
need it. So remove it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/posix-timers.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 4556182..a6dcc10 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -71,7 +71,6 @@
  */
 static struct kmem_cache *posix_timers_cache;
 static struct idr posix_timers_id;
-static DEFINE_SPINLOCK(idr_lock);
 
 /*
  * we assume that the new SIGEV_THREAD_ID shares no bits with the other
@@ -502,12 +501,8 @@ static void k_itimer_rcu_free(struct rcu_head *head)
 #define IT_ID_NOT_SET	0
 static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
 {
-	if (it_id_set) {
-		unsigned long flags;
-		spin_lock_irqsave(&idr_lock, flags);
+	if (it_id_set)
 		idr_remove(&posix_timers_id, tmr->it_id);
-		spin_unlock_irqrestore(&idr_lock, flags);
-	}
 	put_pid(tmr->it_pid);
 	sigqueue_free(tmr->sigq);
 	call_rcu(&tmr->it.rcu, k_itimer_rcu_free);
@@ -557,9 +552,7 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 		error = -EAGAIN;
 		goto out;
 	}
-	spin_lock_irq(&idr_lock);
 	error = idr_get_new(&posix_timers_id, new_timer, &new_timer_id);
-	spin_unlock_irq(&idr_lock);
 	if (error) {
 		if (error == -EAGAIN)
 			goto retry;
-- 
1.7.4.4

