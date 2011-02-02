Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab1BBApb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:45:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:26982 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab1BBAp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="883418509"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: sconklin@canonical.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [138/139] Revert drm/radeon/kms: properly compute group_size on 6xx/7xx
Message-Id: <20110202004538.285EC3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Conklin <sconklin@canonical.com>

We discovered a regression for Radeon users in our latest proposed
kernel for 2.6.35 (Maverick), and have isolated it to this patch:

http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.35.y.git;a=commit;h=b8e9a4a45f8427837f4dba89
+bda4d4e3f3a5c726

We took that patch as part of 2.6.35.10, and one of our testers has
reported that our build of that kernel also exhibits the problem.

These are mainline kernels built with the Ubuntu configs.
http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.35.10-maverick/

Our bug report is here:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/703553

Upstream bug report:

https://bugzilla.kernel.org/show_bug.cgi?id=24802

Index: linux-2.6.35.y/drivers/gpu/drm/radeon/r600.c
===================================================================
--- linux-2.6.35.y.orig/drivers/gpu/drm/radeon/r600.c
+++ linux-2.6.35.y/drivers/gpu/drm/radeon/r600.c
@@ -1597,11 +1597,8 @@ void r600_gpu_init(struct radeon_device 
 	rdev->config.r600.tiling_npipes = rdev->config.r600.max_tile_pipes;
 	rdev->config.r600.tiling_nbanks = 4 << ((ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT);
 	tiling_config |= BANK_TILING((ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT);
-	tiling_config |= GROUP_SIZE((ramcfg & BURSTLENGTH_MASK) >> BURSTLENGTH_SHIFT);
-	if ((ramcfg & BURSTLENGTH_MASK) >> BURSTLENGTH_SHIFT)
-		rdev->config.r600.tiling_group_size = 512;
-	else
-		rdev->config.r600.tiling_group_size = 256;
+	tiling_config |= GROUP_SIZE(0);
+	rdev->config.r600.tiling_group_size = 256;
 	tmp = (ramcfg & NOOFROWS_MASK) >> NOOFROWS_SHIFT;
 	if (tmp > 3) {
 		tiling_config |= ROW_TILING(3);
Index: linux-2.6.35.y/drivers/gpu/drm/radeon/rv770.c
===================================================================
--- linux-2.6.35.y.orig/drivers/gpu/drm/radeon/rv770.c
+++ linux-2.6.35.y/drivers/gpu/drm/radeon/rv770.c
@@ -627,11 +627,10 @@ static void rv770_gpu_init(struct radeon
 	else
 		gb_tiling_config |= BANK_TILING((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT);
 	rdev->config.rv770.tiling_nbanks = 4 << ((gb_tiling_config >> 4) & 0x3);
-	gb_tiling_config |= GROUP_SIZE((mc_arb_ramcfg & BURSTLENGTH_MASK) >> BURSTLENGTH_SHIFT);
-	if ((mc_arb_ramcfg & BURSTLENGTH_MASK) >> BURSTLENGTH_SHIFT)
-		rdev->config.rv770.tiling_group_size = 512;
-	else
-		rdev->config.rv770.tiling_group_size = 256;
+
+	gb_tiling_config |= GROUP_SIZE(0);
+	rdev->config.rv770.tiling_group_size = 256;
+
 	if (((mc_arb_ramcfg & NOOFROWS_MASK) >> NOOFROWS_SHIFT) > 3) {
 		gb_tiling_config |= ROW_TILING(3);
 		gb_tiling_config |= SAMPLE_SPLIT(3);
