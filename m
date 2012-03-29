Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab2C2Jzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:55:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34263 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758875Ab2C2Jzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:55:43 -0400
Date: Thu, 29 Mar 2012 02:55:12 -0700
From: tip-bot for Kees Cook <keescook@chromium.org>
Message-ID: <tip-bdbb776f882f5ad431aa1e694c69c1c3d6a4a5b8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        serge.hallyn@canonical.com, a.p.zijlstra@chello.nl,
        dvhart@linux.intel.com, jkosina@suse.cz, ebiederm@xmission.com,
        keescook@chromium.org, dhowells@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        serge.hallyn@canonical.com, dvhart@linux.intel.com,
        a.p.zijlstra@chello.nl, jkosina@suse.cz, ebiederm@xmission.com,
        dhowells@redhat.com, keescook@chromium.org, tglx@linutronix.de
In-Reply-To: <20120319231253.GA20893@www.outflux.net>
References: <20120319231253.GA20893@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] futex:
  Do not leak robust list to unprivileged process
Git-Commit-ID: bdbb776f882f5ad431aa1e694c69c1c3d6a4a5b8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 29 Mar 2012 02:55:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bdbb776f882f5ad431aa1e694c69c1c3d6a4a5b8
Gitweb:     http://git.kernel.org/tip/bdbb776f882f5ad431aa1e694c69c1c3d6a4a5b8
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Mon, 19 Mar 2012 16:12:53 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 29 Mar 2012 11:37:17 +0200

futex: Do not leak robust list to unprivileged process

It was possible to extract the robust list head address from a setuid
process if it had used set_robust_list(), allowing an ASLR info leak. This
changes the permission checks to be the same as those used for similar
info that comes out of /proc.

Running a setuid program that uses robust futexes would have had:
  cred->euid != pcred->euid
  cred->euid == pcred->uid
so the old permissions check would allow it. I'm not aware of any setuid
programs that use robust futexes, so this is just a preventative measure.

(This patch is based on changes from grsecurity.)

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: kernel-hardening@lists.openwall.com
Cc: spender@grsecurity.net
Link: http://lkml.kernel.org/r/20120319231253.GA20893@www.outflux.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c        |   36 +++++++++++++-----------------------
 kernel/futex_compat.c |   36 +++++++++++++-----------------------
 2 files changed, 26 insertions(+), 46 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 72efa1e..d701be5 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -59,6 +59,7 @@
 #include <linux/magic.h>
 #include <linux/pid.h>
 #include <linux/nsproxy.h>
+#include <linux/ptrace.h>
 
 #include <asm/futex.h>
 
@@ -2443,40 +2444,29 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
 {
 	struct robust_list_head __user *head;
 	unsigned long ret;
-	const struct cred *cred = current_cred(), *pcred;
+	struct task_struct *p;
 
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
 
+	rcu_read_lock();
+
+	ret = -ESRCH;
 	if (!pid)
-		head = current->robust_list;
+		p = current;
 	else {
-		struct task_struct *p;
-
-		ret = -ESRCH;
-		rcu_read_lock();
 		p = find_task_by_vpid(pid);
 		if (!p)
 			goto err_unlock;
-		ret = -EPERM;
-		pcred = __task_cred(p);
-		/* If victim is in different user_ns, then uids are not
-		   comparable, so we must have CAP_SYS_PTRACE */
-		if (cred->user->user_ns != pcred->user->user_ns) {
-			if (!ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
-				goto err_unlock;
-			goto ok;
-		}
-		/* If victim is in same user_ns, then uids are comparable */
-		if (cred->euid != pcred->euid &&
-		    cred->euid != pcred->uid &&
-		    !ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
-			goto err_unlock;
-ok:
-		head = p->robust_list;
-		rcu_read_unlock();
 	}
 
+	ret = -EPERM;
+	if (!ptrace_may_access(p, PTRACE_MODE_READ))
+		goto err_unlock;
+
+	head = p->robust_list;
+	rcu_read_unlock();
+
 	if (put_user(sizeof(*head), len_ptr))
 		return -EFAULT;
 	return put_user(head, head_ptr);
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 5f9e689..a9642d5 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -10,6 +10,7 @@
 #include <linux/compat.h>
 #include <linux/nsproxy.h>
 #include <linux/futex.h>
+#include <linux/ptrace.h>
 
 #include <asm/uaccess.h>
 
@@ -136,40 +137,29 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 {
 	struct compat_robust_list_head __user *head;
 	unsigned long ret;
-	const struct cred *cred = current_cred(), *pcred;
+	struct task_struct *p;
 
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
 
+	rcu_read_lock();
+
+	ret = -ESRCH;
 	if (!pid)
-		head = current->compat_robust_list;
+		p = current;
 	else {
-		struct task_struct *p;
-
-		ret = -ESRCH;
-		rcu_read_lock();
 		p = find_task_by_vpid(pid);
 		if (!p)
 			goto err_unlock;
-		ret = -EPERM;
-		pcred = __task_cred(p);
-		/* If victim is in different user_ns, then uids are not
-		   comparable, so we must have CAP_SYS_PTRACE */
-		if (cred->user->user_ns != pcred->user->user_ns) {
-			if (!ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
-				goto err_unlock;
-			goto ok;
-		}
-		/* If victim is in same user_ns, then uids are comparable */
-		if (cred->euid != pcred->euid &&
-		    cred->euid != pcred->uid &&
-		    !ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
-			goto err_unlock;
-ok:
-		head = p->compat_robust_list;
-		rcu_read_unlock();
 	}
 
+	ret = -EPERM;
+	if (!ptrace_may_access(p, PTRACE_MODE_READ))
+		goto err_unlock;
+
+	head = p->compat_robust_list;
+	rcu_read_unlock();
+
 	if (put_user(sizeof(*head), len_ptr))
 		return -EFAULT;
 	return put_user(ptr_to_compat(head), head_ptr);
