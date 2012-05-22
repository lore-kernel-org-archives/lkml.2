Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512Ab2EVAwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 20:52:19 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:31777 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab2EVAwS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 20:52:18 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-131.messagelabs.com!1337647936!20132595!2
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: gsc_hpdi: plx9080_iobase and hpdi_iobase are void __iomem *
Date: Mon, 21 May 2012 17:52:07 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <201205211752.08267.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The plx9080_iobase and hpdi_iobase variables in struct hpdi_private
are ioremap'ed pci resource and should be void __iomem * not void *.

This quiets a lot of sparse warings for the writel and readl calls
like:

warning: incorrect type in argument 1 (different address spaces)
   expected void const volatile [noderef] <asn:2>*addr
   got void *<noident>

warning: incorrect type in argument 2 (different address spaces)
   expected void volatile [noderef] <asn:2>*addr
   got void *

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/gsc_hpdi.c b/drivers/staging/comedi/drivers/gsc_hpdi.c
index 8aece08..e41c664 100644
--- a/drivers/staging/comedi/drivers/gsc_hpdi.c
+++ b/drivers/staging/comedi/drivers/gsc_hpdi.c
@@ -297,8 +297,8 @@ struct hpdi_private {
 	resource_size_t plx9080_phys_iobase;
 	resource_size_t hpdi_phys_iobase;
 	/*  base addresses (ioremapped) */
-	void *plx9080_iobase;
-	void *hpdi_iobase;
+	void __iomem *plx9080_iobase;
+	void __iomem *hpdi_iobase;
 	uint32_t *dio_buffer[NUM_DMA_BUFFERS];	/*  dma buffers */
 	/* physical addresses of dma buffers */
 	dma_addr_t dio_buffer_phys_addr[NUM_DMA_BUFFERS];
@@ -364,7 +364,7 @@ static void disable_plx_interrupts(struct comedi_device *dev)
 static void init_plx9080(struct comedi_device *dev)
 {
 	uint32_t bits;
-	void *plx_iobase = priv(dev)->plx9080_iobase;
+	void __iomem *plx_iobase = priv(dev)->plx9080_iobase;
 
 	/*  plx9080 dump */
 	DEBUG_PRINT(" plx interrupt status 0x%x\n",
@@ -673,10 +673,10 @@ static void hpdi_detach(struct comedi_device *dev)
 	if ((priv(dev)) && (priv(dev)->hw_dev)) {
 		if (priv(dev)->plx9080_iobase) {
 			disable_plx_interrupts(dev);
-			iounmap((void *)priv(dev)->plx9080_iobase);
+			iounmap(priv(dev)->plx9080_iobase);
 		}
 		if (priv(dev)->hpdi_iobase)
-			iounmap((void *)priv(dev)->hpdi_iobase);
+			iounmap(priv(dev)->hpdi_iobase);
 		/*  free pci dma buffers */
 		for (i = 0; i < NUM_DMA_BUFFERS; i++) {
 			if (priv(dev)->dio_buffer[i])
@@ -903,7 +903,7 @@ static void drain_dma_buffers(struct comedi_device *dev, unsigned int channel)
 	uint32_t next_transfer_addr;
 	int j;
 	int num_samples = 0;
-	void *pci_addr_reg;
+	void __iomem *pci_addr_reg;
 
 	if (channel)
 		pci_addr_reg =
