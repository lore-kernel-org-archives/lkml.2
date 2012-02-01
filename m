Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab2BATrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:47:08 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39245 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932205Ab2BATrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:47:03 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 41/41] rcu: Trace only after NULL-pointer check
Date: Wed,  1 Feb 2012 11:41:59 -0800
Message-Id: <1328125319-5205-41-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-5112-0000-0000-0000049E7080
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Fix a bonehead error introduced when adding event tracing to rcutorture.
Move the traces to follow the NULL-pointer checks.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 071c578..7765aaa 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -1000,12 +1000,12 @@ static void rcu_torture_timer(unsigned long unused)
 				  rcu_read_lock_bh_held() ||
 				  rcu_read_lock_sched_held() ||
 				  srcu_read_lock_held(&srcu_ctl));
-	do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu);
 	if (p == NULL) {
 		/* Leave because rcu_torture_writer is not yet underway */
 		cur_ops->readunlock(idx);
 		return;
 	}
+	do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu);
 	if (p->rtort_mbtest == 0)
 		atomic_inc(&n_rcu_torture_mberror);
 	spin_lock(&rand_lock);
@@ -1063,13 +1063,13 @@ rcu_torture_reader(void *arg)
 					  rcu_read_lock_bh_held() ||
 					  rcu_read_lock_sched_held() ||
 					  srcu_read_lock_held(&srcu_ctl));
-		do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu);
 		if (p == NULL) {
 			/* Wait for rcu_torture_writer to get underway */
 			cur_ops->readunlock(idx);
 			schedule_timeout_interruptible(HZ);
 			continue;
 		}
+		do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu);
 		if (p->rtort_mbtest == 0)
 			atomic_inc(&n_rcu_torture_mberror);
 		cur_ops->read_delay(&rand);
-- 
1.7.8

