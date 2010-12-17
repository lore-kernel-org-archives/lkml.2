Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab0LQUzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:55:09 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59209 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165Ab0LQUzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:55:04 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 12/20] rcu: Make synchronize_srcu_expedited() fast if running readers
Date: Fri, 17 Dec 2010 12:54:43 -0800
Message-Id: <1292619291-2468-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20101217205433.GA10199@linux.vnet.ibm.com>
References: <20101217205433.GA10199@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The synchronize_srcu_expedited() function is currently quick if there
are no active readers, but will delay a full jiffy if there are any.
If these readers leave their SRCU read-side critical sections quickly,
this is way too long to wait.  So this commit first waits ten microseconds,
and only then falls back to jiffy-at-a-time waiting.

Reported-by: Avi Kivity <avi@redhat.com>
Reported-by: Marcelo Tosatti <mtosatti@redhat.com>
Tested-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig  |   15 +++++++++++++++
 kernel/srcu.c |    8 +++++++-
 2 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 929adf6..3551824 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -488,6 +488,21 @@ config RCU_BOOST_DELAY
 
 	  Accept the default if unsure.
 
+config SRCU_SYNCHRONIZE_DELAY
+	int "Microseconds to delay before waiting for readers"
+	range 0 20
+	default 10
+	help
+	  This option controls how long SRCU delays before entering its
+	  loop waiting on SRCU readers.  The purpose of this loop is
+	  to avoid the unconditional context-switch penalty that would
+	  otherwise be incurred if there was an active SRCU reader,
+	  in a manner similar to adaptive locking schemes.  This should
+	  be set to be a bit longer than the common-case SRCU read-side
+	  critical-section overhead.
+
+	  Accept the default if unsure.
+
 endmenu # "RCU Subsystem"
 
 config IKCONFIG
diff --git a/kernel/srcu.c b/kernel/srcu.c
index c71e075..98d8c1e 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -31,6 +31,7 @@
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
+#include <linux/delay.h>
 #include <linux/srcu.h>
 
 static int init_srcu_struct_fields(struct srcu_struct *sp)
@@ -203,9 +204,14 @@ static void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
 	 * all srcu_read_lock() calls using the old counters have completed.
 	 * Their corresponding critical sections might well be still
 	 * executing, but the srcu_read_lock() primitives themselves
-	 * will have finished executing.
+	 * will have finished executing.  We initially give readers
+	 * an arbitrarily chosen 10 microseconds to get out of their
+	 * SRCU read-side critical sections, then loop waiting 1/HZ
+	 * seconds per iteration.
 	 */
 
+	if (srcu_readers_active_idx(sp, idx))
+		udelay(CONFIG_SRCU_SYNCHRONIZE_DELAY);
 	while (srcu_readers_active_idx(sp, idx))
 		schedule_timeout_interruptible(1);
 
-- 
1.7.3.2

