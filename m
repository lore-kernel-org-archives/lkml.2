Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946000Ab2JLRMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 13:12:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41138 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1945953Ab2JLRMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 13:12:22 -0400
X-IronPort-AV: E=Sophos;i="4.80,578,1344182400"; 
   d="scan'208";a="5990993"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 3/4] srcu: add DEFINE_SRCU()
Date: Sat, 13 Oct 2012 01:14:16 +0800
Message-Id: <1350062057-2439-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1350062057-2439-1-git-send-email-laijs@cn.fujitsu.com>
References: <1350062057-2439-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/13 01:12:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/13 01:12:06,
	Serialize complete at 2012/10/13 01:12:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In old days, we have two different API sets for dynamic-allocated per_cpu data
and DEFINE_PER_CPU()-defined per_cpu data, and since we used
dynamic-allocated per_cpu data, we can't use DEFINE_PER_CPU()-defined
per_cpu data(otherwise we will introduce a lot of duplicated code.

In new days, we have only one API sets for both type of per_cpu data,
so we can use DEFINE_PER_CPU() for DEFINE_SRCU() which allows us
define and init srcu struct in build time and allows us use srcu APIs
in very early boot time.

We also provide DEFINE_STATIC_SRCU() which defines an internal srcu struct
inside a single *.c.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/srcu.h |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 5cce128..f986df1 100644
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
+		.work = __DELAYED_WORK_INITIALIZER(name.work, process_srcu),\
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
+#define DEFINE_STATIC_SRCU(name)						\
+	static DEFINE_PER_CPU(struct srcu_struct_array, name##_srcu_array);\
+	static struct srcu_struct name = __SRCU_STRUCT_INIT(name);
+
 /**
  * call_srcu() - Queue a callback for invocation after an SRCU grace period
  * @sp: srcu_struct in queue the callback
-- 
1.7.7.6

