Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107Ab0JLSQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 14:16:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:59716 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab0JLSQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 14:16:18 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: airlied@linux.ie
Cc: jbarnes@virtuousgeek.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 3/5] drm,kdb,kms: Add an enter argument to mode_set_base_atomic() API
Date: Tue, 12 Oct 2010 13:15:46 -0500
Message-Id: <1286907348-25817-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1286907348-25817-1-git-send-email-jason.wessel@windriver.com>
References: <1286907348-25817-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Oct 2010 18:16:12.0017 (UTC) FILETIME=[8CEC5610:01CB6A39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices such as the pre nv02 chips have enter and exit
constraints where hardware compression must be turned off and
re-enabled on resuming normal operations.

This patch extends the mode_set_base_atomic() call to pass an argument
to indicate if this is an entry or an exit from an atomic kernel mode
set change.  Individual drm drivers can properly save and restore
state accordingly.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: David Airlie <airlied@linux.ie>
CC: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/drm_fb_helper.c             |    5 +++--
 drivers/gpu/drm/i915/intel_display.c        |    5 +++--
 drivers/gpu/drm/nouveau/nv04_crtc.c         |    2 +-
 drivers/gpu/drm/nouveau/nv50_crtc.c         |    2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c      |    2 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    2 +-
 drivers/gpu/drm/radeon/radeon_mode.h        |    7 +++++--
 include/drm/drm_crtc_helper.h               |    8 +++++++-
 8 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 6a5e403..74bac82 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -263,7 +263,8 @@ int drm_fb_helper_debug_enter(struct fb_info *info)
 			funcs->mode_set_base_atomic(mode_set->crtc,
 						    mode_set->fb,
 						    mode_set->x,
-						    mode_set->y);
+						    mode_set->y,
+						    ENTER_ATOMIC_MODE_SET);
 
 		}
 	}
@@ -309,7 +310,7 @@ int drm_fb_helper_debug_leave(struct fb_info *info)
 		}
 
 		funcs->mode_set_base_atomic(mode_set->crtc, fb, crtc->x,
-					    crtc->y);
+					    crtc->y, LEAVE_ATOMIC_MODE_SET);
 	}
 
 	return 0;
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 9792285..eee0fa6 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1458,7 +1458,7 @@ intel_pin_and_fence_fb_obj(struct drm_device *dev, struct drm_gem_object *obj)
 /* Assume fb object is pinned & idle & fenced and just update base pointers */
 static int
 intel_pipe_set_base_atomic(struct drm_crtc *crtc, struct drm_framebuffer *fb,
-			   int x, int y)
+			   int x, int y, enum mode_set_atomic state)
 {
 	struct drm_device *dev = crtc->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -1593,7 +1593,8 @@ intel_pipe_set_base(struct drm_crtc *crtc, int x, int y,
 		return ret;
 	}
 
-	ret = intel_pipe_set_base_atomic(crtc, crtc->fb, x, y);
+	ret = intel_pipe_set_base_atomic(crtc, crtc->fb, x, y,
+					 LEAVE_ATOMIC_MODE_SET);
 	if (ret) {
 		i915_gem_object_unpin(obj);
 		mutex_unlock(&dev->struct_mutex);
diff --git a/drivers/gpu/drm/nouveau/nv04_crtc.c b/drivers/gpu/drm/nouveau/nv04_crtc.c
index 9d214f5..dc44ccc 100644
--- a/drivers/gpu/drm/nouveau/nv04_crtc.c
+++ b/drivers/gpu/drm/nouveau/nv04_crtc.c
@@ -857,7 +857,7 @@ nv04_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
 static int
 nv04_crtc_mode_set_base_atomic(struct drm_crtc *crtc,
 			       struct drm_framebuffer *fb,
-			       int x, int y)
+			       int x, int y, enum mode_set_atomic state)
 {
 	return nv04_crtc_do_mode_set_base(crtc, fb, x, y, true);
 }
diff --git a/drivers/gpu/drm/nouveau/nv50_crtc.c b/drivers/gpu/drm/nouveau/nv50_crtc.c
index a75f25f..fe75e8f 100644
--- a/drivers/gpu/drm/nouveau/nv50_crtc.c
+++ b/drivers/gpu/drm/nouveau/nv50_crtc.c
@@ -711,7 +711,7 @@ nv50_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
 static int
 nv50_crtc_mode_set_base_atomic(struct drm_crtc *crtc,
 			       struct drm_framebuffer *fb,
-			       int x, int y)
+			       int x, int y, enum mode_set_atomic state)
 {
 	return nv50_crtc_do_mode_set_base(crtc, fb, x, y, true, true);
 }
diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index 58f7b15..18d4324 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -1178,7 +1178,7 @@ int atombios_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 
 int atombios_crtc_set_base_atomic(struct drm_crtc *crtc,
 				  struct drm_framebuffer *fb,
-				  int x, int y)
+				  int x, int y, enum mode_set_atomic state)
 {
 	struct drm_device *dev = crtc->dev;
 	struct radeon_device *rdev = dev->dev_private;
diff --git a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
index 555c055..eb52f27 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
@@ -353,7 +353,7 @@ int radeon_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 
 int radeon_crtc_set_base_atomic(struct drm_crtc *crtc,
 				struct drm_framebuffer *fb,
-				int x, int y)
+				int x, int y, enum mode_set_atomic state)
 {
 	return radeon_crtc_do_set_base(crtc, fb, x, y, 1);
 }
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
index 9dd27c2..9d5d780 100644
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
@@ -516,7 +517,8 @@ extern int atombios_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 				   struct drm_framebuffer *old_fb);
 extern int atombios_crtc_set_base_atomic(struct drm_crtc *crtc,
 					 struct drm_framebuffer *fb,
-					 int x, int y);
+					 int x, int y,
+					 enum mode_set_atomic state);
 extern int atombios_crtc_mode_set(struct drm_crtc *crtc,
 				   struct drm_display_mode *mode,
 				   struct drm_display_mode *adjusted_mode,
@@ -528,7 +530,8 @@ extern int radeon_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 				 struct drm_framebuffer *old_fb);
 extern int radeon_crtc_set_base_atomic(struct drm_crtc *crtc,
 				       struct drm_framebuffer *fb,
-				       int x, int y);
+				       int x, int y,
+				       enum mode_set_atomic state);
 extern int radeon_crtc_do_set_base(struct drm_crtc *crtc,
 				   struct drm_framebuffer *fb,
 				   int x, int y, int atomic);
diff --git a/include/drm/drm_crtc_helper.h b/include/drm/drm_crtc_helper.h
index 59b7073..73b0712 100644
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
@@ -61,7 +66,8 @@ struct drm_crtc_helper_funcs {
 	int (*mode_set_base)(struct drm_crtc *crtc, int x, int y,
 			     struct drm_framebuffer *old_fb);
 	int (*mode_set_base_atomic)(struct drm_crtc *crtc,
-				    struct drm_framebuffer *fb, int x, int y);
+				    struct drm_framebuffer *fb, int x, int y,
+				    enum mode_set_atomic);
 
 	/* reload the current crtc LUT */
 	void (*load_lut)(struct drm_crtc *crtc);
-- 
1.6.3.3

