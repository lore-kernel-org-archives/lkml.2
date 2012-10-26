Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137Ab2JZOFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:05:38 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:39784 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab2JZOFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:05:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: platform: Don't initialize driver-private data
Date: Fri, 26 Oct 2012 16:06:27 +0200
Message-ID: <15899660.S8avMzQBpd@avalon>
User-Agent: KMail/4.9.2 (Linux/3.5.7-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <1350324222-26885-1-git-send-email-thierry.reding@avionic-design.de>
References: <1350324222-26885-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

Thank you for the patch, and sorry for the late reply.

On Monday 15 October 2012 20:03:42 Thierry Reding wrote:
> Platform device drivers usually use the driver-private data for their
> own purposes. Having it overwritten by drm_platform_init() is confusing
> and error-prone.

If you want to push drivers that way, you should get rid of the 
pci_set_drvdata() call in core DRM as well. This would push device driver data 
handling down to all drivers, so I'm not convinced it would actually make 
things simpler.

> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

But I'm not convinced by the patch, as explained above.

> ---
> Note that I don't have any hardware to test the shmobile changes on so
> it would be good to get a Tested-by for that.
> 
>  drivers/gpu/drm/drm_platform.c           |  1 -
>  drivers/gpu/drm/shmobile/shmob_drm_drv.c | 12 +++++-------
>  2 files changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_platform.c b/drivers/gpu/drm/drm_platform.c
> index aaeb6f8..b8a282e 100644
> --- a/drivers/gpu/drm/drm_platform.c
> +++ b/drivers/gpu/drm/drm_platform.c
> @@ -64,7 +64,6 @@ int drm_get_platform_dev(struct platform_device *platdev,
>  	}
> 
>  	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
> -		dev_set_drvdata(&platdev->dev, dev);
>  		ret = drm_get_minor(dev, &dev->control, DRM_MINOR_CONTROL);
>  		if (ret)
>  			goto err_g1;
> diff --git a/drivers/gpu/drm/shmobile/shmob_drm_drv.c
> b/drivers/gpu/drm/shmobile/shmob_drm_drv.c index c71d493..1c350fc 100644
> --- a/drivers/gpu/drm/shmobile/shmob_drm_drv.c
> +++ b/drivers/gpu/drm/shmobile/shmob_drm_drv.c
> @@ -201,6 +201,8 @@ static int shmob_drm_load(struct drm_device *dev,
> unsigned long flags) goto done;
>  	}
> 
> +	platform_set_drvdata(pdev, sdev);
> +
>  done:
>  	if (ret)
>  		shmob_drm_unload(dev);
> @@ -299,11 +301,9 @@ static struct drm_driver shmob_drm_driver = {
>  #if CONFIG_PM_SLEEP
>  static int shmob_drm_pm_suspend(struct device *dev)
>  {
> -	struct platform_device *pdev = to_platform_device(dev);
> -	struct drm_device *ddev = platform_get_drvdata(pdev);
> -	struct shmob_drm_device *sdev = ddev->dev_private;
> +	struct shmob_drm_device *sdev = dev_get_drvdata(dev);
> 
> -	drm_kms_helper_poll_disable(ddev);
> +	drm_kms_helper_poll_disable(sdev->ddev);
>  	shmob_drm_crtc_suspend(&sdev->crtc);
> 
>  	return 0;
> @@ -311,9 +311,7 @@ static int shmob_drm_pm_suspend(struct device *dev)
> 
>  static int shmob_drm_pm_resume(struct device *dev)
>  {
> -	struct platform_device *pdev = to_platform_device(dev);
> -	struct drm_device *ddev = platform_get_drvdata(pdev);
> -	struct shmob_drm_device *sdev = ddev->dev_private;
> +	struct shmob_drm_device *sdev = dev_get_drvdata(dev);
> 
>  	mutex_lock(&sdev->ddev->mode_config.mutex);
>  	shmob_drm_crtc_resume(&sdev->crtc);

-- 
Regards,

Laurent Pinchart

