Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab1KFVQN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 16:16:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:24132 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330Ab1KFVQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 16:16:10 -0500
Message-Id: <e0d58a$24a0r5@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="71631717"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 09/13] drm/i915: don't use gtt_pwrite on LLC cached objects
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
In-Reply-To: <1320606840-21132-10-git-send-email-daniel.vetter@ffwll.ch>
References: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch> <1320606840-21132-10-git-send-email-daniel.vetter@ffwll.ch>
Date: Sun, 06 Nov 2011 21:16:00 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  6 Nov 2011 20:13:56 +0100, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> ~120 µs instead fo ~210 µs to write 1mb on my snb. I like this.
> 
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
>  drivers/gpu/drm/i915/i915_gem.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> index 0048917..8fd175c 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -842,6 +842,7 @@ i915_gem_pwrite_ioctl(struct drm_device *dev, void *data,
>  		ret = i915_gem_phys_pwrite(dev, obj, args, file);
>  		goto out;
>  	} else if (obj->gtt_space &&
> +		   obj->cache_level == I915_CACHE_NONE &&
>  		   obj->base.write_domain != I915_GEM_DOMAIN_CPU) {
>  		ret = i915_gem_object_pin(obj, 0, true);
>  		if (ret)

I still think you want to include a obj->map_and_fenceable test here.
When doing 2D benchmarks the stall incurred here to evict an old object
map the to-be-written object into the mappable GTT causes measureable
pain (obviously on non-LLC architectures).

The series looks good and I'll look at the impact upon 2D for pnv and
snb over the next couple of days. With and without the extra check ;-)
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
