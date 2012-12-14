Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab2LNLBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:01:09 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:49660 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab2LNLBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:01:07 -0500
Subject: [PATCH] drm/fb: avoid sleeping in unblank_screen() if oops in progress
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: David Airlie <airlied@linux.ie>, Andrew Morton <akpm@linux-foundation.org>,
        dri-devel@lists.freedesktop.org
Date: Fri, 14 Dec 2012 15:01:00 +0400
Message-ID: <20121214110100.7836.65250.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unblank_screen() can be called from interrupt context during oops.
thus all ->fb_blank handlers should avoid sleeping in this situation.

callstack:
panic()
bust_spinlocks(1)
unblank_screen()
vc->vc_sw->con_blank()
fbcon_blank()
fb_blank()
info->fbops->fb_blank()
drm_fb_helper_blank()
drm_fb_helper_dpms()
mutex_lock(&dev->mode_config.mutex)

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/drm_fb_helper.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 954d175..2c9f49f 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -326,7 +326,7 @@ static struct sysrq_key_op sysrq_drm_fb_helper_restore_op = {
 static struct sysrq_key_op sysrq_drm_fb_helper_restore_op = { };
 #endif
 
-static void drm_fb_helper_dpms(struct fb_info *info, int dpms_mode)
+static int drm_fb_helper_dpms(struct fb_info *info, int dpms_mode)
 {
 	struct drm_fb_helper *fb_helper = info->par;
 	struct drm_device *dev = fb_helper->dev;
@@ -334,10 +334,15 @@ static void drm_fb_helper_dpms(struct fb_info *info, int dpms_mode)
 	struct drm_connector *connector;
 	int i, j;
 
+	if (oops_in_progress) {
+		if (!mutex_trylock(&dev->mode_config.mutex))
+			return -EBUSY;
+	} else
+		mutex_lock(&dev->mode_config.mutex);
+
 	/*
 	 * For each CRTC in this fb, turn the connectors on/off.
 	 */
-	mutex_lock(&dev->mode_config.mutex);
 	for (i = 0; i < fb_helper->crtc_count; i++) {
 		crtc = fb_helper->crtc_info[i].mode_set.crtc;
 
@@ -353,6 +358,7 @@ static void drm_fb_helper_dpms(struct fb_info *info, int dpms_mode)
 		}
 	}
 	mutex_unlock(&dev->mode_config.mutex);
+	return 0;
 }
 
 int drm_fb_helper_blank(int blank, struct fb_info *info)
@@ -360,24 +366,19 @@ int drm_fb_helper_blank(int blank, struct fb_info *info)
 	switch (blank) {
 	/* Display: On; HSync: On, VSync: On */
 	case FB_BLANK_UNBLANK:
-		drm_fb_helper_dpms(info, DRM_MODE_DPMS_ON);
-		break;
+		return drm_fb_helper_dpms(info, DRM_MODE_DPMS_ON);
 	/* Display: Off; HSync: On, VSync: On */
 	case FB_BLANK_NORMAL:
-		drm_fb_helper_dpms(info, DRM_MODE_DPMS_STANDBY);
-		break;
+		return drm_fb_helper_dpms(info, DRM_MODE_DPMS_STANDBY);
 	/* Display: Off; HSync: Off, VSync: On */
 	case FB_BLANK_HSYNC_SUSPEND:
-		drm_fb_helper_dpms(info, DRM_MODE_DPMS_STANDBY);
-		break;
+		return drm_fb_helper_dpms(info, DRM_MODE_DPMS_STANDBY);
 	/* Display: Off; HSync: On, VSync: Off */
 	case FB_BLANK_VSYNC_SUSPEND:
-		drm_fb_helper_dpms(info, DRM_MODE_DPMS_SUSPEND);
-		break;
+		return drm_fb_helper_dpms(info, DRM_MODE_DPMS_SUSPEND);
 	/* Display: Off; HSync: Off, VSync: Off */
 	case FB_BLANK_POWERDOWN:
-		drm_fb_helper_dpms(info, DRM_MODE_DPMS_OFF);
-		break;
+		return drm_fb_helper_dpms(info, DRM_MODE_DPMS_OFF);
 	}
 	return 0;
 }

