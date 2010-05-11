Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab0EKPng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:43:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:37729 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981Ab0EKPnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:43:32 -0400
Date: Tue, 11 May 2010 15:43:01 GMT
From: tip-bot for Tony Breeds <tony@bakeyournoodle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, benh@kernel.crashing.org, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu, tony@bakeyournoodle.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, benh@kernel.crashing.org, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu, tony@bakeyournoodle.com
In-Reply-To: <20100507042010.GR12389@ozlabs.org>
References: <20100507042010.GR12389@ozlabs.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] mutex: Fix optimistic spinning vs. BKL
Message-ID: <tip-227945799cc10d77c6ef812f3eb8a61a78689454@git.kernel.org>
Git-Commit-ID: 227945799cc10d77c6ef812f3eb8a61a78689454
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 11 May 2010 15:43:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  227945799cc10d77c6ef812f3eb8a61a78689454
Gitweb:     http://git.kernel.org/tip/227945799cc10d77c6ef812f3eb8a61a78689454
Author:     Tony Breeds <tony@bakeyournoodle.com>
AuthorDate: Fri, 7 May 2010 14:20:10 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 11 May 2010 17:07:24 +0200

mutex: Fix optimistic spinning vs. BKL

Currently, we can hit a nasty case with optimistic spinning on
mutexes:

    CPU A tries to take a mutex, while holding the BKL

    CPU B tried to take the BLK while holding the mutex

This looks like a AB-BA scenario but in practice, is allowed and
happens due to the auto-release-on-schedule nature of the BKL.

In that case, the optimistic spinning code can get us into a situation
where instead of going to sleep, A will spin waiting for B who is
spinning waiting for A, and the only way out of that loop is the
need_resched() test in mutex_spin_on_owner().

Now, that's bad enough since we may end up having those two processors
deadlocked for a while, thus introducing latencies, but I've had cases
where it completely stopped making forward progress. I suspect CPU A
had nothing else waiting to run, and see need_resched() was never set.

This patch fixes both in a rather crude way. I completely disable
spinning if we own the BKL, and I add a safety timeout using jiffies
to fallback to sleeping if we end up spinning for more than 1 or 2
jiffies.

Now, we -could- make it a bit smarter about the BKL by introducing a
contention counter and only go out if we own the BKL and it is
contended, but I didn't feel like this was worth the effort, time is
better spent removing the BKL from sensitive code path instead.

Regarding the choice of 1 or 2 jiffies, it's completely arbitrary. I
prefer that to an arbitrary number of milliseconds mostly because it's
expected that a 1000HZ kernel is run on a workload that expects
smaller latencies, and as such reflects better the idea that if we're
going to spin for more than a scheduler tick, we may as well schedule
(and save power by doing so if we hit the idle thread).

This timeout is also a safeguard in case we find another weird
deadlock scenario with optimistic spinning (that's the second one I
found so far, the other one was with CPU hotplug). At least we have
some kind of forward progress guarantee now.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org>
LKML-Reference: <20100507042010.GR12389@ozlabs.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    3 ++-
 kernel/mutex.c        |   12 ++++++++++--
 kernel/sched.c        |    5 +++--
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index dad7f66..bc6bd9a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -361,7 +361,8 @@ extern signed long schedule_timeout_interruptible(signed long timeout);
 extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
 asmlinkage void schedule(void);
-extern int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner);
+extern int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner,
+			       unsigned long timeout);
 
 struct nsproxy;
 struct user_namespace;
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 632f04c..7d4626b 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -145,6 +145,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
 	unsigned long flags;
+	unsigned long timeout;
 
 	preempt_disable();
 	mutex_acquire(&lock->dep_map, subclass, 0, ip);
@@ -168,15 +169,22 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	 * to serialize everything.
 	 */
 
-	for (;;) {
+	for (timeout = jiffies + 2; time_before(jiffies, timeout);) {
 		struct thread_info *owner;
 
 		/*
+		 * If we own the BKL, then don't spin. The owner of the mutex
+		 * might be waiting on us to release the BKL.
+		 */
+		if (current->lock_depth >= 0)
+			break;
+
+		/*
 		 * If there's an owner, wait for it to either
 		 * release the lock or go to sleep.
 		 */
 		owner = ACCESS_ONCE(lock->owner);
-		if (owner && !mutex_spin_on_owner(lock, owner))
+		if (owner && !mutex_spin_on_owner(lock, owner, timeout))
 			break;
 
 		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
diff --git a/kernel/sched.c b/kernel/sched.c
index 3c2a54f..e613160 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3775,7 +3775,8 @@ EXPORT_SYMBOL(schedule);
  * Look out! "owner" is an entirely speculative pointer
  * access and not reliable.
  */
-int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
+int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner,
+			unsigned long timeout)
 {
 	unsigned int cpu;
 	struct rq *rq;
@@ -3811,7 +3812,7 @@ int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
 
 	rq = cpu_rq(cpu);
 
-	for (;;) {
+	while (time_before(jiffies, timeout)) {
 		/*
 		 * Owner changed, break to re-assess state.
 		 */
