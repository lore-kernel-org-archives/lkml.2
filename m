Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0JYD36 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 23:29:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57935 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab0JYD35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 23:29:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [resend][PATCH 4/4] oom: don't ignore rss in nascent mm
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, pageexec@freemail.hu,
        Solar Designer <solar@openwall.com>, Eugene Teo <eteo@redhat.com>,
        Brad Spengler <spender@grsecurity.net>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
In-Reply-To: <20101025122538.9167.A69D9226@jp.fujitsu.com>
References: <20101025122538.9167.A69D9226@jp.fujitsu.com>
Message-Id: <20101025122914.9173.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 25 Oct 2010 12:29:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ChangeLog
 o since v2
   - Move ->in_exec_mm from task_struct to signal_struct
   - clean up oom_rss_swap_usage()
 o since v1
   - Always use thread group leader's ->in_exec_mm.
     It slightly makes efficient oom when a process has many thread.
   - Add the link of Brad's explanation to the description.


-----------------------------------------------------------
Brad Spengler published a local memory-allocation DoS that
evades the OOM-killer (though not the virtual memory RLIMIT):
http://www.grsecurity.net/~spender/64bit_dos.c

Because execve() makes new mm struct and setup stack and
copy argv. It mean the task have two mm while execve() temporary.
Unfortunately this nascent mm is not pointed any tasks, then
OOM-killer can't detect this memory usage. therefore OOM-killer
may kill incorrect task.

Thus, this patch added signal->in_exec_mm member and track
nascent mm usage.

Cc: stable@kernel.org
Cc: pageexec@freemail.hu
Cc: Roland McGrath <roland@redhat.com>
Cc: Solar Designer <solar@openwall.com>
Cc: Eugene Teo <eteo@redhat.com>
Reported-by: Brad Spengler <spender@grsecurity.net>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/compat.c             |    4 +++-
 fs/exec.c               |   16 +++++++++++++++-
 include/linux/binfmts.h |    1 +
 include/linux/sched.h   |    1 +
 mm/oom_kill.c           |   26 +++++++++++++++++++-------
 5 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 0644a15..a85b196 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1567,8 +1567,10 @@ int compat_do_execve(char * filename,
 	return retval;
 
 out:
-	if (bprm->mm)
+	if (bprm->mm) {
+		set_exec_mm(NULL);
 		mmput(bprm->mm);
+	}
 
 out_file:
 	if (bprm->file) {
diff --git a/fs/exec.c b/fs/exec.c
index 94dabd2..2395d10 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -347,6 +347,8 @@ int bprm_mm_init(struct linux_binprm *bprm)
 	if (err)
 		goto err;
 
+	set_exec_mm(mm);
+
 	return 0;
 
 err:
@@ -759,6 +761,7 @@ static int exec_mmap(struct mm_struct *mm)
 	tsk->mm = mm;
 	tsk->active_mm = mm;
 	activate_mm(active_mm, mm);
+	tsk->signal->in_exec_mm = NULL;
 	task_unlock(tsk);
 	arch_pick_mmap_layout(mm);
 	if (old_mm) {
@@ -1328,6 +1331,15 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 
 EXPORT_SYMBOL(search_binary_handler);
 
+void set_exec_mm(struct mm_struct *mm)
+{
+	struct task_struct *leader = current->group_leader;
+
+	task_lock(leader);
+	leader->signal->in_exec_mm = mm;
+	task_unlock(leader);
+}
+
 /*
  * sys_execve() executes a new program.
  */
@@ -1416,8 +1428,10 @@ int do_execve(const char * filename,
 	return retval;
 
 out:
-	if (bprm->mm)
+	if (bprm->mm) {
+		set_exec_mm(NULL);
 		mmput (bprm->mm);
+	}
 
 out_file:
 	if (bprm->file) {
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index a065612..2fde1ba 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -133,6 +133,7 @@ extern void install_exec_creds(struct linux_binprm *bprm);
 extern void do_coredump(long signr, int exit_code, struct pt_regs *regs);
 extern void set_binfmt(struct linux_binfmt *new);
 extern void free_bprm(struct linux_binprm *);
+extern void set_exec_mm(struct mm_struct *mm);
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_BINFMTS_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ac65605..b880931 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -630,6 +630,7 @@ struct signal_struct {
 	struct mutex cred_guard_mutex;	/* guard against foreign influences on
 					 * credential calculations
 					 * (notably. ptrace) */
+	struct mm_struct *in_exec_mm;	/* temporary nascent mm in execve */
 };
 
 /* Context switch must be unlocked if interrupts are to be enabled */
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index d58925e..830065f 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -120,6 +120,15 @@ struct task_struct *find_lock_task_mm(struct task_struct *p)
 	return NULL;
 }
 
+/*
+ * The baseline for the badness score is the proportion of RAM that each
+ * task's rss and swap space use.
+ */
+static unsigned long oom_rss_swap_usage(struct mm_struct *mm)
+{
+	return get_mm_rss(mm) + get_mm_counter(mm, MM_SWAPENTS);
+}
+
 /* return true if the task is not adequate as candidate victim task. */
 static bool oom_unkillable_task(struct task_struct *p,
 		const struct mem_cgroup *mem, const nodemask_t *nodemask)
@@ -151,7 +160,7 @@ static bool oom_unkillable_task(struct task_struct *p,
 unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *mem,
 			  const nodemask_t *nodemask)
 {
-	unsigned long points;
+	unsigned long points = 0;
 	unsigned long points_orig;
 	int oom_adj = p->signal->oom_adj;
 	long oom_score_adj = p->signal->oom_score_adj;
@@ -169,15 +178,18 @@ unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *mem,
 	if (p->flags & PF_OOM_ORIGIN)
 		return ULONG_MAX;
 
+	/* The task is now processing execve(). then it has second mm */
+	if (unlikely(p->signal->in_exec_mm)) {
+		task_lock(p->group_leader);
+		if (p->signal->in_exec_mm)
+			points = oom_rss_swap_usage(p->signal->in_exec_mm);
+		task_unlock(p->group_leader);
+	}
+
 	p = find_lock_task_mm(p);
 	if (!p)
 		return 0;
-
-	/*
-	 * The baseline for the badness score is the proportion of RAM that each
-	 * task's rss and swap space use.
-	 */
-	points = (get_mm_rss(p->mm) + get_mm_counter(p->mm, MM_SWAPENTS));
+	points += oom_rss_swap_usage(p->mm);
 	task_unlock(p);
 
 	/*
-- 
1.6.5.2



