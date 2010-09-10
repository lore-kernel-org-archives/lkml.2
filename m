Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab0IJBsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 21:48:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:40159 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948Ab0IJBsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 21:48:08 -0400
Date: Fri, 10 Sep 2010 01:46:51 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        brgerst@gmail.com, penberg@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, penberg@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1283563039-3466-4-git-send-email-brgerst@gmail.com>
References: <1283563039-3466-4-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu: Merge tolerant_fwait()
Message-ID: <tip-51115d4d45700fc7c08306f7ba6e68551f526ae5@git.kernel.org>
Git-Commit-ID: 51115d4d45700fc7c08306f7ba6e68551f526ae5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Sep 2010 01:46:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  51115d4d45700fc7c08306f7ba6e68551f526ae5
Gitweb:     http://git.kernel.org/tip/51115d4d45700fc7c08306f7ba6e68551f526ae5
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Fri, 3 Sep 2010 21:17:10 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 9 Sep 2010 14:16:25 -0700

x86, fpu: Merge tolerant_fwait()

Commit e2e75c91 merged the math exception handler, allowing both 32-bit
and 64-bit to handle math exceptions from kernel mode.  Switch to using
the 64-bit version of tolerant_fwait() without fnclex, which simply
ignores the exception if one is still pending from userspace.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1283563039-3466-4-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
