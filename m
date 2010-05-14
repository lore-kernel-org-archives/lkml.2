Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743Ab0ENLpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 07:45:53 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:51840 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab0ENLpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 07:45:52 -0400
Date: Fri, 14 May 2010 13:43:36 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH 1/4] padata: Use a timer to handle remaining objects in the
 reorder queues
Message-ID: <20100514114336.GB2184@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 14 May 2010 11:45:47.0767 (UTC) FILETIME=[FE9B3070:01CAF35A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

padata_get_next needs to check whether the next object that
need serialization must be parallel processed by the local cpu.
This check was wrong implemented and returned always true,
so the try_again loop in padata_reorder was never taken. This
can lead to object leaks in some rare cases due to a race that
appears with the trylock in padata_reorder. The try_again loop
was not a good idea after all, because a cpu could take that
loop frequently, so we handle this with a timer instead.

This patch adds a timer to handle the race that appears with
the trylock. If cpu1 queues an object to the reorder queue while
cpu2 holds the pd->lock but left the while loop in padata_reorder
already, cpu2 can't care for this object and cpu1 exits because
it can't get the lock. Usually the next cpu that takes the lock
cares for this object too. We need the timer just if this object
was the last one that arrives to the reorder queues. The timer
function sends it out in this case.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/linux/padata.h |    2 ++
 kernel/padata.c        |   25 ++++++++++++++++++-------
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 51611da..64836a6 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -24,6 +24,7 @@
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
+#include <linux/timer.h>
 
 struct padata_priv {
 	struct list_head	list;
@@ -60,6 +61,7 @@ struct parallel_data {
 	unsigned int		max_seq_nr;
 	cpumask_var_t		cpumask;
 	spinlock_t              lock;
+	struct timer_list       timer;
 };
 
 struct padata_instance {
diff --git a/kernel/padata.c b/kernel/padata.c
index 82958e0..6d7ea48 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -231,7 +231,8 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 		goto out;
 	}
 
-	if (next_nr % num_cpus == next_queue->cpu_index) {
+	queue = per_cpu_ptr(pd->queue, smp_processor_id());
+	if (queue->cpu_index == next_queue->cpu_index) {
 		padata = ERR_PTR(-ENODATA);
 		goto out;
 	}
@@ -247,9 +248,8 @@ static void padata_reorder(struct parallel_data *pd)
 	struct padata_queue *queue;
 	struct padata_instance *pinst = pd->pinst;
 
-try_again:
 	if (!spin_trylock_bh(&pd->lock))
-		goto out;
+		return;
 
 	while (1) {
 		padata = padata_get_next(pd);
@@ -258,8 +258,9 @@ try_again:
 			break;
 
 		if (PTR_ERR(padata) == -ENODATA) {
+			del_timer(&pd->timer);
 			spin_unlock_bh(&pd->lock);
-			goto out;
+			return;
 		}
 
 		queue = per_cpu_ptr(pd->queue, padata->cb_cpu);
@@ -273,13 +274,22 @@ try_again:
 
 	spin_unlock_bh(&pd->lock);
 
-	if (atomic_read(&pd->reorder_objects))
-		goto try_again;
+	if (atomic_read(&pd->reorder_objects)
+			&& !(pinst->flags & PADATA_RESET))
+		mod_timer(&pd->timer, jiffies + HZ);
+	else
+		del_timer(&pd->timer);
 
-out:
 	return;
 }
 
+static void padata_reorder_timer(unsigned long arg)
+{
+	struct parallel_data *pd = (struct parallel_data *)arg;
+
+	padata_reorder(pd);
+}
+
 static void padata_serial_worker(struct work_struct *work)
 {
 	struct padata_queue *queue;
@@ -383,6 +393,7 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 	num_cpus = cpumask_weight(pd->cpumask);
 	pd->max_seq_nr = (MAX_SEQ_NR / num_cpus) * num_cpus - 1;
 
+	setup_timer(&pd->timer, padata_reorder_timer, (unsigned long)pd);
 	atomic_set(&pd->seq_nr, -1);
 	atomic_set(&pd->reorder_objects, 0);
 	atomic_set(&pd->refcnt, 0);
-- 
1.5.6.5

