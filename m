Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab1KDMMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:12:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33331 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1KDMJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:09:54 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-0f-4eb3d61093c4
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        airlied@redhat.com
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com, jy0922.shim@samsung.com,
        inki.dae@samsung.com
Subject: [PATCH 05/10] drm/exynos: added manager object to connector
Date: Fri, 04 Nov 2011 21:09:54 +0900
Message-id: <1320408599-7475-6-git-send-email-sw0312.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1320408599-7475-1-git-send-email-sw0312.kim@samsung.com>
References: <1320408599-7475-1-git-send-email-sw0312.kim@samsung.com>
X-OriginalArrivalTime: 04 Nov 2011 12:09:38.0169 (UTC)
 FILETIME=[9FD87690:01CC9AEA]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Inki Dae <inki.dae@samsung.com>

connector contains some contents for display controller so the connector also
should be able to access contoroller through manager.

Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_connector.c |   38 ++++++++++++++++++++----
 drivers/gpu/drm/exynos/exynos_drm_encoder.c   |    3 +-
 2 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_connector.c b/drivers/gpu/drm/exynos/exynos_drm_connector.c
index 7ca1274..d33f803 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_connector.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_connector.c
@@ -37,6 +37,8 @@
 
 struct exynos_drm_connector {
 	struct drm_connector	drm_connector;
+	uint32_t		encoder_id;
+	struct exynos_drm_manager *manager;
 };
 
 /* convert exynos_video_timings to drm_display_mode */
@@ -99,8 +101,9 @@ convert_to_video_timing(struct fb_videomode *timing,
 
 static int exynos_drm_connector_get_modes(struct drm_connector *connector)
 {
-	struct exynos_drm_manager *manager =
-				exynos_drm_get_manager(connector->encoder);
+	struct exynos_drm_connector *exynos_connector =
+					to_exynos_connector(connector);
+	struct exynos_drm_manager *manager = exynos_connector->manager;
 	struct exynos_drm_display *display = manager->display;
 	unsigned int count;
 
@@ -169,8 +172,9 @@ static int exynos_drm_connector_get_modes(struct drm_connector *connector)
 static int exynos_drm_connector_mode_valid(struct drm_connector *connector,
 					    struct drm_display_mode *mode)
 {
-	struct exynos_drm_manager *manager =
-				exynos_drm_get_manager(connector->encoder);
+	struct exynos_drm_connector *exynos_connector =
+					to_exynos_connector(connector);
+	struct exynos_drm_manager *manager = exynos_connector->manager;
 	struct exynos_drm_display *display = manager->display;
 	struct fb_videomode timing;
 	int ret = MODE_BAD;
@@ -188,9 +192,25 @@ static int exynos_drm_connector_mode_valid(struct drm_connector *connector,
 
 struct drm_encoder *exynos_drm_best_encoder(struct drm_connector *connector)
 {
+	struct drm_device *dev = connector->dev;
+	struct exynos_drm_connector *exynos_connector =
+					to_exynos_connector(connector);
+	struct drm_mode_object *obj;
+	struct drm_encoder *encoder;
+
 	DRM_DEBUG_KMS("%s\n", __FILE__);
 
-	return connector->encoder;
+	obj = drm_mode_object_find(dev, exynos_connector->encoder_id,
+				   DRM_MODE_OBJECT_ENCODER);
+	if (!obj) {
+		DRM_DEBUG_KMS("Unknown ENCODER ID %d\n",
+				exynos_connector->encoder_id);
+		return NULL;
+	}
+
+	encoder = obj_to_encoder(obj);
+
+	return encoder;
 }
 
 static struct drm_connector_helper_funcs exynos_connector_helper_funcs = {
@@ -203,8 +223,9 @@ static struct drm_connector_helper_funcs exynos_connector_helper_funcs = {
 static enum drm_connector_status
 exynos_drm_connector_detect(struct drm_connector *connector, bool force)
 {
-	struct exynos_drm_manager *manager =
-				exynos_drm_get_manager(connector->encoder);
+	struct exynos_drm_connector *exynos_connector =
+					to_exynos_connector(connector);
+	struct exynos_drm_manager *manager = exynos_connector->manager;
 	struct exynos_drm_display *display = manager->display;
 	enum drm_connector_status status = connector_status_disconnected;
 
@@ -276,7 +297,10 @@ struct drm_connector *exynos_drm_connector_create(struct drm_device *dev,
 	if (err)
 		goto err_connector;
 
+	exynos_connector->encoder_id = encoder->base.id;
+	exynos_connector->manager = manager;
 	connector->encoder = encoder;
+
 	err = drm_mode_connector_attach_encoder(connector, encoder);
 	if (err) {
 		DRM_ERROR("failed to attach a connector to a encoder\n");
diff --git a/drivers/gpu/drm/exynos/exynos_drm_encoder.c b/drivers/gpu/drm/exynos/exynos_drm_encoder.c
index 7cf6fa8..4e5535b 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_encoder.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_encoder.c
@@ -58,7 +58,8 @@ static void exynos_drm_encoder_dpms(struct drm_encoder *encoder, int mode)
 
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
 		if (connector->encoder == encoder) {
-			struct exynos_drm_display *display = manager->display;
+			struct exynos_drm_display *display =
+							manager->display;
 
 			if (display && display->power_on)
 				display->power_on(manager->dev, mode);
-- 
1.7.4.1

