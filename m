Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab0FWVzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 17:55:09 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:37302 "EHLO
	mail.pripojeni.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752714Ab0FWVwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 17:52:50 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: Oleg Nesterov <oleg@redhat.com>, akpm@linux-foundation.org,
       adobriyan@gmail.com, nhorman@tuxdriver.com,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 05/12] rlimits: split sys_setrlimit
Date: Wed, 23 Jun 2010 23:52:06 +0200
Message-Id: <1277329933-8139-5-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277329933-8139-1-git-send-email-jslaby@suse.cz>
References: <1277329933-8139-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Create do_setrlimit from sys_setrlimit and declare do_setrlimit
in the resource header. This is the first phase to have generic
do_prlimit which allows to be called from read, write and compat
rlimits code.

The new do_setrlimit also accepts a task pointer to change the limits
of. Currently, it cannot be other than current, but this will change
with locking later.

Also pass tsk->group_leader to security_task_setrlimit to check
whether current is allowed to change rlimits of the process and not
its arbitrary thread because it makes more sense given that rlimit are
per process and not per-thread.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/resource.h |    2 ++
 kernel/sys.c             |   40 ++++++++++++++++++++++++----------------
 2 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/include/linux/resource.h b/include/linux/resource.h
index f1e914e..cf8dc96 100644
--- a/include/linux/resource.h
+++ b/include/linux/resource.h
@@ -73,6 +73,8 @@ struct rlimit {
 struct task_struct;
 
 int getrusage(struct task_struct *p, int who, struct rusage __user *ru);
+int do_setrlimit(struct task_struct *tsk, unsigned int resource,
+		struct rlimit *new_rlim);
 
 #endif /* __KERNEL__ */
 
diff --git a/kernel/sys.c b/kernel/sys.c
index f2b2d7a..b5b96e3 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1272,42 +1272,41 @@ SYSCALL_DEFINE2(old_getrlimit, unsigned int, resource,
 
 #endif
 
-SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
+int do_setrlimit(struct task_struct *tsk, unsigned int resource,
+		struct rlimit *new_rlim)
 {
-	struct rlimit new_rlim, *old_rlim;
+	struct rlimit *old_rlim;
 	int retval;
 
 	if (resource >= RLIM_NLIMITS)
 		return -EINVAL;
-	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
-		return -EFAULT;
-	if (new_rlim.rlim_cur > new_rlim.rlim_max)
+	if (new_rlim->rlim_cur > new_rlim->rlim_max)
 		return -EINVAL;
-	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
+	if (resource == RLIMIT_NOFILE && new_rlim->rlim_max > sysctl_nr_open)
 		return -EPERM;
 
-	retval = security_task_setrlimit(current, resource, &new_rlim);
+	retval = security_task_setrlimit(tsk->group_leader, resource, new_rlim);
 	if (retval)
 		return retval;
 
-	if (resource == RLIMIT_CPU && new_rlim.rlim_cur == 0) {
+	if (resource == RLIMIT_CPU && new_rlim->rlim_cur == 0) {
 		/*
 		 * The caller is asking for an immediate RLIMIT_CPU
 		 * expiry.  But we use the zero value to mean "it was
 		 * never set".  So let's cheat and make it one second
 		 * instead
 		 */
-		new_rlim.rlim_cur = 1;
+		new_rlim->rlim_cur = 1;
 	}
 
-	old_rlim = current->signal->rlim + resource;
-	task_lock(current->group_leader);
-	if (new_rlim.rlim_max > old_rlim->rlim_max &&
+	old_rlim = tsk->signal->rlim + resource;
+	task_lock(tsk->group_leader);
+	if (new_rlim->rlim_max > old_rlim->rlim_max &&
 			!capable(CAP_SYS_RESOURCE))
 		retval = -EPERM;
 	else
-		*old_rlim = new_rlim;
-	task_unlock(current->group_leader);
+		*old_rlim = *new_rlim;
+	task_unlock(tsk->group_leader);
 
 	if (retval || resource != RLIMIT_CPU)
 		goto out;
@@ -1318,14 +1317,23 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 	 * very long-standing error, and fixing it now risks breakage of
 	 * applications, so we live with it
 	 */
-	if (new_rlim.rlim_cur == RLIM_INFINITY)
+	if (new_rlim->rlim_cur == RLIM_INFINITY)
 		goto out;
 
-	update_rlimit_cpu(current, new_rlim.rlim_cur);
+	update_rlimit_cpu(tsk, new_rlim->rlim_cur);
 out:
 	return retval;
 }
 
+SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
+{
+	struct rlimit new_rlim;
+
+	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
+		return -EFAULT;
+	return do_setrlimit(current, resource, &new_rlim);
+}
+
 /*
  * It would make sense to put struct rusage in the task_struct,
  * except that would make the task_struct be *really big*.  After
-- 
1.7.1


