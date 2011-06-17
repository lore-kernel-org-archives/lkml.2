Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339Ab1FQOwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:52:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43064 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759316Ab1FQOuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:50:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=S3DRHRq7U2EBkHHcTz/E06tZSVF0UOMLEoeBU45M029bmcbI9bCSMBmkjCb1mAMJM5
         yMLuzZ5Wf+++Fi14TEz5g9PIgB69NsWh8+52UrpSeytLkTkjnsyGOyeJTCBkJmHkQi6N
         NDlcFXMKmZFO4v70qHLubCMtXoN4br622LQQI=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, oleg@redhat.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        hch@infradead.org, Tejun Heo <tj@kernel.org>,
        John Johansen <john.johansen@canonical.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH 7/7] ptrace: s/tracehook_tracer_task()/ptrace_parent()/
Date: Fri, 17 Jun 2011 16:50:40 +0200
Message-Id: <1308322240-8247-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308322240-8247-1-git-send-email-tj@kernel.org>
References: <1308322240-8247-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tracehook.h is on the way out.  Rename tracehook_tracer_task() to
ptrace_parent() and move it from tracehook.h to ptrace.h.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: John Johansen <john.johansen@canonical.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
---
 fs/proc/array.c            |    2 +-
 fs/proc/base.c             |    2 +-
 include/linux/ptrace.h     |   18 ++++++++++++++++++
 include/linux/tracehook.h  |   18 ------------------
 security/apparmor/domain.c |    2 +-
 security/selinux/hooks.c   |    4 ++--
 6 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 9b45ee8..3a1dafd 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -172,7 +172,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		task_tgid_nr_ns(rcu_dereference(p->real_parent), ns) : 0;
 	tpid = 0;
 	if (pid_alive(p)) {
-		struct task_struct *tracer = tracehook_tracer_task(p);
+		struct task_struct *tracer = ptrace_parent(p);
 		if (tracer)
 			tpid = task_pid_nr_ns(tracer, ns);
 	}
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 14def99..c883dad 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -216,7 +216,7 @@ static struct mm_struct *__check_mem_permission(struct task_struct *task)
 	if (task_is_stopped_or_traced(task)) {
 		int match;
 		rcu_read_lock();
-		match = (tracehook_tracer_task(task) == current);
+		match = (ptrace_parent(task) == current);
 		rcu_read_unlock();
 		if (match && ptrace_may_access(task, PTRACE_MODE_ATTACH))
 			return mm;
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index b546fd6..bb157bd 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -151,6 +151,24 @@ int generic_ptrace_pokedata(struct task_struct *tsk, unsigned long addr,
 			    unsigned long data);
 
 /**
+ * ptrace_parent - return the task that is tracing the given task
+ * @task: task to consider
+ *
+ * Returns %NULL if no one is tracing @task, or the &struct task_struct
+ * pointer to its tracer.
+ *
+ * Must called under rcu_read_lock().  The pointer returned might be kept
+ * live only by RCU.  During exec, this may be called with task_lock() held
+ * on @task, still held from when check_unsafe_exec() was called.
+ */
+static inline struct task_struct *ptrace_parent(struct task_struct *task)
+{
+	if (unlikely(task->ptrace))
+		return rcu_dereference(task->parent);
+	return NULL;
+}
+
+/**
  * ptrace_event_enabled - test whether a ptrace event is enabled
  * @task: ptracee of interest
  * @event: %PTRACE_EVENT_* to test
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index fea0d4b..a71a292 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -130,24 +130,6 @@ static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
 }
 
 /**
- * tracehook_tracer_task - return the task that is tracing the given task
- * @tsk:		task to consider
- *
- * Returns NULL if no one is tracing @task, or the &struct task_struct
- * pointer to its tracer.
- *
- * Must called under rcu_read_lock().  The pointer returned might be kept
- * live only by RCU.  During exec, this may be called with task_lock()
- * held on @task, still held from when tracehook_unsafe_exec() was called.
- */
-static inline struct task_struct *tracehook_tracer_task(struct task_struct *tsk)
-{
-	if (tsk->ptrace & PT_PTRACED)
-		return rcu_dereference(tsk->parent);
-	return NULL;
-}
-
-/**
  * tracehook_signal_handler - signal handler setup is complete
  * @sig:		number of signal being delivered
  * @info:		siginfo_t of signal being delivered
diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index c825c6e..7312bf9 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -67,7 +67,7 @@ static int may_change_ptraced_domain(struct task_struct *task,
 	int error = 0;
 
 	rcu_read_lock();
-	tracer = tracehook_tracer_task(task);
+	tracer = ptrace_parent(task);
 	if (tracer) {
 		/* released below */
 		cred = get_task_cred(tracer);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index a0d3845..fc07d18 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2048,7 +2048,7 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
 			u32 ptsid = 0;
 
 			rcu_read_lock();
-			tracer = tracehook_tracer_task(current);
+			tracer = ptrace_parent(current);
 			if (likely(tracer != NULL)) {
 				sec = __task_cred(tracer)->security;
 				ptsid = sec->sid;
@@ -5314,7 +5314,7 @@ static int selinux_setprocattr(struct task_struct *p,
 		   Otherwise, leave SID unchanged and fail. */
 		ptsid = 0;
 		task_lock(p);
-		tracer = tracehook_tracer_task(p);
+		tracer = ptrace_parent(p);
 		if (tracer)
 			ptsid = task_sid(tracer);
 		task_unlock(p);
-- 
1.7.5.4

