Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788Ab2CVUjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 16:39:43 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50500 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759731Ab2CVUjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 16:39:39 -0400
Subject: [PATCH, RFC] endless loop when processing signals for kernel-space
 tasks
From: dimm <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Mar 2012 21:39:25 +0100
Message-ID: <1332448765.2299.68.camel@dimm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Adamushko <dmitry.adamushko@gmail.com>

The problem occurs on !CONFIG_VM86 kernels [1] when a kernel-mode task returns from a system call with a pending signal.

A real-life scenario is a child of 'khelper' returning from a failed kernel_execve() in ____call_usermodehelper() [ kernel/kmod.c ].
kernel_execve() fails due to a pending SIGKILL, which is the result of "kill -9 -1" (at least, busybox's init does it upon reboot).

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

More information can be found in another LKML thread: http://www.serverphorums.com/read.php?12,457826

[1] the problem was also seen on MIPS.

Thanks in advance for any feedback!


Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@zytor.com>,
CC: Roland McGrath <roland@hack.frob.com>
CC: Andrew Morton <akpm@linux-foundation.org>

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
 


