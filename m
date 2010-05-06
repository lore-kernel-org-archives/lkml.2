Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254Ab0EFQxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 12:53:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:51680 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756576Ab0EFQxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 12:53:39 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/5] sched: correctly place paranioa memory barriers in synchronize_sched_expedited()
Date: Thu,  6 May 2010 18:52:52 +0200
Message-Id: <1273164772-19149-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273164772-19149-1-git-send-email-tj@kernel.org>
References: <1273164772-19149-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 06 May 2010 16:52:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

The memory barriers must be in the SMP case, not in the !SMP case.
Also add a barrier after the atomic_inc() in order to ensure that
other CPUs see post-synchronize_sched_expedited() actions as following
the expedited grace period.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/sched.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e9c6d79..155a16d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8932,6 +8932,15 @@ struct cgroup_subsys cpuacct_subsys = {
 
 void synchronize_sched_expedited(void)
 {
+}
+EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
+
+#else /* #ifndef CONFIG_SMP */
+
+static atomic_t synchronize_sched_expedited_count = ATOMIC_INIT(0);
+
+static int synchronize_sched_expedited_cpu_stop(void *data)
+{
 	/*
 	 * There must be a full memory barrier on each affected CPU
 	 * between the time that try_stop_cpus() is called and the
@@ -8943,16 +8952,7 @@ void synchronize_sched_expedited(void)
 	 * necessary.  Do smp_mb() anyway for documentation and
 	 * robustness against future implementation changes.
 	 */
-	smp_mb();
-}
-EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
-
-#else /* #ifndef CONFIG_SMP */
-
-static atomic_t synchronize_sched_expedited_count = ATOMIC_INIT(0);
-
-static int synchronize_sched_expedited_cpu_stop(void *data)
-{
+	smp_mb(); /* See above comment block. */
 	return 0;
 }
 
@@ -8990,6 +8990,7 @@ void synchronize_sched_expedited(void)
 		get_online_cpus();
 	}
 	atomic_inc(&synchronize_sched_expedited_count);
+	smp_mb__after_atomic_inc(); /* ensure post-GP actions seen after GP. */
 	put_online_cpus();
 }
 EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
-- 
1.6.4.2

