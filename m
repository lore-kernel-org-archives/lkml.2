Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab2CZPTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:19:30 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41170 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab2CZPT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:19:29 -0400
Date: Mon, 26 Mar 2012 17:20:11 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 04/11 v3] drm/i915/intel_i2c: cleanup gmbus/gpio pin
 assignments
Message-ID: <20120326152011.GT4014@phenom.ffwll.local>
Mail-Followup-To: Daniel Kurtz <djkurtz@chromium.org>,
	Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Benson Leung <bleung@chromium.org>,
	Yufeng Shen <miletus@chromium.org>
References: <1332772010-19619-1-git-send-email-djkurtz@chromium.org>
 <1332772010-19619-5-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332772010-19619-5-git-send-email-djkurtz@chromium.org>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 10:26:43PM +0800, Daniel Kurtz wrote:
> There is no GMBUS "disabled" port 0, nor "reserved" port 7.
> For the other 6 ports there is a fixed 1:1 mapping between pin pairs and
> gmbus ports, which means every real gmbus port has a gpio pin.
> 
> Given these realizations, clean up gmbus initialization.
> 
> Tested on Sandybridge (gen 6, PCH == CougarPoint) hardware.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/gpu/drm/i915/i915_drv.h  |    1 -
>  drivers/gpu/drm/i915/i915_reg.h  |    2 +-
>  drivers/gpu/drm/i915/intel_i2c.c |   63 ++++++++++++++-----------------------
>  3 files changed, 25 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
> @@ -370,16 +365,6 @@ static const struct i2c_algorithm gmbus_algorithm = {
>   */
>  int intel_setup_gmbus(struct drm_device *dev)
>  {
> -	static const char *names[GMBUS_NUM_PORTS] = {
> -		"disabled",
> -		"ssc",
> -		"vga",
> -		"panel",
> -		"dpc",
> -		"dpb",
> -		"dpd",
> -		"reserved",
> -	};
>  	struct drm_i915_private *dev_priv = dev->dev_private;
>  	int ret, i;
>  
> @@ -397,13 +382,14 @@ int intel_setup_gmbus(struct drm_device *dev)
>  
>  	for (i = 0; i < GMBUS_NUM_PORTS; i++) {
>  		struct intel_gmbus *bus = &dev_priv->gmbus[i];
> +		u32 port = i + 1; /* +1 to map gmbus index to pin pair */

On reconsideration you move around gmbus ports here, which will break
things horribly. I've wondered a bit how that could possible work and
noticed that you fix things up in the a later patch when introducing
get_adapter.

This ordering breaks bisecting is a complete no-go. If you want to do this
(I still think the refactor is nice) you need to introduce get_adapter
first, then change the meaning of the array index in this patch while
adjusting the lookup in the new get_adapter function.

Yours, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
