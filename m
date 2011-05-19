Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886Ab1ESSIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:08:00 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48705 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933842Ab1ESSH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:07:59 -0400
X-Sasl-enc: 4Sa5y5+4C5CAGGzgrvxLvpE0hsKU/LK8t5Nbh8lPsI/p 1305828478
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:55 2011
Message-Id: <20110519180555.537975272@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:04:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>,
        Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [13/71] [stable] [PATCH] drm/radeon/kms: fix gart setup on fusion parts (v2) backport
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

Backport of 8aeb96f80232e9a701b5c4715504f4c9173978bd
(drm/radeon/kms: fix gart setup on fusion parts (v2))
to the stable tree.

Out of the entire GART/VM subsystem, the hw designers changed
the location of 3 regs.

v2: airlied: add parameter for userspace to work from.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpu/drm/radeon/evergreen.c  |   17 +++++++++--------
 drivers/gpu/drm/radeon/evergreend.h |    5 +++++
 drivers/gpu/drm/radeon/radeon_kms.c |    3 +++
 include/drm/radeon_drm.h            |    1 +
 4 files changed, 18 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -869,9 +869,15 @@ int evergreen_pcie_gart_enable(struct ra
 		SYSTEM_ACCESS_MODE_NOT_IN_SYS |
 		SYSTEM_APERTURE_UNMAPPED_ACCESS_PASS_THRU |
 		EFFECTIVE_L1_TLB_SIZE(5) | EFFECTIVE_L1_QUEUE_SIZE(5);
-	WREG32(MC_VM_MD_L1_TLB0_CNTL, tmp);
-	WREG32(MC_VM_MD_L1_TLB1_CNTL, tmp);
-	WREG32(MC_VM_MD_L1_TLB2_CNTL, tmp);
+	if (rdev->flags & RADEON_IS_IGP) {
+		WREG32(FUS_MC_VM_MD_L1_TLB0_CNTL, tmp);
+		WREG32(FUS_MC_VM_MD_L1_TLB1_CNTL, tmp);
+		WREG32(FUS_MC_VM_MD_L1_TLB2_CNTL, tmp);
+	} else {
+		WREG32(MC_VM_MD_L1_TLB0_CNTL, tmp);
+		WREG32(MC_VM_MD_L1_TLB1_CNTL, tmp);
+		WREG32(MC_VM_MD_L1_TLB2_CNTL, tmp);
+	}
 	WREG32(MC_VM_MB_L1_TLB0_CNTL, tmp);
 	WREG32(MC_VM_MB_L1_TLB1_CNTL, tmp);
 	WREG32(MC_VM_MB_L1_TLB2_CNTL, tmp);
@@ -2930,11 +2936,6 @@ static int evergreen_startup(struct rade
 		rdev->asic->copy = NULL;
 		dev_warn(rdev->dev, "failed blitter (%d) falling back to memcpy\n", r);
 	}
-	/* XXX: ontario has problems blitting to gart at the moment */
-	if (rdev->family == CHIP_PALM) {
-		rdev->asic->copy = NULL;
-		radeon_ttm_set_active_vram_size(rdev, rdev->mc.visible_vram_size);
-	}
 
 	/* allocate wb buffer */
 	r = radeon_wb_init(rdev);
--- a/drivers/gpu/drm/radeon/evergreend.h
+++ b/drivers/gpu/drm/radeon/evergreend.h
@@ -221,6 +221,11 @@
 #define	MC_VM_MD_L1_TLB0_CNTL				0x2654
 #define	MC_VM_MD_L1_TLB1_CNTL				0x2658
 #define	MC_VM_MD_L1_TLB2_CNTL				0x265C
+
+#define	FUS_MC_VM_MD_L1_TLB0_CNTL			0x265C
+#define	FUS_MC_VM_MD_L1_TLB1_CNTL			0x2660
+#define	FUS_MC_VM_MD_L1_TLB2_CNTL			0x2664
+
 #define	MC_VM_SYSTEM_APERTURE_DEFAULT_ADDR		0x203C
 #define	MC_VM_SYSTEM_APERTURE_HIGH_ADDR			0x2038
 #define	MC_VM_SYSTEM_APERTURE_LOW_ADDR			0x2034
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -205,6 +205,9 @@ int radeon_info_ioctl(struct drm_device
 		/* return clock value in KHz */
 		value = rdev->clock.spll.reference_freq * 10;
 		break;
+	case RADEON_INFO_FUSION_GART_WORKING:
+		value = 1;
+		break;
 	default:
 		DRM_DEBUG_KMS("Invalid request %d\n", info->request);
 		return -EINVAL;
--- a/include/drm/radeon_drm.h
+++ b/include/drm/radeon_drm.h
@@ -908,6 +908,7 @@ struct drm_radeon_cs {
 #define RADEON_INFO_WANT_HYPERZ		0x07
 #define RADEON_INFO_WANT_CMASK		0x08 /* get access to CMASK on r300 */
 #define RADEON_INFO_CLOCK_CRYSTAL_FREQ	0x09 /* clock crystal frequency */
+#define RADEON_INFO_FUSION_GART_WORKING	0x0c /* fusion writes to GTT were broken before this */
 
 struct drm_radeon_info {
 	uint32_t		request;


