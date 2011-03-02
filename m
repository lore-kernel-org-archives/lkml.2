Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab1CBQKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 11:10:14 -0500
Received: from adelie.canonical.com ([91.189.90.139]:55197 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab1CBQKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 11:10:12 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [2.6.32+drm33-longterm] Linux 2.6.32.29+drm33.14
Date: Wed,  2 Mar 2011 17:10:09 +0100
Message-Id: <1299082209-28610-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
To: linux-kernel@vger.kernel.org
To: stable@kernel.org
To: kernel-team@lists.ubuntu.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 2.6.32.29+drm33.14 longterm tree.

This tree is based on 2.6.32 and generally has all of the stable updates
applied. Except those to the DRM subsystem, which was based on 2.6.33 and
took updates from that upstream stable as long as that existed. It will
continue to add patches to the DRM subsystem as long as they are valid
according to the stable update rules (Documentation/stable_kernel_rules.txt).
DRM patches for this tree should be sent to kernel-team@lists.ubuntu.com.

This release updates the DRM subsystem only.

The updated 2.6.32.y-drm33.z tree can be found at:
  git://git.kernel.org/pub/scm/linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git
and can be browsed through git web via:
  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=summary

-Stefan

------

* drm/radeon/kms: add quirk for Mac Radeon HD 2600 card
* drm/radeon/kms: make the mac rv630 quirk generic
* drm/radeon/kms: add pll debugging output
* drm/radeon: remove 0x4243 pci id
* drm/radeon/kms: fix s/r issues with bios scratch regs
* drm/i915/lvds: Add AOpen i915GMm-HFS to the list of false-positive LVDS
* drm/i915: Add dependency on CONFIG_TMPFS
* Linux 2.6.32.29+drm33.14

 Makefile                                 |    2 +-
 drivers/gpu/drm/Kconfig                  |    3 +++
 drivers/gpu/drm/i915/intel_lvds.c        |    8 ++++++++
 drivers/gpu/drm/radeon/radeon_atombios.c |   16 +++++++++++++---
 drivers/gpu/drm/radeon/radeon_display.c  |    4 ++++
 include/drm/drm_pciids.h                 |    1 -
 6 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 1453b38..0b9e821 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .29+drm33.13
+EXTRAVERSION = .29+drm33.14
 NAME = Man-Eating Seals of Antiquity

 # *DOCUMENTATION*
diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 305c590..7bb111b 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -94,7 +94,10 @@ config DRM_I830
 config DRM_I915
 	tristate "i915 driver"
 	depends on AGP_INTEL
+	# we need shmfs for the swappable backing store, and in particular
+	# the shmem_readpage() which depends upon tmpfs
 	select SHMEM
+	select TMPFS
 	select DRM_KMS_HELPER
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 66df0c3..49c724e 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -894,6 +894,14 @@ static const struct dmi_system_id intel_no_lvds[] = {
 	},
 	{
 		.callback = intel_no_lvds_dmi_callback,
+		.ident = "AOpen i915GMm-HFS",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AOpen"),
+			DMI_MATCH(DMI_BOARD_NAME, "i915GMm-HFS"),
+		},
+	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
 		.ident = "Aopen i945GTt-VFA",
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "AO00001JW"),
diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index b57e4a8..7c9b013 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -262,6 +262,13 @@ static bool radeon_atom_apply_quirks(struct drm_device *dev,
 			*line_mux = 0x90;
 	}

+	/* mac rv630, rv730, others */
+	if ((supported_device == ATOM_DEVICE_TV1_SUPPORT) &&
+	    (*connector_type == DRM_MODE_CONNECTOR_DVII)) {
+		*connector_type = DRM_MODE_CONNECTOR_9PinDIN;
+		*line_mux = CONNECTOR_7PIN_DIN_ENUM_ID1;
+	}
+
 	/* ASUS HD 3600 XT board lists the DVI port as HDMI */
 	if ((dev->pdev->device == 0x9598) &&
 	    (dev->pdev->subsystem_vendor == 0x1043) &&
@@ -1489,7 +1496,7 @@ void radeon_atom_initialize_bios_scratch_regs(struct drm_device *dev)
 	bios_2_scratch &= ~ATOM_S2_VRI_BRIGHT_ENABLE;

 	/* tell the bios not to handle mode switching */
-	bios_6_scratch |= (ATOM_S6_ACC_BLOCK_DISPLAY_SWITCH | ATOM_S6_ACC_MODE);
+	bios_6_scratch |= ATOM_S6_ACC_BLOCK_DISPLAY_SWITCH;

 	if (rdev->family >= CHIP_R600) {
 		WREG32(R600_BIOS_2_SCRATCH, bios_2_scratch);
@@ -1540,10 +1547,13 @@ void radeon_atom_output_lock(struct drm_encoder *encoder, bool lock)
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
diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index 7e17a36..567bd8e 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -578,6 +578,10 @@ void radeon_compute_pll(struct radeon_pll *pll,
 	*frac_fb_div_p = best_frac_feedback_div;
 	*ref_div_p = best_ref_div;
 	*post_div_p = best_post_div;
+	DRM_DEBUG_KMS("%d %d, pll dividers - fb: %d.%d ref: %d, post %d\n",
+		      freq, best_freq / 1000, best_feedback_div, best_frac_feedback_div,
+		      best_ref_div, best_post_div);
+
 }

 void radeon_compute_pll_avivo(struct radeon_pll *pll,
diff --git a/include/drm/drm_pciids.h b/include/drm/drm_pciids.h
index 3d016e9..d2674f9 100644
--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -28,7 +28,6 @@
 	{0x1002, 0x4156, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV350}, \
 	{0x1002, 0x4237, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS200|RADEON_IS_IGP}, \
 	{0x1002, 0x4242, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R200}, \
-	{0x1002, 0x4243, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R200}, \
 	{0x1002, 0x4336, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS100|RADEON_IS_IGP|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x4337, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS200|RADEON_IS_IGP|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x4437, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS200|RADEON_IS_IGP|RADEON_IS_MOBILITY}, \
