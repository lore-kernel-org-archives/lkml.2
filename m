Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964998Ab0HFSgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:36:41 -0400
Received: from kroah.org ([198.145.64.141]:48750 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964961Ab0HFSgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:36:12 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:32:03 2010
Message-Id: <20100806183203.235235513@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:30:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [36/38] drm/radeon/kms: handle the case of no active displays properly in the bandwidth code
In-Reply-To: <20100806183250.GA23019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit e06b14ee91a2ddefc9a67443a6cd8ee0fa800115 upstream.

Logic was:
if (mode0 && mode1)
else if (mode0)
else

Should be:
if (mode0 && mode1)
else if (mode0)
else if (mode1)

Otherwise we may end up calculating the priority regs with
unitialized values.

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=16492

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/rs690.c |   27 +++++++++------------------
 drivers/gpu/drm/radeon/rv515.c |   23 +++++++++--------------
 2 files changed, 18 insertions(+), 32 deletions(-)

--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -398,7 +398,9 @@ void rs690_bandwidth_update(struct radeo
 	struct drm_display_mode *mode1 = NULL;
 	struct rs690_watermark wm0;
 	struct rs690_watermark wm1;
-	u32 tmp, d1mode_priority_a_cnt, d2mode_priority_a_cnt;
+	u32 tmp;
+	u32 d1mode_priority_a_cnt = S_006548_D1MODE_PRIORITY_A_OFF(1);
+	u32 d2mode_priority_a_cnt = S_006548_D1MODE_PRIORITY_A_OFF(1);
 	fixed20_12 priority_mark02, priority_mark12, fill_rate;
 	fixed20_12 a, b;
 
@@ -495,10 +497,6 @@ void rs690_bandwidth_update(struct radeo
 			d1mode_priority_a_cnt |= S_006548_D1MODE_PRIORITY_A_ALWAYS_ON(1);
 			d2mode_priority_a_cnt |= S_006D48_D2MODE_PRIORITY_A_ALWAYS_ON(1);
 		}
-		WREG32(R_006548_D1MODE_PRIORITY_A_CNT, d1mode_priority_a_cnt);
-		WREG32(R_00654C_D1MODE_PRIORITY_B_CNT, d1mode_priority_a_cnt);
-		WREG32(R_006D48_D2MODE_PRIORITY_A_CNT, d2mode_priority_a_cnt);
-		WREG32(R_006D4C_D2MODE_PRIORITY_B_CNT, d2mode_priority_a_cnt);
 	} else if (mode0) {
 		if (dfixed_trunc(wm0.dbpp) > 64)
 			a.full = dfixed_mul(wm0.dbpp, wm0.num_line_pair);
@@ -528,13 +526,7 @@ void rs690_bandwidth_update(struct radeo
 		d1mode_priority_a_cnt = dfixed_trunc(priority_mark02);
 		if (rdev->disp_priority == 2)
 			d1mode_priority_a_cnt |= S_006548_D1MODE_PRIORITY_A_ALWAYS_ON(1);
-		WREG32(R_006548_D1MODE_PRIORITY_A_CNT, d1mode_priority_a_cnt);
-		WREG32(R_00654C_D1MODE_PRIORITY_B_CNT, d1mode_priority_a_cnt);
-		WREG32(R_006D48_D2MODE_PRIORITY_A_CNT,
-			S_006D48_D2MODE_PRIORITY_A_OFF(1));
-		WREG32(R_006D4C_D2MODE_PRIORITY_B_CNT,
-			S_006D4C_D2MODE_PRIORITY_B_OFF(1));
-	} else {
+	} else if (mode1) {
 		if (dfixed_trunc(wm1.dbpp) > 64)
 			a.full = dfixed_mul(wm1.dbpp, wm1.num_line_pair);
 		else
@@ -563,13 +555,12 @@ void rs690_bandwidth_update(struct radeo
 		d2mode_priority_a_cnt = dfixed_trunc(priority_mark12);
 		if (rdev->disp_priority == 2)
 			d2mode_priority_a_cnt |= S_006D48_D2MODE_PRIORITY_A_ALWAYS_ON(1);
-		WREG32(R_006548_D1MODE_PRIORITY_A_CNT,
-			S_006548_D1MODE_PRIORITY_A_OFF(1));
-		WREG32(R_00654C_D1MODE_PRIORITY_B_CNT,
-			S_00654C_D1MODE_PRIORITY_B_OFF(1));
-		WREG32(R_006D48_D2MODE_PRIORITY_A_CNT, d2mode_priority_a_cnt);
-		WREG32(R_006D4C_D2MODE_PRIORITY_B_CNT, d2mode_priority_a_cnt);
 	}
+
+	WREG32(R_006548_D1MODE_PRIORITY_A_CNT, d1mode_priority_a_cnt);
+	WREG32(R_00654C_D1MODE_PRIORITY_B_CNT, d1mode_priority_a_cnt);
+	WREG32(R_006D48_D2MODE_PRIORITY_A_CNT, d2mode_priority_a_cnt);
+	WREG32(R_006D4C_D2MODE_PRIORITY_B_CNT, d2mode_priority_a_cnt);
 }
 
 uint32_t rs690_mc_rreg(struct radeon_device *rdev, uint32_t reg)
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -925,7 +925,9 @@ void rv515_bandwidth_avivo_update(struct
 	struct drm_display_mode *mode1 = NULL;
 	struct rv515_watermark wm0;
 	struct rv515_watermark wm1;
-	u32 tmp, d1mode_priority_a_cnt, d2mode_priority_a_cnt;
+	u32 tmp;
+	u32 d1mode_priority_a_cnt = MODE_PRIORITY_OFF;
+	u32 d2mode_priority_a_cnt = MODE_PRIORITY_OFF;
 	fixed20_12 priority_mark02, priority_mark12, fill_rate;
 	fixed20_12 a, b;
 
@@ -999,10 +1001,6 @@ void rv515_bandwidth_avivo_update(struct
 			d1mode_priority_a_cnt |= MODE_PRIORITY_ALWAYS_ON;
 			d2mode_priority_a_cnt |= MODE_PRIORITY_ALWAYS_ON;
 		}
-		WREG32(D1MODE_PRIORITY_A_CNT, d1mode_priority_a_cnt);
-		WREG32(D1MODE_PRIORITY_B_CNT, d1mode_priority_a_cnt);
-		WREG32(D2MODE_PRIORITY_A_CNT, d2mode_priority_a_cnt);
-		WREG32(D2MODE_PRIORITY_B_CNT, d2mode_priority_a_cnt);
 	} else if (mode0) {
 		if (dfixed_trunc(wm0.dbpp) > 64)
 			a.full = dfixed_div(wm0.dbpp, wm0.num_line_pair);
@@ -1032,11 +1030,7 @@ void rv515_bandwidth_avivo_update(struct
 		d1mode_priority_a_cnt = dfixed_trunc(priority_mark02);
 		if (rdev->disp_priority == 2)
 			d1mode_priority_a_cnt |= MODE_PRIORITY_ALWAYS_ON;
-		WREG32(D1MODE_PRIORITY_A_CNT, d1mode_priority_a_cnt);
-		WREG32(D1MODE_PRIORITY_B_CNT, d1mode_priority_a_cnt);
-		WREG32(D2MODE_PRIORITY_A_CNT, MODE_PRIORITY_OFF);
-		WREG32(D2MODE_PRIORITY_B_CNT, MODE_PRIORITY_OFF);
-	} else {
+	} else if (mode1) {
 		if (dfixed_trunc(wm1.dbpp) > 64)
 			a.full = dfixed_div(wm1.dbpp, wm1.num_line_pair);
 		else
@@ -1065,11 +1059,12 @@ void rv515_bandwidth_avivo_update(struct
 		d2mode_priority_a_cnt = dfixed_trunc(priority_mark12);
 		if (rdev->disp_priority == 2)
 			d2mode_priority_a_cnt |= MODE_PRIORITY_ALWAYS_ON;
-		WREG32(D1MODE_PRIORITY_A_CNT, MODE_PRIORITY_OFF);
-		WREG32(D1MODE_PRIORITY_B_CNT, MODE_PRIORITY_OFF);
-		WREG32(D2MODE_PRIORITY_A_CNT, d2mode_priority_a_cnt);
-		WREG32(D2MODE_PRIORITY_B_CNT, d2mode_priority_a_cnt);
 	}
+
+	WREG32(D1MODE_PRIORITY_A_CNT, d1mode_priority_a_cnt);
+	WREG32(D1MODE_PRIORITY_B_CNT, d1mode_priority_a_cnt);
+	WREG32(D2MODE_PRIORITY_A_CNT, d2mode_priority_a_cnt);
+	WREG32(D2MODE_PRIORITY_B_CNT, d2mode_priority_a_cnt);
 }
 
 void rv515_bandwidth_update(struct radeon_device *rdev)


