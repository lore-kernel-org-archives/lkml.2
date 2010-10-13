Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab0JMTLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 15:11:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:38217 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab0JMTKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 15:10:00 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: airlied@linux.ie
Cc: jbarnes@virtuousgeek.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 3/3] drm,kdb,kms: Change mode_set_base_atomic() enter argument to be an enum
Date: Wed, 13 Oct 2010 14:09:44 -0500
Message-Id: <1286996984-21987-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1286996984-21987-1-git-send-email-jason.wessel@windriver.com>
References: <1286996984-21987-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 13 Oct 2010 19:09:58.0565 (UTC) FILETIME=[3A823D50:01CB6B0A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The enter argument as implemented by commit 413d45d3627 (drm, kdb, kms:
Add an enter argument to mode_set_base_atomic() API) should be more
descriptive as to what it does vs just passing 1 and 0 around.

There is no runtime behavior change as a result of this patch.

Reported-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
CC: David Airlie <airlied@linux.ie>
CC: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/drm_fb_helper.c             |    5 ++---
 drivers/gpu/drm/i915/intel_display.c        |    5 +++--
 drivers/gpu/drm/nouveau/nv04_crtc.c         |    4 ++--
 drivers/gpu/drm/nouveau/nv50_crtc.c         |    2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c      |    2 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    2 +-
 drivers/gpu/drm/radeon/radeon_mode.h        |    7 +++++--
 include/drm/drm_crtc_helper.h               |    7 ++++++-
 8 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 8208e19..d2849e4 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -289,8 +289,7 @@ int drm_fb_helper_debug_enter(struct fb_info *info)
 						    mode_set->fb,
 						    mode_set->x,
 						    mode_set->y,
-						    1);
-
+						    ENTER_ATOMIC_MODE_SET);
 		}
 	}
 
@@ -336,7 +335,7 @@ int drm_fb_helper_debug_leave(struct fb_info *info)
 
 		drm_fb_helper_restore_lut_atomic(mode_set->crtc);
 		funcs->mode_set_base_atomic(mode_set->crtc, fb, crtc->x,
-					    crtc->y, 0);
+					    crtc->y, LEAVE_ATOMIC_MODE_SET);
 	}
 
 	return 0;
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 9109c00..96d08a9 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1492,7 +1492,7 @@ err_unpin:
 /* Assume fb object is pinned & idle & fenced and just update base pointers */
 static int
 intel_pipe_set_base_atomic(struct drm_crtc *crtc, struct drm_framebuffer *fb,
-			   int x, int y, int enter)
+			   int x, int y, enum mode_set_atomic state)
 {
 	struct drm_device *dev = crtc->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -1614,7 +1614,8 @@ intel_pipe_set_base(struct drm_crtc *crtc, int x, int y,
 			   atomic_read(&obj_priv->pending_flip) == 0);
 	}
 
-	ret = intel_pipe_set_base_atomic(crtc, crtc->fb, x, y, 0);
+	ret = intel_pipe_set_base_atomic(crtc, crtc->fb, x, y,
+					 LEAVE_ATOMIC_MODE_SET);
 	if (ret) {
 		i915_gem_object_unpin(to_intel_framebuffer(crtc->fb)->obj);
 		mutex_unlock(&dev->struct_mutex);
diff --git a/drivers/gpu/drm/nouveau/nv04_crtc.c b/drivers/gpu/drm/nouveau/nv04_crtc.c
index 17f7cf0..c71abc2 100644
--- a/drivers/gpu/drm/nouveau/nv04_crtc.c
+++ b/drivers/gpu/drm/nouveau/nv04_crtc.c
@@ -860,12 +860,12 @@ nv04_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
 static int
 nv04_crtc_mode_set_base_atomic(struct drm_crtc *crtc,
 			       struct drm_framebuffer *fb,
-			       int x, int y, int enter)
+			       int x, int y, enum mode_set_atomic state)
 {
 	struct drm_nouveau_private *dev_priv = crtc->dev->dev_private;
 	struct drm_device *dev = dev_priv->dev;
 
-	if (enter)
+	if (state == ENTER_ATOMIC_MODE_SET)
 		nouveau_fbcon_save_disable_accel(dev);
 	else
 		nouveau_fbcon_restore_accel(dev);
diff --git a/drivers/gpu/drm/nouveau/nv50_crtc.c b/drivers/gpu/drm/nouveau/nv50_crtc.c
index ba91bef..16380d5 100644
--- a/drivers/gpu/drm/nouveau/nv50_crtc.c
+++ b/drivers/gpu/drm/nouveau/nv50_crtc.c
@@ -708,7 +708,7 @@ nv50_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
 static int
 nv50_crtc_mode_set_base_atomic(struct drm_crtc *crtc,
 			       struct drm_framebuffer *fb,
-			       int x, int y, int enter)
+			       int x, int y, enum mode_set_atomic state)
 {
 	return nv50_crtc_do_mode_set_base(crtc, fb, x, y, true, true);
 }
diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index 037e326..348b367 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -1258,7 +1258,7 @@ int atombios_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 
 int atombios_crtc_set_base_atomic(struct drm_crtc *crtc,
                                   struct drm_framebuffer *fb,
-                                  int x, int y, int enter)
+				  int x, int y, enum mode_set_atomic state)
 {
        struct drm_device *dev = crtc->dev;
        struct radeon_device *rdev = dev->dev_private;
diff --git a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
index 590f6a1..793d880 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
@@ -353,7 +353,7 @@ int radeon_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 
 int radeon_crtc_set_base_atomic(struct drm_crtc *crtc,
 				struct drm_framebuffer *fb,
-				int x, int y, int enter)
+				int x, int y, enum mode_set_atomic state)
 {
 	return radeon_crtc_do_set_base(crtc, fb, x, y, 1);
 }
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
index 94eb184..e1113a9 100644
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -35,6 +35,7 @@
 #include <drm_edid.h>
 #include <drm_dp_helper.h>
 #include <drm_fixed.h>
+#include <drm_crtc_helper.h>
 #include <linux/i2c.h>
 #include <linux/i2c-id.h>
 #include <linux/i2c-algo-bit.h>
@@ -520,7 +521,8 @@ extern int atombios_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 				   struct drm_framebuffer *old_fb);
 extern int atombios_crtc_set_base_atomic(struct drm_crtc *crtc,
 					 struct drm_framebuffer *fb,
-					 int x, int y, int enter);
+					 int x, int y,
+					 enum mode_set_atomic state);
 extern int atombios_crtc_mode_set(struct drm_crtc *crtc,
 				   struct drm_display_mode *mode,
 				   struct drm_display_mode *adjusted_mode,
@@ -532,7 +534,8 @@ extern int radeon_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 				 struct drm_framebuffer *old_fb);
 extern int radeon_crtc_set_base_atomic(struct drm_crtc *crtc,
 				       struct drm_framebuffer *fb,
-				       int x, int y, int enter);
+				       int x, int y,
+				       enum mode_set_atomic state);
 extern int radeon_crtc_do_set_base(struct drm_crtc *crtc,
 				   struct drm_framebuffer *fb,
 				   int x, int y, int atomic);
diff --git a/include/drm/drm_crtc_helper.h b/include/drm/drm_crtc_helper.h
index 6a9f393..73b0712 100644
--- a/include/drm/drm_crtc_helper.h
+++ b/include/drm/drm_crtc_helper.h
@@ -39,6 +39,11 @@
 
 #include <linux/fb.h>
 
+enum mode_set_atomic {
+	LEAVE_ATOMIC_MODE_SET,
+	ENTER_ATOMIC_MODE_SET,
+};
+
 struct drm_crtc_helper_funcs {
 	/*
 	 * Control power levels on the CRTC.  If the mode passed in is
@@ -62,7 +67,7 @@ struct drm_crtc_helper_funcs {
 			     struct drm_framebuffer *old_fb);
 	int (*mode_set_base_atomic)(struct drm_crtc *crtc,
 				    struct drm_framebuffer *fb, int x, int y,
-				    int is_enter);
+				    enum mode_set_atomic);
 
 	/* reload the current crtc LUT */
 	void (*load_lut)(struct drm_crtc *crtc);
-- 
1.6.3.3

