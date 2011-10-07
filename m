Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965316Ab1JGFeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 01:34:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:60555 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758214Ab1JGFen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 01:34:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="59999759"
Subject: RE: [RFC PATCH 1/2] RapidIO: Add DMA Engine support for RIO data
 transfers
From: Vinod Koul <vinod.koul@intel.com>
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Cc: Dan <dan.j.williams@intel.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E55202291E40@CORPEXCH1.na.ads.idt.com>
References: <1317418715-9666-1-git-send-email-alexandre.bounine@idt.com>
	 <1317492077.1573.1839.camel@vkoul-udesk3>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E55202291E40@CORPEXCH1.na.ads.idt.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 10:57:32 +0530
Message-ID: <1317965252.1573.2238.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 09:52 -0700, Bounine, Alexandre wrote:
> Vinod Koul wrote:
> > 
> > On Fri, 2011-09-30 at 17:38 -0400, Alexandre Bounine wrote:
> > Please CC *maintainers* on your patches, get_maintainers.pl will tell
> > you who. Adding Dan here
> 
> Based on https://lkml.org/lkml/2011/2/14/67 and use of DMA_SLAVE in this
> patch I decided that you are the best match among two and there is no reason
> to disturb Dan ;) 
I don't think he minds :) and we can all benefit from his wisdom

> 
> > > Adds DMA Engine framework support into RapidIO subsystem.
> > > Uses DMA Engine DMA_SLAVE interface to generate data transfers to/from remote
> > > RapidIO target devices. Uses scatterlist to describe local data buffer and
> > > dma_chan.private member to pass target specific information. Supports flat
> > > data buffer only for a remote side.
> > The way dmaengine works today is that it doesn't know anything about
> > client subsystem. But this brings in a subsystem details to dmaengine
> > which I don't agree with yet.
> > Why can't we abstract this out??
> 
> The only thing that brings subsystem knowledge into dmaengine is DMA_RAPIDIO flag.
> I am actually on the fence about this. From RapidIO side point of view I do not
> need that flag at all.
> RapidIO uses a filter routine that is sufficient to identify dmaengine channels
> associated with specific RapidIO mport. Use of DMA_SLAVE flag is safe here.
> Use of private member of dma_chan is "private" business of RapidIO and does
> not break anything. 
> 
> My concern here is that other subsystems may use/request DMA_SLAVE channel(s) as well
> and wrongfully acquire one that belongs to RapidIO. In this case separation with another
> flag may have a sense - it is possible to have a system that uses RapidIO
> and other "traditional" DMA slave channel.
Nope that will never happen in current form.
Every controller driver today "magically" ensures that it doesn't get
any other dma controllers channel. We use filter function for that.
Although it is not clean yet and we are working to fix that but that's
another discussion.
Even specifying plain DMA_SLAVE should work if you code your filter
function properly :)

> 
> This is why I put that proposed interface for discussion instead of keeping everything
> inside of RapidIO.
> If you think that situation above will not happen I will be happy to remove
> that subsystem knowledge from dmaengine files.
> 
> My most recent test implementation runs without DMA_RAPIDIO flag though.
> 
> > 
> > After going thru the patch, I do not believe that this this is case of
> > SLAVE transfers, Dan can you please take a look at this patch
> 
> I agree, this is not a case of "pure" slave transfers but existing DMA_SLAVE
> interface fits well into the RapidIO operations.
> 
> First, we have only one memory mapped location on the host side. We transfer
> data to/from location that is not mapped into memory on the same side.  
> 
> Second, having ability to pass private target information allows me to pass
> information about remote target device on per-transfer basis.
Okay, then why not pass the dma address and make your dma driver
transparent (i saw you passed RIO address, IIRC 64+2 bits)
Currently using dma_slave_config we pass channel specific information,
things like peripheral address and config don't change typically between
transfers and if you have some controller specific properties you can
pass them by embedding dma_slave_config in your specific structure.
Worst case, you can configure slave before every prepare


-- 
~Vinod

