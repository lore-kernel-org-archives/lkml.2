Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933798Ab0D3SE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:04:59 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:43350 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759027Ab0D3SC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:02:29 -0400
Date: Thu, 29 Apr 2010 14:40:10 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] padata: cpu hotplug code should depend on
 CONFIG_HOTPLUG_CPU
Message-ID: <20100429124010.GF5275@secunet.com>
References: <20100429123636.GD5275@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100429123636.GD5275@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 29 Apr 2010 12:35:06.0951 (UTC) FILETIME=[66389570:01CAE798]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the padata cpu hotplug code dependend on CONFIG_HOTPLUG_CPU.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 kernel/padata.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 5b44d0f..1209a17 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -570,6 +570,7 @@ void padata_stop(struct padata_instance *pinst)
 }
 EXPORT_SYMBOL(padata_stop);
 
+#ifdef CONFIG_HOTPLUG_CPU
 static int padata_cpu_callback(struct notifier_block *nfb,
 			       unsigned long action, void *hcpu)
 {
@@ -621,6 +622,7 @@ static int padata_cpu_callback(struct notifier_block *nfb,
 
 	return NOTIFY_OK;
 }
+#endif
 
 /*
  * padata_alloc - allocate and initialize a padata instance
@@ -631,7 +633,6 @@ static int padata_cpu_callback(struct notifier_block *nfb,
 struct padata_instance *padata_alloc(const struct cpumask *cpumask,
 				     struct workqueue_struct *wq)
 {
-	int err;
 	struct padata_instance *pinst;
 	struct parallel_data *pd;
 
@@ -654,18 +655,16 @@ struct padata_instance *padata_alloc(const struct cpumask *cpumask,
 
 	pinst->flags = 0;
 
+#ifdef CONFIG_HOTPLUG_CPU
 	pinst->cpu_notifier.notifier_call = padata_cpu_callback;
 	pinst->cpu_notifier.priority = 0;
-	err = register_hotcpu_notifier(&pinst->cpu_notifier);
-	if (err)
-		goto err_free_cpumask;
+	register_hotcpu_notifier(&pinst->cpu_notifier);
+#endif
 
 	mutex_init(&pinst->lock);
 
 	return pinst;
 
-err_free_cpumask:
-	free_cpumask_var(pinst->cpumask);
 err_free_pd:
 	padata_free_pd(pd);
 err_free_inst:
@@ -689,7 +688,9 @@ void padata_free(struct padata_instance *pinst)
 	while (atomic_read(&pinst->pd->refcnt) != 0)
 		yield();
 
+#ifdef CONFIG_HOTPLUG_CPU
 	unregister_hotcpu_notifier(&pinst->cpu_notifier);
+#endif
 	padata_free_pd(pinst->pd);
 	free_cpumask_var(pinst->cpumask);
 	kfree(pinst);
-- 
1.5.6.5

