Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858Ab2GYIqC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 04:46:02 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60969 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932748Ab2GYIp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 04:45:58 -0400
Date: Wed, 25 Jul 2012 10:46:05 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PULL] drm-intel-fixes for 3.6
Message-ID: <20120725084605.GC5396@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20120725081733.GA5396@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120725081733.GA5396@phenom.ffwll.local>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 10:17:33AM +0200, Daniel Vetter wrote:
> Hi Dave,
> 
> First pile of fixes for 3.6 already, and I'm afraid it's a bit larger than
> what I'd wish for. But I've moved all the feature-y stuff to -next, so
> this really is all -fixes. Most of it is handling fallout from the hw
> context stuff, discovered now that mesa git has started using them for
> real. Otherwise all just small fixes:
> - unbreak modeset=0 on gen6+ (regressed in next)
> - const mismatch fix for ->mode_fixup
> - simplify overly clever lvds modeset code (current code can totally
>   confuse backlights, resulting in broken panels until a full power draw
>   restores them).
> - fix some fallout from the flushing_list disabling (regression only
>   introduced in -next)
> - DP link train improvements (this also kills the last 3.2 dp regression
>   afaik)
> - bugfix for the new ddc VGA detection on newer platforms
> - minor backlight fixes (one of them a -next regression)
> - only enable the required PM interrupts (to avoid waking up the cpu
>   unnecessarily)
> - some really minor bits (workaround clarification, make coverty happy,
>   hsw init fix)
> 
> Fyi I'll be on vacation next week, so you need to yell at someone else if
> stuff blows up ;-) But with this -fixes pile I'm not aware of any issues
> in the patches for 3.6, so I don't expect anything to blow up ...

I've just noticed that one of the issues QA reported yesterday on the
first 3.7 patches testing round is caused by one of the patches in here
(I've thought preliminary triaging by them said that it works in -fixes,
but alas). It's a rather nasty issue around rc6 wake-ups on snb, and the
offending patch already tried to work around a much rarer, but similar
issue (but only affecting the video decoding ring).

I guess this will take us 1-2 days to sort out, so for now I've just taken
out the offending patch, new pull request below.

Yours, Daniel


The following changes since commit 83bc5fd29afff5898cadf87fb29eb9260eecc63e:

  drm/sis: fixup sis_mm ioctl structs (2012-07-19 22:51:58 -0400)

are available in the git repository at:

  git://people.freedesktop.org/~danvet/drm-intel drm-intel-fixes

for you to fetch changes up to e8aeaee7b012f1cdb382765d17307445385aa87c:

  drm/i915: unbreak lastclose for failed driver init (2012-07-25 10:40:00 +0200)

----------------------------------------------------------------
Ander Conselvan de Oliveira (1):
      drm/i915: mask tiled bit when updating ILK sprites

Ben Widawsky (3):
      drm/i915/context/: s/CTX/CXT
      drm/i915/context: Add missing IVB context sizes
      drm/i915: missing error case in init status page

Chris Wilson (8):
      drm/i915: Only request PM interrupts for the events we handled
      drm/i915: Disable the BLT on pre-production SNB hardware
      drm/i915: Add comments to explain the BSD tail write workaround
      drm/i915: Insert a flush between batches if the breadcrumb was dropped
      drm/i915: Make the lock for pageflips interruptible
      drm/i915: Flush the context object from the CPU caches upon switching
      drm/i915: Add -EIO to the list of known errors for __wait_seqno
      drm/i915: fix invalid reference handling of the default ctx obj

Dan Carpenter (1):
      drm/i915: dereferencing an error pointer

Daniel Vetter (6):
      drm/i915: fix up PCH backlight #define mixup
      drm/i915: check whether we actually received an edid in detect_ddc
      drm/i915: kill intel_ddc_probe
      drm/i915/lvds: ditch ->prepare special case
      drm/i915: constify mode in crtc_mode_fixup
      drm/i915: unbreak lastclose for failed driver init

Eric Anholt (1):
      drm/i915: Set the context before setting up regs for the context.

Eugeni Dodonov (1):
      drm/i915: initialize power wells in modeset_init_hw

Paulo Zanoni (2):
      drm/i915: try to train DP even harder
      drm/i915: don't forget the PCH backlight registers

 drivers/gpu/drm/i915/i915_debugfs.c        |    1 +
 drivers/gpu/drm/i915/i915_dma.c            |    8 +++++-
 drivers/gpu/drm/i915/i915_drv.h            |    1 +
 drivers/gpu/drm/i915/i915_gem.c            |   19 +++++++++++++-
 drivers/gpu/drm/i915/i915_gem_context.c    |   37 +++++++++++++++-------------
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   17 ++++++++-----
 drivers/gpu/drm/i915/i915_irq.c            |    1 +
 drivers/gpu/drm/i915/i915_reg.h            |   32 +++++++++++++-----------
 drivers/gpu/drm/i915/intel_crt.c           |   33 +++++++++++--------------
 drivers/gpu/drm/i915/intel_display.c       |   12 +++++++--
 drivers/gpu/drm/i915/intel_dp.c            |    2 +-
 drivers/gpu/drm/i915/intel_drv.h           |    2 +-
 drivers/gpu/drm/i915/intel_lvds.c          |    8 +-----
 drivers/gpu/drm/i915/intel_modes.c         |   28 ---------------------
 drivers/gpu/drm/i915/intel_panel.c         |   15 ++++++++++-
 drivers/gpu/drm/i915/intel_pm.c            |   14 +----------
 drivers/gpu/drm/i915/intel_ringbuffer.c    |   28 +++++++++++++++------
 drivers/gpu/drm/i915/intel_sprite.c        |    1 +
 18 files changed, 140 insertions(+), 119 deletions(-)
