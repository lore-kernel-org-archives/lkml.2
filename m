Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab2EIGLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:11:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39153 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756708Ab2EIFxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:31 -0400
Message-Id: <20120509055044.902920009@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:19 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kenneth Graunke <kenneth@whitecape.org>,
        Rob Castle <futuredub@gmail.com>, Eric Appleman <erappleman@gmail.com>,
        Keith Packard <keithp@keithp.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 110/167] [PATCH] drm/i915: Set the Stencil Cache eviction policy to non-LRA
 mode.
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenneth Graunke <kenneth@whitecape.org>

commit 3a69ddd6f872180b6f61fda87152b37202118fbc upstream.

Clearing bit 5 of CACHE_MODE_0 is necessary to prevent GPU hangs in
OpenGL programs such as Google MapsGL, Google Earth, and gzdoom when
using separate stencil buffers.  Without it, the GPU tries to use the
LRA eviction policy, which isn't supported.  This was supposed to be off
by default, but seems to be on for many machines.

This cannot be done in gen6_init_clock_gating with most of the other
workaround bits; the render ring needs to exist.  Otherwise, the
register write gets dropped on the floor (one printk will show it
changed, but a second printk immediately following shows the value
reverts to the old one).

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=47535
Cc: Rob Castle <futuredub@gmail.com>
Cc: Eric Appleman <erappleman@gmail.com>
Cc: aaron667@gmx.net
Cc: Keith Packard <keithp@keithp.com>
Signed-off-by: Kenneth Graunke <kenneth@whitecape.org>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_reg.h         |    1 +
 drivers/gpu/drm/i915/intel_ringbuffer.c |    8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index b4bb1ef..9d24d65 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -568,6 +568,7 @@
 #define   CM0_MASK_SHIFT          16
 #define   CM0_IZ_OPT_DISABLE      (1<<6)
 #define   CM0_ZR_OPT_DISABLE      (1<<5)
+#define	  CM0_STC_EVICT_DISABLE_LRA_SNB	(1<<5)
 #define   CM0_DEPTH_EVICT_DISABLE (1<<4)
 #define   CM0_COLOR_EVICT_DISABLE (1<<3)
 #define   CM0_DEPTH_WRITE_DISABLE (1<<1)
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index f75806e..80fce51 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -401,6 +401,14 @@ static int init_render_ring(struct intel_ring_buffer *ring)
 	if (INTEL_INFO(dev)->gen >= 6) {
 		I915_WRITE(INSTPM,
 			   INSTPM_FORCE_ORDERING << 16 | INSTPM_FORCE_ORDERING);
+
+		/* From the Sandybridge PRM, volume 1 part 3, page 24:
+		 * "If this bit is set, STCunit will have LRA as replacement
+		 *  policy. [...] This bit must be reset.  LRA replacement
+		 *  policy is not supported."
+		 */
+		I915_WRITE(CACHE_MODE_0,
+			   CM0_STC_EVICT_DISABLE_LRA_SNB << CM0_MASK_SHIFT);
 	}
 
 	return ret;
-- 
1.7.10



