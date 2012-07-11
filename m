Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300Ab2GKS1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 14:27:32 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47918 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549Ab2GKS10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 14:27:26 -0400
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
Subject: [PATCH 07/11] rcu: Exit RCU extended QS on kernel preemption after irq/exception
Date: Wed, 11 Jul 2012 20:26:36 +0200
Message-Id: <1342031200-22731-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1342031200-22731-1-git-send-email-fweisbec@gmail.com>
References: <1342031200-22731-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an exception or an irq exits, and we are going to resume into
interrupted kernel code, the low level architecture code calls
preempt_schedule_irq() if there is a need to reschedule.

If the interrupt/exception occured between a call to rcu_user_enter()
(from syscall exit, exception exit, do_notify_resume exit, ...) and
a real resume to userspace (iret,...), preempt_schedule_irq() can be
called whereas RCU thinks we are in userspace. But preempt_schedule_irq()
is going to run kernel code and may be some RCU read side critical
section. We must exit the userspace extended quiescent state before
we call it.

To solve this, just call rcu_user_exit() in the beginning of
preempt_schedule_irq().

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
 kernel/sched/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fa61d8a..1e0fa5b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3433,6 +3433,7 @@ asmlinkage void __sched preempt_schedule_irq(void)
 	/* Catch callers which need to be fixed */
 	BUG_ON(ti->preempt_count || !irqs_disabled());
 
+	rcu_user_exit();
 	do {
 		add_preempt_count(PREEMPT_ACTIVE);
 		local_irq_enable();
-- 
1.7.5.4

