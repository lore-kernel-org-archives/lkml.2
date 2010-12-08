Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab0LHB0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:26:05 -0500
Received: from kroah.org ([198.145.64.141]:33479 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932482Ab0LHBCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:31 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:39 2010
Message-Id: <20101208005739.669113240@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [182/289] drm/radeon/kms: fix interlaced and doublescan handling
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit c49948f4bd39e27dd06a1cdb0c3743ca2a734f5e upstream.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_connectors.c |   34 +++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -1119,6 +1119,8 @@ radeon_add_atom_connector(struct drm_dev
 		/* no HPD on analog connectors */
 		radeon_connector->hpd.hpd = RADEON_HPD_NONE;
 		connector->polled = DRM_CONNECTOR_POLL_CONNECT;
+		connector->interlace_allowed = true;
+		connector->doublescan_allowed = true;
 		break;
 	case DRM_MODE_CONNECTOR_DVIA:
 		drm_connector_init(dev, &radeon_connector->base, &radeon_vga_connector_funcs, connector_type);
@@ -1134,6 +1136,8 @@ radeon_add_atom_connector(struct drm_dev
 					      1);
 		/* no HPD on analog connectors */
 		radeon_connector->hpd.hpd = RADEON_HPD_NONE;
+		connector->interlace_allowed = true;
+		connector->doublescan_allowed = true;
 		break;
 	case DRM_MODE_CONNECTOR_DVII:
 	case DRM_MODE_CONNECTOR_DVID:
@@ -1163,6 +1167,11 @@ radeon_add_atom_connector(struct drm_dev
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
@@ -1186,6 +1195,11 @@ radeon_add_atom_connector(struct drm_dev
 						      rdev->mode_info.underscan_property,
 						      UNDERSCAN_AUTO);
 		subpixel_order = SubPixelHorizontalRGB;
+		connector->interlace_allowed = true;
+		if (connector_type == DRM_MODE_CONNECTOR_HDMIB)
+			connector->doublescan_allowed = true;
+		else
+			connector->doublescan_allowed = false;
 		break;
 	case DRM_MODE_CONNECTOR_DisplayPort:
 	case DRM_MODE_CONNECTOR_eDP:
@@ -1216,6 +1230,9 @@ radeon_add_atom_connector(struct drm_dev
 			drm_connector_attach_property(&radeon_connector->base,
 						      rdev->mode_info.underscan_property,
 						      UNDERSCAN_AUTO);
+		connector->interlace_allowed = true;
+		/* in theory with a DP to VGA converter... */
+		connector->doublescan_allowed = false;
 		break;
 	case DRM_MODE_CONNECTOR_SVIDEO:
 	case DRM_MODE_CONNECTOR_Composite:
@@ -1231,6 +1248,8 @@ radeon_add_atom_connector(struct drm_dev
 					      radeon_atombios_get_tv_info(rdev));
 		/* no HPD on analog connectors */
 		radeon_connector->hpd.hpd = RADEON_HPD_NONE;
+		connector->interlace_allowed = false;
+		connector->doublescan_allowed = false;
 		break;
 	case DRM_MODE_CONNECTOR_LVDS:
 		radeon_dig_connector = kzalloc(sizeof(struct radeon_connector_atom_dig), GFP_KERNEL);
@@ -1249,6 +1268,8 @@ radeon_add_atom_connector(struct drm_dev
 					      dev->mode_config.scaling_mode_property,
 					      DRM_MODE_SCALE_FULLSCREEN);
 		subpixel_order = SubPixelHorizontalRGB;
+		connector->interlace_allowed = false;
+		connector->doublescan_allowed = false;
 		break;
 	}
 
@@ -1326,6 +1347,8 @@ radeon_add_legacy_connector(struct drm_d
 		/* no HPD on analog connectors */
 		radeon_connector->hpd.hpd = RADEON_HPD_NONE;
 		connector->polled = DRM_CONNECTOR_POLL_CONNECT;
+		connector->interlace_allowed = true;
+		connector->doublescan_allowed = true;
 		break;
 	case DRM_MODE_CONNECTOR_DVIA:
 		drm_connector_init(dev, &radeon_connector->base, &radeon_vga_connector_funcs, connector_type);
@@ -1341,6 +1364,8 @@ radeon_add_legacy_connector(struct drm_d
 					      1);
 		/* no HPD on analog connectors */
 		radeon_connector->hpd.hpd = RADEON_HPD_NONE;
+		connector->interlace_allowed = true;
+		connector->doublescan_allowed = true;
 		break;
 	case DRM_MODE_CONNECTOR_DVII:
 	case DRM_MODE_CONNECTOR_DVID:
@@ -1358,6 +1383,11 @@ radeon_add_legacy_connector(struct drm_d
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
@@ -1380,6 +1410,8 @@ radeon_add_legacy_connector(struct drm_d
 					      radeon_combios_get_tv_info(rdev));
 		/* no HPD on analog connectors */
 		radeon_connector->hpd.hpd = RADEON_HPD_NONE;
+		connector->interlace_allowed = false;
+		connector->doublescan_allowed = false;
 		break;
 	case DRM_MODE_CONNECTOR_LVDS:
 		drm_connector_init(dev, &radeon_connector->base, &radeon_lvds_connector_funcs, connector_type);
@@ -1393,6 +1425,8 @@ radeon_add_legacy_connector(struct drm_d
 					      dev->mode_config.scaling_mode_property,
 					      DRM_MODE_SCALE_FULLSCREEN);
 		subpixel_order = SubPixelHorizontalRGB;
+		connector->interlace_allowed = false;
+		connector->doublescan_allowed = false;
 		break;
 	}
 


