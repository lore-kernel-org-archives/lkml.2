Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab1FJVtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 17:49:12 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:27402 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab1FJVtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 17:49:09 -0400
Date: Fri, 10 Jun 2011 23:40:47 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH] i915: Don't leak in i915_gem_shmem_pread_slow()..
Message-ID: <alpine.LNX.2.00.1106102336560.21722@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems to me that we are leaking 'user_pages' in 
drivers/gpu/drm/i915/i915_gem.c::i915_gem_shmem_pread_slow() if 
read_cache_page_gfp() fails.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 i915_gem.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

 Untested patch - user be warned.

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 12d3257..4df3272 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -465,8 +465,10 @@ i915_gem_shmem_pread_slow(struct drm_device *dev,
 
 		page = read_cache_page_gfp(mapping, offset >> PAGE_SHIFT,
 					   GFP_HIGHUSER | __GFP_RECLAIMABLE);
-		if (IS_ERR(page))
+		if (IS_ERR(page)) {
+			drm_free_large(user_pages);
 			return PTR_ERR(page);
+		}
 
 		if (do_bit17_swizzling) {
 			slow_shmem_bit17_copy(page,


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

