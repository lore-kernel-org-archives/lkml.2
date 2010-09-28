Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618Ab0I1C5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 22:57:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40267 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995Ab0I1C5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 22:57:33 -0400
Date: Tue, 28 Sep 2010 03:57:32 +0100
To: hans-christian.egtvedt@atmel.com
Subject: [PATCH 2/6] avr32: get rid of useless args in signal.c before
 other work there
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1P0QNo-0008S7-Vr@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/avr32/kernel/signal.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/avr32/kernel/signal.c b/arch/avr32/kernel/signal.c
index 64f886f..8c481fb 100644
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
@@ -273,7 +274,7 @@ int do_signal(struct pt_regs *regs, sigset_t *oldset, int syscall)
 	 * without doing anything if so.
 	 */
 	if (!user_mode(regs))
-		return 0;
+		return;
 
 	if (test_thread_flag(TIF_RESTORE_SIGMASK))
 		oldset = &current->saved_sigmask;
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


