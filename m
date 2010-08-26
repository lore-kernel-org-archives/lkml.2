Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab0HZJxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 05:53:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55911 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab0HZJxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 05:53:33 -0400
Date: Thu, 26 Aug 2010 11:53:11 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: g.liakhovetski@gmx.de, mitov@issp.bas.bg, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, akpm@linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        philippe.retornaz@epfl.ch, gregkh@suse.de, jkrzyszt@tis.icnet.pl
Subject: Re: [RFC][PATCH] add
	dma_reserve_coherent_memory()/dma_free_reserved_memory() API
Message-ID: <20100826095311.GA13051@pengutronix.de>
References: <201008260904.19973.mitov@issp.bas.bg> <20100826152333K.fujita.tomonori@lab.ntt.co.jp> <Pine.LNX.4.64.1008261100150.14167@axis700.grange> <20100826182915S.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100826182915S.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 06:30:02PM +0900, FUJITA Tomonori wrote:
> On Thu, 26 Aug 2010 11:06:20 +0200 (CEST)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > On Thu, 26 Aug 2010, FUJITA Tomonori wrote:
> > 
> > > On Thu, 26 Aug 2010 09:04:14 +0300
> > > Marin Mitov <mitov@issp.bas.bg> wrote:
> > > 
> > > > On Thursday, August 26, 2010 08:40:47 am FUJITA Tomonori wrote:
> > > > > On Fri, 20 Aug 2010 14:50:12 +0300
> > > > > Marin Mitov <mitov@issp.bas.bg> wrote:
> > > > > 
> > > > > > On Friday, August 20, 2010 11:35:06 am FUJITA Tomonori wrote:
> > > > > > > On Fri, 20 Aug 2010 11:13:45 +0300
> > > > > > > Marin Mitov <mitov@issp.bas.bg> wrote:
> > > > > > > 
> > > > > > > > > > This tric is already used in drivers/staging/dt3155v4l.c
> > > > > > > > > > dt3155_alloc_coherent()/dt3155_free_coherent()
> > > > > > > > > > 
> > > > > > > > > > Here proposed for general use by popular demand from video4linux folks.
> > > > > > > > > > Helps for videobuf-dma-contig framework.
> > > > > > > > > 
> > > > > > > > > What you guys exactly want to do? If you just want to pre-allocate
> > > > > > > > > coherent memory for latter usage,
> > > > > > > > 
> > > > > > > > Yes, just to preallocate not coherent, but rather contiguous memory for latter usage.
> > > > > > > > We use coherent memory because it turns out to be contiguous.
> > > > > > > 
> > > > > > > Hmm, you don't care about coherency? You just need contiguous memory?
> > > > > > 
> > > > > > Yes. We just need contiguous memory. Coherency is important as far as when dma
> > > > > > transfer finishes user land is able to see the new data. Could be done by something like
> > > > > > dma_{,un}map_single()
> > > > > 
> > > > > Then, we should avoid using coherent memory as I exaplained before. In
> > > > > addition, dma_alloc_coherent can't provide large enough contigous
> > > > > memory for some drivers so this patch doesn't help much.
> > > > 
> > > > Please, look at drivers/media/video/videobuf-dma-contig.c. Using coherent memory
> > > > is inavoidable for now, there is no alternative for it for now. The two new functions,
> > > > which I propose are just helpers for those of us who already use coherent memory
> > > > (via videobuf-dma-contig API). May be adding these two functions to 
> > > > drivers/media/video/videobuf-dma-contig.c will be better solution?
> > > 
> > > If you add something to the videobuf-dma-contig API, that's fine by me
> > > because drivers/media/video/videobuf-dma-contig.c uses the own
> > > structure and plays with dma_alloc_coherent. As long as a driver
> > > doesn't touch device->dma_mem directly, it's fine, I think (that is,
> > > dt3155v4l driver is broken). There are already some workarounds for
> > > contigous memory in several drivers anyway.
> > 
> > No, this will not work - this API has to be used from board code and 
> > videobuf can be built modular.
> > 
> > > We will have the proper API for contiguous memory. I don't think that
> > > adding such workaround to the DMA API is a good idea.
> > 
> > We have currently a number of boards broken in the mainline. They must be 
> > fixed for 2.6.36. I don't think the mentioned API will do this for us. So, 
> > as I suggested earlier, we need either this or my patch series
> > 
> > http://thread.gmane.org/gmane.linux.ports.sh.devel/8595
> > 
> > for 2.6.36.
> 
> Why can't you revert a commit that causes the regression?
> 
> The related DMA API wasn't changed in 2.6.36-rc1. The DMA API is not
> responsible for the regression. And the patchset even exnteds the
> definition of the DMA API (dma_declare_coherent_memory). Such change
> shouldn't applied after rc1. I think that DMA-API.txt says that
> dma_declare_coherent_memory() handles coherent memory for a particular
> device. It's not for the API that reserves coherent memory that can be
> used for any device for a single device.
The patch that made the problem obvious for ARM is
309caa9cc6ff39d261264ec4ff10e29489afc8f8 aka v2.6.36-rc1~591^2~2^4~12.
So this went in before v2.6.36-rc1.  One of the "architectures which
similar restrictions" is x86 BTW.

And no, we won't revert 309caa9cc6ff39d261264ec4ff10e29489afc8f8 as it
addresses a hardware restriction.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
