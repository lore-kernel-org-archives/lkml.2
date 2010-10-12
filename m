Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab0JLMu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 08:50:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:45044 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab0JLMun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 08:50:43 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: airlied@linux.ie
Cc: jbarnes@virtuousgeek.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 2/5] drm/nouveau/kms: Implement KDB debug hooks for nouveau KMS.
Date: Tue, 12 Oct 2010 07:49:58 -0500
Message-Id: <1286887801-8179-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1286887801-8179-1-git-send-email-jason.wessel@windriver.com>
References: <1286887801-8179-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Oct 2010 12:50:31.0188 (UTC) FILETIME=[0DAE7540:01CB6A0C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Ball <cjb@laptop.org>

Tested on nv50 and nv04 HW.

Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: David Airlie <airlied@linux.ie>
CC: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/nouveau/nouveau_fbcon.c |    6 ++++
 drivers/gpu/drm/nouveau/nv04_crtc.c     |   45 +++++++++++++++++++++++-----
 drivers/gpu/drm/nouveau/nv50_crtc.c     |   48 ++++++++++++++++++++++--------
 3 files changed, 78 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index dbd30b2..02a4d1f 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -104,6 +104,8 @@ static struct fb_ops nouveau_fbcon_ops = {
 	.fb_pan_display = drm_fb_helper_pan_display,
 	.fb_blank = drm_fb_helper_blank,
 	.fb_setcmap = drm_fb_helper_setcmap,
+	.fb_debug_enter = drm_fb_helper_debug_enter,
+	.fb_debug_leave = drm_fb_helper_debug_leave,
 };
 
 static struct fb_ops nv04_fbcon_ops = {
@@ -117,6 +119,8 @@ static struct fb_ops nv04_fbcon_ops = {
 	.fb_pan_display = drm_fb_helper_pan_display,
 	.fb_blank = drm_fb_helper_blank,
 	.fb_setcmap = drm_fb_helper_setcmap,
+	.fb_debug_enter = drm_fb_helper_debug_enter,
+	.fb_debug_leave = drm_fb_helper_debug_leave,
 };
 
 static struct fb_ops nv50_fbcon_ops = {
@@ -130,6 +134,8 @@ static struct fb_ops nv50_fbcon_ops = {
 	.fb_pan_display = drm_fb_helper_pan_display,
 	.fb_blank = drm_fb_helper_blank,
 	.fb_setcmap = drm_fb_helper_setcmap,
+	.fb_debug_enter = drm_fb_helper_debug_enter,
+	.fb_debug_leave = drm_fb_helper_debug_leave,
 };
 
 static void nouveau_fbcon_gamma_set(struct drm_crtc *crtc, u16 red, u16 green,
diff --git a/drivers/gpu/drm/nouveau/nv04_crtc.c b/drivers/gpu/drm/nouveau/nv04_crtc.c
index 497df87..9d214f5 100644
--- a/drivers/gpu/drm/nouveau/nv04_crtc.c
+++ b/drivers/gpu/drm/nouveau/nv04_crtc.c
@@ -768,8 +768,9 @@ nv_crtc_gamma_set(struct drm_crtc *crtc, u16 *r, u16 *g, u16 *b, uint32_t start,
 }
 
 static int
-nv04_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
-			struct drm_framebuffer *old_fb)
+nv04_crtc_do_mode_set_base(struct drm_crtc *crtc,
+			   struct drm_framebuffer *passed_fb,
+			   int x, int y, bool atomic)
 {
 	struct nouveau_crtc *nv_crtc = nouveau_crtc(crtc);
 	struct drm_device *dev = crtc->dev;
@@ -780,13 +781,25 @@ nv04_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
 	int arb_burst, arb_lwm;
 	int ret;
 
-	ret = nouveau_bo_pin(fb->nvbo, TTM_PL_FLAG_VRAM);
-	if (ret)
-		return ret;
+	/* If atomic, we want to switch to the fb we were passed, so
+	 * now we update pointers to do that.  (We don't pin; just
+	 * assume we're already pinned and update the base address.)
+	 */
+	if (atomic) {
+		drm_fb = passed_fb;
+		fb = nouveau_framebuffer(passed_fb);
+	} else {
+		/* If not atomic, we can go ahead and pin, and unpin the
+		 * old fb we were passed.
+		 */
+		ret = nouveau_bo_pin(fb->nvbo, TTM_PL_FLAG_VRAM);
+		if (ret)
+			return ret;
 
-	if (old_fb) {
-		struct nouveau_framebuffer *ofb = nouveau_framebuffer(old_fb);
-		nouveau_bo_unpin(ofb->nvbo);
+		if (passed_fb) {
+			struct nouveau_framebuffer *ofb = nouveau_framebuffer(passed_fb);
+			nouveau_bo_unpin(ofb->nvbo);
+		}
 	}
 
 	nv_crtc->fb.offset = fb->nvbo->bo.offset;
@@ -834,6 +847,21 @@ nv04_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
 	return 0;
 }
 
+static int
+nv04_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
+			struct drm_framebuffer *old_fb)
+{
+	return nv04_crtc_do_mode_set_base(crtc, old_fb, x, y, false);
+}
+
+static int
+nv04_crtc_mode_set_base_atomic(struct drm_crtc *crtc,
+			       struct drm_framebuffer *fb,
+			       int x, int y)
+{
+	return nv04_crtc_do_mode_set_base(crtc, fb, x, y, true);
+}
+
 static void nv04_cursor_upload(struct drm_device *dev, struct nouveau_bo *src,
 			       struct nouveau_bo *dst)
 {
@@ -962,6 +990,7 @@ static const struct drm_crtc_helper_funcs nv04_crtc_helper_funcs = {
 	.mode_fixup = nv_crtc_mode_fixup,
 	.mode_set = nv_crtc_mode_set,
 	.mode_set_base = nv04_crtc_mode_set_base,
+	.mode_set_base_atomic = nv04_crtc_mode_set_base_atomic,
 	.load_lut = nv_crtc_gamma_load,
 };
 
diff --git a/drivers/gpu/drm/nouveau/nv50_crtc.c b/drivers/gpu/drm/nouveau/nv50_crtc.c
index bfd4ca2..a75f25f 100644
--- a/drivers/gpu/drm/nouveau/nv50_crtc.c
+++ b/drivers/gpu/drm/nouveau/nv50_crtc.c
@@ -491,8 +491,9 @@ nv50_crtc_mode_fixup(struct drm_crtc *crtc, struct drm_display_mode *mode,
 }
 
 static int
-nv50_crtc_do_mode_set_base(struct drm_crtc *crtc, int x, int y,
-			   struct drm_framebuffer *old_fb, bool update)
+nv50_crtc_do_mode_set_base(struct drm_crtc *crtc,
+			   struct drm_framebuffer *passed_fb,
+			   int x, int y, bool update, bool atomic)
 {
 	struct nouveau_crtc *nv_crtc = nouveau_crtc(crtc);
 	struct drm_device *dev = nv_crtc->base.dev;
@@ -504,6 +505,27 @@ nv50_crtc_do_mode_set_base(struct drm_crtc *crtc, int x, int y,
 
 	NV_DEBUG_KMS(dev, "index %d\n", nv_crtc->index);
 
+	/* If atomic, we want to switch to the fb we were passed, so
+	 * now we update pointers to do that.  (We don't pin; just
+	 * assume we're already pinned and update the base address.)
+	 */
+	if (atomic) {
+		drm_fb = passed_fb;
+		fb = nouveau_framebuffer(passed_fb);
+	} else {
+		/* If not atomic, we can go ahead and pin, and unpin the
+		 * old fb we were passed.
+		 */
+		ret = nouveau_bo_pin(fb->nvbo, TTM_PL_FLAG_VRAM);
+		if (ret)
+			return ret;
+
+		if (passed_fb) {
+			struct nouveau_framebuffer *ofb = nouveau_framebuffer(passed_fb);
+			nouveau_bo_unpin(ofb->nvbo);
+		}
+	}
+
 	switch (drm_fb->depth) {
 	case  8:
 		format = NV50_EVO_CRTC_FB_DEPTH_8;
@@ -526,15 +548,6 @@ nv50_crtc_do_mode_set_base(struct drm_crtc *crtc, int x, int y,
 		 return -EINVAL;
 	}
 
-	ret = nouveau_bo_pin(fb->nvbo, TTM_PL_FLAG_VRAM);
-	if (ret)
-		return ret;
-
-	if (old_fb) {
-		struct nouveau_framebuffer *ofb = nouveau_framebuffer(old_fb);
-		nouveau_bo_unpin(ofb->nvbo);
-	}
-
 	nv_crtc->fb.offset = fb->nvbo->bo.offset - dev_priv->vm_vram_base;
 	nv_crtc->fb.tile_flags = fb->nvbo->tile_flags;
 	nv_crtc->fb.cpp = drm_fb->bits_per_pixel / 8;
@@ -685,14 +698,22 @@ nv50_crtc_mode_set(struct drm_crtc *crtc, struct drm_display_mode *mode,
 	nv_crtc->set_dither(nv_crtc, nv_connector->use_dithering, false);
 	nv_crtc->set_scale(nv_crtc, nv_connector->scaling_mode, false);
 
-	return nv50_crtc_do_mode_set_base(crtc, x, y, old_fb, false);
+	return nv50_crtc_do_mode_set_base(crtc, old_fb, x, y, false, false);
 }
 
 static int
 nv50_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
 			struct drm_framebuffer *old_fb)
 {
-	return nv50_crtc_do_mode_set_base(crtc, x, y, old_fb, true);
+	return nv50_crtc_do_mode_set_base(crtc, old_fb, x, y, true, false);
+}
+
+static int
+nv50_crtc_mode_set_base_atomic(struct drm_crtc *crtc,
+			       struct drm_framebuffer *fb,
+			       int x, int y)
+{
+	return nv50_crtc_do_mode_set_base(crtc, fb, x, y, true, true);
 }
 
 static const struct drm_crtc_helper_funcs nv50_crtc_helper_funcs = {
@@ -702,6 +723,7 @@ static const struct drm_crtc_helper_funcs nv50_crtc_helper_funcs = {
 	.mode_fixup = nv50_crtc_mode_fixup,
 	.mode_set = nv50_crtc_mode_set,
 	.mode_set_base = nv50_crtc_mode_set_base,
+	.mode_set_base_atomic = nv50_crtc_mode_set_base_atomic,
 	.load_lut = nv50_crtc_lut_load,
 };
 
-- 
1.6.3.3

