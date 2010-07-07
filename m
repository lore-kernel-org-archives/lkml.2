Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab0GGNaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:30:06 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:47343 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222Ab0GGNaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:30:03 -0400
Date: Wed, 7 Jul 2010 15:32:02 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Dan Kruchinin <dkruchinin@acm.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] padata: make padata_do_parallel to return zero on
 success
Message-ID: <20100707133202.GZ10072@secunet.com>
References: <20100707132915.GV10072@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100707132915.GV10072@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Jul 2010 13:30:00.0372 (UTC) FILETIME=[7FC17F40:01CB1DD8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To return -EINPROGRESS on success in padata_do_parallel was
considered to be odd. This patch changes this to return zero
on success. Also the only user of padata, pcrypt is adapted to
convert a return of zero to -EINPROGRESS within the crypto layer.
This also removes the pcrypt fallback if padata_do_parallel
was called on a not running padata instance as we can't handle it
anymore. This fallback was unused, so it's save to remove it.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/pcrypt.c |   18 ++++++------------
 kernel/padata.c |   11 +++++------
 2 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 71ae2b2..6036b6d 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -143,10 +143,8 @@ static int pcrypt_aead_encrypt(struct aead_request *req)
 	aead_request_set_assoc(creq, req->assoc, req->assoclen);
 
 	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, pcrypt_enc_padata);
-	if (err)
-		return err;
-	else
-		err = crypto_aead_encrypt(creq);
+	if (!err)
+		return -EINPROGRESS;
 
 	return err;
 }
@@ -187,10 +185,8 @@ static int pcrypt_aead_decrypt(struct aead_request *req)
 	aead_request_set_assoc(creq, req->assoc, req->assoclen);
 
 	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, pcrypt_dec_padata);
-	if (err)
-		return err;
-	else
-		err = crypto_aead_decrypt(creq);
+	if (!err)
+		return -EINPROGRESS;
 
 	return err;
 }
@@ -233,10 +229,8 @@ static int pcrypt_aead_givencrypt(struct aead_givcrypt_request *req)
 	aead_givcrypt_set_giv(creq, req->giv, req->seq);
 
 	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, pcrypt_enc_padata);
-	if (err)
-		return err;
-	else
-		err = crypto_aead_givencrypt(creq);
+	if (!err)
+		return -EINPROGRESS;
 
 	return err;
 }
diff --git a/kernel/padata.c b/kernel/padata.c
index 57ec4eb..ae8defc 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -111,10 +111,13 @@ int padata_do_parallel(struct padata_instance *pinst,
 
 	pd = rcu_dereference(pinst->pd);
 
-	err = 0;
+	err = -EINVAL;
 	if (!(pinst->flags & PADATA_INIT))
 		goto out;
 
+	if (!cpumask_test_cpu(cb_cpu, pd->cpumask))
+		goto out;
+
 	err =  -EBUSY;
 	if ((pinst->flags & PADATA_RESET))
 		goto out;
@@ -122,11 +125,7 @@ int padata_do_parallel(struct padata_instance *pinst,
 	if (atomic_read(&pd->refcnt) >= MAX_OBJ_NUM)
 		goto out;
 
-	err = -EINVAL;
-	if (!cpumask_test_cpu(cb_cpu, pd->cpumask))
-		goto out;
-
-	err = -EINPROGRESS;
+	err = 0;
 	atomic_inc(&pd->refcnt);
 	padata->pd = pd;
 	padata->cb_cpu = cb_cpu;
-- 
1.5.6.5

