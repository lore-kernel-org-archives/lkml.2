Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab2JEHUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 03:20:54 -0400
Received: from kvy.fi ([83.143.60.250]:59262 "EHLO kvy.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab2JEHUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 03:20:53 -0400
X-Greylist: delayed 1198 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Oct 2012 03:20:52 EDT
Date: Fri, 05 Oct 2012 09:59:15 +0300 (EEST)
Message-Id: <20121005.095915.597083345241151143.apm@brigitte.kvy.fi>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
From: Antti P Miettinen <ananaza@iki.fi>
Reply-To: ananaza@iki.fi
In-Reply-To: <20121004213933.GI2464@linux.vnet.ibm.com>
References: <20121005.000053.1467384272006747942.apm@brigitte.kvy.fi>
	<20121004213933.GI2464@linux.vnet.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 83.143.58.51
X-SA-Exim-Mail-From: ananaza@iki.fi
Subject: Re: [PATCH] rcu: Add "expedite always" switch
X-SA-Exim-Version: 4.2.1 (built Wed, 12 May 2010 04:32:08 +0000)
X-SA-Exim-Scanned: Yes (on brigitte)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> b.	Maybe sysfs setting.  Initially, this can be simple "on" and "off",
> 	exported with root-only access (like you have above).  If more
> 	elaborate use cases appear, this might become the adminstrative
> 	override.  The key point is that this needs to go through some
> 	sort of separate function (for example, via the KERNEL_ATTR_RW()
> 	macro) so that if it needs to change in the future, we can do
> 	the change easily.

I did not really envision the module param to be an application
interface, more like an administrative interface. For dynamically
requesting things on/off you probably want something like PM QoS which
does proper book keeping and consolidation but PM QoS for this feels a
bit overkill. But I do not think sysfs node is appropriate either for
an application interface. I guess module_param_cb() would also achieve
the goal of "doing something" upon parameter change. Anyway - below
the 0-perm module param + sysfs node version.

	--Antti

Add a module parameter for always using expedited RCU primitives.

Signed-off-by: Antti P Miettinen <amiettinen@nvidia.com>
---
 kernel/ksysfs.c         |   18 ++++++++++++++++++
 kernel/rcu.h            |    2 ++
 kernel/rcupdate.c       |    3 +++
 kernel/rcutiny_plugin.h |    5 ++++-
 kernel/rcutree.c        |   10 ++++++++--
 kernel/rcutree_plugin.h |    5 ++++-
 kernel/srcu.c           |    6 +++++-
 7 files changed, 44 insertions(+), 5 deletions(-)

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
index 4fb2376..744c117 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2221,7 +2221,10 @@ void synchronize_sched(void)
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
 
@@ -2242,7 +2245,10 @@ void synchronize_rcu_bh(void)
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
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index f921154..0e9ca8b 100644
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
 
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 97c465e..d56873c 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -34,6 +34,8 @@
 #include <linux/delay.h>
 #include <linux/srcu.h>
 
+#include "rcu.h"
+
 /*
  * Initialize an rcu_batch structure to empty.
  */
@@ -464,7 +466,9 @@ static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
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
1.7.4.1

