Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab2GaQk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:40:28 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:44887 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755682Ab2GaQj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 12:39:27 -0400
X-IronPort-AV: E=Sophos;i="4.77,688,1336341600"; 
   d="scan'208";a="168700820"
From: Damien Cassou <damien.cassou@lifl.fr>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] drivers/video/gbefb.c: use devm_ functions
Date: Tue, 31 Jul 2012 18:39:19 +0200
Message-Id: <1343752762-16861-3-git-send-email-damien.cassou@lifl.fr>
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
 drivers/video/gbefb.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/video/gbefb.c b/drivers/video/gbefb.c
index 7e7b7a9..9b79d38 100644
--- a/drivers/video/gbefb.c
+++ b/drivers/video/gbefb.c
@@ -1156,7 +1156,8 @@ static int __devinit gbefb_probe(struct platform_device *p_dev)
 		goto out_release_framebuffer;
 	}
 
-	gbe = (struct sgi_gbe *) ioremap(GBE_BASE, sizeof(struct sgi_gbe));
+	gbe = (struct sgi_gbe *) devm_ioremap(&p_dev->dev, GBE_BASE,
+					      sizeof(struct sgi_gbe));
 	if (!gbe) {
 		printk(KERN_ERR "gbefb: couldn't map mmio region\n");
 		ret = -ENXIO;
@@ -1170,12 +1171,13 @@ static int __devinit gbefb_probe(struct platform_device *p_dev)
 	if (!gbe_tiles.cpu) {
 		printk(KERN_ERR "gbefb: couldn't allocate tiles table\n");
 		ret = -ENOMEM;
-		goto out_unmap;
+		goto out_release_mem_region;
 	}
 
 	if (gbe_mem_phys) {
 		/* memory was allocated at boot time */
-		gbe_mem = ioremap_nocache(gbe_mem_phys, gbe_mem_size);
+		gbe_mem = devm_ioremap_nocache(&p_dev->dev, gbe_mem_phys,
+					       gbe_mem_size);
 		if (!gbe_mem) {
 			printk(KERN_ERR "gbefb: couldn't map framebuffer\n");
 			ret = -ENOMEM;
@@ -1241,13 +1243,9 @@ static int __devinit gbefb_probe(struct platform_device *p_dev)
 out_gbe_unmap:
 	if (gbe_dma_addr)
 		dma_free_coherent(NULL, gbe_mem_size, gbe_mem, gbe_mem_phys);
-	else
-		iounmap(gbe_mem);
 out_tiles_free:
 	dma_free_coherent(NULL, GBE_TLB_SIZE * sizeof(uint16_t),
 			  (void *)gbe_tiles.cpu, gbe_tiles.dma);
-out_unmap:
-	iounmap(gbe);
 out_release_mem_region:
 	release_mem_region(GBE_BASE, sizeof(struct sgi_gbe));
 out_release_framebuffer:
@@ -1264,12 +1262,9 @@ static int __devexit gbefb_remove(struct platform_device* p_dev)
 	gbe_turn_off();
 	if (gbe_dma_addr)
 		dma_free_coherent(NULL, gbe_mem_size, gbe_mem, gbe_mem_phys);
-	else
-		iounmap(gbe_mem);
 	dma_free_coherent(NULL, GBE_TLB_SIZE * sizeof(uint16_t),
 			  (void *)gbe_tiles.cpu, gbe_tiles.dma);
 	release_mem_region(GBE_BASE, sizeof(struct sgi_gbe));
-	iounmap(gbe);
 	gbefb_remove_sysfs(&p_dev->dev);
 	framebuffer_release(info);
 

