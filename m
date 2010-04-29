Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282Ab0D3STC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:19:02 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:42493 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933290Ab0D3R3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:29:12 -0400
Date: Thu, 29 Apr 2010 14:44:26 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] padata: Flush the padata queues actively
Message-ID: <20100429124426.GK5275@secunet.com>
References: <20100429123636.GD5275@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100429123636.GD5275@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 29 Apr 2010 12:39:22.0964 (UTC) FILETIME=[FED11140:01CAE798]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yield was used to wait until all references of the internal control
structure in use are dropped before it is freed. This patch implements
padata_flush_queues which actively flushes the padata percpu queues
in this case.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 kernel/padata.c |   33 +++++++++++++++++++++++++--------
 1 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 6d7ea48..ec6b8b7 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -417,6 +417,29 @@ static void padata_free_pd(struct parallel_data *pd)
 	kfree(pd);
 }
 
+static void padata_flush_queues(struct parallel_data *pd)
+{
+	int cpu;
+	struct padata_queue *queue;
+
+	for_each_cpu(cpu, pd->cpumask) {
+		queue = per_cpu_ptr(pd->queue, cpu);
+		flush_work(&queue->pwork);
+	}
+
+	del_timer_sync(&pd->timer);
+
+	if (atomic_read(&pd->reorder_objects))
+		padata_reorder(pd);
+
+	for_each_cpu(cpu, pd->cpumask) {
+		queue = per_cpu_ptr(pd->queue, cpu);
+		flush_work(&queue->swork);
+	}
+
+	BUG_ON(atomic_read(&pd->refcnt) != 0);
+}
+
 static void padata_replace(struct padata_instance *pinst,
 			   struct parallel_data *pd_new)
 {
@@ -428,11 +451,7 @@ static void padata_replace(struct padata_instance *pinst,
 
 	synchronize_rcu();
 
-	while (atomic_read(&pd_old->refcnt) != 0)
-		yield();
-
-	flush_workqueue(pinst->wq);
-
+	padata_flush_queues(pd_old);
 	padata_free_pd(pd_old);
 
 	pinst->flags &= ~PADATA_RESET;
@@ -695,12 +714,10 @@ void padata_free(struct padata_instance *pinst)
 
 	synchronize_rcu();
 
-	while (atomic_read(&pinst->pd->refcnt) != 0)
-		yield();
-
 #ifdef CONFIG_HOTPLUG_CPU
 	unregister_hotcpu_notifier(&pinst->cpu_notifier);
 #endif
+	padata_flush_queues(pinst->pd);
 	padata_free_pd(pinst->pd);
 	free_cpumask_var(pinst->cpumask);
 	kfree(pinst);
-- 
1.5.6.5

