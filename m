Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab1GZQjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 12:39:01 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:33189 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753719Ab1GZQiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 12:38:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=hzpiCDGCnB+q14LVsH06yTi9ga+V0g7/lT8w+GoZWwXRRh5tr1CVpe/n7rxi9uF5wrAGnWxcRX+mp7aaDT3wCpxWQuEHI5nT+AXdMN+hPCD68U7xF0uFLhb7WTF/8GPr;
Date: Tue, 26 Jul 2011 09:38:46 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 3/5] drm/i915: In intel_dp_init, replace
 read of DPCD with intel_dp_get_dpcd
Message-ID: <20110726093846.58e2c9f1@jbarnes-desktop>
In-Reply-To: <1311662194-4050-4-git-send-email-keithp@keithp.com>
References: <1311662194-4050-1-git-send-email-keithp@keithp.com>
	<1311662194-4050-4-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jul 2011 23:36:32 -0700
Keith Packard <keithp@keithp.com> wrote:

> Eliminates an open-coded read and also gains the retry behaviour of
> intel_dp_get_dpcd, which seems like a good idea.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/intel_dp.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
> index 41674e1..9f134d2 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -2015,7 +2015,7 @@ intel_dp_init(struct drm_device *dev, int output_reg)
>  
>  	/* Cache some DPCD data in the eDP case */
>  	if (is_edp(intel_dp)) {
> -		int ret;
> +		bool ret;
>  		u32 pp_on, pp_div;
>  
>  		pp_on = I915_READ(PCH_PP_ON_DELAYS);
> @@ -2028,11 +2028,9 @@ intel_dp_init(struct drm_device *dev, int output_reg)
>  		dev_priv->panel_t12 *= 100; /* t12 in 100ms units */
>  
>  		ironlake_edp_panel_vdd_on(intel_dp);
> -		ret = intel_dp_aux_native_read(intel_dp, DP_DPCD_REV,
> -					       intel_dp->dpcd,
> -					       sizeof(intel_dp->dpcd));
> +		ret = intel_dp_get_dpcd(intel_dp);
>  		ironlake_edp_panel_vdd_off(intel_dp);
> -		if (ret == sizeof(intel_dp->dpcd)) {
> +		if (ret) {
>  			if (intel_dp->dpcd[DP_DPCD_REV] >= 0x11)
>  				dev_priv->no_aux_handshake =
>  					intel_dp->dpcd[DP_MAX_DOWNSPREAD] &

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Now we just have to enable fast link training in the eDP case (and
optionally when we know the DP monitor hasn't changed, just DPMS'd).

-- 
Jesse Barnes, Intel Open Source Technology Center
