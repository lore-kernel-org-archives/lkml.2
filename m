Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab0F1VGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 17:06:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:42866 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755251Ab0F1VGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 17:06:17 -0400
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Cc: Tejun Heo <tj@kernel.org>, Herbert Xu <herbert@gondor.hengli.com.au>,
       "David S. Miller" <davem@davemloft.net>,
       Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 35/35] pcrypt: use HIGHPRI and CPU_INTENSIVE workqueues for padata
Date: Mon, 28 Jun 2010 23:04:23 +0200
Message-Id: <1277759063-24607-36-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1277759063-24607-1-git-send-email-tj@kernel.org>
References: <1277759063-24607-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 28 Jun 2010 21:05:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcrypt padata works are cpu intensive and shouldn't affect or be
affected by workqueue concurrency management.  Allocate padata
workqueues with WQ_HIGHPRI and WQ_CPU_INTENSIVE flags set.

Now that creating workqueues doesn't cost that much and less direct
manipulation of workers is allowed, it might make sense to update
padata interface such that it allocates workqueues with proper flags
itself.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/pcrypt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 247178c..4728cdc 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -385,11 +385,11 @@ static struct crypto_template pcrypt_tmpl = {
 
 static int __init pcrypt_init(void)
 {
-	encwq = create_workqueue("pencrypt");
+	encwq = alloc_workqueue("pencrypt", WQ_HIGHPRI | WQ_CPU_INTENSIVE, 1);
 	if (!encwq)
 		goto err;
 
-	decwq = create_workqueue("pdecrypt");
+	decwq = alloc_workqueue("pdecrypt", WQ_HIGHPRI | WQ_CPU_INTENSIVE, 1);
 	if (!decwq)
 		goto err_destroy_encwq;
 
-- 
1.6.4.2

