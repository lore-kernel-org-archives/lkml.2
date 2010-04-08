Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab0DHFAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 01:00:33 -0400
Received: from sh.osrg.net ([192.16.179.4]:33696 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab0DHFAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 01:00:32 -0400
Date: Thu, 8 Apr 2010 14:00:22 +0900
To: vapier.adi@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 09/12] blackfin: use use asm-generic/scatterlist.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <y2z8bd0f97a1004072051i3d309852zf3dc1b3ffb06d0ac@mail.gmail.com>
References: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1270511567-18567-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<y2z8bd0f97a1004072051i3d309852zf3dc1b3ffb06d0ac@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100408135958F.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 08 Apr 2010 14:00:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Apr 2010 23:51:04 -0400
Mike Frysinger <vapier.adi@gmail.com> wrote:

> > #define ISA_DMA_THRESHOLD (0xffffffff)
> 
> this is the same value as the common asm-generic one, so this define
> should be punted, especially since this would probably introduce
> redefined warnings.

I removed ISA_DMA_THRESHOLD in the common asm-generic one since it
doesn't work for powerpc.

I've attached the common asm-generic in -mm below.

> once that is done, this header is simply a redirect, so it'd be better
> if it was just one line:
> #include <asm-generic/scatterlist.h>
> 
> one of the reasons i hadnt converted sooner was that it seems like the
> common header introduces bloat.  the Blackfin header has just "length"

I took care of it. Blackfin doesn't define
CONFIG_NEED_SG_DMA_LENGTH so doesn't get "dma_length".


> while the asm-generic has both "length" and "dma_length".  unless i
> missed something, this hasnt been a problem for us.  perhaps the
> common header should have something like:
> #if __BITS_PER_LONG == 64
>     unsigned int    dma_length;
> #endif

'#if __BITS_PER_LONG == 64' doesn't work since some 32-bit
architectures need it. So I invented CONFIG_NEED_SG_DMA_LENGTH.

=
#ifndef __ASM_GENERIC_SCATTERLIST_H
#define __ASM_GENERIC_SCATTERLIST_H

#include <linux/types.h>

struct scatterlist {
#ifdef CONFIG_DEBUG_SG
	unsigned long	sg_magic;
#endif
	unsigned long	page_link;
	unsigned int	offset;
	unsigned int	length;
	dma_addr_t	dma_address;
#ifdef CONFIG_NEED_SG_DMA_LENGTH
	unsigned int	dma_length;
#endif
};

/*
 * These macros should be used after a dma_map_sg call has been done
 * to get bus addresses of each of the SG entries and their lengths.
 * You should only work with the number of sg entries pci_map_sg
 * returns, or alternatively stop on the first sg_dma_len(sg) which
 * is 0.
 */
#define sg_dma_address(sg)	((sg)->dma_address)

#ifdef CONFIG_NEED_SG_DMA_LENGTH
#define sg_dma_len(sg)		((sg)->dma_length)
#else
#define sg_dma_len(sg)		((sg)->length)
#endif

#endif /* __ASM_GENERIC_SCATTERLIST_H */
