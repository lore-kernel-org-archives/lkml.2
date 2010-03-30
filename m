Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab0C3XgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:36:24 -0400
Received: from kroah.org ([198.145.64.141]:46408 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755774Ab0C3XU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:20:59 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:25 2010
Message-Id: <20100330224824.584108264@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Carpenter <error27@gmail.com>, Eric Anholt <eric@anholt.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [097/156] drm/i915: fix small leak on overlay error path
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit 915a428e43acfd05e4ffeaf40549b0cf163eebe2 upstream.

We should free "params" before returning.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_overlay.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/intel_overlay.c
+++ b/drivers/gpu/drm/i915/intel_overlay.c
@@ -1083,14 +1083,18 @@ int intel_overlay_put_image(struct drm_d
 
 	drmmode_obj = drm_mode_object_find(dev, put_image_rec->crtc_id,
                         DRM_MODE_OBJECT_CRTC);
-	if (!drmmode_obj)
-		return -ENOENT;
+	if (!drmmode_obj) {
+		ret = -ENOENT;
+		goto out_free;
+	}
 	crtc = to_intel_crtc(obj_to_crtc(drmmode_obj));
 
 	new_bo = drm_gem_object_lookup(dev, file_priv,
 			put_image_rec->bo_handle);
-	if (!new_bo)
-		return -ENOENT;
+	if (!new_bo) {
+		ret = -ENOENT;
+		goto out_free;
+	}
 
 	mutex_lock(&dev->mode_config.mutex);
 	mutex_lock(&dev->struct_mutex);
@@ -1180,6 +1184,7 @@ out_unlock:
 	mutex_unlock(&dev->struct_mutex);
 	mutex_unlock(&dev->mode_config.mutex);
 	drm_gem_object_unreference(new_bo);
+out_free:
 	kfree(params);
 
 	return ret;


