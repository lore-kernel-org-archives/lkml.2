Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab1HZRrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 13:47:04 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43043 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403Ab1HZRrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 13:47:01 -0400
X-Sasl-enc: p6gRYtMqKxuvbCj9J1XGAKfbIq26ayofEToxJKDikSV5 1314380820
Date: Fri, 26 Aug 2011 10:45:47 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] gma500: frame buffer locking
Message-ID: <20110826174547.GA9937@kroah.com>
References: <20110826101734.16760.64364.stgit@localhost.localdomain>
 <20110826101945.16760.8598.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826101945.16760.8598.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 11:19:58AM +0100, Alan Cox wrote:
> From: Alan Cox <alan@linux.intel.com>
> 
> If we are the console then a printk can hit us with a spin lock held (and
> in fact the kernel will do its best to take printing lock).
> 
> In that case we cannot politely sleep when synching after an accelerated op
> but must behave obnixously to be sure of getting the bits out.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/staging/gma500/accel_2d.c |   10 ++++++----
>  drivers/staging/gma500/psb_drv.c  |    2 +-
>  drivers/staging/gma500/psb_drv.h  |    2 +-
>  kernel/printk.c                   |    2 +-
>  4 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/gma500/accel_2d.c b/drivers/staging/gma500/accel_2d.c
> index be92371..114b99a 100644
> --- a/drivers/staging/gma500/accel_2d.c
> +++ b/drivers/staging/gma500/accel_2d.c
> @@ -111,8 +111,9 @@ static int psbfb_2d_submit(struct drm_psb_private *dev_priv, uint32_t *cmdbuf,
>  	int ret = 0;
>  	int i;
>  	unsigned submit_size;
> +	unsigned long flags;
>  
> -	mutex_lock(&dev_priv->mutex_2d);
> +	spin_lock_irqsave(&dev_priv->lock_2d, flags);
>  	while (size > 0) {
>  		submit_size = (size < 0x60) ? size : 0x60;
>  		size -= submit_size;
> @@ -127,7 +128,7 @@ static int psbfb_2d_submit(struct drm_psb_private *dev_priv, uint32_t *cmdbuf,
>  
>  		(void)PSB_RSGX32(PSB_SGX_2D_SLAVE_PORT + i - 4);
>  	}
> -	mutex_unlock(&dev_priv->mutex_2d);
> +	spin_unlock_irqrestore(&dev_priv->lock_2d, flags);
>  	return ret;
>  }
>  
> @@ -327,8 +328,9 @@ int psbfb_sync(struct fb_info *info)
>  	struct drm_psb_private *dev_priv = dev->dev_private;
>  	unsigned long _end = jiffies + DRM_HZ;
>  	int busy = 0;
> +	unsigned long flags;
>  
> -	mutex_lock(&dev_priv->mutex_2d);
> +	spin_lock_irqsave(&dev_priv->lock_2d, flags);
>  	/*
>  	 * First idle the 2D engine.
>  	 */
> @@ -357,7 +359,7 @@ int psbfb_sync(struct fb_info *info)
>  					_PSB_C2B_STATUS_BUSY) != 0);
>  
>  out:
> -	mutex_unlock(&dev_priv->mutex_2d);
> +	spin_unlock_irqrestore(&dev_priv->lock_2d, flags);
>  	return (busy) ? -EBUSY : 0;
>  }
>  
> diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
> index 34cf24a..9470af9 100644
> --- a/drivers/staging/gma500/psb_drv.c
> +++ b/drivers/staging/gma500/psb_drv.c
> @@ -228,7 +228,7 @@ static int psb_do_init(struct drm_device *dev)
>  
>  
>  	spin_lock_init(&dev_priv->irqmask_lock);
> -	mutex_init(&dev_priv->mutex_2d);
> +	spin_lock_init(&dev_priv->lock_2d);
>  
>  	PSB_WSGX32(0x00000000, PSB_CR_BIF_BANK0);
>  	PSB_WSGX32(0x00000000, PSB_CR_BIF_BANK1);
> diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
> index 9cbb494..11d963a 100644
> --- a/drivers/staging/gma500/psb_drv.h
> +++ b/drivers/staging/gma500/psb_drv.h
> @@ -612,7 +612,7 @@ struct drm_psb_private {
>  	void (*exit_idle)(struct drm_device *dev, u32 update_src);
>  
>  	/* 2D acceleration */
> -	struct mutex mutex_2d;
> +	spinlock_t lock_2d;
>  
>  	/* FIXME: Arrays anyone ? */
>  	struct mdfld_dsi_encoder *encoder0;	
> diff --git a/kernel/printk.c b/kernel/printk.c
> index e861488..af2eec8 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -512,7 +512,7 @@ static void __call_console_drivers(unsigned start, unsigned end)
>  	struct console *con;
>  
>  	for_each_console(con) {
> -		if (exclusive_console && con != exclusive_console)
> +		if (0 && exclusive_console && con != exclusive_console)
>  			continue;
>  		if ((con->flags & CON_ENABLED) && con->write &&
>  				(cpu_online(smp_processor_id()) ||

Are you sure you want this in the tree?  I don't feel comfortable making
this fix just for one staging driver right now, do you?

greg k-h
