Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785Ab0D3SEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:04:50 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:43355 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759037Ab0D3SCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:02:30 -0400
Date: Thu, 29 Apr 2010 14:41:36 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] padata: Initialize the padata queues only for the used
 cpus
Message-ID: <20100429124136.GH5275@secunet.com>
References: <20100429123636.GD5275@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100429123636.GD5275@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 29 Apr 2010 12:36:32.0799 (UTC) FILETIME=[9963F2F0:01CAE798]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

padata_alloc_pd set up queues for all possible cpus.
This patch changes this to set up the queues just for
the used cpus.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 kernel/padata.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 5fa6ba6..fc9f19a 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -358,17 +358,15 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 	if (!alloc_cpumask_var(&pd->cpumask, GFP_KERNEL))
 		goto err_free_queue;
 
-	for_each_possible_cpu(cpu) {
+	cpumask_and(pd->cpumask, cpumask, cpu_active_mask);
+
+	for_each_cpu(cpu, pd->cpumask) {
 		queue = per_cpu_ptr(pd->queue, cpu);
 
 		queue->pd = pd;
 
-		if (cpumask_test_cpu(cpu, cpumask)
-		    && cpumask_test_cpu(cpu, cpu_active_mask)) {
-			queue->cpu_index = cpu_index;
-			cpu_index++;
-		} else
-			queue->cpu_index = -1;
+		queue->cpu_index = cpu_index;
+		cpu_index++;
 
 		INIT_LIST_HEAD(&queue->reorder.list);
 		INIT_LIST_HEAD(&queue->parallel.list);
@@ -382,8 +380,6 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 		atomic_set(&queue->num_obj, 0);
 	}
 
-	cpumask_and(pd->cpumask, cpumask, cpu_active_mask);
-
 	num_cpus = cpumask_weight(pd->cpumask);
 	pd->max_seq_nr = (MAX_SEQ_NR / num_cpus) * num_cpus - 1;
 
-- 
1.5.6.5

