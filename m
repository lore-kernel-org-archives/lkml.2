Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965019Ab2J3RcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:32:19 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58797 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933622Ab2J3RcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:32:13 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Antti P Miettinen <ananaza@iki.fi>,
        Antti P Miettinen <amiettinen@nvidia.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/5] rcu: Add a module parameter to force use of expedited RCU primitives
Date: Tue, 30 Oct 2012 10:19:21 -0700
Message-Id: <1351617563-28506-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351617563-28506-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030171906.GA27431@linux.vnet.ibm.com>
 <1351617563-28506-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103017-5112-0000-0000-00000E01AFED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antti P Miettinen <ananaza@iki.fi>

There have been some embedded applications that would benefit from
use of expedited grace-period primitives.  In some ways, this is
similar to synchronize_net() doing either a normal or an expedited
grace period depending on lock state, but with control outside of
the kernel.

This commit therefore adds rcu_expedited boot and sysfs parameters
that cause the kernel to substitute expedited primitives for the
normal grace-period primitives.

[ paulmck: Add trace/event/rcu.h to kernel/srcu.c to avoid build error.
	   Get rid of infinite loop through contention path.]

Signed-off-by: Antti P Miettinen <amiettinen@nvidia.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/ksysfs.c         |   18 ++++++++++++++++++
 kernel/rcu.h            |    2 ++
 kernel/rcupdate.c       |    3 +++
 kernel/rcutiny_plugin.h |    5 ++++-
 kernel/rcutree.c        |   12 +++++++++---
 kernel/rcutree_plugin.h |    7 +++++--
 kernel/srcu.c           |    8 +++++++-
 7 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 4e316e1..8715a79 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -141,6 +141,23 @@ static ssize_t fscaps_show(struct kobject *kobj,
 }
 KERNEL_ATTR_RO(fscaps);
 
+int rcu_expedited;
+static ssize_t rcu_expedited_show(struct kobject *kobj,
+				  struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", rcu_expedited);
+}
+static ssize_t rcu_expedited_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t count)
+{
+	if (kstrtoint(buf, 0, &rcu_expedited))
+		return -EINVAL;
+
+	return count;
+}
+KERNEL_ATTR_RW(rcu_expedited);
+
 /*
  * Make /sys/kernel/notes give the raw contents of our kernel .notes section.
  */
@@ -182,6 +199,7 @@ static struct attribute * kernel_attrs[] = {
 	&kexec_crash_size_attr.attr,
 	&vmcoreinfo_attr.attr,
 #endif
+	&rcu_expedited_attr.attr,
 	NULL
 };
 
diff --git a/kernel/rcu.h b/kernel/rcu.h
index 8ba99cd..20dfba5 100644
--- a/kernel/rcu.h
+++ b/kernel/rcu.h
@@ -109,4 +109,6 @@ static inline bool __rcu_reclaim(char *rn, struct rcu_head *head)
 	}
 }
 
+extern int rcu_expedited;
+
 #endif /* __LINUX_RCU_H */
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 29ca1c6..a2cf761 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -46,12 +46,15 @@
 #include <linux/export.h>
 #include <linux/hardirq.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/rcu.h>
 
 #include "rcu.h"
 
+module_param(rcu_expedited, int, 0);
+
 #ifdef CONFIG_PREEMPT_RCU
 
 /*
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 3d01902..f85016a 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -706,7 +706,10 @@ void synchronize_rcu(void)
 		return;
 
 	/* Once we get past the fastpath checks, same code as rcu_barrier(). */
-	rcu_barrier();
+	if (rcu_expedited)
+		synchronize_rcu_expedited();
+	else
+		rcu_barrier();
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 74df86b..f9c17c3 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2224,7 +2224,10 @@ void synchronize_sched(void)
 			   "Illegal synchronize_sched() in RCU-sched read-side critical section");
 	if (rcu_blocking_is_gp())
 		return;
-	wait_rcu_gp(call_rcu_sched);
+	if (rcu_expedited)
+		synchronize_sched_expedited();
+	else
+		wait_rcu_gp(call_rcu_sched);
 }
 EXPORT_SYMBOL_GPL(synchronize_sched);
 
@@ -2245,7 +2248,10 @@ void synchronize_rcu_bh(void)
 			   "Illegal synchronize_rcu_bh() in RCU-bh read-side critical section");
 	if (rcu_blocking_is_gp())
 		return;
-	wait_rcu_gp(call_rcu_bh);
+	if (rcu_expedited)
+		synchronize_rcu_bh_expedited();
+	else
+		wait_rcu_gp(call_rcu_bh);
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
 
@@ -2328,7 +2334,7 @@ void synchronize_sched_expedited(void)
 		if (trycount++ < 10) {
 			udelay(trycount * num_online_cpus());
 		} else {
-			synchronize_sched();
+			wait_rcu_gp(call_rcu_sched);
 			return;
 		}
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index f921154..c177ba0 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -679,7 +679,10 @@ void synchronize_rcu(void)
 			   "Illegal synchronize_rcu() in RCU read-side critical section");
 	if (!rcu_scheduler_active)
 		return;
-	wait_rcu_gp(call_rcu);
+	if (rcu_expedited)
+		synchronize_rcu_expedited();
+	else
+		wait_rcu_gp(call_rcu);
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
@@ -831,7 +834,7 @@ void synchronize_rcu_expedited(void)
 			udelay(trycount * num_online_cpus());
 		} else {
 			put_online_cpus();
-			synchronize_rcu();
+			wait_rcu_gp(call_rcu);
 			return;
 		}
 	}
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 97c465e..de90740 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -34,6 +34,10 @@
 #include <linux/delay.h>
 #include <linux/srcu.h>
 
+#include <trace/events/rcu.h>
+
+#include "rcu.h"
+
 /*
  * Initialize an rcu_batch structure to empty.
  */
@@ -464,7 +468,9 @@ static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
  */
 void synchronize_srcu(struct srcu_struct *sp)
 {
-	__synchronize_srcu(sp, SYNCHRONIZE_SRCU_TRYCOUNT);
+	__synchronize_srcu(sp, rcu_expedited
+			   ? SYNCHRONIZE_SRCU_EXP_TRYCOUNT
+			   : SYNCHRONIZE_SRCU_TRYCOUNT);
 }
 EXPORT_SYMBOL_GPL(synchronize_srcu);
 
-- 
1.7.8

