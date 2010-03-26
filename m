Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0CZNo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 09:44:27 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:61035 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754005Ab0CZNoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 09:44:25 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Mar 2010 09:44:25 EDT
X-AuditID: 1209190f-b7b20ae000003f85-3e-4bacb90bffa8
From: Andy Lutomirski <luto@MIT.EDU>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: Eric Biederman <ebiederm@xmission.com>,
       "Andrew G. Morgan" <morgan@kernel.org>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 3/3] Add PR_SET_FORCE_EXECVE_NOSECURITY to turn execve calls into execve_nosecurity.
Date: Fri, 26 Mar 2010 07:38:36 -0600
Message-Id: <e515416a8565f1e86a1c579985063a431a103568.1269610459.git.luto@mit.edu>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <cover.1269610458.git.luto@mit.edu>
References: <cover.1269610458.git.luto@mit.edu>
X-Brightmail-Tracker: AAAAARNt6nE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag is preserved across execve_nosecurity.  It's obviously dangerous, so
we only allow it if PR_RESTRICT_EXEC is set.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 fs/compat.c           |    3 +++
 fs/exec.c             |    3 +++
 include/linux/prctl.h |    5 +++++
 include/linux/sched.h |    1 +
 kernel/fork.c         |    1 +
 kernel/sys.c          |   13 +++++++++++++
 6 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index a091da6..4b7f61f 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1468,6 +1468,9 @@ int compat_do_execve(char * filename,
 	bool clear_in_exec;
 	int retval;
 
+	if (current->force_execve_nosecurity)
+		change_security = false;
+
 	if (current->restrict_exec && change_security) {
 		retval = -EPERM;
 		goto out_ret;
diff --git a/fs/exec.c b/fs/exec.c
index 37fb5fa..0e045b8 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1350,6 +1350,9 @@ int do_execve(char * filename,
 	bool clear_in_exec;
 	int retval;
 
+	if (current->force_execve_nosecurity)
+		change_security = false;
+
 	if (current->restrict_exec && change_security) {
 		retval = -EPERM;
 		goto out_ret;
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index b926055..8465df3 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -108,4 +108,9 @@
 
 #define PR_GET_RESTRICT 36
 
+/* Get/set execve -> execve_nosecurity remapping. */
+#define PR_SET_FORCE_EXECVE_NOSECURITY 37
+#define PR_GET_FORCE_EXECVE_NOSECURITY 38
+
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d1956f7..59f7bcd 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1303,6 +1303,7 @@ struct task_struct {
 	unsigned sched_reset_on_fork:1;
 
 	unsigned restrict_exec:1; /* Process may not call execve. */
+	unsigned force_execve_nosecurity:1; /* execve means execve_nosecurity */
 
 	pid_t pid;
 	pid_t tgid;
diff --git a/kernel/fork.c b/kernel/fork.c
index 8f994e5..d7e1688 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1044,6 +1044,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto bad_fork_free;
 
 	p->restrict_exec = current->restrict_exec;
+	p->force_execve_nosecurity = current->force_execve_nosecurity;
 
 	/*
 	 * If multiple threads are within copy_process(), then this check
diff --git a/kernel/sys.c b/kernel/sys.c
index 3f4aa33..d34daaa 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1609,6 +1609,19 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			if (arg5 && !error)
 				error = put_user(0, (unsigned long __user *)arg5);
 			break;
+		case PR_SET_FORCE_EXECVE_NOSECURITY:
+			if (arg3 | arg4 | arg5)
+				return -EINVAL;
+
+			/* Someone braver could remove this check. */
+			if (!current->restrict_exec)
+				return -EPERM;
+
+			current->force_execve_nosecurity = !!arg2;
+			break;
+		case PR_GET_FORCE_EXECVE_NOSECURITY:
+			error = current->force_execve_nosecurity;
+			break;
 		default:
 			error = -EINVAL;
 			break;
-- 
1.6.6.1

