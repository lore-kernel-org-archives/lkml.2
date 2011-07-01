Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab1GAPRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:17:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:33136 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab1GAPRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:17:08 -0400
Date: Fri, 1 Jul 2011 15:16:55 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-307bf9803f25a8a3f53c1012110fb74e2f893eb0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <alpine.LFD.2.02.1106101458350.11814@ionos>
References: <alpine.LFD.2.02.1106101458350.11814@ionos>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Simplify mutex_spin_on_owner()
Git-Commit-ID: 307bf9803f25a8a3f53c1012110fb74e2f893eb0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:16:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  307bf9803f25a8a3f53c1012110fb74e2f893eb0
Gitweb:     http://git.kernel.org/tip/307bf9803f25a8a3f53c1012110fb74e2f893eb0
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 10 Jun 2011 15:08:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 10:39:07 +0200

sched: Simplify mutex_spin_on_owner()

It does not make sense to rcu_read_lock/unlock() in every loop
iteration while spinning on the mutex.

Move the rcu protection outside the loop. Also simplify the
return path to always check for lock->owner == NULL which
meets the requirements of both owner changed and need_resched()
caused loop exits.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1106101458350.11814@ionos
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   25 +++++++++----------------
 1 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 5925275..e355ee7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
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
@@ -4320,11 +4317,7 @@ static inline bool owner_running(struct mutex *lock, struct task_struct *owner)
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
@@ -4336,21 +4329,21 @@ int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
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
 
