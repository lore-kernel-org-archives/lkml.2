Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab0G0FNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 01:13:04 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:45586 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab0G0FNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 01:13:01 -0400
Date: Tue, 27 Jul 2010 07:16:33 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Dan Kruchinin <dkruchinin@acm.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] crypto: pcrypt - Rename pcrypt_instance
Message-ID: <20100727051633.GM11081@secunet.com>
References: <20100727051347.GI11081@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727051347.GI11081@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 Jul 2010 05:12:57.0808 (UTC) FILETIME=[60625D00:01CB2D4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the crypto-layer an instance refers usually to a crypto instance.
The struct pcrypt_instance is not related to a crypto instance.
It rather contains the padata informations, so we rename it to
padata_pcrypt. The functions that handle this struct are renamed
accordingly.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/pcrypt.c |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 5546083..7742553 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -28,8 +28,7 @@
 #include <linux/kobject.h>
 #include <crypto/pcrypt.h>
 
-struct pcrypt_instance {
-	const char *name;
+struct padata_pcrypt {
 	struct padata_instance *pinst;
 	struct workqueue_struct *wq;
 
@@ -55,8 +54,8 @@ struct pcrypt_instance {
 	struct notifier_block nblock;
 };
 
-static struct pcrypt_instance pencrypt;
-static struct pcrypt_instance pdecrypt;
+static struct padata_pcrypt pencrypt;
+static struct padata_pcrypt pdecrypt;
 static struct kset           *pcrypt_kset;
 
 struct pcrypt_instance_ctx {
@@ -70,7 +69,7 @@ struct pcrypt_aead_ctx {
 };
 
 static int pcrypt_do_parallel(struct padata_priv *padata, unsigned int *cb_cpu,
-			      struct pcrypt_instance *pcrypt)
+			      struct padata_pcrypt *pcrypt)
 {
 	unsigned int cpu_index, cpu, i;
 	struct pcrypt_cpumask *cpumask;
@@ -408,13 +407,13 @@ static void pcrypt_free(struct crypto_instance *inst)
 static int pcrypt_cpumask_change_notify(struct notifier_block *self,
 					unsigned long val, void *data)
 {
-	struct pcrypt_instance *pcrypt;
+	struct padata_pcrypt *pcrypt;
 	struct pcrypt_cpumask *new_mask, *old_mask;
 
 	if (!(val & PADATA_CPU_SERIAL))
 		return 0;
 
-	pcrypt = container_of(self, struct pcrypt_instance, nblock);
+	pcrypt = container_of(self, struct padata_pcrypt, nblock);
 	new_mask = kmalloc(sizeof(*new_mask), GFP_KERNEL);
 	if (!new_mask)
 		return -ENOMEM;
@@ -446,13 +445,12 @@ static int pcrypt_sysfs_add(struct padata_instance *pinst, const char *name)
 	return ret;
 }
 
-static int __pcrypt_init_instance(struct pcrypt_instance *pcrypt,
-				  const char *name)
+static int pcrypt_init_padata(struct padata_pcrypt *pcrypt,
+			      const char *name)
 {
 	int ret = -ENOMEM;
 	struct pcrypt_cpumask *mask;
 
-	pcrypt->name = name;
 	pcrypt->wq = create_workqueue(name);
 	if (!pcrypt->wq)
 		goto err;
@@ -495,7 +493,7 @@ err:
 	return ret;
 }
 
-static void __pcrypt_deinit_instance(struct pcrypt_instance *pcrypt)
+static void pcrypt_fini_padata(struct padata_pcrypt *pcrypt)
 {
 	kobject_put(&pcrypt->pinst->kobj);
 	free_cpumask_var(pcrypt->cb_cpumask->mask);
@@ -522,11 +520,11 @@ static int __init pcrypt_init(void)
 	if (!pcrypt_kset)
 		goto err;
 
-	err = __pcrypt_init_instance(&pencrypt, "pencrypt");
+	err = pcrypt_init_padata(&pencrypt, "pencrypt");
 	if (err)
 		goto err_unreg_kset;
 
-	err = __pcrypt_init_instance(&pdecrypt, "pdecrypt");
+	err = pcrypt_init_padata(&pdecrypt, "pdecrypt");
 	if (err)
 		goto err_deinit_pencrypt;
 
@@ -536,7 +534,7 @@ static int __init pcrypt_init(void)
 	return crypto_register_template(&pcrypt_tmpl);
 
 err_deinit_pencrypt:
-	__pcrypt_deinit_instance(&pencrypt);
+	pcrypt_fini_padata(&pencrypt);
 err_unreg_kset:
 	kset_unregister(pcrypt_kset);
 err:
@@ -545,8 +543,8 @@ err:
 
 static void __exit pcrypt_exit(void)
 {
-	__pcrypt_deinit_instance(&pencrypt);
-	__pcrypt_deinit_instance(&pdecrypt);
+	pcrypt_fini_padata(&pencrypt);
+	pcrypt_fini_padata(&pdecrypt);
 
 	kset_unregister(pcrypt_kset);
 	crypto_unregister_template(&pcrypt_tmpl);
-- 
1.5.6.5

