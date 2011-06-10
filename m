Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab1FJNNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:13:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:37073 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757228Ab1FJNI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:08:58 -0400
Date: Fri, 10 Jun 2011 15:08:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] sched; Simplify mutex_spin_on_owner()
Message-ID: <alpine.LFD.2.02.1106101458350.11814@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It does not make sense to rcu_read_lock/unlock() in every loop
iteration while spinning on the mutex.

Move the rcu protection once outside the loop. Also simplify the
return path to always check for lock->owner == NULL which meets the
requirements of both owner changed and need_resched() caused loop
exits.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched.c |   25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4306,11 +4306,8 @@ EXPORT_SYMBOL(schedule);
 
 static inline bool owner_running(struct mutex *lock, struct task_struct *owner)
 {
-	bool ret = false;
-
-	rcu_read_lock();
 	if (lock->owner != owner)
-		goto fail;
+		return false;
 
 	/*
 	 * Ensure we emit the owner->on_cpu, dereference _after_ checking
@@ -4320,11 +4317,7 @@ static inline bool owner_running(struct 
 	 */
 	barrier();
 
-	ret = owner->on_cpu;
-fail:
-	rcu_read_unlock();
-
-	return ret;
+	return owner->on_cpu;
 }
 
 /*
@@ -4336,21 +4329,21 @@ int mutex_spin_on_owner(struct mutex *lo
 	if (!sched_feat(OWNER_SPIN))
 		return 0;
 
+	rcu_read_lock();
 	while (owner_running(lock, owner)) {
 		if (need_resched())
-			return 0;
+			break;
 
 		arch_mutex_cpu_relax();
 	}
+	rcu_read_unlock();
 
 	/*
-	 * If the owner changed to another task there is likely
-	 * heavy contention, stop spinning.
+	 * We break out the loop above on need_resched() and when the
+	 * owner changed, which is a sign for heavy contention. Return
+	 * success only when lock->owner is NULL.
 	 */
-	if (lock->owner)
-		return 0;
-
-	return 1;
+	return lock->owner == NULL;
 }
 #endif
 
