Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab0I3J3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 05:29:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41574 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab0I3J32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 05:29:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WqSSBdbiiRUXRQl0IIVArL4HPTOQ9kkltAyReDuC9Oly2/BT7QAKLptyHG0sayVgEj
         iRmSlZ30euSv5bwRaY9nxqbHi4yK/kkuCurCfKnfIIJ5YUg2LGGbI3ACQbwr52HziABk
         9dZpN3uzFpD0xIgiw1znR/tgFOJOevc6/ZROo=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH RESEND v3 20/24] ptrace: cleanup arch_ptrace() on sh
Date: Thu, 30 Sep 2010 18:27:55 +0900
Message-Id: <1285838880-4977-21-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
References: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary castings and get rid of dummy pointer in favor of
offsetof() macro in ptrace_32.c. Also use temporary variables and
break long lines in order to improve readability.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/kernel/ptrace_32.c |   38 +++++++++++++++++++++-----------------
 arch/sh/kernel/ptrace_64.c |   19 ++++++++++++-------
 2 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/arch/sh/kernel/ptrace_32.c b/arch/sh/kernel/ptrace_32.c
index 84c217c..b791460 100644
--- a/arch/sh/kernel/ptrace_32.c
+++ b/arch/sh/kernel/ptrace_32.c
@@ -341,7 +341,6 @@ const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
-	struct user * dummy = NULL;
 	unsigned long __user *datap = (unsigned long __user *)data;
 	int ret;
 
@@ -357,17 +356,20 @@ long arch_ptrace(struct task_struct *child, long request,
 
 		if (addr < sizeof(struct pt_regs))
 			tmp = get_stack_long(child, addr);
-		else if (addr >= (unsigned long) &dummy->fpu &&
-			 addr < (unsigned long) &dummy->u_fpvalid) {
+		else if (addr >= offsetof(struct user, fpu) &&
+			 addr < offsetof(struct user, u_fpvalid)) {
 			if (!tsk_used_math(child)) {
-				if (addr == (unsigned long)&dummy->fpu.fpscr)
+				if (addr == offsetof(struct user, fpu.fpscr))
 					tmp = FPSCR_INIT;
 				else
 					tmp = 0;
-			} else
+			} else {
+				unsigned long index;
+				index = addr - offsetof(struct user, fpu);
 				tmp = ((unsigned long *)child->thread.xstate)
-					[(addr - (long)&dummy->fpu) >> 2];
-		} else if (addr == (unsigned long) &dummy->u_fpvalid)
+					[index >> 2];
+			}
+		} else if (addr == offsetof(struct user, u_fpvalid))
 			tmp = !!tsk_used_math(child);
 		else if (addr == PT_TEXT_ADDR)
 			tmp = child->mm->start_code;
@@ -391,13 +393,15 @@ long arch_ptrace(struct task_struct *child, long request,
 
 		if (addr < sizeof(struct pt_regs))
 			ret = put_stack_long(child, addr, data);
-		else if (addr >= (unsigned long) &dummy->fpu &&
-			 addr < (unsigned long) &dummy->u_fpvalid) {
+		else if (addr >= offsetof(struct user, fpu) &&
+			 addr < offsetof(struct user, u_fpvalid)) {
+			unsigned long index;
+			index = addr - offsetof(struct user, fpu);
 			set_stopped_child_used_math(child);
 			((unsigned long *)child->thread.xstate)
-				[(addr - (long)&dummy->fpu) >> 2] = data;
+				[index >> 2] = data;
 			ret = 0;
-		} else if (addr == (unsigned long) &dummy->u_fpvalid) {
+		} else if (addr == offsetof(struct user, u_fpvalid)) {
 			conditional_stopped_child_used_math(data, child);
 			ret = 0;
 		}
@@ -407,35 +411,35 @@ long arch_ptrace(struct task_struct *child, long request,
 		return copy_regset_to_user(child, &user_sh_native_view,
 					   REGSET_GENERAL,
 					   0, sizeof(struct pt_regs),
-					   (void __user *)data);
+					   datap);
 	case PTRACE_SETREGS:
 		return copy_regset_from_user(child, &user_sh_native_view,
 					     REGSET_GENERAL,
 					     0, sizeof(struct pt_regs),
-					     (const void __user *)data);
+					     datap);
 #ifdef CONFIG_SH_FPU
 	case PTRACE_GETFPREGS:
 		return copy_regset_to_user(child, &user_sh_native_view,
 					   REGSET_FPU,
 					   0, sizeof(struct user_fpu_struct),
-					   (void __user *)data);
+					   datap);
 	case PTRACE_SETFPREGS:
 		return copy_regset_from_user(child, &user_sh_native_view,
 					     REGSET_FPU,
 					     0, sizeof(struct user_fpu_struct),
-					     (const void __user *)data);
+					     datap);
 #endif
 #ifdef CONFIG_SH_DSP
 	case PTRACE_GETDSPREGS:
 		return copy_regset_to_user(child, &user_sh_native_view,
 					   REGSET_DSP,
 					   0, sizeof(struct pt_dspregs),
-					   (void __user *)data);
+					   datap);
 	case PTRACE_SETDSPREGS:
 		return copy_regset_from_user(child, &user_sh_native_view,
 					     REGSET_DSP,
 					     0, sizeof(struct pt_dspregs),
-					     (const void __user *)data);
+					     datap);
 #endif
 	default:
 		ret = ptrace_request(child, request, addr, data);
