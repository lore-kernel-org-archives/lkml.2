Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab1IGG3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:29:12 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40056 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709Ab1IGGUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:55 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH tip/core/rcu 05/55] rcu: Move rcu_head definition to types.h
Date: Tue,  6 Sep 2011 10:59:59 -0700
Message-Id: <1315332049-2604-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take a first step towards untangling Linux kernel header files by
placing the struct rcu_head definition into include/linux/types.h
and including include/linux/types.h in include/linux/rcupdate.h
where struct rcu_head used to be defined.  The actual inclusion point
for include/linux/types.h is with the rest of the #include directives
rather than at the point where struct rcu_head used to be defined,
as suggested by Mathieu Desnoyers.

Once this is in place, then header files that need only rcu_head
can include types.h rather than rcupdate.h.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/rcupdate.h |   11 +----------
 include/linux/types.h    |   10 ++++++++++
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 8be0433..2516555 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -33,6 +33,7 @@
 #ifndef __LINUX_RCUPDATE_H
 #define __LINUX_RCUPDATE_H
 
+#include <linux/types.h>
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/threads.h>
@@ -64,16 +65,6 @@ static inline void rcutorture_record_progress(unsigned long vernum)
 #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
 #define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
 
-/**
- * struct rcu_head - callback structure for use with RCU
- * @next: next update requests in a list
- * @func: actual update function to call after the grace period.
- */
-struct rcu_head {
-	struct rcu_head *next;
-	void (*func)(struct rcu_head *head);
-};
-
 /* Exported common interfaces */
 extern void call_rcu_sched(struct rcu_head *head,
 			   void (*func)(struct rcu_head *rcu));
diff --git a/include/linux/types.h b/include/linux/types.h
index 176da8c..57a9723 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -238,6 +238,16 @@ struct ustat {
 	char			f_fpack[6];
 };
 
+/**
+ * struct rcu_head - callback structure for use with RCU
+ * @next: next update requests in a list
+ * @func: actual update function to call after the grace period.
+ */
+struct rcu_head {
+	struct rcu_head *next;
+	void (*func)(struct rcu_head *head);
+};
+
 #endif	/* __KERNEL__ */
 #endif /*  __ASSEMBLY__ */
 #endif /* _LINUX_TYPES_H */
-- 
1.7.3.2

