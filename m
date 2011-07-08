Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab1GHFBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:01:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41696 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab1GHFBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:01:36 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:55 2011
Message-Id: <20110708001655.280182108@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:15:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel J Blueman <daniel.blueman@gmail.com>,
        Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@redhat.com>
Subject: [026/107] drm/i915: Fix gen6 (SNB) missed BLT ring interrupts.
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel J Blueman <daniel.blueman@gmail.com>

commit 498e720b96379d8ee9c294950a01534a73defcf3 upstream.

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

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Tested-by: Chris Wilson <chris@chris-wilson.co.uk> [v1]
Tested-by: Eric Anholt <eric@anholt.net> [v1,v3]
	   (incidence of the bug with a testcase went from avg 2/1000 to
	   0/12651 in the latest test run (plus more for v1))
Tested-by: Kenneth Graunke <kenneth@whitecape.org> [v1]
Tested-by: Robert Hooker <robert.hooker@canonical.com> [v1]
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=33394
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_irq.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -1567,6 +1567,16 @@ static void ironlake_irq_preinstall(stru
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
 
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
 


