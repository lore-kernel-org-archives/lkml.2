Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987Ab1FWWGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:06:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43647 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab1FWWGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:06:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kL2koCE7RE5ynk2W2bKJAZYIDuZhvM6aXKbQh3NcNH6eTjw+og1AY+/zv/gKewrpJa
         XR8JhfCl4VjKB3f43IP5u9hRtCkpgVm4D56SvXU+j7gvZl8GJaHDj5XnfPlhVwJxktjh
         GPDCUgTePKKOqNUMmSwV7pEUEX3xsuKDSUtzQ=
From: reimth@googlemail.com
To: Dave Airlie <airlied@redhat.com>, Alex Deucher <alexdeucher@gmail.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Jean Delvare <khali@linux-fr.org>,
        Tyson Whitehead <twhitehead@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Reim <rdratlos@yahoo.co.uk>
Subject: [PATCH] drm/radeon: Fix Asus M2A-VM HDMI EDID error flooding problem
Date: Fri, 24 Jun 2011 00:05:43 +0200
Message-Id: <1308866743-8066-1-git-send-email-reimth@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1308705639-4215-1-git-send-email-reimth@gmail.com>
References: <1308705639-4215-1-git-send-email-reimth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Reim <rdratlos@yahoo.co.uk>

Some integrated ATI Radeon chipset implementations
(e. g. Asus M2A-VM HDMI, RS690) indicate the availability
of a DDC even when there's no monitor connected.
In this case, drm_get_edid() and drm_edid_block_valid()
periodically dump data and kernel errors into system
log files and onto terminals, which lead to an unacceptable
system behaviour. For this purpose function drm_edid_header_is_valid()
has been added to drm and function drm_edid_block_valid()
has been adapted to also use drm_edid_header_is_valid().

Tested since kernel 2.35 on Asus M2A-VM HDMI board

Signed-off-by: Thomas Reim <rdratlos@yahoo.co.uk>
---
 drivers/gpu/drm/drm_edid.c                 |   23 +++++++++++---
 drivers/gpu/drm/radeon/radeon_connectors.c |   29 ++++++++++++++++-
 drivers/gpu/drm/radeon/radeon_display.c    |   12 +++++++
 drivers/gpu/drm/radeon/radeon_i2c.c        |   45 ++++++++++++++++++++++++++-
 drivers/gpu/drm/radeon/radeon_mode.h       |    4 ++
 include/drm/drm_crtc.h                     |    1 +
 6 files changed, 105 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 0929219..1daaf81 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -128,6 +128,23 @@ static const u8 edid_header[] = {
 };
 
 /*
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
+/*
  * Sanity check the EDID block (base or extension).  Return 0 if the block
  * doesn't check out, or 1 if it's valid.
  */
