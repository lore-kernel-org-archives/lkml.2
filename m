Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab0EACzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 22:55:48 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:58932 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759243Ab0EACyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 22:54:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=OEFKl15h7WZxOsXsdnpfhAJ95zQ2Sjl9Yf9HY0wrflIBjulkpSYcWjdzLGGva0WaEk
         ZftpOxFpuZUPaBmbOp+Qh/lRnkN5i2WkhIZQYFMBw3yB2Yo33jEgCDP+MGmhSLBGBB7l
         txOofekl0i99IlZ+RDYtyQgwF0qzQ1WsP5Hb0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Will Deacon <will.deacon@arm.com>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 5/8] hw-breakpoints: Change/Enforce some breakpoints policies
Date: Sat,  1 May 2010 04:53:52 +0200
Message-Id: <1272682436-10682-6-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1272682436-10682-1-git-send-regression-fweisbec@gmail.com>
References: <1272682436-10682-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current policies of breakpoints in x86 and SH are the following:

- task bound breakpoints can only break on userspace addresses
- cpu wide breakpoints can only break on kernel addresses

The former rule prevents ptrace breakpoints to be set to trigger on
kernel addresses, which is good. But as a side effect, we can't
breakpoint on kernel addresses for task bound breakpoints.

The latter rule simply makes no sense, there is no reason why we
can't set breakpoints on userspace while performing cpu bound
profiles.

We want the following new policies:

- task bound breakpoint can set userspace address breakpoints, with
no particular privilege required.
- task bound breakpoints can set kernelspace address breakpoints but
must be privileged to do that.
- cpu bound breakpoints can do what they want as they are privileged
already.

To implement these new policies, this patch checks if we are dealing
with a kernel address breakpoint, if so and if the exclude_kernel
parameter is set, we tell the user that the breakpoint is invalid,
which makes a good generic ptrace protection.
If we don't have exclude_kernel, ensure the user has the right
privileges as kernel breakpoints are quite sensitive (risk of
trap recursion attacks and global performance impacts).

[ Paul Mundt: keep addr space check for sh signal delivery and fix
  double function declaration]

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: K. Prasad <prasad@linux.vnet.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/include/asm/hw_breakpoint.h  |    5 +--
 arch/sh/kernel/hw_breakpoint.c       |   34 +++++----------------------
 arch/x86/include/asm/hw_breakpoint.h |    5 +--
 arch/x86/kernel/hw_breakpoint.c      |   41 +++++-----------------------------
 kernel/hw_breakpoint.c               |   26 +++++++++++++++++++-
 5 files changed, 41 insertions(+), 70 deletions(-)

diff --git a/arch/sh/include/asm/hw_breakpoint.h b/arch/sh/include/asm/hw_breakpoint.h
index 965dd78..382bad9 100644
--- a/arch/sh/include/asm/hw_breakpoint.h
+++ b/arch/sh/include/asm/hw_breakpoint.h
@@ -47,9 +47,8 @@ struct pmu;
 #define HBP_NUM		2
 
 /* arch/sh/kernel/hw_breakpoint.c */
-extern int arch_check_va_in_userspace(unsigned long va, u16 hbp_len);
-extern int arch_validate_hwbkpt_settings(struct perf_event *bp,
-					 struct task_struct *tsk);
+extern int arch_check_bp_in_kernelspace(struct perf_event *bp);
+extern int arch_validate_hwbkpt_settings(struct perf_event *bp);
 extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
 					   unsigned long val, void *data);
 
diff --git a/arch/sh/kernel/hw_breakpoint.c b/arch/sh/kernel/hw_breakpoint.c
index 675eea7..1f2cf62 100644
--- a/arch/sh/kernel/hw_breakpoint.c
+++ b/arch/sh/kernel/hw_breakpoint.c
@@ -120,25 +120,16 @@ static int get_hbp_len(u16 hbp_len)
 }
 
 /*
- * Check for virtual address in user space.
- */
-int arch_check_va_in_userspace(unsigned long va, u16 hbp_len)
-{
-	unsigned int len;
-
-	len = get_hbp_len(hbp_len);
-
-	return (va <= TASK_SIZE - len);
-}
-
-/*
  * Check for virtual address in kernel space.
  */
-static int arch_check_va_in_kernelspace(unsigned long va, u8 hbp_len)
+int arch_check_bp_in_kernelspace(struct perf_event *bp)
 {
 	unsigned int len;
+	unsigned long va;
+	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
 
-	len = get_hbp_len(hbp_len);
+	va = info->address;
+	len = get_hbp_len(info->len);
 
 	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
 }
@@ -226,8 +217,7 @@ static int arch_build_bp_info(struct perf_event *bp)
 /*
  * Validate the arch-specific HW Breakpoint register settings
  */
