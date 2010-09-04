Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab0IDBSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 21:18:21 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59457 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab0IDBRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 21:17:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FJfIR+7LjT05lGrhhRIU4TPRINswVe2n2F3yaApupV8U0KEKR9OAeBvKsGmVK9MM2u
         xYzaDq1FZarYmBy71nwvk35G9a8G7RlgQMq+/dN6EWQtyHUgJFW/f87mWiqwK3fs16ap
         6L3PpRUxkiKm+paCRcadfD0S7Ksk8MMx2pEsc=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, penberg@kernel.org
Subject: [PATCH 03/12] x86: Merge tolerant_fwait()
Date: Fri,  3 Sep 2010 21:17:10 -0400
Message-Id: <1283563039-3466-4-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283563039-3466-1-git-send-email-brgerst@gmail.com>
References: <1283563039-3466-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e2e75c91 merged the math exception handler, allowing both 32-bit
and 64-bit to handle math exceptions from kernel mode.  Switch to using
the 64-bit version of tolerant_fwait() without fnclex, which simply
ignores the exception if one is still pending from userspace.

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

