Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab0IPF5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 01:57:21 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49775 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab0IPF5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 01:57:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4/4] oom: don't ignore rss in nascent mm
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        linux-fsdevel@vger.kernel.org, pageexec@freemail.hu,
        Brad Spengler <spender@grsecurity.net>, Eugene Teo <eugene@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, David Rientjes <rientjes@google.com>
In-Reply-To: <20100916144930.3BAE.A69D9226@jp.fujitsu.com>
References: <20100916144930.3BAE.A69D9226@jp.fujitsu.com>
Message-Id: <20100916145710.3BBA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 16 Sep 2010 14:57:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ChangeLog
 o since v1
   - Always use thread group leader's ->in_exec_mm.
     It slightly makes efficient oom when a process has many thread.
   - Add the link of Brad's explanation to the description.

Brad Spengler published a local memory-allocation DoS that
evades the OOM-killer (though not the virtual memory RLIMIT):
http://www.grsecurity.net/~spender/64bit_dos.c

Because execve() makes new mm struct and setup stack and
copy argv. It mean the task have two mm while execve() temporary.
Unfortunately this nascent mm is not pointed any tasks, then
OOM-killer can't detect this memory usage. therefore OOM-killer
may kill incorrect task.

Thus, this patch added task->in_exec_mm member and track
nascent mm usage.

Cc: pageexec@freemail.hu
Cc: Roland McGrath <roland@redhat.com>
Cc: Solar Designer <solar@openwall.com>
Cc: Eugene Teo <eteo@redhat.com>
Reported-by: Brad Spengler <spender@grsecurity.net>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/compat.c             |    4 +++-
 fs/exec.c               |   24 +++++++++++++++++++++++-
 include/linux/binfmts.h |    1 +
 include/linux/sched.h   |    1 +
 mm/oom_kill.c           |   45 +++++++++++++++++++++++++++++++++++++--------
 5 files changed, 65 insertions(+), 10 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 718c706..b631120 100644
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
index 160eb46..2a08459 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -347,6 +347,8 @@ int bprm_mm_init(struct linux_binprm *bprm)
 	if (err)
 		goto err;
 
+	set_exec_mm(bprm->mm);
+
 	return 0;
 
 err:
@@ -745,6 +747,7 @@ static int exec_mmap(struct mm_struct *mm)
 	tsk->mm = mm;
 	tsk->active_mm = mm;
 	activate_mm(active_mm, mm);
+	tsk->in_exec_mm = NULL;
 	task_unlock(tsk);
 	arch_pick_mmap_layout(mm);
 	if (old_mm) {
@@ -855,6 +858,9 @@ static int de_thread(struct task_struct *tsk)
 		tsk->group_leader = tsk;
 		leader->group_leader = tsk;
 
+		tsk->in_exec_mm = leader->in_exec_mm;
+		leader->in_exec_mm = NULL;
+
 		tsk->exit_signal = SIGCHLD;
 
 		BUG_ON(leader->exit_state != EXIT_ZOMBIE);
@@ -1314,6 +1320,20 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 
 EXPORT_SYMBOL(search_binary_handler);
 
+void set_exec_mm(struct mm_struct *mm)
+{
+	/*
+	 * Both ->group_leader change in de_thread() and this function
+	 * are protected by ->cred_guard_mutex. Then, we don't need
+	 * additional lock to protect other exec. oom_kill takes both
+	 * tasklist_lock and task_lock. Then, task_lock() provide enough
+	 * protection.
+	 */
+	task_lock(current->group_leader);
+	current->group_leader->in_exec_mm = mm;
+	task_unlock(current->group_leader);
+}
+
 /*
  * sys_execve() executes a new program.
  */
@@ -1402,8 +1422,10 @@ int do_execve(const char * filename,
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
index 960a867..a7e7c2a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1230,6 +1230,7 @@ struct task_struct {
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
 	/* ??? */
 	unsigned int personality;
+	struct mm_struct *in_exec_mm;
 	unsigned did_exec:1;
 	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
 				 * execve */
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index c1beda0..d03ef9c 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -120,6 +120,41 @@ struct task_struct *find_lock_task_mm(struct task_struct *p)
 	return NULL;
 }
 
+/*
+ * The baseline for the badness score is the proportion of RAM that each
+ * task's rss and swap space use.
+ */
+static unsigned long oom_rss_swap_usage(struct task_struct *p)
+{
+	struct task_struct *t = p;
+	struct task_struct *leader = p->group_leader;
+	unsigned long points = 0;
+
+	do {
+		task_lock(t);
+		if (t->mm) {
+			points += get_mm_rss(t->mm);
+			points += get_mm_counter(t->mm, MM_SWAPENTS);
+			task_unlock(t);
+			break;
+		}
+		task_unlock(t);
+	} while_each_thread(p, t);
+
+	/*
+	 * If the process is in execve() processing, we have to concern
+	 * about both old and new mm.
+	 */
+	task_lock(leader);
+	if (leader->in_exec_mm) {
+		points += get_mm_rss(leader->in_exec_mm);
+		points += get_mm_counter(leader->in_exec_mm, MM_SWAPENTS);
+	}
+	task_unlock(leader);
+
+	return points;
+}
+
 /* return true if the task is not adequate as candidate victim task. */
 static bool oom_unkillable_task(struct task_struct *p, struct mem_cgroup *mem,
 			   const nodemask_t *nodemask)
@@ -169,16 +204,10 @@ unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *mem,
 	if (p->flags & PF_OOM_ORIGIN)
 		return ULONG_MAX;
 
-	p = find_lock_task_mm(p);
-	if (!p)
+	points = oom_rss_swap_usage(p);
+	if (!points)
 		return 0;
 
-	/*
-	 * The baseline for the badness score is the proportion of RAM that each
-	 * task's rss and swap space use.
-	 */
-	points = (get_mm_rss(p->mm) + get_mm_counter(p->mm, MM_SWAPENTS));
-	task_unlock(p);
 
 	/*
 	 * Root processes get 3% bonus, just like the __vm_enough_memory()
-- 
1.6.5.2



