Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab1DVUEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 16:04:33 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55181 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab1DVUE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 16:04:26 -0400
From: Julia Lawall <julia@diku.dk>
To: Paul Mundt <lethal@linux-sh.org>
Cc: kernel-janitors@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 2/3] drivers/video/sm501fb.c: Convert release_resource to release_mem_region
Date: Fri, 22 Apr 2011 22:11:22 +0200
Message-Id: <1303503083-26170-2-git-send-email-julia@diku.dk>
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
 drivers/video/sm501fb.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/video/sm501fb.c b/drivers/video/sm501fb.c
index 56ef6b3..87f0be1 100644
--- a/drivers/video/sm501fb.c
+++ b/drivers/video/sm501fb.c
@@ -1625,22 +1625,22 @@ static int sm501fb_start(struct sm501fb_info *info,
 	return 0; /* everything is setup */
 
  err_mem_res:
-	release_resource(info->fbmem_res);
-	kfree(info->fbmem_res);
+	release_mem_region(info->fbmem_res->start,
+			   resource_size(info->fbmem_res));
 
  err_regs2d_map:
 	iounmap(info->regs2d);
 
  err_regs2d_res:
-	release_resource(info->regs2d_res);
-	kfree(info->regs2d_res);
+	release_mem_region(info->regs2d_res->start,
+			   resource_size(info->regs2d_res));
 
  err_regs_map:
 	iounmap(info->regs);
 
  err_regs_res:
-	release_resource(info->regs_res);
-	kfree(info->regs_res);
+	release_mem_region(info->regs_res->start,
+			   resource_size(info->regs_res));
 
  err_release:
 	return ret;
@@ -1652,16 +1652,16 @@ static void sm501fb_stop(struct sm501fb_info *info)
 	sm501_unit_power(info->dev->parent, SM501_GATE_DISPLAY, 0);
 
 	iounmap(info->fbmem);
-	release_resource(info->fbmem_res);
-	kfree(info->fbmem_res);
+	release_mem_region(info->fbmem_res->start,
+			   resource_size(info->fbmem_res));
 
 	iounmap(info->regs2d);
-	release_resource(info->regs2d_res);
-	kfree(info->regs2d_res);
+	release_mem_region(info->regs2d_res->start,
+			   resource_size(info->regs2d_res));
 
 	iounmap(info->regs);
-	release_resource(info->regs_res);
-	kfree(info->regs_res);
+	release_mem_region(info->regs_res->start,
+			   resource_size(info->regs_res));
 }
 
 static int sm501fb_init_fb(struct fb_info *fb,

