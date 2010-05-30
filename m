Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab0E3Buu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 21:50:50 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.61]:49486 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab0E3Bue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 21:50:34 -0400
X-Greylist: delayed 1191 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 May 2010 21:50:33 EDT
Date: Sat, 29 May 2010 21:31:36 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Cc: akpm@linux-foundation.org, bblum@andrew.cmu.edu, ebiederm@xmission.com,
       lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com,
       oleg@redhat.com
Subject: [RFC] [PATCH 1/2] cgroups: read-write lock CLONE_THREAD forking
 per threadgroup
Message-ID: <20100530013136.GB762@ghc01.ghc.andrew.cmu.edu>
References: <20100530013002.GA762@ghc01.ghc.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cgroup-threadgroup-fork-lock.patch"
In-Reply-To: <20100530013002.GA762@ghc01.ghc.andrew.cmu.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.5.30.11514
X-SMTP-Spam-Clean: 8% (
 TO_NO_NAME 0, __CD 0, __CP_NAME_BODY 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS , __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds functionality to read/write lock CLONE_THREAD fork()ing per-threadgroup

From: Ben Blum <bblum@andrew.cmu.edu>

This patch adds an rwsem that lives in a threadgroup's signal_struct that's
taken for reading in the fork path, under CONFIG_CGROUPS. If another part of
the kernel later wants to use such a locking mechanism, the CONFIG_CGROUPS
ifdefs should be changed to a higher-up flag that CGROUPS and the other system
would both depend on.

This is a pre-patch for cgroups-procs-write.patch.

Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
---
 include/linux/cgroup.h    |   15 ++++++++++-----
 include/linux/init_task.h |    9 +++++++++
 include/linux/sched.h     |   10 ++++++++++
 kernel/cgroup.c           |   23 +++++++++++++++++++++--
 kernel/fork.c             |   10 +++++++---
 5 files changed, 57 insertions(+), 10 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 8f78073..196a703 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -31,10 +31,12 @@ extern void cgroup_lock(void);
 extern int cgroup_lock_is_held(void);
 extern bool cgroup_lock_live_group(struct cgroup *cgrp);
 extern void cgroup_unlock(void);
-extern void cgroup_fork(struct task_struct *p);
+extern void cgroup_fork(struct task_struct *p, unsigned long clone_flags);
 extern void cgroup_fork_callbacks(struct task_struct *p);
-extern void cgroup_post_fork(struct task_struct *p);
+extern void cgroup_post_fork(struct task_struct *p, unsigned long clone_flags);
 extern void cgroup_exit(struct task_struct *p, int run_callbacks);
+extern void cgroup_fork_failed(struct task_struct *p, int run_callbacks,
+			       unsigned long clone_flags);
 extern int cgroupstats_build(struct cgroupstats *stats,
 				struct dentry *dentry);
 extern int cgroup_load_subsys(struct cgroup_subsys *ss);
@@ -613,11 +615,14 @@ unsigned short css_depth(struct cgroup_subsys_state *css);
 
 static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
-static inline void cgroup_fork(struct task_struct *p) {}
+static inline void cgroup_fork(struct task_struct *p,
+			       unsigned long clone_flags) {}
 static inline void cgroup_fork_callbacks(struct task_struct *p) {}
-static inline void cgroup_post_fork(struct task_struct *p) {}
+static inline void cgroup_post_fork(struct task_struct *p,
+				    unsigned long clone_flags) {}
 static inline void cgroup_exit(struct task_struct *p, int callbacks) {}
-
+static inline void cgroup_fork_failed(struct task_struct *p, int callbacks,
+				      unsigned long clone_flags) {}
 static inline void cgroup_lock(void) {}
 static inline void cgroup_unlock(void) {}
 static inline int cgroupstats_build(struct cgroupstats *stats,
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index b1ed1cd..cfb2bc8 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -15,6 +15,14 @@
 extern struct files_struct init_files;
 extern struct fs_struct init_fs;
 
+#ifdef CONFIG_CGROUPS
+#define INIT_THREADGROUP_FORK_LOCK(sig)					\
+	.threadgroup_fork_lock =					\
+		__RWSEM_INITIALIZER(sig.threadgroup_fork_lock),
+#else
+#define INIT_THREADGROUP_FORK_LOCK(sig)
+#endif
+
 #define INIT_SIGNALS(sig) {						\
 	.count		= ATOMIC_INIT(1), 				\
 	.wait_chldexit	= __WAIT_QUEUE_HEAD_INITIALIZER(sig.wait_chldexit),\
@@ -29,6 +37,7 @@ extern struct fs_struct init_fs;
 		.running = 0,						\
 		.lock = __SPIN_LOCK_UNLOCKED(sig.cputimer.lock),	\
 	},								\
+	INIT_THREADGROUP_FORK_LOCK(sig)					\
 }
 
 extern struct nsproxy init_nsproxy;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2b7b81d..2bbcbd2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -627,6 +627,16 @@ struct signal_struct {
 	unsigned audit_tty;
 	struct tty_audit_buf *tty_audit_buf;
 #endif
+#ifdef CONFIG_CGROUPS
+	/*
+	 * The threadgroup_fork_lock prevents threads from forking with
+	 * CLONE_THREAD while held for writing. Use this for fork-sensitive
+	 * threadgroup-wide operations.
+	 * Currently only needed by cgroups, and the fork-side readlock happens
+	 * in cgroup_{fork,post_fork,fork_failed}.
+	 */
+	struct rw_semaphore threadgroup_fork_lock;
+#endif
 
 	int oom_adj;	/* OOM kill score adjustment (bit shift) */
 };
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6d870f2..6c8e46f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4015,8 +4015,10 @@ static const struct file_operations proc_cgroupstats_operations = {
  * At the point that cgroup_fork() is called, 'current' is the parent
  * task, and the passed argument 'child' points to the child task.
  */
-void cgroup_fork(struct task_struct *child)
+void cgroup_fork(struct task_struct *child, unsigned long clone_flags)
 {
+	if (clone_flags & CLONE_THREAD)
+		down_read(&current->signal->threadgroup_fork_lock);
 	task_lock(current);
 	child->cgroups = current->cgroups;
 	get_css_set(child->cgroups);
@@ -4058,7 +4060,7 @@ void cgroup_fork_callbacks(struct task_struct *child)
  * with the first call to cgroup_iter_start() - to guarantee that the
  * new task ends up on its list.
  */
-void cgroup_post_fork(struct task_struct *child)
+void cgroup_post_fork(struct task_struct *child, unsigned long clone_flags)
 {
 	if (use_task_css_set_links) {
 		write_lock(&css_set_lock);
@@ -4068,6 +4070,8 @@ void cgroup_post_fork(struct task_struct *child)
 		task_unlock(child);
 		write_unlock(&css_set_lock);
 	}
+	if (clone_flags & CLONE_THREAD)
+		up_read(&current->signal->threadgroup_fork_lock);
 }
 /**
  * cgroup_exit - detach cgroup from exiting task
@@ -4143,6 +4147,21 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 }
 
 /**
+ * cgroup_fork_failed - undo operations for fork failure
+ * @tsk: pointer to  task_struct of exiting process
+ * @run_callback: run exit callbacks?
+ *
+ * Wrapper for cgroup_exit that also drops the fork lock.
+ */
+void cgroup_fork_failed(struct task_struct *tsk, int run_callbacks,
+			unsigned long clone_flags)
+{
+	if (clone_flags & CLONE_THREAD)
+		up_read(&current->signal->threadgroup_fork_lock);
+	cgroup_exit(tsk, run_callbacks);
+}
+
+/**
  * cgroup_clone - clone the cgroup the given subsystem is attached to
  * @tsk: the task to be moved
  * @subsys: the given subsystem
diff --git a/kernel/fork.c b/kernel/fork.c
index 4c14942..e2b04ac 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -884,6 +884,10 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 
 	tty_audit_fork(sig);
 
+#ifdef CONFIG_CGROUPS
+	init_rwsem(&sig->threadgroup_fork_lock);
+#endif
+
 	sig->oom_adj = current->signal->oom_adj;
 
 	return 0;
@@ -1069,7 +1073,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	monotonic_to_bootbased(&p->real_start_time);
 	p->io_context = NULL;
 	p->audit_context = NULL;
-	cgroup_fork(p);
+	cgroup_fork(p, clone_flags);
 #ifdef CONFIG_NUMA
 	p->mempolicy = mpol_dup(p->mempolicy);
  	if (IS_ERR(p->mempolicy)) {
@@ -1277,7 +1281,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	spin_unlock(&current->sighand->siglock);
 	write_unlock_irq(&tasklist_lock);
 	proc_fork_connector(p);
-	cgroup_post_fork(p);
+	cgroup_post_fork(p, clone_flags);
 	perf_event_fork(p);
 	return p;
 
@@ -1311,7 +1315,7 @@ bad_fork_cleanup_policy:
 	mpol_put(p->mempolicy);
 bad_fork_cleanup_cgroup:
 #endif
-	cgroup_exit(p, cgroup_callbacks_done);
+	cgroup_fork_failed(p, cgroup_callbacks_done, clone_flags);
 	delayacct_tsk_free(p);
 	module_put(task_thread_info(p)->exec_domain->module);
 bad_fork_cleanup_count:
