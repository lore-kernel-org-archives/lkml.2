Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab1IGG2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:28:00 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50030 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755719Ab1IGGU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:57 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 35/55] rcu: Dump local stack if cannot dump all CPUs' stacks
Date: Tue,  6 Sep 2011 11:00:29 -0700
Message-Id: <1315332049-2604-35-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trigger_all_cpu_backtrace() function is a no-op in architectures that
do not define arch_trigger_all_cpu_backtrace.  On such architectures, RCU
CPU stall warning messages contain no stack trace information, which makes
debugging quite difficult.  This commit therefore substitutes dump_stack()
for architectures that do not define arch_trigger_all_cpu_backtrace,
so that at least the local CPU's stack is dumped as part of the RCU CPU
stall warning message.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ebd18e5..a07bf55 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -583,7 +583,8 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	}
 	printk("} (detected by %d, t=%ld jiffies)\n",
 	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
-	trigger_all_cpu_backtrace();
+	if (!trigger_all_cpu_backtrace())
+		dump_stack();
 
 	/* If so configured, complain about tasks blocking the grace period. */
 
@@ -604,7 +605,8 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	 */
 	printk(KERN_ERR "INFO: %s detected stall on CPU %d (t=%lu jiffies)\n",
 	       rsp->name, smp_processor_id(), jiffies - rsp->gp_start);
-	trigger_all_cpu_backtrace();
+	if (!trigger_all_cpu_backtrace())
+		dump_stack();
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	if (ULONG_CMP_GE(jiffies, rsp->jiffies_stall))
-- 
1.7.3.2

