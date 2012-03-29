Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308Ab2C2AK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 20:10:56 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24884 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609Ab2C2AKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 20:10:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6663"; a="174463036"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: Satyam Sharma <satyam@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: Fix __schedule_bug() output when called from an interrupt
Date: Wed, 28 Mar 2012 17:10:47 -0700
Message-Id: <1332979847-27102-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.10.rc2.27.g59012
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If schedule is called from an interrupt handler __schedule_bug()
will call show_regs() with the registers saved during the
interrupt handling done in do_IRQ(). This means we'll see the
registers and the backtrace for the process that was interrupted
and not the full backtrace explaining who called schedule().

This is due to 838225b (sched: use show_regs() to improve
__schedule_bug() output, 2007-10-24) which improperly assumed
that get_irq_regs() would return the registers for the current
stack because it is being called from within an interrupt
handler. Simply remove the show_reg() code so that we dump a
backtrace for the interrupt handler that called schedule().

Cc: Satyam Sharma <satyam@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

I ran across this when I was presented with a scheduling while
atomic log with a stacktrace pointing at spin_unlock_irqrestore().
It made no sense and I had to guess what interrupt handler could
be called and poke around for someone calling schedule() in an
interrupt handler. A simple test of putting an msleep() in
an interrupt handler works better with this patch because you 
can actually see the msleep() call in the backtrace.

 kernel/sched/core.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3b4e8b7..b496a0b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3101,8 +3101,6 @@ EXPORT_SYMBOL(sub_preempt_count);
  */
 static noinline void __schedule_bug(struct task_struct *prev)
 {
-	struct pt_regs *regs = get_irq_regs();
-
 	if (oops_in_progress)
 		return;
 
@@ -3113,11 +3111,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
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
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

