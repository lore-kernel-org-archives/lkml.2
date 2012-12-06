Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422705Ab2LFJpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:45:13 -0500
Received: from outmail006.ash2.facebook.com ([66.220.155.140]:48704 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422691Ab2LFJpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:45:10 -0500
X-Greylist: delayed 1201 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Dec 2012 04:45:10 EST
Subject: [PATCH 00/12] dmaengine_unmap_data
To: linux-kernel@vger.kernel.org
From: Dan Williams <djbw@fb.com>
Cc: vinod.koul@intel.com, linux@arm.linux.org.uk, dave.jiang@intel.com
Date: Thu, 06 Dec 2012 01:25:08 -0800
Message-ID: <20121206091055.17085.47979.stgit@dev279.prn1.facebook.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmaengine from the beginning has placed the burden of unmapping dma
buffers on the individual drivers.  The thought being that since the dma
driver already has the descriptor it can use that information for
unmapping.  This results in a lot of cruft to read back data from
descriptors, places a burden on channels that need to break up an
operation internally into multiple descriptors, and makes it difficult
to have dma mappings with different lifetimes than the current
operation.

For example an xor->copy->xor chain wants to leave all buffers
mapped until completion, async_tx currently performs invalid overlapping
mappings.  With dmaengine_unmap_data map once and take a reference for
descriptor that uses the mapping.

Thanks to Bart for getting this cleanup started!

I'll also push this out to the 'unmap' branch:
git://git.kernel.org/pub/scm/linux/kernel/git/djbw/dmaengine unmap

--
Dan


---

Bartlomiej Zolnierkiewicz (2):
      dmaengine: remove DMA unmap from drivers
      dmaengine: remove DMA unmap flags

Dan Williams (10):
      dmaengine: consolidate memcpy apis
      dmaengine: prepare for generic 'unmap' data
      dmaengine: reference counted unmap data
      async_memcpy: convert to dmaengine_unmap_data
      async_memset: convert to dmaengine_unmap_data
      async_xor: convert to dmaengine_unmap_data
      async_xor_val: convert to dmaengine_unmap_data
      async_raid6_recov: convert to dmaengine_unmap_data
      async_pq: convert to dmaengine_unmap_data
      async_pq_val: convert to dmaengine_unmap_data


 arch/arm/include/asm/hardware/iop3xx-adma.h |   30 ---
 arch/arm/include/asm/hardware/iop_adma.h    |    4 
 arch/arm/mach-iop13xx/include/mach/adma.h   |   26 ---
 crypto/async_tx/async_memcpy.c              |   36 ++--
 crypto/async_tx/async_memset.c              |   15 +-
 crypto/async_tx/async_pq.c                  |  174 ++++++++++-------
 crypto/async_tx/async_raid6_recov.c         |   61 ++++--
 crypto/async_tx/async_xor.c                 |  122 +++++++-----
 drivers/ata/pata_arasan_cf.c                |    3 
 drivers/dma/amba-pl08x.c                    |   32 ---
 drivers/dma/at_hdmac.c                      |   26 ---
 drivers/dma/dmaengine.c                     |  261 ++++++++++++++++++--------
 drivers/dma/dmatest.c                       |    3 
 drivers/dma/dw_dmac.c                       |   21 --
 drivers/dma/ep93xx_dma.c                    |   30 ---
 drivers/dma/fsldma.c                        |   17 --
 drivers/dma/ioat/dma.c                      |   20 --
 drivers/dma/ioat/dma.h                      |   12 -
 drivers/dma/ioat/dma_v2.c                   |    2 
 drivers/dma/ioat/dma_v3.c                   |  143 +-------------
 drivers/dma/iop-adma.c                      |   99 ----------
 drivers/dma/mv_xor.c                        |   46 -----
 drivers/dma/ppc4xx/adma.c                   |  270 ---------------------------
 drivers/dma/timb_dma.c                      |   37 ----
 drivers/dma/txx9dmac.c                      |   25 ---
 drivers/media/platform/m2m-deinterlace.c    |    3 
 drivers/media/platform/timblogiw.c          |    2 
 drivers/misc/carma/carma-fpga.c             |    3 
 drivers/mtd/nand/atmel_nand.c               |    3 
 drivers/mtd/nand/fsmc_nand.c                |    2 
 drivers/net/ethernet/micrel/ks8842.c        |    6 -
 drivers/spi/spi-dw-mid.c                    |    4 
 include/linux/dmaengine.h                   |   49 ++++-
 33 files changed, 481 insertions(+), 1106 deletions(-)
