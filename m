Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab1DVUEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 16:04:30 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55183 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076Ab1DVUE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 16:04:26 -0400
From: Julia Lawall <julia@diku.dk>
To: Paul Mundt <lethal@linux-sh.org>
Cc: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] drivers/video: Convert release_resource to release_mem_region
Date: Fri, 22 Apr 2011 22:11:21 +0200
Message-Id: <1303503083-26170-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Request_mem_region should be used with release_mem_region, not
release_resource.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@s exists@
expression e1,e2,e3,e4,e;
@@

*e4 = request_mem_region(e1,e2,e3)
... when != e4 = e
*release_resource(e4);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/video/s3c-fb.c   |    6 ++----
 drivers/video/sh7760fb.c |    6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
index 3fa7911..d570e58 100644
--- a/drivers/video/s3c-fb.c
+++ b/drivers/video/s3c-fb.c
@@ -1449,8 +1449,7 @@ err_ioremap:
 	iounmap(sfb->regs);
 
 err_req_region:
-	release_resource(sfb->regs_res);
-	kfree(sfb->regs_res);
+	release_mem_region(sfb->regs_res->start, resource_size(sfb->regs_res));
 
 err_clk:
 	clk_disable(sfb->bus_clk);
@@ -1486,8 +1485,7 @@ static int __devexit s3c_fb_remove(struct platform_device *pdev)
 	clk_disable(sfb->bus_clk);
 	clk_put(sfb->bus_clk);
 
-	release_resource(sfb->regs_res);
-	kfree(sfb->regs_res);
+	release_mem_region(sfb->regs_res->start, resource_size(sfb->regs_res));
 
 	kfree(sfb);
 
diff --git a/drivers/video/sh7760fb.c b/drivers/video/sh7760fb.c
index 8fe1958..45e47d8 100644
--- a/drivers/video/sh7760fb.c
+++ b/drivers/video/sh7760fb.c
@@ -551,8 +551,7 @@ out_unmap:
 		free_irq(par->irq, &par->vsync);
 	iounmap(par->base);
 out_res:
-	release_resource(par->ioarea);
-	kfree(par->ioarea);
+	release_mem_region(res->start, resource_size(res));
 out_fb:
 	framebuffer_release(info);
 	return ret;
@@ -570,8 +569,7 @@ static int __devexit sh7760fb_remove(struct platform_device *dev)
 	if (par->irq >= 0)
 		free_irq(par->irq, par);
 	iounmap(par->base);
-	release_resource(par->ioarea);
-	kfree(par->ioarea);
+	release_mem_region(par->ioarea->start, resource_size(par->ioarea));
 	framebuffer_release(info);
 	platform_set_drvdata(dev, NULL);
 

