Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761960Ab2FHFVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:21:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43173 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760146Ab2FHFHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:22 -0400
Message-Id: <20120608041847.012293416@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:26 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 46/82] drm/radeon: fix bank information in tiling config
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

commit 29d654067a98c1cb8874c774e5fd799a038af8a6 upstream.

While there are cards with more than 8 mem banks, the max
number of banks from a tiling perspective is 8, so cap
the tiling config at 8 banks.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=43448

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
[bwh: Backported to 3.2: fix up context and indentation for missing
 IGP condition in ni.c]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/evergreen.c |    9 ++++++---
 drivers/gpu/drm/radeon/ni.c        |    9 ++++++---
 drivers/gpu/drm/radeon/rv770.c     |    8 ++++++--
 3 files changed, 18 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2074,9 +2074,12 @@
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
@@ -804,8 +804,10 @@
 		rdev->config.cayman.tile_config |= (3 << 0);
 		break;
 	}
-	rdev->config.cayman.tile_config |=
-		((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT) << 4;
+	if ((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT)
+		rdev->config.cayman.tile_config |= 1 << 4;
+	else
+		rdev->config.cayman.tile_config |= 0 << 4;
 	rdev->config.cayman.tile_config |=
 		((gb_addr_config & PIPE_INTERLEAVE_SIZE_MASK) >> PIPE_INTERLEAVE_SIZE_SHIFT) << 8;
 	rdev->config.cayman.tile_config |=
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -689,8 +689,12 @@
 
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


