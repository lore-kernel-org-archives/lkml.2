Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274Ab2CHUkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 15:40:11 -0500
Received: from mxout1.idt.com ([157.165.5.25]:37949 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab2CHUkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 15:40:06 -0500
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>, jaswinder.singh@linaro.org,
        linus.walleij@stericsson.com, leoli@freescale.com, zw@zh-kernel.org,
        STEricsson_nomadik_linux@list.st.com, ben-linux@fluff.org,
        kgene.kim@samsung.com, mchehab@infradead.org,
        ludovic.desroches@atmel.com, cjb@laptop.org, g.liakhovetski@gmx.de,
        ian@mnementh.co.uk, dwmw2@infradead.org, grant.likely@secretlab.ca,
        alan@linux.intel.com, balbi@ti.com, FlorianSchandinat@gmx.de,
        perex@perex.cz, tiwai@suse.de, viresh.kumar@st.com,
        baohua.song@csr.com, srinidhi.kasagar@stericsson.com
Subject: [PATCH 0/2 V2] dmaengine: add context parameter to prep_slave_sg and prep_dma_cyclic
Date: Thu,  8 Mar 2012 15:35:11 -0500
Message-Id: <1331238913-25818-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we agreed during our discussion about adding DMA Engine support for RapidIO
subsystem [1], RapidIO and similar clients may benefit from adding an extra
context parameter to device_prep_slave_sg() and device_prep_dma_cyclic() interfaces.

Adding the context parameter will allow to pass client/target specific
information associated with an individual data transfer request.

In the case of RapidIO support this additional information consists of target
destination ID and its buffer address (which is not mapped into the local CPU
memory space). Because a single RapidIO-capable DMA channel may queue data
transfer requests to different target devices, the per-request configuration
is required.

This set of patches presents changes to DMA_SLAVE and DMA_CYCLIC interfaces [2]
and corresponding changes to all affected current drivers/clients.

V.2 of the patches is reworked to implement wrappers and use staged approach
as proposed by Russell King [3]. 

DMA Engine support for RapidIO and device-specific driver for Tsi721 PCIe-to-SRIO
bridge will follow as a separate set of patches.

[1] https://lkml.org/lkml/2011/10/24/275
[2] https://lkml.org/lkml/2012/1/30/624
[3] https://lkml.org/lkml/2012/2/3/269

Alexandre Bounine (2):
  dmaengine/dma_slave: introduce inline wrappers
  dmaengine: add context parameter to prep_slave_sg and prep_dma_cyclic

 arch/arm/plat-nomadik/include/plat/ste_dma40.h |    3 +-
 arch/arm/plat-samsung/dma-ops.c                |    4 +-
 drivers/dma/amba-pl08x.c                       |    2 +-
 drivers/dma/at_hdmac.c                         |    7 ++++-
 drivers/dma/coh901318.c                        |    2 +-
 drivers/dma/dw_dmac.c                          |    2 +-
 drivers/dma/ep93xx_dma.c                       |    6 +++-
 drivers/dma/fsldma.c                           |    4 ++-
 drivers/dma/imx-dma.c                          |    5 ++-
 drivers/dma/imx-sdma.c                         |    5 ++-
 drivers/dma/intel_mid_dma.c                    |    3 +-
 drivers/dma/ipu/ipu_idmac.c                    |    3 +-
 drivers/dma/mxs-dma.c                          |    5 ++-
 drivers/dma/pch_dma.c                          |    3 +-
 drivers/dma/pl330.c                            |    5 ++-
 drivers/dma/shdma.c                            |    3 +-
 drivers/dma/sirf-dma.c                         |    2 +-
 drivers/dma/ste_dma40.c                        |    5 ++-
 drivers/dma/timb_dma.c                         |    3 +-
 drivers/dma/txx9dmac.c                         |    2 +-
 drivers/media/video/mx3_camera.c               |    2 +-
 drivers/media/video/timblogiw.c                |    2 +-
 drivers/mmc/host/atmel-mci.c                   |    2 +-
 drivers/mmc/host/mmci.c                        |    2 +-
 drivers/mmc/host/mxcmmc.c                      |    2 +-
 drivers/mmc/host/mxs-mmc.c                     |    2 +-
 drivers/mmc/host/sh_mmcif.c                    |    4 +-
 drivers/mmc/host/tmio_mmc_dma.c                |    4 +-
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c          |   25 ++++++++++-------------
 drivers/net/ethernet/micrel/ks8842.c           |    4 +-
 drivers/spi/spi-dw-mid.c                       |    4 +-
 drivers/spi/spi-ep93xx.c                       |    4 +-
 drivers/spi/spi-pl022.c                        |    4 +-
 drivers/spi/spi-topcliff-pch.c                 |    4 +-
 drivers/tty/serial/amba-pl011.c                |    6 +---
 drivers/tty/serial/pch_uart.c                  |    4 +-
 drivers/tty/serial/sh-sci.c                    |    4 +-
 drivers/usb/musb/ux500_dma.c                   |    3 +-
 drivers/usb/renesas_usbhs/fifo.c               |    5 +--
 drivers/video/mx3fb.c                          |    4 +-
 include/linux/dmaengine.h                      |   24 ++++++++++++++++++++--
 sound/soc/ep93xx/ep93xx-pcm.c                  |    3 +-
 sound/soc/imx/imx-pcm-dma-mx2.c                |    2 +-
 sound/soc/mxs/mxs-pcm.c                        |    2 +-
 sound/soc/sh/siu_pcm.c                         |    4 +-
 sound/soc/txx9/txx9aclc.c                      |    2 +-
 46 files changed, 114 insertions(+), 88 deletions(-)

-- 
1.7.8.4

