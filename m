Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab2IQAu2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33362 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753015Ab2IQAtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:33 -0400
Message-Id: <20120917003628.860292301@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 019/135] drm: remove some potentially dangerous DRM_ERRORs
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit acb4b992d8a13728044f430b47b9199aa45993e9 upstream.

Each of these error messages can be caused by a broken or malicious
userspace wanting to spam the dmesg with useless info.  They're really
not worthy of DRM_DEBUG statements either; those are generally only
useful during bringup of new hardware or versions, and ought to be
removed before going upstream anyway.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Reviewed-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
[bwh: Backported to 3.2: s/r\./r->/ in drm_mode_addfb()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/drm_crtc.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -1625,10 +1625,8 @@ int drm_mode_cursor_ioctl(struct drm_dev
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return -EINVAL;
 
-	if (!req->flags) {
-		DRM_ERROR("no operation set\n");
+	if (!req->flags)
 		return -EINVAL;
-	}
 
 	mutex_lock(&dev->mode_config.mutex);
 	obj = drm_mode_object_find(dev, req->crtc_id, DRM_MODE_OBJECT_CRTC);
@@ -1641,7 +1639,6 @@ int drm_mode_cursor_ioctl(struct drm_dev
 
 	if (req->flags & DRM_MODE_CURSOR_BO) {
 		if (!crtc->funcs->cursor_set) {
-			DRM_ERROR("crtc does not support cursor\n");
 			ret = -ENXIO;
 			goto out;
 		}
@@ -1654,7 +1651,6 @@ int drm_mode_cursor_ioctl(struct drm_dev
 		if (crtc->funcs->cursor_move) {
 			ret = crtc->funcs->cursor_move(crtc, req->x, req->y);
 		} else {
-			DRM_ERROR("crtc does not support cursor\n");
 			ret = -EFAULT;
 			goto out;
 		}
@@ -1692,14 +1688,11 @@ int drm_mode_addfb(struct drm_device *de
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return -EINVAL;
 
-	if ((config->min_width > r->width) || (r->width > config->max_width)) {
-		DRM_ERROR("mode new framebuffer width not within limits\n");
+	if ((config->min_width > r->width) || (r->width > config->max_width))
 		return -EINVAL;
-	}
-	if ((config->min_height > r->height) || (r->height > config->max_height)) {
-		DRM_ERROR("mode new framebuffer height not within limits\n");
+
+	if ((config->min_height > r->height) || (r->height > config->max_height))
 		return -EINVAL;
-	}
 
 	mutex_lock(&dev->mode_config.mutex);
 
@@ -1756,7 +1749,6 @@ int drm_mode_rmfb(struct drm_device *dev
 	obj = drm_mode_object_find(dev, *id, DRM_MODE_OBJECT_FB);
 	/* TODO check that we really get a framebuffer back. */
 	if (!obj) {
-		DRM_ERROR("mode invalid framebuffer id\n");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1767,7 +1759,6 @@ int drm_mode_rmfb(struct drm_device *dev
 			found = 1;
 
 	if (!found) {
-		DRM_ERROR("tried to remove a fb that we didn't own\n");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1814,7 +1805,6 @@ int drm_mode_getfb(struct drm_device *de
 	mutex_lock(&dev->mode_config.mutex);
 	obj = drm_mode_object_find(dev, r->fb_id, DRM_MODE_OBJECT_FB);
 	if (!obj) {
-		DRM_ERROR("invalid framebuffer id\n");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1850,7 +1840,6 @@ int drm_mode_dirtyfb_ioctl(struct drm_de
 	mutex_lock(&dev->mode_config.mutex);
 	obj = drm_mode_object_find(dev, r->fb_id, DRM_MODE_OBJECT_FB);
 	if (!obj) {
-		DRM_ERROR("invalid framebuffer id\n");
 		ret = -EINVAL;
 		goto out_err1;
 	}


