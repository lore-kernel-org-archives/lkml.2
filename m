Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab1KDMJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:09:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48992 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab1KDMJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:09:55 -0400
X-AuditID: cbfee61b-b7b7fae000005864-05-4eb3d611ad28
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        airlied@redhat.com
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com, jy0922.shim@samsung.com,
        inki.dae@samsung.com
Subject: [PATCH 06/10] drm/exynos: changed exynos_drm_display to
 exynos_drm_display_ops
Date: Fri, 04 Nov 2011 21:09:55 +0900
Message-id: <1320408599-7475-7-git-send-email-sw0312.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1320408599-7475-1-git-send-email-sw0312.kim@samsung.com>
References: <1320408599-7475-1-git-send-email-sw0312.kim@samsung.com>
X-OriginalArrivalTime: 04 Nov 2011 12:09:38.0184 (UTC)
 FILETIME=[9FDAC080:01CC9AEA]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Inki Dae <inki.dae@samsung.com>

exynos_drm_display has function pointes so exynos_drm_display_ops is better
to describe.

Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_connector.c |   29 +++++++++++++------------
 drivers/gpu/drm/exynos/exynos_drm_drv.h       |    4 +-
 drivers/gpu/drm/exynos/exynos_drm_encoder.c   |    8 +++---
 drivers/gpu/drm/exynos/exynos_drm_fimd.c      |    4 +-
 4 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_connector.c b/drivers/gpu/drm/exynos/exynos_drm_connector.c
index d33f803..d620b07 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_connector.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_connector.c
@@ -104,13 +104,13 @@ static int exynos_drm_connector_get_modes(struct drm_connector *connector)
 	struct exynos_drm_connector *exynos_connector =
 					to_exynos_connector(connector);
 	struct exynos_drm_manager *manager = exynos_connector->manager;
-	struct exynos_drm_display *display = manager->display;
+	struct exynos_drm_display_ops *display_ops = manager->display_ops;
 	unsigned int count;
 
 	DRM_DEBUG_KMS("%s\n", __FILE__);
 
