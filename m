Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab0IRTSd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:18:33 -0400
Received: from kroah.org ([198.145.64.141]:43934 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757257Ab0IRTQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:16:30 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:07 2010
Message-Id: <20100918191307.502349474@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [119/129] drm/radeon/kms/evergreen: fix gpu hangs in userspace accel code
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 7e7b41d2ff30ed7ad4bf401d18566e6f38e42e4f upstream.

These VGT regs need to be programmed via the ring rather than
MMIO as on previous asics (r6xx/r7xx).

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/evergreen.c |   39 ++++++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/radeon/r600.c      |    5 ----
 2 files changed, 39 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -658,6 +658,43 @@ static int evergreen_cp_load_microcode(s
 	return 0;
 }
 
+static int evergreen_cp_start(struct radeon_device *rdev)
+{
+	int r;
+	uint32_t cp_me;
+
+	r = radeon_ring_lock(rdev, 7);
+	if (r) {
+		DRM_ERROR("radeon: cp failed to lock ring (%d).\n", r);
+		return r;
+	}
+	radeon_ring_write(rdev, PACKET3(PACKET3_ME_INITIALIZE, 5));
+	radeon_ring_write(rdev, 0x1);
+	radeon_ring_write(rdev, 0x0);
+	radeon_ring_write(rdev, rdev->config.evergreen.max_hw_contexts - 1);
+	radeon_ring_write(rdev, PACKET3_ME_INITIALIZE_DEVICE_ID(1));
+	radeon_ring_write(rdev, 0);
+	radeon_ring_write(rdev, 0);
+	radeon_ring_unlock_commit(rdev);
+
+	cp_me = 0xff;
+	WREG32(CP_ME_CNTL, cp_me);
+
+	r = radeon_ring_lock(rdev, 4);
+	if (r) {
+		DRM_ERROR("radeon: cp failed to lock ring (%d).\n", r);
+		return r;
+	}
+	/* init some VGT regs */
+	radeon_ring_write(rdev, PACKET3(PACKET3_SET_CONTEXT_REG, 2));
+	radeon_ring_write(rdev, (VGT_VERTEX_REUSE_BLOCK_CNTL - PACKET3_SET_CONTEXT_REG_START) >> 2);
+	radeon_ring_write(rdev, 0xe);
+	radeon_ring_write(rdev, 0x10);
+	radeon_ring_unlock_commit(rdev);
+
+	return 0;
+}
+
 int evergreen_cp_resume(struct radeon_device *rdev)
 {
 	u32 tmp;
@@ -702,7 +739,7 @@ int evergreen_cp_resume(struct radeon_de
 	rdev->cp.rptr = RREG32(CP_RB_RPTR);
 	rdev->cp.wptr = RREG32(CP_RB_WPTR);
 
-	r600_cp_start(rdev);
+	evergreen_cp_start(rdev);
 	rdev->cp.ready = true;
 	r = radeon_ring_test(rdev);
 	if (r) {
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2104,10 +2104,7 @@ int r600_cp_start(struct radeon_device *
 	}
 	radeon_ring_write(rdev, PACKET3(PACKET3_ME_INITIALIZE, 5));
 	radeon_ring_write(rdev, 0x1);
-	if (rdev->family >= CHIP_CEDAR) {
-		radeon_ring_write(rdev, 0x0);
-		radeon_ring_write(rdev, rdev->config.evergreen.max_hw_contexts - 1);
-	} else if (rdev->family >= CHIP_RV770) {
+	if (rdev->family >= CHIP_RV770) {
 		radeon_ring_write(rdev, 0x0);
 		radeon_ring_write(rdev, rdev->config.rv770.max_hw_contexts - 1);
 	} else {


