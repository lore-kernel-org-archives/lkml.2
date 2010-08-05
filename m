Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485Ab0HEOlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:41:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:41903 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933420Ab0HEOlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:41:12 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 5/9] drm: add KGDB/KDB support
Date: Thu,  5 Aug 2010 09:39:54 -0500
Message-Id: <1281019198-6777-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019198-6777-5-git-send-email-jason.wessel@windriver.com>
References: <1281019198-6777-1-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-2-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-3-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-4-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-5-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:40:07.0842 (UTC) FILETIME=[19953820:01CB34AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesse Barnes <jbarnes@virtuousgeek.org>

Implement the callbacks for KDB entry/exit via the drm helpers.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/gpu/drm/drm_fb_helper.c |   74 +++++++++++++++++++++++++++++++++++++++
 include/drm/drm_crtc_helper.h   |    2 +
 include/drm/drm_fb_helper.h     |    5 +++
 3 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 7196620..6245add 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -241,6 +241,80 @@ static int drm_fb_helper_parse_command_line(struct drm_fb_helper *fb_helper)
 	return 0;
 }
 
+int drm_fb_helper_debug_enter(struct fb_info *info)
+{
+	struct drm_fb_helper *helper = info->par;
+	struct drm_crtc_helper_funcs *funcs;
+	int i;
+
+	if (list_empty(&kernel_fb_helper_list))
+		return false;
+
+	list_for_each_entry(helper, &kernel_fb_helper_list, kernel_fb_list) {
+		for (i = 0; i < helper->crtc_count; i++) {
+			struct drm_mode_set *mode_set =
+				&helper->crtc_info[i].mode_set;
+
+			if (!mode_set->crtc->enabled)
+				continue;
+
+			funcs =	mode_set->crtc->helper_private;
+			funcs->mode_set_base_atomic(mode_set->crtc,
+						    mode_set->fb,
+						    mode_set->x,
+						    mode_set->y);
+
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(drm_fb_helper_debug_enter);
+
+/* Find the real fb for a given fb helper CRTC */
+static struct drm_framebuffer *drm_mode_config_fb(struct drm_crtc *crtc)
+{
+	struct drm_device *dev = crtc->dev;
+	struct drm_crtc *c;
+
+	list_for_each_entry(c, &dev->mode_config.crtc_list, head) {
+		if (crtc->base.id == c->base.id)
+			return c->fb;
+	}
+
+	return NULL;
+}
+
+int drm_fb_helper_debug_leave(struct fb_info *info)
+{
+	struct drm_fb_helper *helper = info->par;
+	struct drm_crtc *crtc;
+	struct drm_crtc_helper_funcs *funcs;
+	struct drm_framebuffer *fb;
+	int i;
+
+	for (i = 0; i < helper->crtc_count; i++) {
+		struct drm_mode_set *mode_set = &helper->crtc_info[i].mode_set;
+		crtc = mode_set->crtc;
+		funcs = crtc->helper_private;
+		fb = drm_mode_config_fb(crtc);
+
+		if (!crtc->enabled)
+			continue;
+
+		if (!fb) {
+			DRM_ERROR("no fb to restore??\n");
+			continue;
+		}
+
+		funcs->mode_set_base_atomic(mode_set->crtc, fb, crtc->x,
+					    crtc->y);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(drm_fb_helper_debug_leave);
+
 bool drm_fb_helper_force_kernel_mode(void)
 {
 	int i = 0;
diff --git a/include/drm/drm_crtc_helper.h b/include/drm/drm_crtc_helper.h
index 1121f77..10f7d03 100644
--- a/include/drm/drm_crtc_helper.h
+++ b/include/drm/drm_crtc_helper.h
@@ -60,6 +60,8 @@ struct drm_crtc_helper_funcs {
 	/* Move the crtc on the current fb to the given position *optional* */
 	int (*mode_set_base)(struct drm_crtc *crtc, int x, int y,
 			     struct drm_framebuffer *old_fb);
+	int (*mode_set_base_atomic)(struct drm_crtc *crtc,
+				    struct drm_framebuffer *fb, int x, int y);
 
 	/* reload the current crtc LUT */
 	void (*load_lut)(struct drm_crtc *crtc);
diff --git a/include/drm/drm_fb_helper.h b/include/drm/drm_fb_helper.h
index f0a6afc..f22e7fe 100644
--- a/include/drm/drm_fb_helper.h
+++ b/include/drm/drm_fb_helper.h
@@ -32,6 +32,8 @@
 
 struct drm_fb_helper;
 
+#include <linux/kgdb.h>
+
 struct drm_fb_helper_crtc {
 	uint32_t crtc_id;
 	struct drm_mode_set mode_set;
@@ -78,6 +80,7 @@ struct drm_fb_helper_connector {
 
 struct drm_fb_helper {
 	struct drm_framebuffer *fb;
+	struct drm_framebuffer *saved_fb;
 	struct drm_device *dev;
 	struct drm_display_mode *mode;
 	int crtc_count;
@@ -126,5 +129,7 @@ int drm_fb_helper_setcmap(struct fb_cmap *cmap, struct fb_info *info);
 bool drm_fb_helper_hotplug_event(struct drm_fb_helper *fb_helper);
 bool drm_fb_helper_initial_config(struct drm_fb_helper *fb_helper, int bpp_sel);
 int drm_fb_helper_single_add_all_connectors(struct drm_fb_helper *fb_helper);
+int drm_fb_helper_debug_enter(struct fb_info *info);
+int drm_fb_helper_debug_leave(struct fb_info *info);
 
 #endif
-- 
1.6.4.rc1

