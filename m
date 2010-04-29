Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253Ab0D3SSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:18:36 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:42494 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933293Ab0D3R3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:29:17 -0400
Date: Thu, 29 Apr 2010 14:42:30 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] padata: Use get_online_cpus/put_online_cpus
Message-ID: <20100429124230.GI5275@secunet.com>
References: <20100429123636.GD5275@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100429123636.GD5275@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 29 Apr 2010 12:37:27.0193 (UTC) FILETIME=[B9CFD090:01CAE798]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch puts get_online_cpus/put_online_cpus around the places
we modify the padata cpumask to ensure that no cpu goes offline
during this operation.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 kernel/padata.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index fc9f19a..82958e0 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -441,6 +441,8 @@ int padata_set_cpumask(struct padata_instance *pinst,
 
 	mutex_lock(&pinst->lock);
 
+	get_online_cpus();
+
 	pd = padata_alloc_pd(pinst, cpumask);
 	if (!pd) {
 		err = -ENOMEM;
@@ -452,6 +454,8 @@ int padata_set_cpumask(struct padata_instance *pinst,
 	padata_replace(pinst, pd);
 
 out:
+	put_online_cpus();
+
 	mutex_unlock(&pinst->lock);
 
 	return err;
@@ -485,8 +489,10 @@ int padata_add_cpu(struct padata_instance *pinst, int cpu)
 
 	mutex_lock(&pinst->lock);
 
+	get_online_cpus();
 	cpumask_set_cpu(cpu, pinst->cpumask);
 	err = __padata_add_cpu(pinst, cpu);
+	put_online_cpus();
 
 	mutex_unlock(&pinst->lock);
 
@@ -521,8 +527,10 @@ int padata_remove_cpu(struct padata_instance *pinst, int cpu)
 
 	mutex_lock(&pinst->lock);
 
+	get_online_cpus();
 	cpumask_clear_cpu(cpu, pinst->cpumask);
 	err = __padata_remove_cpu(pinst, cpu);
+	put_online_cpus();
 
 	mutex_unlock(&pinst->lock);
 
@@ -626,6 +634,8 @@ struct padata_instance *padata_alloc(const struct cpumask *cpumask,
 	if (!pinst)
 		goto err;
 
+	get_online_cpus();
+
 	pd = padata_alloc_pd(pinst, cpumask);
 	if (!pd)
 		goto err_free_inst;
@@ -647,6 +657,8 @@ struct padata_instance *padata_alloc(const struct cpumask *cpumask,
 	register_hotcpu_notifier(&pinst->cpu_notifier);
 #endif
 
+	put_online_cpus();
+
 	mutex_init(&pinst->lock);
 
 	return pinst;
@@ -655,6 +667,7 @@ err_free_pd:
 	padata_free_pd(pd);
 err_free_inst:
 	kfree(pinst);
+	put_online_cpus();
 err:
 	return NULL;
 }
-- 
1.5.6.5

