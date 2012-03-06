Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671Ab2CFA53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 19:57:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35023 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932654Ab2CFA51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 19:57:27 -0500
Date: Mon, 5 Mar 2012 16:56:55 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-e7084fd52ed71249ab2ce7a7d89d601c9d1f904c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hjl.tools@gmail.com, gregory.m.lueck@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, gregory.m.lueck@intel.com, hjl.tools@gmail.com
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x32] x32: Switch to a 64-bit clock_t
Git-Commit-ID: e7084fd52ed71249ab2ce7a7d89d601c9d1f904c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Mar 2012 16:57:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7084fd52ed71249ab2ce7a7d89d601c9d1f904c
Gitweb:     http://git.kernel.org/tip/e7084fd52ed71249ab2ce7a7d89d601c9d1f904c
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 5 Mar 2012 13:40:24 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 5 Mar 2012 15:35:18 -0800

x32: Switch to a 64-bit clock_t

clock_t is used mainly to give the number of jiffies a certain process
has burned.  It is entirely feasible for a long-running process to
consume more than 2^32 jiffies especially in a multiprocess system.
As such, switch to a 64-bit clock_t for x32, just as we already
switched to a 64-bit time_t.

clock_t is only used in a handful of places, and as such it is really
not a very significant change.  The one that has the biggest impact is
in struct siginfo, but since the *size* of struct siginfo doesn't
change (it is padded to the hilt) it is fairly easy to make this a
localized change.

This also gets rid of sys_x32_times, however since this is a pretty
late change don't compactify the system call numbers; we can reuse
system call slot 521 next time we need an x32 system call.

Reported-by: Gregory M. Lueck <gregory.m.lueck@intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: H. J. Lu <hjl.tools@gmail.com>
Link: http://lkml.kernel.org/r/1329696488-16970-1-git-send-email-hpa@zytor.com
---
 arch/x86/ia32/ia32_signal.c      |   10 ++++++++--
 arch/x86/include/asm/ia32.h      |    9 +++++++++
 arch/x86/syscalls/syscall_64.tbl |    4 ++--
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 25d80f3..bc09ed2 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -37,6 +37,7 @@
 int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 {
 	int err = 0;
+	bool ia32 = !is_ia32_task();
 
 	if (!access_ok(VERIFY_WRITE, to, sizeof(compat_siginfo_t)))
 		return -EFAULT;
@@ -66,8 +67,13 @@ int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 			case __SI_FAULT >> 16:
 				break;
 			case __SI_CHLD >> 16:
-				put_user_ex(from->si_utime, &to->si_utime);
-				put_user_ex(from->si_stime, &to->si_stime);
+				if (ia32) {
+					put_user_ex(from->si_utime, &to->si_utime);
+					put_user_ex(from->si_stime, &to->si_stime);
+				} else {
+					put_user_ex(from->si_utime, &to->_sifields._sigchld_x32._utime);
+					put_user_ex(from->si_stime, &to->_sifields._sigchld_x32._stime);
+				}
 				put_user_ex(from->si_status, &to->si_status);
 				/* FALL THROUGH */
 			default:
diff --git a/arch/x86/include/asm/ia32.h b/arch/x86/include/asm/ia32.h
index c6435ab..7d0c185 100644
--- a/arch/x86/include/asm/ia32.h
+++ b/arch/x86/include/asm/ia32.h
@@ -125,6 +125,15 @@ typedef struct compat_siginfo {
 			compat_clock_t _stime;
 		} _sigchld;
 
+		/* SIGCHLD (x32 version) */
+		struct {
+			unsigned int _pid;	/* which child */
+			unsigned int _uid;	/* sender's uid */
+			int _status;		/* exit code */
+			s64 _utime;
+			s64 _stime;
+		} _sigchld_x32;
+
 		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
 		struct {
 			unsigned int _addr;	/* faulting insn/memory ref. */
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 4aecc7e..0d778b8 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -106,7 +106,7 @@
 97	common	getrlimit		sys_getrlimit
 98	common	getrusage		sys_getrusage
 99	common	sysinfo			sys_sysinfo
-100	64	times			sys_times
+100	common	times			sys_times
 101	common	ptrace			sys_ptrace
 102	common	getuid			sys_getuid
 103	common	syslog			sys_syslog
@@ -331,7 +331,7 @@
 518	x32	sendmsg			compat_sys_sendmsg
 519	x32	recvmsg			compat_sys_recvmsg
 520	x32	execve			stub_x32_execve
-521	x32	times			compat_sys_times
+# 521 available
 522	x32	rt_sigpending		sys32_rt_sigpending
 523	x32	rt_sigtimedwait		compat_sys_rt_sigtimedwait
 524	x32	rt_sigqueueinfo		sys32_rt_sigqueueinfo
