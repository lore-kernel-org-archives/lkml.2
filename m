Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab1BJM0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:26:53 -0500
Received: from cantor.suse.de ([195.135.220.2]:33779 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756290Ab1BJMZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:25:20 -0500
From: stable-bot for Venkatesh Pallipadi <venki@google.com>
Date: Thu, 10 Feb 2011 10:23:28 +0100
Subject: [PATCH 21/28] sched: Call tick_check_idle before __irq_enter
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Message-ID: <1297340644.5512.21.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit: d267f87fb8179c6dba03d08b91952e81bc3723c7 upstream
Author: Venkatesh Pallipadi <venki@google.com>
AuthorDate: Mon Oct 4 17:03:23 2010 -0700

When CPU is idle and on first interrupt, irq_enter calls tick_check_idle()
to notify interruption from idle. But, there is a problem if this call
is done after __irq_enter, as all routines in __irq_enter may find
stale time due to yet to be done tick_check_idle.

Specifically, trace calls in __irq_enter when they use global clock and also
account_system_vtime change in this patch as it wants to use sched_clock_cpu()
to do proper irq timing.

But, tick_check_idle was moved after __irq_enter intentionally to
prevent problem of unneeded ksoftirqd wakeups by the commit ee5f80a:

    irq: call __irq_enter() before calling the tick_idle_check
    Impact: avoid spurious ksoftirqd wakeups

Moving tick_check_idle() before __irq_enter and wrapping it with
local_bh_enable/disable would solve both the problems.

Fixed-by: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1286237003-12406-9-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c   |    2 +-
 kernel/softirq.c |   12 +++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 4f86094..c7f69fe 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1872,8 +1872,8 @@ void account_system_vtime(struct task_struct *curr)
 
 	local_irq_save(flags);
 
-	now = sched_clock();
 	cpu = smp_processor_id();
+	now = sched_clock_cpu(cpu);
 	delta = now - per_cpu(irq_start_time, cpu);
 	per_cpu(irq_start_time, cpu) = now;
 	/*
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 0a617de..04a0252 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -296,10 +296,16 @@ void irq_enter(void)
 
 	rcu_irq_enter();
 	if (idle_cpu(cpu) && !in_interrupt()) {
-		__irq_enter();
+		/*
+		 * Prevent raise_softirq from needlessly waking up ksoftirqd
+		 * here, as softirq will be serviced on return from interrupt.
+		 */
+		local_bh_disable();
 		tick_check_idle(cpu);
-	} else
-		__irq_enter();
+		_local_bh_enable();
+	}
+
+	__irq_enter();
 }
 
 #ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
-- 
1.7.4


