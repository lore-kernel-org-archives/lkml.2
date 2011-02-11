Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab1BKU20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 15:28:26 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48311 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758087Ab1BKU2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 15:28:24 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6254"; a="74105721"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: davidb@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 2/3] msm: iommu: Generalize platform data for multiple targets
Date: Fri, 11 Feb 2011 12:28:17 -0800
Message-Id: <1297456098-3241-2-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1297456098-3241-1-git-send-email-stepanm@codeaurora.org>
References: <1297456098-3241-1-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the IOMMU platform data target-independent in
preparation for adding MSM8960 IOMMU support. The IOMMU
configuration on MSM8x60 and MSM8960 is identical and the
same platform data can be used for both.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/Makefile                         |    4 +-
 .../{devices-msm8x60-iommu.c => devices-iommu.c}   |   54 +++++++++----------
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h    |   36 -------------
 3 files changed, 28 insertions(+), 66 deletions(-)
 rename arch/arm/mach-msm/{devices-msm8x60-iommu.c => devices-iommu.c} (93%)

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 81f4811..2099c97 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -4,12 +4,12 @@ obj-$(CONFIG_DEBUG_FS) += clock-debug.o
 endif

 obj-$(CONFIG_MSM_VIC) += irq-vic.o
-obj-$(CONFIG_MSM_IOMMU) += iommu.o iommu_dev.o
+obj-$(CONFIG_MSM_IOMMU) += iommu.o iommu_dev.o devices-iommu.o

 obj-$(CONFIG_ARCH_MSM7X00A) += dma.o irq.o acpuclock-arm11.o
 obj-$(CONFIG_ARCH_MSM7X30) += dma.o
 obj-$(CONFIG_ARCH_QSD8X50) += dma.o sirc.o
-obj-$(CONFIG_ARCH_MSM8X60) += clock-dummy.o devices-msm8x60-iommu.o
+obj-$(CONFIG_ARCH_MSM8X60) += clock-dummy.o
 obj-$(CONFIG_ARCH_MSM8960) += clock-dummy.o

 obj-$(CONFIG_MSM_PROC_COMM) += proc_comm.o clock-pcom.o vreg.o