-	if (!display) {
-		DRM_DEBUG_KMS("display is null.\n");
+	if (!display_ops) {
+		DRM_DEBUG_KMS("display_ops is null.\n");
 		return 0;
 	}
 
@@ -122,7 +122,7 @@ static int exynos_drm_connector_get_modes(struct drm_connector *connector)
 	 * P.S. in case of lcd panel, count is always 1 if success
 	 * because lcd panel has only one mode.
 	 */
-	if (display->get_edid) {
+	if (display_ops->get_edid) {
 		int ret;
 		void *edid;
 
@@ -132,7 +132,7 @@ static int exynos_drm_connector_get_modes(struct drm_connector *connector)
 			return 0;
 		}
 
-		ret = display->get_edid(manager->dev, connector,
+		ret = display_ops->get_edid(manager->dev, connector,
 						edid, MAX_EDID);
 		if (ret < 0) {
 			DRM_ERROR("failed to get edid data.\n");
@@ -150,8 +150,8 @@ static int exynos_drm_connector_get_modes(struct drm_connector *connector)
 		struct drm_display_mode *mode = drm_mode_create(connector->dev);
 		struct fb_videomode *timing;
 
-		if (display->get_timing)
-			timing = display->get_timing(manager->dev);
+		if (display_ops->get_timing)
+			timing = display_ops->get_timing(manager->dev);
 		else {
 			drm_mode_destroy(connector->dev, mode);
 			return 0;
@@ -175,7 +175,7 @@ static int exynos_drm_connector_mode_valid(struct drm_connector *connector,
 	struct exynos_drm_connector *exynos_connector =
 					to_exynos_connector(connector);
 	struct exynos_drm_manager *manager = exynos_connector->manager;
-	struct exynos_drm_display *display = manager->display;
+	struct exynos_drm_display_ops *display_ops = manager->display_ops;
 	struct fb_videomode timing;
 	int ret = MODE_BAD;
 
@@ -183,8 +183,8 @@ static int exynos_drm_connector_mode_valid(struct drm_connector *connector,
 
 	convert_to_video_timing(&timing, mode);
 
-	if (display && display->check_timing)
-		if (!display->check_timing(manager->dev, (void *)&timing))
+	if (display_ops && display_ops->check_timing)
+		if (!display_ops->check_timing(manager->dev, (void *)&timing))
 			ret = MODE_OK;
 
 	return ret;
@@ -226,13 +226,14 @@ exynos_drm_connector_detect(struct drm_connector *connector, bool force)
 	struct exynos_drm_connector *exynos_connector =
 					to_exynos_connector(connector);
 	struct exynos_drm_manager *manager = exynos_connector->manager;
-	struct exynos_drm_display *display = manager->display;
+	struct exynos_drm_display_ops *display_ops =
+					manager->display_ops;
 	enum drm_connector_status status = connector_status_disconnected;
 
 	DRM_DEBUG_KMS("%s\n", __FILE__);
 
-	if (display && display->is_connected) {
-		if (display->is_connected(manager->dev))
+	if (display_ops && display_ops->is_connected) {
+		if (display_ops->is_connected(manager->dev))
 			status = connector_status_connected;
 		else
 			status = connector_status_disconnected;
@@ -279,7 +280,7 @@ struct drm_connector *exynos_drm_connector_create(struct drm_device *dev,
 
 	connector = &exynos_connector->drm_connector;
 
-	switch (manager->display->type) {
+	switch (manager->display_ops->type) {
 	case EXYNOS_DISPLAY_TYPE_HDMI:
 		type = DRM_MODE_CONNECTOR_HDMIA;
 		connector->interlace_allowed = true;
diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.h b/drivers/gpu/drm/exynos/exynos_drm_drv.h
index c03683f..1575e5f 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.h
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.h
@@ -130,7 +130,7 @@ struct exynos_drm_overlay {
  * @check_timing: check if timing is valid or not.
  * @power_on: display device on or off.
  */
-struct exynos_drm_display {
+struct exynos_drm_display_ops {
 	enum exynos_drm_output_type type;
 	bool (*is_connected)(struct device *dev);
 	int (*get_edid)(struct device *dev, struct drm_connector *connector,
@@ -178,7 +178,7 @@ struct exynos_drm_manager {
 	int pipe;
 	struct exynos_drm_manager_ops *ops;
 	struct exynos_drm_overlay_ops *overlay_ops;
-	struct exynos_drm_display *display;
+	struct exynos_drm_display_ops *display_ops;
 };
 
 /*
diff --git a/drivers/gpu/drm/exynos/exynos_drm_encoder.c b/drivers/gpu/drm/exynos/exynos_drm_encoder.c
index 4e5535b..0034fa7 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_encoder.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_encoder.c
@@ -58,11 +58,11 @@ static void exynos_drm_encoder_dpms(struct drm_encoder *encoder, int mode)
 
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
 		if (connector->encoder == encoder) {
-			struct exynos_drm_display *display =
-							manager->display;
+			struct exynos_drm_display_ops *display_ops =
+							manager->display_ops;
 
-			if (display && display->power_on)
-				display->power_on(manager->dev, mode);
+			if (display_ops && display_ops->power_on)
+				display_ops->power_on(manager->dev, mode);
 		}
 	}
 }
diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index 4659c88..f2d883f 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -124,7 +124,7 @@ static int fimd_display_power_on(struct device *dev, int mode)
 	return 0;
 }
 
-static struct exynos_drm_display fimd_display = {
+static struct exynos_drm_display_ops fimd_display_ops = {
 	.type = EXYNOS_DISPLAY_TYPE_LCD,
 	.is_connected = fimd_display_is_connected,
 	.get_timing = fimd_get_timing,
@@ -731,7 +731,7 @@ static int __devinit fimd_probe(struct platform_device *pdev)
 	subdrv->manager.pipe = -1;
 	subdrv->manager.ops = &fimd_manager_ops;
 	subdrv->manager.overlay_ops = &fimd_overlay_ops;
-	subdrv->manager.display = &fimd_display;
+	subdrv->manager.display_ops = &fimd_display_ops;
 	subdrv->manager.dev = dev;
 
 	platform_set_drvdata(pdev, ctx);
-- 
1.7.4.1

