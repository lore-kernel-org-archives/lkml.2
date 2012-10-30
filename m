Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934042Ab2J3QjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:39:18 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47872 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933844Ab2J3QjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:39:16 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/4] srcu: Add DEFINE_SRCU()
Date: Tue, 30 Oct 2012 09:38:09 -0700
Message-Id: <1351615090-24398-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351615090-24398-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030163650.GA23518@linux.vnet.ibm.com>
 <1351615090-24398-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-8974-0000-0000-000010576936
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000198; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00186993; UDB=6.00042359; UTC=2012-10-30
 16:39:14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

In old days, we had two different API sets for dynamic-allocated per-CPU
data and DEFINE_PER_CPU()-defined per_cpu data, and because SRCU used
dynamic-allocated per-CPU data, its srcu_struct structures cannot be
declared statically.  This commit therefore introduces DEFINE_SRCU()
and DEFINE_STATIC_SRCU() to allow statically declared SRCU structures,
using the new static per-CPU interfaces.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
[ paulmck: Updated for __DELAYED_WORK_INITIALIZER() added argument,
	   fixed whitespace issue. ]
---
 include/linux/srcu.h |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 5cce128..6eb691b 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -42,6 +42,8 @@ struct rcu_batch {
 	struct rcu_head *head, **tail;
 };
 
+#define RCU_BATCH_INIT(name) { NULL, &(name.head) }
+
 struct srcu_struct {
 	unsigned completed;
 	struct srcu_struct_array __percpu *per_cpu_ref;
@@ -72,14 +74,42 @@ int __init_srcu_struct(struct srcu_struct *sp, const char *name,
 	__init_srcu_struct((sp), #sp, &__srcu_key); \
 })
 
+#define __SRCU_DEP_MAP_INIT(srcu_name)	.dep_map = { .name = #srcu_name },
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 int init_srcu_struct(struct srcu_struct *sp);
 
+#define __SRCU_DEP_MAP_INIT(srcu_name)
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 void process_srcu(struct work_struct *work);
 
+#define __SRCU_STRUCT_INIT(name)					\
+	{								\
+		.completed = -300,					\
+		.per_cpu_ref = &name##_srcu_array,			\
+		.queue_lock = __SPIN_LOCK_UNLOCKED(name.queue_lock),	\
+		.running = false,					\
+		.batch_queue = RCU_BATCH_INIT(name.batch_queue),	\
+		.batch_check0 = RCU_BATCH_INIT(name.batch_check0),	\
+		.batch_check1 = RCU_BATCH_INIT(name.batch_check1),	\
+		.batch_done = RCU_BATCH_INIT(name.batch_done),		\
+		.work = __DELAYED_WORK_INITIALIZER(name.work, process_srcu, 0),\
+		__SRCU_DEP_MAP_INIT(name)				\
+	}
+
+/*
+ * define and init a srcu struct at build time.
+ * dont't call init_srcu_struct() nor cleanup_srcu_struct() on it.
+ */
+#define DEFINE_SRCU(name)						\
+	static DEFINE_PER_CPU(struct srcu_struct_array, name##_srcu_array);\
+	struct srcu_struct name = __SRCU_STRUCT_INIT(name);
+
+#define DEFINE_STATIC_SRCU(name)					\
+	static DEFINE_PER_CPU(struct srcu_struct_array, name##_srcu_array);\
+	static struct srcu_struct name = __SRCU_STRUCT_INIT(name);
+
 /**
  * call_srcu() - Queue a callback for invocation after an SRCU grace period
  * @sp: srcu_struct in queue the callback
-- 
1.7.8

