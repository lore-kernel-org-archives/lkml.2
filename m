Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197Ab0FPWTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 18:19:47 -0400
Received: from smtp.outflux.net ([198.145.64.163]:39354 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758559Ab0FPWTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 18:19:46 -0400
Date: Wed, 16 Jun 2010 15:18:33 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Kees Cook <kees.cook@canonical.com>,
       Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-doc@vger.kernel.org
Subject: [PATCH] ptrace: allow restriction of ptrace scope
Message-ID: <20100616221833.GM24749@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Linux grows in popularity, it will become a larger target for
malware. One particularly troubling weakness of the Linux process
interfaces is that a single user is able to examine the memory and
running state of any of their processes. For example, if one application
(e.g. Pidgin) was compromised, it would be possible for an attacker to
attach to other running processes (e.g. Firefox, SSH sessions, GPG agent,
etc) to extract additional credentials and continue to expand the scope
of their attack without resorting to user-assisted phishing.

This is not a theoretical problem. SSH session hijacking
(http://www.storm.net.nz/projects/7) and arbitrary code injection
(http://c-skills.blogspot.com/2007/05/injectso.html) attacks already
exist and remain possible if PTRACE is allowed to operate as before.
PTRACE is not commonly used by non-developers and non-admins, so system
builders should be allowed the option to disable this debugging system.

For a solution, some applications use prctl(PR_SET_DUMPABLE, ...) to
specifically disallow such PTRACE attachment (e.g. ssh-agent), but many
do not. A more general solution is to only allow PTRACE directly from a
parent to a child process (i.e. direct "gdb EXE" and "strace EXE" still
work), or with CAP_SYS_PTRACE (i.e. "gdb --pid=PID", and "strace -p PID"
still work as root).

This patch is based on the patch in grsecurity. It includes a sysctl
to enable the behavior via /proc/sys/kernel/ptrace_scope.  This could
be expanded in the future to further restrict PTRACE to, for example,
only CAP_SYS_PTRACE (scope 2) or only init (scope 3).

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 Documentation/sysctl/kernel.txt |   16 ++++++++++++++++
 kernel/ptrace.c                 |   24 ++++++++++++++++++++++++
 kernel/sysctl.c                 |   10 ++++++++++
 3 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 3894eaa..030f2f2 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -50,6 +50,7 @@ show up in /proc/sys/kernel:
 - powersave-nap               [ PPC only ]
 - panic_on_unrecovered_nmi
 - printk
+- ptrace_scope
 - randomize_va_space
 - real-root-dev               ==> Documentation/initrd.txt
 - reboot-cmd                  [ SPARC only ]
@@ -406,6 +407,21 @@ that support this feature.
 
 ==============================================================
 
+ptrace_scope:
+
+This option can used to select the scope of PTRACE functionality.
+
+0 - Standard scope.  PTRACE can be used by any process on any other
+    process that shares the same uid and is dumpable (i.e. hasn't been
+    setuid, or has prctl(PR_SET_DUMPABLE) called on it).  CAP_SYS_PTRACE
+    overrides any limitations.  (This is the default option.)
+
+1 - Child-only.  PTRACE can be used by any process on any child process
+    that shares the same uid and is dumpable.  CAP_SYS_PTRACE overrides
+    any limitations.
+
+==============================================================
+
 reboot-cmd: (Sparc only)
 
 ??? This seems to be a way to give an argument to the Sparc
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 74a3d69..5e7777a 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -23,6 +23,8 @@
 #include <linux/uaccess.h>
 #include <linux/regset.h>
 
+/* sysctl for defining allowed scope of PTRACE */
+int ptrace_scope;
 
 /*
  * ptrace a task: make the debugger its new parent and
@@ -127,6 +129,10 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	 * ptrace_attach denies several cases that /proc allows
 	 * because setting up the necessary parent/child relationship
 	 * or halting the specified task is impossible.
+	 *
+	 * PTRACE scope can be define as:
+	 *  0 - classic: CAP_SYS_PTRACE and same uid can ptrace non-setuid
+	 *  1 - restricted: as above, but only children of ptracing process
 	 */
 	int dumpable = 0;
 	/* Don't let security modules deny introspection */
@@ -150,6 +156,24 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 		dumpable = get_dumpable(task->mm);
 	if (!dumpable && !capable(CAP_SYS_PTRACE))
 		return -EPERM;
+	/* require ptrace target be a child of ptracer on attach */
+	if (mode == PTRACE_MODE_ATTACH && ptrace_scope &&
+	    !capable(CAP_SYS_PTRACE)) {
+		struct task_struct *walker = task;
+		int rc = 0;
+
+		read_lock(&tasklist_lock);
+		while (walker->pid > 0) {
+			if (walker == current)
+				break;
+			walker = walker->parent;
+		}
+		if (walker->pid == 0)
+			rc = -EPERM;
+		read_unlock(&tasklist_lock);
+		if (rc)
+			return rc;
+	}
 
 	return security_ptrace_access_check(task, mode);
 }
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index d24f761..fcb61c3 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -86,6 +86,7 @@ extern int sysctl_panic_on_oom;
 extern int sysctl_oom_kill_allocating_task;
 extern int sysctl_oom_dump_tasks;
 extern int max_threads;
+extern int ptrace_scope;
 extern int core_uses_pid;
 extern int suid_dumpable;
 extern char core_pattern[];
@@ -408,6 +409,15 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
+		.procname	= "ptrace_scope",
+		.data		= &ptrace_scope,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+	{
 		.procname	= "core_uses_pid",
 		.data		= &core_uses_pid,
 		.maxlen		= sizeof(int),
-- 
1.7.1

-- 
Kees Cook
Ubuntu Security Team
