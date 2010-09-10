Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab0IJJ5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 05:57:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49154 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab0IJJ52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 05:57:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] move cred_guard_mutex from task_struct to signal_struct
Cc: kosaki.motohiro@jp.fujitsu.com, Roland McGrath <roland@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Neil Horman <nhorman@tuxdriver.com>, linux-fsdevel@vger.kernel.org,
        pageexec@freemail.hu,
        "Brad Spengler <spender@grsecurity.net>, Eugene Teo" 
	<eugene@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100909220504.GA6273@redhat.com>
References: <20100909140219.C942.A69D9226@jp.fujitsu.com> <20100909220504.GA6273@redhat.com>
Message-Id: <20100910101528.C958.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 10 Sep 2010 18:57:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 09/09, KOSAKI Motohiro wrote:
> >
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -1226,6 +1226,7 @@ struct task_struct {
> >  	int pdeath_signal;  /*  The signal sent when the parent dies  */
> >  	/* ??? */
> >  	unsigned int personality;
> > +	struct mm_struct *in_exec_mm;
> 
> Oh, yes, this has to be per-thread (unlike ->mm, btw).
> 
> I wonder if it makes sense to move ->cred_guard_mutex from task_struct
> to signal_struct and thus make multiple-threads-inside-exec impossible.
> Only one thread can win anyway.

Interesting idea, really.
I've thought

1) moving cread_guard_mutex itself
   - no increase execve overhead
	-> very good
   - it also prevent parallel ptrace
	-> probably no problem. nobody want parallel debugging
2) move in_exec_mm to signal_struct too
   -> very hard. oom-killer can use very few lock because it's called
      from various place. now both ->mm and ->in_exec_mm are protected
      task_lock() and it help to avoid messy.


So, I've done only (1). I think this restriction effectivly prevent 
some theorical execve() resouce smashing attack.


======================================================================
Subject: [PATCH] move cred_guard_mutex from task_struct to signal_struct

Oleg Nesterov pointed out we have to prevent multiple-threads-inside-exec
itself and we can reuse ->cred_guard_mutex for it. Yes, concurrent execve()
has no worth.

Let's move ->cred_guard_mutex from task_struct to signal_struct. It
naturally prevent multiple-threads-inside-exec.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/exec.c                 |    8 ++++----
 fs/proc/base.c            |    8 ++++----
 include/linux/init_task.h |    4 ++--
 include/linux/sched.h     |    7 ++++---
 kernel/cred.c             |    2 --
 kernel/fork.c             |    2 ++
 kernel/ptrace.c           |    4 ++--
 7 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 81d0d06..052ed54 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1091,14 +1091,14 @@ EXPORT_SYMBOL(setup_new_exec);
  */
 int prepare_bprm_creds(struct linux_binprm *bprm)
 {
-	if (mutex_lock_interruptible(&current->cred_guard_mutex))
+	if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
 		return -ERESTARTNOINTR;
 
 	bprm->cred = prepare_exec_creds();
 	if (likely(bprm->cred))
 		return 0;
 
-	mutex_unlock(&current->cred_guard_mutex);
+	mutex_unlock(&current->signal->cred_guard_mutex);
 	return -ENOMEM;
 }
 
@@ -1106,7 +1106,7 @@ void free_bprm(struct linux_binprm *bprm)
 {
 	free_arg_pages(bprm);
 	if (bprm->cred) {
-		mutex_unlock(&current->cred_guard_mutex);
+		mutex_unlock(&current->signal->cred_guard_mutex);
 		abort_creds(bprm->cred);
 	}
 	kfree(bprm);
@@ -1127,7 +1127,7 @@ void install_exec_creds(struct linux_binprm *bprm)
 	 * credentials; any time after this it may be unlocked.
 	 */
 	security_bprm_committed_creds(bprm);
-	mutex_unlock(&current->cred_guard_mutex);
+	mutex_unlock(&current->signal->cred_guard_mutex);
 }
 EXPORT_SYMBOL(install_exec_creds);
 
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 55a16f2..fd97c8f 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -226,7 +226,7 @@ struct mm_struct *mm_for_maps(struct task_struct *task)
 {
 	struct mm_struct *mm;
 
-	if (mutex_lock_killable(&task->cred_guard_mutex))
+	if (mutex_lock_killable(&task->signal->cred_guard_mutex))
 		return NULL;
 
 	mm = get_task_mm(task);
@@ -235,7 +235,7 @@ struct mm_struct *mm_for_maps(struct task_struct *task)
 		mmput(mm);
 		mm = NULL;
 	}
