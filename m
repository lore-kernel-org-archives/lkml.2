Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab2HOUIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:08:12 -0400
Received: from mail.windriver.com ([147.11.1.11]:37093 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab2HOTwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:19 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Chris Wilson <chris@chris-wilson.co.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 132/165] drm/i915: Sanity check pread/pwrite
Date: Wed, 15 Aug 2012 15:47:56 -0400
Message-ID: <1345060109-9187-133-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit ce9d419dbecc292cc3e06e8b1d6d123d3fa813a4 upstream.

Move the access control up from the fast paths, which are no longer
universally taken first, up into the caller. This then duplicates some
sanity checking along the slow paths, but is much simpler.
Tracked as CVE-2010-2962.

Reported-by: Kees Cook <kees@ubuntu.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/gpu/drm/i915/i915_gem.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index e07722a..fd51c36 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -487,8 +487,15 @@ i915_gem_pread_ioctl(struct drm_device *dev, void *data,
 	 */
 	if (args->offset > obj->size || args->size > obj->size ||
 	    args->offset + args->size > obj->size) {
-		drm_gem_object_unreference_unlocked(obj);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
+	}
+
+	if (!access_ok(VERIFY_WRITE,
+		       (char __user *)(uintptr_t)args->data_ptr,
+		       args->size)) {
+		ret = -EFAULT;
+		goto err;
 	}
 
 	if (i915_gem_object_needs_bit17_swizzle(obj)) {
@@ -500,8 +507,8 @@ i915_gem_pread_ioctl(struct drm_device *dev, void *data,
 							file_priv);
 	}
 
+err:
 	drm_gem_object_unreference_unlocked(obj);
-
 	return ret;
 }
 
@@ -591,8 +598,6 @@ i915_gem_gtt_pwrite_fast(struct drm_device *dev, struct drm_gem_object *obj,
 
 	user_data = (char __user *) (uintptr_t) args->data_ptr;
 	remain = args->size;
-	if (!access_ok(VERIFY_READ, user_data, remain))
-		return -EFAULT;
 
 
 	mutex_lock(&dev->struct_mutex);
@@ -960,8 +965,15 @@ i915_gem_pwrite_ioctl(struct drm_device *dev, void *data,
 	 */
 	if (args->offset > obj->size || args->size > obj->size ||
 	    args->offset + args->size > obj->size) {
-		drm_gem_object_unreference_unlocked(obj);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
+	}
+
+	if (!access_ok(VERIFY_READ,
+		       (char __user *)(uintptr_t)args->data_ptr,
+		       args->size)) {
+		ret = -EFAULT;
+		goto err;
 	}
 
 	/* We can only do the GTT pwrite on untiled buffers, as otherwise
@@ -994,8 +1006,8 @@ i915_gem_pwrite_ioctl(struct drm_device *dev, void *data,
 		DRM_INFO("pwrite failed %d\n", ret);
 #endif
 
+err:
 	drm_gem_object_unreference_unlocked(obj);
-
 	return ret;
 }
 
-- 
1.7.12.rc2

