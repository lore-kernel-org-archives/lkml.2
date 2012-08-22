Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869Ab2HVQEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:04:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57104 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab2HVQEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:04:20 -0400
Date: Wed, 22 Aug 2012 12:04:17 -0400
From: Matt Porter <mporter@ti.com>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: cjb@laptop.org, grant.likely@secretlab.ca,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 3/3] spi: spi-davinci: convert to DMA engine API
Message-ID: <20120822160417.GA27758@beef>
References: <1345574589-24757-1-git-send-email-mporter@ti.com>
 <1345574589-24757-4-git-send-email-mporter@ti.com>
 <1345607122.1895.44.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345607122.1895.44.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 09:15:22AM +0530, Vinod Koul wrote:
> On Tue, 2012-08-21 at 14:43 -0400, Matt Porter wrote:
> > Removes use of the DaVinci EDMA private DMA API and replaces
> > it with use of the DMA engine API.
> > 
> > Signed-off-by: Matt Porter <mporter@ti.com>
> > ---
> 
> > +		struct dma_slave_config dma_rx_conf = {
> > +			.direction = DMA_DEV_TO_MEM,
> > +			.src_addr = (unsigned long)dspi->pbase + SPIBUF,
> > +			.src_addr_width = data_type,
> > +			.src_maxburst = 1,
> what does 1 mean in this context? We define as number of units that
> needs to be transfered, so are you sure that you want only one unit to
> be dma'ed in a single burst. that seems like killing your dmac,
> shouldn't you be using larger bursts for a better dma performance?

This device can't handle bursts, it's a simple shift register based
SPI master that always asserts a DMA req for each SPI word transfer.

The other important thing to note is that the EDMA driver itself
is able to handle a maxburst of 1 as a special case. That is, the
EDMA has some limitations in transfer sizes it can handle if you
need burst support. So, on the EDMA end of things you'll see that
if maxburst if 1, it's able to handle setting up an A-synchronized
transfer to handle any sized segment coming in with a single transfer
slot. However, is maxburst is >1, EDMA requires up to set up an
AB-synchronized transfer. This type of transfer limits allows for
a DMA req per burst, but the maximum segment size we can handle is
SZ_64K-1. An annoying hardware design limitation, indeed.

It works out ok because in this spi driver conversion we always
map a SPI transfer into a single segment (similar to the
spi-omap2-mcspi conversion). Since the SPI master can't handle
bursts, the EDMA driver is able to handle any sized transfer
without any performance penalty. If this SPI master could
handle bursts, we'd be in trouble because we quickly run
into our AB-synced max segment limitation.

In the mmc driver, we have a device that can handle bursts for
performance reasons. It sets maxburst appropriately and the
EDMA driver does the required AB-synced transfer at the h/w
level. However, this is subject to our limitation of SZ_64K-1
per segment. Luckily we aren't the first to need to limit the
segment size coming into an mmc host driver. The mmc
subsystem already handles this case and the existing driver
using the private EDMA API was already advertising a maximum
number of segments and segments size to the mmc subsystem.
Ideally, we should have a dmaengine interface that allows
for querying of these types of limitations. Right now, the
mmc driver implicitly knows that EDMA needs this restriction
but it's something that should be queried before calling
prep_slave().

-Matt
