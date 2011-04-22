Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab1DVUE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 16:04:29 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55179 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458Ab1DVUEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 16:04:25 -0400
From: Julia Lawall <julia@diku.dk>
To: Ben Dooks <ben-linux@fluff.org>
Cc: kernel-janitors@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] drivers/video/s3c2410fb.c: Convert release_resource to release_mem_region
Date: Fri, 22 Apr 2011 22:11:23 +0200
Message-Id: <1303503083-26170-3-git-send-email-julia@diku.dk>
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
 drivers/video/s3c2410fb.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/video/s3c2410fb.c b/drivers/video/s3c2410fb.c
index 61c819e..0aa1376 100644
--- a/drivers/video/s3c2410fb.c
+++ b/drivers/video/s3c2410fb.c
@@ -867,7 +867,7 @@ static int __devinit s3c24xxfb_probe(struct platform_device *pdev,
 		goto dealloc_fb;
 	}
 
-	size = (res->end - res->start) + 1;
+	size = resource_size(res);
 	info->mem = request_mem_region(res->start, size, pdev->name);
 	if (info->mem == NULL) {
 		dev_err(&pdev->dev, "failed to get memory region\n");
@@ -997,8 +997,7 @@ release_irq:
 release_regs:
 	iounmap(info->io);
 release_mem:
-	release_resource(info->mem);
-	kfree(info->mem);
+	release_mem_region(res->start, size);
 dealloc_fb:
 	platform_set_drvdata(pdev, NULL);
 	framebuffer_release(fbinfo);
@@ -1044,8 +1043,7 @@ static int __devexit s3c2410fb_remove(struct platform_device *pdev)
 
 	iounmap(info->io);
 
-	release_resource(info->mem);
-	kfree(info->mem);
+	release_mem_region(info->mem->start, resource_size(info->mem));
 
 	platform_set_drvdata(pdev, NULL);
 	framebuffer_release(fbinfo);

