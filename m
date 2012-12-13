Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594Ab2LMOIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:08:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44559 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539Ab2LMOIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:08:20 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 123/241] drm/radeon/dce4+: don't use radeon_crtc for vblank callback
Date: Thu, 13 Dec 2012 11:58:08 -0200
Message-Id: <1355407206-17100-124-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4a15903db02026728d0cf2755c6fabae16b8db6a upstream.

This might be called before we've allocated the radeon_crtcs

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ herton: unfuzz patch ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index e98dc9c..b6cce9c 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -37,6 +37,16 @@
 #define EVERGREEN_PFP_UCODE_SIZE 1120
 #define EVERGREEN_PM4_UCODE_SIZE 1376
 
+static const u32 crtc_offsets[6] =
+{
+	EVERGREEN_CRTC0_REGISTER_OFFSET,
+	EVERGREEN_CRTC1_REGISTER_OFFSET,
+	EVERGREEN_CRTC2_REGISTER_OFFSET,
+	EVERGREEN_CRTC3_REGISTER_OFFSET,
+	EVERGREEN_CRTC4_REGISTER_OFFSET,
+	EVERGREEN_CRTC5_REGISTER_OFFSET
+};
+
 static void evergreen_gpu_init(struct radeon_device *rdev);
 void evergreen_fini(struct radeon_device *rdev);
 void evergreen_pcie_gen2_enable(struct radeon_device *rdev);
@@ -101,17 +111,19 @@ void evergreen_fix_pci_max_read_req_size(struct radeon_device *rdev)
 
 void dce4_wait_for_vblank(struct radeon_device *rdev, int crtc)
 {
-	struct radeon_crtc *radeon_crtc = rdev->mode_info.crtcs[crtc];
 	int i;
 
-	if (RREG32(EVERGREEN_CRTC_CONTROL + radeon_crtc->crtc_offset) & EVERGREEN_CRTC_MASTER_EN) {
+	if (crtc >= rdev->num_crtc)
+		return;
+
+	if (RREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[crtc]) & EVERGREEN_CRTC_MASTER_EN) {
 		for (i = 0; i < rdev->usec_timeout; i++) {
-			if (!(RREG32(EVERGREEN_CRTC_STATUS + radeon_crtc->crtc_offset) & EVERGREEN_CRTC_V_BLANK))
+			if (!(RREG32(EVERGREEN_CRTC_STATUS + crtc_offsets[crtc]) & EVERGREEN_CRTC_V_BLANK))
 				break;
 			udelay(1);
 		}
 		for (i = 0; i < rdev->usec_timeout; i++) {
-			if (RREG32(EVERGREEN_CRTC_STATUS + radeon_crtc->crtc_offset) & EVERGREEN_CRTC_V_BLANK)
+			if (RREG32(EVERGREEN_CRTC_STATUS + crtc_offsets[crtc]) & EVERGREEN_CRTC_V_BLANK)
 				break;
 			udelay(1);
 		}
-- 
1.7.9.5