-int arch_validate_hwbkpt_settings(struct perf_event *bp,
-				  struct task_struct *tsk)
+int arch_validate_hwbkpt_settings(struct perf_event *bp)
 {
 	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
 	unsigned int align;
@@ -270,15 +260,6 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp,
 	if (info->address & align)
 		return -EINVAL;
 
-	/* Check that the virtual address is in the proper range */
-	if (tsk) {
-		if (!arch_check_va_in_userspace(info->address, info->len))
-			return -EFAULT;
-	} else {
-		if (!arch_check_va_in_kernelspace(info->address, info->len))
-			return -EFAULT;
-	}
-
 	return 0;
 }
 
@@ -363,8 +344,7 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
 		perf_bp_event(bp, args->regs);
 
 		/* Deliver the signal to userspace */
-		if (arch_check_va_in_userspace(bp->attr.bp_addr,
-					       bp->attr.bp_len)) {
+		if (!arch_check_bp_in_kernelspace(bp)) {
 			siginfo_t info;
 
 			info.si_signo = args->signr;
diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index 2a1bd8f..c77a5a6 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -44,9 +44,8 @@ struct arch_hw_breakpoint {
 struct perf_event;
 struct pmu;
 
-extern int arch_check_va_in_userspace(unsigned long va, u8 hbp_len);
-extern int arch_validate_hwbkpt_settings(struct perf_event *bp,
-					 struct task_struct *tsk);
+extern int arch_check_bp_in_kernelspace(struct perf_event *bp);
+extern int arch_validate_hwbkpt_settings(struct perf_event *bp);
 extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
 					   unsigned long val, void *data);
 
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index d6cc065..a8f1b80 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -189,25 +189,16 @@ static int get_hbp_len(u8 hbp_len)
 }
 
 /*
- * Check for virtual address in user space.
- */
-int arch_check_va_in_userspace(unsigned long va, u8 hbp_len)
-{
-	unsigned int len;
-
-	len = get_hbp_len(hbp_len);
-
-	return (va <= TASK_SIZE - len);
-}
-
-/*
  * Check for virtual address in kernel space.
  */
-static int arch_check_va_in_kernelspace(unsigned long va, u8 hbp_len)
+int arch_check_bp_in_kernelspace(struct perf_event *bp)
 {
 	unsigned int len;
+	unsigned long va;
+	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
 
-	len = get_hbp_len(hbp_len);
+	va = info->address;
+	len = get_hbp_len(info->len);
 
 	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
 }
@@ -300,8 +291,7 @@ static int arch_build_bp_info(struct perf_event *bp)
 /*
  * Validate the arch-specific HW Breakpoint register settings
  */
-int arch_validate_hwbkpt_settings(struct perf_event *bp,
-				  struct task_struct *tsk)
+int arch_validate_hwbkpt_settings(struct perf_event *bp)
 {
 	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
 	unsigned int align;
@@ -314,16 +304,6 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp,
 
 	ret = -EINVAL;
 
-	if (info->type == X86_BREAKPOINT_EXECUTE)
-		/*
-		 * Ptrace-refactoring code
-		 * For now, we'll allow instruction breakpoint only for user-space
-		 * addresses
-		 */
-		if ((!arch_check_va_in_userspace(info->address, info->len)) &&
-			info->len != X86_BREAKPOINT_EXECUTE)
-			return ret;
-
 	switch (info->len) {
 	case X86_BREAKPOINT_LEN_1:
 		align = 0;
@@ -350,15 +330,6 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp,
 	if (info->address & align)
 		return -EINVAL;
 
-	/* Check that the virtual address is in the proper range */
-	if (tsk) {
-		if (!arch_check_va_in_userspace(info->address, info->len))
-			return -EFAULT;
-	} else {
-		if (!arch_check_va_in_kernelspace(info->address, info->len))
-			return -EFAULT;
-	}
-
 	return 0;
 }
 
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 9ed9ae3..89e8a05 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -308,6 +308,28 @@ int dbg_release_bp_slot(struct perf_event *bp)
 	return 0;
 }
 
+static int validate_hw_breakpoint(struct perf_event *bp)
+{
+	int ret;
+
+	ret = arch_validate_hwbkpt_settings(bp);
+	if (ret)
+		return ret;
+
+	if (arch_check_bp_in_kernelspace(bp)) {
+		if (bp->attr.exclude_kernel)
+			return -EINVAL;
+		/*
+		 * Don't let unprivileged users set a breakpoint in the trap
+		 * path to avoid trap recursion attacks.
+		 */
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+	}
+
+	return 0;
+}
+
 int register_perf_hw_breakpoint(struct perf_event *bp)
 {
 	int ret;
@@ -316,7 +338,7 @@ int register_perf_hw_breakpoint(struct perf_event *bp)
 	if (ret)
 		return ret;
 
-	ret = arch_validate_hwbkpt_settings(bp, bp->ctx->task);
+	ret = validate_hw_breakpoint(bp);
 
 	/* if arch_validate_hwbkpt_settings() fails then release bp slot */
 	if (ret)
@@ -363,7 +385,7 @@ int modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *att
 	if (attr->disabled)
 		goto end;
 
-	err = arch_validate_hwbkpt_settings(bp, bp->ctx->task);
+	err = validate_hw_breakpoint(bp);
 	if (!err)
 		perf_event_enable(bp);
 
-- 
1.6.2.3

