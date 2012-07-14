Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab2GNEMu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 00:12:50 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59802 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab2GNEMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 00:12:48 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: qmewlo@gmail.com, eparis@redhat.com, keescook@chromium.org,
        james.l.morris@oracle.com, hpa@zytor.com, cevans@chromium.org,
        luto@mit.edu, rob@landley.net, linux-doc@vger.kernel.org,
        Will Drewry <wad@chromium.org>
Subject: [PATCH v3 1/2] vsyscall: allow seccomp in vsyscall=emulate
Date: Fri, 13 Jul 2012 23:11:10 -0500
Message-Id: <1342239071-16678-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a seccomp filter program is installed, older static binaries and
distributions with older libc implementations (glibc 2.13 and earlier)
that rely on vsyscall use will be terminated regardless of the filter
program policy when executing time, gettimeofday, or getcpu.  This is
only the case when vsyscall emulation is in use (vsyscall=emulate is the
default).

This patch emulates system call entry inside a vsyscall=emulate by
populating regs->ax and regs->orig_ax with the system call number prior
to calling into seccomp such that all seccomp-dependencies function
normally.  Additionally, system call return behavior is emulated in line
with other vsyscall entrypoints for the trace/trap cases.

Note, v3 adds support for a ptracer to skip and emulate vsyscalls. This
is not required behavior but the documentation should reflect the behavior
for whichever is preferred (v2 or v3).

Reported-by: Owen Kibel <qmewlo@gmail.com>
Signed-off-by: Will Drewry <wad@chromium.org>

v3: - allow ptrace orig_ax changes to skip the syscall since changing it is not
      an option. (result of discussions with luto)
    - ensure ptrace register modification doesn't change return behavior taking
      the "normal" return path
    - add some comments
v2: - fixed ip and sp on SECCOMP_RET_TRAP/ERRNO (thanks to luto@mit.edu)
---
 arch/x86/kernel/vsyscall_64.c |   42 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 7515cf0..c56a8dc 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -139,6 +139,22 @@ static int addr_to_vsyscall_nr(unsigned long addr)
 	return nr;
 }
 
+static int vsyscall_seccomp(struct task_struct *tsk, int syscall_nr)
+{
+	int ret;
+	struct pt_regs *regs;
+	if (!seccomp_mode(&tsk->seccomp))
+		return 0;
+	regs = task_pt_regs(tsk);
+	regs->orig_ax = syscall_nr;
+	regs->ax = syscall_nr;  /* ensure consistency */
+	/* 0 if allowed, -1 on SECCOMP_RET_ERRNO and SECCOMP_RET_TRAP */
+	ret = __secure_computing(syscall_nr);
+	if (regs->orig_ax != syscall_nr)
+		return 1; /* ptrace requested skip */
+	return ret;
+}
+
 static bool write_ok_or_segv(unsigned long ptr, size_t size)
 {
 	/*
@@ -174,6 +190,7 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 	int vsyscall_nr;
 	int prev_sig_on_uaccess_error;
 	long ret;
+	int skip;
 
 	/*
 	 * No point in checking CS -- the only way to get here is a user mode
@@ -205,9 +222,6 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 	}
 
 	tsk = current;
-	if (seccomp_mode(&tsk->seccomp))
-		do_exit(SIGKILL);
-
 	/*
 	 * With a real vsyscall, page faults cause SIGSEGV.  We want to
 	 * preserve that behavior to make writing exploits harder.
@@ -222,8 +236,13 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 	 * address 0".
 	 */
 	ret = -EFAULT;
+	skip = 0;
 	switch (vsyscall_nr) {
 	case 0:
+		skip = vsyscall_seccomp(tsk, __NR_gettimeofday);
+		if (skip)
+			break;
+
 		if (!write_ok_or_segv(regs->di, sizeof(struct timeval)) ||
 		    !write_ok_or_segv(regs->si, sizeof(struct timezone)))
 			break;
@@ -234,6 +253,10 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 		break;
 
 	case 1:
+		skip = vsyscall_seccomp(tsk, __NR_time);
+		if (skip)
+			break;
+
 		if (!write_ok_or_segv(regs->di, sizeof(time_t)))
 			break;
 
@@ -241,6 +264,10 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 		break;
 
 	case 2:
+		skip = vsyscall_seccomp(tsk, __NR_getcpu);
+		if (skip)
+			break;
+
 		if (!write_ok_or_segv(regs->di, sizeof(unsigned)) ||
 		    !write_ok_or_segv(regs->si, sizeof(unsigned)))
 			break;
@@ -253,6 +280,12 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 
 	current_thread_info()->sig_on_uaccess_error = prev_sig_on_uaccess_error;
 
+	if (skip) {
+		if ((long)regs->ax <= 0L || skip == 1) /* seccomp errno/trace */
+			goto do_ret;
+		goto done; /* seccomp trap */
+	}
+
 	if (ret == -EFAULT) {
 		/* Bad news -- userspace fed a bad pointer to a vsyscall. */
 		warn_bad_vsyscall(KERN_INFO, regs,
@@ -271,10 +304,11 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 
 	regs->ax = ret;
 
+do_ret:
 	/* Emulate a ret instruction. */
 	regs->ip = caller;
 	regs->sp += 8;
-
+done:
 	return true;
 
 sigsegv:
-- 
1.7.9.5

