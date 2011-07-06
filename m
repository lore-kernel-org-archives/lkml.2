Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab1GFKKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 06:10:03 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:62193 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab1GFKKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 06:10:01 -0400
From: reimth@googlemail.com
To: Dave Airlie <airlied@redhat.com>, Alex Deucher <alexdeucher@gmail.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Jean Delvare <khali@linux-fr.org>,
        Tyson Whitehead <twhitehead@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Reim <rdratlos@yahoo.co.uk>
Subject: [PATCH] drm/radeon: Fix Asus M2A-VM HDMI EDID error flooding problem
Date: Wed,  6 Jul 2011 12:09:23 +0200
Message-Id: <1309946963-6409-1-git-send-email-reimth@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1308866743-8066-1-git-send-email-reimth@gmail.com>
References: <1308866743-8066-1-git-send-email-reimth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Reim <rdratlos@yahoo.co.uk>

    Some integrated ATI Radeon chipset implementations
    with add-on HDMI card (e. g. Asus M2A-VM HDMI) indicate the availability
    of a DDC even when the add-on card is not plugged in or HDMI is disabled
    in BIOS setup. In this case, drm_get_edid() and drm_edid_block_valid()
    periodically dump data and kernel errors into system log files and onto
    terminals. For these chipsets DDC probing is extended by a check for a
    correct EDID header. Only in case a valid EDID header is also found, the
    (HDMI) connector will be used by the Radeon driver. This prevents the
    kernel driver from useless flooding of logs and terminal sessions with
    EDID dumps and error messages.
    This patch adds a flag 'requires_extended_probe' to the radeon_connector
    structure. In function radeon_connector_needs_extended_probe() this flag
    can be set on a chipset family/vendor/connector type specific basis.
    In addition, function drm_edid_header_is_valid() has been added for EDID
    header check and function radeon_ddc_probe() has been adapted to perform
    extended DDC probing if required by the connector's flag.

    Tested for kernel 2.35, 2.38 and 3.0 on Asus M2A-VM HDMI board

Signed-off-by: Thomas Reim <rdratlos@yahoo.co.uk>
---
 drivers/gpu/drm/drm_edid.c                 |   24 +++++++++++----
 drivers/gpu/drm/radeon/radeon_connectors.c |   45 ++++++++++++++++++++++++++--
 drivers/gpu/drm/radeon/radeon_device.c     |    7 ++++-
 drivers/gpu/drm/radeon/radeon_display.c    |    9 +++++
 drivers/gpu/drm/radeon/radeon_i2c.c        |   32 +++++++++++++++-----
 drivers/gpu/drm/radeon/radeon_mode.h       |    6 +++-
 include/drm/drm_crtc.h                     |    1 +
 7 files changed, 105 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 0929219..1bbb85b 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -127,6 +127,23 @@ static const u8 edid_header[] = {
 	0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00
 };
 
