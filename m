Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab1BBAuC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:50:02 -0500
Received: from mga11.intel.com ([192.55.52.93]:43069 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab1BBApK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="653505339"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: alexdeucher@gmail.com, ak@linux.intel.com, jglisse@redhat.com,
        airlied@redhat.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [121/139] drm/radeon/kms: fix evergreen asic reset
Message-Id: <20110202004520.65E9B3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alex Deucher <alexdeucher@gmail.com>

commit 9f0c4f9c2f835eee1bbb93f96bf9483d56f1892b upstream.

Only reset the grbm blocks, srbm tends to lock the GPU
if not done properly and in most cases is not necessary.
Also, no need to call asic init after reset the grbm blocks.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/evergreen.c |   15 ---------------
 1 file changed, 15 deletions(-)

Index: linux-2.6.35.y/drivers/gpu/drm/radeon/evergreen.c
===================================================================
--- linux-2.6.35.y.orig/drivers/gpu/drm/radeon/evergreen.c
+++ linux-2.6.35.y/drivers/gpu/drm/radeon/evergreen.c
@@ -1406,7 +1406,6 @@ bool evergreen_gpu_is_lockup(struct rade
 static int evergreen_gpu_soft_reset(struct radeon_device *rdev)
 {
 	struct evergreen_mc_save save;
-	u32 srbm_reset = 0;
 	u32 grbm_reset = 0;
 
 	dev_info(rdev->dev, "GPU softreset \n");
@@ -1445,16 +1444,6 @@ static int evergreen_gpu_soft_reset(stru
 	udelay(50);
 	WREG32(GRBM_SOFT_RESET, 0);
 	(void)RREG32(GRBM_SOFT_RESET);
-
-	/* reset all the system blocks */
-	srbm_reset = SRBM_SOFT_RESET_ALL_MASK;
-
-	dev_info(rdev->dev, "  SRBM_SOFT_RESET=0x%08X\n", srbm_reset);
-	WREG32(SRBM_SOFT_RESET, srbm_reset);
-	(void)RREG32(SRBM_SOFT_RESET);
-	udelay(50);
-	WREG32(SRBM_SOFT_RESET, 0);
-	(void)RREG32(SRBM_SOFT_RESET);
 	/* Wait a little for things to settle down */
 	udelay(50);
 	dev_info(rdev->dev, "  GRBM_STATUS=0x%08X\n",
@@ -1465,10 +1454,6 @@ static int evergreen_gpu_soft_reset(stru
 		RREG32(GRBM_STATUS_SE1));
 	dev_info(rdev->dev, "  SRBM_STATUS=0x%08X\n",
 		RREG32(SRBM_STATUS));
-	/* After reset we need to reinit the asic as GPU often endup in an
-	 * incoherent state.
-	 */
-	atom_asic_init(rdev->mode_info.atom_context);
 	evergreen_mc_resume(rdev, &save);
 	return 0;
 }
