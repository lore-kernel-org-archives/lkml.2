Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab2ETT7O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 15:59:14 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64233 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab2ETT7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 15:59:12 -0400
Date: Sun, 20 May 2012 22:00:26 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: "Sun, Yi" <yi.sun@intel.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] last drm-intel-next for 3.5
Message-ID: <20120520200026.GA17948@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	"Sun, Yi" <yi.sun@intel.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux phenom 3.4.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

The last pull I'd like to squeeze into 3.5, safe for the hsw stuff mostly
bugfixes:
- last few patches for basic hsw enabling (Eugeni, infoframe support by
  Paulo)
- Fix up infoframe support, we've hopefully squashed all the cargo-culting
  in there (Paulo). Among all the issues, this finally fixes some of the
  infoframe regressions seen on g4x and snb systems.
- Fixup sdvo infoframe support, this fixes a regression from 2.6.37.
- Correctly enable semaphores on snb, we've enabled it already for 3.5,
  but the dmar check was slightly wrong.
- gen6 irq fixlets from Chris.
- disable gmbus on i830, the hw seems to be simply broken.
- fix up the pch pll fallout (Chris & me).
- for_each_ring macro from Chris - I've figured I'll merge this now to
  avoid backport pain.
- complain when the rps state isn't what we expect (Chris). Note that this
  is shockingly easy to hit and hence pretty much will cause a regression
  report. But it only tells us that the gpu turbo state got out of whack,
  a problem we know off since a long time (it cause the gpu to get stuck a
  a fixed frequency, usually the lowest one). Chris is working on a fix,
  but we haven't yet found a magic formula that works perfectly (only
  patches that massively reduce the frequency of this happening).
- MAINTAINERS patch, I'm now officially the guy to beat up.

Wrt regressions in 3.5, we have the same two issues open:
- a gmbus patch regressed lvds detection on a Macbook Pro. We have a
  tested patch, but Daniel Kurtz proposed an improved fix. That one is
  awaiting test feedback from the reporter currently.
- the dp failure on ilk turned out to be due to the pch pll patch. Chris
  and me fixed this up, but we haven't yet gotten confirmation from QA
  that it fixes their problem, too (I could only reproduce a rather
  similar bug on my ilk, not exactly the same one). We also still have
  some assertion fallout from that patch, but a patch from Chris is
  awaiting review (just posted today).

Given that waiting for QA to run the manual tests this would add a week
(and hence miss the merge window), I'm bending the rules a bit on this one
and send you the pull request right away. I've beaten a bit more on it
than usually, and safe for the hsw patches it's all fixes.

I've also updated drm-intel-testing so that our QA can beat on the new
stuff.

Yours, Daniel

The following changes since commit 5e13a0c5ec05d382b488a691dfb8af015b1dea1e:

  Merge remote-tracking branch 'airlied/drm-core-next' into drm-intel-next-queued (2012-05-08 13:39:59 +0200)

are available in the git repository at:


  git://people.freedesktop.org/~danvet/drm-intel tags/drm-intel-next-2012-05-20

for you to fetch changes up to 98b6bd998ae057611d2bc040ace1fc847f575b84:

  drm/i915: IBX has a fixed pch pll to pch pipe mapping (2012-05-20 20:48:35 +0200)

----------------------------------------------------------------
Chris Wilson (10):
      drm/i915: Limit calling mark-busy only for potential scanouts
      drm/i915: Avoid a double-read of PCH_IIR during interrupt handling
      drm/i915: Simplify interrupt processing for IvyBridge
      drm/i915: gen6_enable_rps() wants to be called after ring initialisation
      drm/i915: Assert that the transcoder is indeed off before modifying it
      drm/i915: Introduce for_each_ring() macro
      drm/i915: Check whether the ring is initialised prior to dispatch
      drm/i915: Replace the feature tests for BLT/BSD with ring init checks
      drm/i915: Convert BUG_ON(!pll->active) and friends to a WARN
      drm/i915: Enable the PCH PLL for all generations after link training

