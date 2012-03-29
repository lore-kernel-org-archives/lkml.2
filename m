Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230Ab2C2HRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 03:17:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33278 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab2C2HRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 03:17:02 -0400
Date: Thu, 29 Mar 2012 00:16:33 -0700
From: tip-bot for Stephen Boyd <sboyd@codeaurora.org>
Message-ID: <tip-6135fc1eb4b1c9ae5f535507ed59591bab51e630@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, cmetcalf@tilera.com, sboyd@codeaurora.org,
        satyam@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        satyam@infradead.org, peterz@infradead.org, cmetcalf@tilera.com,
        tglx@linutronix.de, sboyd@codeaurora.org
In-Reply-To: <1332979847-27102-1-git-send-email-sboyd@codeaurora.org>
References: <1332979847-27102-1-git-send-email-sboyd@codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix __schedule_bug()
  output when called from an interrupt
Git-Commit-ID: 6135fc1eb4b1c9ae5f535507ed59591bab51e630
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 29 Mar 2012 00:16:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6135fc1eb4b1c9ae5f535507ed59591bab51e630
Gitweb:     http://git.kernel.org/tip/6135fc1eb4b1c9ae5f535507ed59591bab51e630
Author:     Stephen Boyd <sboyd@codeaurora.org>
AuthorDate: Wed, 28 Mar 2012 17:10:47 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 29 Mar 2012 08:34:45 +0200

sched: Fix __schedule_bug() output when called from an interrupt

If schedule is called from an interrupt handler __schedule_bug()
will call show_regs() with the registers saved during the
interrupt handling done in do_IRQ(). This means we'll see the
registers and the backtrace for the process that was interrupted
and not the full backtrace explaining who called schedule().

This is due to 838225b ("sched: use show_regs() to improve
__schedule_bug() output", 2007-10-24) which improperly assumed
that get_irq_regs() would return the registers for the current
stack because it is being called from within an interrupt
handler. Simply remove the show_reg() code so that we dump a
backtrace for the interrupt handler that called schedule().

[ I ran across this when I was presented with a scheduling while
  atomic log with a stacktrace pointing at spin_unlock_irqrestore().
  It made no sense and I had to guess what interrupt handler could
  be called and poke around for someone calling schedule() in an
  interrupt handler. A simple test of putting an msleep() in
  an interrupt handler works better with this patch because you
  can actually see the msleep() call in the backtrace. ]

Also-reported-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Satyam Sharma <satyam@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1332979847-27102-1-git-send-email-sboyd@codeaurora.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9c1629c..929fd85 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3099,8 +3099,6 @@ EXPORT_SYMBOL(sub_preempt_count);
  */
 static noinline void __schedule_bug(struct task_struct *prev)
 {
-	struct pt_regs *regs = get_irq_regs();
-
 	if (oops_in_progress)
 		return;
 
@@ -3111,11 +3109,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
 	print_modules();
 	if (irqs_disabled())
 		print_irqtrace_events(prev);
-
-	if (regs)
-		show_regs(regs);
-	else
-		dump_stack();
+	dump_stack();
 }
 
 /*
