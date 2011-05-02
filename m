Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab1EBInF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 04:43:05 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56720 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab1EBIm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 04:42:59 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [2.6.32+drm33-longterm] Linux 2.6.32.38+drm33.17
Date: Mon,  2 May 2011 10:42:54 +0200
Message-Id: <1304325774-2793-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
To: linux-kernel@vger.kernel.org
To: stable@kernel.org
To: kernel-team@lists.ubuntu.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 2.6.32.38+drm33.17 longterm tree.

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

* drm/i915: set DIDL using the ACPI video output device _ADR method return.
* drm/radeon/kms: MC vram map needs to be >= pci aperture size
* drm/radeon/kms: make sure blit addr masks are 64 bit
* drm/radeon/kms: fix handling of tex lookup disable in cs checker on r2xx
* drm/i915: Free hardware status page on unload when physically mapped
* drm/i915/overlay: Ensure that the reg_bo is in the GTT prior to writing.
* drm/radeon/kms/atom: set sane defaults in atombios_get_encoder_mode()
* drm/radeon/kms: fix typos in disabled vbios code
* drm/radeon/kms: add workaround for dce3 ddc line vbios bug
* drm/radeon/kms: fix interlaced and doublescan handling
* drm/i915/sdvo: Always add a 30ms delay to make SDVO TV detection reliable
* drm/radeon/kms: don't apply 7xx HDP flush workaround on AGP
* drm/ttm: Fix two race conditions + fix busy codepaths
* drm/i915: overlay on gen2 can't address above 1G
* drm/i915: fix memory corruption with GM965 and >4GB RAM
* drm/radeon: add quirk to make HP nx6125 laptop resume.
* drm/radeon/kms: add quirk to make HP DV5000 laptop resume
* drm/i915: Sanity check pread/pwrite
* drm/i915: Rephrase pwrite bounds checking to avoid any potential overflow
* drm/i915: Stop trying to use ACPI lid status to determine LVDS connection.
* Linux 2.6.32.38+drm33.17

 Makefile                                   |    2 +-
 drivers/gpu/drm/i915/i915_dma.c            |   18 ++++++
 drivers/gpu/drm/i915/i915_gem.c            |   44 ++++++++-------
 drivers/gpu/drm/i915/i915_opregion.c       |   54 ++++++++++++++++-
 drivers/gpu/drm/i915/intel_lvds.c          |   52 +-----------------
 drivers/gpu/drm/i915/intel_overlay.c       |    8 +++
 drivers/gpu/drm/i915/intel_sdvo.c          |    8 +-
 drivers/gpu/drm/radeon/r100.c              |    6 ++
 drivers/gpu/drm/radeon/r100_track.h        |    1 +
 drivers/gpu/drm/radeon/r200.c              |    2 +
 drivers/gpu/drm/radeon/r600.c              |   11 +++-
 drivers/gpu/drm/radeon/r600_blit_kms.c     |    8 +-
 drivers/gpu/drm/radeon/r600_reg.h          |    1 +
 drivers/gpu/drm/radeon/radeon_atombios.c   |    8 +++
 drivers/gpu/drm/radeon/radeon_bios.c       |   12 ++--
 drivers/gpu/drm/radeon/radeon_combios.c    |   16 +++++
 drivers/gpu/drm/radeon/radeon_connectors.c |   34 +++++++++++
 drivers/gpu/drm/radeon/radeon_encoders.c   |   18 +++++-
 drivers/gpu/drm/radeon/radeon_reg.h        |    1 +
 drivers/gpu/drm/ttm/ttm_bo.c               |   84 +++++++++++++++++++++++----
 include/drm/ttm/ttm_bo_api.h               |    4 +-
 21 files changed, 282 insertions(+), 110 deletions(-)

diff --git a/Makefile b/Makefile
index 6b2feae..8ea6c3f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .38+drm33.16
+EXTRAVERSION = .38+drm33.17
 NAME = Man-Eating Seals of Antiquity

 # *DOCUMENTATION*
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 7f13d50..be27acc 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1407,6 +1407,21 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 		goto free_priv;
 	}

