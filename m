Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab0DXAjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 20:39:25 -0400
Received: from vps.273k.net ([78.153.208.64]:47979 "EHLO
	vps-1000455-184.cp.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754846Ab0DXAjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 20:39:23 -0400
X-Greylist: delayed 1247 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Apr 2010 20:39:23 EDT
Date: Sat, 24 Apr 2010 01:18:13 +0100
From: Robert Fitzsimons <robfitz@273k.net>
To: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/radeon/kms/agp The wrong AGP chipset can cause a NULL
 pointer dereference
Message-ID: <20100424001813.GA5641@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Selecting the wrong or no CONFIG_AGP_* chipset can cause a NULL pointer
dereference when combined with CONFIG_DRM_RADEON_KMS and an old system
with a R100 AGP card (should effect other cards too).  The agp field
will be set to NULL if no suitable AGP chipset driver is loaded,
drm_agp_acquire already preforms a suitable NULL check so it can be used
directly.

Signed-off-by: Robert Fitzsimons <robfitz@273k.net>
---
 drivers/gpu/drm/radeon/radeon_agp.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_agp.c b/drivers/gpu/drm/radeon/radeon_agp.c
index c445779..28e473f 100644
--- a/drivers/gpu/drm/radeon/radeon_agp.c
+++ b/drivers/gpu/drm/radeon/radeon_agp.c
@@ -134,12 +134,10 @@ int radeon_agp_init(struct radeon_device *rdev)
 	int ret;
 
 	/* Acquire AGP. */
-	if (!rdev->ddev->agp->acquired) {
-		ret = drm_agp_acquire(rdev->ddev);
-		if (ret) {
-			DRM_ERROR("Unable to acquire AGP: %d\n", ret);
-			return ret;
-		}
+	ret = drm_agp_acquire(rdev->ddev);
+	if (ret) {
+		DRM_ERROR("Unable to acquire AGP: %d\n", ret);
+		return ret;
 	}
 
 	ret = drm_agp_info(rdev->ddev, &info);
-- 
1.7.0

