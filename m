Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab2HTORa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:17:30 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56968 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2HTOR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:17:26 -0400
Date: Mon, 20 Aug 2012 10:17:21 -0400
From: Matt Porter <mporter@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, cjb@laptop.org,
        grant.likely@secretlab.ca,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] dmaengine: add TI EDMA DMA engine driver
Message-ID: <20120820141721.GA31897@beef>
References: <1345153471-22757-1-git-send-email-mporter@ti.com>
 <1345153471-22757-2-git-send-email-mporter@ti.com>
 <20120816222912.GA15883@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120816222912.GA15883@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 11:29:12PM +0100, Russell King wrote:
> On Thu, Aug 16, 2012 at 05:44:29PM -0400, Matt Porter wrote:
> > Add a DMA engine driver for the TI EDMA controller. This driver
> > is implemented as a wrapper around the existing DaVinci private
> > DMA implementation. This approach allows for incremental conversion
> > of each peripheral driver to the DMA engine API. The EDMA driver
> > supports slave transfers but does not yet support cyclic transfers.
> 
> Have you looked at the virt-dma support?  That should allow you to
> avoid some common errors, like forgetting that stuff submitted but
> not issued should not be started even if the channel is currently
> running.

I had previously skimmed it a bit and wrote it off as a helper for
certain types of controllers. On your suggestion, I looked into it
in detail and it does look to be a nice improvement on handling those
types of errors...some of which I noticed were not being handled
properly in my v1 version. I did a quick and dirty conversion of the
EDMA driver to use virt-dma now and it also results in simplified
handling of the descriptors and about a 10% code reduction. I'll do
some clean up on this virt-dma-enabled version and post v2.

One thing to note is that although I'm borrowing a lot from how you
did the omap-dma.c driver, the EDMA implementation of issue_pending()
cannot schedule a tasklet to send the descriptor to the hardware. The
client drivers have to be sure that dma_async_issue_pending() results
in the PaRAM set been written to the h/w before the driver specific
DMA reqs are enabled. Enabling the DMA req before the PaRAM set is
programmed results in an event error condition on this h/w. Ideally
there would be a dma_status state to reflect that a descriptor has
actually been written to the h/w so that client drivers can safely
enable dma reqs where this is a requirement.

Thanks,
Matt