+	/* overlay on gen2 is broken and can't address above 1G */
+	if (IS_GEN2(dev))
+		pci_set_consistent_dma_mask(dev->pdev, DMA_BIT_MASK(30));
+
+	/* 965GM sometimes incorrectly writes to hardware status page (HWS)
+	 * using 32bit addressing, overwriting memory if HWS is located
+	 * above 4GB.
+	 *
+	 * The documentation also mentions an issue with undefined
+	 * behaviour if any general state is accessed within a page above 4GB,
+	 * which also needs to be handled carefully.
+	 */
+	if (IS_I965G(dev) && !IS_G4X(dev) && !IS_IRONLAKE(dev))
+		pci_set_consistent_dma_mask(dev->pdev, DMA_BIT_MASK(32));
+
 	dev_priv->regs = ioremap(base, size);
 	if (!dev_priv->regs) {
 		DRM_ERROR("failed to map registers\n");
@@ -1583,6 +1598,9 @@ int i915_driver_unload(struct drm_device *dev)
 		i915_gem_lastclose(dev);

 		intel_cleanup_overlay(dev);
+
+		if (!I915_NEED_GFX_HWS(dev))
+			i915_free_hws(dev);
 	}

 	pci_dev_put(dev_priv->bridge_dev);
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index ad3c4a2..a34fd44 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -482,14 +482,17 @@ i915_gem_pread_ioctl(struct drm_device *dev, void *data,
 		return -EBADF;
 	obj_priv = obj->driver_private;

-	/* Bounds check source.
-	 *
-	 * XXX: This could use review for overflow issues...
-	 */
-	if (args->offset > obj->size || args->size > obj->size ||
-	    args->offset + args->size > obj->size) {
-		drm_gem_object_unreference(obj);
-		return -EINVAL;
+	/* Bounds check source.  */
+	if (args->offset > obj->size || args->size > obj->size - args->offset) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	if (!access_ok(VERIFY_WRITE,
+		       (char __user *)(uintptr_t)args->data_ptr,
+		       args->size)) {
+		ret = -EFAULT;
+		goto err;
 	}

 	if (i915_gem_object_needs_bit17_swizzle(obj)) {
@@ -501,8 +504,8 @@ i915_gem_pread_ioctl(struct drm_device *dev, void *data,
 							file_priv);
 	}

+err:
 	drm_gem_object_unreference(obj);
-
 	return ret;
 }

@@ -592,8 +595,6 @@ i915_gem_gtt_pwrite_fast(struct drm_device *dev, struct drm_gem_object *obj,

 	user_data = (char __user *) (uintptr_t) args->data_ptr;
 	remain = args->size;
-	if (!access_ok(VERIFY_READ, user_data, remain))
-		return -EFAULT;


 	mutex_lock(&dev->struct_mutex);
@@ -955,14 +956,17 @@ i915_gem_pwrite_ioctl(struct drm_device *dev, void *data,
 		return -EBADF;
 	obj_priv = obj->driver_private;

-	/* Bounds check destination.
-	 *
-	 * XXX: This could use review for overflow issues...
-	 */
-	if (args->offset > obj->size || args->size > obj->size ||
-	    args->offset + args->size > obj->size) {
-		drm_gem_object_unreference(obj);
-		return -EINVAL;
+	/* Bounds check destination. */
+	if (args->offset > obj->size || args->size > obj->size - args->offset) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	if (!access_ok(VERIFY_READ,
+		       (char __user *)(uintptr_t)args->data_ptr,
+		       args->size)) {
+		ret = -EFAULT;
+		goto err;
 	}

 	/* We can only do the GTT pwrite on untiled buffers, as otherwise
@@ -995,8 +999,8 @@ i915_gem_pwrite_ioctl(struct drm_device *dev, void *data,
 		DRM_INFO("pwrite failed %d\n", ret);
 #endif

+err:
 	drm_gem_object_unreference(obj);
-
 	return ret;
 }

diff --git a/drivers/gpu/drm/i915/i915_opregion.c b/drivers/gpu/drm/i915/i915_opregion.c
index 7cc8410..8fcc75c 100644
--- a/drivers/gpu/drm/i915/i915_opregion.c
+++ b/drivers/gpu/drm/i915/i915_opregion.c
@@ -382,8 +382,57 @@ static void intel_didl_outputs(struct drm_device *dev)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_opregion *opregion = &dev_priv->opregion;
 	struct drm_connector *connector;
+	acpi_handle handle;
+	struct acpi_device *acpi_dev, *acpi_cdev, *acpi_video_bus = NULL;
+	unsigned long long device_id;
+	acpi_status status;
 	int i = 0;

+	handle = DEVICE_ACPI_HANDLE(&dev->pdev->dev);
+	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &acpi_dev)))
+		return;
+
+	if (acpi_is_video_device(acpi_dev))
+		acpi_video_bus = acpi_dev;
+	else {
+		list_for_each_entry(acpi_cdev, &acpi_dev->children, node) {
+			if (acpi_is_video_device(acpi_cdev)) {
+				acpi_video_bus = acpi_cdev;
+				break;
+			}
+		}
+	}
+
+	if (!acpi_video_bus) {
+		printk(KERN_WARNING "No ACPI video bus found\n");
+		return;
+	}
+
+	list_for_each_entry(acpi_cdev, &acpi_video_bus->children, node) {
+		if (i >= 8) {
+			dev_printk (KERN_ERR, &dev->pdev->dev,
+				    "More than 8 outputs detected\n");
+			return;
+		}
+		status =
+			acpi_evaluate_integer(acpi_cdev->handle, "_ADR",
+						NULL, &device_id);
+		if (ACPI_SUCCESS(status)) {
+			if (!device_id)
+				goto blind_set;
+			opregion->acpi->didl[i] = (u32)(device_id & 0x0f0f);
+			i++;
+		}
+	}
+
+end:
+	/* If fewer than 8 outputs, the list must be null terminated */
+	if (i < 8)
+		opregion->acpi->didl[i] = 0;
+	return;
+
+blind_set:
+	i = 0;
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
 		int output_type = ACPI_OTHER_OUTPUT;
 		if (i >= 8) {
@@ -416,10 +465,7 @@ static void intel_didl_outputs(struct drm_device *dev)
 		opregion->acpi->didl[i] |= (1<<31) | output_type | i;
 		i++;
 	}
-
-	/* If fewer than 8 outputs, the list must be null terminated */
-	if (i < 8)
-		opregion->acpi->didl[i] = 0;
+	goto end;
 }

 int intel_opregion_init(struct drm_device *dev, int resume)
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 49c724e..d34c09f 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -599,53 +599,6 @@ static void intel_lvds_mode_set(struct drm_encoder *encoder,
 	I915_WRITE(PFIT_CONTROL, lvds_priv->pfit_control);
 }

-/* Some lid devices report incorrect lid status, assume they're connected */
-static const struct dmi_system_id bad_lid_status[] = {
-	{
-		.ident = "Compaq nx9020",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_BOARD_NAME, "3084"),
-		},
-	},
-	{
-		.ident = "Samsung SX20S",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Samsung Electronics"),
-			DMI_MATCH(DMI_BOARD_NAME, "SX20S"),
-		},
-	},
-	{
-		.ident = "Aspire One",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire one"),
-		},
-	},
-	{
-		.ident = "Aspire 1810T",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 1810T"),
-		},
-	},
-	{
-		.ident = "PC-81005",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "MALATA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PC-81005"),
-		},
-	},
-	{
-		.ident = "Clevo M5x0N",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "CLEVO Co."),
-			DMI_MATCH(DMI_BOARD_NAME, "M5x0N"),
-		},
-	},
-	{ }
-};
-
 /**
  * Detect the LVDS connection.
  *
@@ -661,12 +614,9 @@ static enum drm_connector_status intel_lvds_detect(struct drm_connector *connect
 	/* ACPI lid methods were generally unreliable in this generation, so
 	 * don't even bother.
 	 */