Daniel Vetter (9):
      drm/i915: replace intel_infoframe_freq with VIDEO_DIP_FREQ_VSYNC
      drm/i915: s/i9xx_/gm45_ for the gm45 write_infoframe function
      drm/i915: s/intel_infoframe/gm45_infoframe
      MAINTAINERS: switch drm/i915 to Daniel Vetter
      drm/i915: enable semaphores on gen6 if dmar is not active
      drm/i915: disable gmbus on i830
      drm/i915: don't clobber the pipe param in sanitize_modesetting
      drm/i915: fixup infoframe support for sdvo
      drm/i915: IBX has a fixed pch pll to pch pipe mapping

Eugeni Dodonov (24):
      drm/i915: add new Haswell DIP controls registers
      drm/i915: reuse Ivy Bridge interrupts code for Haswell
      drm/i915: add support for SBI ops
      drm/i915: calculate watermarks for devices that have 3 pipes
      drm/i915: properly check for pipe count
      drm/i915: show unknown sdvox registers on hdmi init
      drm/i915: do not use fdi_normal_train on Haswell
      drm/i915: detect PCH encoders on Haswell
      drm/i915: enable power wells on Haswell init
      drm/i915: add LPT PCH checks
      drm/i915: handle DDI-related assertions
      drm/i915: account for only one PCH receiver on Haswell
      drm/i915: initialize DDI buffer translations
      drm/i915: support DDI training in FDI mode
      drm/i915: use ironlake eld write routine for Haswell
      drm/i915: define Haswell watermarks and clock gating
      drm/i915: program WM_LINETIME on Haswell
      drm/i915: program iCLKIP on Lynx Point
      drm/i915: detect digital outputs on Haswell
      drm/i915: add support for DDI-controlled digital outputs
      drm/i915: add WR PLL programming table
      drm/i915: move HDMI structs to shared location
      drm/i915: prepare HDMI link for Haswell
      drm/i915: hook Haswell devices in place

Paulo Zanoni (14):
      drm/i915: DSL_LINEMASK is 12 bits only on gen2
      drm/i915: change coding style of the write_infoframe functions
      drm/i915: start writing infoframes at address 0 on gen 4
      drm/i915: mask the video DIP port select
      drm/i915: break intel_infoframe_flags into _enable and _frequency
      drm/i915: disable the infoframe before changing it
      drm/i915: mask the video DIP frequency when changing it
      drm/i915: simplify intel_encoder_commit
      drm/i915: split ironlake_write_infoframe into ibx_ and cpt_
      drm/i915: ibx_write_infoframe can disable AVI
      drm/i915: set the DIP port on ibx_write_infoframe
      drm/i915: implement ironlake_wait_for_vblank
      drm/i915: small hdmi coding style cleanups
      drm/i915: implement hsw_write_infoframe

 MAINTAINERS                                |    4 +-
 drivers/char/agp/intel-agp.c               |    4 +
 drivers/gpu/drm/i915/Makefile              |    1 +
 drivers/gpu/drm/i915/i915_debugfs.c        |    9 +-
 drivers/gpu/drm/i915/i915_dma.c            |    4 +-
 drivers/gpu/drm/i915/i915_drv.c            |   33 +-
 drivers/gpu/drm/i915/i915_drv.h            |   11 +-
 drivers/gpu/drm/i915/i915_gem.c            |   39 +-
 drivers/gpu/drm/i915/i915_gem_evict.c      |   14 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   18 +-
 drivers/gpu/drm/i915/i915_irq.c            |  174 +++----
 drivers/gpu/drm/i915/i915_reg.h            |   46 +-
 drivers/gpu/drm/i915/i915_suspend.c        |    6 -
 drivers/gpu/drm/i915/intel_crt.c           |    6 +-
 drivers/gpu/drm/i915/intel_ddi.c           |  755 ++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/intel_display.c       |  371 ++++++++++++--
 drivers/gpu/drm/i915/intel_drv.h           |   33 +-
 drivers/gpu/drm/i915/intel_hdmi.c          |  278 +++++++---
 drivers/gpu/drm/i915/intel_i2c.c           |    4 +
 drivers/gpu/drm/i915/intel_pm.c            |   92 +++-
 drivers/gpu/drm/i915/intel_ringbuffer.h    |    6 +
 drivers/gpu/drm/i915/intel_sdvo.c          |   11 +-
 22 files changed, 1627 insertions(+), 292 deletions(-)
 create mode 100644 drivers/gpu/drm/i915/intel_ddi.c
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
