Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab0HKFrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 01:47:52 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.61]:56022 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab0HKFru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 01:47:50 -0400
Date: Wed, 11 Aug 2010 01:47:11 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        akpm@linux-foundation.org, ebiederm@xmission.com, lizf@cn.fujitsu.com,
        matthltc@us.ibm.com, menage@google.com, oleg@redhat.com
Subject: [PATCH v5 1/3] cgroups: read-write lock CLONE_THREAD forking per
 threadgroup
Message-ID: <20100811054711.GB8743@ghc17.ghc.andrew.cmu.edu>
References: <20100730235649.GA22644@ghc17.ghc.andrew.cmu.edu>
 <20100811054604.GA8743@ghc17.ghc.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cgroup-threadgroup-fork-lock.patch"
In-Reply-To: <20100811054604.GA8743@ghc17.ghc.andrew.cmu.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.8.11.53318
X-SMTP-Spam-Clean: 8% (
 FROM_SAME_AS_TO 0.05, BODY_SIZE_4000_4999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __FROM_SAME_AS_TO2 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS , __USER_AGENT 0)
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

This is a pre-patch for cgroup-procs-write.patch.

Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
---
 include/linux/init_task.h |    9 +++++++++
 include/linux/sched.h     |   35 +++++++++++++++++++++++++++++++++++
 kernel/fork.c             |   10 ++++++++++
 3 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 1f43fa5..ca46711 100644
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
 	.nr_threads	= 1,						\
 	.wait_chldexit	= __WAIT_QUEUE_HEAD_INITIALIZER(sig.wait_chldexit),\
@@ -29,6 +37,7 @@ extern struct fs_struct init_fs;
 		.running = 0,						\
 		.lock = __SPIN_LOCK_UNLOCKED(sig.cputimer.lock),	\
 	},								\
+	INIT_THREADGROUP_FORK_LOCK(sig)					\
 }
 
 extern struct nsproxy init_nsproxy;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ae69716..ebd4af2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -619,6 +619,16 @@ struct signal_struct {
 	unsigned audit_tty;
 	struct tty_audit_buf *tty_audit_buf;
 #endif
+#ifdef CONFIG_CGROUPS
+	/*
+	 * The threadgroup_fork_lock prevents threads from forking with
+	 * CLONE_THREAD while held for writing. Use this for fork-sensitive
+	 * threadgroup-wide operations. It's taken for reading in fork.c in
+	 * copy_process().
+	 * Currently only needed write-side by cgroups.
+	 */
+	struct rw_semaphore threadgroup_fork_lock;
+#endif
 
 	int oom_adj;	/* OOM kill score adjustment (bit shift) */
 };
@@ -2216,6 +2226,31 @@ static inline void unlock_task_sighand(struct task_struct *tsk,
 	spin_unlock_irqrestore(&tsk->sighand->siglock, *flags);
 }
 
+/* See the declaration of threadgroup_fork_lock in signal_struct. */
+#ifdef CONFIG_CGROUPS
+static inline void threadgroup_fork_read_lock(struct task_struct *tsk)
+{
+	down_read(&tsk->signal->threadgroup_fork_lock);
+}
+static inline void threadgroup_fork_read_unlock(struct task_struct *tsk)
+{
+	up_read(&tsk->signal->threadgroup_fork_lock);
+}
+static inline void threadgroup_fork_write_lock(struct task_struct *tsk)
+{
+	down_write(&tsk->signal->threadgroup_fork_lock);
+}
+static inline void threadgroup_fork_write_unlock(struct task_struct *tsk)
+{
+	up_write(&tsk->signal->threadgroup_fork_lock);
+}
+#else
+static inline void threadgroup_fork_read_lock(struct task_struct *tsk) {}
+static inline void threadgroup_fork_read_unlock(struct task_struct *tsk) {}
+static inline void threadgroup_fork_write_lock(struct task_struct *tsk) {}
+static inline void threadgroup_fork_write_unlock(struct task_struct *tsk) {}
+#endif
+
 #ifndef __HAVE_THREAD_FUNCTIONS
 
 #define task_thread_info(task)	((struct thread_info *)(task)->stack)
diff --git a/kernel/fork.c b/kernel/fork.c
index a82a65c..41df253 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -898,6 +898,10 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 
 	tty_audit_fork(sig);
 
+#ifdef CONFIG_CGROUPS
+	init_rwsem(&sig->threadgroup_fork_lock);
+#endif
+
 	sig->oom_adj = current->signal->oom_adj;
 
 	return 0;
@@ -1076,6 +1080,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	monotonic_to_bootbased(&p->real_start_time);
 	p->io_context = NULL;
 	p->audit_context = NULL;
+	if (clone_flags & CLONE_THREAD)
+		threadgroup_fork_read_lock(current);
 	cgroup_fork(p);
 #ifdef CONFIG_NUMA
 	p->mempolicy = mpol_dup(p->mempolicy);
@@ -1283,6 +1289,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	write_unlock_irq(&tasklist_lock);
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
+	if (clone_flags & CLONE_THREAD)
+		threadgroup_fork_read_unlock(current);
 	perf_event_fork(p);
 	return p;
 
@@ -1316,6 +1324,8 @@ bad_fork_cleanup_policy:
 	mpol_put(p->mempolicy);
 bad_fork_cleanup_cgroup:
 #endif
+	if (clone_flags & CLONE_THREAD)
+		threadgroup_fork_read_unlock(current);
 	cgroup_exit(p, cgroup_callbacks_done);
 	delayacct_tsk_free(p);
 	module_put(task_thread_info(p)->exec_domain->module);
