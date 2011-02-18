Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab1BRJGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 04:06:10 -0500
Received: from adelie.canonical.com ([91.189.90.139]:56459 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609Ab1BRJFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 04:05:05 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 5/7] drm/radeon/kms: fix s/r issues with bios scratch regs" has been added to staging queue
Date: Fri, 18 Feb 2011 10:05:02 +0100
Message-Id: <1298019902-2440-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
To: Alex Deucher <alexdeucher@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 5/7] drm/radeon/kms: fix s/r issues with bios scratch regs

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 314bf442eb5bbd1b388cd49a758c676dd166a4b3 Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexdeucher@gmail.com>
Date: Wed, 2 Feb 2011 19:46:06 -0500
Subject: [PATCH 5/7] drm/radeon/kms: fix s/r issues with bios scratch regs

commit 87364760de5d631390c478fcbac8db1b926e0adf upstream.

The accelerate mode bit gets checked by certain atom
command tables to set up some register state.  It needs
to be clear when setting modes and set when not.

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=26942

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_atombios.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 38631f6..7c9b013 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -1496,7 +1496,7 @@ void radeon_atom_initialize_bios_scratch_regs(struct drm_device *dev)
 	bios_2_scratch &= ~ATOM_S2_VRI_BRIGHT_ENABLE;

 	/* tell the bios not to handle mode switching */
-	bios_6_scratch |= (ATOM_S6_ACC_BLOCK_DISPLAY_SWITCH | ATOM_S6_ACC_MODE);
+	bios_6_scratch |= ATOM_S6_ACC_BLOCK_DISPLAY_SWITCH;

 	if (rdev->family >= CHIP_R600) {
 		WREG32(R600_BIOS_2_SCRATCH, bios_2_scratch);
@@ -1547,10 +1547,13 @@ void radeon_atom_output_lock(struct drm_encoder *encoder, bool lock)
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
--
1.7.0.4

