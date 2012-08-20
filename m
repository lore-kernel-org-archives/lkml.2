Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158Ab2HTEAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:00:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59366 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab2HTEAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:00:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 13/46] drm/radeon: properly handle crtc powergating
Date: Sun, 19 Aug 2012 20:58:49 -0700
Message-Id: <20120820035834.127890575@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 6c0ae2ab85fc4a95cae82047a7db1f688a7737ab upstream.

Need to make sure the crtc is gated on before modesetting.
Explicitly gate the crtc on in prepare() and set a flag
so that the dpms functions don't gate it off during
mode set.

Noticed by sylware on IRC.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_crtc.c      |   14 ++++++++++++--
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    4 ++++
 drivers/gpu/drm/radeon/radeon_mode.h        |    1 +
 3 files changed, 17 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -259,7 +259,7 @@ void atombios_crtc_dpms(struct drm_crtc
 		/* adjust pm to dpms changes BEFORE enabling crtcs */
 		radeon_pm_compute_clocks(rdev);
 		/* disable crtc pair power gating before programming */
-		if (ASIC_IS_DCE6(rdev))
+		if (ASIC_IS_DCE6(rdev) && !radeon_crtc->in_mode_set)
 			atombios_powergate_crtc(crtc, ATOM_DISABLE);
 		atombios_enable_crtc(crtc, ATOM_ENABLE);
 		if (ASIC_IS_DCE3(rdev) && !ASIC_IS_DCE6(rdev))
@@ -279,7 +279,7 @@ void atombios_crtc_dpms(struct drm_crtc
 		atombios_enable_crtc(crtc, ATOM_DISABLE);
 		radeon_crtc->enabled = false;
 		/* power gating is per-pair */
-		if (ASIC_IS_DCE6(rdev)) {
+		if (ASIC_IS_DCE6(rdev) && !radeon_crtc->in_mode_set) {
 			struct drm_crtc *other_crtc;
 			struct radeon_crtc *other_radeon_crtc;
 			list_for_each_entry(other_crtc, &rdev->ddev->mode_config.crtc_list, head) {
@@ -1639,18 +1639,28 @@ static bool atombios_crtc_mode_fixup(str
 static void atombios_crtc_prepare(struct drm_crtc *crtc)
 {
 	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
+	struct drm_device *dev = crtc->dev;
+	struct radeon_device *rdev = dev->dev_private;
 
+	radeon_crtc->in_mode_set = true;
 	/* pick pll */
 	radeon_crtc->pll_id = radeon_atom_pick_pll(crtc);
 
+	/* disable crtc pair power gating before programming */
+	if (ASIC_IS_DCE6(rdev))
+		atombios_powergate_crtc(crtc, ATOM_DISABLE);
+
 	atombios_lock_crtc(crtc, ATOM_ENABLE);
 	atombios_crtc_dpms(crtc, DRM_MODE_DPMS_OFF);
 }
 
 static void atombios_crtc_commit(struct drm_crtc *crtc)
 {
+	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
+
 	atombios_crtc_dpms(crtc, DRM_MODE_DPMS_ON);
 	atombios_lock_crtc(crtc, ATOM_DISABLE);
+	radeon_crtc->in_mode_set = false;
 }
 
 static void atombios_crtc_disable(struct drm_crtc *crtc)
--- a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
@@ -1025,9 +1025,11 @@ static int radeon_crtc_mode_set(struct d
 
 static void radeon_crtc_prepare(struct drm_crtc *crtc)
 {
+	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
 	struct drm_device *dev = crtc->dev;
 	struct drm_crtc *crtci;
 
+	radeon_crtc->in_mode_set = true;
 	/*
 	* The hardware wedges sometimes if you reconfigure one CRTC
 	* whilst another is running (see fdo bug #24611).
@@ -1038,6 +1040,7 @@ static void radeon_crtc_prepare(struct d
 
 static void radeon_crtc_commit(struct drm_crtc *crtc)
 {
+	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
 	struct drm_device *dev = crtc->dev;
 	struct drm_crtc *crtci;
 
@@ -1048,6 +1051,7 @@ static void radeon_crtc_commit(struct dr
 		if (crtci->enabled)
 			radeon_crtc_dpms(crtci, DRM_MODE_DPMS_ON);
 	}
+	radeon_crtc->in_mode_set = false;
 }
 
 static const struct drm_crtc_helper_funcs legacy_helper_funcs = {
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -275,6 +275,7 @@ struct radeon_crtc {
 	u16 lut_r[256], lut_g[256], lut_b[256];
 	bool enabled;
 	bool can_tile;
+	bool in_mode_set;
 	uint32_t crtc_offset;
 	struct drm_gem_object *cursor_bo;
 	uint64_t cursor_addr;


