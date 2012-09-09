Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab2IIX2f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:28:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51277 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755726Ab2IIXQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:32 -0400
Message-Id: <20120909224200.135239780@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:59 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>
Subject: [ 69/95] Revert "drm/radeon: fix bo creation retry path"
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 676bc2e1e4f9072f7a640d5b7c99ffdf9709a6e7 upstream.

This reverts commit d1c7871ddb1f588b8eb35affd9ee1a3d5e11cd0c.

ttm_bo_init() destroys the BO on failure. So this patch makes
the retry path work with freed memory.  This ends up causing
kernel panics when this path is hit.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_object.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -117,6 +117,7 @@ int radeon_bo_create(struct radeon_devic
 		return -ENOMEM;
 	}
 
+retry:
 	bo = kzalloc(sizeof(struct radeon_bo), GFP_KERNEL);
 	if (bo == NULL)
 		return -ENOMEM;
@@ -129,8 +130,6 @@ int radeon_bo_create(struct radeon_devic
 	bo->gem_base.driver_private = NULL;
 	bo->surface_reg = -1;
 	INIT_LIST_HEAD(&bo->list);
-
-retry:
 	radeon_ttm_placement_from_domain(bo, domain);
 	/* Kernel allocation are uninterruptible */
 	mutex_lock(&rdev->vram_mutex);