diff --git a/arch/arm/mach-msm/devices-msm8x60-iommu.c b/arch/arm/mach-msm/devices-iommu.c
similarity index 93%
rename from arch/arm/mach-msm/devices-msm8x60-iommu.c
rename to arch/arm/mach-msm/devices-iommu.c
index f9e7bd3..c0206b7 100644
--- a/arch/arm/mach-msm/devices-msm8x60-iommu.c
+++ b/arch/arm/mach-msm/devices-iommu.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
@@ -18,15 +18,13 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/bootmem.h>
-
-#include <mach/msm_iomap-8x60.h>
-#include <mach/irqs-8x60.h>
+#include <mach/irqs.h>
 #include <mach/iommu.h>

 static struct resource msm_iommu_jpegd_resources[] = {
 	{
-		.start = MSM_IOMMU_JPEGD_PHYS,
-		.end   = MSM_IOMMU_JPEGD_PHYS + MSM_IOMMU_JPEGD_SIZE - 1,
+		.start = 0x07300000,
+		.end   = 0x07300000 + SZ_1M - 1,
 		.name  = "physbase",
 		.flags = IORESOURCE_MEM,
 	},
@@ -46,8 +44,8 @@ static struct resource msm_iommu_jpegd_resources[] = {

 static struct resource msm_iommu_vpe_resources[] = {
 	{
-		.start = MSM_IOMMU_VPE_PHYS,
-		.end   = MSM_IOMMU_VPE_PHYS + MSM_IOMMU_VPE_SIZE - 1,
+		.start = 0x07400000,
+		.end   = 0x07400000 + SZ_1M - 1,
 		.name  = "physbase",
 		.flags = IORESOURCE_MEM,
 	},
@@ -67,8 +65,8 @@ static struct resource msm_iommu_vpe_resources[] = {

 static struct resource msm_iommu_mdp0_resources[] = {
 	{
-		.start = MSM_IOMMU_MDP0_PHYS,
-		.end   = MSM_IOMMU_MDP0_PHYS + MSM_IOMMU_MDP0_SIZE - 1,
+		.start = 0x07500000,
+		.end   = 0x07500000 + SZ_1M - 1,
 		.name  = "physbase",
 		.flags = IORESOURCE_MEM,
 	},
@@ -88,8 +86,8 @@ static struct resource msm_iommu_mdp0_resources[] = {

 static struct resource msm_iommu_mdp1_resources[] = {
 	{
-		.start = MSM_IOMMU_MDP1_PHYS,
-		.end   = MSM_IOMMU_MDP1_PHYS + MSM_IOMMU_MDP1_SIZE - 1,
+		.start = 0x07600000,
+		.end   = 0x07600000 + SZ_1M - 1,
 		.name  = "physbase",
 		.flags = IORESOURCE_MEM,
 	},
@@ -109,8 +107,8 @@ static struct resource msm_iommu_mdp1_resources[] = {

 static struct resource msm_iommu_rot_resources[] = {
 	{
-		.start = MSM_IOMMU_ROT_PHYS,
-		.end   = MSM_IOMMU_ROT_PHYS + MSM_IOMMU_ROT_SIZE - 1,
+		.start = 0x07700000,
+		.end   = 0x07700000 + SZ_1M - 1,
 		.name  = "physbase",
 		.flags = IORESOURCE_MEM,
 	},
@@ -130,8 +128,8 @@ static struct resource msm_iommu_rot_resources[] = {

 static struct resource msm_iommu_ijpeg_resources[] = {
 	{
-		.start = MSM_IOMMU_IJPEG_PHYS,
-		.end   = MSM_IOMMU_IJPEG_PHYS + MSM_IOMMU_IJPEG_SIZE - 1,
+		.start = 0x07800000,
+		.end   = 0x07800000 + SZ_1M - 1,
 		.name  = "physbase",
 		.flags = IORESOURCE_MEM,
 	},
@@ -151,8 +149,8 @@ static struct resource msm_iommu_ijpeg_resources[] = {

 static struct resource msm_iommu_vfe_resources[] = {
 	{
-		.start = MSM_IOMMU_VFE_PHYS,
-		.end   = MSM_IOMMU_VFE_PHYS + MSM_IOMMU_VFE_SIZE - 1,
+		.start = 0x07900000,
+		.end   = 0x07900000 + SZ_1M - 1,
 		.name  = "physbase",
 		.flags = IORESOURCE_MEM,
 	},
@@ -172,8 +170,8 @@ static struct resource msm_iommu_vfe_resources[] = {

 static struct resource msm_iommu_vcodec_a_resources[] = {
 	{
-		.start = MSM_IOMMU_VCODEC_A_PHYS,
-		.end   = MSM_IOMMU_VCODEC_A_PHYS + MSM_IOMMU_VCODEC_A_SIZE - 1,
+		.start = 0x07A00000,
+		.end   = 0x07A00000 + SZ_1M - 1,
 		.name  = "physbase",
 		.flags = IORESOURCE_MEM,
 	},
@@ -193,8 +191,8 @@ static struct resource msm_iommu_vcodec_a_resources[] = {

 static struct resource msm_iommu_vcodec_b_resources[] = {
 	{
-		.start = MSM_IOMMU_VCODEC_B_PHYS,
-		.end   = MSM_IOMMU_VCODEC_B_PHYS + MSM_IOMMU_VCODEC_B_SIZE - 1,
+		.start = 0x07B00000,
+		.end   = 0x07B00000 + SZ_1M - 1,
 		.name  = "physbase",
 		.flags = IORESOURCE_MEM,
 	},
@@ -214,8 +212,8 @@ static struct resource msm_iommu_vcodec_b_resources[] = {

 static struct resource msm_iommu_gfx3d_resources[] = {
 	{
-		.start = MSM_IOMMU_GFX3D_PHYS,
-		.end   = MSM_IOMMU_GFX3D_PHYS + MSM_IOMMU_GFX3D_SIZE - 1,
+		.start = 0x07C00000,
+		.end   = 0x07C00000 + SZ_1M - 1,
 		.name  = "physbase",
 		.flags = IORESOURCE_MEM,
 	},
@@ -235,8 +233,8 @@ static struct resource msm_iommu_gfx3d_resources[] = {

 static struct resource msm_iommu_gfx2d0_resources[] = {
 	{
-		.start = MSM_IOMMU_GFX2D0_PHYS,
-		.end   = MSM_IOMMU_GFX2D0_PHYS + MSM_IOMMU_GFX2D0_SIZE - 1,
+		.start = 0x07D00000,
+		.end   = 0x07D00000 + SZ_1M - 1,
 		.name  = "physbase",
 		.flags = IORESOURCE_MEM,
 	},
@@ -256,8 +254,8 @@ static struct resource msm_iommu_gfx2d0_resources[] = {

 static struct resource msm_iommu_gfx2d1_resources[] = {
 	{
-		.start = MSM_IOMMU_GFX2D1_PHYS,
-		.end   = MSM_IOMMU_GFX2D1_PHYS + MSM_IOMMU_GFX2D1_SIZE - 1,
+		.start = 0x07E00000,
+		.end   = 0x07E00000 + SZ_1M - 1,
 		.name  = "physbase",
 		.flags = IORESOURCE_MEM,
 	},
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
index 5bd18db..3b19b8f 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
@@ -62,40 +62,4 @@
 #define MSM8X60_TMR0_PHYS	0x02040000
 #define MSM8X60_TMR0_SIZE	SZ_4K

-#define MSM_IOMMU_JPEGD_PHYS	0x07300000
-#define MSM_IOMMU_JPEGD_SIZE	SZ_1M
-
-#define MSM_IOMMU_VPE_PHYS	0x07400000
-#define MSM_IOMMU_VPE_SIZE	SZ_1M
-
-#define MSM_IOMMU_MDP0_PHYS	0x07500000
-#define MSM_IOMMU_MDP0_SIZE	SZ_1M
-
-#define MSM_IOMMU_MDP1_PHYS	0x07600000
-#define MSM_IOMMU_MDP1_SIZE	SZ_1M
-
-#define MSM_IOMMU_ROT_PHYS	0x07700000
-#define MSM_IOMMU_ROT_SIZE	SZ_1M
-
-#define MSM_IOMMU_IJPEG_PHYS	0x07800000
-#define MSM_IOMMU_IJPEG_SIZE	SZ_1M
-
-#define MSM_IOMMU_VFE_PHYS	0x07900000
-#define MSM_IOMMU_VFE_SIZE	SZ_1M
-
-#define MSM_IOMMU_VCODEC_A_PHYS	0x07A00000
-#define MSM_IOMMU_VCODEC_A_SIZE	SZ_1M
-
-#define MSM_IOMMU_VCODEC_B_PHYS	0x07B00000
-#define MSM_IOMMU_VCODEC_B_SIZE	SZ_1M
-
-#define MSM_IOMMU_GFX3D_PHYS	0x07C00000
-#define MSM_IOMMU_GFX3D_SIZE	SZ_1M
-
-#define MSM_IOMMU_GFX2D0_PHYS	0x07D00000
-#define MSM_IOMMU_GFX2D0_SIZE	SZ_1M
-
-#define MSM_IOMMU_GFX2D1_PHYS	0x07E00000
-#define MSM_IOMMU_GFX2D1_SIZE	SZ_1M
-
 #endif
--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

