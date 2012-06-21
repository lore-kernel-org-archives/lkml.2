Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab2FUTnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 15:43:46 -0400
Received: from smtp.outflux.net ([198.145.64.163]:41521 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488Ab2FUTno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 15:43:44 -0400
Date: Thu, 21 Jun 2012 12:43:19 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>, Marcel Holtmann <marcel@holtmann.org>,
        Doug Ledford <dledford@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Joe Korty <joe.korty@ccur.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] fs: make dumpable=2 only write to a pipe
Message-ID: <20120621194319.GA5961@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the suid_dumpable sysctl is set to "2", and there is no
core dump pipe defined in the core_pattern sysctl, a local user
can cause core files to be written to root-writable directories,
potentially with user-controlled content. This means an admin
can unknowningly reintroduce a variation of CVE-2006-2451 (see
abf75a5033d4da7b8a7e92321d74021d1fcfb502).

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
$ pid=$1
$ sleep 1
$ kill -SEGV $pid
$ ls -l core
-rw------- 1 root kees 458752 Jun 21 11:35 core
$ sudo strings core | grep evil
OHAI=evil-string-here

While cron has been fixed to abort reading a file when there is any
parse error, there are still other sensitive directories that will read
any file present and skip unparsable lines.

This patch changes dumpable=2 to not allow writing to disk at all. Crashes
in this mode may only be collected through the core_pattern pipe handler.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/sysctl/fs.txt |   11 +++++------
 fs/exec.c                   |   31 ++++++++++---------------------
 2 files changed, 15 insertions(+), 27 deletions(-)

diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
index 13d6166..70650d0 100644
--- a/Documentation/sysctl/fs.txt
+++ b/Documentation/sysctl/fs.txt
@@ -167,12 +167,11 @@ or otherwise protected/tainted binaries. The modes are
 1 - (debug) - all processes dump core when possible. The core dump is
 	owned by the current user and no security is applied. This is
 	intended for system debugging situations only. Ptrace is unchecked.
-2 - (suidsafe) - any binary which normally would not be dumped is dumped
-	readable by root only. This allows the end user to remove
-	such a dump but not access it directly. For security reasons
-	core dumps in this mode will not overwrite one another or
-	other files. This mode is appropriate when administrators are
-	attempting to debug problems in a normal environment.
+2 - (pipeonly) - any binary which normally would not be dumped is dumped
+	anyway, but only if a core dump pipe handler is defined (see the
+	"core_pattern" kernel sysctl). This mode is appropriate when
+	administrators are attempting to debug problems in a normal
+	environment.
 
 ==============================================================
 
diff --git a/fs/exec.c b/fs/exec.c
index a79786a..0cd2eb9 100644
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
-- 
1.7.0.4

-- 
Kees Cook
Chrome OS Security
