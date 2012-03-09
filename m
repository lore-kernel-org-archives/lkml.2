Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718Ab2CISyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 13:54:05 -0500
Received: from mail-ee0-f74.google.com ([74.125.83.74]:48586 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301Ab2CISyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 13:54:01 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 00/10 v2] fix gmbus writes and related issues
Date: Sat, 10 Mar 2012 02:48:14 +0800
Message-Id: <1331318904-20577-1-git-send-email-djkurtz@chromium.org>
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
 * turns on the GMBUS interrupt whenever possible to dramatically improve
   throughput by eliminating the very slow polling loop.

The patchset should apply cleanly onto linus/master.
It is inspired by, but completely supercedes, a similar patch submitted
recently by Benson Leung (bleung@chromium.org).
I'd be happy to rebase on a different tree if necessary.

v2 of the patchset address review comments from Chris Wilson (thanks for the
review, Chris!), and adds the interrupt patch.  There weren't any review
comments for patches 5, 7, or 8 of the first set.  Hopefully they will get
more love the second time around :).


Daniel Kurtz (10):
  drm/i915/intel_i2c: cleanup
  drm/i915/intel_i2c: assign HDMI port D to pin pair 6
  drm/i915/intel_i2c: refactor using intel_gmbus_get_adapter
  drm/i915/intel_i2c: cleanup gmbus/gpio pin assignments
  drm/i915/intel_i2c: add locking around i2c algorithm accesses
  drm/i915/intel_i2c: return -ENXIO for device NAK
  drm/i915/intel_i2c: use WAIT cycle, not STOP
  drm/i915/intel_i2c: use INDEX cycles for i2c read transactions
  drm/i915/intel_i2c: reuse GMBUS2 value read in polling loop
  drm/i915/intel_i2c: enable gmbus interrupts

 drivers/gpu/drm/i915/i915_drv.h    |    7 +-
 drivers/gpu/drm/i915/i915_irq.c    |   22 +++-
 drivers/gpu/drm/i915/i915_reg.h    |    6 +-
 drivers/gpu/drm/i915/intel_bios.c  |   11 +-
 drivers/gpu/drm/i915/intel_crt.c   |   13 +-
 drivers/gpu/drm/i915/intel_drv.h   |    9 ++-
 drivers/gpu/drm/i915/intel_dvo.c   |    4 +-
 drivers/gpu/drm/i915/intel_hdmi.c  |   29 ++---
 drivers/gpu/drm/i915/intel_i2c.c   |  236 ++++++++++++++++++++++++++++--------
 drivers/gpu/drm/i915/intel_lvds.c  |    3 +-
 drivers/gpu/drm/i915/intel_modes.c |    6 +-
 drivers/gpu/drm/i915/intel_sdvo.c  |   10 +-
 12 files changed, 257 insertions(+), 99 deletions(-)

-- 
1.7.7.3

