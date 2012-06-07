Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab2FGETM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:19:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab2FGETI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:19:08 -0400
Message-Id: <20120607040343.436193482@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:25 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 49/82] drm/radeon: properly program gart on rv740, juniper, cypress, barts, hemlock
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0b8c30bc4943137a4a36b9cb059b1cc684f5d702 upstream.

Need to program an additional VM register.  This doesn't not currently
cause any problems, but allows us to program the proper backend
map in a subsequent patch which should improve performance on these
asics.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen.c  |    5 +++++
 drivers/gpu/drm/radeon/evergreend.h |    1 +
 drivers/gpu/drm/radeon/rv770.c      |    2 ++
 drivers/gpu/drm/radeon/rv770d.h     |    1 +
 4 files changed, 9 insertions(+)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1029,6 +1029,11 @@ int evergreen_pcie_gart_enable(struct ra
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
--- a/drivers/gpu/drm/radeon/evergreend.h
+++ b/drivers/gpu/drm/radeon/evergreend.h
@@ -232,6 +232,7 @@
 #define	MC_VM_MD_L1_TLB0_CNTL				0x2654
 #define	MC_VM_MD_L1_TLB1_CNTL				0x2658
 #define	MC_VM_MD_L1_TLB2_CNTL				0x265C
+#define	MC_VM_MD_L1_TLB3_CNTL				0x2698
 
 #define	FUS_MC_VM_MD_L1_TLB0_CNTL			0x265C
 #define	FUS_MC_VM_MD_L1_TLB1_CNTL			0x2660
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -151,6 +151,8 @@ int rv770_pcie_gart_enable(struct radeon
 	WREG32(MC_VM_MD_L1_TLB0_CNTL, tmp);
 	WREG32(MC_VM_MD_L1_TLB1_CNTL, tmp);
 	WREG32(MC_VM_MD_L1_TLB2_CNTL, tmp);
+	if (rdev->family == CHIP_RV740)
+		WREG32(MC_VM_MD_L1_TLB3_CNTL, tmp);
 	WREG32(MC_VM_MB_L1_TLB0_CNTL, tmp);
 	WREG32(MC_VM_MB_L1_TLB1_CNTL, tmp);
 	WREG32(MC_VM_MB_L1_TLB2_CNTL, tmp);
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


