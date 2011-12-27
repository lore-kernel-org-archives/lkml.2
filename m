Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab1L0OCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 09:02:24 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:44218 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028Ab1L0OBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 09:01:43 -0500
From: Julia Lawall <julia@diku.dk>
To: Matt Mackall <mpm@selenic.com>
Cc: kernel-janitors@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] drivers/char/hw_random/tx4939-rng.c: use devm_request_and_ioremap
Date: Tue, 27 Dec 2011 15:01:30 +0100
Message-Id: <1324994491-21828-6-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1324994491-21828-1-git-send-email-julia@diku.dk>
References: <1324994491-21828-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Reimplement a call to devm_request_mem_region followed by a call to ioremap
or ioremap_nocache by a call to devm_request_and_ioremap.

The semantic patch that makes this transformation is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@nm@
expression myname;
identifier i;
@@

struct platform_driver i = { .driver = { .name = myname } };

@@
expression dev,res,size;
expression nm.myname;
@@

-if (!devm_request_mem_region(dev, res->start, size,
-                              \(res->name\|dev_name(dev)\|myname\))) {
-   ...
-   return ...;
-}
... when != res->start
(
-devm_ioremap(dev,res->start,size)
+devm_request_and_ioremap(dev,res)
|
-devm_ioremap_nocache(dev,res->start,size)
+devm_request_and_ioremap(dev,res)
)
... when any
    when != res->start
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/char/hw_random/tx4939-rng.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/tx4939-rng.c b/drivers/char/hw_random/tx4939-rng.c
index 0bc0cb7..de473ef 100644
--- a/drivers/char/hw_random/tx4939-rng.c
+++ b/drivers/char/hw_random/tx4939-rng.c
@@ -115,10 +115,7 @@ static int __init tx4939_rng_probe(struct platform_device *dev)
 	rngdev = devm_kzalloc(&dev->dev, sizeof(*rngdev), GFP_KERNEL);
 	if (!rngdev)
 		return -ENOMEM;
-	if (!devm_request_mem_region(&dev->dev, r->start, resource_size(r),
-				     dev_name(&dev->dev)))
-		return -EBUSY;
-	rngdev->base = devm_ioremap(&dev->dev, r->start, resource_size(r));
+	rngdev->base = devm_request_and_ioremap(&dev->dev, r);
 	if (!rngdev->base)
 		return -EBUSY;
 

