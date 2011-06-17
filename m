Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648Ab1FQSmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 14:42:16 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:47586 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab1FQSmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 14:42:13 -0400
X-Greylist: delayed 590 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Jun 2011 14:42:13 EDT
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Cc: Dave Airlie <airlied@redhat.com>,
        Daniel J Blueman <daniel.blueman@gmail.com>, stable@kernel.org,
        Eric Anholt <eric@anholt.net>
Subject: [PATCH] drm/i915: Fix gen6 (SNB) missed BLT ring interrupts.
Date: Fri, 17 Jun 2011 11:32:19 -0700
Message-Id: <1308335539-13952-1-git-send-email-eric@anholt.net>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel J Blueman <daniel.blueman@gmail.com>

The failure appeared in dmesg as:

[drm:i915_hangcheck_ring_idle] *ERROR* Hangcheck timer elapsed... blt
ring idle [waiting on 35064155, at 35064155], missed IRQ?

This works around that problem on by making the blitter command
streamer write interrupt state to the Hardware Status Page when a
MI_USER_INTERRUPT command is decoded, which appears to force the seqno
out to memory before the interrupt happens.

v1->v2: Moved to prior interrupt handler installation and RMW flags as
per feedback.
v2->v3: Removed RMW of flags (by anholt)

Cc: stable@kernel.org
Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Tested-by: Chris Wilson <chris@chris-wilson.co.uk> [v1]
Tested-by: Eric Anholt <eric@anholt.net> [v1,v3]
	   (incidence of the bug with a testcase went from avg 2/1000 to
	   0/12651 in the latest test run (plus more for v1))
Tested-by: Kenneth Graunke <kenneth@whitecape.org> [v1]
Tested-by: Robert Hooker <robert.hooker@canonical.com> [v1]
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=33394
---
 drivers/gpu/drm/i915/i915_irq.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index b79619a..0263717 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -1740,6 +1740,16 @@ void ironlake_irq_preinstall(struct drm_device *dev)
 		INIT_WORK(&dev_priv->rps_work, gen6_pm_rps_work);
 
 	I915_WRITE(HWSTAM, 0xeffe);
+	if (IS_GEN6(dev)) {
+		/* Workaround stalls observed on Sandy Bridge GPUs by
+		 * making the blitter command streamer generate a
+		 * write to the Hardware Status Page for
+		 * MI_USER_INTERRUPT.  This appears to serialize the
+		 * previous seqno write out before the interrupt
+		 * happens.
+		 */
+		I915_WRITE(GEN6_BLITTER_HWSTAM, ~GEN6_BLITTER_USER_INTERRUPT);
+	}
 
 	/* XXX hotplug from PCH */
 
-- 
1.7.5.3

