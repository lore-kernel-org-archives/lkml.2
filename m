Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365Ab2CVVjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:39:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42170 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab2CVVjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:39:13 -0400
Date: Thu, 22 Mar 2012 14:38:52 -0700
Message-Id: <201203222138.q2MLcqDX005416@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Additional x86 fixes for v3.4-rc1
Cc: <stable@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@hack.frob.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 22 Mar 2012 14:38:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 28f23d1f3b6a6078312b6e9585e583cc7326fe22:

  Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2012-03-22 09:44:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

The head of this tree is 29a2e2836ff9ea65a603c89df217f4198973a74f.

    --------------------

In order, these patches:

1. addresses a long-standing related when a kernel-spawned process
   gets a signal on an i386 kernel compiled without CONFIG_VM86.

2. fixes the newly introduced build warning in arch/x86/boot.

3. fixes a typo in the i386 system call table which affects building
   some libcs.

    --------------------

Dmitry Adamushko (1):
      x86-32: Fix endless loop when processing signals for kernel tasks

H. Peter Anvin (1):
      x86, boot: Correct CFLAGS for hostprogs

Thierry Reding (1):
      x86-32: Fix typo for mq_getsetattr in syscall table

 arch/x86/boot/Makefile           |    6 +++---
 arch/x86/kernel/entry_32.S       |   17 ++++++++++-------
 arch/x86/syscalls/syscall_32.tbl |    2 +-
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 3e02148..5a747dd 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -37,9 +37,9 @@ setup-y		+= video-bios.o
 targets		+= $(setup-y)
 hostprogs-y	:= mkcpustr tools/build
 
-HOSTCFLAGS_mkcpustr.o := -I$(srctree)/arch/$(SRCARCH)/include
-HOST_EXTRACFLAGS += -I$(objtree)/include -I$(srctree)/tools/include \
-                   -include $(srctree)/include/linux/kconfig.h
+HOST_EXTRACFLAGS += -I$(srctree)/tools/include $(LINUXINCLUDE) \
+	            -D__EXPORTED_HEADERS__
+
 $(obj)/cpu.o: $(obj)/cpustr.h
 
 quiet_cmd_cpustr = CPUSTR  $@
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
 
diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index ce98e28..e7e67cc 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -288,7 +288,7 @@
 279	i386	mq_timedsend		sys_mq_timedsend		compat_sys_mq_timedsend
 280	i386	mq_timedreceive		sys_mq_timedreceive		compat_sys_mq_timedreceive
 281	i386	mq_notify		sys_mq_notify			compat_sys_mq_notify
-282	i386	mq_getsetaddr		sys_mq_getsetattr		compat_sys_mq_getsetattr
+282	i386	mq_getsetattr		sys_mq_getsetattr		compat_sys_mq_getsetattr
 283	i386	kexec_load		sys_kexec_load			compat_sys_kexec_load
 284	i386	waitid			sys_waitid			compat_sys_waitid
 # 285 sys_setaltroot
