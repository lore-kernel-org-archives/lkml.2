Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab1LUCAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 21:00:03 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:46698 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab1LUCAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 21:00:01 -0500
Date: Wed, 21 Dec 2011 02:59:35 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] uio: Pass pointers to virt_to_page(), not integers
Message-ID: <20111221015934.GA27441@local>
References: <1324430940.2844.144.camel@deadeye>
 <1324431393.2844.153.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324431393.2844.153.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 01:36:33AM +0000, Ben Hutchings wrote:
> Most architectures define virt_to_page() as a macro that casts its
> argument such that an argument of type unsigned long will be accepted
> without complaint.  However, the proper type is void *, and passing
> unsigned long results in a warning on MIPS.

Not only on MIPS... This is already fixed in Greg's tree and will go
to mainline in the next merge window.

Thanks,
Hans

> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> It might be clearer to assign:
> 
> 	addr = (void *)((unsigned long)idev->info->mem[mi].addr + offset);
> 
> since arithmetic on void pointers is weird.  Either way should work though.
> 
> Ben.
> 
>  drivers/uio/uio.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index a783d53..1ff7927 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -620,6 +620,7 @@ static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	struct uio_device *idev = vma->vm_private_data;
>  	struct page *page;
>  	unsigned long offset;
> +	void *addr;
>  
>  	int mi = uio_find_mem_index(vma);
>  	if (mi < 0)
> @@ -631,10 +632,11 @@ static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	 */
>  	offset = (vmf->pgoff - mi) << PAGE_SHIFT;
>  
> +	addr = (void *)(unsigned long)idev->info->mem[mi].addr + offset;
>  	if (idev->info->mem[mi].memtype == UIO_MEM_LOGICAL)
> -		page = virt_to_page(idev->info->mem[mi].addr + offset);
> +		page = virt_to_page(addr);
>  	else
> -		page = vmalloc_to_page((void *)(unsigned long)idev->info->mem[mi].addr + offset);
> +		page = vmalloc_to_page(addr);
>  	get_page(page);
>  	vmf->page = page;
>  	return 0;
> -- 
> 1.7.7.3
> 
> 
> 
> 
