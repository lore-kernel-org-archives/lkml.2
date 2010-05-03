Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab0ECSzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 14:55:33 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40168 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605Ab0ECSx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 14:53:28 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH tip/core/urgent 10/10] vfs: fix RCU-lockdep false positive due to /proc access
Date: Mon,  3 May 2010 11:53:19 -0700
Message-Id: <1272912799-17859-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100503185253.GA17672@linux.vnet.ibm.com>
References: <20100503185253.GA17672@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a single-threaded process does a file-descriptor operation, and
some other process accesses that same file descriptor via /proc,
the current rcu_dereference_check_fdtable() can give a false-positive
RCU-lockdep splat due to the reference count being increased by the
/proc access after the reference-count check in fget_light() but before
the check in rcu_dereference_check_fdtable().

This commit prevents this false positive by checking for a single-threaded
process.  To avoid #include hell, this commit also introduces an
rcu_my_thread_group_empty() as a wrapper for thread_group_empty(current).

Located-by: Miles Lane <miles.lane@gmail.com>
Located-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---
 include/linux/fdtable.h  |    3 ++-
 include/linux/rcupdate.h |    2 ++
 kernel/rcupdate.c        |   11 +++++++++++
 3 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 013dc52..d147461 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -61,7 +61,8 @@ struct files_struct {
 	(rcu_dereference_check((fdtfd), \
 			       rcu_read_lock_held() || \
 			       lockdep_is_held(&(files)->file_lock) || \
-			       atomic_read(&(files)->count) == 1))
+			       atomic_read(&(files)->count) == 1 || \
+			       rcu_my_thread_group_empty()))
 
 #define files_fdtable(files) \
 		(rcu_dereference_check_fdtable((files), (files)->fdt))
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index ec9ab49..4dca275 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -190,6 +190,8 @@ static inline int rcu_read_lock_sched_held(void)
 
 #ifdef CONFIG_PROVE_RCU
 
+extern int rcu_my_thread_group_empty(void);
+
 #define __do_rcu_dereference_check(c)					\
 	do {								\
 		static bool __warned;					\
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 03a7ea1..49d808e 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -122,3 +122,14 @@ void wakeme_after_rcu(struct rcu_head  *head)
 	rcu = container_of(head, struct rcu_synchronize, head);
 	complete(&rcu->completion);
 }
+
+#ifdef CONFIG_PROVE_RCU
+/*
+ * wrapper function to avoid #include problems.
+ */
+int rcu_my_thread_group_empty(void)
+{
+	return thread_group_empty(current);
+}
+EXPORT_SYMBOL_GPL(rcu_my_thread_group_empty);
+#endif /* #ifdef CONFIG_PROVE_RCU */
-- 
1.7.0

