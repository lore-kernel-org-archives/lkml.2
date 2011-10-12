Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab1JLPct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 11:32:49 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:56518 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab1JLPcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 11:32:48 -0400
Date: Wed, 12 Oct 2011 17:32:29 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: hjk@hansjkoch.de, gregkh@suse.de, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, Kai Jiang <Kai.Jiang@freescale.com>
Subject: Re: [PATCH] uio: Support 36-bit physical addresses on 32-bit systems
Message-ID: <20111012153229.GB21852@local>
References: <1318430145-19898-1-git-send-email-galak@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318430145-19898-1-git-send-email-galak@kernel.crashing.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 09:35:45AM -0500, Kumar Gala wrote:
> From: Kai Jiang <Kai.Jiang@freescale.com>
> 
> To support >32-bit physical addresses for UIO_MEM_PHYS type we need to
> extend the width of 'addr' in struct uio_mem.  Numerous platforms like
> embedded PPC, ARM, and X86 have support for systems with larger physical
> address than logical.
> 
> Since 'addr' may contain a physical, logical, or virtual address the
> easiest solution is to just change the type to 'unsigned long long'
> regardless of which type is utilized.

No. There's phys_addr_t for that purpose, defined in include/linux/types.h.
Please use that.

Thanks,
Hans

> 
> For physical address we can support up to a 44-bit physical address on a
> typical 32-bit system as we utilize remap_pfn_range() for the mapping of
> the memory region and pfn's are represnted by shifting the address by
> the page size (typically 4k).
> 
> Signed-off-by: Kai Jiang <Kai.Jiang@freescale.com>
> Signed-off-by: Minghuan Lian <Minghuan.Lian@freescale.com>
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
>  drivers/uio/uio.c          |    8 ++++----
>  include/linux/uio_driver.h |    2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index d2efe82..a927c51 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -69,7 +69,7 @@ static ssize_t map_name_show(struct uio_mem *mem, char *buf)
>  
>  static ssize_t map_addr_show(struct uio_mem *mem, char *buf)
>  {
> -	return sprintf(buf, "0x%lx\n", mem->addr);
> +	return sprintf(buf, "0x%llx\n", mem->addr);
>  }
>  
>  static ssize_t map_size_show(struct uio_mem *mem, char *buf)
> @@ -79,7 +79,7 @@ static ssize_t map_size_show(struct uio_mem *mem, char *buf)
>  
>  static ssize_t map_offset_show(struct uio_mem *mem, char *buf)
>  {
> -	return sprintf(buf, "0x%lx\n", mem->addr & ~PAGE_MASK);
> +	return sprintf(buf, "0x%llx\n", mem->addr & ~PAGE_MASK);
>  }
>  
>  struct map_sysfs_entry {
> @@ -634,8 +634,8 @@ static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	if (idev->info->mem[mi].memtype == UIO_MEM_LOGICAL)
>  		page = virt_to_page(idev->info->mem[mi].addr + offset);
>  	else
> -		page = vmalloc_to_page((void *)idev->info->mem[mi].addr
> -							+ offset);
> +		page = vmalloc_to_page((void *)(unsigned long)
> +				idev->info->mem[mi].addr + offset);
>  	get_page(page);
>  	vmf->page = page;
>  	return 0;
> diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
> index 665517c..c1fdb19 100644
> --- a/include/linux/uio_driver.h
> +++ b/include/linux/uio_driver.h
> @@ -31,7 +31,7 @@ struct uio_map;
>   */
>  struct uio_mem {
>  	const char		*name;
> -	unsigned long		addr;
> +	unsigned long long	addr;
>  	unsigned long		size;
>  	int			memtype;
>  	void __iomem		*internal_addr;
> -- 
> 1.7.3.4
> 
> 
