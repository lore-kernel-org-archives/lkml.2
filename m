Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab2FGETH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:19:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560Ab2FGETE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:19:04 -0400
Message-Id: <20120607040343.316773054@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:24 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 48/82] drm/radeon: fix bank information in tiling config
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 29d654067a98c1cb8874c774e5fd799a038af8a6 upstream.

While there are cards with more than 8 mem banks, the max
number of banks from a tiling perspective is 8, so cap
the tiling config at 8 banks.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=43448

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen.c |    9 ++++++---
 drivers/gpu/drm/radeon/ni.c        |    9 ++++++---
 drivers/gpu/drm/radeon/rv770.c     |    8 ++++++--
 3 files changed, 18 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2136,9 +2136,12 @@ static void evergreen_gpu_init(struct ra
 	/* num banks is 8 on all fusion asics. 0 = 4, 1 = 8, 2 = 16 */
 	if (rdev->flags & RADEON_IS_IGP)
 		rdev->config.evergreen.tile_config |= 1 << 4;
-	else
-		rdev->config.evergreen.tile_config |=
-			((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT) << 4;
+	else {
+		if ((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT)
+			rdev->config.evergreen.tile_config |= 1 << 4;
+		else
+			rdev->config.evergreen.tile_config |= 0 << 4;
+	}
 	rdev->config.evergreen.tile_config |=
 		((mc_arb_ramcfg & BURSTLENGTH_MASK) >> BURSTLENGTH_SHIFT) << 8;
 	rdev->config.evergreen.tile_config |=
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -866,9 +866,12 @@ static void cayman_gpu_init(struct radeo
 	/* num banks is 8 on all fusion asics. 0 = 4, 1 = 8, 2 = 16 */
 	if (rdev->flags & RADEON_IS_IGP)
 		rdev->config.cayman.tile_config |= 1 << 4;
-	else
-		rdev->config.cayman.tile_config |=
-			((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT) << 4;
+	else {
+		if ((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT)
+			rdev->config.cayman.tile_config |= 1 << 4;
+		else
+			rdev->config.cayman.tile_config |= 0 << 4;
+	}
 	rdev->config.cayman.tile_config |=
 		((gb_addr_config & PIPE_INTERLEAVE_SIZE_MASK) >> PIPE_INTERLEAVE_SIZE_SHIFT) << 8;
 	rdev->config.cayman.tile_config |=
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -689,8 +689,12 @@ static void rv770_gpu_init(struct radeon
 
 	if (rdev->family == CHIP_RV770)
 		gb_tiling_config |= BANK_TILING(1);
-	else
-		gb_tiling_config |= BANK_TILING((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT);
+	else {
+		if ((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT)
+			gb_tiling_config |= BANK_TILING(1);
+		else
+			gb_tiling_config |= BANK_TILING(0);
+	}
 	rdev->config.rv770.tiling_nbanks = 4 << ((gb_tiling_config >> 4) & 0x3);
 	gb_tiling_config |= GROUP_SIZE((mc_arb_ramcfg & BURSTLENGTH_MASK) >> BURSTLENGTH_SHIFT);
 	if ((mc_arb_ramcfg & BURSTLENGTH_MASK) >> BURSTLENGTH_SHIFT)


