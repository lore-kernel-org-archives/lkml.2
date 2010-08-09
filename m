Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab0HIWPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 18:15:34 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51530 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757202Ab0HIWPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 18:15:22 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 09/10] rcu: update obsolete rcu_read_lock() comment.
Date: Mon,  9 Aug 2010 15:15:10 -0700
Message-Id: <1281392111-25060-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100809221447.GA24358@linux.vnet.ibm.com>
References: <20100809221447.GA24358@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment says that blocking is illegal in rcu_read_lock()-style
RCU read-side critical sections, which is no longer entirely true
given preemptible RCU.  This commit provides a fix.

Suggested-by: David Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 24b8966..d7af96e 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -458,7 +458,20 @@ extern int rcu_my_thread_group_empty(void);
  * will be deferred until the outermost RCU read-side critical section
  * completes.
  *
- * It is illegal to block while in an RCU read-side critical section.
+ * You can avoid reading and understanding the next paragraph by
+ * following this rule: don't put anything in an rcu_read_lock() RCU
+ * read-side critical section that would block in a !PREEMPT kernel.
+ * But if you want the full story, read on!
+ *
+ * In non-preemptible RCU implementations (TREE_RCU and TINY_RCU), it
+ * is illegal to block while in an RCU read-side critical section.  In
+ * preemptible RCU implementations (TREE_PREEMPT_RCU and TINY_PREEMPT_RCU)
+ * in CONFIG_PREEMPT kernel builds, RCU read-side critical sections may
+ * be preempted, but explicit blocking is illegal.  Finally, in preemptible
+ * RCU implementations in real-time (CONFIG_PREEMPT_RT) kernel builds,
+ * RCU read-side critical sections may be preempted and they may also
+ * block, but only when acquiring spinlocks that are subject to priority
+ * inheritance.
  */
 static inline void rcu_read_lock(void)
 {
-- 
1.7.0.6

