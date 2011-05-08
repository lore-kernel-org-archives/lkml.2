Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab1EHNeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 09:34:19 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33445 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab1EHNeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 09:34:17 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/3] rcu: get rid of signed overflow in check_cpu_stall()
Date: Sun,  8 May 2011 06:34:08 -0700
Message-Id: <1304861650-18475-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110508133343.GA18287@linux.vnet.ibm.com>
References: <20110508133343.GA18287@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed integer overflow is undefined by the C standard, so move
calculations to unsigned.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 78923a5..b2fe2a2 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -581,21 +581,24 @@ static void print_cpu_stall(struct rcu_state *rsp)
 
 static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 {
-	long delta;
+	unsigned long j;
+	unsigned long js;
 	struct rcu_node *rnp;
 
 	if (rcu_cpu_stall_suppress)
 		return;
-	delta = jiffies - ACCESS_ONCE(rsp->jiffies_stall);
+	j = ACCESS_ONCE(jiffies);
+	js = ACCESS_ONCE(rsp->jiffies_stall);
 	rnp = rdp->mynode;
-	if ((ACCESS_ONCE(rnp->qsmask) & rdp->grpmask) && delta >= 0) {
+	if ((ACCESS_ONCE(rnp->qsmask) & rdp->grpmask) && ULONG_CMP_GE(j, js)) {
 
 		/* We haven't checked in, so go dump stack. */
 		print_cpu_stall(rsp);
 
-	} else if (rcu_gp_in_progress(rsp) && delta >= RCU_STALL_RAT_DELAY) {
+	} else if (rcu_gp_in_progress(rsp) &&
+		   ULONG_CMP_GE(j, js + RCU_STALL_RAT_DELAY)) {
 
-		/* They had two time units to dump stack, so complain. */
+		/* They had a few time units to dump stack, so complain. */
 		print_other_cpu_stall(rsp);
 	}
 }
-- 
1.7.3.2

