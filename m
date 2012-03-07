Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab2CGLvD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:51:03 -0500
Received: from mail-gx0-f202.google.com ([209.85.161.202]:42222 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2CGLu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:50:59 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 0/9] drm/i915/intel_i2c: fix gmbus writes and related issues
Date: Wed,  7 Mar 2012 19:50:41 +0800
Message-Id: <1331121050-17857-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset addresses a couple of issues with the i915 gmbus implementation:
  * fixes misassigned pin port pair for HDMI-D
  * fixes write transactions when they are the only transaction requested
    (including large >4-byte writes)
  * returns -ENXIO and -ETIMEDOUT as appropriate so upper layers can handled
    i2c transaction failures
  * optimizes the typical read transaction case by using the INDEX cycle

The patchset should apply cleanly onto linus/master.
It is inspired by, but completely supercedes, a similar patch submitted
recently by Benson Leung (bleung@chromium.org).
I'd be happy to rebase on a different tree if necessary.

Note: 
There is one more patch in the set which I have not included here.  It enables
the PCH GMBUS interrupt and makes use of it to eliminate the very slow
'wait_for' polling loop.  This patch was not included, however, because there
is at least one case I have discovered where the i915 driver issues a GMBUS
transaction AFTER its interrupts have been initialized, but BEFORE it they have
been enabled.  Both the gmbus transaction and irq initialization occur during
i915_load_modeset_init(), but the gmbus transaction happens first, during:
  intel_modeset_init()
    intel_setup_outputs()
      intel_lvds_init()
        drm_get_edid()
Is there a way to switch the order of these to events?
Or does it make more sense for the gmbus driver to check a "bool irq_enabled",
and choose whether to poll or use the GMBUS interrupt?
... or both?


Daniel Kurtz (9):
  drm/i915/intel_i2c: cleanup
  drm/i915/intel_i2c: assign HDMI port D to pin pair 6
  drm/i915/intel_i2c: refactor using intel_gmbus_get_bus
  drm/i915/intel_i2c: cleanup gmbus/gpio pin assignments
  drm/i915/intel_i2c: add locking around i2c algorithm accesses
  drm/i915/intel_i2c: return -ENXIO for device NAK
  drm/i915/intel_i2c: use WAIT cycle, not STOP
  drm/i915/intel_i2c: use INDEX cycles for i2c read transactions
  drm/i915/intel_i2c: reuse GMBUS2 value read in polling loop

 drivers/gpu/drm/i915/i915_drv.h    |    5 +-
 drivers/gpu/drm/i915/i915_reg.h    |    5 +-
 drivers/gpu/drm/i915/intel_bios.c  |   10 ++-
 drivers/gpu/drm/i915/intel_crt.c   |   13 ++--
 drivers/gpu/drm/i915/intel_drv.h   |    3 +-
 drivers/gpu/drm/i915/intel_dvo.c   |    4 +-
 drivers/gpu/drm/i915/intel_hdmi.c  |   29 +++---
 drivers/gpu/drm/i915/intel_i2c.c   |  175 +++++++++++++++++++++++++-----------
 drivers/gpu/drm/i915/intel_lvds.c  |    2 +-
 drivers/gpu/drm/i915/intel_modes.c |    6 +-
 drivers/gpu/drm/i915/intel_sdvo.c  |   10 +--
 11 files changed, 165 insertions(+), 97 deletions(-)

-- 
1.7.7.3

