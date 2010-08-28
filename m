Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab0H1QHS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 12:07:18 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53210 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab0H1QHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 12:07:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZHnBj0mkqtwhS+7jVp554aSUGlkD7T9uPFfaYTKyeEydxZBtQ2a9NzZUqw2/X/I2Ys
         Zqc5pFtOClkSEtvIOLcHpGMqbnWzmAFSkTvy/0kQWDAmXuaSx0lmjd6WURqwXAluc7Ps
         fOvDsG7vXIpqRy50JhxwTFW07uGqGZgvcKPsE=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/11] x86: Merge tolerant_fwait()
Date: Sat, 28 Aug 2010 12:04:30 -0400
Message-Id: <1283011478-27237-4-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that 32-bit can handle exceptions from the kernel, switch to using
the 64-bit version of tolerant_fwait() without fnclex.  In the unlikely
event an exception is triggered, it is simply ignored.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/i387.h |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index a73a8d5..5d8f9a7 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -77,15 +77,6 @@ static inline void sanitize_i387_state(struct task_struct *tsk)
 }
 
 #ifdef CONFIG_X86_64
-
-/* Ignore delayed exceptions from user space */
-static inline void tolerant_fwait(void)
-{
-	asm volatile("1: fwait\n"
-		     "2:\n"
-		     _ASM_EXTABLE(1b, 2b));
-}
-
 static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 {
 	int err;
@@ -220,11 +211,6 @@ extern void finit_soft_fpu(struct i387_soft_struct *soft);
 static inline void finit_soft_fpu(struct i387_soft_struct *soft) {}
 #endif
 
-static inline void tolerant_fwait(void)
-{
-	asm volatile("fnclex ; fwait");
-}
-
 /* perform fxrstor iff the processor has extended states, otherwise frstor */
 static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 {
@@ -344,7 +330,10 @@ static inline void __unlazy_fpu(struct task_struct *tsk)
 static inline void __clear_fpu(struct task_struct *tsk)
 {
 	if (task_thread_info(tsk)->status & TS_USEDFPU) {
-		tolerant_fwait();
+		/* Ignore delayed exceptions from user space */
+		asm volatile("1: fwait\n"
+			     "2:\n"
+			     _ASM_EXTABLE(1b, 2b));
 		task_thread_info(tsk)->status &= ~TS_USEDFPU;
 		stts();
 	}
-- 
1.7.2.2

