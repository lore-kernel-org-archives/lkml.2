Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab0JEDt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 23:49:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62499 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab0JEDt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 23:49:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=W4m6nWDVQrtS2uo33VcKSLX6P477aD77iv8Wuo2hP0x21KY0YtAHsh35k6ltgvXl/p
         vrTl21Ukgu4Fk/1GGxAneQ+cFKNsnU+lsLx4P4O1GmX4g1nEZrAsAQa9IKEDu1doDTxq
         Kv/tfARYBaAAwIJpOu73AnEXogMzgDSYVqk5g=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>
Subject: [PATCH UPDATED] ptrace: cleanup arch_ptrace() on m68knommu
Date: Tue,  5 Oct 2010 12:49:49 +0900
Message-Id: <1286250589-3693-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20101004164205.7e8c0a66.akpm@linux-foundation.org>
References: <20101004164205.7e8c0a66.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new 'regno', 'datap' variables in order to remove duplicated
expressions and unnecessary castings. Alse remove checking @addr
less than 0 because addr is now unsigned.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
---

reworked version on top of -next. Thanks.

 arch/m68knommu/kernel/ptrace.c |   54 ++++++++++++++++++---------------------
 1 files changed, 25 insertions(+), 29 deletions(-)

diff --git a/arch/m68knommu/kernel/ptrace.c b/arch/m68knommu/kernel/ptrace.c
index 4ba708b..3defad4 100644
--- a/arch/m68knommu/kernel/ptrace.c
+++ b/arch/m68knommu/kernel/ptrace.c
@@ -115,6 +115,8 @@ long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
 	int ret;
+	int regno = addr >> 2;
+	unsigned long __user *datap = (unsigned long __user *) data;
 
 	switch (request) {
 		/* read the word at location addr in the USER area. */
@@ -122,53 +124,48 @@ long arch_ptrace(struct task_struct *child, long request,
 			unsigned long tmp;
 
 			ret = -EIO;
-			if ((addr & 3) || addr < 0 ||
-			    addr > sizeof(struct user) - 3)
+			if ((addr & 3) || addr > sizeof(struct user) - 3)
 				break;
 
 			tmp = 0;  /* Default return condition */
-			addr = addr >> 2; /* temporary hack. */
 			ret = -EIO;
-			if (addr < 19) {
-				tmp = get_reg(child, addr);
-				if (addr == PT_SR)
+			if (regno < 19) {
+				tmp = get_reg(child, regno);
+				if (regno == PT_SR)
 					tmp >>= 16;
-			} else if (addr >= 21 && addr < 49) {
-				tmp = child->thread.fp[addr - 21];
-			} else if (addr == 49) {
+			} else if (regno >= 21 && regno < 49) {
+				tmp = child->thread.fp[regno - 21];
+			} else if (regno == 49) {
 				tmp = child->mm->start_code;
-			} else if (addr == 50) {
+			} else if (regno == 50) {
 				tmp = child->mm->start_data;
-			} else if (addr == 51) {
+			} else if (regno == 51) {
 				tmp = child->mm->end_code;
 			} else
 				break;
-			ret = put_user(tmp,(unsigned long *) data);
+			ret = put_user(tmp, datap);
 			break;
 		}
 
 		case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
 			ret = -EIO;
-			if ((addr & 3) || addr < 0 ||
-			    addr > sizeof(struct user) - 3)
+			if ((addr & 3) || addr > sizeof(struct user) - 3)
 				break;
 
-			addr = addr >> 2; /* temporary hack. */
-
-			if (addr == PT_SR) {
+			if (regno == PT_SR) {
 				data &= SR_MASK;
 				data <<= 16;
 				data |= get_reg(child, PT_SR) & ~(SR_MASK << 16);
 			}
-			if (addr < 19) {
-				if (put_reg(child, addr, data))
+			if (regno < 19) {
+				if (put_reg(child, regno, data))
 					break;
 				ret = 0;
 				break;
 			}
-			if (addr >= 21 && addr < 48)
+			if (regno >= 21 && regno < 48)
 			{
-				child->thread.fp[addr - 21] = data;
+				child->thread.fp[regno - 21] = data;
 				ret = 0;
 			}
 			break;
@@ -180,11 +177,11 @@ long arch_ptrace(struct task_struct *child, long request,
 			    tmp = get_reg(child, i);
 			    if (i == PT_SR)
 				tmp >>= 16;
-			    if (put_user(tmp, (unsigned long *) data)) {
+			    if (put_user(tmp, datap)) {
 				ret = -EFAULT;
 				break;
 			    }
-			    data += sizeof(unsigned long);
+			    datap++;
 			}
 			ret = 0;
 			break;
@@ -194,7 +191,7 @@ long arch_ptrace(struct task_struct *child, long request,
 			int i;
 			unsigned long tmp;
 			for (i = 0; i < 19; i++) {
-			    if (get_user(tmp, (unsigned long *) data)) {
+			    if (get_user(tmp, datap)) {
 				ret = -EFAULT;
 				break;
 			    }
@@ -204,7 +201,7 @@ long arch_ptrace(struct task_struct *child, long request,
 				tmp |= get_reg(child, PT_SR) & ~(SR_MASK << 16);
 			    }
 			    put_reg(child, i, tmp);
-			    data += sizeof(unsigned long);
+			    datap++;
 			}
 			ret = 0;
 			break;
@@ -213,7 +210,7 @@ long arch_ptrace(struct task_struct *child, long request,
 #ifdef PTRACE_GETFPREGS
 		case PTRACE_GETFPREGS: { /* Get the child FPU state. */
 			ret = 0;
-			if (copy_to_user((void *)data, &child->thread.fp,
+			if (copy_to_user(datap, &child->thread.fp,
 					 sizeof(struct user_m68kfp_struct)))
 				ret = -EFAULT;
 			break;
@@ -223,7 +220,7 @@ long arch_ptrace(struct task_struct *child, long request,
 #ifdef PTRACE_SETFPREGS
 		case PTRACE_SETFPREGS: { /* Set the child FPU state. */
 			ret = 0;
-			if (copy_from_user(&child->thread.fp, (void *)data,
+			if (copy_from_user(&child->thread.fp, datap,
 					   sizeof(struct user_m68kfp_struct)))
 				ret = -EFAULT;
 			break;
@@ -231,8 +228,7 @@ long arch_ptrace(struct task_struct *child, long request,
 #endif
 
 	case PTRACE_GET_THREAD_AREA:
-		ret = put_user(task_thread_info(child)->tp_value,
-			       (unsigned long __user *)data);
+		ret = put_user(task_thread_info(child)->tp_value, datap);
 		break;
 
 		default:
-- 
1.7.0.4

