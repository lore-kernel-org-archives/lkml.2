Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750986Ab0FQEEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 00:04:16 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:48344 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab0FQEEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 00:04:14 -0400
Date: Thu, 17 Jun 2010 13:03:57 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Michael Chan <mchan@broadcom.com>
Cc: "'Mike Frysinger'" <vapier@gentoo.org>,
       James Bottomley <JBottomley@novell.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: bnx2 fails to compile on parisc because of missing get_dma_ops()
Message-ID: <20100617040356.GA8105@linux-sh.org>
References: <AANLkTilSfOwwT87mgDcWBogL4gPnM7VBTOALKpZv_upN@mail.gmail.com> <C27F8246C663564A84BB7AB3439772421B79CBCA1C@IRVEXCHCCR01.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C27F8246C663564A84BB7AB3439772421B79CBCA1C@IRVEXCHCCR01.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 08:53:57PM -0700, Michael Chan wrote:
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
> 
Except that's not a valid assertion, there are platforms that implement
it for sanity checks yet still have consistent DMA. You are making
inherently non-portable assumptions for a PCI driver, which is a good
example of why drivers should never be side-stepping the API in the first
place. If you want to have a micro-optimization for the consistent DMA
case, you can check dma_is_consistent(), which is part of the API and
will be variable on certain platform configurations (ie, some may be
consistent with PCI but not on other busses, etc.) 
