Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab1IGGUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:20:55 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46406 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755596Ab1IGGUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:42 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 54/55] rcu: Make srcu_read_lock_held() call common lockdep-enabled function
Date: Tue,  6 Sep 2011 11:00:48 -0700
Message-Id: <1315332049-2604-54-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A common debug_lockdep_rcu_enabled() function is used to check whether
RCU lockdep splats should be reported, but srcu_read_lock() does not
use it.  This commit therefore brings srcu_read_lock_held() up to date.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/srcu.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index fcbaee7..54a70b7 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -84,6 +84,9 @@ long srcu_batches_completed(struct srcu_struct *sp);
  * this assumes we are in an SRCU read-side critical section unless it can
  * prove otherwise.
  *
+ * Checks debug_lockdep_rcu_enabled() to prevent false positives during boot
+ * and while lockdep is disabled.
+ *
  * Note that if the CPU is in an extended quiescent state, for example,
  * if the CPU is in dyntick-idle mode, then rcu_read_lock_held() returns
  * false even if the CPU did an rcu_read_lock().  The reason for this is
@@ -96,7 +99,7 @@ long srcu_batches_completed(struct srcu_struct *sp);
  */
 static inline int srcu_read_lock_held(struct srcu_struct *sp)
 {
-	if (debug_locks)
+	if (!debug_lockdep_rcu_enabled())
 		return lock_is_held(&sp->dep_map);
 	if (rcu_check_extended_qs())
 		return 0;
-- 
1.7.3.2