-	mutex_unlock(&task->cred_guard_mutex);
+	mutex_unlock(&task->signal->cred_guard_mutex);
 
 	return mm;
 }
@@ -2273,14 +2273,14 @@ static ssize_t proc_pid_attr_write(struct file * file, const char __user * buf,
 		goto out_free;
 
 	/* Guard against adverse ptrace interaction */
-	length = mutex_lock_interruptible(&task->cred_guard_mutex);
+	length = mutex_lock_interruptible(&task->signal->cred_guard_mutex);
 	if (length < 0)
 		goto out_free;
 
 	length = security_setprocattr(task,
 				      (char*)file->f_path.dentry->d_name.name,
 				      (void*)page, count);
-	mutex_unlock(&task->cred_guard_mutex);
+	mutex_unlock(&task->signal->cred_guard_mutex);
 out_free:
 	free_page((unsigned long) page);
 out:
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 1f43fa5..ff3cc33 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -29,6 +29,8 @@ extern struct fs_struct init_fs;
 		.running = 0,						\
 		.lock = __SPIN_LOCK_UNLOCKED(sig.cputimer.lock),	\
 	},								\
+	.cred_guard_mutex =						\
+		 __MUTEX_INITIALIZER(sig.cred_guard_mutex),		\
 }
 
 extern struct nsproxy init_nsproxy;
@@ -139,8 +141,6 @@ extern struct cred init_cred;
 	.group_leader	= &tsk,						\
 	.real_cred	= &init_cred,					\
 	.cred		= &init_cred,					\
-	.cred_guard_mutex =						\
-		 __MUTEX_INITIALIZER(tsk.cred_guard_mutex),		\
 	.comm		= "swapper",					\
 	.thread		= INIT_THREAD,					\
 	.fs		= &init_fs,					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index bb5bf3d..a7e7c2a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -623,6 +623,10 @@ struct signal_struct {
 
 	int oom_adj;		/* OOM kill score adjustment (bit shift) */
 	long oom_score_adj;	/* OOM kill score adjustment */
+
+	struct mutex cred_guard_mutex;	/* guard against foreign influences on
+					 * credential calculations
+					 * (notably. ptrace) */
 };
 
 /* Context switch must be unlocked if interrupts are to be enabled */
@@ -1293,9 +1297,6 @@ struct task_struct {
 					 * credentials (COW) */
 	const struct cred *cred;	/* effective (overridable) subjective task
 					 * credentials (COW) */
-	struct mutex cred_guard_mutex;	/* guard against foreign influences on
-					 * credential calculations
-					 * (notably. ptrace) */
 	struct cred *replacement_session_keyring; /* for KEYCTL_SESSION_TO_PARENT */
 
 	char comm[TASK_COMM_LEN]; /* executable name excluding path
diff --git a/kernel/cred.c b/kernel/cred.c
index 9a3e226..a81833d 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -384,8 +384,6 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 	struct cred *new;
 	int ret;
 
-	mutex_init(&p->cred_guard_mutex);
-
 	if (
 #ifdef CONFIG_KEYS
 		!p->cred->thread_keyring &&
diff --git a/kernel/fork.c b/kernel/fork.c
index b7e9d60..4c0d3ea 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -904,6 +904,8 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->oom_adj = current->signal->oom_adj;
 	sig->oom_score_adj = current->signal->oom_score_adj;
 
+	mutex_init(&sig->cred_guard_mutex);
+
 	return 0;
 }
 
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index f34d798..ac5013a 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -181,7 +181,7 @@ int ptrace_attach(struct task_struct *task)
 	 * under ptrace.
 	 */
 	retval = -ERESTARTNOINTR;
-	if (mutex_lock_interruptible(&task->cred_guard_mutex))
+	if (mutex_lock_interruptible(&task->signal->cred_guard_mutex))
 		goto out;
 
 	task_lock(task);
@@ -208,7 +208,7 @@ int ptrace_attach(struct task_struct *task)
 unlock_tasklist:
 	write_unlock_irq(&tasklist_lock);
 unlock_creds:
-	mutex_unlock(&task->cred_guard_mutex);
+	mutex_unlock(&task->signal->cred_guard_mutex);
 out:
 	return retval;
 }
-- 
1.6.5.2



