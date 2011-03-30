Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933511Ab1C3Vty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:49:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:58294 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933453Ab1C3VH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411277677"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: venki@google.com, a.p.zijlstra@chello.nl, ak@linux.intel.com,
        mingo@elte.hu, efault@gmx.de, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [105/275] sched: Call tick_check_idle before __irq_enter
Message-Id: <20110330210544.356DF3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <1286237003-12406-9-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c   |    2 +-
 kernel/softirq.c |   12 +++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/kernel/sched.c
===================================================================
--- linux-2.6.35.y.orig/kernel/sched.c	2011-03-29 23:03:00.344291360 -0700
+++ linux-2.6.35.y/kernel/sched.c	2011-03-29 23:54:58.516505136 -0700
@@ -1884,8 +1884,8 @@
 
 	local_irq_save(flags);
 
-	now = sched_clock();
 	cpu = smp_processor_id();
+	now = sched_clock_cpu(cpu);
 	delta = now - per_cpu(irq_start_time, cpu);
 	per_cpu(irq_start_time, cpu) = now;
 	/*
Index: linux-2.6.35.y/kernel/softirq.c
===================================================================
--- linux-2.6.35.y.orig/kernel/softirq.c	2011-03-29 23:03:00.249293792 -0700
+++ linux-2.6.35.y/kernel/softirq.c	2011-03-29 23:03:00.370290694 -0700
@@ -296,10 +296,16 @@
 
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
