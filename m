Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382Ab1AMTEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 14:04:54 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40387 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933192Ab1AMTEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 14:04:49 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 1/2] rcu: demote SRCU_SYNCHRONIZE_DELAY from kernel-parameter status
Date: Thu, 13 Jan 2011 11:04:36 -0800
Message-Id: <1294945477-10612-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110113190414.GA10457@linux.vnet.ibm.com>
References: <20110113190414.GA10457@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the adaptive synchronize_srcu_expedited() approach has
worked very well in testing, remove the kernel parameter and
replace it by a C-preprocessor macro.  If someone finds problems
with this approach, a more complex and aggressively adaptive
approach might be required.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig  |   15 ---------------
 kernel/srcu.c |   15 +++++++++++++--
 2 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 526ec1c..e11bc79 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -497,21 +497,6 @@ config RCU_BOOST_DELAY
 
 	  Accept the default if unsure.
 
-config SRCU_SYNCHRONIZE_DELAY
-	int "Microseconds to delay before waiting for readers"
-	range 0 20
-	default 10
-	help
-	  This option controls how long SRCU delays before entering its
-	  loop waiting on SRCU readers.  The purpose of this loop is
-	  to avoid the unconditional context-switch penalty that would
-	  otherwise be incurred if there was an active SRCU reader,
-	  in a manner similar to adaptive locking schemes.  This should
-	  be set to be a bit longer than the common-case SRCU read-side
-	  critical-section overhead.
-
-	  Accept the default if unsure.
-
 endmenu # "RCU Subsystem"
 
 config IKCONFIG
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 98d8c1e..73ce23f 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -156,6 +156,16 @@ void __srcu_read_unlock(struct srcu_struct *sp, int idx)
 EXPORT_SYMBOL_GPL(__srcu_read_unlock);
 
 /*
+ * We use an adaptive strategy for synchronize_srcu() and especially for
+ * synchronize_srcu_expedited().  We spin for a fixed time period
+ * (defined below) to allow SRCU readers to exit their read-side critical
+ * sections.  If there are still some readers after 10 microseconds,
+ * we repeatedly block for 1-millisecond time periods.  This approach
+ * has done well in testing, so there is no need for a config parameter.
+ */
+#define SYNCHRONIZE_SRCU_READER_DELAY 10
+
+/*
  * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
  */
 static void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
@@ -207,11 +217,12 @@ static void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
 	 * will have finished executing.  We initially give readers
 	 * an arbitrarily chosen 10 microseconds to get out of their
 	 * SRCU read-side critical sections, then loop waiting 1/HZ
-	 * seconds per iteration.
+	 * seconds per iteration.  The 10-microsecond value has done
+	 * very well in testing.
 	 */
 
 	if (srcu_readers_active_idx(sp, idx))
-		udelay(CONFIG_SRCU_SYNCHRONIZE_DELAY);
+		udelay(SYNCHRONIZE_SRCU_READER_DELAY);
 	while (srcu_readers_active_idx(sp, idx))
 		schedule_timeout_interruptible(1);
 
-- 
1.7.3.2

