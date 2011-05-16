Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab1EPSRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:17:50 -0400
Received: from mail-bw0-f52.google.com ([209.85.214.52]:60031 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab1EPSRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:17:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=dcw7m/Wo6V1peFJlKvsCFuOmsr2zwPfpsY8RLZkX/CmdG0Uu0bD10THGR3MSHXJ98Y
         sMETlilo1LUU8T8MdpdOGbmL7U03yQxEoDLLA74N38cEK+39TKyJIhhs81mYncB/g8yZ
         CVnrAOdGAvG0cRGXBcUoX4a0Xv+WttByc/BXg=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/10] ptrace: add JOBCTL_BLOCK_NOTIFY
Date: Mon, 16 May 2011 20:17:28 +0200
Message-Id: <1305569849-10448-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1305569849-10448-1-git-send-email-tj@kernel.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For to-be-added notification retraps, other tasks need to be able to
tell whether ptrace request is currently in progress while tracee is
in STOP trap.  This patch adds JOBCTL_BLOCK_NOTIFY which is set on
ptrace_check_attach() if the request requires tracee to be trapped and
it's trapped for STOP, and cleared when ptrace syscall finishes.

This flag isn't used yet.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/ptrace.h |    2 +
 include/linux/sched.h  |    1 +
 kernel/ptrace.c        |   51 ++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 72b9150..b0c1347 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -73,6 +73,8 @@
 #define PTRACE_EVENT_EXIT	6
 #define PTRACE_EVENT_STOP	7
 
+#define PTRACE_STOP_SI_CODE	(__SI_TRAP | SIGTRAP | PTRACE_EVENT_STOP << 8)
+
 /* flags in siginfo.si_pt_flags from PTRACE_GETSIGINFO */
 #define PTRACE_SI_STOPPED	0x00000001 /* tracee is job control stopped */
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d8a11cb..1f082d9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1786,6 +1786,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define JOBCTL_STOP_CONSUME	(1 << 18) /* consume group stop count */
 #define JOBCTL_TRAP_STOP	(1 << 19) /* trap for STOP */
 #define JOBCTL_TRAPPING		(1 << 21) /* switching to TRACED */
+#define JOBCTL_BLOCK_NOTIFY	(1 << 22) /* block NOTIFY re-traps */
 
 #define JOBCTL_TRAP_MASK	JOBCTL_TRAP_STOP
 #define JOBCTL_PENDING_MASK	(JOBCTL_STOP_PENDING | JOBCTL_TRAP_MASK)
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index c12daec..d382f81 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -189,10 +189,24 @@ int ptrace_check_attach(struct task_struct *child, bool ignore_state)
 		 */
 		spin_lock_irq(&child->sighand->siglock);
 		WARN_ON_ONCE(task_is_stopped(child));
-		if (task_is_traced(child) || ignore_state)
+
+		if (ignore_state) {
+			ret = 0;
+		} else if (task_is_traced(child)) {
+			siginfo_t *si = child->last_siginfo;
+
+			/*
+			 * If STOP trapped, ptrace notification may cause
+			 * re-traps, which we don't want while ptrace
+			 * request is in progress.  Block notification.
+			 */
+			if (si && si->si_code == PTRACE_STOP_SI_CODE)
+				child->jobctl |= JOBCTL_BLOCK_NOTIFY;
 			ret = 0;
-		else if (ptrace_wait_trapping(child))
+		} else if (ptrace_wait_trapping(child)) {
 			return restart_syscall();
+		}
+
 		spin_unlock_irq(&child->sighand->siglock);
 	}
 	read_unlock(&tasklist_lock);
@@ -889,6 +903,35 @@ static struct task_struct *ptrace_get_task_struct(pid_t pid)
 #define arch_ptrace_attach(child)	do { } while (0)
 #endif
 
+/**
+ * ptrace_put_task_struct - ptrace request processing done, put child
+ * @child: child task struct to put
+ *
+ * ptrace request processing for @child is finished.  Clean up and put
+ * @child.  This function clears %JOBCTL_BLOCK_NOTIFY which can be set by
+ * ptrace_check_attach().
+ */
+static void ptrace_put_task_struct(struct task_struct *child)
+{
+	unsigned long flags;
+
+	if (!(child->jobctl & JOBCTL_BLOCK_NOTIFY))
+		goto out_put;
+
+	if (unlikely(!lock_task_sighand(child, &flags)))
+		goto out_put;
+
+	/*
+	 * Make sure @chlid is still ptraced by us and clear BLOCK_NOTIFY.
+	 */
+	if (likely((child->ptrace & PT_PTRACED) && child->parent == current))
+		child->jobctl &= ~JOBCTL_BLOCK_NOTIFY;
+
+	unlock_task_sighand(child, &flags);
+out_put:
+	put_task_struct(child);
+}
+
 SYSCALL_DEFINE4(ptrace, long, request, long, pid, unsigned long, addr,
 		unsigned long, data)
 {
@@ -927,7 +970,7 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, unsigned long, addr,
 	ret = arch_ptrace(child, request, addr, data);
 
  out_put_task_struct:
-	put_task_struct(child);
+	ptrace_put_task_struct(child);
  out:
 	return ret;
 }
@@ -1068,7 +1111,7 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 		ret = compat_arch_ptrace(child, request, addr, data);
 
  out_put_task_struct:
-	put_task_struct(child);
+	ptrace_put_task_struct(child);
  out:
 	return ret;
 }
-- 
1.7.1

