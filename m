Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab0KGCFq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 22:05:46 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49758 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867Ab0KGCFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 22:05:42 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 12/12] rcu: Make synchronize_srcu_expedited() fast if running readers
Date: Sat,  6 Nov 2010 19:05:32 -0700
Message-Id: <1289095532-5398-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20101107020507.GA4974@linux.vnet.ibm.com>
References: <20101107020507.GA4974@linux.vnet.ibm.com>
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
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/srcu.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/srcu.c b/kernel/srcu.c
index c71e075..a48caa7 100644
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
+		udelay(10);
 	while (srcu_readers_active_idx(sp, idx))
 		schedule_timeout_interruptible(1);
 
-- 
1.7.0.6

