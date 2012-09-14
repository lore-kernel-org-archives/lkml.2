Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab2INQRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:17:40 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59228 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab2INQRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:17:38 -0400
Date: Fri, 14 Sep 2012 18:18:12 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Matthew Garrett <mjg@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] i915: Don't register backlight when max PWM value is
 unknown
Message-ID: <20120914161812.GB5799@phenom.ffwll.local>
Mail-Followup-To: Grant Likely <grant.likely@secretlab.ca>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	David Airlie <airlied@linux.ie>, Matthew Garrett <mjg@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>
References: <1347636868-3100-1-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347636868-3100-1-git-send-email-grant.likely@secretlab.ca>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 04:34:28PM +0100, Grant Likely wrote:
> When a backlight isn't connected to the i915 it doesn't make any sense
> to register the backlight device, but the driver currently tries to limp
> along using a max brightness value of 1. Instead, this patch makes it so
> that if the maximum PWM value cannot be determined, then the backlight
> will not be registered.
> 
> Tested on MacbookPro8,3.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: David Woodhouse <dwmw2@infradead.org>

I've already merged a rather similar patch from Jani Nikula

commit 28dcc2d60cb570d9f549c329b2f51400553412a1
Author: Jani Nikula <jani.nikula@intel.com>
Date:   Mon Sep 3 16:25:12 2012 +0300

    drm/i915: do not expose a dysfunctional backlight interface to
    userspace

Should land in 3.6 rsn.
-Daniel

> ---
>  drivers/gpu/drm/i915/intel_panel.c |   15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
> index 3df4f5f..f410c6e 100644
> --- a/drivers/gpu/drm/i915/intel_panel.c
> +++ b/drivers/gpu/drm/i915/intel_panel.c
> @@ -168,13 +168,8 @@ u32 intel_panel_get_max_backlight(struct drm_device *dev)
>  	u32 max;
>  
>  	max = i915_read_blc_pwm_ctl(dev_priv);
> -	if (max == 0) {
> -		/* XXX add code here to query mode clock or hardware clock
> -		 * and program max PWM appropriately.
> -		 */
> -		pr_warn_once("fixme: max PWM is zero\n");
> -		return 1;
> -	}
> +	if (max == 0)
> +		return 0; /* Cannot read max PWM. Assume no backlight */
>  
>  	if (HAS_PCH_SPLIT(dev)) {
>  		max >>= 16;
> @@ -413,6 +408,12 @@ int intel_panel_setup_backlight(struct drm_device *dev)
>  	struct backlight_properties props;
>  	struct drm_connector *connector;
>  
> +	/* Is there a backlight present? max will be zero if not */
> +	if (intel_panel_get_max_backlight(dev) == 0) {
> +		DRM_INFO("i915 doesn't seem to be connected to backlight\n");
> +		return 0;
> +	}
> +
>  	intel_panel_init_backlight(dev);
>  
>  	if (dev_priv->int_lvds_connector)
> -- 
> 1.7.9.5
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
