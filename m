Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761937Ab2FHFVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:21:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43175 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760208Ab2FHFHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:22 -0400
Message-Id: <20120608041847.143900866@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:27 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 47/82] drm/radeon: properly program gart on rv740, juniper, cypress, barts,
 hemlock
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0b8c30bc4943137a4a36b9cb059b1cc684f5d702 upstream.

Need to program an additional VM register.  This doesn't not currently
cause any problems, but allows us to program the proper backend
map in a subsequent patch which should improve performance on these
asics.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/evergreen.c  |    5 +++++
 drivers/gpu/drm/radeon/evergreend.h |    1 +
 drivers/gpu/drm/radeon/rv770.c      |    2 ++
 drivers/gpu/drm/radeon/rv770d.h     |    1 +
 4 files changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 5d9c2c6..0408ac2 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1029,6 +1029,11 @@ int evergreen_pcie_gart_enable(struct radeon_device *rdev)
 		WREG32(MC_VM_MD_L1_TLB0_CNTL, tmp);
 		WREG32(MC_VM_MD_L1_TLB1_CNTL, tmp);
 		WREG32(MC_VM_MD_L1_TLB2_CNTL, tmp);
+		if ((rdev->family == CHIP_JUNIPER) ||
+		    (rdev->family == CHIP_CYPRESS) ||
+		    (rdev->family == CHIP_HEMLOCK) ||
+		    (rdev->family == CHIP_BARTS))
+			WREG32(MC_VM_MD_L1_TLB3_CNTL, tmp);
 	}
 	WREG32(MC_VM_MB_L1_TLB0_CNTL, tmp);
 	WREG32(MC_VM_MB_L1_TLB1_CNTL, tmp);
diff --git a/drivers/gpu/drm/radeon/evergreend.h b/drivers/gpu/drm/radeon/evergreend.h
index 79130bf..3dd43e7 100644
--- a/drivers/gpu/drm/radeon/evergreend.h
+++ b/drivers/gpu/drm/radeon/evergreend.h
@@ -452,6 +452,7 @@
 #define	MC_VM_MD_L1_TLB0_CNTL				0x2654
 #define	MC_VM_MD_L1_TLB1_CNTL				0x2658
 #define	MC_VM_MD_L1_TLB2_CNTL				0x265C
+#define	MC_VM_MD_L1_TLB3_CNTL				0x2698
 
 #define	FUS_MC_VM_MD_L1_TLB0_CNTL			0x265C
 #define	FUS_MC_VM_MD_L1_TLB1_CNTL			0x2660
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index c824d49..c12349d 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -151,6 +151,8 @@ int rv770_pcie_gart_enable(struct radeon_device *rdev)
 	WREG32(MC_VM_MD_L1_TLB0_CNTL, tmp);
 	WREG32(MC_VM_MD_L1_TLB1_CNTL, tmp);
 	WREG32(MC_VM_MD_L1_TLB2_CNTL, tmp);
+	if (rdev->family == CHIP_RV740)
+		WREG32(MC_VM_MD_L1_TLB3_CNTL, tmp);
 	WREG32(MC_VM_MB_L1_TLB0_CNTL, tmp);
 	WREG32(MC_VM_MB_L1_TLB1_CNTL, tmp);
 	WREG32(MC_VM_MB_L1_TLB2_CNTL, tmp);
diff --git a/drivers/gpu/drm/radeon/rv770d.h b/drivers/gpu/drm/radeon/rv770d.h
index 9c549f7..7addbef 100644
--- a/drivers/gpu/drm/radeon/rv770d.h
+++ b/drivers/gpu/drm/radeon/rv770d.h
@@ -174,6 +174,7 @@
 #define	MC_VM_MD_L1_TLB0_CNTL				0x2654
 #define	MC_VM_MD_L1_TLB1_CNTL				0x2658
 #define	MC_VM_MD_L1_TLB2_CNTL				0x265C
+#define	MC_VM_MD_L1_TLB3_CNTL				0x2698
 #define	MC_VM_SYSTEM_APERTURE_DEFAULT_ADDR		0x203C
 #define	MC_VM_SYSTEM_APERTURE_HIGH_ADDR			0x2038
 #define	MC_VM_SYSTEM_APERTURE_LOW_ADDR			0x2034


