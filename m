Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030854Ab2ERKnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:43:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42699 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758927Ab2ERKn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:43:28 -0400
Date: Fri, 18 May 2012 03:43:01 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-kgvq9yp3jhtnkwgqm4xrhvov@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        cl@linux.com, riel@redhat.com, akpm@linux-foundation.org,
        bharata.rao@gmail.com, aarcange@redhat.com, Lee.Schermerhorn@hp.com,
        suresh.b.siddha@intel.com, danms@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        cl@linux.com, riel@redhat.com, bharata.rao@gmail.com,
        akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, danms@us.ibm.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm: Optimize numa_group RSS accounting
Git-Commit-ID: c9d90e77f23a1778812e470d48a0be802a8cd4d9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:43:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c9d90e77f23a1778812e470d48a0be802a8cd4d9
Gitweb:     http://git.kernel.org/tip/c9d90e77f23a1778812e470d48a0be802a8cd4d9
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 16 May 2012 15:11:26 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 08:16:27 +0200

mm: Optimize numa_group RSS accounting

Move all relevant data structures into mm_types.h so that mm.h can
access the numa_group::rss fields avoiding the out of line call.

Also wrap the whole thing in a jump-label so as to avoid the
conditionals when there aren't any numa groups around (the normal
case).

This should remove most of the cost added to RSS accounting by the
numa group stuff when that's unused.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dan Smith <danms@us.ibm.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-kgvq9yp3jhtnkwgqm4xrhvov@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mempolicy.h |   45 +--------------------
 include/linux/mm.h        |   16 ++++++-
 include/linux/mm_types.h  |  100 ++++++++++++++++++++++++++++++++++++---------
 kernel/sched/numa.c       |   35 +++-------------
 4 files changed, 101 insertions(+), 95 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 6e1029f..f5db168 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -81,52 +81,9 @@ enum mpol_rebind_step {
 #include <linux/migrate.h>
 #include <linux/list.h>
 #include <linux/sched.h>
-
-struct mm_struct;
+#include <linux/mm_types.h>
 
 #ifdef CONFIG_NUMA
-
-/*
- * Describe a memory policy.
- *
- * A mempolicy can be either associated with a process or with a VMA.
- * For VMA related allocations the VMA policy is preferred, otherwise
- * the process policy is used. Interrupts ignore the memory policy
- * of the current process.
- *
- * Locking policy for interlave:
- * In process context there is no locking because only the process accesses
- * its own state. All vma manipulation is somewhat protected by a down_read on
- * mmap_sem.
- *
- * Freeing policy:
- * Mempolicy objects are reference counted.  A mempolicy will be freed when
- * mpol_put() decrements the reference count to zero.
- *
- * Duplicating policy objects:
- * mpol_dup() allocates a new mempolicy and copies the specified mempolicy
- * to the new storage.  The reference count of the new object is initialized
- * to 1, representing the caller of mpol_dup().
- */
-struct mempolicy {
-	atomic_t refcnt;
-	unsigned short mode; 	/* See MPOL_* above */
-	unsigned short flags;	/* See set_mempolicy() MPOL_F_* above */
-	struct numa_group *numa_group;
-	struct list_head ng_entry;
-	struct vm_area_struct *vma;
-	struct rcu_head rcu;
-	union {
-		short 		 preferred_node; /* preferred */
-		nodemask_t	 nodes;		/* interleave/bind */
-		/* undefined for default */
-	} v;
-	union {
-		nodemask_t cpuset_mems_allowed;	/* relative to these nodes */
-		nodemask_t user_nodemask;	/* nodemask passed by user */
-	} w;
-};
-
 /*
  * Support for managing mempolicy data objects (clone, copy, destroy)
  * The default fast path of a NULL MPOL_DEFAULT policy is always inlined.
diff --git a/include/linux/mm.h b/include/linux/mm.h
index eda8271..96ef84c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1077,13 +1077,23 @@ static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
 }
 
 #ifdef CONFIG_NUMA
-extern void __numa_add_rss_counter(struct vm_area_struct *, int, long);
+#include <linux/jump_label.h>
+
+extern struct static_key sched_numa_groups;
 
 static inline
 void numa_add_rss_counter(struct vm_area_struct *vma, int member, long value)
 {
-	if (vma->vm_policy) /* XXX sodding include dependecies */
-		__numa_add_rss_counter(vma, member, value);
+	if (static_key_false(&sched_numa_groups) &&
+	    vma->vm_policy && vma->vm_policy->numa_group) {
+		/*
+		 * Since the caller passes the vma argument, the caller is
+		 * responsible for making sure the vma is stable, hence the
+		 * ->vm_policy->numa_group dereference is safe. (caller usually
+		 * has vma->vm_mm->mmap_sem for reading).
+		 */
+		atomic_long_add(value, &vma->vm_policy->numa_group->rss.count[member]);
+	}
 }
 #else /* !CONFIG_NUMA */
 static inline void numa_add_rss_counter(struct vm_area_struct *vma, int member, long value) { }
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 9b98193..ee48fe3 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -191,6 +191,87 @@ struct vm_region {
 						* this region */
 };
 
