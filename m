Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab1DGVlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 17:41:09 -0400
Received: from smtp-out.google.com ([74.125.121.67]:47201 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab1DGVlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 17:41:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=XQmA6bolNsTL7G8MrpdXS1zqvoqawyR39vBCr5+k7djxWFqdcRzIpd14J/T4/jLDy5
         YUdzAW/8dBWYd9/vuhQA==
Date: Thu, 7 Apr 2011 14:40:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Timur Tabi <timur@freescale.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] rename alloc_pages_exact()
In-Reply-To: <20110407172104.1F8B7329@kernel>
Message-ID: <alpine.DEB.2.00.1104071437130.14967@chino.kir.corp.google.com>
References: <20110407172104.1F8B7329@kernel>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Apr 2011, Dave Hansen wrote:

> 
> alloc_pages_exact() returns a virtual address.  But, alloc_pages() returns
> a 'struct page *'.  That makes for very confused kernel hackers.
> 
> __get_free_pages(), on the other hand, returns virtual addresses.  That
> makes alloc_pages_exact() a much closer match to __get_free_pages(), so
> rename it to get_free_pages_exact().
> 

The patch also reverses the arguments of the function in 
include/linux/gfp.h, undoubtedly to resemble the (mask, order) appearance 
of __get_free_pages():

	-void *alloc_pages_exact(size_t size, gfp_t gfp_mask);
	+void *get_free_pages_exact(gfp_t gfp_mask, size_t size);

> Note that alloc_pages_exact()'s partner, free_pages_exact() already
> matches free_pages(), so we do not have to touch the free side of things.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> Acked-by: Andi Kleen <ak@linux.intel.com>
> ---
> 
>  linux-2.6.git-dave/drivers/video/fsl-diu-fb.c  |    2 +-
>  linux-2.6.git-dave/drivers/video/mxsfb.c       |    2 +-
>  linux-2.6.git-dave/drivers/video/pxafb.c       |    4 ++--
>  linux-2.6.git-dave/drivers/virtio/virtio_pci.c |    2 +-
>  linux-2.6.git-dave/include/linux/gfp.h         |    2 +-
>  linux-2.6.git-dave/kernel/profile.c            |    2 +-
>  linux-2.6.git-dave/mm/page_alloc.c             |   24 ++++++++++++------------
>  linux-2.6.git-dave/mm/page_cgroup.c            |    2 +-
>  8 files changed, 20 insertions(+), 20 deletions(-)
> 
> diff -puN drivers/video/fsl-diu-fb.c~change-alloc_pages_exact-name drivers/video/fsl-diu-fb.c
> --- linux-2.6.git/drivers/video/fsl-diu-fb.c~change-alloc_pages_exact-name	2011-04-07 08:37:58.074400957 -0700
> +++ linux-2.6.git-dave/drivers/video/fsl-diu-fb.c	2011-04-07 08:37:58.186400949 -0700
> @@ -294,7 +294,7 @@ static void *fsl_diu_alloc(size_t size, 
>  
>  	pr_debug("size=%zu\n", size);
>  
> -	virt = alloc_pages_exact(size, GFP_DMA | __GFP_ZERO);
> +	virt = get_free_pages_exact(GFP_DMA | __GFP_ZERO, size);
>  	if (virt) {
>  		*phys = virt_to_phys(virt);
>  		pr_debug("virt=%p phys=%llx\n", virt,
> diff -puN drivers/video/pxafb.c~change-alloc_pages_exact-name drivers/video/pxafb.c
> --- linux-2.6.git/drivers/video/pxafb.c~change-alloc_pages_exact-name	2011-04-07 08:37:58.078400957 -0700
> +++ linux-2.6.git-dave/drivers/video/pxafb.c	2011-04-07 08:39:16.198395385 -0700
> @@ -905,7 +905,7 @@ static int __devinit pxafb_overlay_map_v
>  	/* We assume that user will use at most video_mem_size for overlay fb,
>  	 * anyway, it's useless to use 16bpp main plane and 24bpp overlay
>  	 */
> -	ofb->video_mem = alloc_pages_exact(PAGE_ALIGN(pxafb->video_mem_size),
> +	ofb->video_mem = get_free_pages_exact(PAGE_ALIGN(pxafb->video_mem_size),
>  		GFP_KERNEL | __GFP_ZERO);
>  	if (ofb->video_mem == NULL)
>  		return -ENOMEM;

Doesn't look like this is using the arguments in the newly changed order.

> @@ -1714,7 +1714,7 @@ static int __devinit pxafb_init_video_me
>  {
>  	int size = PAGE_ALIGN(fbi->video_mem_size);
>  
> -	fbi->video_mem = alloc_pages_exact(size, GFP_KERNEL | __GFP_ZERO);
> +	fbi->video_mem = get_free_pages_exact(GFP_KERNEL | __GFP_ZERO, size);
>  	if (fbi->video_mem == NULL)
>  		return -ENOMEM;
>  
> diff -puN drivers/virtio/virtio_pci.c~change-alloc_pages_exact-name drivers/virtio/virtio_pci.c
> --- linux-2.6.git/drivers/virtio/virtio_pci.c~change-alloc_pages_exact-name	2011-04-07 08:37:58.082400957 -0700
> +++ linux-2.6.git-dave/drivers/virtio/virtio_pci.c	2011-04-07 08:37:58.190400949 -0700
> @@ -385,7 +385,7 @@ static struct virtqueue *setup_vq(struct
>  	info->msix_vector = msix_vec;
>  
>  	size = PAGE_ALIGN(vring_size(num, VIRTIO_PCI_VRING_ALIGN));
> -	info->queue = alloc_pages_exact(size, GFP_KERNEL|__GFP_ZERO);
> +	info->queue = get_free_pages_exact(GFP_KERNEL|__GFP_ZERO, size);
>  	if (info->queue == NULL) {
>  		err = -ENOMEM;
>  		goto out_info;
> diff -puN include/linux/gfp.h~change-alloc_pages_exact-name include/linux/gfp.h
> --- linux-2.6.git/include/linux/gfp.h~change-alloc_pages_exact-name	2011-04-07 08:37:58.086400956 -0700
> +++ linux-2.6.git-dave/include/linux/gfp.h	2011-04-07 08:37:58.190400949 -0700
> @@ -351,7 +351,7 @@ extern struct page *alloc_pages_vma(gfp_
>  extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
>  extern unsigned long get_zeroed_page(gfp_t gfp_mask);
>  
> -void *alloc_pages_exact(size_t size, gfp_t gfp_mask);
> +void *get_free_pages_exact(gfp_t gfp_mask, size_t size);
>  void free_pages_exact(void *virt, size_t size);
>  
>  #define __get_free_page(gfp_mask) \
> diff -puN kernel/profile.c~change-alloc_pages_exact-name kernel/profile.c
> --- linux-2.6.git/kernel/profile.c~change-alloc_pages_exact-name	2011-04-07 08:37:58.090400955 -0700
> +++ linux-2.6.git-dave/kernel/profile.c	2011-04-07 08:37:58.190400949 -0700
> @@ -121,7 +121,7 @@ int __ref profile_init(void)
>  	if (prof_buffer)
>  		return 0;
>  
> -	prof_buffer = alloc_pages_exact(buffer_bytes,
> +	prof_buffer = get_free_pages_exact(buffer_bytes,
>  					GFP_KERNEL|__GFP_ZERO|__GFP_NOWARN);
>  	if (prof_buffer)
>  		return 0;

Here either.

Everything else looks good, so once these are corrected:

	Acked-by: David Rientjes <rientjes@google.com>
