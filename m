Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030277Ab2JSCuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:50:18 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41901 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271Ab2JSCuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:50:14 -0400
From: Matt Porter <mporter@ti.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Chris Ball <cjb@laptop.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: [RFC PATCH 0/3] dmaengine: add per channel capabilities api
Date: Thu, 18 Oct 2012 22:51:25 -0400
Message-Id: <1350615088-14562-1-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds a new dmaengine api, dma_get_channels_caps(), which
may be used by a driver to get channel-specific capabilities. This is
based on a starting point suggested by Vinod Koul, but only implements
the minimal sets of channel capabilities to fulfill the needs of the
EDMA DMA Engine driver at this time.

Specifically, this implementation supports reporting of a set of
transfer type operations, maximum number of SG segments, and the
maximum size of an SG segment that a channel can support.

The call is implemented as follows:

	struct dmaengine_chan_caps
	*dma_get_channel_caps(struct dma_chan *chan,
			      enum dma_transfer_direction dir);

The dma transfer direction parameter may appear a bit out of place
but it is necessary since the direction field in struct
dma_slave_config was deprecated. In some cases, EDMA for one, it
is necessary for the dmaengine driver to have the burst and address
width slave configuration parameters available in order to compute
the maximum segment size that can be handle. Due to this requirement,
the calling order of this api is as follows:

1. Allocate a DMA slave channel
1a. [Optionally] Get channel capabilities
2. Set slave and controller specific parameters
3. Get a descriptor for transaction
4. Submit the transaction
5. Issue pending requests and wait for callback notification

Along with the API implementation, this series implements the
backend device_channel_caps() in the EDMA DMA Engine driver and
converts the davinci_mmc driver to use dma_get_channel_caps() to
replace hardcoded limits.

This is tested on the AM1808-EVM.

Matt Porter (3):
  dmaengine: add dma_get_channel_caps()
  dma: edma: add device_channel_caps() support
  mmc: davinci: get SG segment limits with dma_get_channel_caps()

 drivers/dma/edma.c                        |   26 ++++++++++++
 drivers/mmc/host/davinci_mmc.c            |   66 +++++++++--------------------
 include/linux/dmaengine.h                 |   52 +++++++++++++++++++++++
 include/linux/platform_data/mmc-davinci.h |    3 --
 4 files changed, 99 insertions(+), 48 deletions(-)

-- 
1.7.9.5

