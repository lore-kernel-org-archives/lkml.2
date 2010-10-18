Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163Ab0JRT1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:27:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:58878 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757270Ab0JRT1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:27:40 -0400
Date: Mon, 18 Oct 2010 19:27:13 GMT
From: tip-bot for Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, yong.zhang0@gmail.com,
        venki@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, yong.zhang0@gmail.com,
        venki@google.com, mingo@elte.hu
In-Reply-To: <1286237003-12406-9-git-send-email-venki@google.com>
References: <1286237003-12406-9-git-send-email-venki@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Call tick_check_idle before __irq_enter
Message-ID: <tip-d267f87fb8179c6dba03d08b91952e81bc3723c7@git.kernel.org>
Git-Commit-ID: d267f87fb8179c6dba03d08b91952e81bc3723c7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:27:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d267f87fb8179c6dba03d08b91952e81bc3723c7
Gitweb:     http://git.kernel.org/tip/d267f87fb8179c6dba03d08b91952e81bc3723c7
Author:     Venkatesh Pallipadi <venki@google.com>
AuthorDate: Mon, 4 Oct 2010 17:03:23 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 20:52:29 +0200

sched: Call tick_check_idle before __irq_enter

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
---
 kernel/sched.c   |    2 +-
 kernel/softirq.c |   12 +++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index bff9ef5..567f5cb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1974,8 +1974,8 @@ void account_system_vtime(struct task_struct *curr)
 
 	local_irq_save(flags);
 
-	now = sched_clock();
 	cpu = smp_processor_id();
+	now = sched_clock_cpu(cpu);
 	delta = now - per_cpu(irq_start_time, cpu);
 	per_cpu(irq_start_time, cpu) = now;
 	/*
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 267f7b7..79ee8f1 100644
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
