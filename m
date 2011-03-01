Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab1CAIWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 03:22:34 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60059 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab1CAIWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 03:22:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=nzuMTBJXgBnq5/cgND2Rqf2Q5bHO5/g2Ldk/08qUTVkxnisao3nkw/ggHOLaMU3q+k
         upmaqfCpeRsiNwgMue1FXN3PmWW+U2UuaNHb22qJJMeAPWYhifP6nj4Vb+N20Qfvj7o1
         s6fD3nNN0loQHBekGc3PToixQGwMecCg2MK9s=
Message-ID: <4D6CACC2.7010307@gmail.com>
Date: Tue, 01 Mar 2011 09:22:26 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v2 1/1] V4L: videobuf, don't use dma addr as physical
References: <1298967701-11889-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1298967701-11889-1-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2011 09:21 AM, Jiri Slaby wrote:
> mem->dma_handle is a dma address obtained by dma_alloc_coherent which
> needn't be a physical address as a hardware IOMMU can (and most
> likely will) return a bus address where physical != bus address. So
> ensure we are remapping (remap_pfn_range) the right page in
> __videobuf_mmap_mapper by using virt_to_phys(mem->vaddr) and not
> mem->dma_handle.
> 
> While at it, use PFN_DOWN instead of explicit shift to obtain a frame
> number.
> 
> This was discovered by a random review of the code when looking for
> something completely different. I'm not aware of any bug reports for
> this.
> 
> However it is a bug because many v4l drivers use this layer and have
> no idea whether IOMMU is in the system and running or not.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Ah, this is rather:
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> ---
> 
> This is a version with updated changelog.
> 
>  drivers/media/video/videobuf-dma-contig.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
> index c969111..19d3e4a 100644
> --- a/drivers/media/video/videobuf-dma-contig.c
> +++ b/drivers/media/video/videobuf-dma-contig.c
> @@ -300,7 +300,7 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
>  
>  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>  	retval = remap_pfn_range(vma, vma->vm_start,
> -				 mem->dma_handle >> PAGE_SHIFT,
> +				 PFN_DOWN(virt_to_phys(mem->vaddr))
>  				 size, vma->vm_page_prot);
>  	if (retval) {
>  		dev_err(q->dev, "mmap: remap failed with error %d. ", retval);


-- 
js