+ /*
+ * Sanity check the header of the base EDID block.  Return 8 if the header
+ * is perfect, down to 0 if it's totally wrong.
+ */
+int drm_edid_header_is_valid(const u8 *raw_edid)
+{
+	int i, score = 0;
+
+	for (i = 0; i < sizeof(edid_header); i++)
+		if (raw_edid[i] == edid_header[i])
+			score++;
+
+	return score;
+}
+EXPORT_SYMBOL(drm_edid_header_is_valid);
+
+
 /*
  * Sanity check the EDID block (base or extension).  Return 0 if the block
  * doesn't check out, or 1 if it's valid.
@@ -139,12 +156,7 @@ drm_edid_block_valid(u8 *raw_edid)
 	struct edid *edid = (struct edid *)raw_edid;
 
 	if (raw_edid[0] == 0x00) {
-		int score = 0;
-
-		for (i = 0; i < sizeof(edid_header); i++)
-			if (raw_edid[i] == edid_header[i])
-				score++;
-
+		int score = drm_edid_header_is_valid(raw_edid);
 		if (score == 8) ;
 		else if (score >= 6) {
 			DRM_DEBUG("Fixing EDID header, your hardware may be failing\n");
diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index cbfca3a..2e70be2 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -424,6 +424,36 @@ int radeon_connector_set_property(struct drm_connector *connector, struct drm_pr
 	return 0;
 }
 
+/*
+ * Some integrated ATI Radeon chipset implementations (e. g.
+ * Asus M2A-VM HDMI) may indicate the availability of a DDC,
+ * even when there's no monitor connected. For these connectors
+ * following DDC probe extension will be applied: check also for the
+ * availability of EDID with at least a correct EDID header. Only then,
+ * DDC is assumed to be available. This prevents drm_get_edid() and
+ * drm_edid_block_valid() from periodically dumping data and kernel
+ * errors into the logs and onto the terminal.
+ */
+static bool radeon_connector_needs_extended_probe(struct radeon_device *dev,
+				     uint32_t supported_device,
+				     int connector_type)
+{
+	/* Asus M2A-VM HDMI board sends data to i2c bus even,
+	 * if HDMI add-on card is not plugged in or HDMI is disabled in
+	 * BIOS. Valid DDC can only be assumed, if also a valid EDID header
+	 * can be retrieved via i2c bus during DDC probe */
+	if ((dev->pdev->device == 0x791e) &&
+	    (dev->pdev->subsystem_vendor == 0x1043) &&
+	    (dev->pdev->subsystem_device == 0x826d)) {
+		if ((connector_type == DRM_MODE_CONNECTOR_HDMIA) &&
+		    (supported_device == ATOM_DEVICE_DFP2_SUPPORT))
+			return true;
+	}
+
+	/* Default: no EDID header probe required for DDC probing */
+	return false;
+}
+
 static void radeon_fixup_lvds_native_mode(struct drm_encoder *encoder,
 					  struct drm_connector *connector)
 {
@@ -655,7 +685,8 @@ radeon_vga_detect(struct drm_connector *connector, bool force)
 		ret = connector_status_disconnected;
 
 	if (radeon_connector->ddc_bus)
-		dret = radeon_ddc_probe(radeon_connector);
+		dret = radeon_ddc_probe(radeon_connector,
+					radeon_connector->requires_extended_probe);
 	if (dret) {
 		if (radeon_connector->edid) {
 			kfree(radeon_connector->edid);
@@ -827,7 +858,8 @@ radeon_dvi_detect(struct drm_connector *connector, bool force)
 	bool dret = false;
 
 	if (radeon_connector->ddc_bus)
-		dret = radeon_ddc_probe(radeon_connector);
+		dret = radeon_ddc_probe(radeon_connector,
+					radeon_connector->requires_extended_probe);
 	if (dret) {
 		if (radeon_connector->edid) {
 			kfree(radeon_connector->edid);
@@ -1245,7 +1277,8 @@ radeon_dp_detect(struct drm_connector *connector, bool force)
 				if (radeon_dp_getdpcd(radeon_connector))
 					ret = connector_status_connected;
 			} else {
-				if (radeon_ddc_probe(radeon_connector))
+				if (radeon_ddc_probe(radeon_connector,
+						     radeon_connector->requires_extended_probe))
 					ret = connector_status_connected;
 			}
 		}
@@ -1400,6 +1433,9 @@ radeon_add_atom_connector(struct drm_device *dev,
 	radeon_connector->shared_ddc = shared_ddc;
 	radeon_connector->connector_object_id = connector_object_id;
 	radeon_connector->hpd = *hpd;
+	radeon_connector->requires_extended_probe =
+		radeon_connector_needs_extended_probe(rdev, supported_device,
+							connector_type);
 	radeon_connector->router = *router;
 	if (router->ddc_valid || router->cd_valid) {
 		radeon_connector->router_bus = radeon_i2c_lookup(rdev, &router->i2c_info);
@@ -1746,6 +1782,9 @@ radeon_add_legacy_connector(struct drm_device *dev,
 	radeon_connector->devices = supported_device;
 	radeon_connector->connector_object_id = connector_object_id;
 	radeon_connector->hpd = *hpd;
+	radeon_connector->requires_extended_probe =
+		radeon_connector_needs_extended_probe(rdev, supported_device,
+							connector_type);
 	switch (connector_type) {
 	case DRM_MODE_CONNECTOR_VGA:
 		drm_connector_init(dev, &radeon_connector->base, &radeon_vga_connector_funcs, connector_type);
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 7cfaa7e..cbdac3d 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -704,8 +704,13 @@ int radeon_device_init(struct radeon_device *rdev,
 	rdev->gpu_lockup = false;
 	rdev->accel_working = false;
 
-	DRM_INFO("initializing kernel modesetting (%s 0x%04X:0x%04X).\n",
+	if (pdev->subsystem_vendor == 0)
+		DRM_INFO("initializing kernel modesetting (%s 0x%04X:0x%04X).\n",
 		radeon_family_name[rdev->family], pdev->vendor, pdev->device);
+	else
+		DRM_INFO("initializing kernel modesetting (%s 0x%04X:0x%04X 0x%04X:0x%04X).\n",
+		radeon_family_name[rdev->family], pdev->vendor, pdev->device,
+		pdev->subsystem_vendor, pdev->subsystem_device);
 
 	/* mutex initialization are all done here so we
 	 * can recall function without having locking issues */
diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index 292f73f..ed085ce 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -777,8 +777,17 @@ static int radeon_ddc_dump(struct drm_connector *connector)
 	if (!radeon_connector->ddc_bus)
 		return -1;
 	edid = drm_get_edid(connector, &radeon_connector->ddc_bus->adapter);
+	/* Log EDID retrieval status here. In particular with regard to
+	 * connectors with requires_extended_probe flag set, that will prevent
+	 * function radeon_dvi_detect() to fetch EDID on this connector,
+	 * as long as there is no valid EDID header found */
 	if (edid) {
+		DRM_INFO("Radeon display connector %s: Found valid EDID",
+				drm_get_connector_name(connector));
 		kfree(edid);
+	} else {
+		DRM_INFO("Radeon display connector %s: No monitor connected or invalid EDID",
+				drm_get_connector_name(connector));
 	}
 	return ret;
 }
diff --git a/drivers/gpu/drm/radeon/radeon_i2c.c b/drivers/gpu/drm/radeon/radeon_i2c.c
index 781196d..6c111c1 100644
--- a/drivers/gpu/drm/radeon/radeon_i2c.c
+++ b/drivers/gpu/drm/radeon/radeon_i2c.c
@@ -32,17 +32,17 @@
  * radeon_ddc_probe
  *
  */
-bool radeon_ddc_probe(struct radeon_connector *radeon_connector)
+bool radeon_ddc_probe(struct radeon_connector *radeon_connector, bool requires_extended_probe)
 {
-	u8 out_buf[] = { 0x0, 0x0};
-	u8 buf[2];
+	u8 out = 0x0;
+	u8 buf[8];
 	int ret;
 	struct i2c_msg msgs[] = {
 		{
 			.addr = 0x50,
 			.flags = 0,
 			.len = 1,
-			.buf = out_buf,
+			.buf = &out,
 		},
 		{
 			.addr = 0x50,
@@ -52,15 +52,31 @@ bool radeon_ddc_probe(struct radeon_connector *radeon_connector)
 		}
 	};
 
+	/* Read 8 bytes from i2c for extended probe of EDID header */
+	if (requires_extended_probe)
+		msgs[1].len = 8;
+
 	/* on hw with routers, select right port */
 	if (radeon_connector->router.ddc_valid)
 		radeon_router_select_ddc_port(radeon_connector);
 
 	ret = i2c_transfer(&radeon_connector->ddc_bus->adapter, msgs, 2);
-	if (ret == 2)
-		return true;
-
-	return false;
+	if (ret != 2)
+		/* Couldn't find an accessible DDC on this connector */
+		return false;
+	if (requires_extended_probe) {
+		/* Probe also for valid EDID header
+		 * EDID header starts with:
+		 * 0x00,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x00.
+		 * Only the first 6 bytes must be valid as
+		 * drm_edid_block_valid() can fix the last 2 bytes */
+		if (drm_edid_header_is_valid(buf) < 6) {
+			/* Couldn't find an accessible EDID on this
+			 * connector */
+			return false;
+		}
+	}
+	return true;
 }
 
 /* bit banging i2c */
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
index 6df4e3c..d09031c 100644
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -438,6 +438,9 @@ struct radeon_connector {
 	struct radeon_i2c_chan *ddc_bus;
 	/* some systems have an hdmi and vga port with a shared ddc line */
 	bool shared_ddc;
+	/* for some Radeon chip families we apply an additional EDID header
+	   check as part of the DDC probe */
+	bool requires_extended_probe;
 	bool use_digital;
 	/* we need to mind the EDID between detect
 	   and get modes due to analog/digital/tvencoder */
@@ -514,7 +517,8 @@ extern void radeon_i2c_put_byte(struct radeon_i2c_chan *i2c,
 				u8 val);
 extern void radeon_router_select_ddc_port(struct radeon_connector *radeon_connector);
 extern void radeon_router_select_cd_port(struct radeon_connector *radeon_connector);
-extern bool radeon_ddc_probe(struct radeon_connector *radeon_connector);
+extern bool radeon_ddc_probe(struct radeon_connector *radeon_connector,
+			bool requires_extended_probe);
 extern int radeon_ddc_get_modes(struct radeon_connector *radeon_connector);
 
 extern struct drm_encoder *radeon_best_encoder(struct drm_connector *connector);
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index 33d12f8..0ec3687 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -802,6 +802,7 @@ extern struct drm_display_mode *drm_gtf_mode_complex(struct drm_device *dev,
 extern int drm_add_modes_noedid(struct drm_connector *connector,
 				int hdisplay, int vdisplay);
 
+extern int drm_edid_header_is_valid(const u8 *raw_edid);
 extern bool drm_edid_is_valid(struct edid *edid);
 struct drm_display_mode *drm_mode_find_dmt(struct drm_device *dev,
 					   int hsize, int vsize, int fresh);
-- 
1.7.1

