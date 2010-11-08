Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab0KHB5J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 20:57:09 -0500
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:58223
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752603Ab0KHB5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 20:57:08 -0500
X-Greylist: delayed 1343 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Nov 2010 20:57:08 EST
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Uwe Helm <uwe.helm@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm/i915: Avoid might_fault during pwrite whilst holding our mutex
Date: Mon,  8 Nov 2010 01:34:28 +0000
Message-Id: <1289180068-12109-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <AANLkTi=rFCaDCMz3woo=ABtM7TesZK2_cKghnwv4B_Jv@mail.gmail.com>
References: <AANLkTi=rFCaDCMz3woo=ABtM7TesZK2_cKghnwv4B_Jv@mail.gmail.com>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... and so prevent a potential circular reference:

  [ INFO: possible circular locking dependency detected ]
  2.6.37-rc1-uwe1+ #4
  -------------------------------------------------------
  Xorg/1401 is trying to acquire lock:
   (&mm->mmap_sem){++++++}, at: [<c01e4ddb>] might_fault+0x4b/0xa0

  but task is already holding lock:
   (&dev->struct_mutex){+.+.+.}, at: [<f869c3ac>]
  i915_mutex_lock_interruptible+0x3c/0x60 [i915]

  which lock already depends on the new lock.

When the locking around the pwrite ioctl was simplified, I did not spot
that the phys path never took any locks and so we introduced this
potential circular reference.

Reported-by: Uwe Helm <uwe.helm@googlemail.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/i915/i915_gem.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 984eb6e..eba9b16 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -4878,17 +4878,24 @@ i915_gem_phys_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 		     struct drm_file *file_priv)
 {
 	struct drm_i915_gem_object *obj_priv = to_intel_bo(obj);
-	void *obj_addr;
-	int ret;
-	char __user *user_data;
+	void *vaddr = obj_priv->phys_obj->handle->vaddr + args->offset;
+	char __user *user_data = (char __user *) (uintptr_t) args->data_ptr;
 
-	user_data = (char __user *) (uintptr_t) args->data_ptr;
-	obj_addr = obj_priv->phys_obj->handle->vaddr + args->offset;
+	DRM_DEBUG_DRIVER("vaddr %p, %lld\n", vaddr, args->size);
 
-	DRM_DEBUG_DRIVER("obj_addr %p, %lld\n", obj_addr, args->size);
-	ret = copy_from_user(obj_addr, user_data, args->size);
-	if (ret)
-		return -EFAULT;
+	if (__copy_from_user_inatomic_nocache(vaddr, user_data, args->size)) {
+		unsigned long unwritten;
+
+		/* The physical object once assigned is fixed for the lifetime
+		 * of the obj, so we can safely drop the lock and continue
+		 * to access vaddr.
+		 */
+		mutex_unlock(&dev->struct_mutex);
+		unwritten = copy_from_user(vaddr, user_data, args->size);
+		mutex_lock(&dev->struct_mutex);
+		if (unwritten)
+			return -EFAULT;
+	}
 
 	drm_agp_chipset_flush(dev);
 	return 0;
-- 
1.7.2.3

