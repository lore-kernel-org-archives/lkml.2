Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab0G0FMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 01:12:21 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:45570 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab0G0FMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 01:12:18 -0400
Date: Tue, 27 Jul 2010 07:15:50 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Dan Kruchinin <dkruchinin@acm.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] padata: Pass the padata cpumasks to the
 cpumask_change_notifier chain
Message-ID: <20100727051550.GL11081@secunet.com>
References: <20100727051347.GI11081@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727051347.GI11081@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 Jul 2010 05:12:14.0714 (UTC) FILETIME=[46B2BDA0:01CB2D4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We pass a pointer to the new padata cpumasks to the cpumask_change_notifier
chain. So users can access the cpumasks without the need of an extra
padata_get_cpumask function.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/linux/padata.h |   40 +++++++++++++++++++++-------------------
 kernel/padata.c        |    3 ++-
 2 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index bb0fc5d..43db792 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -98,6 +98,16 @@ struct padata_parallel_queue {
        int                   cpu_index;
 };
 
+/**
+ * struct padata_cpumask - The cpumasks for the parallel/serial workers
+ *
+ * @pcpu: cpumask for the parallel workers.
+ * @cbcpu: cpumask for the serial (callback) workers.
+ */
+struct padata_cpumask {
+	cpumask_var_t	pcpu;
+	cpumask_var_t	cbcpu;
+};
 
 /**
  * struct parallel_data - Internal control structure, covers everything
@@ -110,8 +120,7 @@ struct padata_parallel_queue {
  * @reorder_objects: Number of objects waiting in the reorder queues.
  * @refcnt: Number of objects holding a reference on this parallel_data.
  * @max_seq_nr:  Maximal used sequence number.
- * @cpumask: Contains two cpumasks: pcpu and cbcpu for
- *           parallel and serial workers respectively.
+ * @cpumask: The cpumasks in use for parallel and serial workers.
  * @lock: Reorder lock.
  * @processed: Number of already processed objects.
  * @timer: Reorder timer.
@@ -120,17 +129,14 @@ struct parallel_data {
 	struct padata_instance		*pinst;
 	struct padata_parallel_queue	*pqueue;
 	struct padata_serial_queue	*squeue;
-	atomic_t			 seq_nr;
-	atomic_t			 reorder_objects;
-	atomic_t			 refcnt;
-	unsigned int			 max_seq_nr;
-	struct {
-		cpumask_var_t		 pcpu;
-		cpumask_var_t		 cbcpu;
-	} cpumask;
-	spinlock_t                       lock ____cacheline_aligned;
-	unsigned int			 processed;
-	struct timer_list		 timer;
+	atomic_t			seq_nr;
+	atomic_t			reorder_objects;
+	atomic_t			refcnt;
+	unsigned int			max_seq_nr;
+	struct padata_cpumask		cpumask;
+	spinlock_t                      lock ____cacheline_aligned;
+	unsigned int			processed;
+	struct timer_list		timer;
 };
 
 /**
@@ -139,8 +145,7 @@ struct parallel_data {
  * @cpu_notifier: cpu hotplug notifier.
  * @wq: The workqueue in use.
  * @pd: The internal control structure.
- * @cpumask: User supplied cpumask. Contains two cpumasks: pcpu and
- *           cbcpu for parallel and serial works respectivly.
+ * @cpumask: User supplied cpumasks for parallel and serial works.
  * @cpumask_change_notifier: Notifiers chain for user-defined notify
  *            callbacks that will be called when either @pcpu or @cbcpu
  *            or both cpumasks change.
@@ -152,10 +157,7 @@ struct padata_instance {
 	struct notifier_block		 cpu_notifier;
 	struct workqueue_struct		*wq;
 	struct parallel_data		*pd;
-	struct {
-		cpumask_var_t		 pcpu;
-		cpumask_var_t		 cbcpu;
-	} cpumask;
+	struct padata_cpumask		cpumask;
 	struct blocking_notifier_head	 cpumask_change_notifier;
 	struct kobject                   kobj;
 	struct mutex			 lock;
diff --git a/kernel/padata.c b/kernel/padata.c
index 4987203..1c8c1d1 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -538,7 +538,8 @@ static void padata_replace(struct padata_instance *pinst,
 
 	if (notification_mask)
 		blocking_notifier_call_chain(&pinst->cpumask_change_notifier,
-					     notification_mask, pinst);
+					     notification_mask,
+					     &pd_new->cpumask);
 
 	pinst->flags &= ~PADATA_RESET;
 }
-- 
1.5.6.5

