Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965177Ab2CVV13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:27:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42088 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964911Ab2CVV11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:27:27 -0400
Date: Thu, 22 Mar 2012 14:27:13 -0700
From: tip-bot for Dmitry Adamushko <dmitry.adamushko@gmail.com>
Message-ID: <tip-29a2e2836ff9ea65a603c89df217f4198973a74f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        dmitry.adamushko@gmail.com, tglx@linutronix.de, oleg@redhat.com,
        roland@hack.frob.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        dmitry.adamushko@gmail.com, roland@hack.frob.com, tglx@linutronix.de,
        oleg@redhat.com
In-Reply-To: <1332448765.2299.68.camel@dimm>
References: <1332448765.2299.68.camel@dimm>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-32:
  Fix endless loop when processing signals for kernel tasks
Git-Commit-ID: 29a2e2836ff9ea65a603c89df217f4198973a74f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 22 Mar 2012 14:27:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  29a2e2836ff9ea65a603c89df217f4198973a74f
Gitweb:     http://git.kernel.org/tip/29a2e2836ff9ea65a603c89df217f4198973a74f
Author:     Dmitry Adamushko <dmitry.adamushko@gmail.com>
AuthorDate: Thu, 22 Mar 2012 21:39:25 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 22 Mar 2012 13:50:25 -0700

x86-32: Fix endless loop when processing signals for kernel tasks

The problem occurs on !CONFIG_VM86 kernels [1] when a kernel-mode task
returns from a system call with a pending signal.

A real-life scenario is a child of 'khelper' returning from a failed
kernel_execve() in ____call_usermodehelper() [ kernel/kmod.c ].
kernel_execve() fails due to a pending SIGKILL, which is the result of
"kill -9 -1" (at least, busybox's init does it upon reboot).

The loop is as follows:

* syscall_exit_work:
 - work_pending:            // start_of_the_loop
 - work_notify_sig:
   - do_notify_resume()
     - do_signal()
       - if (!user_mode(regs)) return;
 - resume_userspace         // TIF_SIGPENDING is still set
 - work_pending             // so we call work_pending => goto
                            // start_of_the_loop

More information can be found in another LKML thread:
http://www.serverphorums.com/read.php?12,457826

[1] the problem was also seen on MIPS.

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Link: http://lkml.kernel.org/r/1332448765.2299.68.camel@dimm
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/entry_32.S |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 79d97e6..7b784f4 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -98,12 +98,6 @@
 #endif
 .endm
 
-#ifdef CONFIG_VM86
-#define resume_userspace_sig	check_userspace
-#else
-#define resume_userspace_sig	resume_userspace
-#endif
-
 /*
  * User gs save/restore
  *
@@ -327,10 +321,19 @@ ret_from_exception:
 	preempt_stop(CLBR_ANY)
 ret_from_intr:
 	GET_THREAD_INFO(%ebp)
-check_userspace:
+resume_userspace_sig:
+#ifdef CONFIG_VM86
 	movl PT_EFLAGS(%esp), %eax	# mix EFLAGS and CS
 	movb PT_CS(%esp), %al
 	andl $(X86_EFLAGS_VM | SEGMENT_RPL_MASK), %eax
+#else
+	/*
+	 * We can be coming here from a syscall done in the kernel space,
+	 * e.g. a failed kernel_execve().
+	 */
+	movl PT_CS(%esp), %eax
+	andl $SEGMENT_RPL_MASK, %eax
+#endif
 	cmpl $USER_RPL, %eax
 	jb resume_kernel		# not returning to v8086 or userspace
 
