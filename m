Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab2FYSD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 14:03:58 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42742 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262Ab2FYSD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:03:56 -0400
Date: Mon, 25 Jun 2012 11:03:27 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Doug Ledford <dledford@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Joe Korty <joe.korty@ccur.com>, Kees Cook <keescook@chromium.org>,
        linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v5] fs: make dumpable=2 require fully qualified path
Message-ID: <20120625180327.GA31931@www.outflux.net>
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
disk via relative path). Most users of mode 2 (e.g. Chrome OS) already
use a core dump pipe handler, so this change will not break them. For
the situations where a pipe handler is not defined but mode 2 is still
active, crash dumps will only be written to fully qualified paths. If a
relative path is defined (e.g. the default "core" pattern), dump attempts
will trigger a printk yelling about the lack of a fully qualified path.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v5:
 - allow fully qualified paths, suggested by Eric W. Biederman.
 - mention the past CVE in documentation, suggested by Rob Landley.
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
 Documentation/sysctl/fs.txt |   18 ++++++++++++------
 fs/exec.c                   |   17 ++++++++++++++---
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
index 13d6166..8c235b6 100644
--- a/Documentation/sysctl/fs.txt
+++ b/Documentation/sysctl/fs.txt
@@ -163,16 +163,22 @@ This value can be used to query and set the core dump mode for setuid
 or otherwise protected/tainted binaries. The modes are
 
 0 - (default) - traditional behaviour. Any process which has changed
-	privilege levels or is execute only will not be dumped
+	privilege levels or is execute only will not be dumped.
 1 - (debug) - all processes dump core when possible. The core dump is
 	owned by the current user and no security is applied. This is
 	intended for system debugging situations only. Ptrace is unchecked.
+	This is insecure as it allows regular users to examine the memory
+	contents of privileged processes.
 2 - (suidsafe) - any binary which normally would not be dumped is dumped
-	readable by root only. This allows the end user to remove
-	such a dump but not access it directly. For security reasons
-	core dumps in this mode will not overwrite one another or
-	other files. This mode is appropriate when administrators are
-	attempting to debug problems in a normal environment.
+	anyway, but only if the "core_pattern" kernel sysctl is set to
+	either a pipe handler or a fully qualified path. (For more details
+	on this limitation, see CVE-2006-2451.) This mode is appropriate
+	when administrators are attempting to debug problems in a normal
+	environment, and either have a core dump pipe handler that knows
+	to treat privileged core dumps with care, or specific directory
+	defined for catching core dumps. If a core dump happens without
+	a pipe handler or fully qualifid path, a message will be emitted
+	to syslog warning about the lack of a correct setting.
 
 ==============================================================
 
diff --git a/fs/exec.c b/fs/exec.c
index da27b91..a6506ba 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -2111,6 +2111,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	int retval = 0;
 	int flag = 0;
 	int ispipe;
+	bool need_nonrelative = false;
 	static atomic_t core_dump_count = ATOMIC_INIT(0);
 	struct coredump_params cprm = {
 		.signr = signr,
@@ -2136,14 +2137,16 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	if (!cred)
 		goto fail;
 	/*
-	 *	We cannot trust fsuid as being the "true" uid of the
-	 *	process nor do we know its entire history. We only know it
-	 *	was tainted so we dump it as root in mode 2.
+	 * We cannot trust fsuid as being the "true" uid of the process
+	 * nor do we know its entire history. We only know it was tainted
+	 * so we dump it as root in mode 2, and only into a controlled
+	 * environment (pipe handler or fully qualified path).
 	 */
 	if (__get_dumpable(cprm.mm_flags) == 2) {
 		/* Setuid core dump mode */
 		flag = O_EXCL;		/* Stop rewrite attacks */
 		cred->fsuid = GLOBAL_ROOT_UID;	/* Dump root private */
+		need_nonrelative = true;
 	}
 
 	retval = coredump_wait(exit_code, &core_state);
@@ -2223,6 +2226,14 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 		if (cprm.limit < binfmt->min_coredump)
 			goto fail_unlock;
 
+		if (need_nonrelative && cn.corename[0] != '/') {
+			printk(KERN_WARNING "Pid %d(%s) can only dump core "\
+				"to fully qualified path!\n",
+				task_tgid_vnr(current), current->comm);
+			printk(KERN_WARNING "Skipping core dump\n");
+			goto fail_unlock;
+		}
+
 		cprm.file = filp_open(cn.corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
 				 0600);
-- 
1.7.0.4

