Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab0FGG2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 02:28:07 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:40274 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab0FGG2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 02:28:05 -0400
Date: Mon, 7 Jun 2010 15:27:30 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mitov@issp.bas.bg, linux-kernel@vger.kernel.org
Subject: Re: [BUG][PATCH]dma-coherent.c: error path bug
Message-ID: <20100607062729.GA5135@linux-sh.org>
References: <201006070708.57453.mitov@issp.bas.bg> <20100607132631W.fujita.tomonori@lab.ntt.co.jp> <201006070743.20226.mitov@issp.bas.bg> <20100607135845B.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100607135845B.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 01:59:48PM +0900, FUJITA Tomonori wrote:
> On Mon, 7 Jun 2010 07:43:19 +0300
> Marin Mitov <mitov@issp.bas.bg> wrote:
> > On Monday, June 07, 2010 07:27:49 am FUJITA Tomonori wrote:
> > > On Mon, 7 Jun 2010 07:08:56 +0300
> > > Marin Mitov <mitov@issp.bas.bg> wrote:
> > > > On Monday, June 07, 2010 05:30:48 am FUJITA Tomonori wrote:
> > > > > Hmm, if dma_declare_coherent_memory() fails, the driver doesn't use
> > > > > dev->dma_mem. So even if dev->dma_mem points to a freed memory, I'm
> > > > > not sure that it causes a real problem. We could call this patch a
> > > > > cleanup though.
> > > > > 
> > > > My understanding of dma_alloc_coherent() is that  we first try to allocate from 
> > > > per-device coherent memory and we do it using dma_alloc_from_coherent()
> > > > (in drivers/base/dma-coherent.c) if dev->dma_mem is not NULL (and we have 
> > > > left it not NULL, here is the problem). If allocation of dev->dma_mem->bitmap 
> > > > fails dev->dma_mem must be NULL.
> > > 
> > > But are there any driver that can continue when dma_declare_coherent_memory() fails?
> > > 
> > I do not know if such a real driver exists.
> 
> From a quick look, seems no. There is no fallback for such hardware,
> it's safe assumption, I guess.
> 
Most of the devices using dma_declare_coherent_memory() today do so out
of necessity, usually due to addressing limitations and needing to have
DMA buffers allocated from device memory. This doesn't apply to all
devices though, and indeed didn't apply at all when the interface was
used initially (presently this functionality is pushed down to the DMA
flags, anything that needs to be fixed to the device-specific coherent
region uses DMA_MEMORY_EXCLUSIVE).

drivers/scsi/NCR_Q720.c (which was the only in-tree user for the declare
coherent API before we started using it on SH) is an example of one that
supports fallback to non-exclusive memory, and we've largely managed to
avoid usage clashes with the exception of the following:

	0609697eab9775564845d4c94f9e3780fb791ffd
	cdf57cab27aef72f13a19c86858c6cac9951dc24
	58c6d3dfe436eb8cfb451981d8fdc9044eaf42da

I suspect the generic memory fallback path gets a lot less testing than
the exclusive memory one at least.
