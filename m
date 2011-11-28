Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab1K1Xd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:33:59 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36977 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719Ab1K1Xd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:33:57 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 12/13] rcu: Document same-context read-side constraints
Date: Mon, 28 Nov 2011 15:33:04 -0800
Message-Id: <1322523185-456-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111128233212.GA32279@linux.vnet.ibm.com>
References: <20111128233212.GA32279@linux.vnet.ibm.com>
x-cbid: 11112823-8974-0000-0000-00000380646A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intent is that a given RCU read-side critical section be confined
to a single context.  For example, it is illegal to invoke rcu_read_lock()
in an exception handler and then invoke rcu_read_unlock() from the
context of the task that received the exception.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   15 +++++++++++++++
 include/linux/srcu.h     |    5 +++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 5dd6fd8..81c04f4 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -265,6 +265,11 @@ extern int debug_lockdep_rcu_enabled(void);
  *
  * Checks debug_lockdep_rcu_enabled() to prevent false positives during boot
  * and while lockdep is disabled.
+ *
+ * Note that rcu_read_lock() and the matching rcu_read_unlock() must
+ * occur in the same context, for example, it is illegal to invoke
+ * rcu_read_unlock() in process context if the matching rcu_read_lock()
+ * was invoked from within an irq handler.
  */
 static inline int rcu_read_lock_held(void)
 {
@@ -689,6 +694,11 @@ static inline void rcu_read_unlock(void)
  * critical sections in interrupt context can use just rcu_read_lock(),
  * though this should at least be commented to avoid confusing people
  * reading the code.
+ *
+ * Note that rcu_read_lock_bh() and the matching rcu_read_unlock_bh()
+ * must occur in the same context, for example, it is illegal to invoke
+ * rcu_read_unlock_bh() from one task if the matching rcu_read_lock_bh()
+ * was invoked from some other task.
  */
 static inline void rcu_read_lock_bh(void)
 {
@@ -716,6 +726,11 @@ static inline void rcu_read_unlock_bh(void)
  * are being done using call_rcu_sched() or synchronize_rcu_sched().
  * Read-side critical sections can also be introduced by anything that
  * disables preemption, including local_irq_disable() and friends.
+ *
+ * Note that rcu_read_lock_sched() and the matching rcu_read_unlock_sched()
+ * must occur in the same context, for example, it is illegal to invoke
+ * rcu_read_unlock_sched() from process context if the matching
+ * rcu_read_lock_sched() was invoked from an NMI handler.
  */
 static inline void rcu_read_lock_sched(void)
 {
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index d5334d0..83a4f06 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -158,6 +158,11 @@ static inline int srcu_read_lock_held(struct srcu_struct *sp)
  * one way to indirectly wait on an SRCU grace period is to acquire
  * a mutex that is held elsewhere while calling synchronize_srcu() or
  * synchronize_srcu_expedited().
+ *
+ * Note that srcu_read_lock() and the matching srcu_read_unlock() must
+ * occur in the same context, for example, it is illegal to invoke
+ * srcu_read_unlock() in an irq handler if the matching srcu_read_lock()
+ * was invoked in process context.
  */
 static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 {
-- 
1.7.3.2

