Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab1KDMK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:10:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23338 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab1KDMJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:09:56 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-17-4eb3d611e040
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        airlied@redhat.com
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com, jy0922.shim@samsung.com,
        inki.dae@samsung.com
Subject: [PATCH 09/10] drm/exynos: added crtc dpms for disable crtc
Date: Fri, 04 Nov 2011 21:09:58 +0900
Message-id: <1320408599-7475-10-git-send-email-sw0312.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1320408599-7475-1-git-send-email-sw0312.kim@samsung.com>
References: <1320408599-7475-1-git-send-email-sw0312.kim@samsung.com>
X-OriginalArrivalTime: 04 Nov 2011 12:09:38.0216 (UTC)
 FILETIME=[9FDFA280:01CC9AEA]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

crtc dpms is called as destroying attached fb so dpms off sould be processed.
crtc dpms also can be called after crtc is detached from encoder so pipe value
of manager is used to find display controller for this case

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_crtc.c    |   16 ++++++--
 drivers/gpu/drm/exynos/exynos_drm_encoder.c |   53 +++++++++++++++++++++++----
 drivers/gpu/drm/exynos/exynos_drm_encoder.h |    1 +
 3 files changed, 59 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_crtc.c b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
index 9337e5e..db541a5 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_crtc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
@@ -85,7 +85,8 @@ static void exynos_drm_crtc_apply(struct drm_crtc *crtc)
 
 	exynos_drm_fn_encoder(crtc, overlay,
 			exynos_drm_encoder_crtc_mode_set);
-	exynos_drm_fn_encoder(crtc, NULL, exynos_drm_encoder_crtc_commit);
+	exynos_drm_fn_encoder(crtc, &exynos_crtc->pipe,
+			exynos_drm_encoder_crtc_commit);
 }
 
 static int exynos_drm_overlay_update(struct exynos_drm_overlay *overlay,
@@ -171,9 +172,13 @@ static int exynos_drm_crtc_update(struct drm_crtc *crtc)
 
 static void exynos_drm_crtc_dpms(struct drm_crtc *crtc, int mode)
 {
-	DRM_DEBUG_KMS("%s\n", __FILE__);
+	DRM_DEBUG_KMS("crtc[%d] mode[%d]\n", crtc->base.id, mode);
 
-	/* TODO */
+	if (mode == DRM_MODE_DPMS_OFF) {
+		DRM_DEBUG_KMS("crtc[%d] disable\n", crtc->base.id);
+		exynos_drm_fn_encoder(crtc, NULL,
+				exynos_drm_encoder_crtc_disable);
+	}
 }
 
 static void exynos_drm_crtc_prepare(struct drm_crtc *crtc)
@@ -185,9 +190,12 @@ static void exynos_drm_crtc_prepare(struct drm_crtc *crtc)
 
 static void exynos_drm_crtc_commit(struct drm_crtc *crtc)
 {
+	struct exynos_drm_crtc *exynos_crtc = to_exynos_crtc(crtc);
+
 	DRM_DEBUG_KMS("%s\n", __FILE__);
 
-	/* drm framework doesn't check NULL. */
+	exynos_drm_fn_encoder(crtc, &exynos_crtc->pipe,
+			exynos_drm_encoder_crtc_commit);
 }
 
 static bool
diff --git a/drivers/gpu/drm/exynos/exynos_drm_encoder.c b/drivers/gpu/drm/exynos/exynos_drm_encoder.c
index 0034fa7..4092f41 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_encoder.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_encoder.c
@@ -61,6 +61,8 @@ static void exynos_drm_encoder_dpms(struct drm_encoder *encoder, int mode)
 			struct exynos_drm_display_ops *display_ops =
 							manager->display_ops;
 
+			DRM_DEBUG_KMS("connector[%d] dpms[%d]\n",
+					connector->base.id, mode);
 			if (display_ops && display_ops->power_on)
 				display_ops->power_on(manager->dev, mode);
 		}
