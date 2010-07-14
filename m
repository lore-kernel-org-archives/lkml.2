Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab0GNKeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 06:34:21 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54127 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab0GNKeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 06:34:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=FnA1OlGtb4R5tw5W4K0la7KmdnkkZr4OH6KzMQx55HzGCn3Z1QOMc5pb0tdu6ncN9/
         iERFPQURf41egXnxIBJuuAcfAai/5NS5W3TkuKFMadPz8fIM9VxANo1wFB5muncnczLX
         h1HagNib+tZyObHTiT16LzX27upebQY8GCa+E=
Date: Wed, 14 Jul 2010 14:34:15 +0400
From: Dan Kruchinin <dkruchinin@acm.org>
To: Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Added sysfs interface to pcrypt.
Message-ID: <20100714143415.3770997d@leibniz>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added sysfs interface to pcrypt. Now pcrypt subsystem creates two
sysfs directories with corresponding padata sysfs objects:
 /sys/kernel/pcrypt/[pencrypt|pdecrypt]


Signed-off-by: Dan Kruchinin <dkruchinin@acm.org>
---
 crypto/pcrypt.c |   35 ++++++++++++++++++++++++++++++++---
 1 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index c9662e2..7153a50 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -25,9 +25,11 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/notifier.h>
+#include <linux/kobject.h>
 #include <crypto/pcrypt.h>
 
 struct pcrypt_instance {
+	const char *name;
 	struct padata_instance *pinst;
 	struct workqueue_struct *wq;
 
@@ -55,7 +57,7 @@ struct pcrypt_instance {
 
 static struct pcrypt_instance pencrypt;
 static struct pcrypt_instance pdecrypt;
-
+static struct kset           *pcrypt_kset;
 
 struct pcrypt_instance_ctx {
 	struct crypto_spawn spawn;
@@ -429,12 +431,25 @@ static int pcrypt_cpumask_change_notify(struct notifier_block *self,
 	return 0;
 }
 
+static int pcrypt_sysfs_add(struct padata_instance *pinst, const char *name)
+{
+	int ret;
+
+	pinst->kobj.kset = pcrypt_kset;
+	ret = kobject_add(&pinst->kobj, NULL, name);
+	if (!ret)
+		kobject_uevent(&pinst->kobj, KOBJ_ADD);
+
+	return ret;
+}
+
 static int __pcrypt_init_instance(struct pcrypt_instance *pcrypt,
 				  const char *name)
 {
 	int ret = -ENOMEM;
 	struct pcrypt_cpumask *mask;
 
+	pcrypt->name = name;
 	pcrypt->wq = create_workqueue(name);
 	if (!pcrypt->wq)
 		goto err;
@@ -459,7 +474,13 @@ static int __pcrypt_init_instance(struct pcrypt_instance *pcrypt,
 	if (ret)
 		goto err_free_cpumask;
 
+	ret = pcrypt_sysfs_add(pcrypt->pinst, name);
+	if (ret)
+		goto err_unregister_notifier;
+
 	return ret;
+err_unregister_notifier:
+	padata_unregister_cpumask_notifier(pcrypt->pinst, &pcrypt->nblock);
 err_free_cpumask:
 	free_cpumask_var(mask->mask);
 	kfree(mask);
@@ -473,6 +494,7 @@ err:
 
 static void __pcrypt_deinit_instance(struct pcrypt_instance *pcrypt)
 {
+	kobject_put(&pcrypt->pinst->kobj);
 	free_cpumask_var(pcrypt->cb_cpumask->mask);
 	kfree(pcrypt->cb_cpumask);
 
@@ -491,11 +513,15 @@ static struct crypto_template pcrypt_tmpl = {
 
 static int __init pcrypt_init(void)
 {
-	int err;
+	int err = -ENOMEM;
+
+	pcrypt_kset = kset_create_and_add("pcrypt", NULL, kernel_kobj);
+	if (!pcrypt_kset)
+		goto err;
 
 	err = __pcrypt_init_instance(&pencrypt, "pencrypt");
 	if (err)
-		goto err;
+		goto err_unreg_kset;
 
 	err = __pcrypt_init_instance(&pdecrypt, "pdecrypt");
 	if (err)
@@ -508,6 +534,8 @@ static int __init pcrypt_init(void)
 
 err_deinit_pencrypt:
 	__pcrypt_deinit_instance(&pencrypt);
+err_unreg_kset:
+	kset_unregister(pcrypt_kset);
 err:
 	return err;
 }
@@ -517,6 +545,7 @@ static void __exit pcrypt_exit(void)
 	__pcrypt_deinit_instance(&pencrypt);
 	__pcrypt_deinit_instance(&pdecrypt);
 
+	kset_unregister(pcrypt_kset);
 	crypto_unregister_template(&pcrypt_tmpl);
 }
 
-- 
1.7.1


-- 
W.B.R.
Dan Kruchinin
