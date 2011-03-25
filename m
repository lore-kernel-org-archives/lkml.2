Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089Ab1CZADe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:03:34 -0400
Received: from kroah.org ([198.145.64.141]:41888 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755648Ab1CYXxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:53:04 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:45:13 2011
Message-Id: <20110325234513.310545074@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:44:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Airlie <airlied@redhat.com>
Subject: [52/63] drm: check for modesetting on modeset ioctls
In-Reply-To: <20110325234526.GA18017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit fb3b06c8a1fd1a80298f13b738ab38ef8c73baff upstream.

Noticed this while working on some other things, helps if we check for modeset
enabled on modesetting ioctls.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/drm_crtc.c |   51 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -1073,6 +1073,9 @@ int drm_mode_getresources(struct drm_dev
 	uint32_t __user *encoder_id;
 	struct drm_mode_group *mode_group;
 
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
 	mutex_lock(&dev->mode_config.mutex);
 
 	/*
@@ -1244,6 +1247,9 @@ int drm_mode_getcrtc(struct drm_device *
 	struct drm_mode_object *obj;
 	int ret = 0;
 
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
 	mutex_lock(&dev->mode_config.mutex);
 
 	obj = drm_mode_object_find(dev, crtc_resp->crtc_id,
@@ -1312,6 +1318,9 @@ int drm_mode_getconnector(struct drm_dev
 	uint64_t __user *prop_values;
 	uint32_t __user *encoder_ptr;
 
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
 	memset(&u_mode, 0, sizeof(struct drm_mode_modeinfo));
 
 	DRM_DEBUG_KMS("[CONNECTOR:%d:?]\n", out_resp->connector_id);
@@ -1431,6 +1440,9 @@ int drm_mode_getencoder(struct drm_devic
 	struct drm_encoder *encoder;
 	int ret = 0;
 
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
 	mutex_lock(&dev->mode_config.mutex);
 	obj = drm_mode_object_find(dev, enc_resp->encoder_id,
 				   DRM_MODE_OBJECT_ENCODER);
@@ -1486,6 +1498,9 @@ int drm_mode_setcrtc(struct drm_device *
 	int ret = 0;
 	int i;
 
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
 	mutex_lock(&dev->mode_config.mutex);
 	obj = drm_mode_object_find(dev, crtc_req->crtc_id,
 				   DRM_MODE_OBJECT_CRTC);
@@ -1603,6 +1618,9 @@ int drm_mode_cursor_ioctl(struct drm_dev
 	struct drm_crtc *crtc;
 	int ret = 0;
 
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
 	if (!req->flags) {
 		DRM_ERROR("no operation set\n");
 		return -EINVAL;
@@ -1667,6 +1685,9 @@ int drm_mode_addfb(struct drm_device *de
 	struct drm_framebuffer *fb;
 	int ret = 0;
 
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
 	if ((config->min_width > r->width) || (r->width > config->max_width)) {
 		DRM_ERROR("mode new framebuffer width not within limits\n");
 		return -EINVAL;
@@ -1724,6 +1745,9 @@ int drm_mode_rmfb(struct drm_device *dev
 	int ret = 0;
 	int found = 0;
 
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
 	mutex_lock(&dev->mode_config.mutex);
 	obj = drm_mode_object_find(dev, *id, DRM_MODE_OBJECT_FB);
 	/* TODO check that we realy get a framebuffer back. */
@@ -1780,6 +1804,9 @@ int drm_mode_getfb(struct drm_device *de
 	struct drm_framebuffer *fb;
 	int ret = 0;
 
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
 	mutex_lock(&dev->mode_config.mutex);
 	obj = drm_mode_object_find(dev, r->fb_id, DRM_MODE_OBJECT_FB);
 	if (!obj) {
@@ -1813,6 +1840,9 @@ int drm_mode_dirtyfb_ioctl(struct drm_de
 	int num_clips;
 	int ret = 0;
 
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
 	mutex_lock(&dev->mode_config.mutex);
 	obj = drm_mode_object_find(dev, r->fb_id, DRM_MODE_OBJECT_FB);
 	if (!obj) {
@@ -1996,6 +2026,9 @@ int drm_mode_attachmode_ioctl(struct drm
 	struct drm_mode_modeinfo *umode = &mode_cmd->mode;
 	int ret = 0;
 
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
 	mutex_lock(&dev->mode_config.mutex);
 
 	obj = drm_mode_object_find(dev, mode_cmd->connector_id, DRM_MODE_OBJECT_CONNECTOR);
@@ -2042,6 +2075,9 @@ int drm_mode_detachmode_ioctl(struct drm
 	struct drm_mode_modeinfo *umode = &mode_cmd->mode;
 	int ret = 0;
 
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
 	mutex_lock(&dev->mode_config.mutex);
 
 	obj = drm_mode_object_find(dev, mode_cmd->connector_id, DRM_MODE_OBJECT_CONNECTOR);
@@ -2211,6 +2247,9 @@ int drm_mode_getproperty_ioctl(struct dr
 	uint64_t __user *values_ptr;
 	uint32_t __user *blob_length_ptr;
 
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
 	mutex_lock(&dev->mode_config.mutex);
 	obj = drm_mode_object_find(dev, out_resp->prop_id, DRM_MODE_OBJECT_PROPERTY);
 	if (!obj) {
@@ -2333,6 +2372,9 @@ int drm_mode_getblob_ioctl(struct drm_de
 	int ret = 0;
 	void *blob_ptr;
 
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
 	mutex_lock(&dev->mode_config.mutex);
 	obj = drm_mode_object_find(dev, out_resp->blob_id, DRM_MODE_OBJECT_BLOB);
 	if (!obj) {
@@ -2393,6 +2435,9 @@ int drm_mode_connector_property_set_ioct
 	int ret = -EINVAL;
 	int i;
 
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
 	mutex_lock(&dev->mode_config.mutex);
 
 	obj = drm_mode_object_find(dev, out_resp->connector_id, DRM_MODE_OBJECT_CONNECTOR);
@@ -2509,6 +2554,9 @@ int drm_mode_gamma_set_ioctl(struct drm_
 	int size;
 	int ret = 0;
 
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
 	mutex_lock(&dev->mode_config.mutex);
 	obj = drm_mode_object_find(dev, crtc_lut->crtc_id, DRM_MODE_OBJECT_CRTC);
 	if (!obj) {
@@ -2560,6 +2608,9 @@ int drm_mode_gamma_get_ioctl(struct drm_
 	int size;
 	int ret = 0;
 
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
 	mutex_lock(&dev->mode_config.mutex);
 	obj = drm_mode_object_find(dev, crtc_lut->crtc_id, DRM_MODE_OBJECT_CRTC);
 	if (!obj) {


