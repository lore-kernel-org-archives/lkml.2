Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab2FWAM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 20:12:26 -0400
Received: from smtp.outflux.net ([198.145.64.163]:43779 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753740Ab2FWAMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 20:12:24 -0400
Date: Fri, 22 Jun 2012 17:12:06 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Rob Landley <rob@landley.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Doug Ledford <dledford@redhat.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Joe Korty <joe.korty@ccur.com>, Kees Cook <keescook@chromium.org>,
        linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v4] fs: make dumpable=2 only write to a pipe
Message-ID: <20120623001206.GA22639@www.outflux.net>
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
core files to be written to root-writable directories, potentially
with user-controlled content. This means an admin can unknowningly
reintroduce a variation of CVE-2006-2451, allowing local users to gain
root privileges.

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

Instead of introducing a suid_dumpable=3 mode and breaking all users
of mode 2, this only disables the unsafe portion of mode 2 (writing to
disk). Most users of mode 2 (e.g. Chrome OS) already use a core dump
pipe handler, so this change will not break them. For the situations
where a pipe handler is not defined but mode 2 is still active, crash
dumps will no longer be written to disk, and will instead trigger a
printk yelling about the lack of the pipe handler.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v4:
 - drop mode 3 in favor of only half-breaking mode 2, requested by
   Andrew Morton.
 - yell loudly when encountering a mode 2 disk dump, suggested by
   Andrew Morton.
v3:
 - use proper sysctl _conv function, fix commit description, suggested by
  Eric W. Biederman.
v2:
 - switch to mode 3, remove mode 2, suggested by Alan Cox.
---
 Documentation/sysctl/fs.txt |   18 +++++++++++-------
 fs/exec.c                   |   37 ++++++++++++++++---------------------
 2 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
index 13d6166..d20e2ea 100644
--- a/Documentation/sysctl/fs.txt
+++ b/Documentation/sysctl/fs.txt
@@ -163,16 +163,20 @@ This value can be used to query and set the core dump mode for setuid
 or otherwise protected/tainted binaries. The modes are
 
 0 - (default) - traditional behaviour. Any process which has changed
-	privilege levels or is execute only will not be dumped
+	privilege levels or is execute only will not be dumped.
 1 - (debug) - all processes dump core when possible. The core dump is
 	owned by the current user and no security is applied. This is
 	intended for system debugging situations only. Ptrace is unchecked.
-2 - (suidsafe) - any binary which normally would not be dumped is dumped
-	readable by root only. This allows the end user to remove
-	such a dump but not access it directly. For security reasons
-	core dumps in this mode will not overwrite one another or
-	other files. This mode is appropriate when administrators are
-	attempting to debug problems in a normal environment.
+	This is insecure as it allows regular users to examine the memory
+	contents of privileged processes.
+2 - (pipeonly) - any binary which normally would not be dumped is dumped
+	anyway, but only if a core dump pipe handler is defined (see the
+	"core_pattern" kernel sysctl). This mode is appropriate when
+	administrators are attempting to debug problems in a normal
+	environment, and have a core dump pipe handler that knows to
+	treat privileged core dumps with care. If a core dump happens
+	without a pipe handler, a message will be emitted to syslog
+	warning about the lack of a pipe handler.
 
 ==============================================================
 
diff --git a/fs/exec.c b/fs/exec.c
index da27b91..715d7cf 100644
--- a/fs/exec.c
+++ b/fs/exec.c
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
+	 * We cannot trust the environment when dumping in mode 2, so only
+	 * write the dump to a pipe.
 	 */
-	if (__get_dumpable(cprm.mm_flags) == 2) {
-		/* Setuid core dump mode */
-		flag = O_EXCL;		/* Stop rewrite attacks */
-		cred->fsuid = GLOBAL_ROOT_UID;	/* Dump root private */
-	}
+	if (__get_dumpable(cprm.mm_flags) == 2)
+		pipeonly = true;
 
 	retval = coredump_wait(exit_code, &core_state);
 	if (retval < 0)
-		goto fail_creds;
-
-	old_cred = override_creds(cred);
+		goto fail;
 
 	/*
 	 * Clear any false indication of pending signals that might
@@ -2220,11 +2209,20 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	} else {
 		struct inode *inode;
 
+		if (pipeonly) {
+			printk(KERN_WARNING "Pid %d(%s) could not dump core "\
+				"without a core dump pipe handler defined "\
+				"via the core_pattern sysctl!\n",
+			       task_tgid_vnr(current), current->comm);
+			printk(KERN_WARNING "Skipping core dump\n");
+			goto fail_unlock;
+		}
+
 		if (cprm.limit < binfmt->min_coredump)
 			goto fail_unlock;
 
 		cprm.file = filp_open(cn.corename,
-				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
+				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE,
 				 0600);
 		if (IS_ERR(cprm.file))
 			goto fail_unlock;
@@ -2268,9 +2266,6 @@ fail_unlock:
 	kfree(cn.corename);
 fail_corename:
 	coredump_finish(mm);
-	revert_creds(old_cred);
-fail_creds:
-	put_cred(cred);
 fail:
 	return;
 }
-- 
1.7.0.4

