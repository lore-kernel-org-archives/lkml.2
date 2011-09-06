Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab1IGGag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:30:36 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46458 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755652Ab1IGGUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:48 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 38/55] rcu: Prohibit grace periods during early boot
Date: Tue,  6 Sep 2011 11:00:32 -0700
Message-Id: <1315332049-2604-38-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Greater use of RCU during early boot (before the scheduler is operating)
is causing RCU to attempt to start grace periods during that time, which
in turn is resulting in both RCU and the callback functions attempting
to use the scheduler before it is ready.

This commit prevents these problems by prohibiting RCU grace periods
until after the scheduler has spawned the first non-idle task.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 0051dbf..9970116 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -838,8 +838,11 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
-	if (!cpu_needs_another_gp(rsp, rdp) || rsp->fqs_active) {
-		if (cpu_needs_another_gp(rsp, rdp))
+	if (!rcu_scheduler_fully_active ||
+	    !cpu_needs_another_gp(rsp, rdp) ||
+	    rsp->fqs_active) {
+		if (rcu_scheduler_fully_active &&
+		    cpu_needs_another_gp(rsp, rdp))
 			rsp->fqs_need_gp = 1;
 		if (rnp->completed == rsp->completed) {
 			raw_spin_unlock_irqrestore(&rnp->lock, flags);
-- 
1.7.3.2

