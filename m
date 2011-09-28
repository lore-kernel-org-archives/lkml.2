Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320Ab1I1Wso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:48:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933195Ab1I1Wsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:48:41 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:47 2011
Message-Id: <20110928220147.283039386@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [208/244] drm/radeon/kms: fix DDIA enable on some rs690 systems
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit fdfc61594e6de21c23f955818ef78bcab9bafe40 upstream.

DVOOutputControl checks the value of of bios scratch reg 3
on some tables and assumes the encoder is already enabled
if the DFP2_ACTIVE bit is set.  Clear that bit so the table
sets the DDIA enable bit properly.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_encoders.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_encoders.c
@@ -1507,7 +1507,14 @@ radeon_atom_encoder_dpms(struct drm_enco
 		switch (mode) {
 		case DRM_MODE_DPMS_ON:
 			args.ucAction = ATOM_ENABLE;
-			atom_execute_table(rdev->mode_info.atom_context, index, (uint32_t *)&args);
+			/* workaround for DVOOutputControl on some RS690 systems */
+			if (radeon_encoder->encoder_id == ENCODER_OBJECT_ID_INTERNAL_DDI) {
+				u32 reg = RREG32(RADEON_BIOS_3_SCRATCH);
+				WREG32(RADEON_BIOS_3_SCRATCH, reg & ~ATOM_S3_DFP2I_ACTIVE);
+				atom_execute_table(rdev->mode_info.atom_context, index, (uint32_t *)&args);
+				WREG32(RADEON_BIOS_3_SCRATCH, reg);
+			} else
+				atom_execute_table(rdev->mode_info.atom_context, index, (uint32_t *)&args);
 			if (radeon_encoder->devices & (ATOM_DEVICE_LCD_SUPPORT)) {
 				args.ucAction = ATOM_LCD_BLON;
 				atom_execute_table(rdev->mode_info.atom_context, index, (uint32_t *)&args);


