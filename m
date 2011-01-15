Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab1AOPPc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 10:15:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47549 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab1AOPPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 10:15:31 -0500
Date: Sat, 15 Jan 2011 16:15:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core kernel fixes
Message-ID: <20110115151515.GA11124@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Paul E. McKenney (2):
      rcu: demote SRCU_SYNCHRONIZE_DELAY from kernel-parameter status
      rcu: avoid pointless blocked-task warnings

Steven Rostedt (1):
      rtmutex: Fix comment about why new_owner can be NULL in wake_futex_pi()


 init/Kconfig     |   15 ---------------
 kernel/futex.c   |    7 +++----
 kernel/rcutiny.c |    3 ++-
 kernel/srcu.c    |   15 +++++++++++++--
 4 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 8dfd094..bd1ea92 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -497,21 +497,6 @@ config RCU_BOOST_DELAY
 
 	  Accept the default if unsure.
 
-config SRCU_SYNCHRONIZE_DELAY
-	int "Microseconds to delay before waiting for readers"
-	range 0 20
-	default 10
-	help
-	  This option controls how long SRCU delays before entering its
-	  loop waiting on SRCU readers.  The purpose of this loop is
-	  to avoid the unconditional context-switch penalty that would
-	  otherwise be incurred if there was an active SRCU reader,
-	  in a manner similar to adaptive locking schemes.  This should
-	  be set to be a bit longer than the common-case SRCU read-side
-	  critical-section overhead.
-
-	  Accept the default if unsure.
-
 endmenu # "RCU Subsystem"
 
 config IKCONFIG
diff --git a/kernel/futex.c b/kernel/futex.c
index 3019b92..5696d38 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -791,10 +791,9 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
 
 	/*
-	 * This happens when we have stolen the lock and the original
-	 * pending owner did not enqueue itself back on the rt_mutex.
-	 * Thats not a tragedy. We know that way, that a lock waiter
-	 * is on the fly. We make the futex_q waiter the pending owner.
+	 * It is possible that the next waiter (the one that brought
+	 * this owner to the kernel) timed out and is no longer
+	 * waiting on the lock.
 	 */
 	if (!new_owner)
 		new_owner = this->task;
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 0344937..0c343b9 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -189,7 +189,8 @@ static int rcu_kthread(void *arg)
 	unsigned long flags;
 
 	for (;;) {
-		wait_event(rcu_kthread_wq, have_rcu_kthread_work != 0);
+		wait_event_interruptible(rcu_kthread_wq,
+					 have_rcu_kthread_work != 0);
 		morework = rcu_boost();
 		local_irq_save(flags);
 		work = have_rcu_kthread_work;
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 98d8c1e..73ce23f 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -156,6 +156,16 @@ void __srcu_read_unlock(struct srcu_struct *sp, int idx)
 EXPORT_SYMBOL_GPL(__srcu_read_unlock);
 
 /*
+ * We use an adaptive strategy for synchronize_srcu() and especially for
+ * synchronize_srcu_expedited().  We spin for a fixed time period
+ * (defined below) to allow SRCU readers to exit their read-side critical
+ * sections.  If there are still some readers after 10 microseconds,
+ * we repeatedly block for 1-millisecond time periods.  This approach
+ * has done well in testing, so there is no need for a config parameter.
+ */
+#define SYNCHRONIZE_SRCU_READER_DELAY 10
+
+/*
  * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
  */
 static void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
@@ -207,11 +217,12 @@ static void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
 	 * will have finished executing.  We initially give readers
 	 * an arbitrarily chosen 10 microseconds to get out of their
 	 * SRCU read-side critical sections, then loop waiting 1/HZ
-	 * seconds per iteration.
+	 * seconds per iteration.  The 10-microsecond value has done
+	 * very well in testing.
 	 */
 
 	if (srcu_readers_active_idx(sp, idx))
-		udelay(CONFIG_SRCU_SYNCHRONIZE_DELAY);
+		udelay(SYNCHRONIZE_SRCU_READER_DELAY);
 	while (srcu_readers_active_idx(sp, idx))
 		schedule_timeout_interruptible(1);
 
