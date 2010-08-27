Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab0H0JsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:48:09 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57960 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab0H0JoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:44:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FVCgN8pnVQu+jOEGHB6c+KpLCJsVKDuQt2PDR6XTMAjd8Kiw1dYvdLhsn3FIaHnTy1
         HtDTR/w0CnGtCUgmbtBbVVOQiit59v5vH2QARDaigrktwOc9X+DJCUQLmhENx1/CzEuD
         /6UrP5fT7tMWwTu/ihrLtkhDEEC5HxuR2OJIA=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>
Subject: [RFC PATCH 22/43] ptrace, m68k: cleanup arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:08 +0900
Message-Id: <1282902149-12991-23-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use new regno, datap variables in order to remove duplicated expressions and
unnecessary castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 arch/m68k/kernel/ptrace.c |   46 ++++++++++++++++++++++----------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/m68k/kernel/ptrace.c b/arch/m68k/kernel/ptrace.c
index 583f59f..0b25268 100644
--- a/arch/m68k/kernel/ptrace.c
+++ b/arch/m68k/kernel/ptrace.c
@@ -161,51 +161,52 @@ long arch_ptrace(struct task_struct *child, long request,
 {
 	unsigned long tmp;
 	int i, ret = 0;
+	int regno = addr >> 2; /* temporary hack. */
+	unsigned long __user *datap = (unsigned long __user *) data;
 
 	switch (request) {
 	/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR:
 		if (addr & 3)
 			goto out_eio;
-		addr >>= 2;	/* temporary hack. */
 
-		if (addr >= 0 && addr < 19) {
-			tmp = get_reg(child, addr);
-		} else if (addr >= 21 && addr < 49) {
-			tmp = child->thread.fp[addr - 21];
+		if (regno >= 0 && regno < 19) {
+			tmp = get_reg(child, regno);
+		} else if (regno >= 21 && regno < 49) {
+			tmp = child->thread.fp[regno - 21];
 			/* Convert internal fpu reg representation
 			 * into long double format
 			 */
-			if (FPU_IS_EMU && (addr < 45) && !(addr % 3))
+			if (FPU_IS_EMU && (regno < 45) && !(regno % 3))
 				tmp = ((tmp & 0xffff0000) << 15) |
 				      ((tmp & 0x0000ffff) << 16);
 		} else
 			goto out_eio;
-		ret = put_user(tmp, (unsigned long *)data);
+		ret = put_user(tmp, datap);
 		break;
 
-	case PTRACE_POKEUSR:	/* write the word at location addr in the USER area */
+	case PTRACE_POKEUSR:
+	/* write the word at location addr in the USER area */
 		if (addr & 3)
 			goto out_eio;
-		addr >>= 2;	/* temporary hack. */
 
-		if (addr == PT_SR) {
+		if (regno == PT_SR) {
 			data &= SR_MASK;
 			data |= get_reg(child, PT_SR) & ~SR_MASK;
 		}
-		if (addr >= 0 && addr < 19) {
-			if (put_reg(child, addr, data))
+		if (regno >= 0 && regno < 19) {
+			if (put_reg(child, regno, data))
 				goto out_eio;
-		} else if (addr >= 21 && addr < 48) {
+		} else if (regno >= 21 && regno < 48) {
 			/* Convert long double format
 			 * into internal fpu reg representation
 			 */
-			if (FPU_IS_EMU && (addr < 45) && !(addr % 3)) {
+			if (FPU_IS_EMU && (regno < 45) && !(regno % 3)) {
 				data <<= 15;
 				data = (data & 0xffff0000) |
 				       ((data & 0x0000ffff) >> 1);
 			}
-			child->thread.fp[addr - 21] = data;
+			child->thread.fp[regno - 21] = data;
 		} else
 			goto out_eio;
 		break;
@@ -213,16 +214,16 @@ long arch_ptrace(struct task_struct *child, long request,
 	case PTRACE_GETREGS:	/* Get all gp regs from the child. */
 		for (i = 0; i < 19; i++) {
 			tmp = get_reg(child, i);
-			ret = put_user(tmp, (unsigned long *)data);
+			ret = put_user(tmp, datap);
 			if (ret)
 				break;
-			data += sizeof(unsigned long);
+			datap++;
 		}
 		break;
 
 	case PTRACE_SETREGS:	/* Set all gp regs in the child. */
 		for (i = 0; i < 19; i++) {
-			ret = get_user(tmp, (unsigned long *)data);
+			ret = get_user(tmp, datap);
 			if (ret)
 				break;
 			if (i == PT_SR) {
@@ -230,25 +231,24 @@ long arch_ptrace(struct task_struct *child, long request,
 				tmp |= get_reg(child, PT_SR) & ~SR_MASK;
 			}
 			put_reg(child, i, tmp);
-			data += sizeof(unsigned long);
+			datap++;
 		}
 		break;
 
 	case PTRACE_GETFPREGS:	/* Get the child FPU state. */
-		if (copy_to_user((void *)data, &child->thread.fp,
+		if (copy_to_user(datap, &child->thread.fp,
 				 sizeof(struct user_m68kfp_struct)))
 			ret = -EFAULT;
 		break;
 
 	case PTRACE_SETFPREGS:	/* Set the child FPU state. */
-		if (copy_from_user(&child->thread.fp, (void *)data,
+		if (copy_from_user(&child->thread.fp, datap,
 				   sizeof(struct user_m68kfp_struct)))
 			ret = -EFAULT;
 		break;
 
 	case PTRACE_GET_THREAD_AREA:
-		ret = put_user(task_thread_info(child)->tp_value,
-			       (unsigned long __user *)data);
+		ret = put_user(task_thread_info(child)->tp_value, datap);
 		break;
 
 	default:
-- 
1.7.2.2

