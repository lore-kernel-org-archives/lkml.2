Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab2CFA6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 19:58:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35033 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605Ab2CFA6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 19:58:13 -0500
Date: Mon, 5 Mar 2012 16:57:43 -0800
From: "tip-bot for H.J. Lu" <hjl.tools@gmail.com>
Message-ID: <tip-55283e2537714f9370c4ab847d170acf223daf90@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        oleg@redhat.com, roland@hack.frob.com, tglx@linutronix.de,
        hjl.tools@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, roland@hack.frob.com, oleg@redhat.com,
        hjl.tools@gmail.com
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x32] x32: Add ptrace for x32
Git-Commit-ID: 55283e2537714f9370c4ab847d170acf223daf90
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Mar 2012 16:58:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55283e2537714f9370c4ab847d170acf223daf90
Gitweb:     http://git.kernel.org/tip/55283e2537714f9370c4ab847d170acf223daf90
Author:     H.J. Lu <hjl.tools@gmail.com>
AuthorDate: Mon, 5 Mar 2012 15:32:11 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 5 Mar 2012 15:43:45 -0800

x32: Add ptrace for x32

X32 ptrace is a hybrid of 64bit ptrace and compat ptrace with 32bit
address and longs.  It use 64bit ptrace to access the full 64bit
registers.  PTRACE_PEEKUSR and PTRACE_POKEUSR are only allowed to access
segment and debug registers.  PTRACE_PEEKUSR returns the lower 32bits
and PTRACE_POKEUSR zero-extends 32bit value to 64bit.   It works since
the upper 32bits of segment and debug registers of x32 process are always
zero.  GDB only uses PTRACE_PEEKUSR and PTRACE_POKEUSR to access
segment and debug registers.

[ hpa: changed TIF_X32 test to use !is_ia32_task() instead, and moved
  the system call number to the now-unused 521 slot. ]

Signed-off-by: "H.J. Lu" <hjl.tools@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/1329696488-16970-1-git-send-email-hpa@zytor.com
---
 arch/x86/kernel/ptrace.c         |   99 ++++++++++++++++++++++++++++++++++++++
 arch/x86/syscalls/syscall_64.tbl |    4 +-
 2 files changed, 101 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 5026738..93e7877a 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1130,6 +1130,100 @@ static int genregs32_set(struct task_struct *target,
 	return ret;
 }
 
+#ifdef CONFIG_X86_X32_ABI
+static long x32_arch_ptrace(struct task_struct *child,
+			    compat_long_t request, compat_ulong_t caddr,
+			    compat_ulong_t cdata)
+{
+	unsigned long addr = caddr;
+	unsigned long data = cdata;
+	void __user *datap = compat_ptr(data);
+	int ret;
+
+	switch (request) {
+	/* Read 32bits at location addr in the USER area.  Only allow
+	   to return the lower 32bits of segment and debug registers.  */
+	case PTRACE_PEEKUSR: {
+		u32 tmp;
+
+		ret = -EIO;
+		if ((addr & (sizeof(data) - 1)) || addr >= sizeof(struct user) ||
+		    addr < offsetof(struct user_regs_struct, cs))
+			break;
+
+		tmp = 0;  /* Default return condition */
+		if (addr < sizeof(struct user_regs_struct))
+			tmp = getreg(child, addr);
+		else if (addr >= offsetof(struct user, u_debugreg[0]) &&
+			 addr <= offsetof(struct user, u_debugreg[7])) {
+			addr -= offsetof(struct user, u_debugreg[0]);
+			tmp = ptrace_get_debugreg(child, addr / sizeof(data));
+		}
+		ret = put_user(tmp, (__u32 __user *)datap);
+		break;
+	}
+
+	/* Write the word at location addr in the USER area.  Only allow
+	   to update segment and debug registers with the upper 32bits
+	   zero-extended. */
+	case PTRACE_POKEUSR:
+		ret = -EIO;
+		if ((addr & (sizeof(data) - 1)) || addr >= sizeof(struct user) ||
+		    addr < offsetof(struct user_regs_struct, cs))
+			break;
+
+		if (addr < sizeof(struct user_regs_struct))
+			ret = putreg(child, addr, data);
+		else if (addr >= offsetof(struct user, u_debugreg[0]) &&
+			 addr <= offsetof(struct user, u_debugreg[7])) {
+			addr -= offsetof(struct user, u_debugreg[0]);
+			ret = ptrace_set_debugreg(child,
+						  addr / sizeof(data), data);
+		}
+		break;
+
+	case PTRACE_GETREGS:	/* Get all gp regs from the child. */
+		return copy_regset_to_user(child,
+					   task_user_regset_view(current),
+					   REGSET_GENERAL,
+					   0, sizeof(struct user_regs_struct),
+					   datap);
+
+	case PTRACE_SETREGS:	/* Set all gp regs in the child. */
+		return copy_regset_from_user(child,
+					     task_user_regset_view(current),
+					     REGSET_GENERAL,
+					     0, sizeof(struct user_regs_struct),
+					     datap);
+
+	case PTRACE_GETFPREGS:	/* Get the child FPU state. */
+		return copy_regset_to_user(child,
+					   task_user_regset_view(current),
+					   REGSET_FP,
+					   0, sizeof(struct user_i387_struct),
+					   datap);
+
+	case PTRACE_SETFPREGS:	/* Set the child FPU state. */
+		return copy_regset_from_user(child,
+					     task_user_regset_view(current),
+					     REGSET_FP,
+					     0, sizeof(struct user_i387_struct),
+					     datap);
+
+		/* normal 64bit interface to access TLS data.
+		   Works just like arch_prctl, except that the arguments
+		   are reversed. */
+	case PTRACE_ARCH_PRCTL:
+		return do_arch_prctl(child, data, addr);
+
+	default:
+		return compat_ptrace_request(child, request, addr, data);
+	}
+
+	return ret;
+}
+#endif
+
 long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 			compat_ulong_t caddr, compat_ulong_t cdata)
 {
@@ -1139,6 +1233,11 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 	int ret;
 	__u32 val;
 
+#ifdef CONFIG_X86_X32_ABI
+	if (!is_ia32_task())
+		return x32_arch_ptrace(child, request, caddr, cdata);
+#endif
+
 	switch (request) {
 	case PTRACE_PEEKUSR:
 		ret = getreg32(child, addr, &val);
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 0d778b8..dd29a9e 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -107,7 +107,7 @@
 98	common	getrusage		sys_getrusage
 99	common	sysinfo			sys_sysinfo
 100	common	times			sys_times
-101	common	ptrace			sys_ptrace
+101	64	ptrace			sys_ptrace
 102	common	getuid			sys_getuid
 103	common	syslog			sys_syslog
 104	common	getgid			sys_getgid
@@ -331,7 +331,7 @@
 518	x32	sendmsg			compat_sys_sendmsg
 519	x32	recvmsg			compat_sys_recvmsg
 520	x32	execve			stub_x32_execve
-# 521 available
+521	x32	ptrace			compat_sys_ptrace
 522	x32	rt_sigpending		sys32_rt_sigpending
 523	x32	rt_sigtimedwait		compat_sys_rt_sigtimedwait
 524	x32	rt_sigqueueinfo		sys32_rt_sigqueueinfo
