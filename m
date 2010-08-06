Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935854Ab0HFTbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:31:55 -0400
Received: from kroah.org ([198.145.64.141]:43619 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965593Ab0HFT2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:28:15 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 12:21:17 2010
Message-Id: <20100806192116.964588813@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 12:20:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [28/36] drm/radeon/kms/igp: sideport is AMD only
In-Reply-To: <20100806192649.GA1614@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 4c70b2eae371ebe83019ac47de6088b78124ab36 upstream.

Intel variants don't support it.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |   15 ++++++---------
 drivers/gpu/drm/radeon/radeon_combios.c  |    4 ++++
 drivers/gpu/drm/radeon/rs600.c           |    1 -
 drivers/gpu/drm/radeon/rs690.c           |    2 +-
 4 files changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -1024,21 +1024,18 @@ bool radeon_atombios_sideport_present(st
 	u8 frev, crev;
 	u16 data_offset;
 
+	/* sideport is AMD only */
+	if (rdev->family == CHIP_RS600)
+		return false;
+
 	if (atom_parse_data_header(mode_info->atom_context, index, NULL,
 				   &frev, &crev, &data_offset)) {
 		igp_info = (union igp_info *)(mode_info->atom_context->bios +
 				      data_offset);
 		switch (crev) {
 		case 1:
-			/* AMD IGPS */
-			if ((rdev->family == CHIP_RS690) ||
-			    (rdev->family == CHIP_RS740)) {
-				if (igp_info->info.ulBootUpMemoryClock)
-					return true;
-			} else {
-				if (igp_info->info.ucMemoryType & 0xf0)
-					return true;
-			}
+			if (igp_info->info.ulBootUpMemoryClock)
+				return true;
 			break;
 		case 2:
 			if (igp_info->info_2.ucMemoryType & 0x0f)
--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -693,6 +693,10 @@ bool radeon_combios_sideport_present(str
 	struct drm_device *dev = rdev->ddev;
 	u16 igp_info;
 
+	/* sideport is AMD only */
+	if (rdev->family == CHIP_RS400)
+		return false;
+
 	igp_info = combios_get_table_offset(dev, COMBIOS_INTEGRATED_SYSTEM_INFO_TABLE);
 
 	if (igp_info) {
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -475,7 +475,6 @@ void rs600_mc_init(struct radeon_device
 	rdev->mc.igp_sideport_enabled = radeon_atombios_sideport_present(rdev);
 	base = RREG32_MC(R_000004_MC_FB_LOCATION);
 	base = G_000004_MC_FB_START(base) << 16;
-	rdev->mc.igp_sideport_enabled = radeon_atombios_sideport_present(rdev);
 	radeon_vram_location(rdev, &rdev->mc, base);
 	radeon_gtt_location(rdev, &rdev->mc);
 	radeon_update_bandwidth_info(rdev);
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -158,8 +158,8 @@ void rs690_mc_init(struct radeon_device
 	rdev->mc.visible_vram_size = rdev->mc.aper_size;
 	base = RREG32_MC(R_000100_MCCFG_FB_LOCATION);
 	base = G_000100_MC_FB_START(base) << 16;
-	rs690_pm_info(rdev);
 	rdev->mc.igp_sideport_enabled = radeon_atombios_sideport_present(rdev);
+	rs690_pm_info(rdev);
 	radeon_vram_location(rdev, &rdev->mc, base);
 	radeon_gtt_location(rdev, &rdev->mc);
 	radeon_update_bandwidth_info(rdev);


