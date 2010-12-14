Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab0LNJOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 04:14:34 -0500
Received: from mga03.intel.com ([143.182.124.21]:10856 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964Ab0LNJOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 04:14:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,341,1288594800"; 
   d="scan'208";a="361376800"
Subject: [GIT] dmaengine fixes for 2.6.37-rc6
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 01:21:36 -0800
Message-ID: <1292318496.6196.18.camel@dwillia2-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git fixes

...to receive:

A collection of mostly one-liners for drivers/dma/.  All but the most
recent two have seen a -next release.  The imx-sdma fix from Anatolij
addresses data corruption.

Thanks,
Dan

Anatolij Gustschin (1):
      dmaengine: imx-sdma: fix bug in buffer descriptor initialization

Axel Lin (2):
      dma: imx-dma: fix imxdma_probe error path
      dma: intel_mid_dma: fix double free on mid_setup_dma error path

Dan Williams (1):
      intel_mid_dma: fix section mismatch warnings

Forrest Shi (1):
      fsldma: fix issue of slow dma

Joe Perches (1):
      drivers/dma/ppc4xx: Use printf extension %pR for struct resource

Nicolas Ferre (1):
      dmaengine: at_hdmac: fix buffer transfer size specification

Sascha Hauer (1):
      dmaengine i.MX SDMA: initialize on module_init

Tomoya MORINAGA (1):
      dma : EG20T PCH: Fix miss-setting DMA descriptor

Tracey Dent (2):
      drivers/dma/: Use the ccflag-y instead of EXTRA_CFLAGS
      drivers/dma/ioat: Use the ccflag-y instead of EXTRA_CFLAGS

 drivers/dma/Makefile        |    4 ++--
 drivers/dma/at_hdmac.c      |    2 +-
 drivers/dma/fsldma.c        |    6 ++++--
 drivers/dma/fsldma.h        |    9 ++++++++-
 drivers/dma/imx-dma.c       |    2 +-
 drivers/dma/imx-sdma.c      |    4 ++--
 drivers/dma/intel_mid_dma.c |    8 +++-----
 drivers/dma/ioat/Makefile   |    2 +-
 drivers/dma/pch_dma.c       |   15 ++++++++-------
 drivers/dma/ppc4xx/adma.c   |    5 ++---
 10 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index a8a84f4..64b21f5 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -1,8 +1,8 @@
 ifeq ($(CONFIG_DMADEVICES_DEBUG),y)
-	EXTRA_CFLAGS	+= -DDEBUG
+	ccflags-y	+= -DDEBUG
 endif
 ifeq ($(CONFIG_DMADEVICES_VDEBUG),y)
-	EXTRA_CFLAGS	+= -DVERBOSE_DEBUG
+	ccflags-y	+= -DVERBOSE_DEBUG
 endif
 
 obj-$(CONFIG_DMA_ENGINE) += dmaengine.o
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index a0f3e6a..ea0ee81 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -722,7 +722,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			desc->lli.daddr = mem;
 			desc->lli.ctrla = ctrla
 					| ATC_DST_WIDTH(mem_width)
-					| len >> mem_width;
+					| len >> reg_width;
 			desc->lli.ctrlb = ctrlb;
 
 			if (!first) {
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 286c3ac..e5e172d2 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -50,9 +50,11 @@ static void dma_init(struct fsldma_chan *chan)
 		 * EIE - Error interrupt enable
 		 * EOSIE - End of segments interrupt enable (basic mode)
 		 * EOLNIE - End of links interrupt enable
+		 * BWC - Bandwidth sharing among channels
 		 */
-		DMA_OUT(chan, &chan->regs->mr, FSL_DMA_MR_EIE
-				| FSL_DMA_MR_EOLNIE | FSL_DMA_MR_EOSIE, 32);
+		DMA_OUT(chan, &chan->regs->mr, FSL_DMA_MR_BWC
+				| FSL_DMA_MR_EIE | FSL_DMA_MR_EOLNIE
+				| FSL_DMA_MR_EOSIE, 32);
 		break;
 	case FSL_DMA_IP_83XX:
 		/* Set the channel to below modes:
diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
index cb4d6ff..ba9f403 100644
--- a/drivers/dma/fsldma.h
+++ b/drivers/dma/fsldma.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2007 Freescale Semiconductor, Inc. All rights reserved.
+ * Copyright (C) 2007-2010 Freescale Semiconductor, Inc. All rights reserved.
  *
  * Author:
  *   Zhang Wei <wei.zhang@freescale.com>, Jul 2007
@@ -36,6 +36,13 @@
 #define FSL_DMA_MR_DAHE		0x00002000
 #define FSL_DMA_MR_SAHE		0x00001000
 
+/*
+ * Bandwidth/pause control determines how many bytes a given
+ * channel is allowed to transfer before the DMA engine pauses
+ * the current channel and switches to the next channel
+ */
+#define FSL_DMA_MR_BWC         0x08000000
+
 /* Special MR definition for MPC8349 */
 #define FSL_DMA_MR_EOTIE	0x00000080
 #define FSL_DMA_MR_PRC_RM	0x00000800
diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index f629e49..e53d438 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -379,7 +379,7 @@ static int __init imxdma_probe(struct platform_device *pdev)
 	return 0;
 
 err_init:
-	while (i-- >= 0) {
+	while (--i >= 0) {
 		struct imxdma_channel *imxdmac = &imxdma->channel[i];
 		imx_dma_free(imxdmac->imxdma_channel);
 	}
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 0834323..d0602dd 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -951,7 +951,7 @@ static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
 		struct sdma_buffer_descriptor *bd = &sdmac->bd[i];
 		int param;
 
-		bd->buffer_addr = sgl->dma_address;
+		bd->buffer_addr = sg->dma_address;
 
 		count = sg->length;
 
@@ -1385,7 +1385,7 @@ static int __init sdma_module_init(void)
 {
 	return platform_driver_probe(&sdma_driver, sdma_probe);
 }
-subsys_initcall(sdma_module_init);
+module_init(sdma_module_init);
 
 MODULE_AUTHOR("Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>");
 MODULE_DESCRIPTION("i.MX SDMA driver");
diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index 338bc4e..3109bd9 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -1075,7 +1075,6 @@ static int mid_setup_dma(struct pci_dev *pdev)
 	if (NULL == dma->dma_pool) {
 		pr_err("ERR_MDMA:pci_pool_create failed\n");
 		err = -ENOMEM;
-		kfree(dma);
 		goto err_dma_pool;
 	}
 
@@ -1186,7 +1185,6 @@ err_engine:
 	free_irq(pdev->irq, dma);
 err_irq:
 	pci_pool_destroy(dma->dma_pool);
-	kfree(dma);
 err_dma_pool:
 	pr_err("ERR_MDMA:setup_dma failed: %d\n", err);
 	return err;
@@ -1413,7 +1411,7 @@ static const struct dev_pm_ops intel_mid_dma_pm = {
 	.runtime_idle = dma_runtime_idle,
 };
 
-static struct pci_driver intel_mid_dma_pci = {
+static struct pci_driver intel_mid_dma_pci_driver = {
 	.name		=	"Intel MID DMA",
 	.id_table	=	intel_mid_dma_ids,
 	.probe		=	intel_mid_dma_probe,
@@ -1431,13 +1429,13 @@ static int __init intel_mid_dma_init(void)
 {
 	pr_debug("INFO_MDMA: LNW DMA Driver Version %s\n",
 			INTEL_MID_DMA_DRIVER_VERSION);
-	return pci_register_driver(&intel_mid_dma_pci);
+	return pci_register_driver(&intel_mid_dma_pci_driver);
 }
 fs_initcall(intel_mid_dma_init);
 
 static void __exit intel_mid_dma_exit(void)
 {
-	pci_unregister_driver(&intel_mid_dma_pci);
+	pci_unregister_driver(&intel_mid_dma_pci_driver);
 }
 module_exit(intel_mid_dma_exit);
 
diff --git a/drivers/dma/ioat/Makefile b/drivers/dma/ioat/Makefile
index 8997d3f..0ff7270 100644
--- a/drivers/dma/ioat/Makefile
+++ b/drivers/dma/ioat/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_INTEL_IOATDMA) += ioatdma.o
-ioatdma-objs := pci.o dma.o dma_v2.o dma_v3.o dca.o
+ioatdma-y := pci.o dma.o dma_v2.o dma_v3.o dca.o
diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 92b6790..c064c89 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -259,11 +259,6 @@ static void pdc_dostart(struct pch_dma_chan *pd_chan, struct pch_dma_desc* desc)
 		return;
 	}
 
-	channel_writel(pd_chan, DEV_ADDR, desc->regs.dev_addr);
-	channel_writel(pd_chan, MEM_ADDR, desc->regs.mem_addr);
-	channel_writel(pd_chan, SIZE, desc->regs.size);
-	channel_writel(pd_chan, NEXT, desc->regs.next);
-
 	dev_dbg(chan2dev(&pd_chan->chan), "chan %d -> dev_addr: %x\n",
 		pd_chan->chan.chan_id, desc->regs.dev_addr);
 	dev_dbg(chan2dev(&pd_chan->chan), "chan %d -> mem_addr: %x\n",
@@ -273,10 +268,16 @@ static void pdc_dostart(struct pch_dma_chan *pd_chan, struct pch_dma_desc* desc)
 	dev_dbg(chan2dev(&pd_chan->chan), "chan %d -> next: %x\n",
 		pd_chan->chan.chan_id, desc->regs.next);
 
-	if (list_empty(&desc->tx_list))
+	if (list_empty(&desc->tx_list)) {
+		channel_writel(pd_chan, DEV_ADDR, desc->regs.dev_addr);
+		channel_writel(pd_chan, MEM_ADDR, desc->regs.mem_addr);
+		channel_writel(pd_chan, SIZE, desc->regs.size);
+		channel_writel(pd_chan, NEXT, desc->regs.next);
 		pdc_set_mode(&pd_chan->chan, DMA_CTL0_ONESHOT);
-	else
+	} else {
+		channel_writel(pd_chan, NEXT, desc->txd.phys);
 		pdc_set_mode(&pd_chan->chan, DMA_CTL0_SG);
+	}
 
 	val = dma_readl(pd, CTL2);
 	val |= 1 << (DMA_CTL2_START_SHIFT_BITS + pd_chan->chan.chan_id);
diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
index 0d58a4a..cef5845 100644
--- a/drivers/dma/ppc4xx/adma.c
+++ b/drivers/dma/ppc4xx/adma.c
@@ -4449,9 +4449,8 @@ static int __devinit ppc440spe_adma_probe(struct platform_device *ofdev,
 
 	if (!request_mem_region(res.start, resource_size(&res),
 				dev_driver_string(&ofdev->dev))) {
-		dev_err(&ofdev->dev, "failed to request memory region "
-			"(0x%016llx-0x%016llx)\n",
-			(u64)res.start, (u64)res.end);
+		dev_err(&ofdev->dev, "failed to request memory region %pR\n",
+			&res);
 		initcode = PPC_ADMA_INIT_MEMREG;
 		ret = -EBUSY;
 		goto out;

commit 59a609d9b59be9452f168fe228befea53d5962ff
Author: Nicolas Ferre <nicolas.ferre@atmel.com>
Date:   Mon Dec 13 13:48:41 2010 +0100

    dmaengine: at_hdmac: fix buffer transfer size specification
    
    Buffer transfer size is the number of transfers to be performed in
    relation with the width of the _source_ interface.
    So in the DMA_FROM_DEVICE case, it should be the register width that
    should be taken into account.
    
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f3c677b997757326e1f29d33060719a6a5091950
Author: Forrest Shi <b29237@freescale.com>
Date:   Thu Dec 9 16:14:04 2010 +0800

    fsldma: fix issue of slow dma
    
    Fixed fsl dma slow issue by initializing dma mode register with
    bandwidth control. It boosts dma performance and should works
    with 85xx board.
    
    Signed-off-by: Forrest Shi <b29237@freescale.com>
    Signed-off-by: Li Yang <leoli@freescale.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c989a7fc139ec8975fdc230e2de42f3c4555880e
Author: Sascha Hauer <s.hauer@pengutronix.de>
Date:   Mon Dec 6 11:09:57 2010 +0100

    dmaengine i.MX SDMA: initialize on module_init
    
    The firmware framework gets initialized during fs_initcall time, so
    we are not allowed to call request_firmware earlier.
    
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 943d8d8bca431d6c93f17bf38f4b09c65e0a81d7
Author: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Date:   Wed Dec 1 19:49:48 2010 +0900

    dma : EG20T PCH: Fix miss-setting DMA descriptor
    
    Currently, in case of using scatter/gather mode, head of data is not sent to
    
    destination. The cause is second descriptor address is set to NEXT.
    
    The NEXT must have head of descriptor address.
    
    This patch sets head of descriptor address to the NEXT.
    
    Acked-by: Yong Wang <youg.y.wang@intel.com>
    Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
    [dan.j.williams@intel.com: fixed up usage of virt_to_phys()]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit cf2f9c59807f173b1c6a537fde7c83c8da876e56
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sat Dec 4 14:53:32 2010 -0800

    intel_mid_dma: fix section mismatch warnings
    
    Rename intel_mid_dma_pci to intel_mid_dma_pci_driver to pick up the
    applied annotations of that suffix.
    
    Reported-by: <major_Lee@wistron.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d2f5c276ea4b7b7e1b953926bac9d0b148fcce4e
Author: Anatolij Gustschin <agust@denx.de>
Date:   Mon Nov 22 18:35:18 2010 +0100

    dmaengine: imx-sdma: fix bug in buffer descriptor initialization
    
    Currently while submitting scatterlists with more than one SG
    entry the DMA buffer address from the first SG entry is inserted
    into all initialized DMA buffer descriptors. This is due to the
    typo in the for_each_sg() loop where the scatterlist pointer is
    used for obtaining the DMA buffer address and _not_ the SG list
    iterator.
    
    As a result all received data will be written only into the first
    DMA buffer while reading. While writing the data from the first
    DMA buffer is send to the device multiple times. This caused
    the filesystem destruction on the MMC card when using DMA in
    mxcmmc driver.
    
    Signed-off-by: Anatolij Gustschin <agust@denx.de>
    Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a584bff5efae8c1d026e3a930e3d13a90264fafc
Author: Joe Perches <joe@perches.com>
Date:   Fri Nov 12 13:37:54 2010 -0800

    drivers/dma/ppc4xx: Use printf extension %pR for struct resource
    
    Using %pR standardizes the struct resource output.
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit bca364d30d63825f36a03dcacf390943d4c2cb74
Author: Tracey Dent <tdent48227@gmail.com>
Date:   Sat Nov 6 17:01:37 2010 -0400

    drivers/dma/ioat: Use the ccflag-y instead of EXTRA_CFLAGS
    
    Changed Makefile to use <modules>-y instead of <modules>-objs. Following
    (documentation/kbuild/makefiles.txt).
    
    Signed-off-by: Tracey Dent <tdent48227@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 87e51107323a84e26a5004337217fc954e8d9545
Author: Tracey Dent <tdent48227@gmail.com>
Date:   Sat Nov 6 17:01:36 2010 -0400

    drivers/dma/: Use the ccflag-y instead of EXTRA_CFLAGS
    
    Use the ccflag-y flag instead of EXTRA_CFLAGS because EXTRA_CFLAGS is
    deprecated and should now be switched. According to (documentation/kbuild/makefiles.txt).
    
    Signed-off-by: Tracey Dent <tdent48227@gmail.com>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 51a1efe2e84493439db32c07471e835c752a7923
Author: Axel Lin <axel.lin@gmail.com>
Date:   Tue Nov 2 09:52:17 2010 +0800

    dma: intel_mid_dma: fix double free on mid_setup_dma error path
    
    We should not call kfree(dma) in mid_setup_dma error path because
    the memory is allocated in intel_mid_dma_probe and will be freed
    in intel_mid_dma_probe error path if mid_setup_dma return error.
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit cbeae41888bddb2d8c23db281de5f38f4be6a9bb
Author: Axel Lin <axel.lin@gmail.com>
Date:   Tue Nov 2 09:12:57 2010 +0800

    dma: imx-dma: fix imxdma_probe error path
    
    otherwise, i will be -1 inside the latest iteration of the while loop.
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>


