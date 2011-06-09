Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab1FIXsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 19:48:20 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56445 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab1FIXr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 19:47:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PBQe71asnRURpxHVDOqCHbRHhwpnnKXbyN9zVG3xnFKGhl5ebyN2EVvWljZF1GuXHW
         ysy3PS9dfGviAzPCHWbVV4eIT+jiA9IGP/k8ptGPgBBD136k19t5ghtK3pwlBNCxnbuR
         OEkiHX6MUNe2PlBW6HIg7q3JBSvB/o8FpiMqg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/4] x86: Don't call idle notifier inside rcu extended QS
Date: Fri, 10 Jun 2011 01:47:26 +0200
Message-Id: <1307663247-5397-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1307663247-5397-1-git-send-email-fweisbec@gmail.com>
References: <1307663247-5397-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idle notifier in enter_idle / __exit_idle is called
inside the RCU extended quiescent state.

This results in the following warning:

[    2.081278] ===================================================
[    2.081281] [ INFO: suspicious rcu_dereference_check() usage. ]
[    2.081282] ---------------------------------------------------
[    2.081284] kernel/notifier.c:81 invoked rcu_dereference_check() while in RCU extended quiescent state!
[    2.081286]
[    2.081287] other info that might help us debug this:
[    2.081288]
[    2.081289]
[    2.081289] rcu_scheduler_active = 1, debug_locks = 0
[    2.081292] 1 lock held by kworker/0:0/0:
[    2.081293]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff81785c60>] __atomic_notifier_call_chain+0x0/0xa0
[    2.081301]
[    2.081302] stack backtrace:
[    2.081305] Pid: 0, comm: kworker/0:0 Not tainted 3.0.0-rc1+ #103
[    2.081307] Call Trace:
[    2.081313]  [<ffffffff8108e0e4>] lockdep_rcu_dereference+0xd4/0x100
[    2.081316]  [<ffffffff81785c4a>] notifier_call_chain+0x13a/0x150
[    2.081319]  [<ffffffff81785cc7>] __atomic_notifier_call_chain+0x67/0xa0
[    2.081322]  [<ffffffff81785c60>] ? notifier_call_chain+0x150/0x150
[    2.081325]  [<ffffffff81785d11>] atomic_notifier_call_chain+0x11/0x20
[    2.081329]  [<ffffffff8100afa0>] enter_idle+0x20/0x30
[    2.081332]  [<ffffffff8100b05e>] cpu_idle+0xae/0x100
[    2.081335]  [<ffffffff8177951f>] start_secondary+0x1cf/0x1d6

Fix this by entering RCU extended QS later, after we call the
notifier. Exit it also sooner to call the exit idle notifier.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/process_64.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3fe0883..a8bd222 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -120,7 +120,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_enter_idle();
+		tick_nohz_stop_sched_tick(1);
 		while (!need_resched()) {
 
 			rmb();
@@ -134,18 +134,23 @@ void cpu_idle(void)
 			 */
 			local_irq_disable();
 			enter_idle();
+			/*
+			 * We can't enter extended QS before due to idle
+			 * notifier that uses RCU.
+			 */
+			rcu_enter_nohz();
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
 			pm_idle();
 			start_critical_timings();
-
+			rcu_exit_nohz();
 			/* In many cases the interrupt that ended idle
 			   has already called exit_idle. But some idle
 			   loops can be woken up without interrupt. */
 			__exit_idle();
 		}
 
-		tick_nohz_exit_idle();
+		tick_nohz_restart_sched_tick();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
-- 
1.7.5.4

