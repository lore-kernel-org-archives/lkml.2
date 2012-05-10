Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591Ab2EJNy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 09:54:58 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45296 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759574Ab2EJNyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 09:54:53 -0400
Date: Thu, 10 May 2012 15:55:56 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Dave Airlie <airlied@gmail.com>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] drm-intel-next
Message-ID: <20120510135556.GA4912@phenom.ffwll.local>
Mail-Followup-To: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	Dave Airlie <airlied@gmail.com>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20120506190931.GD4756@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120506190931.GD4756@phenom.ffwll.local>
X-Operating-System: Linux phenom 3.4.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

New drm-intel-next pull request.
Highlights:
- sparse fixes from Ben.
- tons of little cleanups from Chris all over: tiling_changed
  clarification, deferred_free list removal, ...
- fix up irq handler on gen2 & gen3 + related cleanups from Chris
- prep work for wait_rendering_timeout from Ben with some nice
  refactorings
- first set of infoframe fixes from Paulo for doubleclocked CEA modes
- improve pch pll handling from Jesse and Chris
- gpu hangman, this also contains the reset fix for gen4
- rps sanity check from Chris - this papers over issues when the gpu fails
  to clock up on snb/ivb, and it is shockingly easy to hit. The code
  prints a big WARN backtrace and restores the hw to a sane state. The
  real fix is still in the works.

Atm I'm aware of 2 regressions in -next:
- One of the gmbus patches (not gmbus itself) regressed lvds detection on
  a MacbookPro. I've analyzed the bug already and I think I know what's
  going on, patch is awaiting test feedback.
- Just today QA reported that DP on ilk regressed. That bug is fresh of
  the press and still awaiting detailed logfiles and the bisect result.
  The only thing that's clear atm is that -fixes works and -next doesn't.

Otherwise 3.5 merge is winding down, I am queueing up a few things though
that I'd like to still sneak in:
- More infoframe fixes from Paulo (most already queued into my tree).
- Final pieces of the first cut at hsw support from Eugeni - all the
  invasive pieces and code rework has landed already so not much harm
  there.
- I'm working on some backlight fixes I'd like to land in 3.5, but not yet
  all ready.

As discussed on irc this pull request is for the merged branch which
already resolves the conflicts with drm-next (due to the -rc6 backmerge).

Yours, Daniel

The following changes since commit 4f256e8aa3eda15c11c3cec3ec5336e1fc579cbd:

  Merge branch 'for-airlied' of git://people.freedesktop.org/~danvet/drm-intel into drm-core-next (2012-05-07 16:09:35 +0100)

are available in the git repository at:


  git://people.freedesktop.org/~danvet/drm-intel tags/drm-intel-next-2012-05-06-merged

for you to fetch changes up to 5e13a0c5ec05d382b488a691dfb8af015b1dea1e:

  Merge remote-tracking branch 'airlied/drm-core-next' into drm-intel-next-queued (2012-05-08 13:39:59 +0200)

----------------------------------------------------------------

Ben Widawsky (11):
      drm/i915: [sparse] __iomem fixes for opregion
      drm/i915: [sparse] __iomem fixes for overlay
      drm/i915: [sparse] __iomem fixes for gem
      drm/i915: remove do_retire from i915_wait_request
      drm/i915: move vbetool invoked ier stuff
      drm/i915: kill waiting_seqno
      drm/i915: drop polled waits from i915_wait_request
      drm/i915: extract __wait_seqno from i915_wait_request
      drm/i915: remove polled wait from throttle
      drm/i915: use __wait_seqno for ring throttle
      drm/i915: extract some common olr+wedge code

Chris Wilson (32):
      drm/i915/sprite: Avoid incurring extra vblank stall when updating plane on IVB
      drm/i915: Remove i915_gem_ringbuffer_(data|info) from debugfs
      drm/i915: Clarify the semantics of tiling_changed
      drm/i915: Only the zap the VMA after updating the tiling parameters
      drm/i915: i8xx interrupt handler
      drm/i915: Use a global lock for modifying global irq flags
      drm/i915: Remove too early plane enable on pre-PCH hardware
      drm/i915: Bump the inactive LRU on set-to-GTT-domain
      drm/i915: Remove i915_gem_evict_inactive()
      drm/i915: Remove the list of pinned inactive objects
      drm/i915: Remove the deferred-free list
      drm/i915: Split the stolen handling for GEM out of i915_dma.c
      drm/i915: Move GEM initialisation from i915_dma.c to i915_gem.c
      drm/i915: CR clock gating is recommend to be set on PineView
      drm/i915: Unconditionally initialise the interrupt workers
      drm/i915: Remove redundant initialisation of per-ring IRQ waitqueues
      drm/i915: pending_flip_is_done is gen3, name it so
      drm/i915: Duplicate and split the gen3/4 irq handler
      drm/i915: Clear FlipDone semantics change for pageflipping on gen3
      drm/i915: Remove gen3 irq code from gen4 irq routine
      drm/i915: Remove gen4 irq code from gen3 irq routine
      drm/i915: HWSTAM is only 16-bit on gen3
      drm/i915: Cleanup gen3 irq uninstall
      drm/i915: Handle PendingFlip on gen3 robustly
      drm/i915: Inline I915_INTERRUPT_ENABLE_FIX
      drm/i915: Remove unused and unloved vblank macros
      drm/i915: Remove unused ring->irq_seqno
      drm/i915: Only enable IPS polling for gen5
      drm/i915: Remove unused dev_priv->vblank_pipe
      drm/i915: Wait for the clocks to stabilise before updating PLLs
      drm/i915: Periodically sanity check power management
      drm/i915: Support pageflipping interrupts for all 3-pipes on IVB

