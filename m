Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191Ab1FARMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:12:07 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:38632 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759021Ab1FARKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:10:22 -0400
From: Julia Lawall <julia@diku.dk>
To: Matt Mackall <mpm@selenic.com>
Cc: kernel-janitors@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/10] drivers/char/hw_random/nomadik-rng.c: add missing clk_put
Date: Wed,  1 Jun 2011 19:10:09 +0200
Message-Id: <1306948213-20767-6-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Jump to the end of the function for the clk_disable and clk_put rather than
returning directly.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression e1,e2;
statement S;
@@

e1 = clk_get@p1(...);
... when != e1 = e2
    when != clk_put(e1)
    when any
if (...) { ... when != clk_put(e1)
               when != if (...) { ... clk_put(e1) ... }
* return@p3 ...;
 } else S
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/char/hw_random/nomadik-rng.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/nomadik-rng.c b/drivers/char/hw_random/nomadik-rng.c
index dd1d143..52e08ca 100644
--- a/drivers/char/hw_random/nomadik-rng.c
+++ b/drivers/char/hw_random/nomadik-rng.c
@@ -55,7 +55,7 @@ static int nmk_rng_probe(struct amba_device *dev, const struct amba_id *id)
 
 	ret = amba_request_regions(dev, dev->dev.init_name);
 	if (ret)
-		return ret;
+		goto out_clk;
 	ret = -ENOMEM;
 	base = ioremap(dev->res.start, resource_size(&dev->res));
 	if (!base)
@@ -70,6 +70,7 @@ out_unmap:
 	iounmap(base);
 out_release:
 	amba_release_regions(dev);
+out_clk:
 	clk_disable(rng_clk);
 	clk_put(rng_clk);
 	return ret;

