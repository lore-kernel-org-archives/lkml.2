Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab1KFWSL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 17:18:11 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51993 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab1KFWSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 17:18:09 -0500
Date: Sun, 6 Nov 2011 23:19:09 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 09/13] drm/i915: don't use gtt_pwrite on LLC cached
 objects
Message-ID: <20111106221909.GC5305@phenom.ffwll.local>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
 <1320606840-21132-10-git-send-email-daniel.vetter@ffwll.ch>
 <e0d58a$24a0r5@orsmga002.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e0d58a$24a0r5@orsmga002.jf.intel.com>
X-Operating-System: Linux phenom 3.1.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 06, 2011 at 09:16:00PM +0000, Chris Wilson wrote:
> On Sun,  6 Nov 2011 20:13:56 +0100, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > ~120 µs instead fo ~210 µs to write 1mb on my snb. I like this.
> > 
> > Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > ---
> >  drivers/gpu/drm/i915/i915_gem.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> > index 0048917..8fd175c 100644
> > --- a/drivers/gpu/drm/i915/i915_gem.c
> > +++ b/drivers/gpu/drm/i915/i915_gem.c
> > @@ -842,6 +842,7 @@ i915_gem_pwrite_ioctl(struct drm_device *dev, void *data,
> >  		ret = i915_gem_phys_pwrite(dev, obj, args, file);
> >  		goto out;
> >  	} else if (obj->gtt_space &&
> > +		   obj->cache_level == I915_CACHE_NONE &&
> >  		   obj->base.write_domain != I915_GEM_DOMAIN_CPU) {
> >  		ret = i915_gem_object_pin(obj, 0, true);
> >  		if (ret)
> 
> I still think you want to include a obj->map_and_fenceable test here.
> When doing 2D benchmarks the stall incurred here to evict an old object
> map the to-be-written object into the mappable GTT causes measureable
> pain (obviously on non-LLC architectures).

That's one of "further tricks". I think we need to also implement the same
in-place clflush trick like for pread, too, to avoid penalizing partial
pwrites too much.

The other trick is to do reloc fixups through llc/clflushed cpu writes.
This way we'd completely eliminate mappable pressure for all untiled
objects. The only thing left would be scanout, tiled gtt uploads and tiled
blts (only on pre-gen4).
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
