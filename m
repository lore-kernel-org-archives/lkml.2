Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab1CVRMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 13:12:01 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60956 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178Ab1CVRL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 13:11:59 -0400
From: Julia Lawall <julia@diku.dk>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: kernel-janitors@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sascha Sommer <saschasommer@freenet.de>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] drivers/mmc/host/mvsdio.c: Convert release_resource to release_mem_region
Date: Tue, 22 Mar 2011 18:14:53 +0100
Message-Id: <1300814095-25278-1-git-send-email-julia@diku.dk>
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
 drivers/mmc/host/mvsdio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index a5bf60e..4606087 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -825,7 +825,7 @@ out:
 			iounmap(host->base);
 	}
 	if (r)
-		release_resource(r);
+		release_mem_region(r->start, resource_size(r));
 	if (mmc)
 		mmc_free_host(mmc);
 
@@ -850,7 +850,7 @@ static int __exit mvsd_remove(struct platform_device *pdev)
 		del_timer_sync(&host->timer);
 		mvsd_power_down(host);
 		iounmap(host->base);
-		release_resource(host->res);
+		release_mem_region(host->res->start, resource_size(host->res));
 		mmc_free_host(mmc);
 	}
 	platform_set_drvdata(pdev, NULL);

