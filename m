Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab2INGLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:11:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48908 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab2INGLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:11:37 -0400
Date: Thu, 13 Sep 2012 23:11:22 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-f784e8a7989c0da3062d04bfea3db90f41e8f738@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org, tglx@linutronix.de,
        oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org, tglx@linutronix.de,
        oleg@redhat.com
In-Reply-To: <20120826191217.GA4238@redhat.com>
References: <20120826191217.GA4238@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] task_work: Simplify the usage in ptrace_notify()
  and get_signal_to_deliver()
Git-Commit-ID: f784e8a7989c0da3062d04bfea3db90f41e8f738
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 23:11:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f784e8a7989c0da3062d04bfea3db90f41e8f738
Gitweb:     http://git.kernel.org/tip/f784e8a7989c0da3062d04bfea3db90f41e8f738
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 26 Aug 2012 21:12:17 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 13 Sep 2012 16:47:37 +0200

task_work: Simplify the usage in ptrace_notify() and get_signal_to_deliver()

ptrace_notify() and get_signal_to_deliver() do unnecessary things
before task_work_run():

1. smp_mb__after_clear_bit() is not needed, test_and_clear_bit()
   implies mb().

2. And we do not need the barrier at all, in this case we only
   care about the "synchronous" works added by the task itself.

3. No need to clear TIF_NOTIFY_RESUME, and we should not assume
   task_works is the only user of this flag.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20120826191217.GA4238@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/signal.c |   18 ++++--------------
 1 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index be4f856..2c681f1 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1971,13 +1971,8 @@ static void ptrace_do_notify(int signr, int exit_code, int why)
 void ptrace_notify(int exit_code)
 {
 	BUG_ON((exit_code & (0x7f | ~0xffff)) != SIGTRAP);
-	if (unlikely(current->task_works)) {
-		if (test_and_clear_ti_thread_flag(current_thread_info(),
-						   TIF_NOTIFY_RESUME)) {
-			smp_mb__after_clear_bit();
-			task_work_run();
-		}
-	}
+	if (unlikely(current->task_works))
+		task_work_run();
 
 	spin_lock_irq(&current->sighand->siglock);
 	ptrace_do_notify(SIGTRAP, exit_code, CLD_TRAPPED);
@@ -2198,13 +2193,8 @@ int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
 	struct signal_struct *signal = current->signal;
 	int signr;
 
-	if (unlikely(current->task_works)) {
-		if (test_and_clear_ti_thread_flag(current_thread_info(),
-						   TIF_NOTIFY_RESUME)) {
-			smp_mb__after_clear_bit();
-			task_work_run();
-		}
-	}
+	if (unlikely(current->task_works))
+		task_work_run();
 
 	if (unlikely(uprobe_deny_signal()))
 		return 0;
