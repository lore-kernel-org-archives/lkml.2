Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab0DYNq7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 09:46:59 -0400
Received: from sh.osrg.net ([192.16.179.4]:53274 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712Ab0DYNq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 09:46:57 -0400
Date: Sun, 25 Apr 2010 22:46:35 +0900
To: geert@linux-m68k.org
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, zippel@linux-m68k.org,
       linux-m68k@vger.kernel.org
Subject: Re: [PATCH -mm 06/12] m68k: use asm-generic/scatterlist.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <p2q10f740e81004230129rd5b07889m5ec7f453efd46403@mail.gmail.com>
References: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1270511567-18567-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<p2q10f740e81004230129rd5b07889m5ec7f453efd46403@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100425224726P.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 25 Apr 2010 22:46:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 10:29:04 +0200
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> > +#include <asm-generic/scatterlist.h>
> 
> This include should be ...
> 
> > /* This is bogus and should go away. */
> > #define ISA_DMA_THRESHOLD (0x00ffffff)

asm-generic/scatterlist.h can't define ISA_DMA_THRESHOLD because of
the way POWERPC uses ISA_DMA_THRESHOLD.


> ... below this definition, else you get duplicate definition errors
> (and the wrong definition).
> 
> > -#define sg_dma_address(sg) ((sg)->dma_address)
> > -#define sg_dma_len(sg) ((sg)->length)

This patch needs to be applied against -mm; including some changes to
asm-generic/scatterlist.h.

I've attached asm-generic/scatterlist.h in -mm.

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
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

