Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab1DESl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 14:41:28 -0400
Received: from kroah.org ([198.145.64.141]:49115 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698Ab1DESlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 14:41:25 -0400
Date: Tue, 5 Apr 2011 11:35:56 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@linux.jf.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] staging: gma500: Add a test ioctl for issuing 2D
 accel ops via user space
Message-ID: <20110405183556.GA594@kroah.com>
References: <20110401173554.18112.67483.stgit@localhost.localdomain>
 <20110401174128.18112.72945.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110401174128.18112.72945.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 06:41:30PM +0100, Alan Cox wrote:
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/staging/gma500/psb_2d.c  |    2 +-
>  drivers/staging/gma500/psb_drv.h |    3 +++
>  drivers/staging/gma500/psb_fb.c  |   26 ++++++++++++++++++++++++++
>  3 files changed, 30 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/gma500/psb_2d.c b/drivers/staging/gma500/psb_2d.c
> index 9a0691f..94bce5c 100644
> --- a/drivers/staging/gma500/psb_2d.c
> +++ b/drivers/staging/gma500/psb_2d.c
> @@ -84,7 +84,7 @@ static int psb_2d_wait_available(struct drm_psb_private *dev_priv,
>  /* FIXME: Remember if we expose the 2D engine to the DRM we need to serialize
>     it with console use */
>  
> -static int psbfb_2d_submit(struct drm_psb_private *dev_priv, uint32_t *cmdbuf,
> +int psbfb_2d_submit(struct drm_psb_private *dev_priv, uint32_t *cmdbuf,
>  	 	  	   unsigned size)
>  {
>  	int ret = 0;
> diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
> index 7361fbf..8c1eceb 100644
> --- a/drivers/staging/gma500/psb_drv.h
> +++ b/drivers/staging/gma500/psb_drv.h
> @@ -709,6 +709,9 @@ extern int psbfb_sync(struct fb_info *info);
>  
>  extern void psb_spank(struct drm_psb_private *dev_priv);
>  
> +extern int psbfb_2d_submit(struct drm_psb_private *dev_priv, uint32_t *cmdbuf,
> +	 	  	   unsigned size);
> +
>  /*
>   *psb_reset.c
>   */
> diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
> index 6c75df5..6499f28 100644
> --- a/drivers/staging/gma500/psb_fb.c
> +++ b/drivers/staging/gma500/psb_fb.c
> @@ -270,6 +270,31 @@ static int psbfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
>  	return 0;
>  }
>  
> +static int psbfb_ioctl(struct fb_info *info, unsigned int cmd, unsigned long arg)
> +{
> +	struct psb_fbdev *fbdev = info->par;
> +	struct psb_framebuffer *psbfb = fbdev->pfb;
> +	struct drm_device *dev = psbfb->base.dev;
> +	struct drm_psb_private *dev_priv = dev->dev_private;
> +	u32 __user *p = (u32 __user *)arg;
> +	u32 l;
> +	u32 buf[32];
> +	switch (cmd) {
> +	case 0x12345678:
> +		if (!capable(CAP_SYS_RAWIO))
> +			return -EPERM;
> +		if (get_user(l, p))
> +			return -EFAULT;
> +		if (l > 32)
> +			return -EMSGSIZE;
> +		if (copy_from_user(buf, p + 1, l))
> +			return -EFAULT;
> +		psbfb_2d_submit(dev_priv, buf, l);
> +		return 0;

What is this used for?  A test version of an x.org driver?  This will go
away eventually, right?

thanks,

greg k-h
