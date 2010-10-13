Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab0JMGWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 02:22:07 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:39074 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752787Ab0JMGWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 02:22:06 -0400
Date: Wed, 13 Oct 2010 16:20:37 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-ID: <201010130620.o9D6KbDd012911@goober.internal.moreton.com.au>
CC: <gerg@uclinux.org>
Subject: [PATCH] m68knommu: convert to using tracehook_report_syscall_*
To: <linux-kernel@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 2.1)
X-OriginalArrivalTime: 13 Oct 2010 06:22:03.0408 (UTC) FILETIME=[F3933900:01CB6A9E]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify syscall_trace() to use the tracehook_report_syscall_entry()
and tracehook_report_syscall_exit() routines.

The actual syscall_trace() call points needed updating to pass in
tne entryexit arg as well.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---
 arch/m68knommu/kernel/ptrace.c           |   26 +++++++++++---------------
 arch/m68knommu/platform/68328/entry.S    |    4 ++++
 arch/m68knommu/platform/68360/entry.S    |    4 ++++
 arch/m68knommu/platform/coldfire/entry.S |    4 ++++
 4 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/arch/m68knommu/kernel/ptrace.c b/arch/m68knommu/kernel/ptrace.c
index a32e2de..9d1900a 100644
--- a/arch/m68knommu/kernel/ptrace.c
+++ b/arch/m68knommu/kernel/ptrace.c
@@ -18,6 +18,7 @@
 #include <linux/ptrace.h>
 #include <linux/user.h>
 #include <linux/signal.h>
+#include <linux/tracehook.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -241,21 +242,16 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	return ret;
 }
 
-asmlinkage void syscall_trace(void)
+asmlinkage int syscall_trace(int entryexit)
 {
-	if (!test_thread_flag(TIF_SYSCALL_TRACE))
-		return;
-	if (!(current->ptrace & PT_PTRACED))
-		return;
-	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD)
-				 ? 0x80 : 0));
-	/*
-	 * this isn't the same as continuing with a signal, but it will do
-	 * for normal use.  strace only continues with a signal if the
-	 * stopping signal is not SIGTRAP.  -brl
-	 */
-	if (current->exit_code) {
-		send_sig(current->exit_code, current, 1);
-		current->exit_code = 0;
+	int ret = 0;
+
+	if (test_thread_flag(TIF_SYSCALL_TRACE)) {
+		if (entryexit)
+			tracehook_report_syscall_exit(task_pt_regs(current), 0);
+		else
+			ret = tracehook_report_syscall_entry(task_pt_regs(current));
 	}
+
+	return ret;
 }
diff --git a/arch/m68knommu/platform/68328/entry.S b/arch/m68knommu/platform/68328/entry.S
index b3d8d73..983370d 100644
--- a/arch/m68knommu/platform/68328/entry.S
+++ b/arch/m68knommu/platform/68328/entry.S
@@ -46,7 +46,9 @@ do_trace:
 	movel	#-ENOSYS,%sp@(PT_OFF_D0) /* needed for strace*/
 	subql	#4,%sp
 	SAVE_SWITCH_STACK
+	clrl	%sp@-
 	jbsr	syscall_trace
+	addql	#4,%sp
 	RESTORE_SWITCH_STACK
 	addql	#4,%sp
 	movel	%sp@(PT_OFF_ORIG_D0),%d1
@@ -60,7 +62,9 @@ do_trace:
 1:	movel	%d0,%sp@(PT_OFF_D0)	/* save the return value */
 	subql	#4,%sp			/* dummy return address */
 	SAVE_SWITCH_STACK
+	movel	#1,%sp@-
 	jbsr	syscall_trace
+	addql	#4,%sp
 
 ret_from_signal:
 	RESTORE_SWITCH_STACK
diff --git a/arch/m68knommu/platform/68360/entry.S b/arch/m68knommu/platform/68360/entry.S
index 5c50473..601b6c0 100644
--- a/arch/m68knommu/platform/68360/entry.S
+++ b/arch/m68knommu/platform/68360/entry.S
@@ -42,7 +42,9 @@ do_trace:
 	movel	#-ENOSYS,%sp@(PT_OFF_D0) /* needed for strace*/
 	subql	#4,%sp
 	SAVE_SWITCH_STACK
+	clrl	%sp@-
 	jbsr	syscall_trace
+	addql	#4,%sp
 	RESTORE_SWITCH_STACK
 	addql	#4,%sp
 	movel	%sp@(PT_OFF_ORIG_D0),%d1
@@ -56,7 +58,9 @@ do_trace:
 1:	movel	%d0,%sp@(PT_OFF_D0)	/* save the return value */
 	subql	#4,%sp			/* dummy return address */
 	SAVE_SWITCH_STACK
+	movel	#1,%sp@-
 	jbsr	syscall_trace
+	addql	#4,%sp
 
 ret_from_signal:
 	RESTORE_SWITCH_STACK
diff --git a/arch/m68knommu/platform/coldfire/entry.S b/arch/m68knommu/platform/coldfire/entry.S
index dd7d591..c4bbb48 100644
--- a/arch/m68knommu/platform/coldfire/entry.S
+++ b/arch/m68knommu/platform/coldfire/entry.S
@@ -88,7 +88,9 @@ ENTRY(system_call)
 	movel	%d2,PT_OFF_D0(%sp)	/* on syscall entry */
 	subql	#4,%sp
 	SAVE_SWITCH_STACK
+	clrl	%sp@-
 	jbsr	syscall_trace
+	addql	#4,%sp
 	RESTORE_SWITCH_STACK
 	addql	#4,%sp
 	movel	%d3,%a0
@@ -96,7 +98,9 @@ ENTRY(system_call)
 	movel	%d0,%sp@(PT_OFF_D0)		/* save the return value */
 	subql	#4,%sp			/* dummy return address */
 	SAVE_SWITCH_STACK
+	movel	#1,%sp@-
 	jbsr	syscall_trace
+	addql	#4,%sp
 
 ret_from_signal:
 	RESTORE_SWITCH_STACK
