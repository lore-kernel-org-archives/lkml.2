Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab1DZM0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:26:51 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57454 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab1DZM0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:26:47 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 18/21] drm/i915: Sanity check pread/pwrite" has been added to staging queue
Date: Tue, 26 Apr 2011 14:26:45 +0200
Message-Id: <1303820805-3937-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 18/21] drm/i915: Sanity check pread/pwrite

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 8cea8a6e94c1fb4a56c800752947340cca01221f Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Sun, 26 Sep 2010 20:50:05 +0100
Subject: [PATCH 18/21] drm/i915: Sanity check pread/pwrite

commit ce9d419dbecc292cc3e06e8b1d6d123d3fa813a4 upstream.

Move the access control up from the fast paths, which are no longer
universally taken first, up into the caller. This then duplicates some
sanity checking along the slow paths, but is much simpler.
Tracked as CVE-2010-2962.

Reported-by: Kees Cook <kees@ubuntu.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@kernel.org

[Backported to Debian's 2.6.32 by dann frazier <dannf@debian.org>]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index ad3c4a2..366abe3 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -488,8 +488,15 @@ i915_gem_pread_ioctl(struct drm_device *dev, void *data,
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
@@ -501,8 +508,8 @@ i915_gem_pread_ioctl(struct drm_device *dev, void *data,
 							file_priv);
 	}

+err:
 	drm_gem_object_unreference(obj);
-
 	return ret;
 }

@@ -592,8 +599,6 @@ i915_gem_gtt_pwrite_fast(struct drm_device *dev, struct drm_gem_object *obj,

 	user_data = (char __user *) (uintptr_t) args->data_ptr;
 	remain = args->size;
-	if (!access_ok(VERIFY_READ, user_data, remain))
-		return -EFAULT;


 	mutex_lock(&dev->struct_mutex);
@@ -961,8 +966,15 @@ i915_gem_pwrite_ioctl(struct drm_device *dev, void *data,
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
@@ -995,8 +1007,8 @@ i915_gem_pwrite_ioctl(struct drm_device *dev, void *data,
 		DRM_INFO("pwrite failed %d\n", ret);
 #endif

+err:
 	drm_gem_object_unreference(obj);
-
 	return ret;
 }

--
1.7.0.4

