Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab2H3VrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:47:00 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:37363 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab2H3Vnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:43:41 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/15] rcu: Protect rcu_node accesses during CPU stall warnings
Date: Thu, 30 Aug 2012 11:56:23 -0700
Message-Id: <1346352988-32444-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-7606-0000-0000-00000334FF6A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The print_other_cpu_stall() function accesses a number of rcu_node
fields without protection from the ->lock.  In theory, this is not
a problem because the fields accessed are all integers, but in
practice the compiler can get nasty.  Therefore, the commit extends
the existing critical section to cover the entire loop body.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 9f44749..fbe43b0 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -746,14 +746,16 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	rcu_for_each_leaf_node(rsp, rnp) {
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		ndetected += rcu_print_task_stall(rnp);
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		if (rnp->qsmask == 0)
+		if (rnp->qsmask == 0) {
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			continue;
+		}
 		for (cpu = 0; cpu <= rnp->grphi - rnp->grplo; cpu++)
 			if (rnp->qsmask & (1UL << cpu)) {
 				print_cpu_stall_info(rsp, rnp->grplo + cpu);
 				ndetected++;
 			}
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 
 	/*
-- 
1.7.8

