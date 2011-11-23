Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab1KWAdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:33:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42059 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757209Ab1KWAdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:33:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:22:08 2011
Message-Id: <20111123002208.207467692@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:21:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <greg@kroah.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [13/25] drm/i915: Sanity check pread/pwrite
In-Reply-To: <20111123002222.GA2376@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 2249
Lines: 86

From: Chris Wilson <chris@chris-wilson.co.uk>

commit ce9d419dbecc292cc3e06e8b1d6d123d3fa813a4 upstream.

Move the access control up from the fast paths, which are no longer
universally taken first, up into the caller. This then duplicates some
sanity checking along the slow paths, but is much simpler.
Tracked as CVE-2010-2962.

Reported-by: Kees Cook <kees@ubuntu.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_gem.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -488,8 +488,15 @@ i915_gem_pread_ioctl(struct drm_device *
 	 */
 	if (args->offset > obj->size || args->size > obj->size ||
 	    args->offset + args->size > obj->size) {
-		drm_gem_object_unreference(obj);
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
@@ -501,8 +508,8 @@ i915_gem_pread_ioctl(struct drm_device *
 							file_priv);
 	}
 
+err:
 	drm_gem_object_unreference(obj);
-
 	return ret;
 }
 
@@ -592,8 +599,6 @@ i915_gem_gtt_pwrite_fast(struct drm_devi
 
 	user_data = (char __user *) (uintptr_t) args->data_ptr;
 	remain = args->size;
-	if (!access_ok(VERIFY_READ, user_data, remain))
-		return -EFAULT;
 
 
 	mutex_lock(&dev->struct_mutex);
@@ -961,8 +966,15 @@ i915_gem_pwrite_ioctl(struct drm_device
 	 */
 	if (args->offset > obj->size || args->size > obj->size ||
 	    args->offset + args->size > obj->size) {
-		drm_gem_object_unreference(obj);
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
@@ -995,8 +1007,8 @@ i915_gem_pwrite_ioctl(struct drm_device
 		DRM_INFO("pwrite failed %d\n", ret);
 #endif
 
+err:
 	drm_gem_object_unreference(obj);
-
 	return ret;
 }
 


