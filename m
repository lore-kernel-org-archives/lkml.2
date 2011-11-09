Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab1KJEys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:54:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42827 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935282Ab1KJDbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:31:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:21 2011
Message-Id: <20111109212721.202875519@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [205/262] drm/radeon/kms: set HPD polarity in hpd_init()
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 64912e997f0fe13512e4c7b90e4f7c11cb922ab5 upstream.

Polarity needs to be set accordingly to connector status (connected
or disconnected). Set it up in hpd_init() so first hotplug works
reliably no matter what is the initial set of connector. hpd_init()
also covers resume so HPD will work correctly after resume as well.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Jerome Glisse <j.glisse@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/evergreen.c         |    1 +
 drivers/gpu/drm/radeon/r100.c              |    1 +
 drivers/gpu/drm/radeon/r600.c              |   19 +++++++++----------
 drivers/gpu/drm/radeon/radeon_connectors.c |    1 -
 drivers/gpu/drm/radeon/rs600.c             |    1 +
 5 files changed, 12 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -353,6 +353,7 @@ void evergreen_hpd_init(struct radeon_de
 		default:
 			break;
 		}
+		radeon_hpd_set_polarity(rdev, radeon_connector->hpd.hpd);
 	}
 	if (rdev->irq.installed)
 		evergreen_irq_set(rdev);
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -434,6 +434,7 @@ void r100_hpd_init(struct radeon_device
 		default:
 			break;
 		}
+		radeon_hpd_set_polarity(rdev, radeon_connector->hpd.hpd);
 	}
 	if (rdev->irq.installed)
 		r100_irq_set(rdev);
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -762,13 +762,14 @@ void r600_hpd_init(struct radeon_device
 	struct drm_device *dev = rdev->ddev;
 	struct drm_connector *connector;
 
-	if (ASIC_IS_DCE3(rdev)) {
-		u32 tmp = DC_HPDx_CONNECTION_TIMER(0x9c4) | DC_HPDx_RX_INT_TIMER(0xfa);
-		if (ASIC_IS_DCE32(rdev))
-			tmp |= DC_HPDx_EN;
+	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
+		struct radeon_connector *radeon_connector = to_radeon_connector(connector);
+
+		if (ASIC_IS_DCE3(rdev)) {
+			u32 tmp = DC_HPDx_CONNECTION_TIMER(0x9c4) | DC_HPDx_RX_INT_TIMER(0xfa);
+			if (ASIC_IS_DCE32(rdev))
+				tmp |= DC_HPDx_EN;
 
-		list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
-			struct radeon_connector *radeon_connector = to_radeon_connector(connector);
 			switch (radeon_connector->hpd.hpd) {
 			case RADEON_HPD_1:
 				WREG32(DC_HPD1_CONTROL, tmp);
@@ -798,10 +799,7 @@ void r600_hpd_init(struct radeon_device
 			default:
 				break;
 			}
-		}
-	} else {
-		list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
-			struct radeon_connector *radeon_connector = to_radeon_connector(connector);
+		} else {
 			switch (radeon_connector->hpd.hpd) {
 			case RADEON_HPD_1:
 				WREG32(DC_HOT_PLUG_DETECT1_CONTROL, DC_HOT_PLUG_DETECTx_EN);
@@ -819,6 +817,7 @@ void r600_hpd_init(struct radeon_device
 				break;
 			}
 		}
+		radeon_hpd_set_polarity(rdev, radeon_connector->hpd.hpd);
 	}
 	if (rdev->irq.installed)
 		r600_irq_set(rdev);
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -1779,7 +1779,6 @@ radeon_add_atom_connector(struct drm_dev
 			connector->polled = DRM_CONNECTOR_POLL_CONNECT;
 	} else
 		connector->polled = DRM_CONNECTOR_POLL_HPD;
-	radeon_hpd_set_polarity(rdev, radeon_connector->hpd.hpd);
 
 	connector->display_info.subpixel_order = subpixel_order;
 	drm_sysfs_connector_add(connector);
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -287,6 +287,7 @@ void rs600_hpd_init(struct radeon_device
 		default:
 			break;
 		}
+		radeon_hpd_set_polarity(rdev, radeon_connector->hpd.hpd);
 	}
 	if (rdev->irq.installed)
 		rs600_irq_set(rdev);


