Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab2JETuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 15:50:18 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:54133 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757173Ab2JETuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 15:50:12 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <peterz@infradead.org>
CC: <mingo@redhat.com>, <linux-kernel@vger.kernel.org>, <arnd@arndb.de>,
        <festevam@gmail.com>, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 2/2] sched: fair: Fix "declared 'static' but never defined" warning
Date: Fri, 5 Oct 2012 16:49:55 -0300
Message-ID: <1349466595-27614-2-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349466595-27614-1-git-send-email-fabio.estevam@freescale.com>
References: <1349466595-27614-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 4ae834f767 (sched/numa: Implement NUMA home-node selection code)
caused the following warning on a !CONFIG_SMP system:

kernel/sched/fair.c:801:22: warning: 'task_h_load' declared 'static' but never defined [-Wunused-function]

Instead of doing the forward declaration of task_h_load(), declare it sooner to avoid
the warning in the !CONFIG_SMP case.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 kernel/sched/fair.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b75a336..d57b5fd 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -798,7 +798,25 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
  * information we have.
  */
 
-static unsigned long task_h_load(struct task_struct *p);
+#ifdef CONFIG_SMP
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static unsigned long task_h_load(struct task_struct *p)
+{
+	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+	unsigned long load;
+
+	load = p->se.load.weight;
+	load = div_u64(load * cfs_rq->h_load, cfs_rq->load.weight + 1);
+
+	return load;
+}
+#else
+static unsigned long task_h_load(struct task_struct *p)
+{
+	return p->se.load.weight;
+}
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+#endif /* CONFIG_SMP */
 
 #ifdef CONFIG_SCHED_NUMA
 #ifdef CONFIG_SMP
@@ -3757,17 +3775,6 @@ static void update_h_load(long cpu)
 	walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
 	rcu_read_unlock();
 }
-
-static unsigned long task_h_load(struct task_struct *p)
-{
-	struct cfs_rq *cfs_rq = task_cfs_rq(p);
-	unsigned long load;
-
-	load = p->se.load.weight;
-	load = div_u64(load * cfs_rq->h_load, cfs_rq->load.weight + 1);
-
-	return load;
-}
 #else
 static inline void update_shares(int cpu)
 {
@@ -3776,11 +3783,6 @@ static inline void update_shares(int cpu)
 static inline void update_h_load(long cpu)
 {
 }
-
-static unsigned long task_h_load(struct task_struct *p)
-{
-	return p->se.load.weight;
-}
 #endif
 
 /********** Helpers for find_busiest_group ************************/
-- 
1.7.9.5


