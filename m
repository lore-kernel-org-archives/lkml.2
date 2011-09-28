Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab1I1Wnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:43:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932548Ab1I1Wnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:43:49 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:38 2011
Message-Id: <20110928220138.289473441@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [123/244] drm/radeon: Dont read from CP ring write pointer registers.
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michel Dänzer <michel.daenzer@amd.com>

commit 87463ff83bcda210d8f0ae440bd64d1548f852e7 upstream.

Apparently this doesn't always work reliably, e.g. at resume time.

Just initialize to 0, so the ring is considered empty.

Tested with hibernation on Sumo and Cayman cards.

Should fix https://bugs.launchpad.net/ubuntu/+source/linux/+bug/820746/ .

Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/evergreen.c |    4 ++--
 drivers/gpu/drm/radeon/ni.c        |   12 ++++++------
 drivers/gpu/drm/radeon/r100.c      |    6 ++----
 drivers/gpu/drm/radeon/r600.c      |    4 ++--
 4 files changed, 12 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1404,7 +1404,8 @@ int evergreen_cp_resume(struct radeon_de
 	/* Initialize the ring buffer's read and write pointers */
 	WREG32(CP_RB_CNTL, tmp | RB_RPTR_WR_ENA);
 	WREG32(CP_RB_RPTR_WR, 0);
-	WREG32(CP_RB_WPTR, 0);
+	rdev->cp.wptr = 0;
+	WREG32(CP_RB_WPTR, rdev->cp.wptr);
 
 	/* set the wb address wether it's enabled or not */
 	WREG32(CP_RB_RPTR_ADDR,
@@ -1429,7 +1430,6 @@ int evergreen_cp_resume(struct radeon_de
 	WREG32(CP_DEBUG, (1 << 27) | (1 << 28));
 
 	rdev->cp.rptr = RREG32(CP_RB_RPTR);
-	rdev->cp.wptr = RREG32(CP_RB_WPTR);
 
 	evergreen_cp_start(rdev);
 	rdev->cp.ready = true;
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -1186,7 +1186,8 @@ int cayman_cp_resume(struct radeon_devic
 
 	/* Initialize the ring buffer's read and write pointers */
 	WREG32(CP_RB0_CNTL, tmp | RB_RPTR_WR_ENA);
-	WREG32(CP_RB0_WPTR, 0);
+	rdev->cp.wptr = 0;
+	WREG32(CP_RB0_WPTR, rdev->cp.wptr);
 
 	/* set the wb address wether it's enabled or not */
 	WREG32(CP_RB0_RPTR_ADDR, (rdev->wb.gpu_addr + RADEON_WB_CP_RPTR_OFFSET) & 0xFFFFFFFC);
@@ -1206,7 +1207,6 @@ int cayman_cp_resume(struct radeon_devic
 	WREG32(CP_RB0_BASE, rdev->cp.gpu_addr >> 8);
 
 	rdev->cp.rptr = RREG32(CP_RB0_RPTR);
-	rdev->cp.wptr = RREG32(CP_RB0_WPTR);
 
 	/* ring1  - compute only */
 	/* Set ring buffer size */
@@ -1219,7 +1219,8 @@ int cayman_cp_resume(struct radeon_devic
 
 	/* Initialize the ring buffer's read and write pointers */
 	WREG32(CP_RB1_CNTL, tmp | RB_RPTR_WR_ENA);
-	WREG32(CP_RB1_WPTR, 0);
+	rdev->cp1.wptr = 0;
+	WREG32(CP_RB1_WPTR, rdev->cp1.wptr);
 
 	/* set the wb address wether it's enabled or not */
 	WREG32(CP_RB1_RPTR_ADDR, (rdev->wb.gpu_addr + RADEON_WB_CP1_RPTR_OFFSET) & 0xFFFFFFFC);
@@ -1231,7 +1232,6 @@ int cayman_cp_resume(struct radeon_devic
 	WREG32(CP_RB1_BASE, rdev->cp1.gpu_addr >> 8);
 
 	rdev->cp1.rptr = RREG32(CP_RB1_RPTR);
-	rdev->cp1.wptr = RREG32(CP_RB1_WPTR);
 
 	/* ring2 - compute only */
 	/* Set ring buffer size */
@@ -1244,7 +1244,8 @@ int cayman_cp_resume(struct radeon_devic
 
 	/* Initialize the ring buffer's read and write pointers */
 	WREG32(CP_RB2_CNTL, tmp | RB_RPTR_WR_ENA);
-	WREG32(CP_RB2_WPTR, 0);
+	rdev->cp2.wptr = 0;
+	WREG32(CP_RB2_WPTR, rdev->cp2.wptr);
 
 	/* set the wb address wether it's enabled or not */
 	WREG32(CP_RB2_RPTR_ADDR, (rdev->wb.gpu_addr + RADEON_WB_CP2_RPTR_OFFSET) & 0xFFFFFFFC);
@@ -1256,7 +1257,6 @@ int cayman_cp_resume(struct radeon_devic
 	WREG32(CP_RB2_BASE, rdev->cp2.gpu_addr >> 8);
 
 	rdev->cp2.rptr = RREG32(CP_RB2_RPTR);
-	rdev->cp2.wptr = RREG32(CP_RB2_WPTR);
 
 	/* start the rings */
 	cayman_cp_start(rdev);
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -990,7 +990,8 @@ int r100_cp_init(struct radeon_device *r
 	/* Force read & write ptr to 0 */
 	WREG32(RADEON_CP_RB_CNTL, tmp | RADEON_RB_RPTR_WR_ENA | RADEON_RB_NO_UPDATE);
 	WREG32(RADEON_CP_RB_RPTR_WR, 0);
-	WREG32(RADEON_CP_RB_WPTR, 0);
+	rdev->cp.wptr = 0;
+	WREG32(RADEON_CP_RB_WPTR, rdev->cp.wptr);
 
 	/* set the wb address whether it's enabled or not */
 	WREG32(R_00070C_CP_RB_RPTR_ADDR,
@@ -1007,9 +1008,6 @@ int r100_cp_init(struct radeon_device *r
 	WREG32(RADEON_CP_RB_CNTL, tmp);
 	udelay(10);
 	rdev->cp.rptr = RREG32(RADEON_CP_RB_RPTR);
-	rdev->cp.wptr = RREG32(RADEON_CP_RB_WPTR);
-	/* protect against crazy HW on resume */
-	rdev->cp.wptr &= rdev->cp.ptr_mask;
 	/* Set cp mode to bus mastering & enable cp*/
 	WREG32(RADEON_CP_CSQ_MODE,
 	       REG_SET(RADEON_INDIRECT2_START, indirect2_start) |
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2208,7 +2208,8 @@ int r600_cp_resume(struct radeon_device
 	/* Initialize the ring buffer's read and write pointers */
 	WREG32(CP_RB_CNTL, tmp | RB_RPTR_WR_ENA);
 	WREG32(CP_RB_RPTR_WR, 0);
-	WREG32(CP_RB_WPTR, 0);
+	rdev->cp.wptr = 0;
+	WREG32(CP_RB_WPTR, rdev->cp.wptr);
 
 	/* set the wb address whether it's enabled or not */
 	WREG32(CP_RB_RPTR_ADDR,
@@ -2233,7 +2234,6 @@ int r600_cp_resume(struct radeon_device
 	WREG32(CP_DEBUG, (1 << 27) | (1 << 28));
 
 	rdev->cp.rptr = RREG32(CP_RB_RPTR);
-	rdev->cp.wptr = RREG32(CP_RB_WPTR);
 
 	r600_cp_start(rdev);
 	rdev->cp.ready = true;


