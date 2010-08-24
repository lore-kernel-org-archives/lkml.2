Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934007Ab0HXXUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:20:07 -0400
Received: from kroah.org ([198.145.64.141]:40964 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933375Ab0HXXBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:01:53 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:04 2010
Message-Id: <20100824224503.975895740@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:44:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [031/114] drm/radeon/kms: add additional quirk for Acer rv620 laptop
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 9ea2c4be978d597076ddc6c550557de5d243cea8 upstream.

HPD pins are reversed

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=29387

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -206,6 +206,7 @@ static bool radeon_atom_apply_quirks(str
 				     uint16_t *line_mux,
 				     struct radeon_hpd *hpd)
 {
+	struct radeon_device *rdev = dev->dev_private;
 
 	/* Asus M2A-VM HDMI board lists the DVI port as HDMI */
 	if ((dev->pdev->device == 0x791e) &&
@@ -308,13 +309,22 @@ static bool radeon_atom_apply_quirks(str
 		}
 	}
 
-	/* Acer laptop reports DVI-D as DVI-I */
+	/* Acer laptop reports DVI-D as DVI-I and hpd pins reversed */
 	if ((dev->pdev->device == 0x95c4) &&
 	    (dev->pdev->subsystem_vendor == 0x1025) &&
 	    (dev->pdev->subsystem_device == 0x013c)) {
+		struct radeon_gpio_rec gpio;
+
 		if ((*connector_type == DRM_MODE_CONNECTOR_DVII) &&
-		    (supported_device == ATOM_DEVICE_DFP1_SUPPORT))
+		    (supported_device == ATOM_DEVICE_DFP1_SUPPORT)) {
+			gpio = radeon_lookup_gpio(rdev, 6);
+			*hpd = radeon_atom_get_hpd_info_from_gpio(rdev, &gpio);
 			*connector_type = DRM_MODE_CONNECTOR_DVID;
+		} else if ((*connector_type == DRM_MODE_CONNECTOR_HDMIA) &&
+			   (supported_device == ATOM_DEVICE_DFP1_SUPPORT)) {
+			gpio = radeon_lookup_gpio(rdev, 7);
+			*hpd = radeon_atom_get_hpd_info_from_gpio(rdev, &gpio);
+		}
 	}
 
 	/* XFX Pine Group device rv730 reports no VGA DDC lines


