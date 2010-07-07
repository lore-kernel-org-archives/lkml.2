Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab0GGN2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:28:48 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:47320 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849Ab0GGN2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:28:46 -0400
Date: Wed, 7 Jul 2010 15:30:47 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Dan Kruchinin <dkruchinin@acm.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] padata: Block until the instance is unused on stop
Message-ID: <20100707133047.GX10072@secunet.com>
References: <20100707132915.GV10072@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100707132915.GV10072@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Jul 2010 13:28:45.0043 (UTC) FILETIME=[52DB3430:01CB1DD8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes padata_stop to block until the padata
instance is unused. Also we split padata_stop to a locked
and a unlocked version. This is in preparation to be able
to change the cpumask after a call to patata stop.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 kernel/padata.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index e7d723a..9e18dfa 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -490,6 +490,20 @@ static void __padata_start(struct padata_instance *pinst)
 	pinst->flags |= PADATA_INIT;
 }
 
+static void __padata_stop(struct padata_instance *pinst)
+{
+	if (!(pinst->flags & PADATA_INIT))
+		return;
+
+	pinst->flags &= ~PADATA_INIT;
+
+	synchronize_rcu();
+
+	get_online_cpus();
+	padata_flush_queues(pinst->pd);
+	put_online_cpus();
+}
+
 /* Replace the internal control stucture with a new one. */
 static void padata_replace(struct padata_instance *pinst,
 			   struct parallel_data *pd_new)
@@ -649,7 +663,7 @@ EXPORT_SYMBOL(padata_start);
 void padata_stop(struct padata_instance *pinst)
 {
 	mutex_lock(&pinst->lock);
-	pinst->flags &= ~PADATA_INIT;
+	__padata_stop(pinst);
 	mutex_unlock(&pinst->lock);
 }
 EXPORT_SYMBOL(padata_stop);
@@ -770,17 +784,11 @@ EXPORT_SYMBOL(padata_alloc);
  */
 void padata_free(struct padata_instance *pinst)
 {
-	padata_stop(pinst);
-
-	synchronize_rcu();
-
 #ifdef CONFIG_HOTPLUG_CPU
 	unregister_hotcpu_notifier(&pinst->cpu_notifier);
 #endif
-	get_online_cpus();
-	padata_flush_queues(pinst->pd);
-	put_online_cpus();
 
+	padata_stop(pinst);
 	padata_free_pd(pinst->pd);
 	free_cpumask_var(pinst->cpumask);
 	kfree(pinst);
-- 
1.5.6.5

