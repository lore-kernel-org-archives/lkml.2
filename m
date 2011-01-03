Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab1ACNuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:50:25 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60593 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061Ab1ACNuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=vl9/qsAOeaSJdRJmS5Y44wvaNfZ+uEqZ5TX3t+o8iETXnqWxFMi+7TJiRKfkHz/0pC
         dlckez/NPEV4kBLPc/NViMSY5nN3t3t0FYv2g898MWcWg3b7qa0bLBlJYgCdCHyW4Pum
         bI0ipTzW6BYzdQZfEnDH9UBsqomP1AOLoV2Ok=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Subject: [PATCH 05/32] crypto: mark crypto workqueues CPU_INTENSIVE
Date: Mon,  3 Jan 2011 14:49:28 +0100
Message-Id: <1294062595-30097-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcrypto_wq and pcrypt->wq's are used to run ciphers and may consume
considerable amount of CPU cycles.  Mark both as CPU_INTENSIVE so that
they don't block other work items.

As the workqueues are primarily used to burn CPU cycles, concurrency
levels shouldn't matter much and are left at 1.  A higher value may be
beneficial and needs investigation.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
---
Only compile tested.  Please feel free to take it into the subsystem
tree or simply ack - I'll route it through the wq tree.

Thanks.

 crypto/crypto_wq.c |    3 ++-
 crypto/pcrypt.c    |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/crypto_wq.c b/crypto/crypto_wq.c
index fdcf624..b980ee1 100644
--- a/crypto/crypto_wq.c
+++ b/crypto/crypto_wq.c
@@ -20,7 +20,8 @@ EXPORT_SYMBOL_GPL(kcrypto_wq);
 
 static int __init crypto_wq_init(void)
 {
-	kcrypto_wq = create_workqueue("crypto");
+	kcrypto_wq = alloc_workqueue("crypto",
+				     WQ_MEM_RECLAIM | WQ_CPU_INTENSIVE, 1);
 	if (unlikely(!kcrypto_wq))
 		return -ENOMEM;
 	return 0;
diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 75586f1..29a89da 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -455,7 +455,8 @@ static int pcrypt_init_padata(struct padata_pcrypt *pcrypt,
 
 	get_online_cpus();
 
-	pcrypt->wq = create_workqueue(name);
+	pcrypt->wq = alloc_workqueue(name,
+				     WQ_MEM_RECLAIM | WQ_CPU_INTENSIVE, 1);
 	if (!pcrypt->wq)
 		goto err;
 
-- 
1.7.1

