Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab1CYGJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 02:09:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:53532 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882Ab1CYGJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 02:09:38 -0400
Subject: Re: [media] V4L: videobuf, don't use dma addr as physical
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <201103241704.p2OH42jb016613@hera.kernel.org>
References: <201103241704.p2OH42jb016613@hera.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 17:09:23 +1100
Message-ID: <1301033363.2402.466.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-24 at 17:04 +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/35d9f510b67b10338161aba6229d4f55b4000f5b
> Commit:     35d9f510b67b10338161aba6229d4f55b4000f5b
> Parent:     4093a5c4a3f59cba1a085bbf87b6ffdddc5a443d
> Author:     Jiri Slaby <jslaby@suse.cz>
> AuthorDate: Mon Feb 28 06:37:02 2011 -0300
> Committer:  Mauro Carvalho Chehab <mchehab@redhat.com>
> CommitDate: Tue Mar 22 06:51:54 2011 -0300
> 
>     [media] V4L: videobuf, don't use dma addr as physical
>     
>     mem->dma_handle is a dma address obtained by dma_alloc_coherent which
>     needn't be a physical address in presence of IOMMU, as
>     a hardware IOMMU can (and most likely) will return a bus address where
>     physical != bus address.
>     
>     So ensure we are remapping (remap_pfn_range) the right page in
>     __videobuf_mmap_mapper by using virt_to_phys(mem->vaddr) and not
>     mem->dma_handle.
>     
>     While at it, use PFN_DOWN instead of explicit shift.

Sadly that doesn't work on all archs either... some will return
addresses in the "vmalloc" space from dma_alloc_coherent() (due to the
need to create non-cachable mappings there) and you can't pass those
through virt_to_phys() either.

I'm sad that thing got merged at all. This whole videobuf2 looks like an
unreviewed pile of crap to me. It re-invents dma pool management,
re-invents even kref's, etc...

As for mmap'ing DMA, there's an attempt at fixing that done by the Alsa
folks in the form of dma_mmap_coherent(). (See sound/core/pcm_native.c).

Only ARM implements it now. We need to move the

#define ARCH_HAS_DMA_MMAP_COHERENT

Out of the sound code into an ARM header tho, that way you can use it
too, and I shall implement a variant for non-coherent embedded PPCs
while at it (I'll take care of that last part).

Ben.

>     [mchehab@redhat.com: Fix compilation breakage due to the lack of a comma]
>     Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>     Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/video/videobuf-dma-contig.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
> index c969111..c4742fc 100644
> --- a/drivers/media/video/videobuf-dma-contig.c
> +++ b/drivers/media/video/videobuf-dma-contig.c
> @@ -300,7 +300,7 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
>  
>  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>  	retval = remap_pfn_range(vma, vma->vm_start,
> -				 mem->dma_handle >> PAGE_SHIFT,
> +				 PFN_DOWN(virt_to_phys(mem->vaddr)),
>  				 size, vma->vm_page_prot);
>  	if (retval) {
>  		dev_err(q->dev, "mmap: remap failed with error %d. ", retval);
> --
> To unsubscribe from this list: send the line "unsubscribe git-commits-head" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


