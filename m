Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549Ab2IEK4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:56:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56266 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab2IEK4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:56:33 -0400
Date: Wed, 5 Sep 2012 03:56:21 -0700
From: tip-bot for Mathias Krause <minipli@googlemail.com>
Message-ID: <tip-0ff8fef4eaf252ee13a2d0b175a8c876415bd62a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        minipli@googlemail.com, oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        minipli@googlemail.com, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <1346621506-30857-4-git-send-email-minipli@googlemail.com>
References: <1346621506-30857-4-git-send-email-minipli@googlemail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86/signals: ia32_signal.c:
  add __user casts to fix sparse warnings
Git-Commit-ID: 0ff8fef4eaf252ee13a2d0b175a8c876415bd62a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 05 Sep 2012 03:56:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ff8fef4eaf252ee13a2d0b175a8c876415bd62a
Gitweb:     http://git.kernel.org/tip/0ff8fef4eaf252ee13a2d0b175a8c876415bd62a
Author:     Mathias Krause <minipli@googlemail.com>
AuthorDate: Sun, 2 Sep 2012 23:31:42 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 5 Sep 2012 10:52:24 +0200

x86/signals: ia32_signal.c: add __user casts to fix sparse warnings

Fix the following sparse warnings by adding appropriate __user
casts and annotations:

  ia32_signal.c:165:38: warning: incorrect type in argument 1 (different address spaces)
   ia32_signal.c:165:38:    expected struct sigaltstack const [noderef] [usertype] <asn:1>*<noident>
  ia32_signal.c:165:38:    got struct sigaltstack *
  [...]

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/1346621506-30857-4-git-send-email-minipli@googlemail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/ia32/ia32_signal.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

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
