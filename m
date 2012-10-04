Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab2JDVII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:08:08 -0400
Received: from kvy.fi ([83.143.60.250]:57862 "EHLO kvy.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757271Ab2JDVIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:08:06 -0400
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Oct 2012 17:08:06 EDT
Date: Fri, 05 Oct 2012 00:00:53 +0300 (EEST)
Message-Id: <20121005.000053.1467384272006747942.apm@brigitte.kvy.fi>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
From: Antti P Miettinen <amiettinen@nvidia.com>
Reply-To: ananaza@iki.fi
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 83.143.58.51
X-SA-Exim-Mail-From: amiettinen@nvidia.com
Subject: [PATCH] rcu: Add "expedite always" switch
X-SA-Exim-Version: 4.2.1 (built Wed, 12 May 2010 04:32:08 +0000)
X-SA-Exim-Scanned: Yes (on brigitte)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a module parameter for always using expedited RCU primitives.

Signed-off-by: Antti P Miettinen <amiettinen@nvidia.com>
---
 include/linux/rcupdate.h |    2 ++
 kernel/rcupdate.c        |    4 ++++
 kernel/rcutiny_plugin.h  |    5 ++++-
 kernel/rcutree.c         |   10 ++++++++--
 kernel/rcutree_plugin.h  |    5 ++++-
 kernel/srcu.c            |    4 +++-
 6 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 7c968e4..b37efae 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -45,6 +45,8 @@
 #include <linux/bug.h>
 #include <linux/compiler.h>
 
+extern int rcu_expedited;
+
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable; /* for sysctl */
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 29ca1c6..6057e58 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -46,12 +46,16 @@
 #include <linux/export.h>
 #include <linux/hardirq.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/rcu.h>
 
 #include "rcu.h"
 
+int rcu_expedited;
+module_param(rcu_expedited, int, 0644);
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
index 97c465e..00c4169 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -464,7 +464,9 @@ static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
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

