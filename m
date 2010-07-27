Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab0G0FPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 01:15:16 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:33223 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab0G0FPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 01:15:13 -0400
Date: Tue, 27 Jul 2010 07:18:46 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Dan Kruchinin <dkruchinin@acm.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] crypto: pcrypt - Update pcrypt cpumask according to
 the padata cpumask notifier
Message-ID: <20100727051846.GN11081@secunet.com>
References: <20100727051347.GI11081@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727051347.GI11081@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 Jul 2010 05:15:10.0214 (UTC) FILETIME=[AF4DEA60:01CB2D4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The padata cpumask change notifier passes a padata_cpumask to the
notifier chain. So we use this cpumask instead of asking padata for
the cpumask.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/pcrypt.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 7742553..de30782 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/notifier.h>
 #include <linux/kobject.h>
+#include <linux/cpu.h>
 #include <crypto/pcrypt.h>
 
 struct padata_pcrypt {
@@ -409,6 +410,7 @@ static int pcrypt_cpumask_change_notify(struct notifier_block *self,
 {
 	struct padata_pcrypt *pcrypt;
 	struct pcrypt_cpumask *new_mask, *old_mask;
+	struct padata_cpumask *cpumask = (struct padata_cpumask *)data;
 
 	if (!(val & PADATA_CPU_SERIAL))
 		return 0;
@@ -424,7 +426,7 @@ static int pcrypt_cpumask_change_notify(struct notifier_block *self,
 
 	old_mask = pcrypt->cb_cpumask;
 
-	padata_get_cpumask(pcrypt->pinst, PADATA_CPU_SERIAL, new_mask->mask);
+	cpumask_copy(new_mask->mask, cpumask->cbcpu);
 	rcu_assign_pointer(pcrypt->cb_cpumask, new_mask);
 	synchronize_rcu_bh();
 
@@ -451,6 +453,8 @@ static int pcrypt_init_padata(struct padata_pcrypt *pcrypt,
 	int ret = -ENOMEM;
 	struct pcrypt_cpumask *mask;
 
+	get_online_cpus();
+
 	pcrypt->wq = create_workqueue(name);
 	if (!pcrypt->wq)
 		goto err;
@@ -467,7 +471,7 @@ static int pcrypt_init_padata(struct padata_pcrypt *pcrypt,
 		goto err_free_padata;
 	}
 
-	padata_get_cpumask(pcrypt->pinst, PADATA_CPU_SERIAL, mask->mask);
+	cpumask_and(mask->mask, cpu_possible_mask, cpu_active_mask);
 	rcu_assign_pointer(pcrypt->cb_cpumask, mask);
 
 	pcrypt->nblock.notifier_call = pcrypt_cpumask_change_notify;
@@ -479,7 +483,10 @@ static int pcrypt_init_padata(struct padata_pcrypt *pcrypt,
 	if (ret)
 		goto err_unregister_notifier;
 
+	put_online_cpus();
+
 	return ret;
+
 err_unregister_notifier:
 	padata_unregister_cpumask_notifier(pcrypt->pinst, &pcrypt->nblock);
 err_free_cpumask:
@@ -490,6 +497,8 @@ err_free_padata:
 err_destroy_workqueue:
 	destroy_workqueue(pcrypt->wq);
 err:
+	put_online_cpus();
+
 	return ret;
 }
 
-- 
1.5.6.5