Daniel Vetter (43):
      drm/i915: print computed bpp in dp link configuration
      drm/i915: [sparse] __iomem fixes for debugfs
      drm/i915: re-add static qualifier to get_cxsr_latency
      drm/i915: fixup tv load-detect on enabled but not active crtc
      drm/i915: create macros to handle masked bits
      drm/i915: implement Disable4x2SubspanOptimization w/a for ivb, too
      drm/i915: properly check for MODESET for kms driver ioctls
      drm/i915: disallow gem ums init ioctl for kms
      drm/i915: rip out GEM drm feature checks
      drm/i915: rip out dev_priv->has_gem
      drm/i915: check for kms in dri1 ioctls
      drm/i915: use the new masked bit macro some more
      drm/i915: move dri1 vblank stubs to i915_dma.c
      drm/i915: create dev_priv->dri1 dragon dungeon^W^W sub-struct
      drm/i915 disallow physical batchbuffers for KMS
      drm/i915: rip out dev_priv->tex_lru_log_granularity
      drm/i915: remove LP_RING&friends from modeset code
      drm/i915: kill intel_clear_scanline_wait
      drm/i915: rip out dri1 breadcrumb updates from gen5+ irq handlers
      drm/i915: move dri1 irq ioctl code to i915_dma.c
      drm/i915: extract dri1 breadcrumb update from irq handler
      drm/i915: move LP_RING&friends to i915_dma.c
      drm/i915: disallow clip rects on gen5+
      drm/i915: move the ips code to intel_pm.c
      drm/i915: move rps/emon function declarations
      drm/i915: kill pointless clearing of dev_priv->hws_map
      drm/i915: rework legacy GFX HWS handling
      drm/i915: fixup __iomem mixups in ringbuffer.c
      drm/i915: move pnv|ilk_gem_mem_freq to intel_pm.c
      drm/i915: rip out intel_dpio_write again
      drm/i915: rip out unnecessary calls to drm_mode_set_crtcinfo
      drm/i915: use mode values consistently when converting to sdvo dtd
      drm/i915: add interface to simulate gpu hangs
      drm/i915: rework dev->first_error locking
      drm/i915: allow the existing error_state to be destroyed
      drm/i915: simplify i915_reset a bit
      drm/i915: extract intel_gpu_reset
      drm/i915: make gpu hangman more resilient
      drm/i915: kill flags parameter for reset functions
      drm/i915: also reset the media engine on gen4/5
      drm/i915: remove modeset reset from i915_reset
      drm/i915: fix gen4 gpu reset
      Merge remote-tracking branch 'airlied/drm-core-next' into drm-intel-next-queued

Jesse Barnes (1):
      drm/i915: manage PCH PLLs separately from pipes

Paulo Zanoni (2):
      drm/i915: rename AVI InfoFrame field 'PR' to 'YQ_CN_PR'
      drm/i915: make DBLCLK modes work

 drivers/gpu/drm/i915/Makefile              |    1 +
 drivers/gpu/drm/i915/i915_debugfs.c        |  270 ++++---
 drivers/gpu/drm/i915/i915_dma.c            | 1076 ++++++--------------------
 drivers/gpu/drm/i915/i915_drv.c            |  132 ++--
 drivers/gpu/drm/i915/i915_drv.h            |  122 ++-
 drivers/gpu/drm/i915/i915_gem.c            |  434 +++++------
 drivers/gpu/drm/i915/i915_gem_debug.c      |   16 -
 drivers/gpu/drm/i915/i915_gem_evict.c      |   42 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    9 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c        |    2 +-
 drivers/gpu/drm/i915/i915_gem_stolen.c     |  202 +++++
 drivers/gpu/drm/i915/i915_gem_tiling.c     |   18 +-
 drivers/gpu/drm/i915/i915_irq.c            | 1136 ++++++++++++++++------------
 drivers/gpu/drm/i915/i915_reg.h            |   24 +-
 drivers/gpu/drm/i915/i915_suspend.c        |    2 +-
 drivers/gpu/drm/i915/intel_display.c       |  413 ++++++----
 drivers/gpu/drm/i915/intel_dp.c            |   19 +-
 drivers/gpu/drm/i915/intel_drv.h           |   24 +-
 drivers/gpu/drm/i915/intel_hdmi.c          |    8 +-
 drivers/gpu/drm/i915/intel_opregion.c      |   67 +-
 drivers/gpu/drm/i915/intel_overlay.c       |  209 ++---
 drivers/gpu/drm/i915/intel_pm.c            |  675 ++++++++++++++++-
 drivers/gpu/drm/i915/intel_ringbuffer.c    |  170 +++--
 drivers/gpu/drm/i915/intel_ringbuffer.h    |   15 +-
 drivers/gpu/drm/i915/intel_sdvo.c          |   19 +-
 drivers/gpu/drm/i915/intel_sprite.c        |   29 +-
 drivers/gpu/drm/i915/intel_tv.c            |    5 +-
 27 files changed, 2882 insertions(+), 2257 deletions(-)
 create mode 100644 drivers/gpu/drm/i915/i915_gem_stolen.c
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
