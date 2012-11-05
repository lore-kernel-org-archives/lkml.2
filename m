Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab2KEKAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:00:54 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26028 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab2KEKAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:00:53 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-58-50978e536f43
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: djbw@fb.com, dwmw2@infradead.org, hskinnemoen@gmail.com,
        iws@ovro.caltech.edu, vinod.koul@intel.com, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 00/20] DMA: DMA unmap fixes
Date: Mon, 05 Nov 2012 11:00:11 +0100
Message-id: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t9jAd3gvukBBnMvKVlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MjzeesRasVanYO/UmYwPjT8kuRk4OCQETiRWHJ7NB2GISF+6t
	B7K5OIQEFjFKrP47kwnCWc0k8X3OSlaQKjYBK4mJ7asYQWwRAQWJzb3PWEGKmAWeMUrMuN3N
	DJIQFtCWuH59BQuIzSKgKvHr91KwOK+Au8SnSc2sEOvkJZ7e72ObwMi9gJFhFaNoakFyQXFS
	eq6hXnFibnFpXrpecn7uJkawF59J7WBc2WBxiFGAg1GJh3em2PQAIdbEsuLK3EOMEhzMSiK8
	HAxAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzNHikBQgLpiSWp2ampBalFMFkmDk6pBkaPTomY
	OzFNmvuE/R88KqvKbfiw/t7dTfc0HsxxDnrQK1sgG9ufOdN4vv/Uh1ON6r7tmdZ3n5mn9fXX
	h8Z5z1p2HanQZitoe2pv49y8RSHMyI89YGXmjWQtkXkSsbefbAudxthdw+ww470bt3Jq5pN2
	O9sarp5gYZbjXrxJC95x/BFNNLvOr8RSnJFoqMVcVJwIAM3AXeneAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently DMA subsystem does DMA mapping in the core code and DMA
unmapping is done by device drivers.  This is counterintuitive,
causes code duplication and subtle errors (some drivers like PL330
one don't implement DMA unmapping code).  The following patchset
modifies DMA subsystem to do DMA unmapping in the core code.
It results in simpler code, less code duplication (more than 400
LOC is gone) and fixes the issue with missing DMA unmapping code
in some drivers.  Additionally many cases when DMA wasn't unmapped
on a failure are also fixed.


patches #1-3 add missing DMA unmap on failure to async_tx core
code (async_memcpy()), ioat and fsmc_nand drivers

patch #4 fixes DMA flags used by carma-fpga driver

patches #5-7 fix core code and dmatest driver to DMA unmap for
MEMCPY operations 

patch #8 adds missing DMA unmap on failure to ioat3 driver

patch #9 fixes build for async_memset.c

patch #10 adds missing DMA unmap on failure to async tx core
code (async_memset())

patches #11-18 fix async_tx core code and dmatest driver to do
DMA unmap for MEMSET, XOR, XOR_VAL, PQ and PQ_VAL operations

patches #19-20 remove no longer needed DMA unmap code from
device drivers and DMA unmap flags from code code


This patchset was tested on PL330 DMA controller using MEMCPY
operations.  It would be great if somebody could test it on
more advanced controller capable of MEMSET, XOR, XOR_VAL,
PQ and PQ_VAL operations (especially since the conversion of
XOR and PQ operations was not obvious).


Bartlomiej Zolnierkiewicz (20):
  async_tx: add missing DMA unmap to async_memcpy()
  ioat: add missing DMA unmap to ioat_dma_self_test()
  mtd: fsmc_nand: add missing DMA unmap to dma_xfer()
  carma-fpga: pass correct flags to ->device_prep_dma_memcpy()
  dmatest: do DMA unmap for MEMCPY operations
  DMA: do DMA unmap in core for MEMCPY operations
  async_tx: do DMA unmap in core for MEMCPY operations
  ioat3: add missing DMA unmap to ioat_xor_val_self_test()
  async_tx: fix build for async_memset
  async_tx: add missing DMA unmap to async_memset()
  async_tx: do DMA unmap in core for MEMSET operations
  dmatest: do DMA unmap for XOR operations
  async_tx: do DMA unmap in core for XOR operations
  async_tx: do DMA unmap in core for XOR_VAL operations
  dmatest: do DMA unmap for PQ operations
  async_tx: do DMA unmap in async_raid6_recov.c for PQ operations
  async_tx: do DMA unmap in core for PQ operations
  async_tx: do DMA unmap in core for PQ_VAL operations
  DMA: remove DMA unmap from drivers
  DMA: remove DMA unmap flags

 arch/arm/include/asm/hardware/iop3xx-adma.h |  30 ----
 arch/arm/mach-iop13xx/include/mach/adma.h   |  26 ---
 crypto/async_tx/async_memcpy.c              |  27 ++-
 crypto/async_tx/async_memset.c              |  23 ++-
 crypto/async_tx/async_pq.c                  | 129 +++++++++----
 crypto/async_tx/async_raid6_recov.c         |  42 ++++-
 crypto/async_tx/async_tx.c                  |  25 ++-
 crypto/async_tx/async_xor.c                 |  98 +++++++---
 drivers/ata/pata_arasan_cf.c                |   3 +-
 drivers/dma/amba-pl08x.c                    |  31 ----
 drivers/dma/at_hdmac.c                      |  25 ---
 drivers/dma/dmaengine.c                     |  59 +++++-
 drivers/dma/dmatest.c                       |  14 +-
 drivers/dma/dw_dmac.c                       |  20 ---
 drivers/dma/ep93xx_dma.c                    |  32 +---
 drivers/dma/fsldma.c                        |  16 --
 drivers/dma/ioat/dma.c                      |  28 +--
 drivers/dma/ioat/dma.h                      |  12 --
 drivers/dma/ioat/dma_v2.c                   |   1 -
 drivers/dma/ioat/dma_v3.c                   | 179 +++++-------------
 drivers/dma/iop-adma.c                      |  70 +-------
 drivers/dma/mv_xor.c                        |  45 +----
 drivers/dma/ppc4xx/adma.c                   | 270 ----------------------------
 drivers/dma/timb_dma.c                      |  36 ----
 drivers/dma/txx9dmac.c                      |  24 ---
 drivers/media/platform/m2m-deinterlace.c    |   3 +-
 drivers/media/platform/timblogiw.c          |   2 +-
 drivers/misc/carma/carma-fpga.c             |   3 +-
 drivers/mtd/nand/atmel_nand.c               |   3 +-
 drivers/mtd/nand/fsmc_nand.c                |  20 ++-
 drivers/net/ethernet/micrel/ks8842.c        |   6 +-
 drivers/spi/spi-dw-mid.c                    |   4 +-
 include/linux/async_tx.h                    |   4 +
 include/linux/dmaengine.h                   |  34 ++--
 34 files changed, 446 insertions(+), 898 deletions(-)

-- 
1.8.0

