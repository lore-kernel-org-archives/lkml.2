Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab1BPBwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:52:14 -0500
Received: from kroah.org ([198.145.64.141]:49378 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758626Ab1BPBwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:52:01 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:04 2011
Message-Id: <20110216014704.844579584@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:46:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Subject: [106/115] sched: Call tick_check_idle before __irq_enter
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

Commit: d267f87fb8179c6dba03d08b91952e81bc3723c7 upstream

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c   |    2 +-
 kernel/softirq.c |   12 +++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1872,8 +1872,8 @@ void account_system_vtime(struct task_st
 
 	local_irq_save(flags);
 
-	now = sched_clock();
 	cpu = smp_processor_id();
+	now = sched_clock_cpu(cpu);
 	delta = now - per_cpu(irq_start_time, cpu);
 	per_cpu(irq_start_time, cpu) = now;
 	/*
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


