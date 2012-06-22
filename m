Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab2FVTY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 15:24:59 -0400
Received: from smtp.outflux.net ([198.145.64.163]:34689 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002Ab2FVTYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 15:24:54 -0400
Date: Fri, 22 Jun 2012 12:24:13 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rob Landley <rob@landley.net>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Doug Ledford <dledford@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Joe Korty <joe.korty@ccur.com>, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [PATCH v3] fs: introduce pipe-only dump mode suid_dumpable=3
Message-ID: <20120622192413.GA5774@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the suid_dumpable sysctl is set to "2", and there is no core
dump pipe defined in the core_pattern sysctl, a local user can cause
core files to be written to root-writable directories, potentially with
user-controlled content. This means an admin can unknowningly reintroduce
a variation of CVE-2006-2451.

$ cat /proc/sys/fs/suid_dumpable
2
$ cat /proc/sys/kernel/core_pattern
core
$ ulimit -c unlimited
$ cd /
$ ls -l core
ls: cannot access core: No such file or directory
$ touch core
touch: cannot touch `core': Permission denied
$ OHAI="evil-string-here" ping localhost >/dev/null 2>&1 &
$ pid=$!
$ sleep 1
$ kill -SEGV $pid
$ ls -l core
-rw------- 1 root kees 458752 Jun 21 11:35 core
$ sudo strings core | grep evil
OHAI=evil-string-here

While cron has been fixed to abort reading a file when there is any
parse error, there are still other sensitive directories that will read
any file present and skip unparsable lines.

This patch introduces suid_dumpable=3 to allow privilege-changed processes
to be dumped only to a pipe handler (and not directly to disk). The value
of suid_dumpable=2 is now historic, and attempting to set this sysctl
value returns -EINVAL.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Alan Cox <alan@linux.intel.com>
---
v3:
 - use proper sysctl _conv function, fix commit description, suggested by
   Eric W. Biederman.
v2:
 - switch to mode 3, remove mode 2, suggested by Alan Cox.
---
 Documentation/sysctl/fs.txt |   12 +++++-----
 fs/exec.c                   |   49 ++++++++++++++++--------------------------
 include/linux/sched.h       |    7 +++++-
 kernel/sysctl.c             |   38 ++++++++++++++++++++++++++++++--
 4 files changed, 66 insertions(+), 40 deletions(-)

diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
index 13d6166..4302839 100644
--- a/Documentation/sysctl/fs.txt
+++ b/Documentation/sysctl/fs.txt
@@ -167,12 +167,12 @@ or otherwise protected/tainted binaries. The modes are
 1 - (debug) - all processes dump core when possible. The core dump is
 	owned by the current user and no security is applied. This is
 	intended for system debugging situations only. Ptrace is unchecked.
-2 - (suidsafe) - any binary which normally would not be dumped is dumped
-	readable by root only. This allows the end user to remove
-	such a dump but not access it directly. For security reasons
-	core dumps in this mode will not overwrite one another or
-	other files. This mode is appropriate when administrators are
-	attempting to debug problems in a normal environment.
+2 - (suidsafe) - no longer allowed (returns -EINVAL).
+3 - (pipeforced) - any binary which normally would not be dumped is dumped
+	anyway, but only if a core dump pipe handler is defined (see the
+	"core_pattern" kernel sysctl). This mode is appropriate when
+	administrators are attempting to debug problems in a normal
+	environment.
 
 ==============================================================
 
diff --git a/fs/exec.c b/fs/exec.c
index da27b91..8e0abf2 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1136,7 +1136,7 @@ void setup_new_exec(struct linux_binprm * bprm)
 	current->sas_ss_sp = current->sas_ss_size = 0;
 
 	if (uid_eq(current_euid(), current_uid()) && gid_eq(current_egid(), current_gid()))
-		set_dumpable(current->mm, 1);
+		set_dumpable(current->mm, SUID_DUMPABLE_ENABLED);
 	else
 		set_dumpable(current->mm, suid_dumpable);
 
@@ -1991,28 +1991,28 @@ static void coredump_finish(struct mm_struct *mm)
  * old  new | initial interim  final
  * ---------+-----------------------
  *  0    1  |   00      01      01
- *  0    2  |   00      10(*)   11
+ *  0    3  |   00      10(*)   11
  *  1    0  |   01      00      00
- *  1    2  |   01      11      11
- *  2    0  |   11      10(*)   00
- *  2    1  |   11      11      01
+ *  1    3  |   01      11      11
+ *  3    0  |   11      10(*)   00
+ *  3    1  |   11      11      01
  *
  * (*) get_dumpable regards interim value of 10 as 11.
  */
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
+	case SUID_DUMPABLE_PIPE_ONLY:
 		set_bit(MMF_DUMP_SECURELY, &mm->flags);
 		smp_wmb();
 		set_bit(MMF_DUMPABLE, &mm->flags);
@@ -2025,7 +2025,7 @@ static int __get_dumpable(unsigned long mm_flags)
 	int ret;
 
 	ret = mm_flags & MMF_DUMPABLE_MASK;
-	return (ret >= 2) ? 2 : ret;
+	return (ret > SUID_DUMPABLE_ENABLED) ? SUID_DUMPABLE_PIPE_ONLY : ret;
 }
 
 int get_dumpable(struct mm_struct *mm)
@@ -2106,10 +2106,8 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	struct core_name cn;
 	struct mm_struct *mm = current->mm;
 	struct linux_binfmt * binfmt;
-	const struct cred *old_cred;
-	struct cred *cred;
+	bool pipeonly = false;
 	int retval = 0;
-	int flag = 0;
 	int ispipe;
 	static atomic_t core_dump_count = ATOMIC_INIT(0);
 	struct coredump_params cprm = {
@@ -2132,25 +2130,16 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	if (!__get_dumpable(cprm.mm_flags))
 		goto fail;
 
-	cred = prepare_creds();
-	if (!cred)
-		goto fail;
 	/*
-	 *	We cannot trust fsuid as being the "true" uid of the
-	 *	process nor do we know its entire history. We only know it
-	 *	was tainted so we dump it as root in mode 2.
+	 * We cannot trust the environment dumping a process that has
+	 * changed privileges, so only write the dump to a pipe.
 	 */
-	if (__get_dumpable(cprm.mm_flags) == 2) {
-		/* Setuid core dump mode */
-		flag = O_EXCL;		/* Stop rewrite attacks */
-		cred->fsuid = GLOBAL_ROOT_UID;	/* Dump root private */
-	}
+	if (__get_dumpable(cprm.mm_flags) == SUID_DUMPABLE_PIPE_ONLY)
+		pipeonly = true;
 
 	retval = coredump_wait(exit_code, &core_state);
 	if (retval < 0)
-		goto fail_creds;
-
-	old_cred = override_creds(cred);
+		goto fail;
 
 	/*
 	 * Clear any false indication of pending signals that might
@@ -2220,11 +2209,14 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	} else {
 		struct inode *inode;
 
+		if (pipeonly)
+			goto fail_unlock;
+
 		if (cprm.limit < binfmt->min_coredump)
 			goto fail_unlock;
 
 		cprm.file = filp_open(cn.corename,
-				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
+				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE,
 				 0600);
 		if (IS_ERR(cprm.file))
 			goto fail_unlock;
@@ -2268,9 +2260,6 @@ fail_unlock:
 	kfree(cn.corename);
 fail_corename:
 	coredump_finish(mm);
-	revert_creds(old_cred);
-fail_creds:
-	put_cred(cred);
 fail:
 	return;
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4059c0f..48a7a8e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -406,10 +406,15 @@ static inline void arch_pick_mmap_layout(struct mm_struct *mm) {}
 extern void set_dumpable(struct mm_struct *mm, int value);
 extern int get_dumpable(struct mm_struct *mm);
 
+/* get/set_dumpable() values */
+#define SUID_DUMPABLE_DISABLED      0
+#define SUID_DUMPABLE_ENABLED       1
+#define SUID_DUMPABLE_PIPE_ONLY     3
+
 /* mm flags */
 /* dumpable bits */
 #define MMF_DUMPABLE      0  /* core dump is permitted */
-#define MMF_DUMP_SECURELY 1  /* core file is readable only by root */
+#define MMF_DUMP_SECURELY 1  /* core is readable only by pipe */
 
 #define MMF_DUMPABLE_BITS 2
 #define MMF_DUMPABLE_MASK ((1 << MMF_DUMPABLE_BITS) - 1)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4ab1187..d163af3 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -174,6 +174,9 @@ static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
 				void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
+static int proc_dointvec_suid_dumpable(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp, loff_t *ppos);
+
 #ifdef CONFIG_MAGIC_SYSRQ
 /* Note: sysrq code uses it's own private copy */
 static int __sysrq_enabled = SYSRQ_DEFAULT_ENABLE;
@@ -1498,9 +1501,7 @@ static struct ctl_table fs_table[] = {
 		.data		= &suid_dumpable,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &two,
+		.proc_handler	= proc_dointvec_suid_dumpable,
 	},
 #if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
 	{
@@ -2009,6 +2010,37 @@ int proc_dointvec_minmax(struct ctl_table *table, int write,
 				do_proc_dointvec_minmax_conv, &param);
 }
 
+/* Allow only the valid suid_dumpable values. */
+static int do_proc_dointvec_suid_dumpable_conv(bool *negp,
+		unsigned long *lvalp, int *valp, int write, void *data)
+{
+	if (write) {
+		int val = *negp ? -*lvalp : *lvalp;
+		if (val != SUID_DUMPABLE_DISABLED &&
+		    val != SUID_DUMPABLE_ENABLED &&
+		    val != SUID_DUMPABLE_PIPE_ONLY)
+			return -EINVAL;
+		*valp = val;
+	} else {
+		int val = *valp;
+		if (val < 0) {
+			*negp = true;
+			*lvalp = (unsigned long)-val;
+		} else {
+			*negp = false;
+			*lvalp = (unsigned long)val;
+		}
+	}
+	return 0;
+}
+
+static int proc_dointvec_suid_dumpable(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return do_proc_dointvec(table, write, buffer, lenp, ppos,
+				do_proc_dointvec_suid_dumpable_conv, NULL);
+}
+
 static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int write,
 				     void __user *buffer,
 				     size_t *lenp, loff_t *ppos,
-- 
1.7.0.4

