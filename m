Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab0DOTup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 15:50:45 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43206 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154Ab0DOTun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 15:50:43 -0400
Date: Thu, 15 Apr 2010 12:50:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: [PATCH tip/core/urgent] rcu: Make RCU lockdep check the
 lockdep_recursion variable
Message-ID: <20100415195039.GA22623@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lockdep facility temporarily disables lockdep checking by incrementing
the current->lockdep_recursion variable.  Such disabling happens in NMIs
and in other situations where lockdep might expect to recurse on itself.
This patch therefore checks current->lockdep_recursion, disabling RCU
lockdep splats when this variable is non-zero.  In addition, this patch
removes the "likely()", as suggested by Lai Jiangshan.

Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Reported-by: David Miller <davem@davemloft.net>
Tested-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/rcupdate.h |    5 +----
 kernel/rcupdate.c        |    7 +++++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 9f1ddfe..07db2fe 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -101,10 +101,7 @@ extern struct lockdep_map rcu_sched_lock_map;
 # define rcu_read_release_sched() \
 		lock_release(&rcu_sched_lock_map, 1, _THIS_IP_)
 
-static inline int debug_lockdep_rcu_enabled(void)
-{
-	return likely(rcu_scheduler_active && debug_locks);
-}
+extern int debug_lockdep_rcu_enabled(void);
 
 /**
  * rcu_read_lock_held - might we be in RCU read-side critical section?
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 63fe254..03a7ea1 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -69,6 +69,13 @@ EXPORT_SYMBOL_GPL(rcu_scheduler_active);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
+int debug_lockdep_rcu_enabled(void)
+{
+	return rcu_scheduler_active && debug_locks &&
+	       current->lockdep_recursion == 0;
+}
+EXPORT_SYMBOL_GPL(debug_lockdep_rcu_enabled);
+
 /**
  * rcu_read_lock_bh_held - might we be in RCU-bh read-side critical section?
  *
