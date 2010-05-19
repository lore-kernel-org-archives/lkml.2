Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab0ESNbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 09:31:22 -0400
Received: from bar.sig21.net ([80.81.252.164]:39980 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab0ESNbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 09:31:20 -0400
Date: Wed, 19 May 2010 15:30:28 +0200
From: Johannes Stezenbach <js@sig21.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, manfred@colorfullife.com,
       David Miller <davem@davemloft.net>, penberg@cs.helsinki.fi,
       mpm@selenic.com, ken@codelabs.ch, geert@linux-m68k.org,
       michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp
Subject: Re: [PATCH 1/4] mm: Move ARCH_SLAB_MINALIGN and
 ARCH_KMALLOC_MINALIGN to <linux/slab_def.h>
Message-ID: <20100519133028.GA26659@sig21.net>
References: <1274266725.6930.9823.camel@macbook.infradead.org>
 <1274266902.6930.9834.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274266902.6930.9834.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.7 (---)
X-Spam-21-Report: No, score=-3.7 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.730,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have some comments/questions, I hope it's not too silly:

On Wed, May 19, 2010 at 12:01:42PM +0100, David Woodhouse wrote:
> +#ifndef ARCH_KMALLOC_MINALIGN
> +/*
> + * Enforce a minimum alignment for the kmalloc caches.
> + * Usually, the kmalloc caches are cache_line_size() aligned, except when
> + * DEBUG and FORCED_DEBUG are enabled, then they are BYTES_PER_WORD aligned.
> + * Some archs want to perform DMA into kmalloc caches and need a guaranteed
> + * alignment larger than the alignment of a 64-bit integer.
> + * ARCH_KMALLOC_MINALIGN allows that.
> + * Note that increasing this value may disable some debug features.
> + */
> +#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
> +#endif

I think the comment is confusing.  IIRC kmalloc() API guarantees that
the allocated buffer is suitable for DMA, so if cache coherence is not
handled by hardware the arch might need to set this to the cache line size,
and that's what ARCH_KMALLOC_MINALIGN is about. Nothing else.

I'm not sure if kmalloc() API makes any guarantee regarding alignment,
like 32bit or 64bit or sizeof(void *) ...?  At least I cannot find
any documentation about this.


> +#ifndef ARCH_SLAB_MINALIGN
> +/*
> + * Enforce a minimum alignment for all caches.
> + * Intended for archs that get misalignment faults even for BYTES_PER_WORD
> + * aligned buffers. Includes ARCH_KMALLOC_MINALIGN.
> + * If possible: Do not enable this flag for CONFIG_DEBUG_SLAB, it disables
> + * some debug features.
> + */
> +#define ARCH_SLAB_MINALIGN 0
> +#endif

Why is this needed at all?  If code calls kmem_cache_create()
with wrong align parameter, or has wrong expectations wrt kmalloc()
alignment guarantees, this code needs to be fixed?
I mean, portable code cannot assume that unaligned accesses work?


Thanks
Johannes
