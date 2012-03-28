Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab2C1Gol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 02:44:41 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:49150 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab2C1GnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 02:43:24 -0400
Date: Wed, 28 Mar 2012 08:43:21 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH 2/3] padata: Use the online cpumask as the default
Message-ID: <20120328064321.GF16191@secunet.com>
References: <20120328064157.GD16191@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328064157.GD16191@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 28 Mar 2012 06:43:21.0484 (UTC) FILETIME=[112124C0:01CD0CAE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use the active cpumask to determine the superset of cpus
to use for parallelization. However, the active cpumask is
for internal usage of the scheduler and therefore not the
appropriate cpumask for these purposes. So use the online
cpumask instead.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 kernel/padata.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 7875088..de3d0d9 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -356,13 +356,13 @@ static int padata_setup_cpumasks(struct parallel_data *pd,
 	if (!alloc_cpumask_var(&pd->cpumask.pcpu, GFP_KERNEL))
 		return -ENOMEM;
 
-	cpumask_and(pd->cpumask.pcpu, pcpumask, cpu_active_mask);
+	cpumask_and(pd->cpumask.pcpu, pcpumask, cpu_online_mask);
 	if (!alloc_cpumask_var(&pd->cpumask.cbcpu, GFP_KERNEL)) {
 		free_cpumask_var(pd->cpumask.cbcpu);
 		return -ENOMEM;
 	}
 
-	cpumask_and(pd->cpumask.cbcpu, cbcpumask, cpu_active_mask);
+	cpumask_and(pd->cpumask.cbcpu, cbcpumask, cpu_online_mask);
 	return 0;
 }
 
@@ -566,7 +566,7 @@ EXPORT_SYMBOL(padata_unregister_cpumask_notifier);
 static bool padata_validate_cpumask(struct padata_instance *pinst,
 				    const struct cpumask *cpumask)
 {
-	if (!cpumask_intersects(cpumask, cpu_active_mask)) {
+	if (!cpumask_intersects(cpumask, cpu_online_mask)) {
 		pinst->flags |= PADATA_INVALID;
 		return false;
 	}
@@ -680,7 +680,7 @@ static int __padata_add_cpu(struct padata_instance *pinst, int cpu)
 {
 	struct parallel_data *pd;
 
-	if (cpumask_test_cpu(cpu, cpu_active_mask)) {
+	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
 		pd = padata_alloc_pd(pinst, pinst->cpumask.pcpu,
 				     pinst->cpumask.cbcpu);
 		if (!pd)
-- 
1.7.0.4

