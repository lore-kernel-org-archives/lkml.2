Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab2JETuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 15:50:14 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:17348
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757171Ab2JETuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 15:50:12 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <peterz@infradead.org>
CC: <mingo@redhat.com>, <linux-kernel@vger.kernel.org>, <arnd@arndb.de>,
        <festevam@gmail.com>, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 1/2] sched: fair: Fix 'defined but not used' warning
Date: Fri, 5 Oct 2012 16:49:54 -0300
Message-ID: <1349466595-27614-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 4ae834f767 (sched/numa: Implement NUMA home-node selection code)
caused the following warning on a !CONFIG_SMP system:

kernel/sched/fair.c:1013:13: warning: 'account_offnode_enqueue' defined but not used [-Wunused-function]

Since account_offnode_enqueue() is only used in a path that requires CONFIG_SMP
to be enabled, make its definition dependent on CONFIG_SMP.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 kernel/sched/fair.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f586f17..b75a336 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -801,12 +801,14 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 static unsigned long task_h_load(struct task_struct *p);
 
 #ifdef CONFIG_SCHED_NUMA
+#ifdef CONFIG_SMP
 static void account_offnode_enqueue(struct rq *rq, struct task_struct *p)
 {
 	p->numa_contrib = task_h_load(p);
 	rq->offnode_weight += p->numa_contrib;
 	rq->offnode_running++;
 }
+#endif /* CONFIG_SMP */
 
 static void account_offnode_dequeue(struct rq *rq, struct task_struct *p)
 {
@@ -1010,9 +1012,11 @@ void task_tick_numa(struct rq *rq, struct task_struct *curr)
 	}
 }
 #else
+#ifdef CONFIG_SMP
 static void account_offnode_enqueue(struct rq *rq, struct task_struct *p)
 {
 }
+#endif /* CONFIG_SMP */
 
 static void account_offnode_dequeue(struct rq *rq, struct task_struct *p)
 {
-- 
1.7.9.5


