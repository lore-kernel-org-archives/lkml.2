Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab1AFA2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:28:54 -0500
Received: from kroah.org ([198.145.64.141]:35390 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab1AFA2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:28:52 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:22:57 2011
Message-Id: <20110106002257.543754276@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:21:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [009/152] drm/radeon/kms: dont apply 7xx HDP flush workaround on AGP
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit f3886f85cfde578f1d0ba6e40ac5f9d70043923b upstream.

It should be required for all 7xx asics, but seems to cause
problems on some AGP 7xx chips.

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=19002

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Reported-and-Tested-by: Duncan <1i5t5.duncan@cox.net>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/r600.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -878,12 +878,15 @@ void r600_pcie_gart_tlb_flush(struct rad
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
@@ -3525,10 +3528,12 @@ int r600_debugfs_mc_info_init(struct rad
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
 


