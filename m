Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab1EFMoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 08:44:04 -0400
Received: from sh.osrg.net ([192.16.179.4]:60071 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325Ab1EFMoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 08:44:02 -0400
Date: Fri, 6 May 2011 21:43:44 +0900
To: mattst88@gmail.com
Cc: mcree@orcon.net.nz, linux-kernel@vger.kernel.org,
        linux-alpha@vger.kernel.org, rth@twiddle.net, ink@jurassic.park.msu.ru
Subject: Re: [PATCH] alpha: Add DMA_ERROR_CODE defn to avert compiler error
 in drm
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <BANLkTiknKa8xq5UQYTWKZnGDqVyAjGhVmw@mail.gmail.com>
References: <1304496817-7646-1-git-send-email-mcree@orcon.net.nz>
	<BANLkTiknKa8xq5UQYTWKZnGDqVyAjGhVmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110506214052V.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 06 May 2011 21:43:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011 17:59:29 -0400
Matt Turner <mattst88@gmail.com> wrote:

> Other architectures define this differently.
> 
> arch/ia64/include/asm/dma-mapping.h:#define DMA_ERROR_CODE 0
> arch/microblaze/include/asm/dma-mapping.h:#define DMA_ERROR_CODE
>          (~(dma_addr_t)0x0)
> arch/powerpc/include/asm/dma-mapping.h:#define DMA_ERROR_CODE
>  (~(dma_addr_t)0x0)
> arch/sparc/include/asm/dma-mapping.h:#define DMA_ERROR_CODE
> (~(dma_addr_t)0x0)
> arch/x86/include/asm/dma-mapping.h:#define DMA_ERROR_CODE       0
> 
> Any idea what the reason is?

Because an invalid DMA address is architecture specific. To be exact,
an invalid DMA address is DMA operation specific.

As I wrote in another mail, this patch is wrong.

Architectures don't need to define DMA_ERROR_CODE.

Some architectures need multiple dma_mapping_error functions. You
could use DMA_ERROR_CODE in order to avoid duplicated code like
this. That is, you define only for dma_map_ops that needs the own
mapping_error function.

static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
{
	struct dma_map_ops *ops = get_dma_ops(dev);
	if (ops->mapping_error)
		return ops->mapping_error(dev, dma_addr);

	return (dma_addr == DMA_ERROR_CODE);
}
