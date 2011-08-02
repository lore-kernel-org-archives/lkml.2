Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab1HBQm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 12:42:57 -0400
Received: from www17.your-server.de ([213.133.104.17]:35088 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab1HBQmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 12:42:53 -0400
Subject: [PATCH] Use resource_size()
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Date: Tue, 02 Aug 2011 18:42:24 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312303347.2629.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Use resource_size function on resource object
 instead of explicit computation.

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/resource_size.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/media/video/davinci/vpbe_osd.c b/drivers/media/video/davinci/vpbe_osd.c
--- a/drivers/media/video/davinci/vpbe_osd.c 2011-07-30 11:10:29.138430171 +0200
+++ b/drivers/media/video/davinci/vpbe_osd.c 2011-08-01 22:50:30.997700024 +0200
@@ -1162,7 +1162,7 @@ static int osd_probe(struct platform_dev
 		goto free_mem;
 	}
 	osd->osd_base_phys = res->start;
-	osd->osd_size = res->end - res->start + 1;
+	osd->osd_size = resource_size(res);
 	if (!request_mem_region(osd->osd_base_phys, osd->osd_size,
 				MODULE_NAME)) {
 		dev_err(osd->dev, "Unable to reserve OSD MMIO region\n");
diff -u -p a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
--- a/drivers/dma/ipu/ipu_idmac.c 2011-07-26 00:46:07.396850877 +0200
+++ b/drivers/dma/ipu/ipu_idmac.c 2011-08-01 22:52:59.680227876 +0200
@@ -1707,7 +1707,7 @@ static int __init ipu_probe(struct platf
 
 	/* Remap IPU common registers */
 	ipu_data.reg_ipu = ioremap(mem_ipu->start,
-				   mem_ipu->end - mem_ipu->start + 1);
+				   resource_size(mem_ipu));
 	if (!ipu_data.reg_ipu) {
 		ret = -ENOMEM;
 		goto err_ioremap_ipu;
@@ -1715,7 +1715,7 @@ static int __init ipu_probe(struct platf
 
 	/* Remap Image Converter and Image DMA Controller registers */
 	ipu_data.reg_ic = ioremap(mem_ic->start,
-				  mem_ic->end - mem_ic->start + 1);
+				  resource_size(mem_ic));
 	if (!ipu_data.reg_ic) {
 		ret = -ENOMEM;
 		goto err_ioremap_ic;
diff -u -p a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
--- a/drivers/dma/at_hdmac.c 2011-06-07 00:56:19.895211029 +0200
+++ b/drivers/dma/at_hdmac.c 2011-08-01 22:53:01.896882533 +0200
@@ -1216,7 +1216,7 @@ static int __init at_dma_probe(struct pl
 	atdma->dma_common.cap_mask = pdata->cap_mask;
 	atdma->all_chan_mask = (1 << pdata->nr_channels) - 1;
 
-	size = io->end - io->start + 1;
+	size = resource_size(io);
 	if (!request_mem_region(io->start, size, pdev->dev.driver->name)) {
 		err = -EBUSY;
 		goto err_kfree;
@@ -1362,7 +1362,7 @@ static int __exit at_dma_remove(struct p
 	atdma->regs = NULL;
 
 	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(io->start, io->end - io->start + 1);
+	release_mem_region(io->start, resource_size(io));
 
 	kfree(atdma);
 
diff -u -p a/drivers/xen/xen-pciback/conf_space_header.c b/drivers/xen/xen-pciback/conf_space_header.c
--- a/drivers/xen/xen-pciback/conf_space_header.c 2011-07-26 00:46:09.730171570 +0200
+++ b/drivers/xen/xen-pciback/conf_space_header.c 2011-08-01 23:02:39.180421787 +0200
@@ -187,7 +187,7 @@ static inline void read_dev_bar(struct p
 
 	bar_info->val = res[pos].start |
 			(res[pos].flags & PCI_REGION_FLAG_MASK);
-	bar_info->len_val = res[pos].end - res[pos].start + 1;
+	bar_info->len_val = resource_size(res);
 }
 
 static void *bar_init(struct pci_dev *dev, int offset)


