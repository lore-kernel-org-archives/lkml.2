Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab1IUS6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 14:58:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59543 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab1IUS6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 14:58:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type;
	b=jECDCDnfzbxLzc3gx6mL6ZsqompdZTgH7+cNGbUjWajwFJuF1KxWgKRQaYLKkauzq
	S5F1QjVs6qUNOhyLengwg==
Date: Wed, 21 Sep 2011 11:56:31 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Keith Packard <keithp@keithp.com>
cc: Francis Moreau <francis.moro@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.1-rc5 is the worst
In-Reply-To: <yun1uvbf7zp.fsf@aiko.keithp.com>
Message-ID: <alpine.LSU.2.00.1109211140170.3200@sister.anvils>
References: <CAC9WiBjoO50H5ZQEShbdZ=64ZXz6Q-OdD+VSD-YrBry3hvdJJQ@mail.gmail.com> <yunbousl9f5.fsf@aiko.keithp.com> <CAC9WiBgn2cr7zY8_9j7SEwQ+rPye9s3cM+Ex4WUxam78qAZhRQ@mail.gmail.com> <yun1uvbf7zp.fsf@aiko.keithp.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011, Keith Packard wrote:
> On Sun, 11 Sep 2011 20:33:14 +0200, Francis Moreau <francis.moro@gmail.com> wrote:
> 
> > Ok this seems to fix the issue.
> 
> I've posted a patch that disables fbc by default on Ironlake machines;
> I'd like to have it tested to make sure it actually does what it's
> supposed to do, and resolves the issue for you without a special kernel
> command line argument. If it does, I'll make sure this lands in 3.1
> 
> From e3d529ddfc9cec12f05e1dde0a0bf0469e15db04 Mon Sep 17 00:00:00 2001
> From: Keith Packard <keithp@keithp.com>
> Date: Mon, 19 Sep 2011 21:34:19 -0700
> Subject: [PATCH] drm/i915: FBC off for ironlake, otherwise on by default
> 
> Make the default FBC behaviour chipset specific, allowing us to turn
> it on by default for everything except Ironlake where it has been
> seen to cause trouble with screen updates.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>

I wonder if you're right to disable it just for INTEL_INFO(dev)->gen == 5.
On this laptop I have INTEL_INFO(dev)->gen == 4, and have had to boot with
i915.i915_enable_fbc=0 since 3.1-rc1 for my xterms to be reliably updated.

An earlier thread on behaviour I get was http://lkml.org/lkml/2011/1/31/97
3.0-rc1 allowed me back to using KMS, but 3.1-rc1 then forced me to switch
fbc off.

Hugh

> ---
>  drivers/gpu/drm/i915/i915_drv.c      |    4 ++--
>  drivers/gpu/drm/i915/intel_display.c |   10 +++++++++-
>  2 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
> index ce045a8..f07e425 100644
> --- a/drivers/gpu/drm/i915/i915_drv.c
> +++ b/drivers/gpu/drm/i915/i915_drv.c
> @@ -67,11 +67,11 @@ module_param_named(i915_enable_rc6, i915_enable_rc6, int, 0600);
>  MODULE_PARM_DESC(i915_enable_rc6,
>  		"Enable power-saving render C-state 6 (default: true)");
>  
> -unsigned int i915_enable_fbc __read_mostly = 1;
> +unsigned int i915_enable_fbc __read_mostly = -1;
>  module_param_named(i915_enable_fbc, i915_enable_fbc, int, 0600);
>  MODULE_PARM_DESC(i915_enable_fbc,
>  		"Enable frame buffer compression for power savings "
> -		"(default: false)");
> +		"(default: -1 (use per-chip default))");
>  
>  unsigned int i915_lvds_downclock __read_mostly = 0;
>  module_param_named(lvds_downclock, i915_lvds_downclock, int, 0400);
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index 9fb4a40..bc05deb 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -1799,6 +1799,7 @@ static void intel_update_fbc(struct drm_device *dev)
>  	struct drm_framebuffer *fb;
>  	struct intel_framebuffer *intel_fb;
>  	struct drm_i915_gem_object *obj;
> +	int enable_fbc;
>  
>  	DRM_DEBUG_KMS("\n");
>  
> @@ -1839,7 +1840,14 @@ static void intel_update_fbc(struct drm_device *dev)
>  	intel_fb = to_intel_framebuffer(fb);
>  	obj = intel_fb->obj;
>  
> -	if (!i915_enable_fbc) {
> +	enable_fbc = i915_enable_fbc;
> +	if (enable_fbc < 0) {
> +		DRM_DEBUG_KMS("fbc set to per-chip default\n");
> +		enable_fbc = 1;
> +		if (INTEL_INFO(dev)->gen == 5)
> +			enable_fbc = 0;
> +	}
> +	if (!enable_fbc) {
>  		DRM_DEBUG_KMS("fbc disabled per module param (default off)\n");
>  		dev_priv->no_fbc_reason = FBC_MODULE_PARAM;
>  		goto out_disable;
> -- 
> 1.7.6.3
> 
> -- 
> keith.packard@intel.com
