Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab2IBVd0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:33:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65319 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2IBVdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:33:05 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 3/7] x86: ia32_signal.c: add __user casts to fix sparse warnings
Date: Sun,  2 Sep 2012 23:31:42 +0200
Message-Id: <1346621506-30857-4-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346621506-30857-1-git-send-email-minipli@googlemail.com>
References: <1346621506-30857-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warnings by adding appropriate __user casts and
annotations:

ia32_signal.c:165:38: warning: incorrect type in argument 1 (different address spaces)
ia32_signal.c:165:38:    expected struct sigaltstack const [noderef] [usertype] <asn:1>*<noident>
ia32_signal.c:165:38:    got struct sigaltstack *
ia32_signal.c:165:54: warning: incorrect type in argument 2 (different address spaces)
ia32_signal.c:165:54:    expected struct sigaltstack [noderef] [usertype] <asn:1>*<noident>
ia32_signal.c:165:54:    got struct sigaltstack *<noident>
ia32_signal.c:386:43: warning: incorrect type in argument 1 (different address spaces)
ia32_signal.c:386:43:    expected void [noderef] <asn:1>*buf
ia32_signal.c:386:43:    got void *<noident>
ia32_signal.c:416:57: warning: incorrect type in argument 4 (different address spaces)
ia32_signal.c:416:57:    expected void **fpstate
ia32_signal.c:416:57:    got void [noderef] <asn:1>**<noident>
ia32_signal.c:451:17: warning: cast removes address space of expression
ia32_signal.c:451:17: warning: incorrect type in argument 1 (different address spaces)
ia32_signal.c:451:17:    expected void const volatile [noderef] <asn:1>*<noident>
ia32_signal.c:451:17:    got unsigned long long [usertype] *<noident>
ia32_signal.c:451:17: warning: cast removes address space of expression
ia32_signal.c:451:17: warning: cast removes address space of expression
ia32_signal.c:451:17: warning: cast removes address space of expression
ia32_signal.c:451:17: warning: cast removes address space of expression
ia32_signal.c:451:17: warning: cast removes address space of expression
ia32_signal.c:451:17: warning: cast removes address space of expression
ia32_signal.c:451:17: warning: cast removes address space of expression
ia32_signal.c:451:17: warning: cast removes address space of expression
ia32_signal.c:451:17: warning: cast removes address space of expression
ia32_signal.c:451:17: warning: cast removes address space of expression
ia32_signal.c:496:57: warning: incorrect type in argument 4 (different address spaces)
ia32_signal.c:496:57:    expected void **fpstate
ia32_signal.c:496:57:    got void [noderef] <asn:1>**<noident>
ia32_signal.c:532:17: warning: cast removes address space of expression
ia32_signal.c:532:17: warning: incorrect type in argument 1 (different address spaces)
ia32_signal.c:532:17:    expected void const volatile [noderef] <asn:1>*<noident>
ia32_signal.c:532:17:    got unsigned long long [usertype] *<noident>
ia32_signal.c:532:17: warning: cast removes address space of expression
ia32_signal.c:532:17: warning: cast removes address space of expression
ia32_signal.c:532:17: warning: cast removes address space of expression
ia32_signal.c:532:17: warning: cast removes address space of expression
ia32_signal.c:532:17: warning: cast removes address space of expression
ia32_signal.c:532:17: warning: cast removes address space of expression
ia32_signal.c:532:17: warning: cast removes address space of expression
ia32_signal.c:532:17: warning: cast removes address space of expression
ia32_signal.c:532:17: warning: cast removes address space of expression
ia32_signal.c:532:17: warning: cast removes address space of expression

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/ia32/ia32_signal.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 673ac9b..452d4dd 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -162,7 +162,8 @@ asmlinkage long sys32_sigaltstack(const stack_ia32_t __user *uss_ptr,
 	}
 	seg = get_fs();
 	set_fs(KERNEL_DS);
-	ret = do_sigaltstack(uss_ptr ? &uss : NULL, &uoss, regs->sp);
+	ret = do_sigaltstack((stack_t __force __user *) (uss_ptr ? &uss : NULL),
+			     (stack_t __force __user *) &uoss, regs->sp);
 	set_fs(seg);
 	if (ret >= 0 && uoss_ptr)  {
 		if (!access_ok(VERIFY_WRITE, uoss_ptr, sizeof(stack_ia32_t)))
@@ -361,7 +362,7 @@ static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
  */
 static void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 				 size_t frame_size,
-				 void **fpstate)
+				 void __user **fpstate)
 {
 	unsigned long sp;
 
@@ -382,7 +383,7 @@ static void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 
 	if (used_math()) {
 		sp = sp - sig_xstate_ia32_size;
-		*fpstate = (struct _fpstate_ia32 *) sp;
+		*fpstate = (struct _fpstate_ia32 __user *) sp;
 		if (save_i387_xstate_ia32(*fpstate) < 0)
 			return (void __user *) -1L;
 	}
@@ -448,7 +449,7 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 		 * These are actually not used anymore, but left because some
 		 * gdb versions depend on them as a marker.
 		 */
-		put_user_ex(*((u64 *)&code), (u64 *)frame->retcode);
+		put_user_ex(*((u64 *)&code), (u64 __user *)frame->retcode);
 	} put_user_catch(err);
 
 	if (err)
@@ -529,7 +530,7 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		 * Not actually used anymore, but left because some gdb
 		 * versions need it.
 		 */
-		put_user_ex(*((u64 *)&code), (u64 *)frame->retcode);
+		put_user_ex(*((u64 *)&code), (u64 __user *)frame->retcode);
 	} put_user_catch(err);
 
 	if (err)
-- 
1.7.10.4

