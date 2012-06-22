Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762654Ab2FVPhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:37:45 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35400 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933068Ab2FVPgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:36:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 01/17] rcu: Fix detection of abruptly-ending stall
Date: Fri, 22 Jun 2012 08:34:56 -0700
Message-Id: <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20120622153501.GA6626@linux.vnet.ibm.com>
References: <20120622153501.GA6626@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062215-7182-0000-0000-000001D2BE5E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The code that attempts to identify stalls that end just as we detect
them is broken by both flavors of initialization failure.  This commit
therefore properly initializes and computes the count of the number
of reasons why the RCU grace period is stalled.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 0da7b88..0f04480 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -732,7 +732,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	int cpu;
 	long delta;
 	unsigned long flags;
-	int ndetected;
+	int ndetected = 0;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	/* Only let one CPU complain about others per time interval. */
@@ -773,7 +773,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	 */
 	rnp = rcu_get_root(rsp);
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	ndetected = rcu_print_task_stall(rnp);
+	ndetected += rcu_print_task_stall(rnp);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	print_cpu_stall_info_end();
-- 
1.7.8