-	if (IS_GEN2(dev))
+	if (IS_GEN2(dev) || IS_GEN3(dev))
 		return connector_status_connected;

-	if (!dmi_check_system(bad_lid_status) && !acpi_lid_open())
-		status = connector_status_disconnected;
-
 	return status;
 }

diff --git a/drivers/gpu/drm/i915/intel_overlay.c b/drivers/gpu/drm/i915/intel_overlay.c
index ed4058e..f240e17 100644
--- a/drivers/gpu/drm/i915/intel_overlay.c
+++ b/drivers/gpu/drm/i915/intel_overlay.c
@@ -1371,6 +1371,12 @@ void intel_setup_overlay(struct drm_device *dev)
                         goto out_free_bo;
                 }
 		overlay->flip_addr = overlay->reg_bo->gtt_offset;
+
+		ret = i915_gem_object_set_to_gtt_domain(reg_bo, true);
+		if (ret) {
+                        DRM_ERROR("failed to move overlay register bo into the GTT\n");
+                        goto out_unpin_bo;
+                }
 	} else {
 		ret = i915_gem_attach_phys_object(dev, reg_bo,
 				I915_GEM_PHYS_OVERLAY_REGS);
@@ -1402,6 +1408,8 @@ void intel_setup_overlay(struct drm_device *dev)
 	DRM_INFO("initialized overlay support\n");
 	return;

+out_unpin_bo:
+	i915_gem_object_unpin(reg_bo);
 out_free_bo:
 	drm_gem_object_unreference(reg_bo);
 out_free:
diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 48daee5..fe83986 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1693,10 +1693,10 @@ static enum drm_connector_status intel_sdvo_detect(struct drm_connector *connect

 	intel_sdvo_write_cmd(intel_output,
 			     SDVO_CMD_GET_ATTACHED_DISPLAYS, NULL, 0);
-	if (sdvo_priv->is_tv) {
-		/* add 30ms delay when the output type is SDVO-TV */
-		mdelay(30);
-	}
+	/* add 30ms delay when the output type might be TV */
+	if (sdvo_priv->caps.output_flags &
+	    (SDVO_OUTPUT_SVID0 | SDVO_OUTPUT_CVBS0))
+ 		mdelay(30);
 	status = intel_sdvo_read_response(intel_output, &response, 2);

 	DRM_DEBUG_KMS("SDVO response %d %d\n", response & 0xff, response >> 8);
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 947570c..6021e91 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -1918,6 +1918,9 @@ void r100_vram_init_sizes(struct radeon_device *rdev)
 		rdev->mc.vram_location = 0xFFFFFFFFUL;
 		 /* Fix for RN50, M6, M7 with 8/16/32(??) MBs of VRAM -
 		  * Novell bug 204882 + along with lots of ubuntu ones */
+		if (rdev->mc.aper_size > config_aper_size)
+			config_aper_size = rdev->mc.aper_size;
+
 		if (config_aper_size > rdev->mc.real_vram_size)
 			rdev->mc.mc_vram_size = config_aper_size;
 		else
@@ -2825,6 +2828,8 @@ static int r100_cs_track_texture_check(struct radeon_device *rdev,
 	for (u = 0; u < track->num_texture; u++) {
 		if (!track->textures[u].enabled)
 			continue;
+		if (track->textures[u].lookup_disable)
+			continue;
 		robj = track->textures[u].robj;
 		if (robj == NULL) {
 			DRM_ERROR("No texture bound to unit %u\n", u);
@@ -3073,6 +3078,7 @@ void r100_cs_track_clear(struct radeon_device *rdev, struct r100_cs_track *track
 		track->textures[i].robj = NULL;
 		/* CS IB emission code makes sure texture unit are disabled */
 		track->textures[i].enabled = false;
+		track->textures[i].lookup_disable = false;
 		track->textures[i].roundup_w = true;
 		track->textures[i].roundup_h = true;
 		if (track->separate_cube)
diff --git a/drivers/gpu/drm/radeon/r100_track.h b/drivers/gpu/drm/radeon/r100_track.h
index a2fada0..e19ef4a 100644
--- a/drivers/gpu/drm/radeon/r100_track.h
+++ b/drivers/gpu/drm/radeon/r100_track.h
@@ -46,6 +46,7 @@ struct r100_cs_track_texture {
 	unsigned		height_11;
 	bool			use_pitch;
 	bool			enabled;
+	bool                    lookup_disable;
 	bool			roundup_w;
 	bool			roundup_h;
 	unsigned                compress_format;
diff --git a/drivers/gpu/drm/radeon/r200.c b/drivers/gpu/drm/radeon/r200.c
index f890fd3..7ebd2ba 100644
--- a/drivers/gpu/drm/radeon/r200.c
+++ b/drivers/gpu/drm/radeon/r200.c
@@ -400,6 +400,8 @@ int r200_packet0_check(struct radeon_cs_parser *p,
 			track->textures[i].width = 1 << ((idx_value >> RADEON_TXFORMAT_WIDTH_SHIFT) & RADEON_TXFORMAT_WIDTH_MASK);
 			track->textures[i].height = 1 << ((idx_value >> RADEON_TXFORMAT_HEIGHT_SHIFT) & RADEON_TXFORMAT_HEIGHT_MASK);
 		}
+		if (idx_value & R200_TXFORMAT_LOOKUP_DISABLE)
+			track->textures[i].lookup_disable = true;
 		switch ((idx_value & RADEON_TXFORMAT_FORMAT_MASK)) {
 		case R200_TXFORMAT_I8:
 		case R200_TXFORMAT_RGB332:
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 814a621..3d70f6c 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -371,12 +371,15 @@ void r600_pcie_gart_tlb_flush(struct radeon_device *rdev)
 	u32 tmp;

 	/* flush hdp cache so updates hit vram */
-	if ((rdev->family >= CHIP_RV770) && (rdev->family <= CHIP_RV740)) {
+	if ((rdev->family >= CHIP_RV770) && (rdev->family <= CHIP_RV740) &&
+	    !(rdev->flags & RADEON_IS_AGP)) {
 		void __iomem *ptr = (void *)rdev->gart.table.vram.ptr;
 		u32 tmp;

 		/* r7xx hw bug.  write to HDP_DEBUG1 followed by fb read
 		 * rather than write to HDP_REG_COHERENCY_FLUSH_CNTL
+		 * This seems to cause problems on some AGP cards. Just use the old
+		 * method for them.
 		 */
 		WREG32(HDP_DEBUG1, 0);
 		tmp = readl((void __iomem *)ptr);
@@ -2940,10 +2943,12 @@ int r600_debugfs_mc_info_init(struct radeon_device *rdev)
 void r600_ioctl_wait_idle(struct radeon_device *rdev, struct radeon_bo *bo)
 {
 	/* r7xx hw bug.  write to HDP_DEBUG1 followed by fb read
-	 * rather than write to HDP_REG_COHERENCY_FLUSH_CNTL
+	 * rather than write to HDP_REG_COHERENCY_FLUSH_CNTL.
+	 * This seems to cause problems on some AGP cards. Just use the old
+	 * method for them.
 	 */
 	if ((rdev->family >= CHIP_RV770) && (rdev->family <= CHIP_RV740) &&
-	    rdev->vram_scratch.ptr) {
+	    rdev->vram_scratch.ptr && !(rdev->flags & RADEON_IS_AGP)) {
 		void __iomem *ptr = (void *)rdev->vram_scratch.ptr;
 		u32 tmp;

diff --git a/drivers/gpu/drm/radeon/r600_blit_kms.c b/drivers/gpu/drm/radeon/r600_blit_kms.c
index 446b765..d6a30a9 100644
--- a/drivers/gpu/drm/radeon/r600_blit_kms.c
+++ b/drivers/gpu/drm/radeon/r600_blit_kms.c
@@ -629,8 +629,8 @@ void r600_kms_blit_copy(struct radeon_device *rdev,
 			int src_x = src_gpu_addr & 255;
 			int dst_x = dst_gpu_addr & 255;
 			int h = 1;
-			src_gpu_addr = src_gpu_addr & ~255;
-			dst_gpu_addr = dst_gpu_addr & ~255;
+			src_gpu_addr = src_gpu_addr & ~255ULL;
+			dst_gpu_addr = dst_gpu_addr & ~255ULL;

 			if (!src_x && !dst_x) {
 				h = (cur_size / max_bytes);
@@ -723,8 +723,8 @@ void r600_kms_blit_copy(struct radeon_device *rdev,
 			int src_x = (src_gpu_addr & 255);
 			int dst_x = (dst_gpu_addr & 255);
 			int h = 1;
-			src_gpu_addr = src_gpu_addr & ~255;
-			dst_gpu_addr = dst_gpu_addr & ~255;
+			src_gpu_addr = src_gpu_addr & ~255ULL;
+			dst_gpu_addr = dst_gpu_addr & ~255ULL;

 			if (!src_x && !dst_x) {
 				h = (cur_size / max_bytes);
diff --git a/drivers/gpu/drm/radeon/r600_reg.h b/drivers/gpu/drm/radeon/r600_reg.h
index d0e28ff..fb3dfef 100644
--- a/drivers/gpu/drm/radeon/r600_reg.h
+++ b/drivers/gpu/drm/radeon/r600_reg.h
@@ -86,6 +86,7 @@
 #define R600_HDP_NONSURFACE_BASE                                0x2c04

 #define R600_BUS_CNTL                                           0x5420
+#       define R600_BIOS_ROM_DIS                                (1 << 1)
 #define R600_CONFIG_CNTL                                        0x5424
 #define R600_CONFIG_MEMSIZE                                     0x5428
 #define R600_CONFIG_F0_BASE                                     0x542C
diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 7c9b013..cddf2c9 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -83,6 +83,14 @@ static inline struct radeon_i2c_bus_rec radeon_lookup_i2c_gpio(struct radeon_dev
 	for (i = 0; i < ATOM_MAX_SUPPORTED_DEVICE; i++) {
 		gpio = &i2c_info->asGPIO_Info[i];

+			/* some DCE3 boards have bad data for this entry */
+			if (ASIC_IS_DCE3(rdev)) {
+				if ((i == 4) &&
+				    (gpio->usClkMaskRegisterIndex == 0x1fda) &&
+				    (gpio->sucI2cId.ucAccess == 0x94))
+					gpio->sucI2cId.ucAccess = 0x14;
+			}
+
 		if (gpio->sucI2cId.ucAccess == id) {
 			i2c.mask_clk_reg = le16_to_cpu(gpio->usClkMaskRegisterIndex) * 4;
 			i2c.mask_data_reg = le16_to_cpu(gpio->usDataMaskRegisterIndex) * 4;
diff --git a/drivers/gpu/drm/radeon/radeon_bios.c b/drivers/gpu/drm/radeon/radeon_bios.c
index 9069217..cd734bd 100644
--- a/drivers/gpu/drm/radeon/radeon_bios.c
+++ b/drivers/gpu/drm/radeon/radeon_bios.c
@@ -106,7 +106,7 @@ static bool r700_read_disabled_bios(struct radeon_device *rdev)
 	bool r;

 	viph_control = RREG32(RADEON_VIPH_CONTROL);
-	bus_cntl = RREG32(RADEON_BUS_CNTL);
+	bus_cntl = RREG32(R600_BUS_CNTL);
 	d1vga_control = RREG32(AVIVO_D1VGA_CONTROL);
 	d2vga_control = RREG32(AVIVO_D2VGA_CONTROL);
 	vga_render_control = RREG32(AVIVO_VGA_RENDER_CONTROL);
@@ -115,7 +115,7 @@ static bool r700_read_disabled_bios(struct radeon_device *rdev)
 	/* disable VIP */
 	WREG32(RADEON_VIPH_CONTROL, (viph_control & ~RADEON_VIPH_EN));
 	/* enable the rom */
-	WREG32(RADEON_BUS_CNTL, (bus_cntl & ~RADEON_BUS_BIOS_DIS_ROM));
+	WREG32(R600_BUS_CNTL, (bus_cntl & ~R600_BIOS_ROM_DIS));
 	/* Disable VGA mode */
 	WREG32(AVIVO_D1VGA_CONTROL,
 	       (d1vga_control & ~(AVIVO_DVGA_CONTROL_MODE_ENABLE |
@@ -154,7 +154,7 @@ static bool r700_read_disabled_bios(struct radeon_device *rdev)
 			cg_spll_status = RREG32(R600_CG_SPLL_STATUS);
 	}
 	WREG32(RADEON_VIPH_CONTROL, viph_control);
-	WREG32(RADEON_BUS_CNTL, bus_cntl);
+	WREG32(R600_BUS_CNTL, bus_cntl);
 	WREG32(AVIVO_D1VGA_CONTROL, d1vga_control);
 	WREG32(AVIVO_D2VGA_CONTROL, d2vga_control);
 	WREG32(AVIVO_VGA_RENDER_CONTROL, vga_render_control);
@@ -179,7 +179,7 @@ static bool r600_read_disabled_bios(struct radeon_device *rdev)
 	bool r;

 	viph_control = RREG32(RADEON_VIPH_CONTROL);
-	bus_cntl = RREG32(RADEON_BUS_CNTL);
+	bus_cntl = RREG32(R600_BUS_CNTL);
 	d1vga_control = RREG32(AVIVO_D1VGA_CONTROL);
 	d2vga_control = RREG32(AVIVO_D2VGA_CONTROL);
 	vga_render_control = RREG32(AVIVO_VGA_RENDER_CONTROL);
@@ -194,7 +194,7 @@ static bool r600_read_disabled_bios(struct radeon_device *rdev)
 	/* disable VIP */
 	WREG32(RADEON_VIPH_CONTROL, (viph_control & ~RADEON_VIPH_EN));
 	/* enable the rom */
-	WREG32(RADEON_BUS_CNTL, (bus_cntl & ~RADEON_BUS_BIOS_DIS_ROM));
+	WREG32(R600_BUS_CNTL, (bus_cntl & ~R600_BIOS_ROM_DIS));
 	/* Disable VGA mode */
 	WREG32(AVIVO_D1VGA_CONTROL,
 	       (d1vga_control & ~(AVIVO_DVGA_CONTROL_MODE_ENABLE |
@@ -225,7 +225,7 @@ static bool r600_read_disabled_bios(struct radeon_device *rdev)

 	/* restore regs */
 	WREG32(RADEON_VIPH_CONTROL, viph_control);
-	WREG32(RADEON_BUS_CNTL, bus_cntl);
+	WREG32(R600_BUS_CNTL, bus_cntl);
 	WREG32(AVIVO_D1VGA_CONTROL, d1vga_control);
 	WREG32(AVIVO_D2VGA_CONTROL, d2vga_control);
 	WREG32(AVIVO_VGA_RENDER_CONTROL, vga_render_control);
diff --git a/drivers/gpu/drm/radeon/radeon_combios.c b/drivers/gpu/drm/radeon/radeon_combios.c
index 44770b9..16024e2 100644
--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -2849,6 +2849,22 @@ void radeon_combios_asic_init(struct drm_device *dev)
 		combios_write_ram_size(dev);
 	}

+	/* quirk for rs4xx HP nx6125 laptop to make it resume
+	 * - it hangs on resume inside the dynclk 1 table.
+	 */
+	if (rdev->family == CHIP_RS480 &&
+	    rdev->pdev->subsystem_vendor == 0x103c &&
+	    rdev->pdev->subsystem_device == 0x308b)
+		return;
+
+	/* quirk for rs4xx HP dv5000 laptop to make it resume
+	 * - it hangs on resume inside the dynclk 1 table.
+	 */
+	if (rdev->family == CHIP_RS480 &&
+	    rdev->pdev->subsystem_vendor == 0x103c &&
+	    rdev->pdev->subsystem_device == 0x30a4)
+		return;
+
 	/* DYN CLK 1 */
 	table = combios_get_table_offset(dev, COMBIOS_DYN_CLK_1_TABLE);
 	if (table)
diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index c263f8e..e9f8c44 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -1095,6 +1095,8 @@ radeon_add_atom_connector(struct drm_device *dev,
 		drm_connector_attach_property(&radeon_connector->base,
 					      rdev->mode_info.load_detect_property,
 					      1);
+		connector->interlace_allowed = true;
+		connector->doublescan_allowed = true;
 		break;
 	case DRM_MODE_CONNECTOR_DVIA:
 		drm_connector_init(dev, &radeon_connector->base, &radeon_vga_connector_funcs, connector_type);
@@ -1110,6 +1112,8 @@ radeon_add_atom_connector(struct drm_device *dev,
 		drm_connector_attach_property(&radeon_connector->base,
 					      rdev->mode_info.load_detect_property,
 					      1);
+		connector->interlace_allowed = true;
+		connector->doublescan_allowed = true;
 		break;
 	case DRM_MODE_CONNECTOR_DVII:
 	case DRM_MODE_CONNECTOR_DVID:
@@ -1138,6 +1142,11 @@ radeon_add_atom_connector(struct drm_device *dev,
 						      rdev->mode_info.load_detect_property,
 						      1);
 		}
+		connector->interlace_allowed = true;
+		if (connector_type == DRM_MODE_CONNECTOR_DVII)
+			connector->doublescan_allowed = true;
+		else
+			connector->doublescan_allowed = false;
 		break;
 	case DRM_MODE_CONNECTOR_HDMIA:
 	case DRM_MODE_CONNECTOR_HDMIB:
@@ -1160,6 +1169,11 @@ radeon_add_atom_connector(struct drm_device *dev,
 					      rdev->mode_info.coherent_mode_property,
 					      1);
 		subpixel_order = SubPixelHorizontalRGB;
+		connector->interlace_allowed = true;
+		if (connector_type == DRM_MODE_CONNECTOR_HDMIB)
+			connector->doublescan_allowed = true;
+		else
+			connector->doublescan_allowed = false;
 		break;
 	case DRM_MODE_CONNECTOR_DisplayPort:
 	case DRM_MODE_CONNECTOR_eDP:
@@ -1192,6 +1206,9 @@ radeon_add_atom_connector(struct drm_device *dev,
 		drm_connector_attach_property(&radeon_connector->base,
 					      rdev->mode_info.coherent_mode_property,
 					      1);
+		connector->interlace_allowed = true;
+		/* in theory with a DP to VGA converter... */
+		connector->doublescan_allowed = false;
 		break;
 	case DRM_MODE_CONNECTOR_SVIDEO:
 	case DRM_MODE_CONNECTOR_Composite:
@@ -1209,6 +1226,8 @@ radeon_add_atom_connector(struct drm_device *dev,
 						      rdev->mode_info.tv_std_property,
 						      radeon_atombios_get_tv_info(rdev));
 		}
+		connector->interlace_allowed = false;
+		connector->doublescan_allowed = false;
 		break;
 	case DRM_MODE_CONNECTOR_LVDS:
 		radeon_dig_connector = kzalloc(sizeof(struct radeon_connector_atom_dig), GFP_KERNEL);
@@ -1230,6 +1249,8 @@ radeon_add_atom_connector(struct drm_device *dev,
 					      dev->mode_config.scaling_mode_property,
 					      DRM_MODE_SCALE_FULLSCREEN);
 		subpixel_order = SubPixelHorizontalRGB;
+		connector->interlace_allowed = false;
+		connector->doublescan_allowed = false;
 		break;
 	}

@@ -1297,6 +1318,8 @@ radeon_add_legacy_connector(struct drm_device *dev,
 		drm_connector_attach_property(&radeon_connector->base,
 					      rdev->mode_info.load_detect_property,
 					      1);
+		connector->interlace_allowed = true;
+		connector->doublescan_allowed = true;
 		break;
 	case DRM_MODE_CONNECTOR_DVIA:
 		drm_connector_init(dev, &radeon_connector->base, &radeon_vga_connector_funcs, connector_type);
@@ -1312,6 +1335,8 @@ radeon_add_legacy_connector(struct drm_device *dev,
 		drm_connector_attach_property(&radeon_connector->base,
 					      rdev->mode_info.load_detect_property,
 					      1);
+		connector->interlace_allowed = true;
+		connector->doublescan_allowed = true;
 		break;
 	case DRM_MODE_CONNECTOR_DVII:
 	case DRM_MODE_CONNECTOR_DVID:
@@ -1329,6 +1354,11 @@ radeon_add_legacy_connector(struct drm_device *dev,
 						      1);
 		}
 		subpixel_order = SubPixelHorizontalRGB;
+		connector->interlace_allowed = true;
+		if (connector_type == DRM_MODE_CONNECTOR_DVII)
+			connector->doublescan_allowed = true;
+		else
+			connector->doublescan_allowed = false;
 		break;
 	case DRM_MODE_CONNECTOR_SVIDEO:
 	case DRM_MODE_CONNECTOR_Composite:
@@ -1353,6 +1383,8 @@ radeon_add_legacy_connector(struct drm_device *dev,
 						      rdev->mode_info.tv_std_property,
 						      radeon_combios_get_tv_info(rdev));
 		}
+		connector->interlace_allowed = false;
+		connector->doublescan_allowed = false;
 		break;
 	case DRM_MODE_CONNECTOR_LVDS:
 		drm_connector_init(dev, &radeon_connector->base, &radeon_lvds_connector_funcs, connector_type);
@@ -1368,6 +1400,8 @@ radeon_add_legacy_connector(struct drm_device *dev,
 					      dev->mode_config.scaling_mode_property,
 					      DRM_MODE_SCALE_FULLSCREEN);
 		subpixel_order = SubPixelHorizontalRGB;
+		connector->interlace_allowed = false;
+		connector->doublescan_allowed = false;
 		break;
 	}

diff --git a/drivers/gpu/drm/radeon/radeon_encoders.c b/drivers/gpu/drm/radeon/radeon_encoders.c
index 7626bd5..ea55516 100644
--- a/drivers/gpu/drm/radeon/radeon_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_encoders.c
@@ -587,11 +587,23 @@ atombios_get_encoder_mode(struct drm_encoder *encoder)
 	struct drm_connector *connector;
 	struct radeon_connector *radeon_connector;
 	struct radeon_connector_atom_dig *radeon_dig_connector;
+	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);

 	connector = radeon_get_connector_for_encoder(encoder);
-	if (!connector)
-		return 0;
-
+	if (!connector) {
+		switch (radeon_encoder->encoder_id) {
+		case ENCODER_OBJECT_ID_INTERNAL_UNIPHY:
+		case ENCODER_OBJECT_ID_INTERNAL_UNIPHY1:
+		case ENCODER_OBJECT_ID_INTERNAL_UNIPHY2:
+		case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_LVTMA:
+		case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_DVO1:
+			return ATOM_ENCODER_MODE_DVI;
+		case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_DAC1:
+		case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_DAC2:
+		default:
+			return ATOM_ENCODER_MODE_CRT;
+		}
+	}
 	radeon_connector = to_radeon_connector(connector);

 	switch (connector->connector_type) {
diff --git a/drivers/gpu/drm/radeon/radeon_reg.h b/drivers/gpu/drm/radeon/radeon_reg.h
index 6d0a009..57bcc8e 100644
--- a/drivers/gpu/drm/radeon/radeon_reg.h
+++ b/drivers/gpu/drm/radeon/radeon_reg.h
@@ -2827,6 +2827,7 @@
 #       define R200_TXFORMAT_ST_ROUTE_STQ5	(5 << 24)
 #       define R200_TXFORMAT_ST_ROUTE_MASK	(7 << 24)
 #       define R200_TXFORMAT_ST_ROUTE_SHIFT	24
+#       define R200_TXFORMAT_LOOKUP_DISABLE	(1 << 27)
 #       define R200_TXFORMAT_ALPHA_MASK_ENABLE	(1 << 28)
 #       define R200_TXFORMAT_CHROMA_KEY_ENABLE	(1 << 29)
 #       define R200_TXFORMAT_CUBIC_MAP_ENABLE		(1 << 30)
diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index c7320ce..acbfa27 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -443,6 +443,43 @@ out_err:
 }

 /**
+ * Call bo::reserved and with the lru lock held.
+ * Will release GPU memory type usage on destruction.
+ * This is the place to put in driver specific hooks.
+ * Will release the bo::reserved lock and the
+ * lru lock on exit.
+ */
+
+static void ttm_bo_cleanup_memtype_use(struct ttm_buffer_object *bo)
+{
+	struct ttm_bo_global *glob = bo->glob;
+
+	if (bo->ttm) {
+
+		/**
+		 * Release the lru_lock, since we don't want to have
+		 * an atomic requirement on ttm_tt[unbind|destroy].
+		 */
+
+		spin_unlock(&glob->lru_lock);
+		ttm_tt_unbind(bo->ttm);
+		ttm_tt_destroy(bo->ttm);
+		bo->ttm = NULL;
+		spin_lock(&glob->lru_lock);
+	}
+
+	if (bo->mem.mm_node) {
+		drm_mm_put_block(bo->mem.mm_node);
+		bo->mem.mm_node = NULL;
+	}
+
+	atomic_set(&bo->reserved, 0);
+	wake_up_all(&bo->event_queue);
+	spin_unlock(&glob->lru_lock);
+}
+
+
+/**
  * If bo idle, remove from delayed- and lru lists, and unref.
  * If not idle, and already on delayed list, do nothing.
  * If not idle, and not on delayed list, put on delayed list,
@@ -457,6 +494,7 @@ static int ttm_bo_cleanup_refs(struct ttm_buffer_object *bo, bool remove_all)
 	int ret;

 	spin_lock(&bo->lock);
+retry:
 	(void) ttm_bo_wait(bo, false, false, !remove_all);

 	if (!bo->sync_obj) {
@@ -465,32 +503,52 @@ static int ttm_bo_cleanup_refs(struct ttm_buffer_object *bo, bool remove_all)
 		spin_unlock(&bo->lock);

 		spin_lock(&glob->lru_lock);
-		put_count = ttm_bo_del_from_lru(bo);
+		ret = ttm_bo_reserve_locked(bo, false, !remove_all, false, 0);
+
+		/**
+		 * Someone else has the object reserved. Bail and retry.
+		 */

-		ret = ttm_bo_reserve_locked(bo, false, false, false, 0);
-		BUG_ON(ret);
-		if (bo->ttm)
-			ttm_tt_unbind(bo->ttm);
+		if (unlikely(ret == -EBUSY)) {
+			spin_unlock(&glob->lru_lock);
+			spin_lock(&bo->lock);
+			goto requeue;
+		}
+
+		/**
+		 * We can re-check for sync object without taking
+		 * the bo::lock since setting the sync object requires
+		 * also bo::reserved. A busy object at this point may
+		 * be caused by another thread starting an accelerated
+		 * eviction.
+		 */
+
+		if (unlikely(bo->sync_obj)) {
+			atomic_set(&bo->reserved, 0);
+			wake_up_all(&bo->event_queue);
+			spin_unlock(&glob->lru_lock);
+			spin_lock(&bo->lock);
+			if (remove_all)
+				goto retry;
+			else
+				goto requeue;
+		}
+
+		put_count = ttm_bo_del_from_lru(bo);

 		if (!list_empty(&bo->ddestroy)) {
 			list_del_init(&bo->ddestroy);
 			++put_count;
 		}
-		if (bo->mem.mm_node) {
-			bo->mem.mm_node->private = NULL;
-			drm_mm_put_block(bo->mem.mm_node);
-			bo->mem.mm_node = NULL;
-		}
-		spin_unlock(&glob->lru_lock);

-		atomic_set(&bo->reserved, 0);
+		ttm_bo_cleanup_memtype_use(bo);

 		while (put_count--)
 			kref_put(&bo->list_kref, ttm_bo_ref_bug);

 		return 0;
 	}
-
+requeue:
 	spin_lock(&glob->lru_lock);
 	if (list_empty(&bo->ddestroy)) {
 		void *sync_obj = bo->sync_obj;
diff --git a/include/drm/ttm/ttm_bo_api.h b/include/drm/ttm/ttm_bo_api.h
index 81eb9f4..d30dc3c 100644
--- a/include/drm/ttm/ttm_bo_api.h
+++ b/include/drm/ttm/ttm_bo_api.h
@@ -224,9 +224,11 @@ struct ttm_buffer_object {

 	atomic_t reserved;

-
 	/**
 	 * Members protected by the bo::lock
+	 * In addition, setting sync_obj to anything else
+	 * than NULL requires bo::reserved to be held. This allows for
+	 * checking NULL while reserved but not holding bo::lock.
 	 */

 	void *sync_obj_arg;
