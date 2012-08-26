Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab2HZTKP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 15:10:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab2HZTJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 15:09:47 -0400
Date: Sun, 26 Aug 2012 21:12:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4/4] task_work: simplify the usage in ptrace_notify() and
	get_signal_to_deliver()
Message-ID: <20120826191217.GA4238@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120826191132.GA3743@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace_notify() and get_signal_to_deliver() do unnecessary things
before task_work_run().

1. smp_mb__after_clear_bit() is not needed, test_and_clear_bit()
   implies mb().

2. And we do not need the barrier at all, in this case we only
   care about the "synchronous" works added by the task itself.

3. No need to clear TIF_NOTIFY_RESUME, and we should not assume
   task_works is the only user of this flag.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
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
-- 
1.5.5.1

