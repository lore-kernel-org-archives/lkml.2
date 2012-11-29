Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab2K2Ins (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 03:43:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:24868 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab2K2InE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 03:43:04 -0500
X-IronPort-AV: E=Sophos;i="4.83,339,1352044800"; 
   d="scan'208";a="6299575"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 5/8] srcu: srcu_read_lock() can be called from idle loop
Date: Thu, 29 Nov 2012 16:46:06 +0800
Message-Id: <1354178770-6028-6-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1354178770-6028-1-git-send-email-laijs@cn.fujitsu.com>
References: <1354178770-6028-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/29 16:42:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/29 16:42:32,
	Serialize complete at 2012/11/29 16:42:32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SRCU is based on its own statemachine and it doesn't
relies on normal RCU now, its read critical section can be used in
idle loop, so we remove the check and the comments.

It partially reverts ff195cb6(the part for SRCU).

It also makes the codes match the comments in whatisRCU.txt:

g.	Do you need read-side critical sections that are respected
	even though they are in the middle of the idle loop, during
	user-mode execution, or on an offlined CPU?  If so, SRCU is the
	only choice that will work for you.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/srcu.h |   21 +++------------------
 1 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index ae3ee39..04f4121 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -151,25 +151,14 @@ void srcu_barrier(struct srcu_struct *sp);
  * Checks debug_lockdep_rcu_enabled() to prevent false positives during boot
  * and while lockdep is disabled.
  *
- * Note that if the CPU is in the idle loop from an RCU point of view
- * (ie: that we are in the section between rcu_idle_enter() and
- * rcu_idle_exit()) then srcu_read_lock_held() returns false even if
- * the CPU did an srcu_read_lock().  The reason for this is that RCU
- * ignores CPUs that are in such a section, considering these as in
- * extended quiescent state, so such a CPU is effectively never in an
- * RCU read-side critical section regardless of what RCU primitives it
- * invokes.  This state of affairs is required --- we need to keep an
- * RCU-free window in idle where the CPU may possibly enter into low
- * power mode. This way we can notice an extended quiescent state to
- * other CPUs that started a grace period. Otherwise we would delay any
- * grace period as long as we run in the idle task.
+ * Note that SRCU is based on its own statemachine and it doesn't
+ * relies on normal RCU, it can be called from the CPU which
+ * is in the idle loop from an RCU point of view or offline.
  */
 static inline int srcu_read_lock_held(struct srcu_struct *sp)
 {
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
-	if (rcu_is_cpu_idle())
-		return 0;
 	return lock_is_held(&sp->dep_map);
 }
 
@@ -231,8 +220,6 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 	int retval = __srcu_read_lock(sp);
 
 	rcu_lock_acquire(&(sp)->dep_map);
-	rcu_lockdep_assert(!rcu_is_cpu_idle(),
-			   "srcu_read_lock() used illegally while idle");
 	return retval;
 }
 
@@ -246,8 +233,6 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
 	__releases(sp)
 {
-	rcu_lockdep_assert(!rcu_is_cpu_idle(),
-			   "srcu_read_unlock() used illegally while idle");
 	rcu_lock_release(&(sp)->dep_map);
 	__srcu_read_unlock(sp, idx);
 }
-- 
1.7.4.4

