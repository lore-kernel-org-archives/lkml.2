Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147Ab1JGQWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 12:22:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50139 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760129Ab1JGQWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 12:22:34 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 06/11] rcu: Make srcu_read_lock_held() call common lockdep-enabled function
Date: Fri,  7 Oct 2011 18:22:05 +0200
Message-Id: <1318004530-705-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318004530-705-1-git-send-email-fweisbec@gmail.com>
References: <1318004530-705-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A common debug_lockdep_rcu_enabled() function is used to check whether
RCU lockdep splats should be reported, but srcu_read_lock() does not
use it.  This commit therefore brings srcu_read_lock_held() up to date.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/srcu.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 553c003..05d34cf 100644
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
  * (ie: that we are in the section between rcu_idle_enter() and rcu_idle_exit())
  * then srcu_read_lock_held() returns false even if the CPU did an srcu_read_lock().
@@ -101,7 +104,7 @@ static inline int srcu_read_lock_held(struct srcu_struct *sp)
 	if (rcu_is_cpu_idle())
 		return 0;
 
-	if (!debug_locks)
+	if (!debug_lockdep_rcu_enabled())
 		return 1;
 
 	return lock_is_held(&sp->dep_map);
-- 
1.7.5.4

