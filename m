Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab0EGI4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:56:40 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:46448 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab0EGI4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:56:22 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, adobriyan@gmail.com, nhorman@tuxdriver.com,
       oleg@redhat.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 08/11] rlimits: redo do_setrlimit to more generic do_prlimit
Date: Fri,  7 May 2010 10:55:39 +0200
Message-Id: <1273222543-17083-8-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <alpine.LFD.2.00.1005060827520.901@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1005060827520.901@i5.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It now allows also reading of limits. I.e. all read and writes will
later use this function.

It takes two parameters, new and old limits which can be both NULL.
If new is non-NULL, the value in it is set to rlimits.
If old is non-NULL, current rlimits are stored there.
If both are non-NULL, old are stored prior to setting the new ones,
atomically.
(Similar to sigaction.)

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/resource.h |    4 +-
 kernel/sys.c             |   63 ++++++++++++++++++++++++++-------------------
 2 files changed, 38 insertions(+), 29 deletions(-)

diff --git a/include/linux/resource.h b/include/linux/resource.h
index 037aa7e..88d36f9 100644
--- a/include/linux/resource.h
+++ b/include/linux/resource.h
@@ -80,8 +80,8 @@ struct rlimit64 {
 struct task_struct;
 
 int getrusage(struct task_struct *p, int who, struct rusage __user *ru);
-int do_setrlimit(struct task_struct *tsk, unsigned int resource,
-		struct rlimit *new_rlim);
+int do_prlimit(struct task_struct *tsk, unsigned int resource,
+		struct rlimit *new_rlim, struct rlimit *old_rlim);
 
 #endif /* __KERNEL__ */
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 9e9a3a7..7a453d2 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1273,18 +1273,30 @@ SYSCALL_DEFINE2(old_getrlimit, unsigned int, resource,
 #endif
 
 /* make sure you are allowed to change @tsk limits before calling this */
-int do_setrlimit(struct task_struct *tsk, unsigned int resource,
-		struct rlimit *new_rlim)
+int do_prlimit(struct task_struct *tsk, unsigned int resource,
+		struct rlimit *new_rlim, struct rlimit *old_rlim)
 {
-	struct rlimit *old_rlim;
+	struct rlimit *rlim;
 	int retval = 0;
 
 	if (resource >= RLIM_NLIMITS)
 		return -EINVAL;
-	if (new_rlim->rlim_cur > new_rlim->rlim_max)
-		return -EINVAL;
-	if (resource == RLIMIT_NOFILE && new_rlim->rlim_max > sysctl_nr_open)
-		return -EPERM;
+	if (new_rlim) {
+		if (new_rlim->rlim_cur > new_rlim->rlim_max)
+			return -EINVAL;
+		if (resource == RLIMIT_NOFILE &&
+				new_rlim->rlim_max > sysctl_nr_open)
+			return -EPERM;
+		if (resource == RLIMIT_CPU && new_rlim->rlim_cur == 0) {
+			/*
+			 * The caller is asking for an immediate RLIMIT_CPU
+			 * expiry.  But we use the zero value to mean "it was
+			 * never set".  So let's cheat and make it one second
+			 * instead
+			 */
+			new_rlim->rlim_cur = 1;
+		}
+	}
 
 	/* protect tsk->signal and tsk->sighand from disappearing */
 	read_lock(&tasklist_lock);
@@ -1293,28 +1305,25 @@ int do_setrlimit(struct task_struct *tsk, unsigned int resource,
 		goto out;
 	}
 
-	if (resource == RLIMIT_CPU && new_rlim->rlim_cur == 0) {
-		/*
-		 * The caller is asking for an immediate RLIMIT_CPU
-		 * expiry.  But we use the zero value to mean "it was
-		 * never set".  So let's cheat and make it one second
-		 * instead
-		 */
-		new_rlim->rlim_cur = 1;
-	}
-
-	old_rlim = tsk->signal->rlim + resource;
+	rlim = tsk->signal->rlim + resource;
 	task_lock(tsk->group_leader);
-	if ((new_rlim->rlim_max > old_rlim->rlim_max) &&
-				!capable(CAP_SYS_RESOURCE))
-		retval = -EPERM;
-	if (!retval)
-		retval = security_task_setrlimit(tsk, resource, new_rlim);
-	if (!retval)
-		*old_rlim = *new_rlim;
+	if (new_rlim) {
+		if ((new_rlim->rlim_max > rlim->rlim_max) &&
+					!capable(CAP_SYS_RESOURCE))
+			retval = -EPERM;
+		if (!retval)
+			retval = security_task_setrlimit(tsk, resource,
+					new_rlim);
+	}
+	if (!retval) {
+		if (old_rlim)
+			*old_rlim = *rlim;
+		if (new_rlim)
+			*rlim = *new_rlim;
+	}
 	task_unlock(tsk->group_leader);
 
-	if (retval || resource != RLIMIT_CPU)
+	if (retval || !new_rlim || resource != RLIMIT_CPU)
 		goto out;
 
 	/*
@@ -1338,7 +1347,7 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 
 	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
 		return -EFAULT;
-	return do_setrlimit(current, resource, &new_rlim);
+	return do_prlimit(current, resource, &new_rlim, NULL);
 }
 
 /*
-- 
1.7.1


