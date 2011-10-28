Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546Ab1J1VvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:51:23 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:43963 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933502Ab1J1Vs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:48:28 -0400
Date: Fri, 28 Oct 2011 23:48:12 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: hjk@hansjkoch.de, Greg KH <greg@kroah.com>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] uio: allow drivers to override the pgprot for
 mmap
Message-ID: <20111028214812.GD23092@local>
References: <1319817030-23992-1-git-send-email-galak@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319817030-23992-1-git-send-email-galak@kernel.crashing.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 10:50:29AM -0500, Kumar Gala wrote:
> For some devices, the default behavior of pgprot_noncached() is not
> appropriate for all of its mappable regions. This provides a means for
> the kernel side of the UIO driver to override the flags without having
> to implement its own full mmap callback.

Thanks for also providing an example driver showing the use of this.
You should also post this driver in a mainline-ready version, I'm a bit
uncomfortable with adding a new function pointer without having any users.

And since you change uio_driver.h you should also update documentation
accordingly (Documentation/DocBook/uio-howto.tmpl).

Otherwise, I have no general objections.

Thanks,
Hans

> 
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> Signed-off-by: Geoff Thorpe <geoff@geoffthorpe.net>
> ---
>  drivers/uio/uio.c          |    6 +++++-
>  include/linux/uio_driver.h |    3 +++
>  2 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index dc27d89..0aebe27 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -655,7 +655,11 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
>  
>  	vma->vm_flags |= VM_IO | VM_RESERVED;
>  
> -	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +	if (idev->info->set_pgprot)
> +		vma->vm_page_prot = idev->info->set_pgprot(idev->info, mi,
> +							   vma->vm_page_prot);
> +	else
> +		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>  
>  	return remap_pfn_range(vma,
>  			       vma->vm_start,
> diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
> index fd99ff9..edfe7c8 100644
> --- a/include/linux/uio_driver.h
> +++ b/include/linux/uio_driver.h
> @@ -80,6 +80,7 @@ struct uio_device;
>   * @open:		open operation for this uio device
>   * @release:		release operation for this uio device
>   * @irqcontrol:		disable/enable irqs when 0/1 is written to /dev/uioX
> + * @set_pgprot:		allow driver to override default(noncached) pgprot
>   */
>  struct uio_info {
>  	struct uio_device	*uio_dev;
> @@ -95,6 +96,8 @@ struct uio_info {
>  	int (*open)(struct uio_info *info, struct inode *inode);
>  	int (*release)(struct uio_info *info, struct inode *inode);
>  	int (*irqcontrol)(struct uio_info *info, s32 irq_on);
> +	pgprot_t (*set_pgprot)(struct uio_info *uio, unsigned int mem_idx,
> +			       pgprot_t prot);
>  };
>  
>  extern int __must_check
> -- 
> 1.7.3.4
> 
> 
