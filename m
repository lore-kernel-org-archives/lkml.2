Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab0GGN2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:28:12 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:47305 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312Ab0GGN2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:28:10 -0400
Date: Wed, 7 Jul 2010 15:30:10 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Dan Kruchinin <dkruchinin@acm.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] padata: Check for valid padata instance on start
Message-ID: <20100707133010.GW10072@secunet.com>
References: <20100707132915.GV10072@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100707132915.GV10072@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Jul 2010 13:28:08.0433 (UTC) FILETIME=[3D08F610:01CB1DD8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the PADATA_INVALID flag which is
checked on padata start. This will be used to mark a padata
instance as invalid, if the padata cpumask does not intersect
with the active cpumask. we change padata_start to return an
error if the PADATA_INVALID is set. Also we adapt the only
padata user, pcrypt to this change.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/pcrypt.c        |   19 ++++++++++++++-----
 include/linux/padata.h |    3 ++-
 kernel/padata.c        |   18 ++++++++++++++++--
 3 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 247178c..71ae2b2 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -385,6 +385,7 @@ static struct crypto_template pcrypt_tmpl = {
 
 static int __init pcrypt_init(void)
 {
+	int err = -ENOMEM;
 	encwq = create_workqueue("pencrypt");
 	if (!encwq)
 		goto err;
@@ -400,14 +401,22 @@ static int __init pcrypt_init(void)
 
 	pcrypt_dec_padata = padata_alloc(cpu_possible_mask, decwq);
 	if (!pcrypt_dec_padata)
-		goto err_free_padata;
+		goto err_free_enc_padata;
 
-	padata_start(pcrypt_enc_padata);
-	padata_start(pcrypt_dec_padata);
+	err = padata_start(pcrypt_enc_padata);
+	if (err)
+		goto err_free_dec_padata;
+
+	err = padata_start(pcrypt_dec_padata);
+	if (err)
+		goto err_free_dec_padata;
 
 	return crypto_register_template(&pcrypt_tmpl);
 
-err_free_padata:
+err_free_dec_padata:
+	padata_free(pcrypt_dec_padata);
+
+err_free_enc_padata:
 	padata_free(pcrypt_enc_padata);
 
 err_destroy_decwq:
@@ -417,7 +426,7 @@ err_destroy_encwq:
 	destroy_workqueue(encwq);
 
 err:
-	return -ENOMEM;
+	return err;
 }
 
 static void __exit pcrypt_exit(void)
diff --git a/include/linux/padata.h b/include/linux/padata.h
index 8d84062..e4c17f9 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -126,6 +126,7 @@ struct padata_instance {
 	u8			flags;
 #define	PADATA_INIT		1
 #define	PADATA_RESET		2
+#define	PADATA_INVALID		4
 };
 
 extern struct padata_instance *padata_alloc(const struct cpumask *cpumask,
@@ -138,6 +139,6 @@ extern int padata_set_cpumask(struct padata_instance *pinst,
 			      cpumask_var_t cpumask);
 extern int padata_add_cpu(struct padata_instance *pinst, int cpu);
 extern int padata_remove_cpu(struct padata_instance *pinst, int cpu);
-extern void padata_start(struct padata_instance *pinst);
+extern int padata_start(struct padata_instance *pinst);
 extern void padata_stop(struct padata_instance *pinst);
 #endif
diff --git a/kernel/padata.c b/kernel/padata.c
index ff8de1b..e7d723a 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -485,6 +485,11 @@ static void padata_flush_queues(struct parallel_data *pd)
 	BUG_ON(atomic_read(&pd->refcnt) != 0);
 }
 
+static void __padata_start(struct padata_instance *pinst)
+{
+	pinst->flags |= PADATA_INIT;
+}
+
 /* Replace the internal control stucture with a new one. */
 static void padata_replace(struct padata_instance *pinst,
 			   struct parallel_data *pd_new)
@@ -619,11 +624,20 @@ EXPORT_SYMBOL(padata_remove_cpu);
  *
  * @pinst: padata instance to start
  */
-void padata_start(struct padata_instance *pinst)
+int padata_start(struct padata_instance *pinst)
 {
+	int err = 0;
+
 	mutex_lock(&pinst->lock);
-	pinst->flags |= PADATA_INIT;
+
+	if (pinst->flags & PADATA_INVALID)
+		err =-EINVAL;
+
+	 __padata_start(pinst);
+
 	mutex_unlock(&pinst->lock);
+
+	return err;
 }
 EXPORT_SYMBOL(padata_start);
 
-- 
1.5.6.5

