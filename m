Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab1JCUsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 16:48:36 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:34745 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755033Ab1JCUsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:48:30 -0400
Date: Mon, 3 Oct 2011 13:48:18 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 05/21] drm/i915: Check eDP power when doing
 aux channel communications
Message-ID: <20111003134818.0ef811ce@jbarnes-desktop>
In-Reply-To: <1317344993-24945-6-git-send-email-keithp@keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
	<1317344993-24945-1-git-send-email-keithp@keithp.com>
	<1317344993-24945-6-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Sep 2011 18:09:37 -0700
Keith Packard <keithp@keithp.com> wrote:

> Verify that the eDP VDD is on, either with the panel being on or with
> the VDD force-on bit being set.
> 
> This demonstrates that in many instances, VDD is not on when needed,
> which leads to failed EDID communications.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/intel_dp.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
> index 8ab2a88..3b29a6f 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -279,6 +279,24 @@ intel_hrawclk(struct drm_device *dev)
>  	}
>  }
>  
> +static void
> +intel_dp_check_edp(struct intel_dp *intel_dp)
> +{
> +	struct drm_device *dev = intel_dp->base.base.dev;
> +	struct drm_i915_private *dev_priv = dev->dev_private;
> +	u32 pp_status, pp_control;
> +	if (!is_edp(intel_dp))
> +		return;
> +	pp_status = I915_READ(PCH_PP_STATUS);
> +	pp_control = I915_READ(PCH_PP_CONTROL);
> +	if ((pp_status & PP_ON) == 0 && (pp_control & EDP_FORCE_VDD) == 0) {
> +		WARN(1, "eDP powered off while attempting aux channel communication.\n");
> +		DRM_DEBUG_KMS("Status 0x%08x Control 0x%08x\n",
> +			      pp_status,
> +			      I915_READ(PCH_PP_CONTROL));
> +	}
> +}

I'd call it "intel_dp_assert_dp_power" or something more descriptive
(or just assert_panel_power to match the other asserts in
intel_display.c), but other than that this is a nice sanity check.

-- 
Jesse Barnes, Intel Open Source Technology Center
