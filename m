Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab1HOPx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:53:58 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46598 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab1HOPxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:53:55 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [PATCH 22/32] rcu: Restart tick if we enqueue a callback in a nohz/cpuset CPU
Date: Mon, 15 Aug 2011 17:52:19 +0200
Message-Id: <1313423549-27093-23-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we enqueue an rcu callback, we need the CPU tick to stay
alive until we take care of those by completing the appropriate
grace period.

Thus, when we call_rcu(), send a self IPI that checks rcu_needs_cpu()
so that we restore a periodic tick behaviour that can take care of
everything.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul E . McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d496c70..b5643ce2 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -51,6 +51,7 @@
 #include <linux/kthread.h>
 #include <linux/prefetch.h>
 #include <linux/cpuset.h>
+#include <linux/tick.h>
 
 #include "rcutree.h"
 
@@ -1546,6 +1547,13 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
 	rdp->qlen++;
 
+	/* Restart the timer if needed to handle the callbacks */
+	if (tick_nohz_adaptive_mode()) {
+		/* Make updates on nxtlist visible to self IPI */
+		barrier();
+		smp_cpuset_update_nohz(smp_processor_id());
+	}
+
 	/* If interrupts were disabled, don't dive into RCU core. */
 	if (irqs_disabled_flags(flags)) {
 		local_irq_restore(flags);
-- 
1.7.5.4

