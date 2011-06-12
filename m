Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab1FLVSM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 17:18:12 -0400
Received: from ev1s-66-98-244-53.theplanet.com ([66.98.244.53]:1148 "EHLO
	relay.fireflyinternet.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751186Ab1FLVSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 17:18:09 -0400
X-Greylist: delayed 1450 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Jun 2011 17:18:09 EDT
From: Chris Wilson <chris@chris-wilson.co.uk>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Jesper Juhl <jj@chaosbits.net>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm/i915: Don't leak in i915_gem_shmem_pread_slow()
Date: Sun, 12 Jun 2011 21:53:44 +0100
Message-Id: <1307912024-14190-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <alpine.LNX.2.00.1106102336560.21722@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106102336560.21722@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>

It seems to me that we are leaking 'user_pages' in
drivers/gpu/drm/i915/i915_gem.c::i915_gem_shmem_pread_slow() if
read_cache_page_gfp() fails.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/i915/i915_gem.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 12d3257..94c84d7 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -465,8 +465,10 @@ i915_gem_shmem_pread_slow(struct drm_device *dev,
 
 		page = read_cache_page_gfp(mapping, offset >> PAGE_SHIFT,
 					   GFP_HIGHUSER | __GFP_RECLAIMABLE);
-		if (IS_ERR(page))
-			return PTR_ERR(page);
+		if (IS_ERR(page)) {
+			ret = PTR_ERR(page);
+			goto out;
+		}
 
 		if (do_bit17_swizzling) {
 			slow_shmem_bit17_copy(page,
-- 
1.7.5.3

