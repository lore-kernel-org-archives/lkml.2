Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab0GNUN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:13:27 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52443 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757547Ab0GNUKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:10:19 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 30/30] rcu: improve kerneldoc for rcu_read_lock(), call_rcu(), and synchronize_rcu()
Date: Wed, 14 Jul 2010 13:10:04 -0700
Message-Id: <1279138204-12849-30-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100714200945.GA10535@linux.vnet.ibm.com>
References: <20100714200945.GA10535@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it explicit that new RCU read-side critical sections that start
after call_rcu() and synchronize_rcu() start might still be running
after the end of the relevant grace period.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   16 +++++++++-------
 kernel/rcutree_plugin.h  |    8 +++++---
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 508ebba..27b44b3 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -444,7 +444,7 @@ extern int rcu_my_thread_group_empty(void);
  * until after the all the other CPUs exit their critical sections.
  *
  * Note, however, that RCU callbacks are permitted to run concurrently
- * with RCU read-side critical sections.  One way that this can happen
+ * with new RCU read-side critical sections.  One way that this can happen
  * is via the following sequence of events: (1) CPU 0 enters an RCU
  * read-side critical section, (2) CPU 1 invokes call_rcu() to register
  * an RCU callback, (3) CPU 0 exits the RCU read-side critical section,
@@ -602,11 +602,13 @@ extern void wakeme_after_rcu(struct rcu_head  *head);
 /**
  * call_rcu() - Queue an RCU callback for invocation after a grace period.
  * @head: structure to be used for queueing the RCU updates.
- * @func: actual update function to be invoked after the grace period
+ * @func: actual callback function to be invoked after the grace period
  *
- * The update function will be invoked some time after a full grace
- * period elapses, in other words after all currently executing RCU
- * read-side critical sections have completed.  RCU read-side critical
+ * The callback function will be invoked some time after a full grace
+ * period elapses, in other words after all pre-existing RCU read-side
+ * critical sections have completed.  However, the callback function
+ * might well execute concurrently with RCU read-side critical sections
+ * that started after call_rcu() was invoked.  RCU read-side critical
  * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
  * and may be nested.
  */
@@ -616,9 +618,9 @@ extern void call_rcu(struct rcu_head *head,
 /**
  * call_rcu_bh() - Queue an RCU for invocation after a quicker grace period.
  * @head: structure to be used for queueing the RCU updates.
- * @func: actual update function to be invoked after the grace period
+ * @func: actual callback function to be invoked after the grace period
  *
- * The update function will be invoked some time after a full grace
+ * The callback function will be invoked some time after a full grace
  * period elapses, in other words after all currently executing RCU
  * read-side critical sections have completed. call_rcu_bh() assumes
  * that the read-side critical sections end on completion of a softirq
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 9906f85..63bb771 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -546,9 +546,11 @@ EXPORT_SYMBOL_GPL(call_rcu);
  *
  * Control will return to the caller some time after a full grace
  * period has elapsed, in other words after all currently executing RCU
- * read-side critical sections have completed.  RCU read-side critical
- * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
- * and may be nested.
+ * read-side critical sections have completed.  Note, however, that
+ * upon return from synchronize_rcu(), the caller might well be executing
+ * concurrently with new RCU read-side critical sections that began while
+ * synchronize_rcu() was waiting.  RCU read-side critical sections are
+ * delimited by rcu_read_lock() and rcu_read_unlock(), and may be nested.
  */
 void synchronize_rcu(void)
 {
-- 
1.7.0.6

