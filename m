Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab2FVPfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:35:43 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55041 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933087Ab2FVPfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:35:40 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 08/17] rcu: Remove return value from rcu_assign_pointer()
Date: Fri, 22 Jun 2012 08:35:03 -0700
Message-Id: <1340379312-6684-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120622153501.GA6626@linux.vnet.ibm.com>
 <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062215-7182-0000-0000-000001D2BD6C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The return value from rcu_assign_pointer() is not used, and using it
would be quite ugly, for example:

	q = rcu_assign_pointer(global_p, p);

To prevent this sort of ugliness from spreading, this commit wraps
rcu_assign_pointer() in a do-while loop.

Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reported-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/rcupdate.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 267dc77..a58f382 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -514,10 +514,10 @@ static inline void rcu_preempt_sleep_check(void)
 		(_________p1); \
 	})
 #define __rcu_assign_pointer(p, v, space) \
-	({ \
+	do { \
 		smp_wmb(); \
 		(p) = (typeof(*v) __force space *)(v); \
-	})
+	} while (0)
 
 
 /**
@@ -852,7 +852,7 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
  *
  * Assigns the specified value to the specified RCU-protected
  * pointer, ensuring that any concurrent RCU readers will see
- * any prior initialization.  Returns the value assigned.
+ * any prior initialization.
  *
  * Inserts memory barriers on architectures that require them
  * (which is most of them), and also prevents the compiler from
-- 
1.7.8

