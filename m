Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab0FICAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 22:00:36 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34347 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548Ab0FICAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 22:00:34 -0400
Date: Wed, 9 Jun 2010 03:00:16 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1006090243360.1269@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1344219592-1276048816=:1269"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1344219592-1276048816=:1269
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT


Okay so while I admire the regression and oops only line, it sorta of 
messes up new features that went in -rc1 that need tweaking now that 
people are testing them. You are asking me to knowingly ship buggy code, 
that isn't a technical regression or oops, but doesn't actually work on 
some of the gpus it should work on. Since I can't (a) enumerate all the 
GPUs it can/can't work on, and (b) can't get fixes in, I'm sorta stuck 
with just removing the whole lot at this point.

So this pull does try and fix some problems in a feature we added in -rc1, 
radeon power management, its either the voltage fixes in here, or just 
remove voltage stuff completely, but since it works in some cases that 
would be a regression in itself. Also the debugging output is needed in 
order to help us track down future problems when/if they occur. The mid 
profile patch might look like a bad thing, but its an API change in a 
feature we haven't shipped so I can't let it wait until the next merge 
window, otherwise we'll have shipped the API, again I'll just remove the 
API if we can't change it now and try again in 2.6.36.

Otherwise it fixes the known Intel 865, radeon X300, evergreen accel 
issues, a longer term nouveau/iommu problem, and a few possible illegal 
memory access fixes.

I think I have one open issue with some unnecessary locks causing a thread 
to stall when the polling kicks in, but I'm trying to find a neat 2 line 
solution instead of converting everything to using an rwsem at this point.

The following changes since commit 386f40c86d6c8d5b717ef20620af1a750d0dacb4:
  Linus Torvalds (1):
        Revert "tty: fix a little bug in scrup, vt.c"

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (7):
      drm/radeon/kms/evergreen: set accel_enabled
      drm/radeon/kms/combios: fix typo in voltage fix
      drm/radeon/kms/pm: Misc fixes
      drm/radeon/kms/pm: add mid profile
      drm/radeon/kms: fix typo in printing the HPD info
      drm/radeon/kms/pm: Disable voltage adjust on RS780/RS880
      drm/radeon/kms/pm: track current voltage (v2)

Ben Skeggs (3):
      drm/nouveau: match U/DP script against SOR link
      drm/nouveau: completely fail init if we fail to map the PRAMIN BAR
      drm/nv50: fix iommu errors caused by device reading from address 0

Chris Wilson (1):
      drm: Propagate error from drm_fb_helper_init().

Dan Carpenter (4):
      drm/drm_crtc: return -EFAULT on copy_to_user errors
      drm/vmwgfx: return -EFAULT for copy_to_user errors
      nouveau: off by one in nv50_gpio_location()
      drm/nouveau: off by one in init_i2c_device_find()

Dave Airlie (5):
      drm/i915: fix oops on single crtc devices.
      drm/radeon: fix PM on non-vram cards.
      drm/fb: use printk to print out the switching to text mode error.
      drm/radeon: reset i2c valid to avoid incorrect tv-out polling.
      drm/radeon: don't poll tv dac if crtc2 is in use.

Rafa³ Mi³ecki (3):
      drm/radeon/kms/r600+: use voltage from requested clock mode (v3)
      drm/radeon/kms: add trivial debugging for voltage
      drm/radeon/kms/pm: resurrect printing power states

 drivers/gpu/drm/drm_crtc.c                      |    4 +-
 drivers/gpu/drm/drm_fb_helper.c                 |    2 +-
 drivers/gpu/drm/i915/i915_dma.c                 |   19 +++-
 drivers/gpu/drm/i915/i915_drv.h                 |    1 +
 drivers/gpu/drm/i915/intel_display.c            |    9 +-
 drivers/gpu/drm/i915/intel_fb.c                 |   10 ++-
 drivers/gpu/drm/nouveau/nouveau_bios.c          |   25 +++++-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c         |    8 ++-
 drivers/gpu/drm/nouveau/nouveau_state.c         |   19 ++---
 drivers/gpu/drm/nouveau/nv50_fb.c               |   10 ++-
 drivers/gpu/drm/nouveau/nv50_gpio.c             |    2 +-
 drivers/gpu/drm/radeon/evergreen.c              |   20 +++--
 drivers/gpu/drm/radeon/r100.c                   |   10 ++
 drivers/gpu/drm/radeon/r420.c                   |   12 +++-
 drivers/gpu/drm/radeon/r600.c                   |  111 ++++++++++++++++++++---
 drivers/gpu/drm/radeon/radeon.h                 |   12 ++-
 drivers/gpu/drm/radeon/radeon_atombios.c        |    6 +-
 drivers/gpu/drm/radeon/radeon_combios.c         |    4 +-
 drivers/gpu/drm/radeon/radeon_display.c         |    3 +-
 drivers/gpu/drm/radeon/radeon_drv.c             |    3 +-
 drivers/gpu/drm/radeon/radeon_fb.c              |   12 ++-
 drivers/gpu/drm/radeon/radeon_kms.c             |    9 ++-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |   11 +++
 drivers/gpu/drm/radeon/radeon_pm.c              |   95 ++++++++++++++------
 drivers/gpu/drm/radeon/rv770.c                  |   16 +++-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c         |    1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c        |    8 ++-
 include/drm/radeon_drm.h                        |    1 +
 28 files changed, 339 insertions(+), 104 deletions(-)
--29444707-1344219592-1276048816=:1269--
