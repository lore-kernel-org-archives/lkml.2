Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab2H3SYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:24:00 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46915 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab2H3STZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:19:25 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/23] rcu: Allow RCU quiescent-state forcing to be preempted
Date: Thu, 30 Aug 2012 11:18:25 -0700
Message-Id: <1346350718-30937-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083018-6148-0000-0000-000009162C26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

RCU quiescent-state forcing is currently carried out without preemption
points, which can result in excessive latency spikes on large systems
(many hundreds or thousands of CPUs).  This patch therefore inserts
a voluntary preemption point into force_qs_rnp(), which should greatly
reduce the magnitude of these spikes.

Reported-by: Mike Galbraith <mgalbraith@suse.de>
Reported-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 79c2c28..cce73ff 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1784,6 +1784,7 @@ static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 	struct rcu_node *rnp;
 
 	rcu_for_each_leaf_node(rsp, rnp) {
+		cond_resched();
 		mask = 0;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		if (!rcu_gp_in_progress(rsp)) {
-- 
1.7.8

