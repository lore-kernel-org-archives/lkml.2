Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab1K2OGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 09:06:53 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49627 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab1K2OGw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 09:06:52 -0500
MIME-Version: 1.0
In-Reply-To: <86k46m8z1s.fsf@sumi.keithp.com>
References: <CACVkyFdhpU1sQb-T-pXYkV8Ot27+LYxV_=FGd=aPLLyrD3-1dg@mail.gmail.com>
	<86k46m8z1s.fsf@sumi.keithp.com>
Date: Tue, 29 Nov 2011 15:06:51 +0100
Message-ID: <CAGPN=9TpFOJ8316faVi8jGzO0-apj-yXkxMQXyApE1=uUmD-AQ@mail.gmail.com>
Subject: Re: drivers/gpu/drm/i915/intel_dp.c problem with commit dc22ee6fc18ce0f15424e753e8473c306ece95c1
From: Patrik Kullman <patrik.kullman@gmail.com>
To: Keith Packard <keith.packard@intel.com>
Cc: Jerker Buud <b.jerker@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I checked out a clean v3.2-rc3, applied this patch and rebooted.

It still doesn't work and Caps Lock still doesn't respond, but I get
very subtle flickering of the screen, 2-3 seconds apart, kind of like
different shades of black.

It 'feels' as if some graphics card/link/monitor negotiation is taking place.

2011/11/26 Keith Packard <keith.packard@intel.com>:
> On Sat, 26 Nov 2011 09:50:41 -0800, Jerker Buud <b.jerker@gmail.com> wrote:
>
>> 245,247c245,246
>> <       if (!is_edp(intel_dp) &&
>> <           (intel_dp_link_required(intel_dp, mode->clock)
>> <            > intel_dp_max_data_rate(max_link_clock, max_lanes)))
>> ---
>> >       if (intel_dp_link_required(intel_dp, mode->clock)
>> >           > intel_dp_max_data_rate(max_link_clock, max_lanes))
>
> Ok, I think I understand why this change is required.
>
> These machines are 'optimized' to provide the bare minimum connection
> necessary between the CPU and the eDP panel -- a single lane is hooked
> up, which is just enough to run the link at 18bpp, but not enough to run
> it at 24bpp.
>
> The problem here (in intel_dp_link_required) is that this is being
> called to see which modes can be supported on the panel. Without the
> CRTC being configured with the appropriate bpp value, this code assumes
> 24bpp.
>
> I thought Adam Jackson had some code around that automatically switched
> From 24bpp to 18bpp when the link didn't have enough bandwidth for
> 24bpp, but I can't find that now.
>
> In any case, I think we need to centralize the bpp selection inside
> intel_dp.c instead of having it in both places. Then, we can make that
> depend on the requested mode as well as the machine configuration.
>
> Here's a patch which uses the VBT configured bpp value in this case. I'd
> love to hear whether this suffices to resolve your problem.
>
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
> index 294f557..3e15479 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -212,10 +212,16 @@ intel_dp_link_required(struct intel_dp *intel_dp, int pixel_clock)
>  {
>        struct drm_crtc *crtc = intel_dp->base.base.crtc;
>        struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
> -       int bpp = 24;
> +       struct drm_device *dev = intel_dp->base.base.dev;
> +       struct drm_i915_private *dev_priv = dev->dev_private;
> +       int bpp;
>
>        if (intel_crtc)
>                bpp = intel_crtc->bpp;
> +       else if (intel_dp->base.type == INTEL_OUTPUT_EDP)
> +               bpp = dev_priv->edp.bpp;
> +       else
> +               bpp = 24;
>
>        return (pixel_clock * bpp + 9) / 10;
>  }
>
> --
> keith.packard@intel.com
