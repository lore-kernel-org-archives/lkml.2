Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab0LLXrT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:47:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36333 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab0LLXrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:16 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: alexdeucher@gmail.com, airlied@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [133/223] drm/radeon/kms: fix interlaced and doublescan handling
Message-Id: <20101212234715.5D640B27C0@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alex Deucher <alexdeucher@gmail.com>

commit c49948f4bd39e27dd06a1cdb0c3743ca2a734f5e upstream.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/radeon/radeon_connectors.c |   34 +++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

Index: linux/drivers/gpu/drm/radeon/radeon_connectors.c
===================================================================
--- linux.orig/drivers/gpu/drm/radeon/radeon_connectors.c
+++ linux/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -1083,6 +1083,8 @@ radeon_add_atom_connector(struct drm_dev
 					      rdev->mode_info.load_detect_property,
 					      1);
 		connector->polled = DRM_CONNECTOR_POLL_CONNECT;
+		connector->interlace_allowed = true;
+		connector->doublescan_allowed = true;
 		break;
 	case DRM_MODE_CONNECTOR_DVIA:
 		drm_connector_init(dev, &radeon_connector->base, &radeon_vga_connector_funcs, connector_type);
@@ -1096,6 +1098,8 @@ radeon_add_atom_connector(struct drm_dev
 		drm_connector_attach_property(&radeon_connector->base,
 					      rdev->mode_info.load_detect_property,
 					      1);
+		connector->interlace_allowed = true;
+		connector->doublescan_allowed = true;
 		break;
 	case DRM_MODE_CONNECTOR_DVII:
 	case DRM_MODE_CONNECTOR_DVID:
@@ -1122,6 +1126,11 @@ radeon_add_atom_connector(struct drm_dev
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
@@ -1142,6 +1151,11 @@ radeon_add_atom_connector(struct drm_dev
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
@@ -1172,6 +1186,9 @@ radeon_add_atom_connector(struct drm_dev
 		drm_connector_attach_property(&radeon_connector->base,
 					      rdev->mode_info.coherent_mode_property,
 					      1);
+		connector->interlace_allowed = true;
+		/* in theory with a DP to VGA converter... */
+		connector->doublescan_allowed = false;
 		break;
 	case DRM_MODE_CONNECTOR_SVIDEO:
 	case DRM_MODE_CONNECTOR_Composite:
@@ -1187,6 +1204,8 @@ radeon_add_atom_connector(struct drm_dev
 						      rdev->mode_info.tv_std_property,
 						      radeon_atombios_get_tv_info(rdev));
 		}
+		connector->interlace_allowed = false;
+		connector->doublescan_allowed = false;
 		break;
 	case DRM_MODE_CONNECTOR_LVDS:
 		radeon_dig_connector = kzalloc(sizeof(struct radeon_connector_atom_dig), GFP_KERNEL);
@@ -1206,6 +1225,8 @@ radeon_add_atom_connector(struct drm_dev
 					      dev->mode_config.scaling_mode_property,
 					      DRM_MODE_SCALE_FULLSCREEN);
 		subpixel_order = SubPixelHorizontalRGB;
+		connector->interlace_allowed = false;
+		connector->doublescan_allowed = false;
 		break;
 	}
 
@@ -1277,6 +1298,8 @@ radeon_add_legacy_connector(struct drm_d
 					      rdev->mode_info.load_detect_property,
 					      1);
 		connector->polled = DRM_CONNECTOR_POLL_CONNECT;
+		connector->interlace_allowed = true;
+		connector->doublescan_allowed = true;
 		break;
 	case DRM_MODE_CONNECTOR_DVIA:
 		drm_connector_init(dev, &radeon_connector->base, &radeon_vga_connector_funcs, connector_type);
@@ -1290,6 +1313,8 @@ radeon_add_legacy_connector(struct drm_d
 		drm_connector_attach_property(&radeon_connector->base,
 					      rdev->mode_info.load_detect_property,
 					      1);
+		connector->interlace_allowed = true;
+		connector->doublescan_allowed = true;
 		break;
 	case DRM_MODE_CONNECTOR_DVII:
 	case DRM_MODE_CONNECTOR_DVID:
@@ -1307,6 +1332,11 @@ radeon_add_legacy_connector(struct drm_d
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
@@ -1329,6 +1359,8 @@ radeon_add_legacy_connector(struct drm_d
 						      rdev->mode_info.tv_std_property,
 						      radeon_combios_get_tv_info(rdev));
 		}
+		connector->interlace_allowed = false;
+		connector->doublescan_allowed = false;
 		break;
 	case DRM_MODE_CONNECTOR_LVDS:
 		drm_connector_init(dev, &radeon_connector->base, &radeon_lvds_connector_funcs, connector_type);
@@ -1342,6 +1374,8 @@ radeon_add_legacy_connector(struct drm_d
 					      dev->mode_config.scaling_mode_property,
 					      DRM_MODE_SCALE_FULLSCREEN);
 		subpixel_order = SubPixelHorizontalRGB;
+		connector->interlace_allowed = false;
+		connector->doublescan_allowed = false;
 		break;
 	}
 
