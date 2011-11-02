Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab1KBUbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:31:45 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58331 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab1KBUbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:31:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH RFC tip/core/rcu 20/28] x86: Enter rcu extended qs after idle notifier call
Date: Wed,  2 Nov 2011 13:30:41 -0700
Message-Id: <1320265849-5744-20-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-6078-0000-0000-000003EA3C9E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

The idle notifier, called by enter_idle(), enters into rcu read
side critical section but at that time we already switched into
the RCU-idle window (rcu_idle_enter() has been called). And it's
illegal to use rcu_read_lock() in that state.

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
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/x86/kernel/process_64.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index e72daf9..4a1535a 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -121,7 +121,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter_norcu();
+		tick_nohz_idle_enter();
 		while (!need_resched()) {
 
 			rmb();
@@ -137,8 +137,14 @@ void cpu_idle(void)
 			enter_idle();
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
+
+			/* enter_idle() needs rcu for notifiers */
+			rcu_idle_enter();
+
 			if (cpuidle_idle_call())
 				pm_idle();
+
+			rcu_idle_exit();
 			start_critical_timings();
 
 			/* In many cases the interrupt that ended idle
@@ -147,7 +153,7 @@ void cpu_idle(void)
 			__exit_idle();
 		}
 
-		tick_nohz_idle_exit_norcu();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
-- 
1.7.3.2

