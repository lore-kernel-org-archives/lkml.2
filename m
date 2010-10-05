Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab0JEAEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 20:04:41 -0400
Received: from smtp-out.google.com ([74.125.121.35]:32667 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477Ab0JEAEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 20:04:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BqwaIc1DvXnTeJ1hDlSSTuOvtddtZlifd31xuBUWhjTyzWbi8Plr5ixj+7rUAXE3uF
         8NwjpzPKdGshrh4w4p7w==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 8/8] Call tick_check_idle before __irq_enter
Date: Mon,  4 Oct 2010 17:03:23 -0700
Message-Id: <1286237003-12406-9-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286237003-12406-1-git-send-email-venki@google.com>
References: <1286237003-12406-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CPU is idle and on first interrupt, irq_enter calls tick_check_idle()
to notify interruption from idle. But, there is a problem if this call
is done after __irq_enter, as all routines in __irq_enter may find
stale time due to yet to be done tick_check_idle.

Specifically, trace calls in __irq_enter when they use global clock and also
account_system_vtime change in this patch as it wants to use sched_clock_cpu()
to do proper irq timing.

But, tick_check_idle was moved after __irq_enter intentionally to
prevent problem of unneeded ksoftirqd wakeups by the commit ee5f80a.
    irq: call __irq_enter() before calling the tick_idle_check
    Impact: avoid spurious ksoftirqd wakeups

Moving tick_check_idle() before __irq_enter and wrapping it with
local_bh_enable/disable would solve both the problems.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched.c   |    2 +-
 kernel/softirq.c |   12 +++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 6487da4..442e151 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1983,8 +1983,8 @@ void account_system_vtime(struct task_struct *curr)
 
 	local_irq_save(flags);
 
-	now = sched_clock();
 	cpu = smp_processor_id();
+	now = sched_clock_cpu(cpu);
 	delta = now - per_cpu(irq_start_time, cpu);
 	per_cpu(irq_start_time, cpu) = now;
 	/*
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 267f7b7..6bb7e19 100644
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
+		local_bh_enable();
+	}
+
+	__irq_enter();
 }
 
 #ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
-- 
1.7.1

