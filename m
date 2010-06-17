Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258Ab0FQEUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 00:20:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41713 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab0FQEUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 00:20:45 -0400
Subject: Re: bnx2 fails to compile on parisc because of missing
 get_dma_ops()
From: James Bottomley <JBottomley@Novell.com>
To: Michael Chan <mchan@broadcom.com>
Cc: "'Mike Frysinger'" <vapier@gentoo.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <C27F8246C663564A84BB7AB3439772421B79CBCA1C@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <C27F8246C663564A84BB7AB3439772421B79CBCA1C@IRVEXCHCCR01.corp.ad.broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jun 2010 23:20:38 -0500
Message-ID: <1276748438.2847.1190.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 20:53 -0700, Michael Chan wrote:
> Mike Frysinger wrote:
> 
> > On Wed, Jun 16, 2010 at 9:13 PM, James Bottomley wrote:
> > > I'm not quite sure whose fault this one is.
> > >
> > > However, this code in bnx2.c:
> > >
> > >                if (!get_dma_ops(&pdev->dev)->sync_single_for_cpu) {
> > >                        next_rx_buf =
> > >                                &rxr->rx_buf_ring[
> > >                                        RX_RING_IDX(NEXT_RX_BD(sw_cons))];
> > >                        prefetch(next_rx_buf->desc);
> > >                }
> > >
> > > Looks remarkably fragile: what exactly is it trying to do?
> 
> If sync_single is not defined, that means the CPU has a consistent
> view of next_rx_buf and so it makes sense to prefetch it.

That's not entirely a correct statement.  Many architectures make a DMA
area coherent by turning off the CPU cache over it.  In that case,
prefetching makes absolutely no sense (although it usually works but is
a nop).

> > > The commit that causes the problem:
> > >
> > > commit a33fa66bcf365ffe5b79d1ae1d3582cc261ae56e
> > > Author: Michael Chan <mchan@broadcom.com>
> > > Date:   Thu May 6 08:58:13 2010 +0000
> > >
> > >    bnx2: Add prefetches to rx path.
> > >
> > > Looks fairly innocuous by the description.
> > >
> > > Should parisc have a get_dma_ops()?  We don't need one
> > because our dma
> > > ops are per platform not per bus.
> >
> > looks like it'll be broken on more than just parisc:
> > $ grep get_dma_ops arch/*/include/asm/ -rl | cut -d/ -f 2
> > alpha
> > ia64
> > microblaze
> > powerpc
> > sh
> > sparc
> > x86
> 
> Most of these archs use the dma functions in:
> 
> <asm-genric/dma-mapping-common.h>
> 
> so it's not a problem.

Parisc begs to differ.

Plus you're making assumptions about the contents of the ops structure
which is an internal architecture object ... that's bound to run into
portability problems even if we make it compile on all platform.

> I think I'll send in a patch to remove that part of the code
> from bnx2.c for now.

I think that's the best solution.

James


