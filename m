Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab0LFR6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:58:18 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:51653 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab0LFR6R (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 12:58:17 -0500
Date: Mon, 6 Dec 2010 12:54:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: mchehab@infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] V4L: videobuf, don't use dma addr as physical
Message-ID: <20101206175418.GA26693@dumpdata.com>
References: <1291642252-10264-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291642252-10264-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 02:30:52PM +0100, Jiri Slaby wrote:
> mem->dma_handle is a dma address obtained by dma_alloc_coherent which
> needn't be a physical address in presence of IOMMU. So ensure we are

Could you use  PFN_DOWN(virt_to_phys(mem->vaddr)?
> remapping (remap_pfn_range) the right page in __videobuf_mmap_mapper
> by using virt_to_phys(mem->vaddr) and not mem->dma_handle.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> ---
>  drivers/media/video/videobuf-dma-contig.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
> index c969111..8d778aa 100644
> --- a/drivers/media/video/videobuf-dma-contig.c
> +++ b/drivers/media/video/videobuf-dma-contig.c
> @@ -300,7 +300,7 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
>  
>  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>  	retval = remap_pfn_range(vma, vma->vm_start,
> -				 mem->dma_handle >> PAGE_SHIFT,
> +				 virt_to_phys(mem->vaddr) >> PAGE_SHIFT,
>  				 size, vma->vm_page_prot);
>  	if (retval) {
>  		dev_err(q->dev, "mmap: remap failed with error %d. ", retval);
> -- 
> 1.7.3.1
> 
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/iommu
