Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab1CXJ16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 05:27:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46232 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1CXJ14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 05:27:56 -0400
Date: Thu, 24 Mar 2011 09:27:32 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Patrice VILCHEZ <patrice.vilchez@atmel.com>,
        Hong XU <hong.xu@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-mtd <linux-mtd@lists.infradead.org>
Subject: Re: Hit BUG_ON in dma-mapping.c:425 (RFC)
Message-ID: <20110324092732.GA19935@n2100.arm.linux.org.uk>
References: <4D24A108.2080609@atmel.com> <4D8AFE45.8050609@atmel.com> <20110324082521.GB9844@n2100.arm.linux.org.uk> <1300955778.2735.68.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300955778.2735.68.camel@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 10:36:18AM +0200, Artem Bityutskiy wrote:
> On Thu, 2011-03-24 at 08:25 +0000, Russell King - ARM Linux wrote:
> > On Thu, Mar 24, 2011 at 04:18:13PM +0800, Nicolas Ferre wrote:
> > > diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
> > > --- a/drivers/spi/atmel_spi.c
> > > +++ b/drivers/spi/atmel_spi.c
> > > @@ -647,6 +647,22 @@ static void atmel_spi_next_message(struct spi_master *master)
> > >  	atmel_spi_next_xfer(master, msg);
> > >  }
> > >  
> > > +static void *adjust_buffer_location(struct device *dev, void *buf)
> > > +{
> > > +	if (likely(buf < high_memory)) {
> > > +		return buf;
> > > +	} else {
> > > +		struct page *pg;
> > > +
> > > +		pg = vmalloc_to_page(buf);
> > > +		if (pg == 0) {
> > > +			dev_err(dev, "failed to vmalloc_to_page\n");
> > > +			return NULL;
> > > +		}
> > > +		return page_address(pg) + ((size_t)buf & ~PAGE_MASK);
> > > +	}
> > > +}
> > > +
> > 
> > This really doesn't fix the problem.  If the page is read or written via
> > the vmalloc mapping, you'll have stale data.
> > 
> > DMA to vmalloc areas is dodgy at best.
> 
> This topics pops up often. So what is the right fix? And sorry for my
> ignorance.

I have no idea.  The problem comes down to MTDs interfaces being designed
only for PIO - it's expected that the CPU places data into the virtual
address being passed.  This virtual address can be a vmalloc address,
a kmalloc'd address or a page address.

As long as that happens, everything all works because there's no cache
aliasing problems to consider as the buffers are always accessed through
the same mappings.

As soon as there's any attempt to move away from PIO, things get really
sticky because, with *any* DMA noncoherent architecture (it's not limited
to ARM) you run into issues with cache coherency causing data corruption.

When cache maintainence ends up having to deal with virtual addresses for
one level of cache and physical addresses for subseqent levels, the
problems are compounded even more.

The only real answer I can give is: if you want to deal with DMA, you
absolutely must conform to the restrictions on DMA which means that you
can't pass vmalloc addresses to the DMA API.

You can't work around that by converting a vmalloc address to a physical
address and then its coresponding virtual page address as that means the
DMA API will flush the wrong virtual address range and you'll again have
cache incoherency.  That goes for *all* of the DMA API interfaces.

