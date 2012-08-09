Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030411Ab2HIOTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:19:48 -0400
Received: from mail.lippert-at.com ([62.80.22.186]:36398 "EHLO
	domex.lippertembedded.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932419Ab2HIOTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:19:45 -0400
Message-ID: <5023C6F7.6040108@LiPPERTembedded.de>
Date: Thu, 09 Aug 2012 16:19:35 +0200
From: Jens Rottmann <JRottmann@LiPPERTembedded.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Willy Tarreau <willy@meta-x.org>
CC: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix ptrace.o compile error
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Aug 2012 14:19:41.0781 (UTC) FILETIME=[04696850:01CD763A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: fix ptrace.o compile error

Fix compiling Linux 2.6.32.59 with gcc 4.7.1 (Debian 7 testing).  Mainline has
instead removed the "asmregparm" in ptrace.c (in fact, everywhere), but this
alternative seemed too invasive.

  CC      arch/x86/kernel/ptrace.o
arch/x86/kernel/ptrace.c:1472:17: error: conflicting types for 'syscall_trace_enter'
In file included from /usr/src/linux-2.6.32/arch/x86/include/asm/vm86.h:130:0,
                 from /usr/src/linux-2.6.32/arch/x86/include/asm/processor.h:10,
                 from /usr/src/linux-2.6.32/arch/x86/include/asm/thread_info.h:22,
                 from include/linux/thread_info.h:56,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:56,
                 from arch/x86/kernel/ptrace.c:11:
/usr/src/linux-2.6.32/arch/x86/include/asm/ptrace.h:145:13: note: previous declaration of 'syscall_trace_enter' was here
arch/x86/kernel/ptrace.c:1517:17: error: conflicting types for 'syscall_trace_leave'
In file included from /usr/src/linux-2.6.32/arch/x86/include/asm/vm86.h:130:0,
                 from /usr/src/linux-2.6.32/arch/x86/include/asm/processor.h:10,
                 from /usr/src/linux-2.6.32/arch/x86/include/asm/thread_info.h:22,
                 from include/linux/thread_info.h:56,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:56,
                 from arch/x86/kernel/ptrace.c:11:
/usr/src/linux-2.6.32/arch/x86/include/asm/ptrace.h:146:13: note: previous declaration of 'syscall_trace_leave' was here
make[2]: *** [arch/x86/kernel/ptrace.o] Error 1
make[1]: *** [arch/x86/kernel] Error 2
make: *** [arch/x86] Error 2

Signed-off-by: Jens Rottmann <JRottmann@LiPPERTembedded.de>
---

--- linux-2.6.32.59/arch/x86/include/asm/ptrace.h
+++ fix_ptrace.o_compile_error/arch/x86/include/asm/ptrace.h
@@ -130,6 +130,7 @@
 #ifdef __KERNEL__
 
 #include <linux/init.h>
+#include <linux/linkage.h>
 
 struct cpuinfo_x86;
 struct task_struct;
@@ -142,8 +143,8 @@
 			 int error_code, int si_code);
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
 
-extern long syscall_trace_enter(struct pt_regs *);
-extern void syscall_trace_leave(struct pt_regs *);
+extern asmregparm long syscall_trace_enter(struct pt_regs *);
+extern asmregparm void syscall_trace_leave(struct pt_regs *);
 
 static inline unsigned long regs_return_value(struct pt_regs *regs)
 {
_
