Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab1CVRMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 13:12:06 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60974 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756393Ab1CVRMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 13:12:03 -0400
From: Julia Lawall <julia@diku.dk>
To: Chris Ball <cjb@laptop.org>
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Marek Vasut <marek.vasut@gmail.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] drivers/mmc/host/pxamci.c: Convert release_resource to release_mem_region
Date: Tue, 22 Mar 2011 18:14:55 +0100
Message-Id: <1300814095-25278-3-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Request_mem_region should be used with release_mem_region, not
release_resource.

A semantic patch that partially fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@b@
expression x,E;
@@

x = request_mem_region(x->start,...)
... when != release_mem_region(x->start,...)
    when != x = E
(
- release_resource(x);
- kfree(x);
+  release_mem_region(x->start,resource_size(x));
|
?- release_resource(x);
+  release_mem_region(x->start,resource_size(x));
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mmc/host/pxamci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 7257738..b6e7e64 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -774,7 +774,7 @@ err_gpio_ro:
 	}
 	if (mmc)
 		mmc_free_host(mmc);
-	release_resource(r);
+	release_mem_region(r->start, resource_size(r));
 	return ret;
 }
 
@@ -824,7 +824,7 @@ static int pxamci_remove(struct platform_device *pdev)
 
 		clk_put(host->clk);
 
-		release_resource(host->res);
+		release_mem_region(host->res->start, resource_size(host->res));
 
 		mmc_free_host(mmc);
 	}

