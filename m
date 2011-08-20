Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab1HTRbW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 13:31:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54864 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab1HTRbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 13:31:13 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/4] x86: Enter rcu extended qs after idle notifier call
Date: Sat, 20 Aug 2011 19:30:50 +0200
Message-Id: <1313861452-24783-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313861452-24783-1-git-send-email-fweisbec@gmail.com>
References: <1313861452-24783-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idle notifier, called by enter_idle(), enters into rcu read
side critical section but at that time we already switched into
rcu dynticks idle mode. And it's illegal to use rcu_read_lock()
in that state.

This results in rcu reporting its bad mood:

[    1.275635] WARNING: at include/linux/rcupdate.h:194 __atomic_notifier_call_chain+0xd2/0x110()
[    1.275635] Hardware name: AMD690VM-FMH
[    1.275635] Modules linked in:
[    1.275635] Pid: 0, comm: swapper Not tainted 3.0.0-rc6+ #252
[    1.275635] Call Trace:
[    1.275635]  [<ffffffff81051c8a>] warn_slowpath_common+0x7a/0xb0
[    1.275635]  [<ffffffff81051cd5>] warn_slowpath_null+0x15/0x20
[    1.275635]  [<ffffffff817d6f22>] __atomic_notifier_call_chain+0xd2/0x110
[    1.275635]  [<ffffffff817d6f71>] atomic_notifier_call_chain+0x11/0x20
[    1.275635]  [<ffffffff810018a0>] enter_idle+0x20/0x30
[    1.275635]  [<ffffffff81001995>] cpu_idle+0xa5/0x110
[    1.275635]  [<ffffffff817a7465>] rest_init+0xe5/0x140
[    1.275635]  [<ffffffff817a73c8>] ? rest_init+0x48/0x140
[    1.275635]  [<ffffffff81cc5ca3>] start_kernel+0x3d1/0x3dc
[    1.275635]  [<ffffffff81cc5321>] x86_64_start_reservations+0x131/0x135
[    1.275635]  [<ffffffff81cc5412>] x86_64_start_kernel+0xed/0xf4
[    1.275635] ---[ end trace a22d306b065d4a66 ]---

Fix this by entering rcu extended quiescent state later, just before
the CPU goes to sleep.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/process_64.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3d56f0d..1efd185 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -120,7 +120,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_enter_idle(true);
+		tick_nohz_enter_idle(false);
 		while (!need_resched()) {
 
 			rmb();
@@ -136,7 +136,12 @@ void cpu_idle(void)
 			enter_idle();
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
+
+			/* enter_idle() needs rcu for notifiers */
+			rcu_enter_nohz();
 			pm_idle();
+			rcu_exit_nohz();
+
 			start_critical_timings();
 
 			/* In many cases the interrupt that ended idle
@@ -145,7 +150,7 @@ void cpu_idle(void)
 			__exit_idle();
 		}
 
-		tick_nohz_exit_idle(true);
+		tick_nohz_exit_idle(false);
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
-- 
1.7.5.4

