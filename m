Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab2H0MCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 08:02:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58176 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab2H0MCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 08:02:50 -0400
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH] drm/i915: Remove __GFP_NO_KSWAPD
Date: Mon, 27 Aug 2012 14:02:37 +0200
Message-Id: <1346068957-27754-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I pulled-in today's drm-intel-next into linux-next (next-20120824)
I saw this build-breakage:

drivers/gpu/drm/i915/i915_gem.c: In function 'i915_gem_object_get_pages_gtt':
drivers/gpu/drm/i915/i915_gem.c:1778:40: error: '__GFP_NO_KSWAPD' undeclared (first use in this function)
drivers/gpu/drm/i915/i915_gem.c:1778:40: note: each undeclared identifier is reported only once for each function it appears in

This is caused by commit ba099ef165f8 ("mm: remove __GFP_NO_KSWAPD")
and commit b6beae2c2014 ("mm: remove __GFP_NO_KSWAPD fixes") in
linux-next (next-20120824).

Fix this by removing __GFP_NO_KSWAPD from drm/i915 driver.

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/gpu/drm/i915/i915_gem.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 61612b3..e16f37b 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1775,7 +1775,7 @@ i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj)
 	/* Fail silently without starting the shrinker */
 	mapping = obj->base.filp->f_path.dentry->d_inode->i_mapping;
 	gfp = mapping_gfp_mask(mapping);
-	gfp |= __GFP_NORETRY | __GFP_NOWARN | __GFP_NO_KSWAPD;
+	gfp |= __GFP_NORETRY | __GFP_NOWARN;
 	gfp &= ~(__GFP_IO | __GFP_WAIT);
 	for (i = 0; i < page_count; i++) {
 		page = shmem_read_mapping_page_gfp(mapping, i, gfp);
@@ -1788,7 +1788,7 @@ i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj)
 			 * our own buffer, now let the real VM do its job and
 			 * go down in flames if truly OOM.
 			 */
-			gfp &= ~(__GFP_NORETRY | __GFP_NOWARN | __GFP_NO_KSWAPD);
+			gfp &= ~(__GFP_NORETRY | __GFP_NOWARN);
 			gfp |= __GFP_IO | __GFP_WAIT;
 
 			i915_gem_shrink_all(dev_priv);
@@ -1796,7 +1796,7 @@ i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj)
 			if (IS_ERR(page))
 				goto err_pages;
 
-			gfp |= __GFP_NORETRY | __GFP_NOWARN | __GFP_NO_KSWAPD;
+			gfp |= __GFP_NORETRY | __GFP_NOWARN;
 			gfp &= ~(__GFP_IO | __GFP_WAIT);
 		}
 
-- 
1.7.9.5

