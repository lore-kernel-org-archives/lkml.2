Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab0CZNoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 09:44:18 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:64883 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753471Ab0CZNoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 09:44:13 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Mar 2010 09:44:13 EDT
X-AuditID: 12074422-b7c13ae000003829-0a-4bacb8ffbb0b
From: Andy Lutomirski <luto@MIT.EDU>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: Eric Biederman <ebiederm@xmission.com>,
       "Andrew G. Morgan" <morgan@kernel.org>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 2/3] Add PR_RESTRICT_ME to disable security-sensitive features for a process tree.
Date: Fri, 26 Mar 2010 07:38:35 -0600
Message-Id: <b27b3045071c6016a4c1329fc270a38acf40a423.1269610458.git.luto@mit.edu>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <cover.1269610458.git.luto@mit.edu>
References: <cover.1269610458.git.luto@mit.edu>
X-Brightmail-Tracker: AAAAARNt6nE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a prctl PR_RESTRICT_ME that enables restrictions that cannot be
disabled and are inherited by children.  There's a long history of dangerous
patches that add similar restrictions that persist across execve.  This is
bad: execve can grant new privileges, and restrictions on exec'd programs
can be used to subvert them.

To avoid this issue, the very first PR_RESTRICT_ME restriction bit is
PR_RESTRICT_EXEC, which simply disables exec.

In the presence of execve_nosecurity, this can be used to shoot oneself in
the foot, but it should not be possible to shoot other people in the foot
with this patch.

Any future PR_RESTRICT_ME bits should not be allowed to be set unless
PR_RESTRICT_EXEC is also set.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 fs/compat.c           |    5 +++++
 fs/exec.c             |    5 +++++
 include/linux/prctl.h |    6 ++++++
 include/linux/sched.h |    2 ++
 kernel/fork.c         |    2 ++
 kernel/sys.c          |   29 +++++++++++++++++++++++++++++
 6 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 585a2d7..a091da6 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1468,6 +1468,11 @@ int compat_do_execve(char * filename,
 	bool clear_in_exec;
 	int retval;
 
+	if (current->restrict_exec && change_security) {
+		retval = -EPERM;
+		goto out_ret;
+	}
+
 	retval = unshare_files(&displaced);
 	if (retval)
 		goto out_ret;
diff --git a/fs/exec.c b/fs/exec.c
index 4067b65..37fb5fa 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1350,6 +1350,11 @@ int do_execve(char * filename,
 	bool clear_in_exec;
 	int retval;
 
+	if (current->restrict_exec && change_security) {
+		retval = -EPERM;
+		goto out_ret;
+	}
+
 	retval = unshare_files(&displaced);
 	if (retval)
 		goto out_ret;
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index a3baeb2..b926055 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -102,4 +102,10 @@
 
 #define PR_MCE_KILL_GET 34
 
+/* Get/set irrevocable restrictions. */
+#define PR_RESTRICT_ME  35
+# define PR_RESTRICT_EXEC 1
+
+#define PR_GET_RESTRICT 36
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2d03069..d1956f7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1302,6 +1302,8 @@ struct task_struct {
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
 
+	unsigned restrict_exec:1; /* Process may not call execve. */
+
 	pid_t pid;
 	pid_t tgid;
 
diff --git a/kernel/fork.c b/kernel/fork.c
index f88bd98..8f994e5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1043,6 +1043,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (retval < 0)
 		goto bad_fork_free;
 
+	p->restrict_exec = current->restrict_exec;
+
 	/*
 	 * If multiple threads are within copy_process(), then this check
 	 * triggers too late. This doesn't hurt, the check is only there
diff --git a/kernel/sys.c b/kernel/sys.c
index 18bde97..3f4aa33 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1580,6 +1580,35 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			else
 				error = PR_MCE_KILL_DEFAULT;
 			break;
+		case PR_RESTRICT_ME:
+			if (arg3 | arg4 | arg5)
+				return -EINVAL;
+
+			/* This should become more sophisticated if
+			   more restriction flags are added. */
+			if (arg2 == PR_RESTRICT_EXEC)
+				current->restrict_exec = 1;
+			else if (arg2 != 0)
+				return -EINVAL;
+			break;
+		case PR_GET_RESTRICT:
+			if (arg2) {
+				unsigned long out2 = 0;
+				if (current->restrict_exec)
+					out2 |= PR_RESTRICT_EXEC;
+				error = put_user(out2,
+						 (unsigned long __user *)arg2);
+			}
+
+			/* In case some crazy person wants to add tons
+			   of future flags, don't get in their way. */
+			if (arg3 && !error)
+				error = put_user(0, (unsigned long __user *)arg3);
+			if (arg4 && !error)
+				error = put_user(0, (unsigned long __user *)arg4);
+			if (arg5 && !error)
+				error = put_user(0, (unsigned long __user *)arg5);
+			break;
 		default:
 			error = -EINVAL;
 			break;
-- 
1.6.6.1

