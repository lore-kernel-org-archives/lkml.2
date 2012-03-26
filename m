Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab2CZO22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:28:28 -0400
Received: from mail-lb0-f202.google.com ([209.85.217.202]:47299 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517Ab2CZO05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:26:57 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 00/11 v3] fix gmbus writes and related issues
Date: Mon, 26 Mar 2012 22:26:39 +0800
Message-Id: <1332772010-19619-1-git-send-email-djkurtz@chromium.org>
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

Daniel Kurtz (11):
  drm/i915/intel_i2c: cleanup
  drm/i915/intel_i2c: assign HDMI port D to pin pair 6
  drm/i915/intel_i2c: use i2c pre/post_xfer functions to setup gpio
    xfers
  drm/i915/intel_i2c: cleanup gmbus/gpio pin assignments
  drm/i915/intel_i2c: allocate gmbus array as part of drm_i915_private
  drm/i915/intel_i2c: refactor using intel_gmbus_get_adapter
  drm/i915/intel_i2c: handle zero-length writes
  drm/i915/intel_i2c: always wait for IDLE before clearing NAK
  drm/i915/intel_i2c: use WAIT cycle, not STOP
  drm/i915/intel_i2c: use INDEX cycles for i2c read transactions
  drm/i915/intel_i2c: reuse GMBUS2 value read in polling loop

 drivers/gpu/drm/i915/i915_drv.h    |   10 +-
 drivers/gpu/drm/i915/i915_reg.h    |    6 +-
 drivers/gpu/drm/i915/intel_bios.c  |    4 +-
 drivers/gpu/drm/i915/intel_crt.c   |   14 +-
 drivers/gpu/drm/i915/intel_dvo.c   |    6 +-
 drivers/gpu/drm/i915/intel_hdmi.c  |    9 +-
 drivers/gpu/drm/i915/intel_i2c.c   |  278 ++++++++++++++++++++++--------------
 drivers/gpu/drm/i915/intel_lvds.c  |    7 +-
 drivers/gpu/drm/i915/intel_modes.c |    3 +-
 drivers/gpu/drm/i915/intel_sdvo.c  |    9 +-
 10 files changed, 213 insertions(+), 133 deletions(-)

-- 
1.7.7.3

