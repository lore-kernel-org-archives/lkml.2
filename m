Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964892Ab2J3Qse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:48:34 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49715 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964804Ab2J3Qsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:48:32 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/4] rcu: Dump number of callbacks in stall warning messages
Date: Tue, 30 Oct 2012 09:46:48 -0700
Message-Id: <1351615609-25316-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351615609-25316-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030164622.GA25108@linux.vnet.ibm.com>
 <1351615609-25316-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-7606-0000-0000-000004EE4B50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

In theory, if a grace period manages to get started despite there being
no callbacks on any of the CPUs, all CPUs could go into dyntick-idle
mode, so that the grace period would never end.  This commit updates
the RCU CPU stall warning messages to detect this condition by summing
up the number of callbacks on all CPUs.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 8f4de3a..24b21cb 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -903,6 +903,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	unsigned long flags;
 	int ndetected = 0;
 	struct rcu_node *rnp = rcu_get_root(rsp);
+	long totqlen = 0;
 
 	/* Only let one CPU complain about others per time interval. */
 
@@ -947,9 +948,11 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	print_cpu_stall_info_end();
-	pr_cont("(detected by %d, t=%ld jiffies, g=%lu, c=%lu)\n",
+	for_each_possible_cpu(cpu)
+		totqlen += per_cpu_ptr(rsp->rda, cpu)->qlen;
+	pr_cont("(detected by %d, t=%ld jiffies, g=%lu, c=%lu, q=%lu)\n",
 	       smp_processor_id(), (long)(jiffies - rsp->gp_start),
-	       rsp->gpnum, rsp->completed);
+	       rsp->gpnum, rsp->completed, totqlen);
 	if (ndetected == 0)
 		printk(KERN_ERR "INFO: Stall ended before state dump start\n");
 	else if (!trigger_all_cpu_backtrace())
@@ -964,8 +967,10 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 
 static void print_cpu_stall(struct rcu_state *rsp)
 {
+	int cpu;
 	unsigned long flags;
 	struct rcu_node *rnp = rcu_get_root(rsp);
+	long totqlen = 0;
 
 	/*
 	 * OK, time to rat on ourselves...
@@ -976,8 +981,10 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	print_cpu_stall_info_begin();
 	print_cpu_stall_info(rsp, smp_processor_id());
 	print_cpu_stall_info_end();
-	pr_cont(" (t=%lu jiffies g=%lu c=%lu)\n",
-		jiffies - rsp->gp_start, rsp->gpnum, rsp->completed);
+	for_each_possible_cpu(cpu)
+		totqlen += per_cpu_ptr(rsp->rda, cpu)->qlen;
+	pr_cont(" (t=%lu jiffies g=%lu c=%lu q=%lu)\n",
+		jiffies - rsp->gp_start, rsp->gpnum, rsp->completed, totqlen);
 	if (!trigger_all_cpu_backtrace())
 		dump_stack();
 
-- 
1.7.8

