Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab1AMAi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 19:38:59 -0500
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:50809
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756495Ab1AMAi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 19:38:57 -0500
X-Greylist: delayed 1529 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jan 2011 19:38:57 EST
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm/i915/execbuffer: Reorder relocations to match new object order
Date: Thu, 13 Jan 2011 00:13:17 +0000
Message-Id: <1294877597-17843-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <id:b7da2f$q4c60f@fmsmga001.fm.intel.com>
References: <id:b7da2f$q4c60f@fmsmga001.fm.intel.com>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the fault path, commit 6fe4f140 introduction a regression whereby it
changed the sequence of the objects but continued to use the original
ordering of relocation entries. The result was that incorrect GTT offsets
were being fed into the execbuffer causing lots of misrendering and
potential hangs.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---

This is what I'm running with at the moment. It only appears to affect the
slow path which hopefully explains why it is relatively infrequent...
-Chris

---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index e698343..6b34e98 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -636,6 +636,7 @@ i915_gem_execbuffer_relocate_slow(struct drm_device *dev,
 {
 	struct drm_i915_gem_relocation_entry *reloc;
 	struct drm_i915_gem_object *obj;
+	int *reloc_offset;
 	int i, total, ret;
 
 	/* We may process another execbuffer during the unlock... */
@@ -653,8 +654,11 @@ i915_gem_execbuffer_relocate_slow(struct drm_device *dev,
 	for (i = 0; i < count; i++)
 		total += exec[i].relocation_count;
 
+	reloc_offset = drm_malloc_ab(count, sizeof(*reloc_offset));
 	reloc = drm_malloc_ab(total, sizeof(*reloc));
-	if (reloc == NULL) {
+	if (reloc == NULL || reloc_offset == NULL) {
+		drm_free_large(reloc);
+		drm_free_large(reloc_offset);
 		mutex_lock(&dev->struct_mutex);
 		return -ENOMEM;
 	}
@@ -672,6 +676,7 @@ i915_gem_execbuffer_relocate_slow(struct drm_device *dev,
 			goto err;
 		}
 
+		reloc_offset[i] = total;
 		total += exec[i].relocation_count;
 	}
 
@@ -705,17 +710,14 @@ i915_gem_execbuffer_relocate_slow(struct drm_device *dev,
 	if (ret)
 		goto err;
 
-	total = 0;
 	list_for_each_entry(obj, objects, exec_list) {
+		int offset = obj->exec_entry - exec;
 		obj->base.pending_read_domains = 0;
 		obj->base.pending_write_domain = 0;
 		ret = i915_gem_execbuffer_relocate_object_slow(obj, eb,
-							       reloc + total);
+							       reloc + reloc_offset[offset]);
 		if (ret)
 			goto err;
-
-		total += exec->relocation_count;
-		exec++;
 	}
 
 	/* Leave the user relocations as are, this is the painfully slow path,
@@ -726,6 +728,7 @@ i915_gem_execbuffer_relocate_slow(struct drm_device *dev,
 
 err:
 	drm_free_large(reloc);
+	drm_free_large(reloc_offset);
 	return ret;
 }
 
-- 
1.7.2.3

