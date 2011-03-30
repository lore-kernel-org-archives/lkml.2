Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825Ab1C3Vyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:54:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:17364 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933370Ab1C3VHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447419"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: alexdeucher@gmail.com, airlied@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [83/275] drm/radeon/kms: fix s/r issues with bios scratch regs
Message-Id: <20110330210521.154DC3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alex Deucher <alexdeucher@gmail.com>

commit 87364760de5d631390c478fcbac8db1b926e0adf upstream.

The accelerate mode bit gets checked by certain atom
command tables to set up some register state.  It needs
to be clear when setting modes and set when not.

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=26942

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/drivers/gpu/drm/radeon/radeon_atombios.c
===================================================================
--- linux-2.6.35.y.orig/drivers/gpu/drm/radeon/radeon_atombios.c	2011-03-29 23:02:59.818304820 -0700
+++ linux-2.6.35.y/drivers/gpu/drm/radeon/radeon_atombios.c	2011-03-29 23:02:59.873303412 -0700
@@ -2125,7 +2125,7 @@
 	bios_2_scratch &= ~ATOM_S2_VRI_BRIGHT_ENABLE;
 
 	/* tell the bios not to handle mode switching */
-	bios_6_scratch |= (ATOM_S6_ACC_BLOCK_DISPLAY_SWITCH | ATOM_S6_ACC_MODE);
+	bios_6_scratch |= ATOM_S6_ACC_BLOCK_DISPLAY_SWITCH;
 
 	if (rdev->family >= CHIP_R600) {
 		WREG32(R600_BIOS_2_SCRATCH, bios_2_scratch);
@@ -2176,10 +2176,13 @@
 	else
 		bios_6_scratch = RREG32(RADEON_BIOS_6_SCRATCH);
 
-	if (lock)
+	if (lock) {
 		bios_6_scratch |= ATOM_S6_CRITICAL_STATE;
-	else
+		bios_6_scratch &= ~ATOM_S6_ACC_MODE;
+	} else {
 		bios_6_scratch &= ~ATOM_S6_CRITICAL_STATE;
+		bios_6_scratch |= ATOM_S6_ACC_MODE;
+	}
 
 	if (rdev->family >= CHIP_R600)
 		WREG32(R600_BIOS_6_SCRATCH, bios_6_scratch);
