Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab0F2Nhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 09:37:40 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54723 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754557Ab0F2Nhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 09:37:38 -0400
Subject: Re: [PATCH -mm 1/2] scsi: remove dma_is_consistent usage in 53c700
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, grundler@parisc-linux.org, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20100629150201C.fujita.tomonori@lab.ntt.co.jp>
References: <1277651328.4366.7.camel@mulgrave.site>
	 <20100628123503Z.fujita.tomonori@lab.ntt.co.jp>
	 <1277736958.10879.43.camel@mulgrave.site>
	 <20100629150201C.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Jun 2010 08:37:35 -0500
Message-ID: <1277818655.4379.5.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-29 at 15:04 +0900, FUJITA Tomonori wrote:
> On Mon, 28 Jun 2010 09:55:58 -0500
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > > > > I think that we can safely remove the above usage:
> > > > > 
> > > > > - such old systems haven't triger the above checking for long.
> > > > > 
> > > > > - the above condition is important for systems that can't allocate
> > > > >   coherent memory if these systems do DMA. So probably it would be
> > > > >   better to have such checking in arch's DMA initialization code
> > > > >   instead of a driver.
> > > > 
> > > > Well, we can't check in the architecture because it's a driver specific
> > > > thing ... I suppose making it a rule that dma_get_cache_alignment()
> > > > *must* be <= L1_CACHE_BYTES fixes it ... we seem to have no architecture
> > > > violating that, so just add it to the documentation, and the check can
> > > > go.
> > > 
> > > Seems that on some architectures (arm and mips at least),
> > > dma_get_cache_alignment() could greater than L1_CACHE_BYTES. But they
> > > simply return the possible maximum size of cache size like:
> > > 
> > > static inline int dma_get_cache_alignment(void)
> > > {
> > > 	/* XXX Largest on any MIPS */
> > > 	return 128;
> > > }
> > > 
> > > So practically, we should be safe. I guess that we can simply convert
> > > them to return L1_CACHE_BYTES.
> > 
> > As long as that's architecturally true, yes.   I mean I can't imagine
> > any architecture that had a dma alignment requirement that was greater
> > than its L1 cache width ... but I've been surprised be for making
> > "Obviously this can't happen ..." type statements where MIPS is
> > concerned.
> 
> How about using ARCH_KMALLOC_MINALIGN instead of L1_CACHE_BYTES?
> 
> In the previous merge window, we made sure that all the architectures
> defines the minimum alignment and width of DMA properly (and the fully
> coherent architectures don't define ARCH_KMALLOC_MINALIGN).
> 
> dma_get_cache_alignment should be equal to ARCH_KMALLOC_MINALIGN if an
> architecture defines ARCH_KMALLOC_MINALIGN (probably,
> dma_get_cache_alignment() can be implemented in the common place with
> ARCH_KMALLOC_MINALIGN. It would be better to rename
> ARCH_KMALLOC_MINALIGN to something like ARCH_DMA_MINALIGN).
> 
> It might be better to place DMA_ALIGN(x) in the common place. Seems
> that some drivers wrongly use L1_CACHE_ALIGN() to get the dma
> alignment. Well, using cache alignment magic in drivers isn't a good
> idea though...
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] 53c700: remove dma_is_consistent usage in 53c700
> 
> ARCH_KMALLOC_MINALIGN returns the minimum alignment and width of DMA
> on architectures that define ARCH_KMALLOC_MINALIGN (if it's not
> defined, architectures are fully coherent).
> 
> So we can use ARCH_KMALLOC_MINALIGN instead of L1_CACHE_BYTES and
> safely remove the alignment checking.

Actually, I'd rather not do this.  The reason is that L1_CACHE_ALIGN is
quite a big performance optimisation on x86 for the driver.  Without it,
it's functionally correct, but the DMA use of the mailboxes really
thrashes the cache which damages performance (x86 has
ARCH_KMALLOC_MINALIGN set to 8 ... the default)

The only correctness problem, which the BUG is checking for is mismatch
in dma alignment ... as I said, I'm happy just to rely on that being
correct on every incoherent platform the driver operates on.

James


