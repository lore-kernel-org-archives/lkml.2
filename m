Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab1BSSeG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 13:34:06 -0500
Received: from cable-static-49-187.intergga.ch ([157.161.49.187]:56348 "EHLO
	mail.ffwll.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541Ab1BSSeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 13:34:02 -0500
X-Greylist: delayed 509 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Feb 2011 13:34:01 EST
X-Spam-ASN: 
X-Spam-Spammy: 
X-Spam-Hammy: 0.000-+--H*Ad:U*dri-devel, 0.000-+--HCc:D*freedesktop.org,
	0.000-+--HCc:D*lists.freedesktop.org
Date: Sat, 19 Feb 2011 19:25:11 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Indan Zupancic <indan@nul.nu>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: [BUG] drm/i915 Screen corruption introduced by
 a00b10c360b35d6431a94cb
Message-ID: <20110219182511.GA3977@viiv.ffwll.ch>
Mail-Followup-To: Indan Zupancic <indan@nul.nu>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <3f9bbd0924f54f6241cc16293fbcbbb4.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <3f9bbd0924f54f6241cc16293fbcbbb4.squirrel@webmail.greenhost.nl>
X-Operating-System: Linux viiv 2.6.38-rc5-00035-g3077686 
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Indan,

Please provide the usual details about your system (especially what gpu
this is on). Also, screenshots of what typical corruptions look like can
help a lot in tracking down such things.

I've created two quick patches to check a few theories, please test them
(both patches independently and both together). Patches attached.

Yours, Daniel

On Sat, Feb 19, 2011 at 06:58:06AM +0100, Indan Zupancic wrote:
> Hello,
> 
> Since 2.6.38-rc I get screen corruption (mostly horizontal grabage stripes on
> the right side of the screen). After a long time bisecting the offending commit
> ends up being:
> 
> commit a00b10c360b35d6431a94cbf130a4e162870d661
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Fri Sep 24 21:15:47 2010 +0100
> 
>     drm/i915: Only enforce fence limits inside the GTT.
> 
>     So long as we adhere to the fence registers rules for alignment and no
>     overlaps (including with unfenced accesses to linear memory) and account
>     for the tiled access in our size allocation, we do not have to allocate
>     the full fenced region for the object. This allows us to fight the bloat
>     tiling imposed on pre-i965 chipsets and frees up RAM for real use. [Inside
>     the GTT we still suffer the additional alignment constraints, so it doesn't
>     magic allow us to render larger scenes without stalls -- we need the
>     expanded GTT and fence pipelining to overcome those...]
> 
>     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> 
> This commit caused other problems too, which Daniel tried to fix with commits:
> 
> 5e78330126e23e00950 drm/i915: fix relaxed tiling for gen <= 3 && !g33
> 75e9e9158f38e5cb21e drm/i915: kill mappable/fenceable disdinction
> 818f2a3cc34b0673dcc drm/i915: revert pageflip/mappable related abi breakage
> 
> But those don't fix my screen corruption.
> 
> Unfortunately, it's a big commit and it doesn't revert cleanly, and its size
> makes it unclear what the source of the problem is. Daniel's commits don't
> revert cleanly either, so reverting all of them didn't work.
> 
> I'll start poking at it and see if I can find anything.
> 
> Greetings,
> 
> Indan
> 
> 

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

--k1lZvvs/B4yU6o8G
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="for-indan-1.patch"

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index cf4f74c..2e6b532 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1404,6 +1404,8 @@ i915_gem_get_unfenced_gtt_alignment(struct drm_i915_gem_object *obj)
 	struct drm_device *dev = obj->base.dev;
 	int tile_height;
 
+	return i915_gem_get_gtt_alignment(obj);
+
 	/*
 	 * Minimum alignment is 4k (GTT page size) for sane hw.
 	 */

--k1lZvvs/B4yU6o8G
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="for-indan-2.patch"

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 17bd766..fbc21e3 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -763,7 +763,7 @@ static int i915_getparam(struct drm_device *dev, void *data,
 		value = HAS_BLT(dev);
 		break;
 	case I915_PARAM_HAS_RELAXED_FENCING:
-		value = 1;
+		value = 0;
 		break;
 	case I915_PARAM_HAS_COHERENT_RINGS:
 		value = 1;

--k1lZvvs/B4yU6o8G--
