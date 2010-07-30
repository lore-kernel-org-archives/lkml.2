Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab0G3R6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:58:35 -0400
Received: from kroah.org ([198.145.64.141]:58987 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932334Ab0G3R5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:04 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:47 2010
Message-Id: <20100730175147.223471313@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
Subject: [146/205] drm/i915: handle shared framebuffers when flipping
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit be9a3dbf65a69933b06011f049b1e2fdfa6bc8b9 upstream.

If a framebuffer is shared across CRTCs, the x,y position of one of them
is likely to be something other than the origin (e.g. for extended
desktop configs).  So calculate the offset at flip time so such
configurations can work.

Fixes https://bugs.freedesktop.org/show_bug.cgi?id=28518.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Tested-by: Thomas M. <tmezzadra@gmail.com>
Tested-by: fangxun <xunx.fang@intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_display.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4229,7 +4229,7 @@ static int intel_crtc_page_flip(struct d
 	struct drm_gem_object *obj;
 	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
 	struct intel_unpin_work *work;
-	unsigned long flags;
+	unsigned long flags, offset;
 	int pipesrc_reg = (intel_crtc->pipe == 0) ? PIPEASRC : PIPEBSRC;
 	int ret, pipesrc;
 	u32 flip_mask;
@@ -4297,19 +4297,23 @@ static int intel_crtc_page_flip(struct d
 		while (I915_READ(ISR) & flip_mask)
 			;
 
+	/* Offset into the new buffer for cases of shared fbs between CRTCs */
+	offset = obj_priv->gtt_offset;
+	offset += (crtc->y * fb->pitch) + (crtc->x * (fb->bits_per_pixel) / 8);
+
 	BEGIN_LP_RING(4);
 	if (IS_I965G(dev)) {
 		OUT_RING(MI_DISPLAY_FLIP |
 			 MI_DISPLAY_FLIP_PLANE(intel_crtc->plane));
 		OUT_RING(fb->pitch);
-		OUT_RING(obj_priv->gtt_offset | obj_priv->tiling_mode);
+		OUT_RING(offset | obj_priv->tiling_mode);
 		pipesrc = I915_READ(pipesrc_reg); 
 		OUT_RING(pipesrc & 0x0fff0fff);
 	} else {
 		OUT_RING(MI_DISPLAY_FLIP_I915 |
 			 MI_DISPLAY_FLIP_PLANE(intel_crtc->plane));
 		OUT_RING(fb->pitch);
-		OUT_RING(obj_priv->gtt_offset);
+		OUT_RING(offset);
 		OUT_RING(MI_NOOP);
 	}
 	ADVANCE_LP_RING();


