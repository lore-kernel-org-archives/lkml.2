Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553Ab1BPCAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:00:47 -0500
Received: from kroah.org ([198.145.64.141]:49178 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab1BPBvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:51:11 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:02 2011
Message-Id: <20110216014702.358548085@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [081/115] drm/radeon/kms: fix s/r issues with bios scratch regs
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

---
 drivers/gpu/drm/radeon/radeon_atombios.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -1217,7 +1217,7 @@ void radeon_atom_initialize_bios_scratch
 	bios_2_scratch &= ~ATOM_S2_VRI_BRIGHT_ENABLE;
 
 	/* tell the bios not to handle mode switching */
-	bios_6_scratch |= (ATOM_S6_ACC_BLOCK_DISPLAY_SWITCH | ATOM_S6_ACC_MODE);
+	bios_6_scratch |= ATOM_S6_ACC_BLOCK_DISPLAY_SWITCH;
 
 	if (rdev->family >= CHIP_R600) {
 		WREG32(R600_BIOS_2_SCRATCH, bios_2_scratch);
@@ -1268,10 +1268,13 @@ void radeon_atom_output_lock(struct drm_
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