+enum {
+	MM_FILEPAGES,
+	MM_ANONPAGES,
+	MM_SWAPENTS,
+	NR_MM_COUNTERS
+};
+
+struct mm_rss_stat {
+	atomic_long_t count[NR_MM_COUNTERS];
+};
+
+struct numa_entity {
+#ifdef CONFIG_NUMA
+	int			node;		/* home node */
+	struct list_head	numa_entry;	/* balance list */
+	const struct numa_ops	*nops;
+#endif
+};
+
+#ifdef CONFIG_NUMA
+#include <linux/nodemask.h>
+
+struct numa_group {
+	spinlock_t		lock;
+	int			id;
+
+	struct mm_rss_stat	rss;
+
+	struct list_head	tasks;
+	struct list_head	vmas;
+
+	const struct cred	*cred;
+	atomic_t		ref;
+
+	struct numa_entity	numa_entity;
+
+	struct rcu_head		rcu;
+};
+
+/*
+ * Describe a memory policy.
+ *
+ * A mempolicy can be either associated with a process or with a VMA.
+ * For VMA related allocations the VMA policy is preferred, otherwise
+ * the process policy is used. Interrupts ignore the memory policy
+ * of the current process.
+ *
+ * Locking policy for interlave:
+ * In process context there is no locking because only the process accesses
+ * its own state. All vma manipulation is somewhat protected by a down_read on
+ * mmap_sem.
+ *
+ * Freeing policy:
+ * Mempolicy objects are reference counted.  A mempolicy will be freed when
+ * mpol_put() decrements the reference count to zero.
+ *
+ * Duplicating policy objects:
+ * mpol_dup() allocates a new mempolicy and copies the specified mempolicy
+ * to the new storage.  The reference count of the new object is initialized
+ * to 1, representing the caller of mpol_dup().
+ */
+struct mempolicy {
+	atomic_t refcnt;
+	unsigned short mode; 	/* See MPOL_* above */
+	unsigned short flags;	/* See set_mempolicy() MPOL_F_* above */
+	struct numa_group *numa_group;
+	struct list_head ng_entry;
+	struct vm_area_struct *vma;
+	struct rcu_head rcu;
+	union {
+		short 		 preferred_node; /* preferred */
+		nodemask_t	 nodes;		/* interleave/bind */
+		/* undefined for default */
+	} v;
+	union {
+		nodemask_t cpuset_mems_allowed;	/* relative to these nodes */
+		nodemask_t user_nodemask;	/* nodemask passed by user */
+	} w;
+};
+#endif /* CONFIG_NUMA */
+
 /*
  * This struct defines a memory VMM memory area. There is one of these
  * per VM-area/task.  A VM area is any part of the process virtual memory
@@ -265,13 +346,6 @@ struct core_state {
 	struct completion startup;
 };
 
-enum {
-	MM_FILEPAGES,
-	MM_ANONPAGES,
-	MM_SWAPENTS,
-	NR_MM_COUNTERS
-};
-
 #if USE_SPLIT_PTLOCKS && defined(CONFIG_MMU)
 #define SPLIT_RSS_COUNTING
 /* per-thread cached information, */
@@ -281,18 +355,6 @@ struct task_rss_stat {
 };
 #endif /* USE_SPLIT_PTLOCKS */
 
-struct mm_rss_stat {
-	atomic_long_t count[NR_MM_COUNTERS];
-};
-
-struct numa_entity {
-#ifdef CONFIG_NUMA
-	int			node;		/* home node */
-	struct list_head	numa_entry;	/* balance list */
-	const struct numa_ops	*nops;
-#endif
-};
-
 struct mm_struct {
 	struct vm_area_struct * mmap;		/* list of VMAs */
 	struct rb_root mm_rb;
diff --git a/kernel/sched/numa.c b/kernel/sched/numa.c
index af123aa..7b74a15 100644
--- a/kernel/sched/numa.c
+++ b/kernel/sched/numa.c
@@ -853,23 +853,6 @@ early_initcall(numa_init);
 #include <linux/srcu.h>
 #include <linux/syscalls.h>
 
-struct numa_group {
-	spinlock_t		lock;
-	int			id;
-
-	struct mm_rss_stat	rss;
-
-	struct list_head	tasks;
-	struct list_head	vmas;
-
-	const struct cred	*cred;
-	atomic_t		ref;
-
-	struct numa_entity	numa_entity;
-
-	struct rcu_head		rcu;
-};
-
 static struct srcu_struct ng_srcu;
 
 static DEFINE_MUTEX(numa_group_idr_lock);
@@ -898,6 +881,8 @@ static void __ng_put_rcu(struct rcu_head *rcu)
 	kfree(ng);
 }
 
+struct static_key sched_numa_groups = STATIC_KEY_INIT_FALSE;
+
 static void __ng_put(struct numa_group *ng)
 {
 	mutex_lock(&numa_group_idr_lock);
@@ -909,6 +894,8 @@ static void __ng_put(struct numa_group *ng)
 
 	dequeue_ne(&ng->numa_entity);
 
+	static_key_slow_dec(&sched_numa_groups);
+
 	call_rcu(&ng->rcu, __ng_put_rcu);
 }
 
@@ -1123,18 +1110,6 @@ void numa_vma_link(struct vm_area_struct *new, struct vm_area_struct *old)
 	spin_unlock(&ng->lock);
 }
 
-void __numa_add_rss_counter(struct vm_area_struct *vma, int member, long value)
-{
-	/*
-	 * Since the caller passes the vma argument, the caller is responsible
-	 * for making sure the vma is stable, hence the ->vm_policy->numa_group
-	 * dereference is safe. (caller usually has vma->vm_mm->mmap_sem for
-	 * reading).
-	 */
-	if (vma->vm_policy->numa_group)
-		atomic_long_add(value, &vma->vm_policy->numa_group->rss.count[member]);
-}
-
 static void __mpol_put_rcu(struct rcu_head *rcu)
 {
 	struct mempolicy *mpol = container_of(rcu, struct mempolicy, rcu);
@@ -1197,6 +1172,8 @@ static struct numa_group *ng_create(struct task_struct *p)
 	if (err)
 		goto fail_alloc;
 
+	static_key_slow_inc(&sched_numa_groups);
+
 	spin_lock_init(&ng->lock);
 	atomic_set(&ng->ref, 1);
 	ng->cred = get_task_cred(p);
