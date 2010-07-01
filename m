Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167Ab0GAVPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:15:32 -0400
Received: from kroah.org ([198.145.64.141]:60857 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758945Ab0GAVNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:39 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:52 2010
Message-Id: <20100701174251.999488773@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>
Subject: [066/200] drm/i915: Reject bind_to_gtt() early if object > aperture
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 654fc6073f68efa3b6c466825749e73e7fbb92cd upstream.

If the object is bigger than the entire aperture, reject it early
before evicting everything in a vain attempt to find space.

v2: Use E2BIG as suggested by Owain G. Ainsworth.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_gem.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2688,6 +2688,14 @@ i915_gem_object_bind_to_gtt(struct drm_g
 		return -EINVAL;
 	}
 
+	/* If the object is bigger than the entire aperture, reject it early
+	 * before evicting everything in a vain attempt to find space.
+	 */
+	if (obj->size > dev->gtt_total) {
+		DRM_ERROR("Attempting to bind an object larger than the aperture\n");
+		return -E2BIG;
+	}
+
  search_free:
 	free_space = drm_mm_search_free(&dev_priv->mm.gtt_space,
 					obj->size, alignment, 0);


