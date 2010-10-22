Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427Ab0JVS4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:56:45 -0400
Received: from kroah.org ([198.145.64.141]:34247 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759395Ab0JVS4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:42 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:33 2010
Message-Id: <20101022185232.935749858@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [062/103] drm/i915: Sanity check pread/pwrite
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit ce9d419dbecc292cc3e06e8b1d6d123d3fa813a4 upstream.

Move the access control up from the fast paths, which are no longer
universally taken first, up into the caller. This then duplicates some
sanity checking along the slow paths, but is much simpler.
Tracked as CVE-2010-2962.

Reported-by: Kees Cook <kees@ubuntu.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_gem.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -465,8 +465,15 @@ i915_gem_pread_ioctl(struct drm_device *
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
@@ -478,8 +485,8 @@ i915_gem_pread_ioctl(struct drm_device *
 							file_priv);
 	}
 
+err:
 	drm_gem_object_unreference_unlocked(obj);
-
 	return ret;
 }
 
@@ -568,8 +575,6 @@ i915_gem_gtt_pwrite_fast(struct drm_devi
 
 	user_data = (char __user *) (uintptr_t) args->data_ptr;
 	remain = args->size;
-	if (!access_ok(VERIFY_READ, user_data, remain))
-		return -EFAULT;
 
 
 	mutex_lock(&dev->struct_mutex);
@@ -928,8 +933,15 @@ i915_gem_pwrite_ioctl(struct drm_device
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
@@ -963,8 +975,8 @@ i915_gem_pwrite_ioctl(struct drm_device
 		DRM_INFO("pwrite failed %d\n", ret);
 #endif
 
+err:
 	drm_gem_object_unreference_unlocked(obj);
-
 	return ret;
 }
 


