Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab0LLXp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:45:56 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44815 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab0LLXpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:44 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: alexdeucher@gmail.com, airlied@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [45/223] drm/radeon/kms: properly compute group_size on 6xx/7xx
Message-Id: <20101212234542.40F58B27C0@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:42 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alex Deucher <alexdeucher@gmail.com>

commit 881fe6c1d06bf49f4ab7aef212cdaf66bd059614 upstream.

Needed for tiled surfaces.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/radeon/r600.c  |    7 +++++--
 drivers/gpu/drm/radeon/rv770.c |    9 +++++----
 2 files changed, 10 insertions(+), 6 deletions(-)

Index: linux/drivers/gpu/drm/radeon/r600.c
===================================================================
--- linux.orig/drivers/gpu/drm/radeon/r600.c
+++ linux/drivers/gpu/drm/radeon/r600.c
@@ -1592,8 +1592,11 @@ void r600_gpu_init(struct radeon_device
 	rdev->config.r600.tiling_npipes = rdev->config.r600.max_tile_pipes;
 	rdev->config.r600.tiling_nbanks = 4 << ((ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT);
 	tiling_config |= BANK_TILING((ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT);
-	tiling_config |= GROUP_SIZE(0);
-	rdev->config.r600.tiling_group_size = 256;
+	tiling_config |= GROUP_SIZE((ramcfg & BURSTLENGTH_MASK) >> BURSTLENGTH_SHIFT);
+	if ((ramcfg & BURSTLENGTH_MASK) >> BURSTLENGTH_SHIFT)
+		rdev->config.r600.tiling_group_size = 512;
+	else
+		rdev->config.r600.tiling_group_size = 256;
 	tmp = (ramcfg & NOOFROWS_MASK) >> NOOFROWS_SHIFT;
 	if (tmp > 3) {
 		tiling_config |= ROW_TILING(3);
Index: linux/drivers/gpu/drm/radeon/rv770.c
===================================================================
--- linux.orig/drivers/gpu/drm/radeon/rv770.c
+++ linux/drivers/gpu/drm/radeon/rv770.c
@@ -627,10 +627,11 @@ static void rv770_gpu_init(struct radeon
 	else
 		gb_tiling_config |= BANK_TILING((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT);
 	rdev->config.rv770.tiling_nbanks = 4 << ((gb_tiling_config >> 4) & 0x3);
-
-	gb_tiling_config |= GROUP_SIZE(0);
-	rdev->config.rv770.tiling_group_size = 256;
-
+	gb_tiling_config |= GROUP_SIZE((mc_arb_ramcfg & BURSTLENGTH_MASK) >> BURSTLENGTH_SHIFT);
+	if ((mc_arb_ramcfg & BURSTLENGTH_MASK) >> BURSTLENGTH_SHIFT)
+		rdev->config.rv770.tiling_group_size = 512;
+	else
+		rdev->config.rv770.tiling_group_size = 256;
 	if (((mc_arb_ramcfg & NOOFROWS_MASK) >> NOOFROWS_SHIFT) > 3) {
 		gb_tiling_config |= ROW_TILING(3);
 		gb_tiling_config |= SAMPLE_SPLIT(3);
