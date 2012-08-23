Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab2HWBJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 21:09:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45221 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab2HWBJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 21:09:35 -0400
From: Matt Porter <mporter@ti.com>
To: vinod.koul@intel.com, cjb@laptop.org, grant.likely@secretlab.ca
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: [PATCH v3 0/3] DaVinci DMA engine conversion
Date: Wed, 22 Aug 2012 21:09:33 -0400
Message-Id: <1345684176-21472-1-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
	- Add virt-dma support. Better error checks
	  and simplified descriptor handling.
	- Fix support for multiple EDMA controllers
	  Tested on AM18x EVM with WL12xx on MMC1

Changes since v2:
	- Set default Kconfig state to off
	- Fix whitespace and indent issues
	- Simplify struct device * assignments
	- Remove unneeded chcnt in edma_chan_init
	- Remove unneeded conditional assignment of prep_slave_sg
	- Fix devm_* usage

This series begins the conversion of the DaVinci private EDMA API
implementation to a DMA engine driver and converts two of the three
in-kernel users of the private EDMA API to DMA engine.

The approach taken is similar to the recent OMAP DMA Engine
conversion. The EDMA DMA Engine driver is a wrapper around the existing
private EDMA implementation and registers the platform device within
the driver.  This allows the conversion series to stand alone with just
the drivers and no changes to platform code. It also allows peripheral
drivers to continue to use the private EDMA implementation until they
are converted.

The EDMA DMA Engine driver supports slave transfers only at this time. It
is planned to add cyclic transfers in support of audio peripherals.

There are three users of the private EDMA API in the kernel now:
davinci_mmc, spi-davinci, and davinci-mcasp.  This series provides DMA
Engine conversions for the davinci_mmc and spi-davinci drivers which
use the supported slave transfers.

This series has been tested on an AM18x EVM and Hawkboard with
driver performance comparable to that of the private EDMA API
implementations. Both MMC0 and MMC1 are tested which handles the
DA850/OMAP-L138/AM18x specific case where MMC1 uses DMA channels on
a second EDMA channel controller.  All other platforms have a simpler
design with just a single EDMA channel controller.

For those wanting to easily test this series, I've pushed a branch for
each version to my github tree at https://github.com/ohporter/linux. The
current branch is edma-dmaengine-v3.

After this series, the current plan is to complete the mcasp driver
conversion which includes adding cyclic dma support. This will then
enable the removal and refactoring of the private EDMA API functionality
into the EDMA DMA Engine driver.  Since EDMA is also used on the AM33xx
family of parts in mach-omap2/, the plan is to enable this driver on
that platform as well.

Matt Porter (3):
  dmaengine: add TI EDMA DMA engine driver
  mmc: davinci_mmc: convert to DMA engine API
  spi: spi-davinci: convert to DMA engine API

 drivers/dma/Kconfig            |   10 +
 drivers/dma/Makefile           |    1 +
 drivers/dma/edma.c             |  671 ++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/host/davinci_mmc.c |  271 +++++-----------
 drivers/spi/spi-davinci.c      |  292 ++++++++---------
 include/linux/edma.h           |   29 ++
 6 files changed, 923 insertions(+), 351 deletions(-)
 create mode 100644 drivers/dma/edma.c
 create mode 100644 include/linux/edma.h

-- 
1.7.9.5

