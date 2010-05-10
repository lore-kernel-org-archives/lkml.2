Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab0EJSCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 14:02:35 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:37100 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755959Ab0EJSBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 14:01:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: adobriyan@gmail.com, nhorman@tuxdriver.com, oleg@redhat.com,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH v3 10/11] rlimits: implement prlimit64 syscall
Date: Mon, 10 May 2010 20:00:50 +0200
Message-Id: <1273514451-28894-10-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273514451-28894-1-git-send-email-jslaby@suse.cz>
References: <1273514451-28894-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the code to support the sys_prlimit64 syscall which
modifies-and-returns the rlim values of a selected process
atomically. The first parameter, pid, being 0 means current process.

Unlike the current implementation, it is a generic interface,
architecture indepentent so that we needn't handle compat stuff
anymore. In the future, after glibc start to use this we can deprecate
sys_setrlimit and sys_getrlimit in favor to clean up the code finally.

It also adds a possibility of changing limits of other processes. We
check the user's permissions to do that and if it succeeds, the new
limits are propagated online. This is good for large scale
applications such as SAP or databases where administrators need to
change limits time by time (e.g. on crashes increase core size). And
it is unacceptable to restart the service.

For safety, all rlim users now either use accessors or doesn't need
them due to
- locking
- the fact a process was just forked and nobody else knows about it
  yet (and nobody can't thus read/write limits)
hence it is safe to modify limits now.

The limitation is that we currently stay at ulong internal
representation. So we use the rlim64_is_infinity check where we
compare to ULONG_MAX on 32-bit which is the maximum value there.

And since internally we hold limits in struct rlimit, we introduce
converters used before and after do_prlimit call in sys_prlimit64.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/syscalls.h |    4 ++
 kernel/sys.c             |   99 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 103 insertions(+), 0 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index f93a5c4..3f0e3ab 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -35,6 +35,7 @@ struct oldold_utsname;
 struct old_utsname;
 struct pollfd;
 struct rlimit;
+struct rlimit64;
 struct rusage;
 struct sched_param;
 struct sel_arg_struct;
@@ -667,6 +668,9 @@ asmlinkage long sys_old_getrlimit(unsigned int resource, struct rlimit __user *r
 #endif
 asmlinkage long sys_setrlimit(unsigned int resource,
 				struct rlimit __user *rlim);
+asmlinkage long sys_prlimit64(pid_t pid, unsigned int resource,
+				const struct rlimit64 __user *new_rlim,
+				struct rlimit64 __user *old_rlim);
 asmlinkage long sys_getrusage(int who, struct rusage __user *ru);
 asmlinkage long sys_umask(int mask);
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 0f8034f..d7fcd4a 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1271,6 +1271,39 @@ SYSCALL_DEFINE2(old_getrlimit, unsigned int, resource,
 
 #endif
 
+static inline bool rlim64_is_infinity(__u64 rlim64)
+{
+#if BITS_PER_LONG < 64
+	return rlim64 >= ULONG_MAX;
+#else
+	return rlim64 == RLIM64_INFINITY;
+#endif
+}
+
+static void rlim_to_rlim64(const struct rlimit *rlim, struct rlimit64 *rlim64)
+{
+	if (rlim->rlim_cur == RLIM_INFINITY)
+		rlim64->rlim_cur = RLIM64_INFINITY;
+	else
+		rlim64->rlim_cur = rlim->rlim_cur;
+	if (rlim->rlim_max == RLIM_INFINITY)
+		rlim64->rlim_max = RLIM64_INFINITY;
+	else
+		rlim64->rlim_max = rlim->rlim_max;
+}
+
+static void rlim64_to_rlim(const struct rlimit64 *rlim64, struct rlimit *rlim)
+{
+	if (rlim64_is_infinity(rlim64->rlim_cur))
+		rlim->rlim_cur = RLIM_INFINITY;
+	else
+		rlim->rlim_cur = (unsigned long)rlim64->rlim_cur;
+	if (rlim64_is_infinity(rlim64->rlim_max))
+		rlim->rlim_max = RLIM_INFINITY;
+	else
+		rlim->rlim_max = (unsigned long)rlim64->rlim_max;
+}
+
 /* make sure you are allowed to change @tsk limits before calling this */
 int do_prlimit(struct task_struct *tsk, unsigned int resource,
 		struct rlimit *new_rlim, struct rlimit *old_rlim)
@@ -1340,6 +1373,72 @@ out:
 	return retval;
 }
 
+/* rcu lock must be held */
+static int check_prlimit_permission(struct task_struct *task)
+{
+	const struct cred *cred = current_cred(), *tcred;
+
+	tcred = __task_cred(task);
+	if ((cred->uid != tcred->euid ||
+	     cred->uid != tcred->suid ||
+	     cred->uid != tcred->uid  ||
+	     cred->gid != tcred->egid ||
+	     cred->gid != tcred->sgid ||
+	     cred->gid != tcred->gid) &&
+	     !capable(CAP_SYS_RESOURCE)) {
+		return -EPERM;
+	}
+
+	return 0;
+}
+
+SYSCALL_DEFINE4(prlimit64, pid_t, pid, unsigned int, resource,
+		const struct rlimit64 __user *, new_rlim,
+		struct rlimit64 __user *, old_rlim)
+{
+	struct rlimit64 old64, new64;
+	struct rlimit old, new;
+	struct task_struct *tsk;
+	int ret;
+
+	if (new_rlim) {
+		if (copy_from_user(&new64, new_rlim, sizeof(new64)))
+			return -EFAULT;
+		rlim64_to_rlim(&new64, &new);
+	}
+
+	/* we don't want to fail after do_rlimit */
+	if (old_rlim && !access_ok(VERIFY_WRITE, old_rlim, sizeof(old64)))
+		return -EFAULT;
+
+	rcu_read_lock();
+	tsk = pid ? find_task_by_vpid(pid) : current;
+	if (!tsk) {
+		rcu_read_unlock();
+		return -ESRCH;
+	}
+	ret = check_prlimit_permission(tsk);
+	if (ret) {
+		rcu_read_unlock();
+		return ret;
+	}
+	get_task_struct(tsk);
+	rcu_read_unlock();
+
+	ret = do_prlimit(tsk, resource, new_rlim ? &new : NULL,
+			old_rlim ? &old : NULL);
+
+	if (!ret && old_rlim) {
+		rlim_to_rlim64(&old, &old64);
+		if (WARN_ON_ONCE(__copy_to_user(old_rlim, &old64,
+						sizeof(old64))))
+			ret = -EFAULT;
+	}
+
+	put_task_struct(tsk);
+	return ret;
+}
+
 SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 {
 	struct rlimit new_rlim;
-- 
1.7.1


