Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab2DCOzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 10:55:54 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57961 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab2DCOzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 10:55:52 -0400
Date: Tue, 3 Apr 2012 16:56:36 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [pull] drm-intel-fixes for 3.4
Message-ID: <20120403145636.GB4415@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

A few patches for 3.4, major part is 3 regression fixes:
- ppgtt broke hibernate on snb/ivb. Somehow our QA claims that it still
  works, which is why this has not been caught earlier.
- ppgtt flails in combination with dmar. I kinda expected this one :(
- fence handling bugfix for gen2/3. Iirc this one is about a year old, fix
  curtesy Chris Wilson. I've created an shockingly simple i-g-t test to
  catch this in the future.

Wrt regressions I've just got a report that gmbus (newly enabled again in
3.4) is a bit noisy. I'm looking into this atm.

Also included are the rc6 enable patches for snb from Eugeni. I wanted to
include these in the main 3.4 pull but screwed it up. Please hit me. Imo
these kind of patches really should go in before -rc1, but in thise case
rc6 has brought us tons of press and guinea pigs^W^W testers and ubuntu is
already running with it. So I estimate a pretty small chance for this to
blow up.

And some smaller things:
- two minor locking snafus
- server gt2 ivb pciid
- 2 patches to sanitize the register state left behind by the bios some
  more
- 2 new quirk entries
- cs readback trick against missed IRQs from ivb also enabled on snb
- sprite fix from Jesse

Yours, Daniel

The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928:

  Linux 3.4-rc1 (2012-03-31 16:24:09 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~danvet/drm-intel drm-intel-fixes

for you to fetch changes up to b4db1e35ac59c144965f517bc575a0d75b60b03f:

  drm/i915: treat src w & h as fixed point in sprite handling code (2012-04-03 11:33:33 +0200)

----------------------------------------------------------------
Anisse Astier (1):
      drm/i915: no-lvds quirk on MSI DC500

Chris Wilson (2):
      drm/i915: Sanitize BIOS debugging bits from PIPECONF
      drm/i915: Mark untiled BLT commands as fenced on gen2/3

Daniel Vetter (6):
      drm/i915: properly restore the ppgtt page directory on resume
      drm/i915: quirk away broken OpRegion VBT
      drm/i915: apply CS reg readback trick against missed IRQ on snb
      drm/i915: properly clear SSC1 bit in the pch refclock init code
      drm/i915: disable ppgtt on snb when dmar is enabled
      drm/i915: don't leak struct_mutex lock on ppgtt init failures

Eugeni Dodonov (3):
      drm/i915: allow to select rc6 modes via kernel parameter
      drm/i915: enable plain RC6 on Sandy Bridge by default
      drm/i915: add Ivy Bridge GT2 Server entries

Jesse Barnes (1):
      drm/i915: treat src w & h as fixed point in sprite handling code

Sean Paul (1):
      drm/i915: Add lock on drm_helper_resume_force_mode

 drivers/char/agp/intel-agp.h               |    1 +
 drivers/char/agp/intel-gtt.c               |    3 +-
 drivers/gpu/drm/i915/i915_dma.c            |   21 ++++++++++++++-
 drivers/gpu/drm/i915/i915_drv.c            |   13 +++++++--
 drivers/gpu/drm/i915/i915_drv.h            |   23 ++++++++++++++++-
 drivers/gpu/drm/i915/i915_gem.c            |   37 ++++++++++++++++++++++-----
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    2 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c        |    9 -------
 drivers/gpu/drm/i915/i915_reg.h            |    1 +
 drivers/gpu/drm/i915/intel_bios.c          |   23 ++++++++++++++++-
 drivers/gpu/drm/i915/intel_display.c       |   37 +++++++++++++++++++++-------
 drivers/gpu/drm/i915/intel_lvds.c          |    8 ++++++
 drivers/gpu/drm/i915/intel_ringbuffer.c    |    2 +-
 drivers/gpu/drm/i915/intel_sprite.c        |    3 ++
 include/drm/intel-gtt.h                    |    4 +++
 15 files changed, 152 insertions(+), 35 deletions(-)
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