diff --git a/arch/sh/kernel/ptrace_64.c b/arch/sh/kernel/ptrace_64.c
index 1367134..1ee5ce6 100644
--- a/arch/sh/kernel/ptrace_64.c
+++ b/arch/sh/kernel/ptrace_64.c
@@ -308,6 +308,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
 	int ret;
+	unsigned long __user *datap = (unsigned long __user *) data;
 
 	switch (request) {
 	/* read the word at location addr in the USER area. */
@@ -322,13 +323,15 @@ long arch_ptrace(struct task_struct *child, long request,
 			tmp = get_stack_long(child, addr);
 		else if ((addr >= offsetof(struct user, fpu)) &&
 			 (addr <  offsetof(struct user, u_fpvalid))) {
-			tmp = get_fpu_long(child, addr - offsetof(struct user, fpu));
+			unsigned long index;
+			index = addr - offsetof(struct user, fpu);
+			tmp = get_fpu_long(child, index);
 		} else if (addr == offsetof(struct user, u_fpvalid)) {
 			tmp = !!tsk_used_math(child);
 		} else {
 			break;
 		}
-		ret = put_user(tmp, (unsigned long *)data);
+		ret = put_user(tmp, datap);
 		break;
 	}
 
@@ -359,7 +362,9 @@ long arch_ptrace(struct task_struct *child, long request,
 		}
 		else if ((addr >= offsetof(struct user, fpu)) &&
 			 (addr <  offsetof(struct user, u_fpvalid))) {
-			ret = put_fpu_long(child, addr - offsetof(struct user, fpu), data);
+			unsigned long index;
+			index = addr - offsetof(struct user, fpu);
+			ret = put_fpu_long(child, index, data);
 		}
 		break;
 
@@ -367,23 +372,23 @@ long arch_ptrace(struct task_struct *child, long request,
 		return copy_regset_to_user(child, &user_sh64_native_view,
 					   REGSET_GENERAL,
 					   0, sizeof(struct pt_regs),
-					   (void __user *)data);
+					   datap);
 	case PTRACE_SETREGS:
 		return copy_regset_from_user(child, &user_sh64_native_view,
 					     REGSET_GENERAL,
 					     0, sizeof(struct pt_regs),
-					     (const void __user *)data);
+					     datap);
 #ifdef CONFIG_SH_FPU
 	case PTRACE_GETFPREGS:
 		return copy_regset_to_user(child, &user_sh64_native_view,
 					   REGSET_FPU,
 					   0, sizeof(struct user_fpu_struct),
-					   (void __user *)data);
+					   datap);
 	case PTRACE_SETFPREGS:
 		return copy_regset_from_user(child, &user_sh64_native_view,
 					     REGSET_FPU,
 					     0, sizeof(struct user_fpu_struct),
-					     (const void __user *)data);
+					     datap);
 #endif
 	default:
 		ret = ptrace_request(child, request, addr, data);
-- 
1.7.2.2

