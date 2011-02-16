Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488Ab1BPAza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:55:30 -0500
Received: from kroah.org ([198.145.64.141]:46240 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933465Ab1BPAvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:51:53 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:15 2011
Message-Id: <20110216002115.006122838@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:22:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [patch 160/176] drm/radeon/kms: adjust quirk for acer laptop
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 2f299d5de02da3ffb1f9e1a05c91dcd1173ebd3c upstream.

Acer laptop (TravelMate 5730G) has an HDMI connector
on the laptop and a DVI connector on the docking station
and both share the same encoder, hpd pin, and ddc line.
The bios connector table reflects this and is technically
correct, however, we drop the DVI connector here since
xrandr has no concept of encoders (only crtcs and connectors)
and will try and drive both connectors with different crtcs
which isn't possible on the hardware side and leaves no crtcs
for LVDS or VGA.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=32732

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -313,7 +313,6 @@ static bool radeon_atom_apply_quirks(str
 				     uint16_t *line_mux,
 				     struct radeon_hpd *hpd)
 {
-	struct radeon_device *rdev = dev->dev_private;
 
 	/* Asus M2A-VM HDMI board lists the DVI port as HDMI */
 	if ((dev->pdev->device == 0x791e) &&
@@ -436,21 +435,23 @@ static bool radeon_atom_apply_quirks(str
 		}
 	}
 
-	/* Acer laptop reports DVI-D as DVI-I and hpd pins reversed */
+	/* Acer laptop (Acer TravelMate 5730G) has an HDMI port
+	 * on the laptop and a DVI port on the docking station and
+	 * both share the same encoder, hpd pin, and ddc line.
+	 * So while the bios table is technically correct,
+	 * we drop the DVI port here since xrandr has no concept of
+	 * encoders and will try and drive both connectors
+	 * with different crtcs which isn't possible on the hardware
+	 * side and leaves no crtcs for LVDS or VGA.
+	 */
 	if ((dev->pdev->device == 0x95c4) &&
 	    (dev->pdev->subsystem_vendor == 0x1025) &&
 	    (dev->pdev->subsystem_device == 0x013c)) {
-		struct radeon_gpio_rec gpio;
-
 		if ((*connector_type == DRM_MODE_CONNECTOR_DVII) &&
 		    (supported_device == ATOM_DEVICE_DFP1_SUPPORT)) {
-			gpio = radeon_lookup_gpio(rdev, 6);
-			*hpd = radeon_atom_get_hpd_info_from_gpio(rdev, &gpio);
+			/* actually it's a DVI-D port not DVI-I */
 			*connector_type = DRM_MODE_CONNECTOR_DVID;
-		} else if ((*connector_type == DRM_MODE_CONNECTOR_HDMIA) &&
-			   (supported_device == ATOM_DEVICE_DFP1_SUPPORT)) {
-			gpio = radeon_lookup_gpio(rdev, 7);
-			*hpd = radeon_atom_get_hpd_info_from_gpio(rdev, &gpio);
+			return false;
 		}
 	}
 


