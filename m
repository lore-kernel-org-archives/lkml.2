Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab1CYX5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:57:43 -0400
Received: from kroah.org ([198.145.64.141]:41919 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662Ab1CYXxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:53:05 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:45:13 2011
Message-Id: <20110325234513.414944070@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:44:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [53/63] drm/i915: Disable pagefaults along execbuffer relocation fast path
In-Reply-To: <20110325234526.GA18017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit d4aeee776017b6da6dcd12f453cd82a3c951a0dc upstream.

Along the fast path for relocation handling, we attempt to copy directly
from the user data structures whilst holding our mutex. This causes
lockdep to warn about circular lock dependencies if we need to pagefault
the user pages. [Since when handling a page fault on a mmapped bo, we
need to acquire the struct mutex whilst already holding the mm
semaphore, it is then verboten to acquire the mm semaphore when already
holding the struct mutex. The likelihood of the user passing in the
relocations contained in a GTT mmaped bo is low, but conceivable for
extreme pathology.] In order to force the mm to return EFAULT rather
than handle the pagefault, we therefore need to disable pagefaults
across the relocation fast path.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -388,6 +388,10 @@ i915_gem_execbuffer_relocate_entry(struc
 		uint32_t __iomem *reloc_entry;
 		void __iomem *reloc_page;
 
+		/* We can't wait for rendering with pagefaults disabled */
+		if (obj->active && in_atomic())
+			return -EFAULT;
+
 		ret = i915_gem_object_set_to_gtt_domain(obj, 1);
 		if (ret)
 			return ret;
@@ -461,15 +465,24 @@ i915_gem_execbuffer_relocate(struct drm_
 			     struct list_head *objects)
 {
 	struct drm_i915_gem_object *obj;
-	int ret;
+	int ret = 0;
 
+	/* This is the fast path and we cannot handle a pagefault whilst
+	 * holding the struct mutex lest the user pass in the relocations
+	 * contained within a mmaped bo. For in such a case we, the page
+	 * fault handler would call i915_gem_fault() and we would try to
+	 * acquire the struct mutex again. Obviously this is bad and so
+	 * lockdep complains vehemently.
+	 */
+	pagefault_disable();
 	list_for_each_entry(obj, objects, exec_list) {
 		ret = i915_gem_execbuffer_relocate_object(obj, eb);
 		if (ret)
-			return ret;
+			break;
 	}
+	pagefault_enable();
 
-	return 0;
+	return ret;
 }
 
 static int


