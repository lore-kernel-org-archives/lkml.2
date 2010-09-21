Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab0IUQzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 12:55:13 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34318 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758025Ab0IUQzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 12:55:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=dMxNWfAV3eBRf4ikfA1JqQKjL48sVU6TkzRMVHuhvZEeiPeMuxw30tHHDKg61q46HM
         TLnCRX8NR8ZPD+H2sBrwTkzXbeC+ej6YPwekc9RX0JG7lWi3+NnWHoe+Gvb4xMHpWOXD
         g0icxF+yIA269PPX7UhLKYMJbu/gGrAgA7JqA=
MIME-Version: 1.0
Date: Tue, 21 Sep 2010 17:55:11 +0100
Message-ID: <AANLkTikCHktMEKu_RfNCS4=jYf-Y5c871axmNRJFhr8a@mail.gmail.com>
Subject: [2.6.36-rc5] DRM resource leak fixes...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex; for your review:

Fix up some indirect and scratch buffer leaks, and correctly release a
buffer object along various error paths.

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index e817a0b..5a7d6a0 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -3540,9 +3540,9 @@ int r100_ib_test(struct radeon_device *rdev)
 	}
 	WREG32(scratch, 0xCAFEDEAD);
 	r = radeon_ib_get(rdev, &ib);
-	if (r) {
-		return r;
-	}
+	if (r)
+		goto out2;
+
 	ib->ptr[0] = PACKET0(scratch, 0);
 	ib->ptr[1] = 0xDEADBEEF;
 	ib->ptr[2] = PACKET2(0);
@@ -3553,15 +3553,13 @@ int r100_ib_test(struct radeon_device *rdev)
 	ib->ptr[7] = PACKET2(0);
 	ib->length_dw = 8;
 	r = radeon_ib_schedule(rdev, ib);
-	if (r) {
-		radeon_scratch_free(rdev, scratch);
-		radeon_ib_free(rdev, &ib);
-		return r;
-	}
+	if (r)
+		goto out1;
+
 	r = radeon_fence_wait(ib->fence, false);
-	if (r) {
-		return r;
-	}
+	if (r)
+		goto out1;
+
 	for (i = 0; i < rdev->usec_timeout; i++) {
 		tmp = RREG32(scratch);
 		if (tmp == 0xDEADBEEF) {
@@ -3576,8 +3574,10 @@ int r100_ib_test(struct radeon_device *rdev)
 			  scratch, tmp);
 		r = -EINVAL;
 	}
-	radeon_scratch_free(rdev, scratch);
+out1:
 	radeon_ib_free(rdev, &ib);
+out2:
+	radeon_scratch_free(rdev, scratch);
 	return r;
 }

diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index afc18d8..bfdfa3e 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2689,7 +2689,7 @@ int r600_ib_test(struct radeon_device *rdev)
 	r = radeon_ib_get(rdev, &ib);
 	if (r) {
 		DRM_ERROR("radeon: failed to get ib (%d).\n", r);
-		return r;
+		goto out2;
 	}
 	ib->ptr[0] = PACKET3(PACKET3_SET_CONFIG_REG, 1);
 	ib->ptr[1] = ((scratch - PACKET3_SET_CONFIG_REG_OFFSET) >> 2);
@@ -2710,15 +2710,13 @@ int r600_ib_test(struct radeon_device *rdev)
 	ib->length_dw = 16;
 	r = radeon_ib_schedule(rdev, ib);
 	if (r) {
-		radeon_scratch_free(rdev, scratch);
-		radeon_ib_free(rdev, &ib);
 		DRM_ERROR("radeon: failed to schedule ib (%d).\n", r);
-		return r;
+		goto out1;
 	}
 	r = radeon_fence_wait(ib->fence, false);
 	if (r) {
 		DRM_ERROR("radeon: fence wait failed (%d).\n", r);
-		return r;
+		goto out1;
 	}
 	for (i = 0; i < rdev->usec_timeout; i++) {
 		tmp = RREG32(scratch);
@@ -2733,8 +2731,10 @@ int r600_ib_test(struct radeon_device *rdev)
 			  scratch, tmp);
 		r = -EINVAL;
 	}
-	radeon_scratch_free(rdev, scratch);
+out1:
 	radeon_ib_free(rdev, &ib);
+out2:
+	radeon_scratch_free(rdev, scratch);
 	return r;
 }

diff --git a/drivers/gpu/drm/radeon/r600_blit_kms.c
b/drivers/gpu/drm/radeon/r600_blit_kms.c
index d13622a..e532a81 100644
--- a/drivers/gpu/drm/radeon/r600_blit_kms.c
+++ b/drivers/gpu/drm/radeon/r600_blit_kms.c
@@ -492,6 +492,7 @@ int r600_blit_init(struct radeon_device *rdev)
 	r = radeon_bo_kmap(rdev->r600_blit.shader_obj, &ptr);
 	if (r) {
 		DRM_ERROR("failed to map blit object %d\n", r);
+		radeon_bo_unreserve(rdev->r600_blit.shader_obj);
 		return r;
 	}
 	if (rdev->family >= CHIP_RV770)
-- 
Daniel J Blueman
