Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab1CIWQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 17:16:43 -0500
Received: from flusers.ccur.com ([173.221.59.2]:41933 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751405Ab1CIWQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 17:16:42 -0500
Date: Wed, 9 Mar 2011 17:16:04 -0500
From: Joe Korty <joe.korty@ccur.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "loic.minier@linaro.org" <loic.minier@linaro.org>,
        "dhaval.giani@gmail.com" <dhaval.giani@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "houston.jim@comcast.net" <houston.jim@comcast.net>
Subject: [PATCH 3/4] jrcu: tap might_resched()
Message-ID: <20110309221604.GC24670@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <4CD912E9.1080907@cn.fujitsu.com>
 <20101110155419.GC5750@nowhere>
 <1289410271.2084.25.camel@laptop>
 <20101111041920.GD3134@linux.vnet.ibm.com>
 <20101113223046.GB5445@nowhere>
 <20101116012846.GV2555@linux.vnet.ibm.com>
 <20101116135230.GA5362@nowhere>
 <20101116155104.GB2497@linux.vnet.ibm.com>
 <20101117005229.GC26243@nowhere>
 <20110307203106.GA23002@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110307203106.GA23002@tsunami.ccur.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jrcu: tap into might_resched.

All places where the voluntary preemption patches have marked
as safe to context switch are also known rcu quiescent points.

Not fundamentally needed, accelerates rcu batching.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/include/linux/kernel.h
===================================================================
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -114,11 +114,18 @@ struct completion;
 struct pt_regs;
 struct user;
 
+/* cannot bring in linux/rcupdate.h at this point */
+#ifdef CONFIG_JRCU
+extern void rcu_note_might_resched(void);
+#else
+#define rcu_note_might_resched()
+#endif /*JRCU */
+
 #ifdef CONFIG_PREEMPT_VOLUNTARY
 extern int _cond_resched(void);
-# define might_resched() _cond_resched()
+# define might_resched() do { _cond_resched(); rcu_note_might_resched(); } while (0)
 #else
-# define might_resched() do { } while (0)
+# define might_resched() do { rcu_note_might_resched(); } while (0)
 #endif
 
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
Index: b/include/linux/jrcu.h
===================================================================
--- a/include/linux/jrcu.h
+++ b/include/linux/jrcu.h
@@ -71,6 +71,8 @@ extern void rcu_note_context_switch(int 
 #define rcu_sched_qs				rcu_note_context_switch
 #define rcu_bh_qs				rcu_note_context_switch
 
+extern void rcu_note_might_resched(void);
+
 extern void rcu_scheduler_starting(void);
 extern int rcu_scheduler_active __read_mostly;
 
Index: b/kernel/jrcu.c
===================================================================
--- a/kernel/jrcu.c
+++ b/kernel/jrcu.c
@@ -166,6 +166,16 @@ void rcu_note_context_switch(int cpu)
 	rcu_eob(cpu);
 }
 
+void rcu_note_might_resched(void)
+{
+	unsigned long flags;
+
+	raw_local_irq_save(flags);
+	rcu_eob(rcu_cpu());
+	raw_local_irq_restore(flags);
+}
+EXPORT_SYMBOL(rcu_note_might_resched);
+
 void rcu_barrier(void)
 {
 	struct rcu_synchronize rcu;
