Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab2IFHig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 03:38:36 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42147 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab2IFHie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 03:38:34 -0400
Date: Thu, 6 Sep 2012 09:39:04 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "alexander.deucher@amd.com" <alexander.deucher@amd.com>,
        "airlied@redhat.com" <airlied@redhat.com>,
        "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Shi, Yang A" <yang.a.shi@intel.com>
Subject: Re: [Patch 0/1]drm_irq: Introducing the irq_thread support
Message-ID: <20120906073904.GD5523@phenom.ffwll.local>
Mail-Followup-To: "Liu, Chuansheng" <chuansheng.liu@intel.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"alexander.deucher@amd.com" <alexander.deucher@amd.com>,
	"airlied@redhat.com" <airlied@redhat.com>,
	"'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"Shi, Yang A" <yang.a.shi@intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A177306@SHSMSX101.ccr.corp.intel.com>
 <20120905134932.00707b98@pyramind.ukuu.org.uk>
 <27240C0AC20F114CBF8149A2696CBE4A177FB6@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A177FB6@SHSMSX101.ccr.corp.intel.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 12:42:05AM +0000, Liu, Chuansheng wrote:
> > This possibly ought to be submitted in parallel with the code that uses it so that
> > the whole proposal can be evaluated as one thing ?
> > 
> > Alan
> 
> Patch is here, thanks.
> 
> From: liu chuansheng <chuansheng.liu@intel.com>
> Subject: [PATCH] drm_irq: Introducing the irq_thread support
> 
> For some GPUs, the irq handler need >1ms to handle the irq action.
> And it will delay the whole system irq handler.
> 
> This patch is adding the irq thread support, it will make the drm_irq
> interface more flexible.
> 
> The changes include:
> 1/ Change the request_irq to request_thread_irq, and add new callback
>    irq_handler_t;
> 2/ Normally we need IRQF_ONESHOT flag support for irq thread, so add
>    this option in drm_irq;
> 
> Cc: Shi Yang <yang.a.shi@intel.com>
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>

Nacked-by: Daniel Vetter <daniel.vetter@ffwll.ch>

I _really_ hate when we add random special cases for random strange
drivers to core code - the usual end result is that in a few years we'll
have a maze of special-cases only used by one driver each. And nope,
cleaning that up isn't _that_ much fun ...

So just do all this in your own driver's code (and maybe set
dev->irq_enabled ourselve so that wait_vblank still works).

Yours, Daniel

> ---
>  drivers/gpu/drm/drm_irq.c |    8 ++++++--
>  include/drm/drmP.h        |    2 ++
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
> index 03f16f3..bc105fe 100644
> --- a/drivers/gpu/drm/drm_irq.c
> +++ b/drivers/gpu/drm/drm_irq.c
> @@ -345,13 +345,17 @@ int drm_irq_install(struct drm_device *dev)
>         if (drm_core_check_feature(dev, DRIVER_IRQ_SHARED))
>                 sh_flags = IRQF_SHARED;
>  
> +       if (drm_core_check_feature(dev, DRIVER_IRQ_ONESHOT))
> +               sh_flags |= IRQF_ONESHOT;
> +
>         if (dev->devname)
>                 irqname = dev->devname;
>         else
>                 irqname = dev->driver->name;
>  
> -       ret = request_irq(drm_dev_to_irq(dev), dev->driver->irq_handler,
> -                         sh_flags, irqname, dev);
> +       ret = request_threaded_irq(drm_dev_to_irq(dev),
> +               dev->driver->irq_handler, dev->driver->irq_handler_t,
> +               sh_flags, irqname, dev);
>  
>         if (ret < 0) {
>                 mutex_lock(&dev->struct_mutex);
> diff --git a/include/drm/drmP.h b/include/drm/drmP.h
> index d6b67bb..b28be4b 100644
> --- a/include/drm/drmP.h
> +++ b/include/drm/drmP.h
> @@ -152,6 +152,7 @@ int drm_err(const char *func, const char *format, ...);
>  #define DRIVER_GEM         0x1000
>  #define DRIVER_MODESET     0x2000
>  #define DRIVER_PRIME       0x4000
> +#define DRIVER_IRQ_ONESHOT 0x8000
>  
>  #define DRIVER_BUS_PCI 0x1
>  #define DRIVER_BUS_PLATFORM 0x2
> @@ -872,6 +873,7 @@ struct drm_driver {
>         /* these have to be filled in */
>  
>         irqreturn_t(*irq_handler) (DRM_IRQ_ARGS);
> +       irqreturn_t(*irq_handler_t) (DRM_IRQ_ARGS);
>         void (*irq_preinstall) (struct drm_device *dev);
>         int (*irq_postinstall) (struct drm_device *dev);
>         void (*irq_uninstall) (struct drm_device *dev);
> -- 
> 1.7.0.4
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
