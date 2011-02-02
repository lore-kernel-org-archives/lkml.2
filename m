Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1BBBMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:12:16 -0500
Received: from mga03.intel.com ([143.182.124.21]:59383 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259Ab1BBAnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960291"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: alexdeucher@gmail.com, ak@linux.intel.com, airlied@redhat.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [7/139] drm/radeon/kms: don't apply 7xx HDP flush workaround on AGP
Message-Id: <20110202004321.10FEA3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alex Deucher <alexdeucher@gmail.com>

commit f3886f85cfde578f1d0ba6e40ac5f9d70043923b upstream.

It should be required for all 7xx asics, but seems to cause
problems on some AGP 7xx chips.

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=19002

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reported-and-Tested-by: Duncan <1i5t5.duncan@cox.net>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/r600.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/drivers/gpu/drm/radeon/r600.c
===================================================================
--- linux-2.6.35.y.orig/drivers/gpu/drm/radeon/r600.c
+++ linux-2.6.35.y/drivers/gpu/drm/radeon/r600.c
@@ -869,12 +869,15 @@ void r600_pcie_gart_tlb_flush(struct rad
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
@@ -3523,10 +3526,12 @@ int r600_debugfs_mc_info_init(struct rad
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
 
