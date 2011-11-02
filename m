Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab1KBUbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:31:19 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:32841 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab1KBUbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:31:16 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 17/28] rcu: Make srcu_read_lock_held() call common lockdep-enabled function
Date: Wed,  2 Nov 2011 13:30:38 -0700
Message-Id: <1320265849-5744-17-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-7182-0000-0000-0000001E33AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

A common debug_lockdep_rcu_enabled() function is used to check whether
RCU lockdep splats should be reported, but srcu_read_lock() does not
use it.  This commit therefore brings srcu_read_lock_held() up to date.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/srcu.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 4e0a3d4..d4b1244 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -84,6 +84,9 @@ long srcu_batches_completed(struct srcu_struct *sp);
  * this assumes we are in an SRCU read-side critical section unless it can
  * prove otherwise.
  *
+ * Checks debug_lockdep_rcu_enabled() to prevent false positives during boot
+ * and while lockdep is disabled.
+ *
  * Note that if the CPU is in the idle loop from an RCU point of view
  * (ie: that we are in the section between rcu_idle_enter() and
  * rcu_idle_exit()) then srcu_read_lock_held() returns false even if
@@ -102,7 +105,7 @@ static inline int srcu_read_lock_held(struct srcu_struct *sp)
 	if (rcu_is_cpu_idle())
 		return 0;
 
-	if (!debug_locks)
+	if (!debug_lockdep_rcu_enabled())
 		return 1;
 
 	return lock_is_held(&sp->dep_map);
-- 
1.7.3.2

