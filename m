Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab1CNDwj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 23:52:39 -0400
Received: from flusers.ccur.com ([173.221.59.2]:45687 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756819Ab1CNDvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 23:51:53 -0400
Date: Sun, 13 Mar 2011 23:50:44 -0400
From: Joe Korty <joe.korty@ccur.com>
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, peterz@infradead.org, laijs@cn.fujitsu.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org, houston.jim@comcast.net, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] jrcu: fix broken rcu_barrier
Message-ID: <20110314035044.GA12990@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jrcu: fix bug in rcu_barrier.

It is not equivalent to synchronize_rcu.  But it
can be implemented by a pair of synchronize_rcu's,
so do so.

Thanks go to Paul E McKenney for finding this.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/kernel/jrcu.c
===================================================================
--- a/kernel/jrcu.c
+++ b/kernel/jrcu.c
@@ -183,7 +183,7 @@ void rcu_note_might_resched(void)
 }
 EXPORT_SYMBOL(rcu_note_might_resched);
 
-void rcu_barrier(void)
+void synchronize_sched(void)
 {
 	struct rcu_synchronize rcu;
 
@@ -196,6 +196,13 @@ void rcu_barrier(void)
 	atomic_inc(&rcu_stats.nbarriers);
 
 }
+EXPORT_SYMBOL_GPL(synchronize_sched);
+
+void rcu_barrier(void)
+{
+	synchronize_sched();
+	synchronize_sched();
+}
 EXPORT_SYMBOL_GPL(rcu_barrier);
 
 void rcu_force_quiescent_state(void)
Index: b/include/linux/jrcu.h
===================================================================
--- a/include/linux/jrcu.h
+++ b/include/linux/jrcu.h
@@ -39,12 +39,13 @@ extern void rcu_barrier(void);
 #define rcu_barrier_sched			rcu_barrier
 #define rcu_barrier_bh				rcu_barrier
 
-#define synchronize_rcu				rcu_barrier
-#define synchronize_sched			rcu_barrier
-#define synchronize_sched_expedited		rcu_barrier
-#define synchronize_rcu_bh			rcu_barrier
-#define synchronize_rcu_expedited		rcu_barrier
-#define synchronize_rcu_bh_expedited		rcu_barrier
+extern void synchronize_sched(void);
+
+#define synchronize_rcu				synchronize_sched
+#define synchronize_sched_expedited		synchronize_sched
+#define synchronize_rcu_bh			synchronize_sched
+#define synchronize_rcu_expedited		synchronize_sched
+#define synchronize_rcu_bh_expedited		synchronize_sched
 
 #define rcu_init(cpu)				do { } while (0)
 #define rcu_init_sched()			do { } while (0)
