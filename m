Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab1ANXiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 18:38:11 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:43955 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335Ab1ANXiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 18:38:09 -0500
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Jan 2011 18:38:09 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAM9qME120B2O/2dsb2JhbACkXHSwMYpvhU8EixaFLA
From: Dave Airlie <airlied@linux.ie>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH] Revert "drm: Update fbdev fb_fix_screeninfo"
Date: Sat, 15 Jan 2011 09:27:00 +1000
Message-Id: <1295047620-26381-1-git-send-email-airlied@linux.ie>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

This reverts commit dfe63bb0ad9810db13aab0058caba97866e0a681.

This commit was causing nouveau not to work properly, for -rc1 I'd prefer it
worked and we can look if this is useful for 2.6.39.

Cc: James Simmons <jsimmons@infradead.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/drm_fb_helper.c         |   41 +++++++++++++++----------------
 drivers/gpu/drm/i915/intel_fb.c         |    1 +
 drivers/gpu/drm/nouveau/nouveau_fbcon.c |    1 +
 drivers/gpu/drm/radeon/radeon_fb.c      |    2 +
 include/drm/drm_fb_helper.h             |    3 ++
 5 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 0307d60..5c4f9b9 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -607,25 +607,6 @@ void drm_fb_helper_fini(struct drm_fb_helper *fb_helper)
 }
 EXPORT_SYMBOL(drm_fb_helper_fini);
 
-void drm_fb_helper_fill_fix(struct fb_info *info, struct drm_framebuffer *fb)
-{
-	info->fix.type = FB_TYPE_PACKED_PIXELS;
-	info->fix.visual = fb->depth == 8 ? FB_VISUAL_PSEUDOCOLOR :
-		FB_VISUAL_TRUECOLOR;
-	info->fix.mmio_start = 0;
-	info->fix.mmio_len = 0;
-	info->fix.type_aux = 0;
-	info->fix.xpanstep = 1; /* doing it in hw */
-	info->fix.ypanstep = 1; /* doing it in hw */
-	info->fix.ywrapstep = 0;
-	info->fix.accel = FB_ACCEL_NONE;
-	info->fix.type_aux = 0;
-
-	info->fix.line_length = fb->pitch;
-	return;
-}
-EXPORT_SYMBOL(drm_fb_helper_fill_fix);
-
 static int setcolreg(struct drm_crtc *crtc, u16 red, u16 green,
 		     u16 blue, u16 regno, struct fb_info *info)
 {
@@ -835,7 +816,6 @@ int drm_fb_helper_set_par(struct fb_info *info)
 			mutex_unlock(&dev->mode_config.mutex);
 			return ret;
 		}
-		drm_fb_helper_fill_fix(info, fb_helper->fb);
 	}
 	mutex_unlock(&dev->mode_config.mutex);
 
@@ -973,7 +953,6 @@ int drm_fb_helper_single_fb_probe(struct drm_fb_helper *fb_helper,
 
 	if (new_fb) {
 		info->var.pixclock = 0;
-		drm_fb_helper_fill_fix(info, fb_helper->fb);
 		if (register_framebuffer(info) < 0) {
 			return -EINVAL;
 		}
@@ -1000,6 +979,26 @@ int drm_fb_helper_single_fb_probe(struct drm_fb_helper *fb_helper,
 }
 EXPORT_SYMBOL(drm_fb_helper_single_fb_probe);
 
+void drm_fb_helper_fill_fix(struct fb_info *info, uint32_t pitch,
+			    uint32_t depth)
+{
+	info->fix.type = FB_TYPE_PACKED_PIXELS;
+	info->fix.visual = depth == 8 ? FB_VISUAL_PSEUDOCOLOR :
+		FB_VISUAL_TRUECOLOR;
+	info->fix.mmio_start = 0;
+	info->fix.mmio_len = 0;
+	info->fix.type_aux = 0;
+	info->fix.xpanstep = 1; /* doing it in hw */
+	info->fix.ypanstep = 1; /* doing it in hw */
+	info->fix.ywrapstep = 0;
+	info->fix.accel = FB_ACCEL_NONE;
+	info->fix.type_aux = 0;
+
+	info->fix.line_length = pitch;
+	return;
+}
+EXPORT_SYMBOL(drm_fb_helper_fill_fix);
+
 void drm_fb_helper_fill_var(struct fb_info *info, struct drm_fb_helper *fb_helper,
 			    uint32_t fb_width, uint32_t fb_height)
 {
diff --git a/drivers/gpu/drm/i915/intel_fb.c b/drivers/gpu/drm/i915/intel_fb.c
index ee145a2..5127827 100644
--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -148,6 +148,7 @@ static int intelfb_create(struct intel_fbdev *ifbdev,
 
 //	memset(info->screen_base, 0, size);
 
+	drm_fb_helper_fill_fix(info, fb->pitch, fb->depth);
 	drm_fb_helper_fill_var(info, &ifbdev->helper, sizes->fb_width, sizes->fb_height);
 
 	info->pixmap.size = 64*1024;
diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index a26d047..6d56a54 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -359,6 +359,7 @@ nouveau_fbcon_create(struct nouveau_fbdev *nfbdev,
 	info->screen_base = nvbo_kmap_obj_iovirtual(nouveau_fb->nvbo);
 	info->screen_size = size;
 
+	drm_fb_helper_fill_fix(info, fb->pitch, fb->depth);
 	drm_fb_helper_fill_var(info, &nfbdev->helper, sizes->fb_width, sizes->fb_height);
 
 	/* Set aperture base/size for vesafb takeover */
diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/radeon_fb.c
index ca32e9c..66324b5 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -225,6 +225,8 @@ static int radeonfb_create(struct radeon_fbdev *rfbdev,
 
 	strcpy(info->fix.id, "radeondrmfb");
 
+	drm_fb_helper_fill_fix(info, fb->pitch, fb->depth);
+
 	info->flags = FBINFO_DEFAULT | FBINFO_CAN_FORCE_OUTPUT;
 	info->fbops = &radeonfb_ops;
 
diff --git a/include/drm/drm_fb_helper.h b/include/drm/drm_fb_helper.h
index aac27bd..f22e7fe 100644
--- a/include/drm/drm_fb_helper.h
+++ b/include/drm/drm_fb_helper.h
@@ -121,6 +121,9 @@ int drm_fb_helper_setcolreg(unsigned regno,
 void drm_fb_helper_restore(void);
 void drm_fb_helper_fill_var(struct fb_info *info, struct drm_fb_helper *fb_helper,
 			    uint32_t fb_width, uint32_t fb_height);
+void drm_fb_helper_fill_fix(struct fb_info *info, uint32_t pitch,
+			    uint32_t depth);
+
 int drm_fb_helper_setcmap(struct fb_cmap *cmap, struct fb_info *info);
 
 bool drm_fb_helper_hotplug_event(struct drm_fb_helper *fb_helper);
-- 
1.7.2.3

