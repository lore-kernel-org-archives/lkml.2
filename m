Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1DZM0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:26:40 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57372 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab1DZM0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:26:38 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 12/21] drm/radeon/kms: don't apply 7xx HDP flush workaround on AGP" has been added to staging queue
Date: Tue, 26 Apr 2011 14:26:36 +0200
Message-Id: <1303820796-3745-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 12/21] drm/radeon/kms: don't apply 7xx HDP flush workaround on AGP

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 244daab8eda7388838f88f7c12708a723fb39922 Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexdeucher@gmail.com>
Date: Wed, 8 Dec 2010 10:05:34 -0500
Subject: [PATCH 12/21] drm/radeon/kms: don't apply 7xx HDP flush workaround on AGP

commit f3886f85cfde578f1d0ba6e40ac5f9d70043923b upstream.

It should be required for all 7xx asics, but seems to cause
problems on some AGP 7xx chips.

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=19002

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Reported-and-Tested-by: Duncan <1i5t5.duncan@cox.net>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/radeon/r600.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 814a621..3d70f6c 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -371,12 +371,15 @@ void r600_pcie_gart_tlb_flush(struct radeon_device *rdev)
 	u32 tmp;

 	/* flush hdp cache so updates hit vram */
-	if ((rdev->family >= CHIP_RV770) && (rdev->family <= CHIP_RV740)) {
+	if ((rdev->family >= CHIP_RV770) && (rdev->family <= CHIP_RV740) &&
+	    !(rdev->flags & RADEON_IS_AGP)) {
 		void __iomem *ptr = (void *)rdev->gart.table.vram.ptr;
 		u32 tmp;

 		/* r7xx hw bug.  write to HDP_DEBUG1 followed by fb read
 		 * rather than write to HDP_REG_COHERENCY_FLUSH_CNTL
+		 * This seems to cause problems on some AGP cards. Just use the old
+		 * method for them.
 		 */
 		WREG32(HDP_DEBUG1, 0);
 		tmp = readl((void __iomem *)ptr);
@@ -2940,10 +2943,12 @@ int r600_debugfs_mc_info_init(struct radeon_device *rdev)
 void r600_ioctl_wait_idle(struct radeon_device *rdev, struct radeon_bo *bo)
 {
 	/* r7xx hw bug.  write to HDP_DEBUG1 followed by fb read
-	 * rather than write to HDP_REG_COHERENCY_FLUSH_CNTL
+	 * rather than write to HDP_REG_COHERENCY_FLUSH_CNTL.
+	 * This seems to cause problems on some AGP cards. Just use the old
+	 * method for them.
 	 */
 	if ((rdev->family >= CHIP_RV770) && (rdev->family <= CHIP_RV740) &&
-	    rdev->vram_scratch.ptr) {
+	    rdev->vram_scratch.ptr && !(rdev->flags & RADEON_IS_AGP)) {
 		void __iomem *ptr = (void *)rdev->vram_scratch.ptr;
 		u32 tmp;

--
1.7.0.4

