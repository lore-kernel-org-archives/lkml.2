Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab2HOAkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 20:40:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65395 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab2HOAkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 20:40:06 -0400
Date: Tue, 14 Aug 2012 17:40:06 -0700
From: Olof Johansson <olof@lixom.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 14/31] arm64: DMA mapping API
Message-ID: <20120815004006.GG19607@quad.lixom.net>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-15-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344966752-16102-15-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Tue, Aug 14, 2012 at 06:52:15PM +0100, Catalin Marinas wrote:
> This patch adds support for the DMA mapping API. It uses dma_map_ops for
> flexibility and it currently supports swiotlb. This patch could be
> simplified further if the DMA accesses are coherent (not mandated by the
> architecture) or if corresponding hooks are placed in the generic
> swiotlb code to deal with cache maintenance.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm64/include/asm/dma-mapping.h |  124 ++++++++++++++++++++
>  arch/arm64/mm/dma-mapping.c          |  208 ++++++++++++++++++++++++++++++++++
>  2 files changed, 332 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm64/include/asm/dma-mapping.h
>  create mode 100644 arch/arm64/mm/dma-mapping.c
> 
> diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
> new file mode 100644
> index 0000000..538f4b4
> --- /dev/null
> +++ b/arch/arm64/include/asm/dma-mapping.h
> @@ -0,0 +1,124 @@
> +/*
> + * Copyright (C) 2012 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#ifndef __ASM_DMA_MAPPING_H
> +#define __ASM_DMA_MAPPING_H
> +
> +#ifdef __KERNEL__
> +
> +#include <linux/types.h>
> +#include <linux/vmalloc.h>
> +
> +#include <asm-generic/dma-coherent.h>
> +
> +#define ARCH_HAS_DMA_GET_REQUIRED_MASK
> +
> +extern struct dma_map_ops *dma_ops;
> 
> +static inline struct dma_map_ops *get_dma_ops(struct device *dev)
> +{
> +	if (unlikely(!dev) || !dev->archdata.dma_ops)
> +		return dma_ops;
> +	else
> +		return dev->archdata.dma_ops;
> +}

Does it make sense to add the concept of a global dma ops on arm64,
instead of requiring the dma ops pointer per device similar to how
some other platforms do it (including powerpc)? For devices that lack
archdata.dma_ops, dma_supported() should return 0 (and the other ops
should return error).



-Olof
