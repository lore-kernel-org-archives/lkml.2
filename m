Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab1DZM33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:29:29 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57319 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab1DZM0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:26:35 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, maximilian attems <max@stro.at>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 10/21] drm/radeon/kms: fix interlaced and doublescan handling" has been added to staging queue
Date: Tue, 26 Apr 2011 14:26:32 +0200
Message-Id: <1303820792-3681-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 10/21] drm/radeon/kms: fix interlaced and doublescan handling

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 16934321f1b31cccf7a39195821eace81d4eabe2 Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexdeucher@gmail.com>
Date: Tue, 30 Nov 2010 15:46:47 -0500
Subject: [PATCH 10/21] drm/radeon/kms: fix interlaced and doublescan handling

commit c49948f4bd39e27dd06a1cdb0c3743ca2a734f5e upstream.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
[ backported -maks ]
Signed-off-by: maximilian attems <max@stro.at>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_connectors.c |   34 ++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

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

--
1.7.0.4

