Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab2IXLcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 07:32:09 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43113 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab2IXLcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 07:32:05 -0400
Date: Mon, 24 Sep 2012 13:31:54 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dave Airlie <airlied@linux.ie>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Wang Xingchao <xingchao.wang@intel.com>
Subject: Re: linux-next: build failure after merge of the drm tree
Message-ID: <20120924113137.GA3824@bremse>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Dave Airlie <airlied@linux.ie>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wang Xingchao <xingchao.wang@intel.com>
References: <20120924131834.348fa5e6ecfa48521391ea62@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120924131834.348fa5e6ecfa48521391ea62@canb.auug.org.au>
X-Operating-System: Linux bremse 3.6.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 01:18:34PM +1000, Stephen Rothwell wrote:
> Hi Dave,
> 
> After merging the drm tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/gpu/drm/i915/intel_hdmi.c: In function 'intel_enable_hdmi':
> drivers/gpu/drm/i915/intel_hdmi.c:633:31: error: 'mode' undeclared (first use in this function)
> 
> Caused by commit b98b60167279 ("drm/i915: HDMI - Clear Audio Enable bit
> for Hot Plug") from Linus' tree interacting with commit 5ab432ef4997
> ("drm/i915/hdmi: convert to encoder->disable/enable") from the drm tree.
> 
> I added the following merge fix patch (which may be wrong, of course):
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 24 Sep 2012 13:14:40 +1000
> Subject: [PATCH] drm/i915: HDMI: update for API change
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Looks good. I've known about this issue and tried to improve matters by
applying the patch to both trees (to at least force a conflict), but not
even with that patch applied in my drm-intel-next queue I get a proper
conflict. I guess I need to do a proper backmerge.

Fixup patch looks good for now.

Thanks, Daniel

> ---
>  drivers/gpu/drm/i915/intel_hdmi.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_hdmi.c b/drivers/gpu/drm/i915/intel_hdmi.c
> index 2ec9c76..d39ed58 100644
> --- a/drivers/gpu/drm/i915/intel_hdmi.c
> +++ b/drivers/gpu/drm/i915/intel_hdmi.c
> @@ -630,7 +630,7 @@ static void intel_enable_hdmi(struct intel_encoder *encoder)
>  	u32 temp;
>  	u32 enable_bits = SDVO_ENABLE;
>  
> -	if (intel_hdmi->has_audio || mode != DRM_MODE_DPMS_ON)
> +	if (intel_hdmi->has_audio)
>  		enable_bits |= SDVO_AUDIO_ENABLE;
>  
>  	temp = I915_READ(intel_hdmi->sdvox_reg);
> @@ -676,8 +676,7 @@ static void intel_disable_hdmi(struct intel_encoder *encoder)
>  	u32 temp;
>  	u32 enable_bits = SDVO_ENABLE;
>  
> -	if (intel_hdmi->has_audio)
> -		enable_bits |= SDVO_AUDIO_ENABLE;
> +	enable_bits |= SDVO_AUDIO_ENABLE;
>  
>  	temp = I915_READ(intel_hdmi->sdvox_reg);
>  
> -- 
> 1.7.10.280.gaa39
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
