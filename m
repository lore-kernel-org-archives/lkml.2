Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950Ab2J3Qk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:40:56 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39877 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580Ab2J3Qkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:40:53 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 5/6] rcu: Clarify memory-ordering properties of grace-period primitives
Date: Tue, 30 Oct 2012 09:27:54 -0700
Message-Id: <1351614475-22895-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351614475-22895-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030162728.GA22648@linux.vnet.ibm.com>
 <1351614475-22895-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-3534-0000-0000-00000E5DED5E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit explicitly states the memory-ordering properties of the
RCU grace-period primitives.  Although these properties were in some
sense implied by the fundmental property of RCU ("a grace period must
wait for all pre-existing RCU read-side critical sections to complete"),
stating it explicitly will be a great labor-saving device.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   20 ++++++++++++++++++++
 kernel/rcutree.c         |   16 ++++++++++++++++
 kernel/rcutree_plugin.h  |    8 ++++++++
 3 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 7c968e4..91d530a 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -90,6 +90,20 @@ extern void do_trace_rcu_torture_read(char *rcutorturename,
  * that started after call_rcu() was invoked.  RCU read-side critical
  * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
  * and may be nested.
+ *
+ * Note that all CPUs must agree that the grace period extended beyond
+ * all pre-existing RCU read-side critical section.  This means that
+ * on systems with more than one CPU, when "func()" is invoked, each
+ * CPU is guaranteed to have executed a full memory barrier since the
+ * end of its last RCU read-side critical section whose beginning
+ * preceded the call to call_rcu().  Note that this guarantee includes
+ * CPUs that are offline, idle, or executing in user mode, as well as
+ * CPUs that are executing in the kernel.  Furthermore, if CPU A
+ * invoked call_rcu() and CPU B invoked the resulting RCU callback
+ * function "func()", then both CPU A and CPU B are guaranteed to execute
+ * a full memory barrier during the time interval between the call to
+ * call_rcu() and the invocation of "func()" -- even if CPU A and CPU B
+ * are the same CPU (but again only if the system has more than one CPU).
  */
 extern void call_rcu(struct rcu_head *head,
 			      void (*func)(struct rcu_head *head));
@@ -118,6 +132,9 @@ extern void call_rcu(struct rcu_head *head,
  *  OR
  *  - rcu_read_lock_bh() and rcu_read_unlock_bh(), if in process context.
  *  These may be nested.
+ *
+ * See the description of call_rcu() for more detailed information on
+ * memory ordering guarantees.
  */
 extern void call_rcu_bh(struct rcu_head *head,
 			void (*func)(struct rcu_head *head));
@@ -137,6 +154,9 @@ extern void call_rcu_bh(struct rcu_head *head,
  *  OR
  *  anything that disables preemption.
  *  These may be nested.
+ *
+ * See the description of call_rcu() for more detailed information on
+ * memory ordering guarantees.
  */
 extern void call_rcu_sched(struct rcu_head *head,
 			   void (*func)(struct rcu_head *rcu));
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e4c2192..ca32215 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2233,6 +2233,19 @@ static inline int rcu_blocking_is_gp(void)
  * softirq handlers will have completed, since in some kernels, these
  * handlers can run in process context, and can block.
  *
+ * Note that this guarantee implies a further memory-ordering guarantee.
+ * On systems with more than one CPU, when synchronize_sched() returns,
+ * each CPU is guaranteed to have executed a full memory barrier since
+ * the end of its last RCU-sched read-side critical section whose beginning
+ * preceded the call to synchronize_sched().  Note that this guarantee
+ * includes CPUs that are offline, idle, or executing in user mode, as
+ * well as CPUs that are executing in the kernel.  Furthermore, if CPU A
+ * invoked synchronize_sched(), which returned to its caller on CPU B,
+ * then both CPU A and CPU B are guaranteed to have executed a full memory
+ * barrier during the execution of synchronize_sched() -- even if CPU A
+ * and CPU B are the same CPU (but again only if the system has more than
+ * one CPU).
+ *
  * This primitive provides the guarantees made by the (now removed)
  * synchronize_kernel() API.  In contrast, synchronize_rcu() only
  * guarantees that rcu_read_lock() sections will have completed.
@@ -2259,6 +2272,9 @@ EXPORT_SYMBOL_GPL(synchronize_sched);
  * read-side critical sections have completed.  RCU read-side critical
  * sections are delimited by rcu_read_lock_bh() and rcu_read_unlock_bh(),
  * and may be nested.
+ *
+ * See the description of synchronize_sched() for more detailed information
+ * on memory ordering guarantees.
  */
 void synchronize_rcu_bh(void)
 {
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index f921154..0f370a8 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -670,6 +670,9 @@ EXPORT_SYMBOL_GPL(kfree_call_rcu);
  * concurrently with new RCU read-side critical sections that began while
  * synchronize_rcu() was waiting.  RCU read-side critical sections are
  * delimited by rcu_read_lock() and rcu_read_unlock(), and may be nested.
+ *
+ * See the description of synchronize_sched() for more detailed information
+ * on memory ordering guarantees.
  */
 void synchronize_rcu(void)
 {
@@ -875,6 +878,11 @@ EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
 
 /**
  * rcu_barrier - Wait until all in-flight call_rcu() callbacks complete.
+ *
+ * Note that this primitive will not always wait for an RCU grace period
+ * to complete.  For example, if there are no RCU callbacks queued anywhere
+ * in the system, then rcu_barrier() is within its rights to return
+ * immediately, without waiting for anything, much less an RCU grace period.
  */
 void rcu_barrier(void)
 {
-- 
1.7.8

