Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1HHQ1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 12:27:35 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:37007 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753232Ab1HHQ1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 12:27:34 -0400
Date: Mon, 8 Aug 2011 09:27:19 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 1/4] drm/i915: Wait for LVDS panel power
 sequence
Message-ID: <20110808092719.4f62983d@jbarnes-desktop>
In-Reply-To: <1312653248-3487-2-git-send-email-keithp@keithp.com>
References: <1312653248-3487-1-git-send-email-keithp@keithp.com>
	<1312653248-3487-2-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  6 Aug 2011 10:54:05 -0700
Keith Packard <keithp@keithp.com> wrote:

> During mode setting, check to make sure the panel power sequencing has
> completed before doing further operations on the device. This
> uncovered errors with DPMS not turning the device off as it was left locked.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/intel_lvds.c |   13 +++++++++++--
>  1 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
> index 2e8ddfc..6985e42 100644
> --- a/drivers/gpu/drm/i915/intel_lvds.c
> +++ b/drivers/gpu/drm/i915/intel_lvds.c
> @@ -72,14 +72,16 @@ static void intel_lvds_enable(struct intel_lvds *intel_lvds)
>  {
>  	struct drm_device *dev = intel_lvds->base.base.dev;
>  	struct drm_i915_private *dev_priv = dev->dev_private;
> -	u32 ctl_reg, lvds_reg;
> +	u32 ctl_reg, lvds_reg, stat_reg;
>  
>  	if (HAS_PCH_SPLIT(dev)) {
>  		ctl_reg = PCH_PP_CONTROL;
>  		lvds_reg = PCH_LVDS;
> +		stat_reg = PCH_PP_STATUS;
>  	} else {
>  		ctl_reg = PP_CONTROL;
>  		lvds_reg = LVDS;
> +		stat_reg = PP_STATUS;
>  	}
>  
>  	I915_WRITE(lvds_reg, I915_READ(lvds_reg) | LVDS_PORT_EN);
> @@ -105,6 +107,8 @@ static void intel_lvds_enable(struct intel_lvds *intel_lvds)
>  
>  	I915_WRITE(ctl_reg, I915_READ(ctl_reg) | POWER_TARGET_ON);
>  	POSTING_READ(lvds_reg);
> +	if (wait_for((I915_READ(stat_reg) & PP_ON) != 0, 1000))
> +		DRM_ERROR("timed out waiting for panel to power on\n");

Looks like maybe we want a small function for this...

>  	I915_WRITE(ctl_reg, I915_READ(ctl_reg) & ~POWER_TARGET_ON);
> +	if (wait_for((I915_READ(stat_reg) & PP_ON) == 0, 1000))
> +		DRM_ERROR("timed out waiting for panel to power off status 0x%08x control 0x%08x\n",
> +			  I915_READ(PCH_PP_STATUS), I915_READ(PCH_PP_CONTROL));

...to catch places like this where the wrong register gets used. :)


-- 
Jesse Barnes, Intel Open Source Technology Center
