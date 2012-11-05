Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab2KEToj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 14:44:39 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:51595 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2KEToi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 14:44:38 -0500
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Nov 2012 14:44:38 EST
Date: Mon, 5 Nov 2012 11:34:53 -0800
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: linux-kernel@vger.kernel.org, djbw@fb.com, dwmw2@infradead.org,
        hskinnemoen@gmail.com, vinod.koul@intel.com, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH 00/20] DMA: DMA unmap fixes
Message-ID: <20121105193453.GB16230@ovro.caltech.edu>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (ovro.ovro.caltech.edu); Mon, 05 Nov 2012 11:34:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 11:00:11AM +0100, Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> Currently DMA subsystem does DMA mapping in the core code and DMA
> unmapping is done by device drivers.  This is counterintuitive,
> causes code duplication and subtle errors (some drivers like PL330
> one don't implement DMA unmapping code).  The following patchset
> modifies DMA subsystem to do DMA unmapping in the core code.
> It results in simpler code, less code duplication (more than 400
> LOC is gone) and fixes the issue with missing DMA unmapping code
> in some drivers.  Additionally many cases when DMA wasn't unmapped
> on a failure are also fixed.
> 
> 
> patches #1-3 add missing DMA unmap on failure to async_tx core
> code (async_memcpy()), ioat and fsmc_nand drivers
> 
> patch #4 fixes DMA flags used by carma-fpga driver
> 
> patches #5-7 fix core code and dmatest driver to DMA unmap for
> MEMCPY operations 
> 
> patch #8 adds missing DMA unmap on failure to ioat3 driver
> 
> patch #9 fixes build for async_memset.c
> 
> patch #10 adds missing DMA unmap on failure to async tx core
> code (async_memset())
> 
> patches #11-18 fix async_tx core code and dmatest driver to do
> DMA unmap for MEMSET, XOR, XOR_VAL, PQ and PQ_VAL operations
> 
> patches #19-20 remove no longer needed DMA unmap code from
> device drivers and DMA unmap flags from code code
> 
> 
> This patchset was tested on PL330 DMA controller using MEMCPY
> operations.  It would be great if somebody could test it on
> more advanced controller capable of MEMSET, XOR, XOR_VAL,
> PQ and PQ_VAL operations (especially since the conversion of
> XOR and PQ operations was not obvious).
> 
> 
> Bartlomiej Zolnierkiewicz (20):
>   async_tx: add missing DMA unmap to async_memcpy()
>   ioat: add missing DMA unmap to ioat_dma_self_test()
>   mtd: fsmc_nand: add missing DMA unmap to dma_xfer()
>   carma-fpga: pass correct flags to ->device_prep_dma_memcpy()
>   dmatest: do DMA unmap for MEMCPY operations
>   DMA: do DMA unmap in core for MEMCPY operations
>   async_tx: do DMA unmap in core for MEMCPY operations
>   ioat3: add missing DMA unmap to ioat_xor_val_self_test()
>   async_tx: fix build for async_memset
>   async_tx: add missing DMA unmap to async_memset()
>   async_tx: do DMA unmap in core for MEMSET operations
>   dmatest: do DMA unmap for XOR operations
>   async_tx: do DMA unmap in core for XOR operations
>   async_tx: do DMA unmap in core for XOR_VAL operations
>   dmatest: do DMA unmap for PQ operations
>   async_tx: do DMA unmap in async_raid6_recov.c for PQ operations
>   async_tx: do DMA unmap in core for PQ operations
>   async_tx: do DMA unmap in core for PQ_VAL operations
>   DMA: remove DMA unmap from drivers
>   DMA: remove DMA unmap flags
> 
>  arch/arm/include/asm/hardware/iop3xx-adma.h |  30 ----
>  arch/arm/mach-iop13xx/include/mach/adma.h   |  26 ---
>  crypto/async_tx/async_memcpy.c              |  27 ++-
>  crypto/async_tx/async_memset.c              |  23 ++-
>  crypto/async_tx/async_pq.c                  | 129 +++++++++----
>  crypto/async_tx/async_raid6_recov.c         |  42 ++++-
>  crypto/async_tx/async_tx.c                  |  25 ++-
>  crypto/async_tx/async_xor.c                 |  98 +++++++---
>  drivers/ata/pata_arasan_cf.c                |   3 +-
>  drivers/dma/amba-pl08x.c                    |  31 ----
>  drivers/dma/at_hdmac.c                      |  25 ---
>  drivers/dma/dmaengine.c                     |  59 +++++-
>  drivers/dma/dmatest.c                       |  14 +-
>  drivers/dma/dw_dmac.c                       |  20 ---
>  drivers/dma/ep93xx_dma.c                    |  32 +---
>  drivers/dma/fsldma.c                        |  16 --
>  drivers/dma/ioat/dma.c                      |  28 +--
>  drivers/dma/ioat/dma.h                      |  12 --
>  drivers/dma/ioat/dma_v2.c                   |   1 -
>  drivers/dma/ioat/dma_v3.c                   | 179 +++++-------------
>  drivers/dma/iop-adma.c                      |  70 +-------
>  drivers/dma/mv_xor.c                        |  45 +----
>  drivers/dma/ppc4xx/adma.c                   | 270 ----------------------------
>  drivers/dma/timb_dma.c                      |  36 ----
>  drivers/dma/txx9dmac.c                      |  24 ---
>  drivers/media/platform/m2m-deinterlace.c    |   3 +-
>  drivers/media/platform/timblogiw.c          |   2 +-
>  drivers/misc/carma/carma-fpga.c             |   3 +-
>  drivers/mtd/nand/atmel_nand.c               |   3 +-
>  drivers/mtd/nand/fsmc_nand.c                |  20 ++-
>  drivers/net/ethernet/micrel/ks8842.c        |   6 +-
>  drivers/spi/spi-dw-mid.c                    |   4 +-
>  include/linux/async_tx.h                    |   4 +
>  include/linux/dmaengine.h                   |  34 ++--
>  34 files changed, 446 insertions(+), 898 deletions(-)
> 
> -- 
> 1.8.0
> 

Hello Bartlomiej Zolnierkiewicz,

The carma-fpga and fsldma parts look good to me. For those parts,

Acked-by: Ira W. Snyder <iws@ovro.caltech.edu>

Thanks,
Ira
