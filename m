Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab2FYXCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 19:02:16 -0400
Received: from smtp.outflux.net ([198.145.64.163]:47430 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151Ab2FYXCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 19:02:14 -0400
Date: Mon, 25 Jun 2012 16:02:04 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] warn about unsafe suid_dumpable / core_pattern combo
Message-ID: <20120625230204.GA27001@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When suid_dumpable=2, detect unsafe core_pattern settings and warn when
they are seen.

Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
---
 fs/exec.c             |   10 +++++-----
 include/linux/sched.h |    5 +++++
 kernel/sysctl.c       |   37 +++++++++++++++++++++++++++++++++++--
 3 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index a6506ba..ddb4c99 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -2002,17 +2002,17 @@ static void coredump_finish(struct mm_struct *mm)
 void set_dumpable(struct mm_struct *mm, int value)
 {
 	switch (value) {
-	case 0:
+	case SUID_DUMPABLE_DISABLED:
 		clear_bit(MMF_DUMPABLE, &mm->flags);
 		smp_wmb();
 		clear_bit(MMF_DUMP_SECURELY, &mm->flags);
 		break;
-	case 1:
+	case SUID_DUMPABLE_ENABLED:
 		set_bit(MMF_DUMPABLE, &mm->flags);
 		smp_wmb();
 		clear_bit(MMF_DUMP_SECURELY, &mm->flags);
 		break;
-	case 2:
+	case SUID_DUMPABLE_SAFE:
 		set_bit(MMF_DUMP_SECURELY, &mm->flags);
 		smp_wmb();
 		set_bit(MMF_DUMPABLE, &mm->flags);
@@ -2025,7 +2025,7 @@ static int __get_dumpable(unsigned long mm_flags)
 	int ret;
 
 	ret = mm_flags & MMF_DUMPABLE_MASK;
-	return (ret >= 2) ? 2 : ret;
+	return (ret > SUID_DUMPABLE_ENABLED) ? SUID_DUMPABLE_SAFE : ret;
 }
 
 int get_dumpable(struct mm_struct *mm)
@@ -2142,7 +2142,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	 * so we dump it as root in mode 2, and only into a controlled
 	 * environment (pipe handler or fully qualified path).
 	 */
-	if (__get_dumpable(cprm.mm_flags) == 2) {
+	if (__get_dumpable(cprm.mm_flags) == SUID_DUMPABLE_SAFE) {
 		/* Setuid core dump mode */
 		flag = O_EXCL;		/* Stop rewrite attacks */
 		cred->fsuid = GLOBAL_ROOT_UID;	/* Dump root private */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4059c0f..394d635 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -406,6 +406,11 @@ static inline void arch_pick_mmap_layout(struct mm_struct *mm) {}
 extern void set_dumpable(struct mm_struct *mm, int value);
 extern int get_dumpable(struct mm_struct *mm);
 
+/* get/set_dumpable() values */
+#define SUID_DUMPABLE_DISABLED	0
+#define SUID_DUMPABLE_ENABLED	1
+#define SUID_DUMPABLE_SAFE	2
+
 /* mm flags */
 /* dumpable bits */
 #define MMF_DUMPABLE      0  /* core dump is permitted */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4ab1187..b46f496 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -174,6 +174,11 @@ static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
 				void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
+static int proc_dointvec_minmax_coredump(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp, loff_t *ppos);
+static int proc_dostring_coredump(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp, loff_t *ppos);
+
 #ifdef CONFIG_MAGIC_SYSRQ
 /* Note: sysrq code uses it's own private copy */
 static int __sysrq_enabled = SYSRQ_DEFAULT_ENABLE;
@@ -410,7 +415,7 @@ static struct ctl_table kern_table[] = {
 		.data		= core_pattern,
 		.maxlen		= CORENAME_MAX_SIZE,
 		.mode		= 0644,
-		.proc_handler	= proc_dostring,
+		.proc_handler	= proc_dostring_coredump,
 	},
 	{
 		.procname	= "core_pipe_limit",
@@ -1498,7 +1503,7 @@ static struct ctl_table fs_table[] = {
 		.data		= &suid_dumpable,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax_coredump,
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
@@ -2009,6 +2014,34 @@ int proc_dointvec_minmax(struct ctl_table *table, int write,
 				do_proc_dointvec_minmax_conv, &param);
 }
 
+static void validate_coredump_safety(void)
+{
+	if (suid_dumpable == SUID_DUMPABLE_SAFE &&
+	    core_pattern[0] != '/' && core_pattern[0] != '|') {
+		printk(KERN_WARNING "Unsafe core_pattern used with "\
+			"suid_dumpable=2. Pipe handler or fully qualified "\
+			"core dump path required.\n");
+	}
+}
+
+static int proc_dointvec_minmax_coredump(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int error = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	if (!error)
+		validate_coredump_safety();
+	return error;
+}
+
+static int proc_dostring_coredump(struct ctl_table *table, int write,
+		  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int error = proc_dostring(table, write, buffer, lenp, ppos);
+	if (!error)
+		validate_coredump_safety();
+	return error;
+}
+
 static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int write,
 				     void __user *buffer,
 				     size_t *lenp, loff_t *ppos,
-- 
1.7.0.4

-- 
Kees Cook
Chrome OS Security
