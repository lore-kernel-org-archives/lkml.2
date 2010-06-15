Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab0FOWaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 18:30:15 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60603 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab0FOW3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 18:29:49 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 1/3] rcu: fix lockdep splat in wake_affine()
Date: Tue, 15 Jun 2010 15:29:41 -0700
Message-Id: <1276640983-14641-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100615222923.GA14571@linux.vnet.ibm.com>
References: <20100615222923.GA14571@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel J Blueman <daniel.blueman@gmail.com>

With 2.6.35-rc1 and your patch in the context below, we still see
"include/linux/cgroup.h:534 invoked rcu_dereference_check() without
protection!", so need this additional patch:

Acquire read-side RCU lock around task_group() calls, addressing
"include/linux/cgroup.h:534 invoked rcu_dereference_check() without
protection!" warning.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/sched_fair.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index eed35ed..ca56133 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1240,6 +1240,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	 * effect of the currently running task from the load
 	 * of the current CPU:
 	 */
+	rcu_read_lock();
 	if (sync) {
 		tg = task_group(current);
 		weight = current->se.load.weight;
@@ -1249,6 +1250,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	}
 
 	tg = task_group(p);
+	rcu_read_unlock();
 	weight = p->se.load.weight;
 
 	/*
-- 
1.7.0.6

