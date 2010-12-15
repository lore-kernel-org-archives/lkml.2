Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab0LOKjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 05:39:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46802 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab0LOKjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 05:39:19 -0500
Message-Id: <E1PSolS-0008Tg-C8@ZenIV.linux.org.uk>
Date: Wed, 15 Dec 2010 10:39:18 +0000
To: hans-christian.egtvedt@atmel.com
Subject: [PATCH 2/6] avr32: get rid of useless args in signal.c before
 other work there
Cc: linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/avr32/kernel/signal.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/avr32/kernel/signal.c b/arch/avr32/kernel/signal.c
index 64f886f..df7d75c 100644
--- a/arch/avr32/kernel/signal.c
+++ b/arch/avr32/kernel/signal.c
@@ -224,7 +224,7 @@ static inline void setup_syscall_restart(struct pt_regs *regs)
 
 static inline void
 handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
-	      sigset_t *oldset, struct pt_regs *regs, int syscall)
+	      sigset_t *oldset, struct pt_regs *regs)
 {
 	int ret;
 
@@ -261,11 +261,12 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
  * doesn't want to handle. Thus you cannot kill init even with a
  * SIGKILL even by mistake.
  */
-int do_signal(struct pt_regs *regs, sigset_t *oldset, int syscall)
+static void do_signal(struct pt_regs *regs, int syscall)
 {
 	siginfo_t info;
 	int signr;
 	struct k_sigaction ka;
+	sigset_t *oldset;
 
 	/*
 	 * We want the common case to go fast, which is why we may in
@@ -273,11 +274,11 @@ int do_signal(struct pt_regs *regs, sigset_t *oldset, int syscall)
 	 * without doing anything if so.
 	 */
 	if (!user_mode(regs))
-		return 0;
+		return;
 
 	if (test_thread_flag(TIF_RESTORE_SIGMASK))
 		oldset = &current->saved_sigmask;
-	else if (!oldset)
+	else
 		oldset = &current->blocked;
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
@@ -307,11 +308,10 @@ int do_signal(struct pt_regs *regs, sigset_t *oldset, int syscall)
 			clear_thread_flag(TIF_RESTORE_SIGMASK);
 			sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
 		}
-		return 0;
+		return;
 	}
 
-	handle_signal(signr, &ka, &info, oldset, regs, syscall);
-	return 1;
+	handle_signal(signr, &ka, &info, oldset, regs);
 }
 
 asmlinkage void do_notify_resume(struct pt_regs *regs, struct thread_info *ti)
@@ -322,7 +322,7 @@ asmlinkage void do_notify_resume(struct pt_regs *regs, struct thread_info *ti)
 		syscall = 1;
 
 	if (ti->flags & (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK))
-		do_signal(regs, &current->blocked, syscall);
+		do_signal(regs, syscall);
 
 	if (ti->flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
-- 
1.5.6.5


