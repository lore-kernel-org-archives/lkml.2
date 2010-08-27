Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab0H0A16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 20:27:58 -0400
Received: from sh.osrg.net ([192.16.179.4]:46975 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645Ab0H0A14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 20:27:56 -0400
Date: Fri, 27 Aug 2010 09:26:20 +0900
To: linux@arm.linux.org.uk
Cc: fujita.tomonori@lab.ntt.co.jp, u.kleine-koenig@pengutronix.de,
        mitov@issp.bas.bg, linux-sh@vger.kernel.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, jkrzyszt@tis.icnet.pl,
        philippe.retornaz@epfl.ch, akpm@linux-foundation.org,
        g.liakhovetski@gmx.de, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC][PATCH] add
	dma_reserve_coherent_memory()/dma_free_reserved_memory() API
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100826175440.GB13224@n2100.arm.linux.org.uk>
References: <20100826095311.GA13051@pengutronix.de>
	<20100826185938A.fujita.tomonori@lab.ntt.co.jp>
	<20100826175440.GB13224@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp-2
Content-Transfer-Encoding: 7bit
Message-Id: <20100827092457G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 27 Aug 2010 09:26:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010 18:54:40 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Thu, Aug 26, 2010 at 07:00:24PM +0900, FUJITA Tomonori wrote:
> > On Thu, 26 Aug 2010 11:53:11 +0200
> > Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> > 
> > > > > We have currently a number of boards broken in the mainline. They must be 
> > > > > fixed for 2.6.36. I don't think the mentioned API will do this for us. So, 
> > > > > as I suggested earlier, we need either this or my patch series
> > > > > 
> > > > > http://thread.gmane.org/gmane.linux.ports.sh.devel/8595
> > > > > 
> > > > > for 2.6.36.
> > > > 
> > > > Why can't you revert a commit that causes the regression?
> > > > 
> > > > The related DMA API wasn't changed in 2.6.36-rc1. The DMA API is not
> > > > responsible for the regression. And the patchset even exnteds the
> > > > definition of the DMA API (dma_declare_coherent_memory). Such change
> > > > shouldn't applied after rc1. I think that DMA-API.txt says that
> > > > dma_declare_coherent_memory() handles coherent memory for a particular
> > > > device. It's not for the API that reserves coherent memory that can be
> > > > used for any device for a single device.
> > > The patch that made the problem obvious for ARM is
> > > 309caa9cc6ff39d261264ec4ff10e29489afc8f8 aka v2.6.36-rc1~591^2~2^4~12.
> > > So this went in before v2.6.36-rc1.  One of the "architectures which
> > > similar restrictions" is x86 BTW.
> > > 
> > > And no, we won't revert 309caa9cc6ff39d261264ec4ff10e29489afc8f8 as it
> > > addresses a hardware restriction.
> > 
> > How these drivers were able to work without hitting the hardware restriction?
> 
> Well, OMAP processors have experienced lock-ups due to multiple mappings of
> memory, so the restriction in the architecture manual is for real.
> 
> But more the issue is that the behaviour you get from a region is _totally_
> unpredictable (as the arch manual says).  With the VIPT caches, they can
> be searched irrespective of whether the page tabkes indicate that it's
> supposed to be cached or not - which means you can still hit cache lines
> for an ioremap'd region.
> 
> And if you do, how do you know that the cached data is still valid - what
> if it's some critical data that results in corruption - how do you know
> whether that's happened or not?  It might not even cause a kernel
> exception.
> 
> We have to adhere to the restrictions placed upon us by the architecture
> at hand, and if that means device drivers break, so be it - at least we
> get to know what needs to be fixed for these restrictions.

I didn't say the commit is technically wrong. I simply meant that the
commit broke some of working systems (so some complain, I guess).

As I wrote, the related DMA API wasn't changed in 2.6.36-rc1. It's not
related with the regression at all. As long as nobody tries to extend
the API wrongly after rc2, I have no complaint.

btw, Marin Mitov said that these drivers don't need coherent memory,
they just want contiguous memory. Telling the page allocater to
reserve some memory at boot time is enough, I guess.