@@ -117,15 +119,11 @@ static void exynos_drm_encoder_commit(struct drm_encoder *encoder)
 {
 	struct exynos_drm_manager *manager = exynos_drm_get_manager(encoder);
 	struct exynos_drm_manager_ops *manager_ops = manager->ops;
-	struct exynos_drm_overlay_ops *overlay_ops = manager->overlay_ops;
 
 	DRM_DEBUG_KMS("%s\n", __FILE__);
 
 	if (manager_ops && manager_ops->commit)
 		manager_ops->commit(manager->dev);
-
-	if (overlay_ops && overlay_ops->commit)
-		overlay_ops->commit(manager->dev);
 }
 
 static struct drm_crtc *
@@ -209,10 +207,30 @@ void exynos_drm_fn_encoder(struct drm_crtc *crtc, void *data,
 {
 	struct drm_device *dev = crtc->dev;
 	struct drm_encoder *encoder;
+	struct exynos_drm_private *private = dev->dev_private;
+	struct exynos_drm_manager *manager;
 
 	list_for_each_entry(encoder, &dev->mode_config.encoder_list, head) {
-		if (encoder->crtc != crtc)
-			continue;
+		/*
+		 * if crtc is detached from encoder, check pipe,
+		 * otherwise check crtc attached to encoder
+		 */
+		if (!encoder->crtc) {
+			manager = to_exynos_encoder(encoder)->manager;
+			if (manager->pipe < 0 ||
+					private->crtc[manager->pipe] != crtc)
+				continue;
+
+			/*
+			 * crtc is already detached from encoder and last
+			 * function for detaching is properly selected, so
+			 * clear pipe from manager to prevent repeating call
+			 */
+			manager->pipe = -1;
+		} else {
+			if (encoder->crtc != crtc)
+				continue;
+		}
 
 		fn(encoder, data);
 	}
@@ -251,8 +269,18 @@ void exynos_drm_encoder_crtc_commit(struct drm_encoder *encoder, void *data)
 	struct exynos_drm_manager *manager =
 		to_exynos_encoder(encoder)->manager;
 	struct exynos_drm_overlay_ops *overlay_ops = manager->overlay_ops;
+	int crtc = *(int *)data;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
 
-	overlay_ops->commit(manager->dev);
+	/*
+	 * when crtc is detached from encoder, this pipe is used
+	 * to select manager operation
+	 */
+	manager->pipe = crtc;
+
+	if (overlay_ops && overlay_ops->commit)
+		overlay_ops->commit(manager->dev);
 }
 
 void exynos_drm_encoder_crtc_mode_set(struct drm_encoder *encoder, void *data)
@@ -265,6 +293,17 @@ void exynos_drm_encoder_crtc_mode_set(struct drm_encoder *encoder, void *data)
 	overlay_ops->mode_set(manager->dev, overlay);
 }
 
+void exynos_drm_encoder_crtc_disable(struct drm_encoder *encoder, void *data)
+{
+	struct exynos_drm_manager *manager =
+		to_exynos_encoder(encoder)->manager;
+	struct exynos_drm_overlay_ops *overlay_ops = manager->overlay_ops;
+
+	DRM_DEBUG_KMS("\n");
+
+	overlay_ops->disable(manager->dev);
+}
+
 MODULE_AUTHOR("Inki Dae <inki.dae@samsung.com>");
 MODULE_AUTHOR("Joonyoung Shim <jy0922.shim@samsung.com>");
 MODULE_AUTHOR("Seung-Woo Kim <sw0312.kim@samsung.com>");
diff --git a/drivers/gpu/drm/exynos/exynos_drm_encoder.h b/drivers/gpu/drm/exynos/exynos_drm_encoder.h
index 5ecd645..a22acfb 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_encoder.h
+++ b/drivers/gpu/drm/exynos/exynos_drm_encoder.h
@@ -41,5 +41,6 @@ void exynos_drm_enable_vblank(struct drm_encoder *encoder, void *data);
 void exynos_drm_disable_vblank(struct drm_encoder *encoder, void *data);
 void exynos_drm_encoder_crtc_commit(struct drm_encoder *encoder, void *data);
 void exynos_drm_encoder_crtc_mode_set(struct drm_encoder *encoder, void *data);
+void exynos_drm_encoder_crtc_disable(struct drm_encoder *encoder, void *data);
 
 #endif
-- 
1.7.4.1

