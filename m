Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab2FLB3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 21:29:09 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:45147 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab2FLB3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 21:29:05 -0400
From: Filipe Brandenburger <filbranden@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, Filipe Brandenburger <filbranden@gmail.com>
Subject: [PATCHv2 1/1] prctl: move pdeath_signal from task_struct to signal_struct
Date: Mon, 11 Jun 2012 21:28:19 -0400
Message-Id: <1339464499-10270-2-git-send-email-filbranden@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1339464499-10270-1-git-send-email-filbranden@gmail.com>
References: <1339464499-10270-1-git-send-email-filbranden@gmail.com>
In-Reply-To: <1338332348-3469-1-git-send-email-filbranden@gmail.com>
References: <1338332348-3469-1-git-send-email-filbranden@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some cases involving multi-threaded processes where pdeath_signal
(which can be set using prctl(PR_SET_PDEATHSIG, signo)) doesn't act correctly
in respect of processes vs. threads. In particular:

1) If a child process is forked from a thread of the parent process and the
child process uses prctl(PR_SET_PDEATHSIG, signo) to set pdeath_signal, then
it will receive a signal when the thread that forked it terminates instead
of the parent process itself.

2) When setting prctl(PR_SET_PDEATHSIG, signo) from a thread of the child
process, if the thread terminates before the parent process then pdeath_signal
will be cancelled as it was associated with that task only.

3) When setting prctl(PR_SET_PDEATHSIG, signo) from a thread of a process and
then querying it with prctl(PR_GET_PDEATHSIG, &signo) from another thread it
will return 0 as no pdeath_signal is not set for that task.

Documentation clearly states that PR_SET_PDEATHSIG and PR_GET_PDEATHSIG should
act on processes, in particular case #1 is very counter intuitive because the
child process should not care whether the parent is multi-threaded or not.

This patch moves pdeath_signal from task_struct to signal_struct in order to
make it effectively per-process even on multi-threaded processes.

Signed-off-by: Filipe Brandenburger <filbranden@gmail.com>
---
 fs/exec.c                  |    2 +-
 include/linux/sched.h      |    7 ++++++-
 kernel/cred.c              |    2 +-
 kernel/exit.c              |    8 +++++---
 kernel/fork.c              |    1 -
 kernel/sys.c               |    5 +++--
 security/apparmor/domain.c |    2 +-
 security/selinux/hooks.c   |    2 +-
 security/smack/smack_lsm.c |    2 +-
 9 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index a79786a..67ce5ee 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1151,7 +1151,7 @@ void setup_new_exec(struct linux_binprm * bprm)
 	/* install the new credentials */
 	if (!uid_eq(bprm->cred->uid, current_euid()) ||
 	    !gid_eq(bprm->cred->gid, current_egid())) {
-		current->pdeath_signal = 0;
+		current->signal->pdeath_signal = 0;
 	} else {
 		would_dump(bprm, bprm->file);
 		if (bprm->interp_flags & BINPRM_FLAGS_ENFORCE_NONDUMP)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f34437e..de22765 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -554,6 +554,12 @@ struct signal_struct {
 	unsigned int		flags; /* see SIGNAL_* flags below */
 
 	/*
+	 * Support for PR_SET_PDEATHSIG.
+	 * If non-zero, it contains the signal sent when the parent dies.
+	 */
+	int pdeath_signal;
+
+	/*
 	 * PR_SET_CHILD_SUBREAPER marks a process, like a service
 	 * manager, to re-parent orphan (double-forking) child processes
 	 * to this process instead of 'init'. The service manager is
@@ -1285,7 +1291,6 @@ struct task_struct {
 /* task state */
 	int exit_state;
 	int exit_code, exit_signal;
-	int pdeath_signal;  /*  The signal sent when the parent dies  */
 	unsigned int jobctl;	/* JOBCTL_*, siglock protected */
 	/* ??? */
 	unsigned int personality;
diff --git a/kernel/cred.c b/kernel/cred.c
index de728ac..128f46e 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -496,7 +496,7 @@ int commit_creds(struct cred *new)
 	    !cap_issubset(new->cap_permitted, old->cap_permitted)) {
 		if (task->mm)
 			set_dumpable(task->mm, suid_dumpable);
-		task->pdeath_signal = 0;
+		task->signal->pdeath_signal = 0;
 		smp_wmb();
 	}
 
diff --git a/kernel/exit.c b/kernel/exit.c
index 34867cc..bcb471e 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -770,6 +770,11 @@ static void reparent_leader(struct task_struct *father, struct task_struct *p,
 	if (same_thread_group(p->real_parent, father))
 		return;
 
+	/* Check if prctl(PR_SET_PDEATHSIG, ...) was set for this process. */
+	if (p->signal->pdeath_signal)
+		group_send_sig_info(p->signal->pdeath_signal,
+				    SEND_SIG_NOINFO, p);
+
 	/* We don't want people slaying init.  */
 	p->exit_signal = SIGCHLD;
 
@@ -806,9 +811,6 @@ static void forget_original_parent(struct task_struct *father)
 				BUG_ON(t->ptrace);
 				t->parent = t->real_parent;
 			}
-			if (t->pdeath_signal)
-				group_send_sig_info(t->pdeath_signal,
-						    SEND_SIG_NOINFO, t);
 		} while_each_thread(p, t);
 		reparent_leader(father, p, &dead_children);
 	}
diff --git a/kernel/fork.c b/kernel/fork.c
index ab5211b..4c9f9b8 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1402,7 +1402,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	else
 		p->exit_signal = (clone_flags & CSIGNAL);
 
-	p->pdeath_signal = 0;
 	p->exit_state = 0;
 
 	p->nr_dirtied = 0;
diff --git a/kernel/sys.c b/kernel/sys.c
index 9ff89cb..fd9ee49 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2007,11 +2007,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 				error = -EINVAL;
 				break;
 			}
-			me->pdeath_signal = arg2;
+			me->signal->pdeath_signal = arg2;
 			error = 0;
 			break;
 		case PR_GET_PDEATHSIG:
-			error = put_user(me->pdeath_signal, (int __user *)arg2);
+			error = put_user(me->signal->pdeath_signal,
+					 (int __user *)arg2);
 			break;
 		case PR_GET_DUMPABLE:
 			error = get_dumpable(me->mm);
diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index b81ea10..0eac0d7 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -564,7 +564,7 @@ void apparmor_bprm_committing_creds(struct linux_binprm *bprm)
 	    (unconfined(new_cxt->profile)))
 		return;
 
-	current->pdeath_signal = 0;
+	current->signal->pdeath_signal = 0;
 
 	/* reset soft limits and set hard limits for the new profile */
 	__aa_transition_rlimits(profile, new_cxt->profile);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 372ec65..e839600 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2195,7 +2195,7 @@ static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
 	flush_unauthorized_files(bprm->cred, current->files);
 
 	/* Always clear parent death signal on SID transitions. */
-	current->pdeath_signal = 0;
+	current->signal->pdeath_signal = 0;
 
 	/* Check whether the new SID can inherit resource limits from the old
 	 * SID.  If not, reset all soft limits to the lower of the current
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index ee0bb57..3c85790 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -496,7 +496,7 @@ static void smack_bprm_committing_creds(struct linux_binprm *bprm)
 	struct task_smack *bsp = bprm->cred->security;
 
 	if (bsp->smk_task != bsp->smk_forked)
-		current->pdeath_signal = 0;
+		current->signal->pdeath_signal = 0;
 }
 
 /**
-- 
1.7.7.6

