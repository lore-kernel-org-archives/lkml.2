Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab2LFW2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 17:28:12 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:51539 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab2LFW2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 17:28:11 -0500
Date: Thu, 6 Dec 2012 23:28:06 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Benedikt Spranger <b.spranger@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hjk@hansjkoch.de, gregkh@linuxfoundation.org,
        Alexander.Frank@eberspaecher.com
Subject: Re: [PATCH 1/2] uio: be aware of open(), mmap(), close()
Message-ID: <20121206222806.GD2611@local>
References: <1354797897-23423-1-git-send-email-b.spranger@linutronix.de>
 <1354797897-23423-2-git-send-email-b.spranger@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354797897-23423-2-git-send-email-b.spranger@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 01:44:56PM +0100, Benedikt Spranger wrote:
> After open(), mmap(), close() the mmaped pointer is valid. Removing the
> underlaying module causes a Oops or other strange effects. Keep all structures
> valid till the last user is gone.
> 
> Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
> ---
>  drivers/uio/uio.c             |   59 ++++++++++++++++++++++++++++++-----------
>  drivers/uio/uio_pdrv_genirq.c |    4 +--
>  include/linux/uio_driver.h    |    4 +--
>  3 files changed, 48 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index 5110f36..b96499a 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -433,8 +433,22 @@ static irqreturn_t uio_interrupt(int irq, void *dev_id)
>  struct uio_listener {
>  	struct uio_device *dev;
>  	s32 event_count;
> +	struct kref kref;
>  };
>  
> +static void uio_release_listener(struct kref *kref)
> +{
> +	struct uio_listener *listener = container_of(kref, struct uio_listener,
> +						     kref);
> +	struct uio_device *idev = listener->dev;
> +
> +	if (idev->info->release)
> +		idev->info->release(idev->info);
> +
> +	module_put(idev->owner);
> +	kfree(listener);
> +}
> +
>  static int uio_open(struct inode *inode, struct file *filep)
>  {
>  	struct uio_device *idev;
> @@ -465,10 +479,13 @@ static int uio_open(struct inode *inode, struct file *filep)
>  	filep->private_data = listener;
>  
>  	if (idev->info->open) {
> -		ret = idev->info->open(idev->info, inode);
> +		ret = idev->info->open(idev->info);
>  		if (ret)
>  			goto err_infoopen;
>  	}
> +
> +	kref_init(&listener->kref);
> +
>  	return 0;
>  
>  err_infoopen:
> @@ -491,16 +508,11 @@ static int uio_fasync(int fd, struct file *filep, int on)
>  
>  static int uio_release(struct inode *inode, struct file *filep)
>  {
> -	int ret = 0;
>  	struct uio_listener *listener = filep->private_data;
> -	struct uio_device *idev = listener->dev;
>  
> -	if (idev->info->release)
> -		ret = idev->info->release(idev->info, inode);
> +	kref_put(&listener->kref, uio_release_listener);
>  
> -	module_put(idev->owner);
> -	kfree(listener);
> -	return ret;
> +	return 0;
>  }
>  
>  static unsigned int uio_poll(struct file *filep, poll_table *wait)
> @@ -605,19 +617,22 @@ static int uio_find_mem_index(struct vm_area_struct *vma)
>  
>  static void uio_vma_open(struct vm_area_struct *vma)
>  {
> -	struct uio_device *idev = vma->vm_private_data;
> -	idev->vma_count++;
> +	struct uio_listener *listener = vma->vm_private_data;
> +
> +	kref_get(&listener->kref);
>  }
>  
>  static void uio_vma_close(struct vm_area_struct *vma)
>  {
> -	struct uio_device *idev = vma->vm_private_data;
> -	idev->vma_count--;
> +	struct uio_listener *listener = vma->vm_private_data;
> +
> +	kref_put(&listener->kref, uio_release_listener);
>  }
>  
>  static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  {
> -	struct uio_device *idev = vma->vm_private_data;
> +	struct uio_listener *listener = vma->vm_private_data;
> +	struct uio_device *idev = listener->dev;
>  	struct page *page;
>  	unsigned long offset;
>  
> @@ -646,20 +661,34 @@ static const struct vm_operations_struct uio_vm_ops = {
>  	.fault = uio_vma_fault,
>  };
>  
> +static const struct vm_operations_struct uio_phys_ops = {
> +	.open = uio_vma_open,
> +	.close = uio_vma_close,
> +};
> +
>  static int uio_mmap_physical(struct vm_area_struct *vma)
>  {
>  	struct uio_device *idev = vma->vm_private_data;
>  	int mi = uio_find_mem_index(vma);
> +	int ret;
> +
>  	if (mi < 0)
>  		return -EINVAL;
>  
>  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +	vma->vm_ops = &uio_phys_ops;
>  
> -	return remap_pfn_range(vma,
> +	ret = remap_pfn_range(vma,
>  			       vma->vm_start,
>  			       idev->info->mem[mi].addr >> PAGE_SHIFT,
>  			       vma->vm_end - vma->vm_start,
>  			       vma->vm_page_prot);
> +	if (ret)
> +		return ret;
> +
> +	uio_vma_open(vma);
> +
> +	return 0;
>  }
>  
>  static int uio_mmap_logical(struct vm_area_struct *vma)
> @@ -681,7 +710,7 @@ static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
>  	if (vma->vm_end < vma->vm_start)
>  		return -EINVAL;
>  
> -	vma->vm_private_data = idev;
> +	vma->vm_private_data = listener;
>  
>  	mi = uio_find_mem_index(vma);
>  	if (mi < 0)
> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
> index 42202cd..a4e32fa 100644
> --- a/drivers/uio/uio_pdrv_genirq.c
> +++ b/drivers/uio/uio_pdrv_genirq.c
> @@ -37,7 +37,7 @@ struct uio_pdrv_genirq_platdata {
>  	struct platform_device *pdev;
>  };
>  
> -static int uio_pdrv_genirq_open(struct uio_info *info, struct inode *inode)
> +static int uio_pdrv_genirq_open(struct uio_info *info)
>  {
>  	struct uio_pdrv_genirq_platdata *priv = info->priv;
>  
> @@ -46,7 +46,7 @@ static int uio_pdrv_genirq_open(struct uio_info *info, struct inode *inode)
>  	return 0;
>  }
>  
> -static int uio_pdrv_genirq_release(struct uio_info *info, struct inode *inode)
> +static int uio_pdrv_genirq_release(struct uio_info *info)
>  {
>  	struct uio_pdrv_genirq_platdata *priv = info->priv;
>  
> diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
> index 1ad4724..1bc6493 100644
> --- a/include/linux/uio_driver.h
> +++ b/include/linux/uio_driver.h
> @@ -92,8 +92,8 @@ struct uio_info {
>  	void			*priv;
>  	irqreturn_t (*handler)(int irq, struct uio_info *dev_info);
>  	int (*mmap)(struct uio_info *info, struct vm_area_struct *vma);
> -	int (*open)(struct uio_info *info, struct inode *inode);
> -	int (*release)(struct uio_info *info, struct inode *inode);
> +	int (*open)(struct uio_info *info);
> +	void (*release)(struct uio_info *info);

Interface changes like that need an explanation and want to go to
a separate patch.

Thanks,
Hans
