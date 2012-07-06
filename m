Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030375Ab2GFMAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 08:00:43 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:58467 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030314Ab2GFMAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 08:00:40 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/6] rcu: Exit RCU extended QS on preemption in irq exit
Date: Fri,  6 Jul 2012 14:00:15 +0200
Message-Id: <1341576018-10721-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1341576018-10721-1-git-send-email-fweisbec@gmail.com>
References: <1341576018-10721-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Syscalls and exceptions low level handlers must be contained
between rcu_user_exit() and rcu_user_enter(). But irq high
level handlers are already protected inside rcu_irq_enter/exit()
so we don't need to call rcu_user_exit() on irq entry. But if
we preempt the running task in the end of the interrupt, we need
to exit the RCU userspace mode because schedule() itself and the
next task are in the kernel and may contain RCU read side critical
section..

To solve this, call rcu_user_exit() from irq exit preemption points:
- If we interrupted kernelspace, we call preempt_schedule_irq() and
rcu_user_exit() is called from it.

- If we interrupted userspace, we usually call schedule() directly.
Now we will rely on a new API schedule_user() which calls rcu_user_exit()
before calling schedule().

The low level irq handler may need to call rcu_user_enter() if we
resume userspace after the task is woken up from its preemption.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d5594a4..1630532 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3332,6 +3332,12 @@ asmlinkage void __sched schedule(void)
 }
 EXPORT_SYMBOL(schedule);
 
+asmlinkage void __sched schedule_user(void)
+{
+	rcu_user_exit();
+	schedule();
+}
+
 /**
  * schedule_preempt_disabled - called with preemption disabled
  *
@@ -3433,6 +3439,7 @@ asmlinkage void __sched preempt_schedule_irq(void)
 	/* Catch callers which need to be fixed */
 	BUG_ON(ti->preempt_count || !irqs_disabled());
 
+	rcu_user_exit();
 	do {
 		add_preempt_count(PREEMPT_ACTIVE);
 		local_irq_enable();
-- 
1.7.5.4

