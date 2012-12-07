Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422839Ab2LGAzC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:55:02 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40591 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713Ab2LGAy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:54:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 03/20] drm/radeon/dce4+: dont use radeon_crtc for vblank callback
Date: Thu,  6 Dec 2012 16:54:18 -0800
Message-Id: <20121207005233.748737106@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121207005232.756641002@linuxfoundation.org>
References: <20121207005232.756641002@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4a15903db02026728d0cf2755c6fabae16b8db6a upstream.

This might be called before we've allocated the radeon_crtcs

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

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
@@ -101,17 +111,19 @@ void evergreen_fix_pci_max_read_req_size
 
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