@@ -139,11 +156,7 @@ drm_edid_block_valid(u8 *raw_edid)
 	struct edid *edid = (struct edid *)raw_edid;
 
 	if (raw_edid[0] == 0x00) {
-		int score = 0;
-
-		for (i = 0; i < sizeof(edid_header); i++)
-			if (raw_edid[i] == edid_header[i])
-				score++;
+		int score = drm_edid_header_is_valid(raw_edid);
 
 		if (score == 8) ;
 		else if (score >= 6) {
diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index cbfca3a..bcd2380 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -826,8 +826,12 @@ radeon_dvi_detect(struct drm_connector *connector, bool force)
 	enum drm_connector_status ret = connector_status_disconnected;
 	bool dret = false;
 
-	if (radeon_connector->ddc_bus)
-		dret = radeon_ddc_probe(radeon_connector);
+	if (radeon_connector->ddc_bus) {
+		if (radeon_connector->requires_extended_probe)
+			dret = radeon_ddc_probe_extended(radeon_connector);
+		else
+			dret = radeon_ddc_probe(radeon_connector);
+	}
 	if (dret) {
 		if (radeon_connector->edid) {
 			kfree(radeon_connector->edid);
@@ -1342,6 +1346,7 @@ radeon_add_atom_connector(struct drm_device *dev,
 	struct radeon_encoder *radeon_encoder;
 	uint32_t subpixel_order = SubPixelNone;
 	bool shared_ddc = false;
+	bool requires_extended_probe = false;
 	bool is_dp_bridge = false;
 
 	if (connector_type == DRM_MODE_CONNECTOR_Unknown)
@@ -1400,6 +1405,7 @@ radeon_add_atom_connector(struct drm_device *dev,
 	radeon_connector->shared_ddc = shared_ddc;
 	radeon_connector->connector_object_id = connector_object_id;
 	radeon_connector->hpd = *hpd;
+	radeon_connector->requires_extended_probe = requires_extended_probe;
 	radeon_connector->router = *router;
 	if (router->ddc_valid || router->cd_valid) {
 		radeon_connector->router_bus = radeon_i2c_lookup(rdev, &router->i2c_info);
@@ -1688,6 +1694,23 @@ radeon_add_atom_connector(struct drm_device *dev,
 		}
 	}
 
+	/* RS690 HDMI DDC quirk:
+	 * Some integrated ATI Radeon chipset implementations (e. g.
+	 * Asus M2A-VM HDMI) indicate the availability of a DDC even
+	 * when there's no monitor connected to HDMI. For HDMI
+	 * connectors we check for the availability of EDID with
+	 * at least a correct EDID header and EDID version/revision
+	 * information. Only then, DDC is assumed to be available.
+	 * This prevents drm_get_edid() and drm_edid_block_valid() of
+	 * periodically dumping data and kernel errors into the logs
+	 * and onto the terminal, which would lead to an unacceptable
+	 * system behaviour */
+	if (connector_type == DRM_MODE_CONNECTOR_HDMIA &&
+		(rdev->family == CHIP_RS690 ||
+		 rdev->family == CHIP_RS740 ||
+		 rdev->family == CHIP_RV630))
+		requires_extended_probe = true;
+	radeon_connector->requires_extended_probe = requires_extended_probe;
 	if (radeon_connector->hpd.hpd == RADEON_HPD_NONE) {
 		if (i2c_bus->valid)
 			connector->polled = DRM_CONNECTOR_POLL_CONNECT;
@@ -1716,6 +1739,7 @@ radeon_add_legacy_connector(struct drm_device *dev,
 	struct drm_connector *connector;
 	struct radeon_connector *radeon_connector;
 	uint32_t subpixel_order = SubPixelNone;
+	bool requires_extended_probe = false;
 
 	if (connector_type == DRM_MODE_CONNECTOR_Unknown)
 		return;
@@ -1746,6 +1770,7 @@ radeon_add_legacy_connector(struct drm_device *dev,
 	radeon_connector->devices = supported_device;
 	radeon_connector->connector_object_id = connector_object_id;
 	radeon_connector->hpd = *hpd;
+	radeon_connector->requires_extended_probe = requires_extended_probe;
 	switch (connector_type) {
 	case DRM_MODE_CONNECTOR_VGA:
 		drm_connector_init(dev, &radeon_connector->base, &radeon_vga_connector_funcs, connector_type);
diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index 292f73f..27e6840 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -715,6 +715,9 @@ static bool radeon_setup_enc_conn(struct drm_device *dev)
 	if (ret) {
 		radeon_setup_encoder_clones(dev);
 		radeon_print_display_setup(dev);
+		/* Is this really required here?
+		   Seems to just force drm to dump EDID errors
+		   to kernel logs */
 		list_for_each_entry(drm_connector, &dev->mode_config.connector_list, head)
 			radeon_ddc_dump(drm_connector);
 	}
@@ -777,8 +780,17 @@ static int radeon_ddc_dump(struct drm_connector *connector)
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
index 781196d..7e93cf9 100644
--- a/drivers/gpu/drm/radeon/radeon_i2c.c
+++ b/drivers/gpu/drm/radeon/radeon_i2c.c
@@ -34,7 +34,7 @@
  */
 bool radeon_ddc_probe(struct radeon_connector *radeon_connector)
 {
-	u8 out_buf[] = { 0x0, 0x0};
+	u8 out = 0x0;
 	u8 buf[2];
 	int ret;
 	struct i2c_msg msgs[] = {
@@ -42,7 +42,7 @@ bool radeon_ddc_probe(struct radeon_connector *radeon_connector)
 			.addr = 0x50,
 			.flags = 0,
 			.len = 1,
-			.buf = out_buf,
+			.buf = &out,
 		},
 		{
 			.addr = 0x50,
@@ -63,6 +63,47 @@ bool radeon_ddc_probe(struct radeon_connector *radeon_connector)
 	return false;
 }
 
+/*
+ * Probe EDID header information via I2C:
+ * Try to fetch EDID information by calling i2c_transfer driver function and
+ * probe for a valid EDID header
+ */
+bool radeon_ddc_probe_extended(struct radeon_connector *radeon_connector)
+{
+	u8 out = 0x0;
+	u8 block[8];
+	int ret;
+	struct i2c_msg msgs[] = {
+		{
+			.addr	= 0x50,
+			.flags	= 0,
+			.len	= 1,
+			.buf	= &out,
+		}, {
+			.addr	= 0x50,
+			.flags	= I2C_M_RD,
+			.len	= 8,
+			.buf	= block,
+		}
+	};
+
+	/* on hw with routers, select right port */
+	if (radeon_connector->router.ddc_valid)
+		radeon_router_select_ddc_port(radeon_connector);
+
+	ret = i2c_transfer(&radeon_connector->ddc_bus->adapter, msgs, 2);
+	if (ret == 2)
+		if (drm_edid_header_is_valid(block) >= 6)
+			/* EDID header starts with:
+			 * 0x00,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x00
+			 * Only the first 6 bytes must be valid as
+			 * drm_edid_block_valid() can fix the last 2 bytes
+			 */
+			return true;
+	/* Couldn't find an accessible EDID on this connector */
+	return false;
+}
+
 /* bit banging i2c */
 
 static void radeon_i2c_do_lock(struct radeon_i2c_chan *i2c, int lock_state)
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
index 6df4e3c..b834f27 100644
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
@@ -515,6 +518,7 @@ extern void radeon_i2c_put_byte(struct radeon_i2c_chan *i2c,
 extern void radeon_router_select_ddc_port(struct radeon_connector *radeon_connector);
 extern void radeon_router_select_cd_port(struct radeon_connector *radeon_connector);
 extern bool radeon_ddc_probe(struct radeon_connector *radeon_connector);
+extern bool radeon_ddc_probe_extended(struct radeon_connector *radeon_connector);
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

