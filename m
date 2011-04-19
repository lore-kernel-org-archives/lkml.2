Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab1DSUSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:18:45 -0400
Received: from kroah.org ([198.145.64.141]:35771 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954Ab1DSURt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:49 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:50 2011
Message-Id: <20110419201050.455232840@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:09:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Michel=20D=C3=A4nzer?= <daenzer@vmware.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [68/70] radeon: Fix KMS CP writeback on big endian machines.
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <daenzer@vmware.com>

commit dc66b325f161bb651493c7d96ad44876b629cf6a upstream.

This is necessary even with PCI(e) GART, and it makes writeback work even with
AGP on my PowerBook. Might still be unreliable with older revisions of UniNorth
and other AGP bridges though.

Signed-off-by: Michel Dänzer <daenzer@vmware.com>
Reviewed-by: Alex Deucher <alex.deucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_fence.c |    2 +-
 drivers/gpu/drm/radeon/radeon_ring.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_fence.c
+++ b/drivers/gpu/drm/radeon/radeon_fence.c
@@ -80,7 +80,7 @@ static bool radeon_fence_poll_locked(str
 			scratch_index = R600_WB_EVENT_OFFSET + rdev->fence_drv.scratch_reg - rdev->scratch.reg_base;
 		else
 			scratch_index = RADEON_WB_SCRATCH_OFFSET + rdev->fence_drv.scratch_reg - rdev->scratch.reg_base;
-		seq = rdev->wb.wb[scratch_index/4];
+		seq = le32_to_cpu(rdev->wb.wb[scratch_index/4]);
 	} else
 		seq = RREG32(rdev->fence_drv.scratch_reg);
 	if (seq != rdev->fence_drv.last_seq) {
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -248,7 +248,7 @@ void radeon_ib_pool_fini(struct radeon_d
 void radeon_ring_free_size(struct radeon_device *rdev)
 {
 	if (rdev->wb.enabled)
-		rdev->cp.rptr = rdev->wb.wb[RADEON_WB_CP_RPTR_OFFSET/4];
+		rdev->cp.rptr = le32_to_cpu(rdev->wb.wb[RADEON_WB_CP_RPTR_OFFSET/4]);
 	else {
 		if (rdev->family >= CHIP_R600)
 			rdev->cp.rptr = RREG32(R600_CP_RB_RPTR);


