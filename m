Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab0JLMup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 08:50:45 -0400
Received: from mail.windriver.com ([147.11.1.11]:45046 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab0JLMun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 08:50:43 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: airlied@linux.ie
Cc: jbarnes@virtuousgeek.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/5] drm/radeon/kms: Implement KDB debug hooks for radeon KMS.
Date: Tue, 12 Oct 2010 07:49:57 -0500
Message-Id: <1286887801-8179-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1286887801-8179-1-git-send-email-jason.wessel@windriver.com>
References: <1286887801-8179-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Oct 2010 12:50:30.0203 (UTC) FILETIME=[0D1828B0:01CB6A0C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Ball <cjb@laptop.org>

Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: David Airlie <airlied@linux.ie>
CC: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/radeon/atombios_crtc.c      |  117 +++++++++++++++++++--------
 drivers/gpu/drm/radeon/radeon_fb.c          |    2 +
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |   44 ++++++++---
 drivers/gpu/drm/radeon/radeon_mode.h        |   10 ++-
 4 files changed, 126 insertions(+), 47 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index cd0290f..58f7b15 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -854,13 +854,15 @@ static void atombios_crtc_set_pll(struct drm_crtc *crtc, struct drm_display_mode
 
 }
 
-static int evergreen_crtc_set_base(struct drm_crtc *crtc, int x, int y,
-				   struct drm_framebuffer *old_fb)
+static int evergreen_crtc_do_set_base(struct drm_crtc *crtc,
+				      struct drm_framebuffer *fb,
+				      int x, int y, int atomic)
 {
 	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
 	struct drm_device *dev = crtc->dev;
 	struct radeon_device *rdev = dev->dev_private;
 	struct radeon_framebuffer *radeon_fb;
+	struct drm_framebuffer *target_fb;
 	struct drm_gem_object *obj;
 	struct radeon_bo *rbo;
 	uint64_t fb_location;
@@ -868,28 +870,42 @@ static int evergreen_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 	int r;
 
 	/* no fb bound */
-	if (!crtc->fb) {
+	if (!atomic && !crtc->fb) {
 		DRM_DEBUG_KMS("No FB bound\n");
 		return 0;
 	}
 
-	radeon_fb = to_radeon_framebuffer(crtc->fb);
+	if (atomic) {
+		radeon_fb = to_radeon_framebuffer(fb);
+		target_fb = fb;
+	} else {
+		radeon_fb = to_radeon_framebuffer(crtc->fb);
+		target_fb = crtc->fb;
+	}
 
-	/* Pin framebuffer & get tilling informations */
+	/* If atomic, assume fb object is pinned & idle & fenced and
+	 * just update base pointers
+	 */
 	obj = radeon_fb->obj;
 	rbo = obj->driver_private;
 	r = radeon_bo_reserve(rbo, false);
 	if (unlikely(r != 0))
 		return r;
-	r = radeon_bo_pin(rbo, RADEON_GEM_DOMAIN_VRAM, &fb_location);
-	if (unlikely(r != 0)) {
-		radeon_bo_unreserve(rbo);
-		return -EINVAL;
+
+	if (atomic)
+		fb_location = radeon_bo_gpu_offset(rbo);
+	else {
+		r = radeon_bo_pin(rbo, RADEON_GEM_DOMAIN_VRAM, &fb_location);
+		if (unlikely(r != 0)) {
+			radeon_bo_unreserve(rbo);
+			return -EINVAL;
+		}
 	}
+
 	radeon_bo_get_tiling_flags(rbo, &tiling_flags, NULL);
 	radeon_bo_unreserve(rbo);
 
-	switch (crtc->fb->bits_per_pixel) {
+	switch (target_fb->bits_per_pixel) {
 	case 8:
 		fb_format = (EVERGREEN_GRPH_DEPTH(EVERGREEN_GRPH_DEPTH_8BPP) |
 			     EVERGREEN_GRPH_FORMAT(EVERGREEN_GRPH_FORMAT_INDEXED));
@@ -909,7 +925,7 @@ static int evergreen_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 		break;
 	default:
 		DRM_ERROR("Unsupported screen depth %d\n",
-			  crtc->fb->bits_per_pixel);
+			  target_fb->bits_per_pixel);
 		return -EINVAL;
 	}
 
@@ -955,10 +971,10 @@ static int evergreen_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 	WREG32(EVERGREEN_GRPH_SURFACE_OFFSET_Y + radeon_crtc->crtc_offset, 0);
 	WREG32(EVERGREEN_GRPH_X_START + radeon_crtc->crtc_offset, 0);
 	WREG32(EVERGREEN_GRPH_Y_START + radeon_crtc->crtc_offset, 0);
-	WREG32(EVERGREEN_GRPH_X_END + radeon_crtc->crtc_offset, crtc->fb->width);
-	WREG32(EVERGREEN_GRPH_Y_END + radeon_crtc->crtc_offset, crtc->fb->height);
+	WREG32(EVERGREEN_GRPH_X_END + radeon_crtc->crtc_offset, target_fb->width);
+	WREG32(EVERGREEN_GRPH_Y_END + radeon_crtc->crtc_offset, target_fb->height);
 
-	fb_pitch_pixels = crtc->fb->pitch / (crtc->fb->bits_per_pixel / 8);
+	fb_pitch_pixels = target_fb->pitch / (target_fb->bits_per_pixel / 8);
 	WREG32(EVERGREEN_GRPH_PITCH + radeon_crtc->crtc_offset, fb_pitch_pixels);
 	WREG32(EVERGREEN_GRPH_ENABLE + radeon_crtc->crtc_offset, 1);
 
@@ -977,8 +993,8 @@ static int evergreen_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 	else
 		WREG32(EVERGREEN_DATA_FORMAT + radeon_crtc->crtc_offset, 0);
 
-	if (old_fb && old_fb != crtc->fb) {
-		radeon_fb = to_radeon_framebuffer(old_fb);
+	if (!atomic && fb && fb != crtc->fb) {
+		radeon_fb = to_radeon_framebuffer(fb);
 		rbo = radeon_fb->obj->driver_private;
 		r = radeon_bo_reserve(rbo, false);
 		if (unlikely(r != 0))
@@ -993,8 +1009,9 @@ static int evergreen_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 	return 0;
 }
 
-static int avivo_crtc_set_base(struct drm_crtc *crtc, int x, int y,
-			       struct drm_framebuffer *old_fb)
+static int avivo_crtc_do_set_base(struct drm_crtc *crtc,
+				  struct drm_framebuffer *fb,
+				  int x, int y, int atomic)
 {
 	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
 	struct drm_device *dev = crtc->dev;
@@ -1002,33 +1019,47 @@ static int avivo_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 	struct radeon_framebuffer *radeon_fb;
 	struct drm_gem_object *obj;
 	struct radeon_bo *rbo;
+	struct drm_framebuffer *target_fb;
 	uint64_t fb_location;
 	uint32_t fb_format, fb_pitch_pixels, tiling_flags;
 	int r;
 
 	/* no fb bound */
-	if (!crtc->fb) {
+	if (!atomic && !crtc->fb) {
 		DRM_DEBUG_KMS("No FB bound\n");
 		return 0;
 	}
 
-	radeon_fb = to_radeon_framebuffer(crtc->fb);
+	if (atomic) {
+		radeon_fb = to_radeon_framebuffer(fb);
+		target_fb = fb;
+	} else {
+		radeon_fb = to_radeon_framebuffer(crtc->fb);
+		target_fb = crtc->fb;
+	}
 
-	/* Pin framebuffer & get tilling informations */
 	obj = radeon_fb->obj;
 	rbo = obj->driver_private;
 	r = radeon_bo_reserve(rbo, false);
 	if (unlikely(r != 0))
 		return r;
-	r = radeon_bo_pin(rbo, RADEON_GEM_DOMAIN_VRAM, &fb_location);
-	if (unlikely(r != 0)) {
-		radeon_bo_unreserve(rbo);
-		return -EINVAL;
+
+	/* If atomic, assume fb object is pinned & idle & fenced and
+	 * just update base pointers
+	 */
+	if (atomic)
+		fb_location = radeon_bo_gpu_offset(rbo);
+	else {
+		r = radeon_bo_pin(rbo, RADEON_GEM_DOMAIN_VRAM, &fb_location);
+		if (unlikely(r != 0)) {
+			radeon_bo_unreserve(rbo);
+			return -EINVAL;
+		}
 	}
 	radeon_bo_get_tiling_flags(rbo, &tiling_flags, NULL);
 	radeon_bo_unreserve(rbo);
 
-	switch (crtc->fb->bits_per_pixel) {
+	switch (target_fb->bits_per_pixel) {
 	case 8:
 		fb_format =
 		    AVIVO_D1GRPH_CONTROL_DEPTH_8BPP |
@@ -1052,7 +1083,7 @@ static int avivo_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 		break;
 	default:
 		DRM_ERROR("Unsupported screen depth %d\n",
-			  crtc->fb->bits_per_pixel);
+			  target_fb->bits_per_pixel);
 		return -EINVAL;
 	}
 
@@ -1093,10 +1124,10 @@ static int avivo_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 	WREG32(AVIVO_D1GRPH_SURFACE_OFFSET_Y + radeon_crtc->crtc_offset, 0);
 	WREG32(AVIVO_D1GRPH_X_START + radeon_crtc->crtc_offset, 0);
 	WREG32(AVIVO_D1GRPH_Y_START + radeon_crtc->crtc_offset, 0);
-	WREG32(AVIVO_D1GRPH_X_END + radeon_crtc->crtc_offset, crtc->fb->width);
-	WREG32(AVIVO_D1GRPH_Y_END + radeon_crtc->crtc_offset, crtc->fb->height);
+	WREG32(AVIVO_D1GRPH_X_END + radeon_crtc->crtc_offset, target_fb->width);
+	WREG32(AVIVO_D1GRPH_Y_END + radeon_crtc->crtc_offset, target_fb->height);
 
-	fb_pitch_pixels = crtc->fb->pitch / (crtc->fb->bits_per_pixel / 8);
+	fb_pitch_pixels = target_fb->pitch / (target_fb->bits_per_pixel / 8);
 	WREG32(AVIVO_D1GRPH_PITCH + radeon_crtc->crtc_offset, fb_pitch_pixels);
 	WREG32(AVIVO_D1GRPH_ENABLE + radeon_crtc->crtc_offset, 1);
 
@@ -1115,8 +1146,8 @@ static int avivo_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 	else
 		WREG32(AVIVO_D1MODE_DATA_FORMAT + radeon_crtc->crtc_offset, 0);
 
-	if (old_fb && old_fb != crtc->fb) {
-		radeon_fb = to_radeon_framebuffer(old_fb);
+	if (!atomic && fb && fb != crtc->fb) {
+		radeon_fb = to_radeon_framebuffer(fb);
 		rbo = radeon_fb->obj->driver_private;
 		r = radeon_bo_reserve(rbo, false);
 		if (unlikely(r != 0))
@@ -1138,11 +1169,26 @@ int atombios_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 	struct radeon_device *rdev = dev->dev_private;
 
 	if (ASIC_IS_DCE4(rdev))
-		return evergreen_crtc_set_base(crtc, x, y, old_fb);
+		return evergreen_crtc_do_set_base(crtc, old_fb, x, y, 0);
+	else if (ASIC_IS_AVIVO(rdev))
+		return avivo_crtc_do_set_base(crtc, old_fb, x, y, 0);
+	else
+		return radeon_crtc_do_set_base(crtc, old_fb, x, y, 0);
+}
+
+int atombios_crtc_set_base_atomic(struct drm_crtc *crtc,
+				  struct drm_framebuffer *fb,
+				  int x, int y)
+{
+	struct drm_device *dev = crtc->dev;
+	struct radeon_device *rdev = dev->dev_private;
+
+	if (ASIC_IS_DCE4(rdev))
+		return evergreen_crtc_do_set_base(crtc, fb, x, y, 1);
 	else if (ASIC_IS_AVIVO(rdev))
-		return avivo_crtc_set_base(crtc, x, y, old_fb);
+		return avivo_crtc_do_set_base(crtc, fb, x, y, 1);
 	else
-		return radeon_crtc_set_base(crtc, x, y, old_fb);
+		return radeon_crtc_do_set_base(crtc, fb, x, y, 1);
 }
 
 /* properly set additional regs when using atombios */
@@ -1311,6 +1357,7 @@ static const struct drm_crtc_helper_funcs atombios_helper_funcs = {
 	.mode_fixup = atombios_crtc_mode_fixup,
 	.mode_set = atombios_crtc_mode_set,
 	.mode_set_base = atombios_crtc_set_base,
+	.mode_set_base_atomic = atombios_crtc_set_base_atomic,
 	.prepare = atombios_crtc_prepare,
 	.commit = atombios_crtc_commit,
 	.load_lut = radeon_crtc_load_lut,
diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/radeon_fb.c
index 40b0c08..efa2118 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -59,6 +59,8 @@ static struct fb_ops radeonfb_ops = {
 	.fb_pan_display = drm_fb_helper_pan_display,
 	.fb_blank = drm_fb_helper_blank,
 	.fb_setcmap = drm_fb_helper_setcmap,
+	.fb_debug_enter = drm_fb_helper_debug_enter,
+	.fb_debug_leave = drm_fb_helper_debug_leave,
 };
 
 
diff --git a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
index 305049a..555c055 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
@@ -348,10 +348,25 @@ void radeon_crtc_dpms(struct drm_crtc *crtc, int mode)
 int radeon_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 			 struct drm_framebuffer *old_fb)
 {
+	return radeon_crtc_do_set_base(crtc, old_fb, x, y, 0);
+}
+
+int radeon_crtc_set_base_atomic(struct drm_crtc *crtc,
+				struct drm_framebuffer *fb,
+				int x, int y)
+{
+	return radeon_crtc_do_set_base(crtc, fb, x, y, 1);
+}
+
+int radeon_crtc_do_set_base(struct drm_crtc *crtc,
+			 struct drm_framebuffer *fb,
+			 int x, int y, int atomic)
+{
 	struct drm_device *dev = crtc->dev;
 	struct radeon_device *rdev = dev->dev_private;
 	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
 	struct radeon_framebuffer *radeon_fb;
+	struct drm_framebuffer *target_fb;
 	struct drm_gem_object *obj;
 	struct radeon_bo *rbo;
 	uint64_t base;
@@ -364,14 +379,20 @@ int radeon_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 
 	DRM_DEBUG_KMS("\n");
 	/* no fb bound */
-	if (!crtc->fb) {
+	if (!atomic && !crtc->fb) {
 		DRM_DEBUG_KMS("No FB bound\n");
 		return 0;
 	}
 
-	radeon_fb = to_radeon_framebuffer(crtc->fb);
+	if (atomic) {
+		radeon_fb = to_radeon_framebuffer(fb);
+		target_fb = fb;
+	} else {
+		radeon_fb = to_radeon_framebuffer(crtc->fb);
+		target_fb = crtc->fb;
+	}
 
-	switch (crtc->fb->bits_per_pixel) {
+	switch (target_fb->bits_per_pixel) {
 	case 8:
 		format = 2;
 		break;
@@ -415,10 +436,10 @@ int radeon_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 
 	crtc_offset_cntl = 0;
 
-	pitch_pixels = crtc->fb->pitch / (crtc->fb->bits_per_pixel / 8);
-	crtc_pitch  = (((pitch_pixels * crtc->fb->bits_per_pixel) +
-			((crtc->fb->bits_per_pixel * 8) - 1)) /
-		       (crtc->fb->bits_per_pixel * 8));
+	pitch_pixels = target_fb->pitch / (target_fb->bits_per_pixel / 8);
+	crtc_pitch  = (((pitch_pixels * target_fb->bits_per_pixel) +
+			((target_fb->bits_per_pixel * 8) - 1)) /
+		       (target_fb->bits_per_pixel * 8));
 	crtc_pitch |= crtc_pitch << 16;
 
 
@@ -443,14 +464,14 @@ int radeon_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 			crtc_tile_x0_y0 = x | (y << 16);
 			base &= ~0x7ff;
 		} else {
-			int byteshift = crtc->fb->bits_per_pixel >> 4;
+			int byteshift = target_fb->bits_per_pixel >> 4;
 			int tile_addr = (((y >> 3) * pitch_pixels +  x) >> (8 - byteshift)) << 11;
 			base += tile_addr + ((x << byteshift) % 256) + ((y % 8) << 8);
 			crtc_offset_cntl |= (y % 16);
 		}
 	} else {
 		int offset = y * pitch_pixels + x;
-		switch (crtc->fb->bits_per_pixel) {
+		switch (target_fb->bits_per_pixel) {
 		case 8:
 			offset *= 1;
 			break;
@@ -496,8 +517,8 @@ int radeon_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 	WREG32(RADEON_CRTC_OFFSET + radeon_crtc->crtc_offset, crtc_offset);
 	WREG32(RADEON_CRTC_PITCH + radeon_crtc->crtc_offset, crtc_pitch);
 
-	if (old_fb && old_fb != crtc->fb) {
-		radeon_fb = to_radeon_framebuffer(old_fb);
+	if (!atomic && fb && fb != crtc->fb) {
+		radeon_fb = to_radeon_framebuffer(fb);
 		rbo = radeon_fb->obj->driver_private;
 		r = radeon_bo_reserve(rbo, false);
 		if (unlikely(r != 0))
@@ -1040,6 +1061,7 @@ static const struct drm_crtc_helper_funcs legacy_helper_funcs = {
 	.mode_fixup = radeon_crtc_mode_fixup,
 	.mode_set = radeon_crtc_mode_set,
 	.mode_set_base = radeon_crtc_set_base,
+	.mode_set_base_atomic = radeon_crtc_set_base_atomic,
 	.prepare = radeon_crtc_prepare,
 	.commit = radeon_crtc_commit,
 	.load_lut = radeon_crtc_load_lut,
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
index 17a6602..9dd27c2 100644
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -514,6 +514,9 @@ extern void radeon_encoder_set_active_device(struct drm_encoder *encoder);
 extern void radeon_crtc_load_lut(struct drm_crtc *crtc);
 extern int atombios_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 				   struct drm_framebuffer *old_fb);
+extern int atombios_crtc_set_base_atomic(struct drm_crtc *crtc,
+					 struct drm_framebuffer *fb,
+					 int x, int y);
 extern int atombios_crtc_mode_set(struct drm_crtc *crtc,
 				   struct drm_display_mode *mode,
 				   struct drm_display_mode *adjusted_mode,
@@ -523,7 +526,12 @@ extern void atombios_crtc_dpms(struct drm_crtc *crtc, int mode);
 
 extern int radeon_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 				 struct drm_framebuffer *old_fb);
-
+extern int radeon_crtc_set_base_atomic(struct drm_crtc *crtc,
+				       struct drm_framebuffer *fb,
+				       int x, int y);
+extern int radeon_crtc_do_set_base(struct drm_crtc *crtc,
+				   struct drm_framebuffer *fb,
+				   int x, int y, int atomic);
 extern int radeon_crtc_cursor_set(struct drm_crtc *crtc,
 				  struct drm_file *file_priv,
 				  uint32_t handle,
-- 
1.6.3.3

