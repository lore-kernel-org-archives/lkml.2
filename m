Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab2JNOxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:53:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46959 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753357Ab2JNOxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:53:17 -0400
Message-Id: <20121014143553.367173311@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:58 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        =?UTF-8?q?Pavel=20Ondra=C4=8Dka?= <pavel.ondracka@email.cz>
Subject: [ 145/147] drm/i915: fix swizzle detection for gen3
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit c9c4b6f6c28354f1df9bd288dc33ba7ae0e66aaa upstream.

It looks like the desktop variants of i915 and i945 also have the DCC
register to control dram channel interleave and cpu side bit6
swizzling.

Unfortunately internal Cspec/ConfigDB documentation for these ancient chips
have already been dropped and there seem to be no archives. Also
somebody thought the swizzling behaviour is surely a worthy secret to
keep and redacted any mention of these fields from the published Intel
datasheets.

I suspect the hw engineers were really proud of the page coloring
they've achieved in their first dual channel dram controller with
bit17 - after all Bspec explains in great length the optimal layout of
page frame numbers modulo 4 for the color and depth buffers, too.
Later on when they've started to work on VT-d they shamefully
discoverd their stupidity and tried to cover the tracks ...

Tested-by: Daniel Vetter <daniel.vetter@ffwll.ch> (i915g)
Tested-by: Pavel Ondračka <pavel.ondracka@email.cz> (i945g)
Tested-by: Chris Wilson <chris@chris-wilson.co.uk>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=42625
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_gem_tiling.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_tiling.c b/drivers/gpu/drm/i915/i915_gem_tiling.c
index 31d334d..861223b 100644
--- a/drivers/gpu/drm/i915/i915_gem_tiling.c
+++ b/drivers/gpu/drm/i915/i915_gem_tiling.c
@@ -107,10 +107,10 @@ i915_gem_detect_bit_6_swizzle(struct drm_device *dev)
 		 */
 		swizzle_x = I915_BIT_6_SWIZZLE_NONE;
 		swizzle_y = I915_BIT_6_SWIZZLE_NONE;
-	} else if (IS_MOBILE(dev)) {
+	} else if (IS_MOBILE(dev) || (IS_GEN3(dev) && !IS_G33(dev))) {
 		uint32_t dcc;
 
-		/* On mobile 9xx chipsets, channel interleave by the CPU is
+		/* On 9xx chipsets, channel interleave by the CPU is
 		 * determined by DCC.  For single-channel, neither the CPU
 		 * nor the GPU do swizzling.  For dual channel interleaved,
 		 * the GPU's interleave is bit 9 and 10 for X tiled, and bit


