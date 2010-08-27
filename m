Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab0H0Joq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:44:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42423 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab0H0Jom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:44:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RvIb2tjd/LpoNyM7emJDdYakJGTra1eB0YzokpMapyuxAULqrGyPo/lMAIIqOCpQTg
         ujpDe9RwfURG0itEu2SodAY/P8GA6GUNwAilY81pd6Whgq015pC0dE8cTkHmAS36Zo7b
         BmJn0gX8UbFUr9ZXBprSERW2i38p9vvEcls04=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: [RFC PATCH 35/43] ptrace, sh: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:21 +0900
Message-Id: <1282902149-12991-36-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/kernel/ptrace_32.c |   31 +++++++++++++++----------------
 arch/sh/kernel/ptrace_64.c |   10 ++++++----
 2 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/arch/sh/kernel/ptrace_32.c b/arch/sh/kernel/ptrace_32.c
index 6c4bbba..c81a6b9 100644
--- a/arch/sh/kernel/ptrace_32.c
+++ b/arch/sh/kernel/ptrace_32.c
@@ -338,7 +338,8 @@ const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 	return &user_sh_native_view;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	struct user * dummy = NULL;
 	unsigned long __user *datap = (unsigned long __user *)data;
@@ -350,23 +351,22 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		unsigned long tmp;
 
 		ret = -EIO;
-		if ((addr & 3) || addr < 0 ||
-		    addr > sizeof(struct user) - 3)
+		if ((addr & 3) || addr > sizeof(struct user) - 3)
 			break;
 
 		if (addr < sizeof(struct pt_regs))
 			tmp = get_stack_long(child, addr);
-		else if (addr >= (long) &dummy->fpu &&
-			 addr < (long) &dummy->u_fpvalid) {
+		else if (addr >= (unsigned long) &dummy->fpu &&
+			 addr < (unsigned long) &dummy->u_fpvalid) {
 			if (!tsk_used_math(child)) {
-				if (addr == (long)&dummy->fpu.fpscr)
+				if (addr == (unsigned long)&dummy->fpu.fpscr)
 					tmp = FPSCR_INIT;
 				else
 					tmp = 0;
 			} else
-				tmp = ((long *)child->thread.xstate)
-					[(addr - (long)&dummy->fpu) >> 2];
-		} else if (addr == (long) &dummy->u_fpvalid)
+				tmp = ((unsigned long *)child->thread.xstate)
+					[(addr - (unsigned long)&dummy->fpu) >> 2];
+		} else if (addr == (unsigned long) &dummy->u_fpvalid)
 			tmp = !!tsk_used_math(child);
 		else if (addr == PT_TEXT_ADDR)
 			tmp = child->mm->start_code;
@@ -384,19 +384,18 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 
 	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
 		ret = -EIO;
-		if ((addr & 3) || addr < 0 ||
-		    addr > sizeof(struct user) - 3)
+		if ((addr & 3) || addr > sizeof(struct user) - 3)
 			break;
 
 		if (addr < sizeof(struct pt_regs))
 			ret = put_stack_long(child, addr, data);
-		else if (addr >= (long) &dummy->fpu &&
-			 addr < (long) &dummy->u_fpvalid) {
+		else if (addr >= (unsigned long) &dummy->fpu &&
+			 addr < (unsigned long) &dummy->u_fpvalid) {
 			set_stopped_child_used_math(child);
-			((long *)child->thread.xstate)
-				[(addr - (long)&dummy->fpu) >> 2] = data;
+			((unsigned long *)child->thread.xstate)
+				[(addr - (unsigned long)&dummy->fpu) >> 2] = data;
 			ret = 0;
-		} else if (addr == (long) &dummy->u_fpvalid) {
+		} else if (addr == (unsigned long) &dummy->u_fpvalid) {
 			conditional_stopped_child_used_math(data, child);
 			ret = 0;
 		}
diff --git a/arch/sh/kernel/ptrace_64.c b/arch/sh/kernel/ptrace_64.c
index 5fd644d..c2c2ed5 100644
--- a/arch/sh/kernel/ptrace_64.c
+++ b/arch/sh/kernel/ptrace_64.c
@@ -304,7 +304,8 @@ const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 	return &user_sh64_native_view;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 
@@ -314,7 +315,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		unsigned long tmp;
 
 		ret = -EIO;
-		if ((addr & 3) || addr < 0)
+		if (addr & 3)
 			break;
 
 		if (addr < sizeof(struct pt_regs))
@@ -337,7 +338,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
                    this could crash the kernel or result in a security
                    loophole. */
 		ret = -EIO;
-		if ((addr & 3) || addr < 0)
+		if (addr & 3)
 			break;
 
 		if (addr < sizeof(struct pt_regs)) {
@@ -392,7 +393,8 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	return ret;
 }
 
-asmlinkage int sh64_ptrace(long request, long pid, long addr, long data)
+asmlinkage int sh64_ptrace(long request, long pid,
+			   unsigned long addr, unsigned long data)
 {
 #define WPC_DBRMODE 0x0d104008
 	static int first_call = 1;
-- 
1.7.2.2

