Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab2C1MxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:53:17 -0400
Received: from mail-wi0-f202.google.com ([209.85.212.202]:61802 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab2C1MwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:52:06 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 00/14 v5] fix gmbus writes and related issues
Date: Wed, 28 Mar 2012 20:51:43 +0800
Message-Id: <1332939117-6513-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset addresses a couple of issues with the i915 gmbus implementation:
 * fixes misassigned pin port pair for HDMI-D
 * fixes write transactions when they are the only transaction requested
   (including large >4-byte writes) by terminating every transaction with a
   WAIT cycle.
 * returns -ENXIO and -ETIMEDOUT as appropriate so upper layers can handled
   i2c transaction failures
 * optimizes the typical read transaction case by using the INDEX cycle

v3:
 * rebased onto Daniel Vetter's drm-intel-next-queued branch
   at git://people.freedesktop.org/~danvet/drm-intel
 * replace intel_i2c_quirk_xfer with pre/post_xfer i2c routines
 * pre-allocate gmbus array
 * drop interrupt approach since I could not make it stable, probably due to
   difficulty in clearing and resetting the GMBUS interrupt which is buffered
   behind the SDE's PCH interrupt.
 * Fix zero-length writes
 * Wait for IDLE before clearing NAK

v4:
 * refactored gmbus_xfer (great idea, danvet!)
 * fixed refactoring braino (swapped [new] patches 6 & 7)
 * added URLs for docs to commit message
 * fixed checkpatch warnings in the "reuse GMBUS2" patch
 * dropped the 'functionaltiy' part of v3 patch 3
 * use WARN_ON instead of BUG_ON when an invalid port is requested

v5:
 * fix bug in handle zero-length writes patch
 * remove POSTING_READ() from gmbus transfers

Daniel Kurtz (14):
  drm/i915/intel_i2c: refactor gmbus_xfer
  drm/i915/intel_i2c: cleanup error messages and comments
  drm/i915/intel_i2c: assign HDMI port D to pin pair 6
  drm/i915/intel_i2c: use i2c pre/post_xfer functions to setup gpio
    xfers
  drm/i915/intel_i2c: refactor using intel_gmbus_get_adapter
  drm/i915/intel_i2c: gmbus disabled and reserved ports are invalid
  drm/i915/intel_i2c: allocate gmbus array as part of drm_i915_private
  drm/i915/intel_i2c: handle zero-length writes
  drm/i915/intel_i2c: use double-buffered writes
  drm/i915/intel_i2c: always wait for IDLE before clearing NAK
  drm/i915/intel_i2c: use WAIT cycle, not STOP
  drm/i915/intel_i2c: use INDEX cycles for i2c read transactions
  drm/i915/intel_i2c: reuse GMBUS2 value read in polling loop
  drm/i915/intel_i2c: remove POSTING_READ() from gmbus transfers

 drivers/gpu/drm/i915/i915_drv.h    |   10 +-
 drivers/gpu/drm/i915/i915_reg.h    |    6 +-
 drivers/gpu/drm/i915/intel_bios.c  |    4 +-
 drivers/gpu/drm/i915/intel_crt.c   |   14 +-
 drivers/gpu/drm/i915/intel_dvo.c   |    6 +-
 drivers/gpu/drm/i915/intel_hdmi.c  |    9 +-
 drivers/gpu/drm/i915/intel_i2c.c   |  356 ++++++++++++++++++++++--------------
 drivers/gpu/drm/i915/intel_lvds.c  |    7 +-
 drivers/gpu/drm/i915/intel_modes.c |    3 +-
 drivers/gpu/drm/i915/intel_sdvo.c  |    9 +-
 10 files changed, 259 insertions(+), 165 deletions(-)

-- 
1.7.7.3

