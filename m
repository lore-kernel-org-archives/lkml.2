Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab0FVAMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 20:12:24 -0400
Received: from mail1.gleim.com ([209.208.68.245]:41348 "EHLO mail1.gleim.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab0FVAMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 20:12:22 -0400
From: Edward Allcutt <edward@allcutt.me.uk>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Edward Allcutt <edward@allcutt.me.uk>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Oleg Nesterov <oleg@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH] fs: limit maximum concurrent coredumps
Date: Mon, 21 Jun 2010 19:58:55 -0400
Message-Id: <1277164737-30055-1-git-send-email-edward@allcutt.me.uk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A moderately large number of large core files being dumped simultaneously
can impose severe latency penalties on other processes due to IO load.

For example, a common configuration for PHP web-servers includes apache's
prefork MPM, mod_php and a PHP opcode cache utilizing shared memory. In
certain failure modes, all requests serviced by PHP result in a segfault.
Enabling coredumps might lead to 10-20 coredumps per second, all attempting
to write a 150-200MB core file. This leads to the whole system becoming
entirely unresponsive for many minutes.

The ability to limit concurrent coredumps allows dumping core to be safely
enabled in these situations without affecting responsiveness of the system
as a whole.

I have several servers running with this patch applied (actually backported
to v2.6.26) and it has allowed me to deal successfully with the situation
described above.

In do_coredump I have pulled dump_count back out to the top-level scope
and core_dump_count is now incremented in the normal path.

Added sysctl parameter for tuning core_max_concurrency.

checkpatch complains about "extern ... core_max_concurrency" but this seems
to be an acceptable exception based on the preponderance of other extern
variables in kernel/sysctl.c

Signed-off-by: Edward Allcutt <edward@allcutt.me.uk>
---
 Documentation/sysctl/kernel.txt |   10 ++++++++++
 fs/exec.c                       |   21 ++++++++++++++-------
 kernel/sysctl.c                 |    8 ++++++++
 3 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 3894eaa..6a58d9b 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -23,6 +23,7 @@ show up in /proc/sys/kernel:
 - bootloader_version	     [ X86 only ]
 - callhome		     [ S390 only ]
 - auto_msgmni
+- core_max_concurrency
 - core_pattern
 - core_pipe_limit
 - core_uses_pid
@@ -139,6 +140,15 @@ on has a service contract with IBM.
 
 ==============================================================
 
+core_max_concurrency:
+
+Controls the maximum number of coredumps that can be in progress
+concurrently. Coredumping processes that would cause this value
+to be exceeded are noted via the kernel log and their cores are
+skipped.  0 is a special value, indicating that unlimited processes
+may be captured in parallel. This value defaults to 0.
+
+==============================================================
 core_pattern:
 
 core_pattern is used to specify a core dumpfile pattern name.
diff --git a/fs/exec.c b/fs/exec.c
index e19de6a..90785e1 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -62,6 +62,7 @@
 #include "internal.h"
 
 int core_uses_pid;
+unsigned int core_max_concurrency;
 char core_pattern[CORENAME_MAX_SIZE] = "core";
 unsigned int core_pipe_limit;
 int suid_dumpable = 0;
@@ -1844,6 +1845,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	int retval = 0;
 	int flag = 0;
 	int ispipe;
+	int dump_count = 0;
 	static atomic_t core_dump_count = ATOMIC_INIT(0);
 	struct coredump_params cprm = {
 		.signr = signr,
@@ -1865,6 +1867,14 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	if (!__get_dumpable(cprm.mm_flags))
 		goto fail;
 
+	dump_count = atomic_inc_return(&core_dump_count);
+	if (core_max_concurrency && (core_max_concurrency < dump_count)) {
+		printk(KERN_WARNING "Pid %d(%s) over core_max_concurrency\n",
+		       task_tgid_vnr(current), current->comm);
+		printk(KERN_WARNING "Skipping core dump\n");
+		goto fail;
+	}
+
 	cred = prepare_creds();
 	if (!cred)
 		goto fail;
@@ -1900,7 +1910,6 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	unlock_kernel();
 
  	if (ispipe) {
-		int dump_count;
 		char **helper_argv;
 
 		if (cprm.limit == 1) {
@@ -1926,19 +1935,18 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 		}
 		cprm.limit = RLIM_INFINITY;
 
-		dump_count = atomic_inc_return(&core_dump_count);
 		if (core_pipe_limit && (core_pipe_limit < dump_count)) {
 			printk(KERN_WARNING "Pid %d(%s) over core_pipe_limit\n",
 			       task_tgid_vnr(current), current->comm);
 			printk(KERN_WARNING "Skipping core dump\n");
-			goto fail_dropcount;
+			goto fail_unlock;
 		}
 
 		helper_argv = argv_split(GFP_KERNEL, corename+1, NULL);
 		if (!helper_argv) {
 			printk(KERN_WARNING "%s failed to allocate memory\n",
 			       __func__);
-			goto fail_dropcount;
+			goto fail_unlock;
 		}
 
 		retval = call_usermodehelper_fns(helper_argv[0], helper_argv,
@@ -1994,14 +2002,13 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 close_fail:
 	if (cprm.file)
 		filp_close(cprm.file, NULL);
-fail_dropcount:
-	if (ispipe)
-		atomic_dec(&core_dump_count);
 fail_unlock:
 	coredump_finish(mm);
 	revert_creds(old_cred);
 fail_creds:
 	put_cred(cred);
 fail:
+	if (dump_count)
+		atomic_dec(&core_dump_count);
 	return;
 }
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index d24f761..3f95916 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -88,6 +88,7 @@ extern int sysctl_oom_dump_tasks;
 extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
+extern unsigned int core_max_concurrency;
 extern char core_pattern[];
 extern unsigned int core_pipe_limit;
 extern int pid_max;
@@ -415,6 +416,13 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
+		.procname	= "core_max_concurrency",
+		.data		= &core_max_concurrency,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
 		.procname	= "core_pattern",
 		.data		= core_pattern,
 		.maxlen		= CORENAME_MAX_SIZE,
-- 
1.7.1