> 
> Yours, Daniel
> 
> The following changes since commit 83bc5fd29afff5898cadf87fb29eb9260eecc63e:
> 
>   drm/sis: fixup sis_mm ioctl structs (2012-07-19 22:51:58 -0400)
> 
> are available in the git repository at:
> 
>   git://people.freedesktop.org/~danvet/drm-intel drm-intel-fixes
> 
> for you to fetch changes up to 18e0a7dd17db91c207f3d37f1e409c48fe02663e:
> 
>   drm/i915: unbreak lastclose for failed driver init (2012-07-23 22:34:29 +0200)
> 
> ----------------------------------------------------------------
> Ander Conselvan de Oliveira (1):
>       drm/i915: mask tiled bit when updating ILK sprites
> 
> Ben Widawsky (3):
>       drm/i915/context/: s/CTX/CXT
>       drm/i915/context: Add missing IVB context sizes
>       drm/i915: missing error case in init status page
> 
> Chris Wilson (9):
>       drm/i915: Only request PM interrupts for the events we handled
>       drm/i915: Disable the BLT on pre-production SNB hardware
>       drm/i915: Add comments to explain the BSD tail write workaround
>       drm/i915: Insert a flush between batches if the breadcrumb was dropped
>       drm/i915: Make the lock for pageflips interruptible
>       drm/i915: Workaround hang with BSD and forcewake on SandyBridge
>       drm/i915: Flush the context object from the CPU caches upon switching
>       drm/i915: Add -EIO to the list of known errors for __wait_seqno
>       drm/i915: fix invalid reference handling of the default ctx obj
> 
> Dan Carpenter (1):
>       drm/i915: dereferencing an error pointer
> 
> Daniel Vetter (6):
>       drm/i915: fix up PCH backlight #define mixup
>       drm/i915: check whether we actually received an edid in detect_ddc
>       drm/i915: kill intel_ddc_probe
>       drm/i915/lvds: ditch ->prepare special case
>       drm/i915: constify mode in crtc_mode_fixup
>       drm/i915: unbreak lastclose for failed driver init
> 
> Eric Anholt (1):
>       drm/i915: Set the context before setting up regs for the context.
> 
> Eugeni Dodonov (1):
>       drm/i915: initialize power wells in modeset_init_hw
> 
> Paulo Zanoni (2):
>       drm/i915: try to train DP even harder
>       drm/i915: don't forget the PCH backlight registers
> 
>  drivers/gpu/drm/i915/i915_debugfs.c        |    1 +
>  drivers/gpu/drm/i915/i915_dma.c            |    8 +++++-
>  drivers/gpu/drm/i915/i915_drv.h            |    1 +
>  drivers/gpu/drm/i915/i915_gem.c            |   19 +++++++++++++-
>  drivers/gpu/drm/i915/i915_gem_context.c    |   37 +++++++++++++++-------------
>  drivers/gpu/drm/i915/i915_gem_execbuffer.c |   17 ++++++++-----
>  drivers/gpu/drm/i915/i915_irq.c            |    1 +
>  drivers/gpu/drm/i915/i915_reg.h            |   32 +++++++++++++-----------
>  drivers/gpu/drm/i915/intel_crt.c           |   33 +++++++++++--------------
>  drivers/gpu/drm/i915/intel_display.c       |   12 +++++++--
>  drivers/gpu/drm/i915/intel_dp.c            |    2 +-
>  drivers/gpu/drm/i915/intel_drv.h           |   21 ++++++++--------
>  drivers/gpu/drm/i915/intel_lvds.c          |    8 +-----
>  drivers/gpu/drm/i915/intel_modes.c         |   28 ---------------------
>  drivers/gpu/drm/i915/intel_panel.c         |   15 ++++++++++-
>  drivers/gpu/drm/i915/intel_pm.c            |   14 +----------
>  drivers/gpu/drm/i915/intel_ringbuffer.c    |   28 +++++++++++++++------
>  drivers/gpu/drm/i915/intel_sprite.c        |    1 +
>  18 files changed, 150 insertions(+), 128 deletions(-)
> -- 
> Daniel Vetter
> Mail: daniel@ffwll.ch
> Mobile: +41 (0)79 365 57 48

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
