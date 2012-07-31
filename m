Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab2GaQku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:40:50 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:21600 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755666Ab2GaQj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 12:39:27 -0400
X-IronPort-AV: E=Sophos;i="4.77,688,1336341600"; 
   d="scan'208";a="168700819"
From: Damien Cassou <damien.cassou@lifl.fr>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] drivers/video/mbx/mbxfb.c: use devm_ functions
Date: Tue, 31 Jul 2012 18:39:18 +0200
Message-Id: <1343752762-16861-2-git-send-email-damien.cassou@lifl.fr>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1343752762-16861-1-git-send-email-damien.cassou@lifl.fr>
References: <1343752762-16861-1-git-send-email-damien.cassou@lifl.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Damien Cassou <damien.cassou@lifl.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

Signed-off-by: Damien Cassou <damien.cassou@lifl.fr>

---
 drivers/video/mbx/mbxfb.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/video/mbx/mbxfb.c b/drivers/video/mbx/mbxfb.c
index 85e4f44..9229acf 100644
--- a/drivers/video/mbx/mbxfb.c
+++ b/drivers/video/mbx/mbxfb.c
@@ -939,8 +939,9 @@ static int __devinit mbxfb_probe(struct platform_device *dev)
 	}
 	mfbi->reg_phys_addr = mfbi->reg_res->start;
 
-	mfbi->reg_virt_addr = ioremap_nocache(mfbi->reg_phys_addr,
-					      res_size(mfbi->reg_req));
+	mfbi->reg_virt_addr = devm_ioremap_nocache(&dev->dev,
+						   mfbi->reg_phys_addr,
+						   res_size(mfbi->reg_req));
 	if (!mfbi->reg_virt_addr) {
 		dev_err(&dev->dev, "failed to ioremap Marathon registers\n");
 		ret = -EINVAL;
@@ -948,12 +949,12 @@ static int __devinit mbxfb_probe(struct platform_device *dev)
 	}
 	virt_base_2700 = mfbi->reg_virt_addr;
 
-	mfbi->fb_virt_addr = ioremap_nocache(mfbi->fb_phys_addr,
-					     res_size(mfbi->fb_req));
+	mfbi->fb_virt_addr = devm_ioremap_nocache(&dev->dev, mfbi->fb_phys_addr,
+						  res_size(mfbi->fb_req));
 	if (!mfbi->fb_virt_addr) {
 		dev_err(&dev->dev, "failed to ioremap frame buffer\n");
 		ret = -EINVAL;
-		goto err4;
+		goto err3;
 	}
 
 	fbi->screen_base = (char __iomem *)(mfbi->fb_virt_addr + 0x60000);
@@ -971,7 +972,7 @@ static int __devinit mbxfb_probe(struct platform_device *dev)
 	if (ret < 0) {
 		dev_err(&dev->dev, "fb_alloc_cmap failed\n");
 		ret = -EINVAL;
-		goto err5;
+		goto err3;
 	}
 
 	platform_set_drvdata(dev, fbi);
@@ -996,10 +997,6 @@ static int __devinit mbxfb_probe(struct platform_device *dev)
 
 err6:
 	fb_dealloc_cmap(&fbi->cmap);
-err5:
-	iounmap(mfbi->fb_virt_addr);
-err4:
-	iounmap(mfbi->reg_virt_addr);
 err3:
 	release_mem_region(mfbi->reg_res->start, res_size(mfbi->reg_res));
 err2:
@@ -1026,10 +1023,7 @@ static int __devexit mbxfb_remove(struct platform_device *dev)
 			if (mfbi->platform_remove)
 				mfbi->platform_remove(fbi);
 
-			if (mfbi->fb_virt_addr)
-				iounmap(mfbi->fb_virt_addr);
-			if (mfbi->reg_virt_addr)
-				iounmap(mfbi->reg_virt_addr);
+
 			if (mfbi->reg_req)
 				release_mem_region(mfbi->reg_req->start,
 						   res_size(mfbi->reg_req));

