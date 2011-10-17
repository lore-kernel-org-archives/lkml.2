Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab1JQQvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 12:51:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:2208 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab1JQQvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:51:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,360,1315206000"; 
   d="scan'208";a="63385767"
Subject: Re: [PATCH v3] dmaengine: add CSR SiRFprimaII DMAC driver
From: Vinod Koul <vinod.koul@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Barry Song <21cnbao@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Rongjun Ying <rongjun.ying@csr.com>,
        Barry Song <Barry.Song@csr.com>
In-Reply-To: <201110171711.07384.arnd@arndb.de>
References: <1318844199-19303-1-git-send-email-Barry.Song@csr.com>
	 <1318859861.23438.137.camel@vkoul-udesk3>
	 <CAGsJ_4y4ZxqmefxXS+2QEtTcq6Jr9+o92pd4enRYQMkG3kZ=ng@mail.gmail.com>
	 <201110171711.07384.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Oct 2011 22:12:39 +0530
Message-ID: <1318869759.23438.159.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 17:11 +0200, Arnd Bergmann wrote:
> On Monday 17 October 2011, Barry Song wrote:
> > >> +
> > >> +     /* Start the DMA transfer */
> > >> +     writel_relaxed(sdesc->width, sdma->base + SIRFSOC_DMA_WIDTH_0 + cid * 4);
> > >> +     writel_relaxed(cid | (schan->mode << SIRFSOC_DMA_MODE_CTRL_BIT) |
> > >> +             (sdesc->dir << SIRFSOC_DMA_DIR_CTRL_BIT),
> > >> +             sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_CTRL);
> > >> +     writel_relaxed(sdesc->xlen, sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_XLEN);
> > >> +     writel_relaxed(sdesc->ylen, sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_YLEN);
> > >> +     writel_relaxed(readl_relaxed(sdma->base + SIRFSOC_DMA_INT_EN) | (1 << cid),
> > >> +             sdma->base + SIRFSOC_DMA_INT_EN);
> > >> +     writel(sdesc->addr >> 2, sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_ADDR);
> > >> +
> > >> +     if (sdesc->cyclic) {
> > >> +             writel((1 << cid) | 1 << (cid + 16) |
> > >> +                     readl_relaxed(sdma->base + SIRFSOC_DMA_CH_LOOP_CTRL),
> > >> +                     sdma->base + SIRFSOC_DMA_CH_LOOP_CTRL);
> > >> +             schan->happened_cyclic = schan->completed_cyclic = 0;
> > >> +     }
> > > any reason why we have mixed use of writel_relaxes and writel?
> > > Shouldn't all the DMA register writes be done only using writel?
> > 
> > Arnd comment this in v2.
> 
> The new version looks good to me, but a comment in the source code would
> be very helpful, especially to prevent people from attempting to "fix" it
> in the future.
> 
> I'm not sure about the writel/readl_relaxed in the end of that function,
> because I don't understand what having a "cyclic" descriptor means.
"cyclic" descriptor represents a dma operation which is cyclic in
nature, i.e would auto restart the DMA operation again, till it is
explicitly aborted.
Typically you need to tell dmac that it has to perform such operation
after the current transfer/list is completed.
In above case looks like you have to do that by performing a writel
which invokes a readl_relaxed as well

-- 
~Vinod

